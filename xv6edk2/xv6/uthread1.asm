
_uthread1:     file format elf32-i386


Disassembly of section .text:

00000000 <dummy_padding_function>:
thread_p  current_thread;
thread_p  next_thread;
extern void thread_switch(void);

//더미 데이터 추가
void dummy_padding_function(void) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 10             	sub    $0x10,%esp
    int a = 0;
   6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    a++;
   d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}
  11:	90                   	nop
  12:	c9                   	leave
  13:	c3                   	ret

00000014 <thread_schedule>:

static void 
thread_schedule(void)
{
  14:	55                   	push   %ebp
  15:	89 e5                	mov    %esp,%ebp
  17:	83 ec 18             	sub    $0x18,%esp
  thread_p t;

  /* Find another runnable thread. */
  next_thread = 0;
  1a:	c7 05 a4 0d 00 00 00 	movl   $0x0,0xda4
  21:	00 00 00 
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  24:	c7 45 f4 c0 0d 00 00 	movl   $0xdc0,-0xc(%ebp)
  2b:	eb 29                	jmp    56 <thread_schedule+0x42>
    if (t->state == RUNNABLE && t != current_thread) {
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  36:	83 f8 02             	cmp    $0x2,%eax
  39:	75 14                	jne    4f <thread_schedule+0x3b>
  3b:	a1 a0 0d 00 00       	mov    0xda0,%eax
  40:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  43:	74 0a                	je     4f <thread_schedule+0x3b>
      next_thread = t;
  45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  48:	a3 a4 0d 00 00       	mov    %eax,0xda4
      break;
  4d:	eb 11                	jmp    60 <thread_schedule+0x4c>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  4f:	81 45 f4 08 20 00 00 	addl   $0x2008,-0xc(%ebp)
  56:	b8 e0 8d 00 00       	mov    $0x8de0,%eax
  5b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  5e:	72 cd                	jb     2d <thread_schedule+0x19>
    }
  }

  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
  60:	b8 e0 8d 00 00       	mov    $0x8de0,%eax
  65:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  68:	72 1a                	jb     84 <thread_schedule+0x70>
  6a:	a1 a0 0d 00 00       	mov    0xda0,%eax
  6f:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  75:	83 f8 02             	cmp    $0x2,%eax
  78:	75 0a                	jne    84 <thread_schedule+0x70>
    /* The current thread is the only runnable thread; run it. */
    next_thread = current_thread;
  7a:	a1 a0 0d 00 00       	mov    0xda0,%eax
  7f:	a3 a4 0d 00 00       	mov    %eax,0xda4
  }

  if (next_thread == 0) {
  84:	a1 a4 0d 00 00       	mov    0xda4,%eax
  89:	85 c0                	test   %eax,%eax
  8b:	75 17                	jne    a4 <thread_schedule+0x90>
    printf(2, "thread_schedule: no runnable threads\n");
  8d:	83 ec 08             	sub    $0x8,%esp
  90:	68 3c 0a 00 00       	push   $0xa3c
  95:	6a 02                	push   $0x2
  97:	e8 e6 05 00 00       	call   682 <printf>
  9c:	83 c4 10             	add    $0x10,%esp
    exit();
  9f:	e8 52 04 00 00       	call   4f6 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  a4:	8b 15 a0 0d 00 00    	mov    0xda0,%edx
  aa:	a1 a4 0d 00 00       	mov    0xda4,%eax
  af:	39 c2                	cmp    %eax,%edx
  b1:	74 40                	je     f3 <thread_schedule+0xdf>
    next_thread->state = RUNNING;
  b3:	a1 a4 0d 00 00       	mov    0xda4,%eax
  b8:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
  bf:	00 00 00 

    // [추가된 코드] 현재 쓰레드가 완전히 죽은 상태(FREE)가 아닐 때만 RUNNABLE로 강등
    if (current_thread->state != FREE && current_thread != &all_thread[0]) {
  c2:	a1 a0 0d 00 00       	mov    0xda0,%eax
  c7:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  cd:	85 c0                	test   %eax,%eax
  cf:	74 1b                	je     ec <thread_schedule+0xd8>
  d1:	a1 a0 0d 00 00       	mov    0xda0,%eax
  d6:	3d c0 0d 00 00       	cmp    $0xdc0,%eax
  db:	74 0f                	je     ec <thread_schedule+0xd8>
        current_thread->state = RUNNABLE;
  dd:	a1 a0 0d 00 00       	mov    0xda0,%eax
  e2:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
  e9:	00 00 00 
    }

    thread_switch();
  ec:	e8 98 01 00 00       	call   289 <thread_switch>
  } else
    next_thread = 0;
}
  f1:	eb 0a                	jmp    fd <thread_schedule+0xe9>
    next_thread = 0;
  f3:	c7 05 a4 0d 00 00 00 	movl   $0x0,0xda4
  fa:	00 00 00 
}
  fd:	90                   	nop
  fe:	c9                   	leave
  ff:	c3                   	ret

00000100 <thread_init>:

void 
thread_init(void)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	83 ec 08             	sub    $0x8,%esp
  uthread_init(thread_schedule);
 106:	83 ec 0c             	sub    $0xc,%esp
 109:	68 14 00 00 00       	push   $0x14
 10e:	e8 93 04 00 00       	call   5a6 <uthread_init>
 113:	83 c4 10             	add    $0x10,%esp
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
 116:	c7 05 a0 0d 00 00 c0 	movl   $0xdc0,0xda0
 11d:	0d 00 00 
  current_thread->state = RUNNING;
 120:	a1 a0 0d 00 00       	mov    0xda0,%eax
 125:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
 12c:	00 00 00 
}
 12f:	90                   	nop
 130:	c9                   	leave
 131:	c3                   	ret

