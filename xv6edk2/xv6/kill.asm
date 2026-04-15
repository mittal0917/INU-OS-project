
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 0c 08 00 00       	push   $0x80c
  21:	6a 02                	push   $0x2
  23:	e8 2d 04 00 00       	call   455 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 99 02 00 00       	call   2c9 <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 01 00 00       	call   237 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 9a 02 00 00       	call   2f9 <kill>
  5f:	83 c4 10             	add    $0x10,%esp
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
  exit();
  6d:	e8 57 02 00 00       	call   2c9 <exit>

00000072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  93:	90                   	nop
  94:	5b                   	pop    %ebx
  95:	5f                   	pop    %edi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret

00000098 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a4:	90                   	nop
  a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  a8:	8d 42 01             	lea    0x1(%edx),%eax
  ab:	89 45 0c             	mov    %eax,0xc(%ebp)
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	8d 48 01             	lea    0x1(%eax),%ecx
  b4:	89 4d 08             	mov    %ecx,0x8(%ebp)
  b7:	0f b6 12             	movzbl (%edx),%edx
  ba:	88 10                	mov    %dl,(%eax)
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 e2                	jne    a5 <strcpy+0xd>
    ;
  return os;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave
  c7:	c3                   	ret

000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cb:	eb 08                	jmp    d5 <strcmp+0xd>
    p++, q++;
  cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	74 10                	je     ef <strcmp+0x27>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 10             	movzbl (%eax),%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 de                	je     cd <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 c0             	movzbl %al,%eax
 101:	29 c2                	sub    %eax,%edx
 103:	89 d0                	mov    %edx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret

00000107 <strlen>:

uint
strlen(char *s)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 04                	jmp    11a <strlen+0x13>
 116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 ed                	jne    116 <strlen+0xf>
    ;
  return n;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave
 12d:	c3                   	ret

0000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 131:	8b 45 10             	mov    0x10(%ebp),%eax
 134:	50                   	push   %eax
 135:	ff 75 0c             	push   0xc(%ebp)
 138:	ff 75 08             	push   0x8(%ebp)
 13b:	e8 32 ff ff ff       	call   72 <stosb>
 140:	83 c4 0c             	add    $0xc,%esp
  return dst;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
}
 146:	c9                   	leave
 147:	c3                   	ret

00000148 <strchr>:

char*
strchr(const char *s, char c)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 154:	eb 14                	jmp    16a <strchr+0x22>
    if(*s == c)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 15f:	75 05                	jne    166 <strchr+0x1e>
      return (char*)s;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	eb 13                	jmp    179 <strchr+0x31>
  for(; *s; s++)
 166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 e2                	jne    156 <strchr+0xe>
  return 0;
 174:	b8 00 00 00 00       	mov    $0x0,%eax
}
 179:	c9                   	leave
 17a:	c3                   	ret

0000017b <gets>:

