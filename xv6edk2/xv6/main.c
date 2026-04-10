#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "mp_uefi.h"
#include "debug.h"
#include "graphic.h"
#include "font.h"
#include "pci.h"
#include "i8254.h"
#include "arp.h"

static void startothers(void);
static void mpmain(void)  __attribute__((noreturn));
extern pde_t *kpgdir;
extern char end[]; // first address after kernel loaded from ELF file

// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  // graphic_init(); // 화면 출력을 위한 그래픽 시스템
  kinit1(end, P2V(4*1024*1024)); // phys page allocator 커널이 사용할 수 있는 물리 메모리의 첫 4MB를 할당할 준비를 합니다.
  kvmalloc();      // kernel page table // 가상 메모리 주소를 물리 메모리 주소로 변환할 **커널 페이지 테이블(지도)**을 만듭니다.
  mpinit_uefi(); // 다중 코어(멀티프로세서) 환경을 UEFI 방식에 맞게 파악합니다. CPU가 몇 개인지 확인하는 작업이죠.
  lapicinit();     // interrupt controller 키보드나 마우스 등 외부에서 들어오는 신호(인터럽트)를 CPU가 받을 수 있도록 컨트롤러를 켭니다.
  seginit();       // segment descriptors 메모리 보호 구역(세그먼트)을 설정하고, 오류나 시스템 콜이 발생했을 때 어디로 가야 할지(트랩 벡터)를 설정합니다.
  picinit();    // disable pic
  ioapicinit();    // another interrupt controller 키보드나 마우스 등 외부에서 들어오는 신호(인터럽트)를 CPU가 받을 수 있도록 컨트롤러를 켭니다.
  consoleinit();   // console hardware 화면에 글자를 찍고(콘솔), 시리얼 통신을 할 준비를 합니다.
  uartinit();      // serial port 화면에 글자를 찍고(콘솔), 시리얼 통신을 할 준비를 합니다.
  pinit();         // process table 프로세스 장부(프로세스 테이블)를 초기화합니다.
  tvinit();        // trap vectors 메모리 보호 구역(세그먼트)을 설정하고, 오류나 시스템 콜이 발생했을 때 어디로 가야 할지(트랩 벡터)를 설정합니다.
  binit();         // buffer cache 하드디스크(IDE)를 읽고 쓸 준비를 하고, 파일 시스템과 버퍼를 세팅합니다.
  fileinit();      // file table 하드디스크(IDE)를 읽고 쓸 준비를 하고, 파일 시스템과 버퍼를 세팅합니다.
  ideinit();       // disk  하드디스크(IDE)를 읽고 쓸 준비를 하고, 파일 시스템과 버퍼를 세팅합니다.
  startothers();   // start other processors 잠들어 있는 나머지 CPU들을 깨웁니다. (자세한 건 아래 2번에서 설명할게요)
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers() 처음 4MB 이후의 나머지 모든 물리 메모리를 운영체제가 사용할 수 있도록 마저 할당합니다.
  // pci_init(); // 추가된 네트워크 및 하드웨어 장치를 스캔합니다 
  // arp_scan(); // 추가된 네트워크 및 하드웨어 장치를 스캔합니다.
  //i8254_recv();
  userinit();      // first user process 드디어 대망의 첫 번째 유저 프로그램(보통 init 프로세스)을 메모리에 만듭니다.

  mpmain();        // finish this processor's setup 준비를 마치고 스케줄러를 가동하여 프로세스들을 실행하기 시작합니다.
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void) // 서브 CPU들의 출근 완료 보고
{
  switchkvm();
  seginit();
  lapicinit();
  mpmain();
}

// Common CPU setup code.
static void
mpmain(void) //서브 CPU들의 출근 완료 보고
{
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
  idtinit();       // load idt register
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
  scheduler();     // start running processes
}

pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
  extern uchar _binary_entryother_start[], _binary_entryother_size[];
  uchar *code;
  struct cpu *c;
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == mycpu()){  // We've started already.
      continue;
    }
    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}

// The boot page table used in entry.S and entryother.S.
// Page directories (and page tables) must start on page boundaries,
// hence the __aligned__ attribute.
// PTE_PS in a page directory entry enables 4Mbyte pages.

__attribute__((__aligned__(PGSIZE)))
pde_t entrypgdir[NPDENTRIES] = {
  // Map VA's [0, 4MB) to PA's [0, 4MB)
  [0] = (0) | PTE_P | PTE_W | PTE_PS,
  // Map VA's [KERNBASE, KERNBASE+4MB) to PA's [0, 4MB)
  [KERNBASE>>PDXSHIFT] = (0) | PTE_P | PTE_W | PTE_PS,
};

//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.