00000132 <thread_create>:

void 
thread_create(void (*func)())
{
 132:	55                   	push   %ebp
 133:	89 e5                	mov    %esp,%ebp
 135:	83 ec 10             	sub    $0x10,%esp
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 138:	c7 45 fc c0 0d 00 00 	movl   $0xdc0,-0x4(%ebp)
 13f:	eb 14                	jmp    155 <thread_create+0x23>
    if (t->state == FREE) break;
 141:	8b 45 fc             	mov    -0x4(%ebp),%eax
 144:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
 14a:	85 c0                	test   %eax,%eax
 14c:	74 13                	je     161 <thread_create+0x2f>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 14e:	81 45 fc 08 20 00 00 	addl   $0x2008,-0x4(%ebp)
 155:	b8 e0 8d 00 00       	mov    $0x8de0,%eax
 15a:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 15d:	72 e2                	jb     141 <thread_create+0xf>
 15f:	eb 01                	jmp    162 <thread_create+0x30>
    if (t->state == FREE) break;
 161:	90                   	nop
  }

  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
 162:	8b 45 fc             	mov    -0x4(%ebp),%eax
 165:	83 c0 04             	add    $0x4,%eax
 168:	05 00 20 00 00       	add    $0x2000,%eax
 16d:	89 c2                	mov    %eax,%edx
 16f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 172:	89 10                	mov    %edx,(%eax)

  //[새로 추가] mythread가 끝난 뒤 돌아갈 "스케줄러 주소"를 푸시
  t->sp -= 4;                              
 174:	8b 45 fc             	mov    -0x4(%ebp),%eax
 177:	8b 00                	mov    (%eax),%eax
 179:	8d 50 fc             	lea    -0x4(%eax),%edx
 17c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 17f:	89 10                	mov    %edx,(%eax)
  * (int *) (t->sp) = (int)thread_schedule;
 181:	8b 45 fc             	mov    -0x4(%ebp),%eax
 184:	8b 00                	mov    (%eax),%eax
 186:	ba 14 00 00 00       	mov    $0x14,%edx
 18b:	89 10                	mov    %edx,(%eax)

  t->sp -= 4;                              // space for return address
 18d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 190:	8b 00                	mov    (%eax),%eax
 192:	8d 50 fc             	lea    -0x4(%eax),%edx
 195:	8b 45 fc             	mov    -0x4(%ebp),%eax
 198:	89 10                	mov    %edx,(%eax)
  * (int *) (t->sp) = (int)func;           // push return address on stack
 19a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 19d:	8b 00                	mov    (%eax),%eax
 19f:	89 c2                	mov    %eax,%edx
 1a1:	8b 45 08             	mov    0x8(%ebp),%eax
 1a4:	89 02                	mov    %eax,(%edx)
  t->sp -= 32;                             // space for registers that thread_switch expects
 1a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1a9:	8b 00                	mov    (%eax),%eax
 1ab:	8d 50 e0             	lea    -0x20(%eax),%edx
 1ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1b1:	89 10                	mov    %edx,(%eax)
  t->state = RUNNABLE;
 1b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1b6:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 1bd:	00 00 00 
}
 1c0:	90                   	nop
 1c1:	c9                   	leave
 1c2:	c3                   	ret

000001c3 <mythread>:

static void 
mythread(void)
{
 1c3:	55                   	push   %ebp
 1c4:	89 e5                	mov    %esp,%ebp
 1c6:	83 ec 18             	sub    $0x18,%esp
  int i;
  printf(1, "my thread running\n");
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	68 62 0a 00 00       	push   $0xa62
 1d1:	6a 01                	push   $0x1
 1d3:	e8 aa 04 00 00       	call   682 <printf>
 1d8:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 100; i++) {
 1db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1e2:	eb 33                	jmp    217 <mythread+0x54>
    printf(1, "my thread 0x%x\n", (int) current_thread);
 1e4:	a1 a0 0d 00 00       	mov    0xda0,%eax
 1e9:	83 ec 04             	sub    $0x4,%esp
 1ec:	50                   	push   %eax
 1ed:	68 75 0a 00 00       	push   $0xa75
 1f2:	6a 01                	push   $0x1
 1f4:	e8 89 04 00 00       	call   682 <printf>
 1f9:	83 c4 10             	add    $0x10,%esp

    for(int j = 0; j<20000000;j++){ //체류시간 늘리기
 1fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 203:	eb 05                	jmp    20a <mythread+0x47>
      asm volatile("nop");
 205:	90                   	nop
    for(int j = 0; j<20000000;j++){ //체류시간 늘리기
 206:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 20a:	81 7d f0 ff 2c 31 01 	cmpl   $0x1312cff,-0x10(%ebp)
 211:	7e f2                	jle    205 <mythread+0x42>
  for (i = 0; i < 100; i++) {
 213:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 217:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
 21b:	7e c7                	jle    1e4 <mythread+0x21>
    }
  }
  printf(1, "my thread: exit\n");
 21d:	83 ec 08             	sub    $0x8,%esp
 220:	68 85 0a 00 00       	push   $0xa85
 225:	6a 01                	push   $0x1
 227:	e8 56 04 00 00       	call   682 <printf>
 22c:	83 c4 10             	add    $0x10,%esp
  current_thread->state = FREE;
 22f:	a1 a0 0d 00 00       	mov    0xda0,%eax
 234:	c7 80 04 20 00 00 00 	movl   $0x0,0x2004(%eax)
 23b:	00 00 00 
}
 23e:	90                   	nop
 23f:	c9                   	leave
 240:	c3                   	ret

00000241 <main>:


int 
main(int argc, char *argv[]) 
{
 241:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 245:	83 e4 f0             	and    $0xfffffff0,%esp
 248:	ff 71 fc             	push   -0x4(%ecx)
 24b:	55                   	push   %ebp
 24c:	89 e5                	mov    %esp,%ebp
 24e:	51                   	push   %ecx
 24f:	83 ec 04             	sub    $0x4,%esp
  thread_init();
 252:	e8 a9 fe ff ff       	call   100 <thread_init>
  thread_create(mythread);
 257:	83 ec 0c             	sub    $0xc,%esp
 25a:	68 c3 01 00 00       	push   $0x1c3
 25f:	e8 ce fe ff ff       	call   132 <thread_create>
 264:	83 c4 10             	add    $0x10,%esp
  thread_create(mythread);
 267:	83 ec 0c             	sub    $0xc,%esp
 26a:	68 c3 01 00 00       	push   $0x1c3
 26f:	e8 be fe ff ff       	call   132 <thread_create>
 274:	83 c4 10             	add    $0x10,%esp
  thread_schedule();
 277:	e8 98 fd ff ff       	call   14 <thread_schedule>
  return 0;
 27c:	b8 00 00 00 00       	mov    $0x0,%eax
 281:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 284:	c9                   	leave
 285:	8d 61 fc             	lea    -0x4(%ecx),%esp
 288:	c3                   	ret

00000289 <thread_switch>:
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	pushal
 289:	60                   	pusha
	movl current_thread, %eax
 28a:	a1 a0 0d 00 00       	mov    0xda0,%eax
	movl %esp, (%eax)
 28f:	89 20                	mov    %esp,(%eax)

	movl next_thread, %eax
 291:	a1 a4 0d 00 00       	mov    0xda4,%eax
	movl %eax, current_thread
 296:	a3 a0 0d 00 00       	mov    %eax,0xda0

	movl (%eax), %esp
 29b:	8b 20                	mov    (%eax),%esp

	popal
 29d:	61                   	popa

	ret    /* return to ra */
 29e:	c3                   	ret

0000029f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
 2a2:	57                   	push   %edi
 2a3:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2a7:	8b 55 10             	mov    0x10(%ebp),%edx
 2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ad:	89 cb                	mov    %ecx,%ebx
 2af:	89 df                	mov    %ebx,%edi
 2b1:	89 d1                	mov    %edx,%ecx
 2b3:	fc                   	cld
 2b4:	f3 aa                	rep stos %al,%es:(%edi)
 2b6:	89 ca                	mov    %ecx,%edx
 2b8:	89 fb                	mov    %edi,%ebx
 2ba:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2bd:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2c0:	90                   	nop
 2c1:	5b                   	pop    %ebx
 2c2:	5f                   	pop    %edi
 2c3:	5d                   	pop    %ebp
 2c4:	c3                   	ret

000002c5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2c5:	55                   	push   %ebp
 2c6:	89 e5                	mov    %esp,%ebp
 2c8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2d1:	90                   	nop
 2d2:	8b 55 0c             	mov    0xc(%ebp),%edx
 2d5:	8d 42 01             	lea    0x1(%edx),%eax
 2d8:	89 45 0c             	mov    %eax,0xc(%ebp)
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	8d 48 01             	lea    0x1(%eax),%ecx
 2e1:	89 4d 08             	mov    %ecx,0x8(%ebp)
 2e4:	0f b6 12             	movzbl (%edx),%edx
 2e7:	88 10                	mov    %dl,(%eax)
 2e9:	0f b6 00             	movzbl (%eax),%eax
 2ec:	84 c0                	test   %al,%al
 2ee:	75 e2                	jne    2d2 <strcpy+0xd>
    ;
  return os;
 2f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f3:	c9                   	leave
 2f4:	c3                   	ret

000002f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f5:	55                   	push   %ebp
 2f6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2f8:	eb 08                	jmp    302 <strcmp+0xd>
    p++, q++;
 2fa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2fe:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	0f b6 00             	movzbl (%eax),%eax
 308:	84 c0                	test   %al,%al
 30a:	74 10                	je     31c <strcmp+0x27>
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
 30f:	0f b6 10             	movzbl (%eax),%edx
 312:	8b 45 0c             	mov    0xc(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	38 c2                	cmp    %al,%dl
 31a:	74 de                	je     2fa <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	0f b6 00             	movzbl (%eax),%eax
 322:	0f b6 d0             	movzbl %al,%edx
 325:	8b 45 0c             	mov    0xc(%ebp),%eax
 328:	0f b6 00             	movzbl (%eax),%eax
 32b:	0f b6 c0             	movzbl %al,%eax
 32e:	29 c2                	sub    %eax,%edx
 330:	89 d0                	mov    %edx,%eax
}
 332:	5d                   	pop    %ebp
 333:	c3                   	ret

00000334 <strlen>:

uint
strlen(char *s)
{
 334:	55                   	push   %ebp
 335:	89 e5                	mov    %esp,%ebp
 337:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 33a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 341:	eb 04                	jmp    347 <strlen+0x13>
 343:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 347:	8b 55 fc             	mov    -0x4(%ebp),%edx
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	01 d0                	add    %edx,%eax
 34f:	0f b6 00             	movzbl (%eax),%eax
 352:	84 c0                	test   %al,%al
 354:	75 ed                	jne    343 <strlen+0xf>
    ;
  return n;
 356:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 359:	c9                   	leave
 35a:	c3                   	ret

0000035b <memset>:

void*
memset(void *dst, int c, uint n)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 35e:	8b 45 10             	mov    0x10(%ebp),%eax
 361:	50                   	push   %eax
 362:	ff 75 0c             	push   0xc(%ebp)
 365:	ff 75 08             	push   0x8(%ebp)
 368:	e8 32 ff ff ff       	call   29f <stosb>
 36d:	83 c4 0c             	add    $0xc,%esp
  return dst;
 370:	8b 45 08             	mov    0x8(%ebp),%eax
}
 373:	c9                   	leave
 374:	c3                   	ret

00000375 <strchr>:

char*
strchr(const char *s, char c)
{
 375:	55                   	push   %ebp
 376:	89 e5                	mov    %esp,%ebp
 378:	83 ec 04             	sub    $0x4,%esp
 37b:	8b 45 0c             	mov    0xc(%ebp),%eax
 37e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 381:	eb 14                	jmp    397 <strchr+0x22>
    if(*s == c)
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	0f b6 00             	movzbl (%eax),%eax
 389:	38 45 fc             	cmp    %al,-0x4(%ebp)
 38c:	75 05                	jne    393 <strchr+0x1e>
      return (char*)s;
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	eb 13                	jmp    3a6 <strchr+0x31>
  for(; *s; s++)
 393:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 397:	8b 45 08             	mov    0x8(%ebp),%eax
 39a:	0f b6 00             	movzbl (%eax),%eax
 39d:	84 c0                	test   %al,%al
 39f:	75 e2                	jne    383 <strchr+0xe>
  return 0;
 3a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3a6:	c9                   	leave
 3a7:	c3                   	ret

000003a8 <gets>:

char*
gets(char *buf, int max)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3b5:	eb 42                	jmp    3f9 <gets+0x51>
    cc = read(0, &c, 1);
 3b7:	83 ec 04             	sub    $0x4,%esp
 3ba:	6a 01                	push   $0x1
 3bc:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3bf:	50                   	push   %eax
 3c0:	6a 00                	push   $0x0
 3c2:	e8 47 01 00 00       	call   50e <read>
 3c7:	83 c4 10             	add    $0x10,%esp
 3ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d1:	7e 33                	jle    406 <gets+0x5e>
      break;
    buf[i++] = c;
 3d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d6:	8d 50 01             	lea    0x1(%eax),%edx
 3d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3dc:	89 c2                	mov    %eax,%edx
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	01 c2                	add    %eax,%edx
 3e3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3e7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3e9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3ed:	3c 0a                	cmp    $0xa,%al
 3ef:	74 16                	je     407 <gets+0x5f>
 3f1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3f5:	3c 0d                	cmp    $0xd,%al
 3f7:	74 0e                	je     407 <gets+0x5f>
  for(i=0; i+1 < max; ){
 3f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fc:	83 c0 01             	add    $0x1,%eax
 3ff:	39 45 0c             	cmp    %eax,0xc(%ebp)
 402:	7f b3                	jg     3b7 <gets+0xf>
 404:	eb 01                	jmp    407 <gets+0x5f>
      break;
 406:	90                   	nop
      break;
  }
  buf[i] = '\0';
 407:	8b 55 f4             	mov    -0xc(%ebp),%edx
 40a:	8b 45 08             	mov    0x8(%ebp),%eax
 40d:	01 d0                	add    %edx,%eax
 40f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 412:	8b 45 08             	mov    0x8(%ebp),%eax
}
 415:	c9                   	leave
 416:	c3                   	ret

00000417 <stat>:

int
stat(char *n, struct stat *st)
{
 417:	55                   	push   %ebp
 418:	89 e5                	mov    %esp,%ebp
 41a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 41d:	83 ec 08             	sub    $0x8,%esp
 420:	6a 00                	push   $0x0
 422:	ff 75 08             	push   0x8(%ebp)
 425:	e8 0c 01 00 00       	call   536 <open>
 42a:	83 c4 10             	add    $0x10,%esp
 42d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 434:	79 07                	jns    43d <stat+0x26>
    return -1;
 436:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 43b:	eb 25                	jmp    462 <stat+0x4b>
  r = fstat(fd, st);
 43d:	83 ec 08             	sub    $0x8,%esp
 440:	ff 75 0c             	push   0xc(%ebp)
 443:	ff 75 f4             	push   -0xc(%ebp)
 446:	e8 03 01 00 00       	call   54e <fstat>
 44b:	83 c4 10             	add    $0x10,%esp
 44e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 451:	83 ec 0c             	sub    $0xc,%esp
 454:	ff 75 f4             	push   -0xc(%ebp)
 457:	e8 c2 00 00 00       	call   51e <close>
 45c:	83 c4 10             	add    $0x10,%esp
  return r;
 45f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 462:	c9                   	leave
 463:	c3                   	ret

00000464 <atoi>:

int
atoi(const char *s)
{
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 46a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 471:	eb 25                	jmp    498 <atoi+0x34>
    n = n*10 + *s++ - '0';
 473:	8b 55 fc             	mov    -0x4(%ebp),%edx
 476:	89 d0                	mov    %edx,%eax
 478:	c1 e0 02             	shl    $0x2,%eax
 47b:	01 d0                	add    %edx,%eax
 47d:	01 c0                	add    %eax,%eax
 47f:	89 c1                	mov    %eax,%ecx
 481:	8b 45 08             	mov    0x8(%ebp),%eax
 484:	8d 50 01             	lea    0x1(%eax),%edx
 487:	89 55 08             	mov    %edx,0x8(%ebp)
 48a:	0f b6 00             	movzbl (%eax),%eax
 48d:	0f be c0             	movsbl %al,%eax
 490:	01 c8                	add    %ecx,%eax
 492:	83 e8 30             	sub    $0x30,%eax
 495:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 498:	8b 45 08             	mov    0x8(%ebp),%eax
 49b:	0f b6 00             	movzbl (%eax),%eax
 49e:	3c 2f                	cmp    $0x2f,%al
 4a0:	7e 0a                	jle    4ac <atoi+0x48>
 4a2:	8b 45 08             	mov    0x8(%ebp),%eax
 4a5:	0f b6 00             	movzbl (%eax),%eax
 4a8:	3c 39                	cmp    $0x39,%al
 4aa:	7e c7                	jle    473 <atoi+0xf>
  return n;
 4ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4af:	c9                   	leave
 4b0:	c3                   	ret

000004b1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4b1:	55                   	push   %ebp
 4b2:	89 e5                	mov    %esp,%ebp
 4b4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 4b7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4c3:	eb 17                	jmp    4dc <memmove+0x2b>
    *dst++ = *src++;
 4c5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4c8:	8d 42 01             	lea    0x1(%edx),%eax
 4cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
 4ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4d1:	8d 48 01             	lea    0x1(%eax),%ecx
 4d4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 4d7:	0f b6 12             	movzbl (%edx),%edx
 4da:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 4dc:	8b 45 10             	mov    0x10(%ebp),%eax
 4df:	8d 50 ff             	lea    -0x1(%eax),%edx
 4e2:	89 55 10             	mov    %edx,0x10(%ebp)
 4e5:	85 c0                	test   %eax,%eax
 4e7:	7f dc                	jg     4c5 <memmove+0x14>
  return vdst;
 4e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ec:	c9                   	leave
 4ed:	c3                   	ret

000004ee <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ee:	b8 01 00 00 00       	mov    $0x1,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret

000004f6 <exit>:
SYSCALL(exit)
 4f6:	b8 02 00 00 00       	mov    $0x2,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret

000004fe <wait>:
SYSCALL(wait)
 4fe:	b8 03 00 00 00       	mov    $0x3,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret

00000506 <pipe>:
SYSCALL(pipe)
 506:	b8 04 00 00 00       	mov    $0x4,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret

0000050e <read>:
SYSCALL(read)
 50e:	b8 05 00 00 00       	mov    $0x5,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret

00000516 <write>:
SYSCALL(write)
 516:	b8 10 00 00 00       	mov    $0x10,%eax
 51b:	cd 40                	int    $0x40
 51d:	c3                   	ret

0000051e <close>:
SYSCALL(close)
 51e:	b8 15 00 00 00       	mov    $0x15,%eax
 523:	cd 40                	int    $0x40
 525:	c3                   	ret

00000526 <kill>:
SYSCALL(kill)
 526:	b8 06 00 00 00       	mov    $0x6,%eax
 52b:	cd 40                	int    $0x40
 52d:	c3                   	ret

0000052e <exec>:
SYSCALL(exec)
 52e:	b8 07 00 00 00       	mov    $0x7,%eax
 533:	cd 40                	int    $0x40
 535:	c3                   	ret

00000536 <open>:
SYSCALL(open)
 536:	b8 0f 00 00 00       	mov    $0xf,%eax
 53b:	cd 40                	int    $0x40
 53d:	c3                   	ret

0000053e <mknod>:
SYSCALL(mknod)
 53e:	b8 11 00 00 00       	mov    $0x11,%eax
 543:	cd 40                	int    $0x40
 545:	c3                   	ret

00000546 <unlink>:
SYSCALL(unlink)
 546:	b8 12 00 00 00       	mov    $0x12,%eax
 54b:	cd 40                	int    $0x40
 54d:	c3                   	ret

0000054e <fstat>:
SYSCALL(fstat)
 54e:	b8 08 00 00 00       	mov    $0x8,%eax
 553:	cd 40                	int    $0x40
 555:	c3                   	ret

00000556 <link>:
SYSCALL(link)
 556:	b8 13 00 00 00       	mov    $0x13,%eax
 55b:	cd 40                	int    $0x40
 55d:	c3                   	ret

0000055e <mkdir>:
SYSCALL(mkdir)
 55e:	b8 14 00 00 00       	mov    $0x14,%eax
 563:	cd 40                	int    $0x40
 565:	c3                   	ret

00000566 <chdir>:
SYSCALL(chdir)
 566:	b8 09 00 00 00       	mov    $0x9,%eax
 56b:	cd 40                	int    $0x40
 56d:	c3                   	ret

0000056e <dup>:
SYSCALL(dup)
 56e:	b8 0a 00 00 00       	mov    $0xa,%eax
 573:	cd 40                	int    $0x40
 575:	c3                   	ret

00000576 <getpid>:
SYSCALL(getpid)
 576:	b8 0b 00 00 00       	mov    $0xb,%eax
 57b:	cd 40                	int    $0x40
 57d:	c3                   	ret

0000057e <sbrk>:
SYSCALL(sbrk)
 57e:	b8 0c 00 00 00       	mov    $0xc,%eax
 583:	cd 40                	int    $0x40
 585:	c3                   	ret

00000586 <sleep>:
SYSCALL(sleep)
 586:	b8 0d 00 00 00       	mov    $0xd,%eax
 58b:	cd 40                	int    $0x40
 58d:	c3                   	ret

0000058e <uptime>:
SYSCALL(uptime)
 58e:	b8 0e 00 00 00       	mov    $0xe,%eax
 593:	cd 40                	int    $0x40
 595:	c3                   	ret

00000596 <wait2>:
SYSCALL(wait2)
 596:	b8 17 00 00 00       	mov    $0x17,%eax
 59b:	cd 40                	int    $0x40
 59d:	c3                   	ret

0000059e <exit2>:
SYSCALL(exit2)
 59e:	b8 16 00 00 00       	mov    $0x16,%eax
 5a3:	cd 40                	int    $0x40
 5a5:	c3                   	ret

000005a6 <uthread_init>:
 5a6:	b8 18 00 00 00       	mov    $0x18,%eax
 5ab:	cd 40                	int    $0x40
 5ad:	c3                   	ret

000005ae <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5ae:	55                   	push   %ebp
 5af:	89 e5                	mov    %esp,%ebp
 5b1:	83 ec 18             	sub    $0x18,%esp
 5b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5ba:	83 ec 04             	sub    $0x4,%esp
 5bd:	6a 01                	push   $0x1
 5bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5c2:	50                   	push   %eax
 5c3:	ff 75 08             	push   0x8(%ebp)
 5c6:	e8 4b ff ff ff       	call   516 <write>
 5cb:	83 c4 10             	add    $0x10,%esp
}
 5ce:	90                   	nop
 5cf:	c9                   	leave
 5d0:	c3                   	ret

000005d1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d1:	55                   	push   %ebp
 5d2:	89 e5                	mov    %esp,%ebp
 5d4:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5de:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5e2:	74 17                	je     5fb <printint+0x2a>
 5e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5e8:	79 11                	jns    5fb <printint+0x2a>
    neg = 1;
 5ea:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f4:	f7 d8                	neg    %eax
 5f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5f9:	eb 06                	jmp    601 <printint+0x30>
  } else {
    x = xx;
 5fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 601:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 608:	8b 4d 10             	mov    0x10(%ebp),%ecx
 60b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 60e:	ba 00 00 00 00       	mov    $0x0,%edx
 613:	f7 f1                	div    %ecx
 615:	89 d1                	mov    %edx,%ecx
 617:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61a:	8d 50 01             	lea    0x1(%eax),%edx
 61d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 620:	0f b6 91 8c 0d 00 00 	movzbl 0xd8c(%ecx),%edx
 627:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 62b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 62e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 631:	ba 00 00 00 00       	mov    $0x0,%edx
 636:	f7 f1                	div    %ecx
 638:	89 45 ec             	mov    %eax,-0x14(%ebp)
 63b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 63f:	75 c7                	jne    608 <printint+0x37>
  if(neg)
 641:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 645:	74 2d                	je     674 <printint+0xa3>
    buf[i++] = '-';
 647:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64a:	8d 50 01             	lea    0x1(%eax),%edx
 64d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 650:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 655:	eb 1d                	jmp    674 <printint+0xa3>
    putc(fd, buf[i]);
 657:	8d 55 dc             	lea    -0x24(%ebp),%edx
 65a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65d:	01 d0                	add    %edx,%eax
 65f:	0f b6 00             	movzbl (%eax),%eax
 662:	0f be c0             	movsbl %al,%eax
 665:	83 ec 08             	sub    $0x8,%esp
 668:	50                   	push   %eax
 669:	ff 75 08             	push   0x8(%ebp)
 66c:	e8 3d ff ff ff       	call   5ae <putc>
 671:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 674:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 67c:	79 d9                	jns    657 <printint+0x86>
}
 67e:	90                   	nop
 67f:	90                   	nop
 680:	c9                   	leave
 681:	c3                   	ret

00000682 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 682:	55                   	push   %ebp
 683:	89 e5                	mov    %esp,%ebp
 685:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 688:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 68f:	8d 45 0c             	lea    0xc(%ebp),%eax
 692:	83 c0 04             	add    $0x4,%eax
 695:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 698:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 69f:	e9 59 01 00 00       	jmp    7fd <printf+0x17b>
    c = fmt[i] & 0xff;
 6a4:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6aa:	01 d0                	add    %edx,%eax
 6ac:	0f b6 00             	movzbl (%eax),%eax
 6af:	0f be c0             	movsbl %al,%eax
 6b2:	25 ff 00 00 00       	and    $0xff,%eax
 6b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6be:	75 2c                	jne    6ec <printf+0x6a>
      if(c == '%'){
 6c0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6c4:	75 0c                	jne    6d2 <printf+0x50>
        state = '%';
 6c6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6cd:	e9 27 01 00 00       	jmp    7f9 <printf+0x177>
      } else {
        putc(fd, c);
 6d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d5:	0f be c0             	movsbl %al,%eax
 6d8:	83 ec 08             	sub    $0x8,%esp
 6db:	50                   	push   %eax
 6dc:	ff 75 08             	push   0x8(%ebp)
 6df:	e8 ca fe ff ff       	call   5ae <putc>
 6e4:	83 c4 10             	add    $0x10,%esp
 6e7:	e9 0d 01 00 00       	jmp    7f9 <printf+0x177>
      }
    } else if(state == '%'){
 6ec:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6f0:	0f 85 03 01 00 00    	jne    7f9 <printf+0x177>
      if(c == 'd'){
 6f6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6fa:	75 1e                	jne    71a <printf+0x98>
        printint(fd, *ap, 10, 1);
 6fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ff:	8b 00                	mov    (%eax),%eax
 701:	6a 01                	push   $0x1
 703:	6a 0a                	push   $0xa
 705:	50                   	push   %eax
 706:	ff 75 08             	push   0x8(%ebp)
 709:	e8 c3 fe ff ff       	call   5d1 <printint>
 70e:	83 c4 10             	add    $0x10,%esp
        ap++;
 711:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 715:	e9 d8 00 00 00       	jmp    7f2 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 71a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 71e:	74 06                	je     726 <printf+0xa4>
 720:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 724:	75 1e                	jne    744 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 726:	8b 45 e8             	mov    -0x18(%ebp),%eax
 729:	8b 00                	mov    (%eax),%eax
 72b:	6a 00                	push   $0x0
 72d:	6a 10                	push   $0x10
 72f:	50                   	push   %eax
 730:	ff 75 08             	push   0x8(%ebp)
 733:	e8 99 fe ff ff       	call   5d1 <printint>
 738:	83 c4 10             	add    $0x10,%esp
        ap++;
 73b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 73f:	e9 ae 00 00 00       	jmp    7f2 <printf+0x170>
      } else if(c == 's'){
 744:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 748:	75 43                	jne    78d <printf+0x10b>
        s = (char*)*ap;
 74a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 752:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 756:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 75a:	75 25                	jne    781 <printf+0xff>
          s = "(null)";
 75c:	c7 45 f4 96 0a 00 00 	movl   $0xa96,-0xc(%ebp)
        while(*s != 0){
 763:	eb 1c                	jmp    781 <printf+0xff>
          putc(fd, *s);
 765:	8b 45 f4             	mov    -0xc(%ebp),%eax
 768:	0f b6 00             	movzbl (%eax),%eax
 76b:	0f be c0             	movsbl %al,%eax
 76e:	83 ec 08             	sub    $0x8,%esp
 771:	50                   	push   %eax
 772:	ff 75 08             	push   0x8(%ebp)
 775:	e8 34 fe ff ff       	call   5ae <putc>
 77a:	83 c4 10             	add    $0x10,%esp
          s++;
 77d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 781:	8b 45 f4             	mov    -0xc(%ebp),%eax
 784:	0f b6 00             	movzbl (%eax),%eax
 787:	84 c0                	test   %al,%al
 789:	75 da                	jne    765 <printf+0xe3>
 78b:	eb 65                	jmp    7f2 <printf+0x170>
        }
      } else if(c == 'c'){
 78d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 791:	75 1d                	jne    7b0 <printf+0x12e>
        putc(fd, *ap);
 793:	8b 45 e8             	mov    -0x18(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	0f be c0             	movsbl %al,%eax
 79b:	83 ec 08             	sub    $0x8,%esp
 79e:	50                   	push   %eax
 79f:	ff 75 08             	push   0x8(%ebp)
 7a2:	e8 07 fe ff ff       	call   5ae <putc>
 7a7:	83 c4 10             	add    $0x10,%esp
        ap++;
 7aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ae:	eb 42                	jmp    7f2 <printf+0x170>
      } else if(c == '%'){
 7b0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7b4:	75 17                	jne    7cd <printf+0x14b>
        putc(fd, c);
 7b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b9:	0f be c0             	movsbl %al,%eax
 7bc:	83 ec 08             	sub    $0x8,%esp
 7bf:	50                   	push   %eax
 7c0:	ff 75 08             	push   0x8(%ebp)
 7c3:	e8 e6 fd ff ff       	call   5ae <putc>
 7c8:	83 c4 10             	add    $0x10,%esp
 7cb:	eb 25                	jmp    7f2 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7cd:	83 ec 08             	sub    $0x8,%esp
 7d0:	6a 25                	push   $0x25
 7d2:	ff 75 08             	push   0x8(%ebp)
 7d5:	e8 d4 fd ff ff       	call   5ae <putc>
 7da:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7e0:	0f be c0             	movsbl %al,%eax
 7e3:	83 ec 08             	sub    $0x8,%esp
 7e6:	50                   	push   %eax
 7e7:	ff 75 08             	push   0x8(%ebp)
 7ea:	e8 bf fd ff ff       	call   5ae <putc>
 7ef:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 7f9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7fd:	8b 55 0c             	mov    0xc(%ebp),%edx
 800:	8b 45 f0             	mov    -0x10(%ebp),%eax
 803:	01 d0                	add    %edx,%eax
 805:	0f b6 00             	movzbl (%eax),%eax
 808:	84 c0                	test   %al,%al
 80a:	0f 85 94 fe ff ff    	jne    6a4 <printf+0x22>
    }
  }
}
 810:	90                   	nop
 811:	90                   	nop
 812:	c9                   	leave
 813:	c3                   	ret

00000814 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 814:	55                   	push   %ebp
 815:	89 e5                	mov    %esp,%ebp
 817:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81a:	8b 45 08             	mov    0x8(%ebp),%eax
 81d:	83 e8 08             	sub    $0x8,%eax
 820:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 823:	a1 e8 8d 00 00       	mov    0x8de8,%eax
 828:	89 45 fc             	mov    %eax,-0x4(%ebp)
 82b:	eb 24                	jmp    851 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 835:	72 12                	jb     849 <free+0x35>
 837:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83a:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 83d:	72 24                	jb     863 <free+0x4f>
 83f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 842:	8b 00                	mov    (%eax),%eax
 844:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 847:	72 1a                	jb     863 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 849:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84c:	8b 00                	mov    (%eax),%eax
 84e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 851:	8b 45 f8             	mov    -0x8(%ebp),%eax
 854:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 857:	73 d4                	jae    82d <free+0x19>
 859:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85c:	8b 00                	mov    (%eax),%eax
 85e:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 861:	73 ca                	jae    82d <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 863:	8b 45 f8             	mov    -0x8(%ebp),%eax
 866:	8b 40 04             	mov    0x4(%eax),%eax
 869:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 870:	8b 45 f8             	mov    -0x8(%ebp),%eax
 873:	01 c2                	add    %eax,%edx
 875:	8b 45 fc             	mov    -0x4(%ebp),%eax
 878:	8b 00                	mov    (%eax),%eax
 87a:	39 c2                	cmp    %eax,%edx
 87c:	75 24                	jne    8a2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 87e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 881:	8b 50 04             	mov    0x4(%eax),%edx
 884:	8b 45 fc             	mov    -0x4(%ebp),%eax
 887:	8b 00                	mov    (%eax),%eax
 889:	8b 40 04             	mov    0x4(%eax),%eax
 88c:	01 c2                	add    %eax,%edx
 88e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 891:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 894:	8b 45 fc             	mov    -0x4(%ebp),%eax
 897:	8b 00                	mov    (%eax),%eax
 899:	8b 10                	mov    (%eax),%edx
 89b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89e:	89 10                	mov    %edx,(%eax)
 8a0:	eb 0a                	jmp    8ac <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a5:	8b 10                	mov    (%eax),%edx
 8a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8aa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8af:	8b 40 04             	mov    0x4(%eax),%eax
 8b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bc:	01 d0                	add    %edx,%eax
 8be:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8c1:	75 20                	jne    8e3 <free+0xcf>
    p->s.size += bp->s.size;
 8c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c6:	8b 50 04             	mov    0x4(%eax),%edx
 8c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cc:	8b 40 04             	mov    0x4(%eax),%eax
 8cf:	01 c2                	add    %eax,%edx
 8d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8da:	8b 10                	mov    (%eax),%edx
 8dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8df:	89 10                	mov    %edx,(%eax)
 8e1:	eb 08                	jmp    8eb <free+0xd7>
  } else
    p->s.ptr = bp;
 8e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8e9:	89 10                	mov    %edx,(%eax)
  freep = p;
 8eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ee:	a3 e8 8d 00 00       	mov    %eax,0x8de8
}
 8f3:	90                   	nop
 8f4:	c9                   	leave
 8f5:	c3                   	ret