char*
gets(char *buf, int max)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 188:	eb 42                	jmp    1cc <gets+0x51>
    cc = read(0, &c, 1);
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	6a 01                	push   $0x1
 18f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 192:	50                   	push   %eax
 193:	6a 00                	push   $0x0
 195:	e8 47 01 00 00       	call   2e1 <read>
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a4:	7e 33                	jle    1d9 <gets+0x5e>
      break;
    buf[i++] = c;
 1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a9:	8d 50 01             	lea    0x1(%eax),%edx
 1ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1af:	89 c2                	mov    %eax,%edx
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	01 c2                	add    %eax,%edx
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x5f>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x5f>
  for(i=0; i+1 < max; ){
 1cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1d5:	7f b3                	jg     18a <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x5f>
      break;
 1d9:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave
 1e9:	c3                   	ret

000001ea <stat>:

int
stat(char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	push   0x8(%ebp)
 1f8:	e8 0c 01 00 00       	call   309 <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	push   0xc(%ebp)
 216:	ff 75 f4             	push   -0xc(%ebp)
 219:	e8 03 01 00 00       	call   321 <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	push   -0xc(%ebp)
 22a:	e8 c2 00 00 00       	call   2f1 <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave
 236:	c3                   	ret

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 25                	jmp    26b <atoi+0x34>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c1                	mov    %eax,%ecx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8d 50 01             	lea    0x1(%eax),%edx
 25a:	89 55 08             	mov    %edx,0x8(%ebp)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f be c0             	movsbl %al,%eax
 263:	01 c8                	add    %ecx,%eax
 265:	83 e8 30             	sub    $0x30,%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 0a                	jle    27f <atoi+0x48>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	3c 39                	cmp    $0x39,%al
 27d:	7e c7                	jle    246 <atoi+0xf>
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave
 283:	c3                   	ret

00000284 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 296:	eb 17                	jmp    2af <memmove+0x2b>
    *dst++ = *src++;
 298:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29b:	8d 42 01             	lea    0x1(%edx),%eax
 29e:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a4:	8d 48 01             	lea    0x1(%eax),%ecx
 2a7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
 2b8:	85 c0                	test   %eax,%eax
 2ba:	7f dc                	jg     298 <memmove+0x14>
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave
 2c0:	c3                   	ret

000002c1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c1:	b8 01 00 00 00       	mov    $0x1,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret

000002c9 <exit>:
SYSCALL(exit)
 2c9:	b8 02 00 00 00       	mov    $0x2,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret

000002d1 <wait>:
SYSCALL(wait)
 2d1:	b8 03 00 00 00       	mov    $0x3,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret

000002d9 <pipe>:
SYSCALL(pipe)
 2d9:	b8 04 00 00 00       	mov    $0x4,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret

000002e1 <read>:
SYSCALL(read)
 2e1:	b8 05 00 00 00       	mov    $0x5,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret

000002e9 <write>:
SYSCALL(write)
 2e9:	b8 10 00 00 00       	mov    $0x10,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret

000002f1 <close>:
SYSCALL(close)
 2f1:	b8 15 00 00 00       	mov    $0x15,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret

000002f9 <kill>:
SYSCALL(kill)
 2f9:	b8 06 00 00 00       	mov    $0x6,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret

00000301 <exec>:
SYSCALL(exec)
 301:	b8 07 00 00 00       	mov    $0x7,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret

00000309 <open>:
SYSCALL(open)
 309:	b8 0f 00 00 00       	mov    $0xf,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret

00000311 <mknod>:
SYSCALL(mknod)
 311:	b8 11 00 00 00       	mov    $0x11,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret

00000319 <unlink>:
SYSCALL(unlink)
 319:	b8 12 00 00 00       	mov    $0x12,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret

00000321 <fstat>:
SYSCALL(fstat)
 321:	b8 08 00 00 00       	mov    $0x8,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret

00000329 <link>:
SYSCALL(link)
 329:	b8 13 00 00 00       	mov    $0x13,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret

00000331 <mkdir>:
SYSCALL(mkdir)
 331:	b8 14 00 00 00       	mov    $0x14,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret

00000339 <chdir>:
SYSCALL(chdir)
 339:	b8 09 00 00 00       	mov    $0x9,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret

00000341 <dup>:
SYSCALL(dup)
 341:	b8 0a 00 00 00       	mov    $0xa,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret

00000349 <getpid>:
SYSCALL(getpid)
 349:	b8 0b 00 00 00       	mov    $0xb,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret

00000351 <sbrk>:
SYSCALL(sbrk)
 351:	b8 0c 00 00 00       	mov    $0xc,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret

00000359 <sleep>:
SYSCALL(sleep)
 359:	b8 0d 00 00 00       	mov    $0xd,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret

00000361 <uptime>:
SYSCALL(uptime)
 361:	b8 0e 00 00 00       	mov    $0xe,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret

00000369 <wait2>:
SYSCALL(wait2)
 369:	b8 17 00 00 00       	mov    $0x17,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret

00000371 <exit2>:
SYSCALL(exit2)
 371:	b8 16 00 00 00       	mov    $0x16,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret

00000379 <uthread_init>:
 379:	b8 18 00 00 00       	mov    $0x18,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret

00000381 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
 384:	83 ec 18             	sub    $0x18,%esp
 387:	8b 45 0c             	mov    0xc(%ebp),%eax
 38a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 38d:	83 ec 04             	sub    $0x4,%esp
 390:	6a 01                	push   $0x1
 392:	8d 45 f4             	lea    -0xc(%ebp),%eax
 395:	50                   	push   %eax
 396:	ff 75 08             	push   0x8(%ebp)
 399:	e8 4b ff ff ff       	call   2e9 <write>
 39e:	83 c4 10             	add    $0x10,%esp
}
 3a1:	90                   	nop
 3a2:	c9                   	leave
 3a3:	c3                   	ret

000003a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b5:	74 17                	je     3ce <printint+0x2a>
 3b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3bb:	79 11                	jns    3ce <printint+0x2a>
    neg = 1;
 3bd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c7:	f7 d8                	neg    %eax
 3c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3cc:	eb 06                	jmp    3d4 <printint+0x30>
  } else {
    x = xx;
 3ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3db:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3de:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e1:	ba 00 00 00 00       	mov    $0x0,%edx
 3e6:	f7 f1                	div    %ecx
 3e8:	89 d1                	mov    %edx,%ecx
 3ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ed:	8d 50 01             	lea    0x1(%eax),%edx
 3f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3f3:	0f b6 91 70 0a 00 00 	movzbl 0xa70(%ecx),%edx
 3fa:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 3fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
 401:	8b 45 ec             	mov    -0x14(%ebp),%eax
 404:	ba 00 00 00 00       	mov    $0x0,%edx
 409:	f7 f1                	div    %ecx
 40b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 40e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 412:	75 c7                	jne    3db <printint+0x37>
  if(neg)
 414:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 418:	74 2d                	je     447 <printint+0xa3>
    buf[i++] = '-';
 41a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41d:	8d 50 01             	lea    0x1(%eax),%edx
 420:	89 55 f4             	mov    %edx,-0xc(%ebp)
 423:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 428:	eb 1d                	jmp    447 <printint+0xa3>
    putc(fd, buf[i]);
 42a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 42d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 430:	01 d0                	add    %edx,%eax
 432:	0f b6 00             	movzbl (%eax),%eax
 435:	0f be c0             	movsbl %al,%eax
 438:	83 ec 08             	sub    $0x8,%esp
 43b:	50                   	push   %eax
 43c:	ff 75 08             	push   0x8(%ebp)
 43f:	e8 3d ff ff ff       	call   381 <putc>
 444:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 447:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 44b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 44f:	79 d9                	jns    42a <printint+0x86>
}
 451:	90                   	nop
 452:	90                   	nop
 453:	c9                   	leave
 454:	c3                   	ret

