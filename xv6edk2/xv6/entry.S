#include "asm.h"
#include "memlayout.h"
#include "mmu.h"
#include "param.h"

.p2align 2
.text
.globl multiboot_header
multiboot_header:
  #define magic 0x1badb002
  #define flags 0
  .long magic
  .long flags
  .long (-magic-flags)

# _start는 엔트리의 물리 주소를 가리킵니다.
.globl _start
_start = V2P_WO(entry)

.globl entry
entry:
  # 1. 4MB 페이지 기능 활성화 (PSE)
  movl    %cr4, %eax
  orl     $(CR4_PSE), %eax
  movl    %eax, %cr4

  # 2. 페이지 테이블 주소 등록
  movl    $(V2P_WO(entrypgdir)), %eax
  movl    %eax, %cr3

  # 3. 페이징 및 쓰기 방지 활성화
  movl    %cr0, %eax
  orl     $0x80010001, %eax
  movl    %eax, %cr0

  # 4. 커널 스택 설정
  movl $(stack + KSTACKSIZE), %esp

  # 5. main()으로 점프 (간접 점프)
  movl $main, %eax
  jmp *%eax

.comm stack, KSTACKSIZE