000008f6 <morecore>:

static Header*
morecore(uint nu)
{
 8f6:	55                   	push   %ebp
 8f7:	89 e5                	mov    %esp,%ebp
 8f9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8fc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 903:	77 07                	ja     90c <morecore+0x16>
    nu = 4096;
 905:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 90c:	8b 45 08             	mov    0x8(%ebp),%eax
 90f:	c1 e0 03             	shl    $0x3,%eax
 912:	83 ec 0c             	sub    $0xc,%esp
 915:	50                   	push   %eax
 916:	e8 63 fc ff ff       	call   57e <sbrk>
 91b:	83 c4 10             	add    $0x10,%esp
 91e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 921:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 925:	75 07                	jne    92e <morecore+0x38>
    return 0;
 927:	b8 00 00 00 00       	mov    $0x0,%eax
 92c:	eb 26                	jmp    954 <morecore+0x5e>
  hp = (Header*)p;
 92e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 931:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 934:	8b 45 f0             	mov    -0x10(%ebp),%eax
 937:	8b 55 08             	mov    0x8(%ebp),%edx
 93a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 93d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 940:	83 c0 08             	add    $0x8,%eax
 943:	83 ec 0c             	sub    $0xc,%esp
 946:	50                   	push   %eax
 947:	e8 c8 fe ff ff       	call   814 <free>
 94c:	83 c4 10             	add    $0x10,%esp
  return freep;
 94f:	a1 e8 8d 00 00       	mov    0x8de8,%eax
}
 954:	c9                   	leave
 955:	c3                   	ret