00000455 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 455:	55                   	push   %ebp
 456:	89 e5                	mov    %esp,%ebp
 458:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 45b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 462:	8d 45 0c             	lea    0xc(%ebp),%eax
 465:	83 c0 04             	add    $0x4,%eax
 468:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 46b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 472:	e9 59 01 00 00       	jmp    5d0 <printf+0x17b>
    c = fmt[i] & 0xff;
 477:	8b 55 0c             	mov    0xc(%ebp),%edx
 47a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 47d:	01 d0                	add    %edx,%eax
 47f:	0f b6 00             	movzbl (%eax),%eax
 482:	0f be c0             	movsbl %al,%eax
 485:	25 ff 00 00 00       	and    $0xff,%eax
 48a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 48d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 491:	75 2c                	jne    4bf <printf+0x6a>
      if(c == '%'){
 493:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 497:	75 0c                	jne    4a5 <printf+0x50>
        state = '%';
 499:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a0:	e9 27 01 00 00       	jmp    5cc <printf+0x177>
      } else {
        putc(fd, c);
 4a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a8:	0f be c0             	movsbl %al,%eax
 4ab:	83 ec 08             	sub    $0x8,%esp
 4ae:	50                   	push   %eax
 4af:	ff 75 08             	push   0x8(%ebp)
 4b2:	e8 ca fe ff ff       	call   381 <putc>
 4b7:	83 c4 10             	add    $0x10,%esp
 4ba:	e9 0d 01 00 00       	jmp    5cc <printf+0x177>
      }
    } else if(state == '%'){
 4bf:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c3:	0f 85 03 01 00 00    	jne    5cc <printf+0x177>
      if(c == 'd'){
 4c9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4cd:	75 1e                	jne    4ed <printf+0x98>
        printint(fd, *ap, 10, 1);
 4cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d2:	8b 00                	mov    (%eax),%eax
 4d4:	6a 01                	push   $0x1
 4d6:	6a 0a                	push   $0xa
 4d8:	50                   	push   %eax
 4d9:	ff 75 08             	push   0x8(%ebp)
 4dc:	e8 c3 fe ff ff       	call   3a4 <printint>
 4e1:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e8:	e9 d8 00 00 00       	jmp    5c5 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4ed:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f1:	74 06                	je     4f9 <printf+0xa4>
 4f3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f7:	75 1e                	jne    517 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fc:	8b 00                	mov    (%eax),%eax
 4fe:	6a 00                	push   $0x0
 500:	6a 10                	push   $0x10
 502:	50                   	push   %eax
 503:	ff 75 08             	push   0x8(%ebp)
 506:	e8 99 fe ff ff       	call   3a4 <printint>
 50b:	83 c4 10             	add    $0x10,%esp
        ap++;
 50e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 512:	e9 ae 00 00 00       	jmp    5c5 <printf+0x170>
      } else if(c == 's'){
 517:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 51b:	75 43                	jne    560 <printf+0x10b>
        s = (char*)*ap;
 51d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 520:	8b 00                	mov    (%eax),%eax
 522:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 525:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 529:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52d:	75 25                	jne    554 <printf+0xff>
          s = "(null)";
 52f:	c7 45 f4 20 08 00 00 	movl   $0x820,-0xc(%ebp)
        while(*s != 0){
 536:	eb 1c                	jmp    554 <printf+0xff>
          putc(fd, *s);
 538:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53b:	0f b6 00             	movzbl (%eax),%eax
 53e:	0f be c0             	movsbl %al,%eax
 541:	83 ec 08             	sub    $0x8,%esp
 544:	50                   	push   %eax
 545:	ff 75 08             	push   0x8(%ebp)
 548:	e8 34 fe ff ff       	call   381 <putc>
 54d:	83 c4 10             	add    $0x10,%esp
          s++;
 550:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 554:	8b 45 f4             	mov    -0xc(%ebp),%eax
 557:	0f b6 00             	movzbl (%eax),%eax
 55a:	84 c0                	test   %al,%al
 55c:	75 da                	jne    538 <printf+0xe3>
 55e:	eb 65                	jmp    5c5 <printf+0x170>
        }
      } else if(c == 'c'){
 560:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 564:	75 1d                	jne    583 <printf+0x12e>
        putc(fd, *ap);
 566:	8b 45 e8             	mov    -0x18(%ebp),%eax
 569:	8b 00                	mov    (%eax),%eax
 56b:	0f be c0             	movsbl %al,%eax
 56e:	83 ec 08             	sub    $0x8,%esp
 571:	50                   	push   %eax
 572:	ff 75 08             	push   0x8(%ebp)
 575:	e8 07 fe ff ff       	call   381 <putc>
 57a:	83 c4 10             	add    $0x10,%esp
        ap++;
 57d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 581:	eb 42                	jmp    5c5 <printf+0x170>
      } else if(c == '%'){
 583:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 587:	75 17                	jne    5a0 <printf+0x14b>
        putc(fd, c);
 589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58c:	0f be c0             	movsbl %al,%eax
 58f:	83 ec 08             	sub    $0x8,%esp
 592:	50                   	push   %eax
 593:	ff 75 08             	push   0x8(%ebp)
 596:	e8 e6 fd ff ff       	call   381 <putc>
 59b:	83 c4 10             	add    $0x10,%esp
 59e:	eb 25                	jmp    5c5 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a0:	83 ec 08             	sub    $0x8,%esp
 5a3:	6a 25                	push   $0x25
 5a5:	ff 75 08             	push   0x8(%ebp)
 5a8:	e8 d4 fd ff ff       	call   381 <putc>
 5ad:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b3:	0f be c0             	movsbl %al,%eax
 5b6:	83 ec 08             	sub    $0x8,%esp
 5b9:	50                   	push   %eax
 5ba:	ff 75 08             	push   0x8(%ebp)
 5bd:	e8 bf fd ff ff       	call   381 <putc>
 5c2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5cc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d0:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d6:	01 d0                	add    %edx,%eax
 5d8:	0f b6 00             	movzbl (%eax),%eax
 5db:	84 c0                	test   %al,%al
 5dd:	0f 85 94 fe ff ff    	jne    477 <printf+0x22>
    }
  }
}
 5e3:	90                   	nop
 5e4:	90                   	nop
 5e5:	c9                   	leave
 5e6:	c3                   	ret

000005e7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e7:	55                   	push   %ebp
 5e8:	89 e5                	mov    %esp,%ebp
 5ea:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ed:	8b 45 08             	mov    0x8(%ebp),%eax
 5f0:	83 e8 08             	sub    $0x8,%eax
 5f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f6:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 5fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5fe:	eb 24                	jmp    624 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 600:	8b 45 fc             	mov    -0x4(%ebp),%eax
 603:	8b 00                	mov    (%eax),%eax
 605:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 608:	72 12                	jb     61c <free+0x35>
 60a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 610:	72 24                	jb     636 <free+0x4f>
 612:	8b 45 fc             	mov    -0x4(%ebp),%eax
 615:	8b 00                	mov    (%eax),%eax
 617:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 61a:	72 1a                	jb     636 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	89 45 fc             	mov    %eax,-0x4(%ebp)
 624:	8b 45 f8             	mov    -0x8(%ebp),%eax
 627:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 62a:	73 d4                	jae    600 <free+0x19>
 62c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62f:	8b 00                	mov    (%eax),%eax
 631:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 634:	73 ca                	jae    600 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 636:	8b 45 f8             	mov    -0x8(%ebp),%eax
 639:	8b 40 04             	mov    0x4(%eax),%eax
 63c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 643:	8b 45 f8             	mov    -0x8(%ebp),%eax
 646:	01 c2                	add    %eax,%edx
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 00                	mov    (%eax),%eax
 64d:	39 c2                	cmp    %eax,%edx
 64f:	75 24                	jne    675 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 651:	8b 45 f8             	mov    -0x8(%ebp),%eax
 654:	8b 50 04             	mov    0x4(%eax),%edx
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	8b 00                	mov    (%eax),%eax
 65c:	8b 40 04             	mov    0x4(%eax),%eax
 65f:	01 c2                	add    %eax,%edx
 661:	8b 45 f8             	mov    -0x8(%ebp),%eax
 664:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 667:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	8b 10                	mov    (%eax),%edx
 66e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 671:	89 10                	mov    %edx,(%eax)
 673:	eb 0a                	jmp    67f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 10                	mov    (%eax),%edx
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 40 04             	mov    0x4(%eax),%eax
 685:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	01 d0                	add    %edx,%eax
 691:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 694:	75 20                	jne    6b6 <free+0xcf>
    p->s.size += bp->s.size;
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	8b 50 04             	mov    0x4(%eax),%edx
 69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69f:	8b 40 04             	mov    0x4(%eax),%eax
 6a2:	01 c2                	add    %eax,%edx
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	8b 10                	mov    (%eax),%edx
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	89 10                	mov    %edx,(%eax)
 6b4:	eb 08                	jmp    6be <free+0xd7>
  } else
    p->s.ptr = bp;
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6bc:	89 10                	mov    %edx,(%eax)
  freep = p;
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	a3 8c 0a 00 00       	mov    %eax,0xa8c
}
 6c6:	90                   	nop
 6c7:	c9                   	leave
 6c8:	c3                   	ret