00000956 <malloc>:

void*
malloc(uint nbytes)
{
 956:	55                   	push   %ebp
 957:	89 e5                	mov    %esp,%ebp
 959:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 95c:	8b 45 08             	mov    0x8(%ebp),%eax
 95f:	83 c0 07             	add    $0x7,%eax
 962:	c1 e8 03             	shr    $0x3,%eax
 965:	83 c0 01             	add    $0x1,%eax
 968:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 96b:	a1 e8 8d 00 00       	mov    0x8de8,%eax
 970:	89 45 f0             	mov    %eax,-0x10(%ebp)
 973:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 977:	75 23                	jne    99c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 979:	c7 45 f0 e0 8d 00 00 	movl   $0x8de0,-0x10(%ebp)
 980:	8b 45 f0             	mov    -0x10(%ebp),%eax
 983:	a3 e8 8d 00 00       	mov    %eax,0x8de8
 988:	a1 e8 8d 00 00       	mov    0x8de8,%eax
 98d:	a3 e0 8d 00 00       	mov    %eax,0x8de0
    base.s.size = 0;
 992:	c7 05 e4 8d 00 00 00 	movl   $0x0,0x8de4
 999:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99f:	8b 00                	mov    (%eax),%eax
 9a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a7:	8b 40 04             	mov    0x4(%eax),%eax
 9aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9ad:	72 4d                	jb     9fc <malloc+0xa6>
      if(p->s.size == nunits)
 9af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b2:	8b 40 04             	mov    0x4(%eax),%eax
 9b5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 9b8:	75 0c                	jne    9c6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bd:	8b 10                	mov    (%eax),%edx
 9bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c2:	89 10                	mov    %edx,(%eax)
 9c4:	eb 26                	jmp    9ec <malloc+0x96>
      else {
        p->s.size -= nunits;
 9c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c9:	8b 40 04             	mov    0x4(%eax),%eax
 9cc:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9cf:	89 c2                	mov    %eax,%edx
 9d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9da:	8b 40 04             	mov    0x4(%eax),%eax
 9dd:	c1 e0 03             	shl    $0x3,%eax
 9e0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9e9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ef:	a3 e8 8d 00 00       	mov    %eax,0x8de8
      return (void*)(p + 1);
 9f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f7:	83 c0 08             	add    $0x8,%eax
 9fa:	eb 3b                	jmp    a37 <malloc+0xe1>
    }
    if(p == freep)
 9fc:	a1 e8 8d 00 00       	mov    0x8de8,%eax
 a01:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a04:	75 1e                	jne    a24 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a06:	83 ec 0c             	sub    $0xc,%esp
 a09:	ff 75 ec             	push   -0x14(%ebp)
 a0c:	e8 e5 fe ff ff       	call   8f6 <morecore>
 a11:	83 c4 10             	add    $0x10,%esp
 a14:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a1b:	75 07                	jne    a24 <malloc+0xce>
        return 0;
 a1d:	b8 00 00 00 00       	mov    $0x0,%eax
 a22:	eb 13                	jmp    a37 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a27:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2d:	8b 00                	mov    (%eax),%eax
 a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a32:	e9 6d ff ff ff       	jmp    9a4 <malloc+0x4e>
  }
}
 a37:	c9                   	leave
 a38:	c3                   	ret