000006c9 <morecore>:

static Header*
morecore(uint nu)
{
 6c9:	55                   	push   %ebp
 6ca:	89 e5                	mov    %esp,%ebp
 6cc:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6cf:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d6:	77 07                	ja     6df <morecore+0x16>
    nu = 4096;
 6d8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6df:	8b 45 08             	mov    0x8(%ebp),%eax
 6e2:	c1 e0 03             	shl    $0x3,%eax
 6e5:	83 ec 0c             	sub    $0xc,%esp
 6e8:	50                   	push   %eax
 6e9:	e8 63 fc ff ff       	call   351 <sbrk>
 6ee:	83 c4 10             	add    $0x10,%esp
 6f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6f8:	75 07                	jne    701 <morecore+0x38>
    return 0;
 6fa:	b8 00 00 00 00       	mov    $0x0,%eax
 6ff:	eb 26                	jmp    727 <morecore+0x5e>
  hp = (Header*)p;
 701:	8b 45 f4             	mov    -0xc(%ebp),%eax
 704:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 707:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70a:	8b 55 08             	mov    0x8(%ebp),%edx
 70d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 710:	8b 45 f0             	mov    -0x10(%ebp),%eax
 713:	83 c0 08             	add    $0x8,%eax
 716:	83 ec 0c             	sub    $0xc,%esp
 719:	50                   	push   %eax
 71a:	e8 c8 fe ff ff       	call   5e7 <free>
 71f:	83 c4 10             	add    $0x10,%esp
  return freep;
 722:	a1 8c 0a 00 00       	mov    0xa8c,%eax
}
 727:	c9                   	leave
 728:	c3                   	ret

00000729 <malloc>:

void*
malloc(uint nbytes)
{
 729:	55                   	push   %ebp
 72a:	89 e5                	mov    %esp,%ebp
 72c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 72f:	8b 45 08             	mov    0x8(%ebp),%eax
 732:	83 c0 07             	add    $0x7,%eax
 735:	c1 e8 03             	shr    $0x3,%eax
 738:	83 c0 01             	add    $0x1,%eax
 73b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 73e:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 743:	89 45 f0             	mov    %eax,-0x10(%ebp)
 746:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74a:	75 23                	jne    76f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 74c:	c7 45 f0 84 0a 00 00 	movl   $0xa84,-0x10(%ebp)
 753:	8b 45 f0             	mov    -0x10(%ebp),%eax
 756:	a3 8c 0a 00 00       	mov    %eax,0xa8c
 75b:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 760:	a3 84 0a 00 00       	mov    %eax,0xa84
    base.s.size = 0;
 765:	c7 05 88 0a 00 00 00 	movl   $0x0,0xa88
 76c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 772:	8b 00                	mov    (%eax),%eax
 774:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	8b 40 04             	mov    0x4(%eax),%eax
 77d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 780:	72 4d                	jb     7cf <malloc+0xa6>
      if(p->s.size == nunits)
 782:	8b 45 f4             	mov    -0xc(%ebp),%eax
 785:	8b 40 04             	mov    0x4(%eax),%eax
 788:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 78b:	75 0c                	jne    799 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 790:	8b 10                	mov    (%eax),%edx
 792:	8b 45 f0             	mov    -0x10(%ebp),%eax
 795:	89 10                	mov    %edx,(%eax)
 797:	eb 26                	jmp    7bf <malloc+0x96>
      else {
        p->s.size -= nunits;
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	8b 40 04             	mov    0x4(%eax),%eax
 79f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a2:	89 c2                	mov    %eax,%edx
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	8b 40 04             	mov    0x4(%eax),%eax
 7b0:	c1 e0 03             	shl    $0x3,%eax
 7b3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7bc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c2:	a3 8c 0a 00 00       	mov    %eax,0xa8c
      return (void*)(p + 1);
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	83 c0 08             	add    $0x8,%eax
 7cd:	eb 3b                	jmp    80a <malloc+0xe1>
    }
    if(p == freep)
 7cf:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 7d4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7d7:	75 1e                	jne    7f7 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7d9:	83 ec 0c             	sub    $0xc,%esp
 7dc:	ff 75 ec             	push   -0x14(%ebp)
 7df:	e8 e5 fe ff ff       	call   6c9 <morecore>
 7e4:	83 c4 10             	add    $0x10,%esp
 7e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ee:	75 07                	jne    7f7 <malloc+0xce>
        return 0;
 7f0:	b8 00 00 00 00       	mov    $0x0,%eax
 7f5:	eb 13                	jmp    80a <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	8b 00                	mov    (%eax),%eax
 802:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 805:	e9 6d ff ff ff       	jmp    777 <malloc+0x4e>
  }
}
 80a:	c9                   	leave
 80b:	c3                   	ret
