
_SID:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h" 
#include "user.h" 

int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
 int id=202201460;  // Your student id.
  11:	c7 45 f4 74 59 0d 0c 	movl   $0xc0d5974,-0xc(%ebp)
 printf(1,"My ID is %d\n", id);
  18:	83 ec 04             	sub    $0x4,%esp
  1b:	ff 75 f4             	push   -0xc(%ebp)
  1e:	68 cc 07 00 00       	push   $0x7cc
  23:	6a 01                	push   $0x1
  25:	e8 eb 03 00 00       	call   415 <printf>
  2a:	83 c4 10             	add    $0x10,%esp
 exit();
  2d:	e8 57 02 00 00       	call   289 <exit>

00000032 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  32:	55                   	push   %ebp
  33:	89 e5                	mov    %esp,%ebp
  35:	57                   	push   %edi
  36:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  3a:	8b 55 10             	mov    0x10(%ebp),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	89 cb                	mov    %ecx,%ebx
  42:	89 df                	mov    %ebx,%edi
  44:	89 d1                	mov    %edx,%ecx
  46:	fc                   	cld
  47:	f3 aa                	rep stos %al,%es:(%edi)
  49:	89 ca                	mov    %ecx,%edx
  4b:	89 fb                	mov    %edi,%ebx
  4d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  50:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  53:	90                   	nop
  54:	5b                   	pop    %ebx
  55:	5f                   	pop    %edi
  56:	5d                   	pop    %ebp
  57:	c3                   	ret

00000058 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  58:	55                   	push   %ebp
  59:	89 e5                	mov    %esp,%ebp
  5b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  5e:	8b 45 08             	mov    0x8(%ebp),%eax
  61:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  64:	90                   	nop
  65:	8b 55 0c             	mov    0xc(%ebp),%edx
  68:	8d 42 01             	lea    0x1(%edx),%eax
  6b:	89 45 0c             	mov    %eax,0xc(%ebp)
  6e:	8b 45 08             	mov    0x8(%ebp),%eax
  71:	8d 48 01             	lea    0x1(%eax),%ecx
  74:	89 4d 08             	mov    %ecx,0x8(%ebp)
  77:	0f b6 12             	movzbl (%edx),%edx
  7a:	88 10                	mov    %dl,(%eax)
  7c:	0f b6 00             	movzbl (%eax),%eax
  7f:	84 c0                	test   %al,%al
  81:	75 e2                	jne    65 <strcpy+0xd>
    ;
  return os;
  83:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  86:	c9                   	leave
  87:	c3                   	ret

00000088 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  88:	55                   	push   %ebp
  89:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  8b:	eb 08                	jmp    95 <strcmp+0xd>
    p++, q++;
  8d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  91:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  95:	8b 45 08             	mov    0x8(%ebp),%eax
  98:	0f b6 00             	movzbl (%eax),%eax
  9b:	84 c0                	test   %al,%al
  9d:	74 10                	je     af <strcmp+0x27>
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	0f b6 10             	movzbl (%eax),%edx
  a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  a8:	0f b6 00             	movzbl (%eax),%eax
  ab:	38 c2                	cmp    %al,%dl
  ad:	74 de                	je     8d <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  af:	8b 45 08             	mov    0x8(%ebp),%eax
  b2:	0f b6 00             	movzbl (%eax),%eax
  b5:	0f b6 d0             	movzbl %al,%edx
  b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  bb:	0f b6 00             	movzbl (%eax),%eax
  be:	0f b6 c0             	movzbl %al,%eax
  c1:	29 c2                	sub    %eax,%edx
  c3:	89 d0                	mov    %edx,%eax
}
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret

000000c7 <strlen>:

uint
strlen(char *s)
{
  c7:	55                   	push   %ebp
  c8:	89 e5                	mov    %esp,%ebp
  ca:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  d4:	eb 04                	jmp    da <strlen+0x13>
  d6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  dd:	8b 45 08             	mov    0x8(%ebp),%eax
  e0:	01 d0                	add    %edx,%eax
  e2:	0f b6 00             	movzbl (%eax),%eax
  e5:	84 c0                	test   %al,%al
  e7:	75 ed                	jne    d6 <strlen+0xf>
    ;
  return n;
  e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ec:	c9                   	leave
  ed:	c3                   	ret

000000ee <memset>:

void*
memset(void *dst, int c, uint n)
{
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  f1:	8b 45 10             	mov    0x10(%ebp),%eax
  f4:	50                   	push   %eax
  f5:	ff 75 0c             	push   0xc(%ebp)
  f8:	ff 75 08             	push   0x8(%ebp)
  fb:	e8 32 ff ff ff       	call   32 <stosb>
 100:	83 c4 0c             	add    $0xc,%esp
  return dst;
 103:	8b 45 08             	mov    0x8(%ebp),%eax
}
 106:	c9                   	leave
 107:	c3                   	ret

00000108 <strchr>:

char*
strchr(const char *s, char c)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	83 ec 04             	sub    $0x4,%esp
 10e:	8b 45 0c             	mov    0xc(%ebp),%eax
 111:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 114:	eb 14                	jmp    12a <strchr+0x22>
    if(*s == c)
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	0f b6 00             	movzbl (%eax),%eax
 11c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 11f:	75 05                	jne    126 <strchr+0x1e>
      return (char*)s;
 121:	8b 45 08             	mov    0x8(%ebp),%eax
 124:	eb 13                	jmp    139 <strchr+0x31>
  for(; *s; s++)
 126:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 12a:	8b 45 08             	mov    0x8(%ebp),%eax
 12d:	0f b6 00             	movzbl (%eax),%eax
 130:	84 c0                	test   %al,%al
 132:	75 e2                	jne    116 <strchr+0xe>
  return 0;
 134:	b8 00 00 00 00       	mov    $0x0,%eax
}
 139:	c9                   	leave
 13a:	c3                   	ret

0000013b <gets>:

char*
gets(char *buf, int max)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 141:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 148:	eb 42                	jmp    18c <gets+0x51>
    cc = read(0, &c, 1);
 14a:	83 ec 04             	sub    $0x4,%esp
 14d:	6a 01                	push   $0x1
 14f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 152:	50                   	push   %eax
 153:	6a 00                	push   $0x0
 155:	e8 47 01 00 00       	call   2a1 <read>
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 160:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 164:	7e 33                	jle    199 <gets+0x5e>
      break;
    buf[i++] = c;
 166:	8b 45 f4             	mov    -0xc(%ebp),%eax
 169:	8d 50 01             	lea    0x1(%eax),%edx
 16c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 16f:	89 c2                	mov    %eax,%edx
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	01 c2                	add    %eax,%edx
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 17c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 180:	3c 0a                	cmp    $0xa,%al
 182:	74 16                	je     19a <gets+0x5f>
 184:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 188:	3c 0d                	cmp    $0xd,%al
 18a:	74 0e                	je     19a <gets+0x5f>
  for(i=0; i+1 < max; ){
 18c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 18f:	83 c0 01             	add    $0x1,%eax
 192:	39 45 0c             	cmp    %eax,0xc(%ebp)
 195:	7f b3                	jg     14a <gets+0xf>
 197:	eb 01                	jmp    19a <gets+0x5f>
      break;
 199:	90                   	nop
      break;
  }
  buf[i] = '\0';
 19a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
 1a0:	01 d0                	add    %edx,%eax
 1a2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a8:	c9                   	leave
 1a9:	c3                   	ret

000001aa <stat>:

int
stat(char *n, struct stat *st)
{
 1aa:	55                   	push   %ebp
 1ab:	89 e5                	mov    %esp,%ebp
 1ad:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b0:	83 ec 08             	sub    $0x8,%esp
 1b3:	6a 00                	push   $0x0
 1b5:	ff 75 08             	push   0x8(%ebp)
 1b8:	e8 0c 01 00 00       	call   2c9 <open>
 1bd:	83 c4 10             	add    $0x10,%esp
 1c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c7:	79 07                	jns    1d0 <stat+0x26>
    return -1;
 1c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1ce:	eb 25                	jmp    1f5 <stat+0x4b>
  r = fstat(fd, st);
 1d0:	83 ec 08             	sub    $0x8,%esp
 1d3:	ff 75 0c             	push   0xc(%ebp)
 1d6:	ff 75 f4             	push   -0xc(%ebp)
 1d9:	e8 03 01 00 00       	call   2e1 <fstat>
 1de:	83 c4 10             	add    $0x10,%esp
 1e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1e4:	83 ec 0c             	sub    $0xc,%esp
 1e7:	ff 75 f4             	push   -0xc(%ebp)
 1ea:	e8 c2 00 00 00       	call   2b1 <close>
 1ef:	83 c4 10             	add    $0x10,%esp
  return r;
 1f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1f5:	c9                   	leave
 1f6:	c3                   	ret

000001f7 <atoi>:

int
atoi(const char *s)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 204:	eb 25                	jmp    22b <atoi+0x34>
    n = n*10 + *s++ - '0';
 206:	8b 55 fc             	mov    -0x4(%ebp),%edx
 209:	89 d0                	mov    %edx,%eax
 20b:	c1 e0 02             	shl    $0x2,%eax
 20e:	01 d0                	add    %edx,%eax
 210:	01 c0                	add    %eax,%eax
 212:	89 c1                	mov    %eax,%ecx
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	8d 50 01             	lea    0x1(%eax),%edx
 21a:	89 55 08             	mov    %edx,0x8(%ebp)
 21d:	0f b6 00             	movzbl (%eax),%eax
 220:	0f be c0             	movsbl %al,%eax
 223:	01 c8                	add    %ecx,%eax
 225:	83 e8 30             	sub    $0x30,%eax
 228:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	0f b6 00             	movzbl (%eax),%eax
 231:	3c 2f                	cmp    $0x2f,%al
 233:	7e 0a                	jle    23f <atoi+0x48>
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	0f b6 00             	movzbl (%eax),%eax
 23b:	3c 39                	cmp    $0x39,%al
 23d:	7e c7                	jle    206 <atoi+0xf>
  return n;
 23f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 242:	c9                   	leave
 243:	c3                   	ret

00000244 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 250:	8b 45 0c             	mov    0xc(%ebp),%eax
 253:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 256:	eb 17                	jmp    26f <memmove+0x2b>
    *dst++ = *src++;
 258:	8b 55 f8             	mov    -0x8(%ebp),%edx
 25b:	8d 42 01             	lea    0x1(%edx),%eax
 25e:	89 45 f8             	mov    %eax,-0x8(%ebp)
 261:	8b 45 fc             	mov    -0x4(%ebp),%eax
 264:	8d 48 01             	lea    0x1(%eax),%ecx
 267:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 26a:	0f b6 12             	movzbl (%edx),%edx
 26d:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 26f:	8b 45 10             	mov    0x10(%ebp),%eax
 272:	8d 50 ff             	lea    -0x1(%eax),%edx
 275:	89 55 10             	mov    %edx,0x10(%ebp)
 278:	85 c0                	test   %eax,%eax
 27a:	7f dc                	jg     258 <memmove+0x14>
  return vdst;
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 27f:	c9                   	leave
 280:	c3                   	ret

00000281 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 281:	b8 01 00 00 00       	mov    $0x1,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret

00000289 <exit>:
SYSCALL(exit)
 289:	b8 02 00 00 00       	mov    $0x2,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret

00000291 <wait>:
SYSCALL(wait)
 291:	b8 03 00 00 00       	mov    $0x3,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret

00000299 <pipe>:
SYSCALL(pipe)
 299:	b8 04 00 00 00       	mov    $0x4,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret

000002a1 <read>:
SYSCALL(read)
 2a1:	b8 05 00 00 00       	mov    $0x5,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret

000002a9 <write>:
SYSCALL(write)
 2a9:	b8 10 00 00 00       	mov    $0x10,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret

000002b1 <close>:
SYSCALL(close)
 2b1:	b8 15 00 00 00       	mov    $0x15,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret

000002b9 <kill>:
SYSCALL(kill)
 2b9:	b8 06 00 00 00       	mov    $0x6,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret

000002c1 <exec>:
SYSCALL(exec)
 2c1:	b8 07 00 00 00       	mov    $0x7,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret

000002c9 <open>:
SYSCALL(open)
 2c9:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret

000002d1 <mknod>:
SYSCALL(mknod)
 2d1:	b8 11 00 00 00       	mov    $0x11,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret

000002d9 <unlink>:
SYSCALL(unlink)
 2d9:	b8 12 00 00 00       	mov    $0x12,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret

000002e1 <fstat>:
SYSCALL(fstat)
 2e1:	b8 08 00 00 00       	mov    $0x8,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret

000002e9 <link>:
SYSCALL(link)
 2e9:	b8 13 00 00 00       	mov    $0x13,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret

000002f1 <mkdir>:
SYSCALL(mkdir)
 2f1:	b8 14 00 00 00       	mov    $0x14,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret

000002f9 <chdir>:
SYSCALL(chdir)
 2f9:	b8 09 00 00 00       	mov    $0x9,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret

00000301 <dup>:
SYSCALL(dup)
 301:	b8 0a 00 00 00       	mov    $0xa,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret

00000309 <getpid>:
SYSCALL(getpid)
 309:	b8 0b 00 00 00       	mov    $0xb,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret

00000311 <sbrk>:
SYSCALL(sbrk)
 311:	b8 0c 00 00 00       	mov    $0xc,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret

00000319 <sleep>:
SYSCALL(sleep)
 319:	b8 0d 00 00 00       	mov    $0xd,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret

00000321 <uptime>:
SYSCALL(uptime)
 321:	b8 0e 00 00 00       	mov    $0xe,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret

00000329 <wait2>:
SYSCALL(wait2)
 329:	b8 17 00 00 00       	mov    $0x17,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret

00000331 <exit2>:
SYSCALL(exit2)
 331:	b8 16 00 00 00       	mov    $0x16,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret

00000339 <uthread_init>:
 339:	b8 18 00 00 00       	mov    $0x18,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret

00000341 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 341:	55                   	push   %ebp
 342:	89 e5                	mov    %esp,%ebp
 344:	83 ec 18             	sub    $0x18,%esp
 347:	8b 45 0c             	mov    0xc(%ebp),%eax
 34a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 34d:	83 ec 04             	sub    $0x4,%esp
 350:	6a 01                	push   $0x1
 352:	8d 45 f4             	lea    -0xc(%ebp),%eax
 355:	50                   	push   %eax
 356:	ff 75 08             	push   0x8(%ebp)
 359:	e8 4b ff ff ff       	call   2a9 <write>
 35e:	83 c4 10             	add    $0x10,%esp
}
 361:	90                   	nop
 362:	c9                   	leave
 363:	c3                   	ret

00000364 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 36a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 371:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 375:	74 17                	je     38e <printint+0x2a>
 377:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 37b:	79 11                	jns    38e <printint+0x2a>
    neg = 1;
 37d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 384:	8b 45 0c             	mov    0xc(%ebp),%eax
 387:	f7 d8                	neg    %eax
 389:	89 45 ec             	mov    %eax,-0x14(%ebp)
 38c:	eb 06                	jmp    394 <printint+0x30>
  } else {
    x = xx;
 38e:	8b 45 0c             	mov    0xc(%ebp),%eax
 391:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 394:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 39b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 39e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a1:	ba 00 00 00 00       	mov    $0x0,%edx
 3a6:	f7 f1                	div    %ecx
 3a8:	89 d1                	mov    %edx,%ecx
 3aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ad:	8d 50 01             	lea    0x1(%eax),%edx
 3b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3b3:	0f b6 91 24 0a 00 00 	movzbl 0xa24(%ecx),%edx
 3ba:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 3be:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c4:	ba 00 00 00 00       	mov    $0x0,%edx
 3c9:	f7 f1                	div    %ecx
 3cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3d2:	75 c7                	jne    39b <printint+0x37>
  if(neg)
 3d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d8:	74 2d                	je     407 <printint+0xa3>
    buf[i++] = '-';
 3da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3dd:	8d 50 01             	lea    0x1(%eax),%edx
 3e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3e3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3e8:	eb 1d                	jmp    407 <printint+0xa3>
    putc(fd, buf[i]);
 3ea:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f0:	01 d0                	add    %edx,%eax
 3f2:	0f b6 00             	movzbl (%eax),%eax
 3f5:	0f be c0             	movsbl %al,%eax
 3f8:	83 ec 08             	sub    $0x8,%esp
 3fb:	50                   	push   %eax
 3fc:	ff 75 08             	push   0x8(%ebp)
 3ff:	e8 3d ff ff ff       	call   341 <putc>
 404:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 407:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 40b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 40f:	79 d9                	jns    3ea <printint+0x86>
}
 411:	90                   	nop
 412:	90                   	nop
 413:	c9                   	leave
 414:	c3                   	ret

00000415 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 415:	55                   	push   %ebp
 416:	89 e5                	mov    %esp,%ebp
 418:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 41b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 422:	8d 45 0c             	lea    0xc(%ebp),%eax
 425:	83 c0 04             	add    $0x4,%eax
 428:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 42b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 432:	e9 59 01 00 00       	jmp    590 <printf+0x17b>
    c = fmt[i] & 0xff;
 437:	8b 55 0c             	mov    0xc(%ebp),%edx
 43a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 43d:	01 d0                	add    %edx,%eax
 43f:	0f b6 00             	movzbl (%eax),%eax
 442:	0f be c0             	movsbl %al,%eax
 445:	25 ff 00 00 00       	and    $0xff,%eax
 44a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 44d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 451:	75 2c                	jne    47f <printf+0x6a>
      if(c == '%'){
 453:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 457:	75 0c                	jne    465 <printf+0x50>
        state = '%';
 459:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 460:	e9 27 01 00 00       	jmp    58c <printf+0x177>
      } else {
        putc(fd, c);
 465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 468:	0f be c0             	movsbl %al,%eax
 46b:	83 ec 08             	sub    $0x8,%esp
 46e:	50                   	push   %eax
 46f:	ff 75 08             	push   0x8(%ebp)
 472:	e8 ca fe ff ff       	call   341 <putc>
 477:	83 c4 10             	add    $0x10,%esp
 47a:	e9 0d 01 00 00       	jmp    58c <printf+0x177>
      }
    } else if(state == '%'){
 47f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 483:	0f 85 03 01 00 00    	jne    58c <printf+0x177>
      if(c == 'd'){
 489:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 48d:	75 1e                	jne    4ad <printf+0x98>
        printint(fd, *ap, 10, 1);
 48f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 492:	8b 00                	mov    (%eax),%eax
 494:	6a 01                	push   $0x1
 496:	6a 0a                	push   $0xa
 498:	50                   	push   %eax
 499:	ff 75 08             	push   0x8(%ebp)
 49c:	e8 c3 fe ff ff       	call   364 <printint>
 4a1:	83 c4 10             	add    $0x10,%esp
        ap++;
 4a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4a8:	e9 d8 00 00 00       	jmp    585 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4ad:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4b1:	74 06                	je     4b9 <printf+0xa4>
 4b3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4b7:	75 1e                	jne    4d7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4bc:	8b 00                	mov    (%eax),%eax
 4be:	6a 00                	push   $0x0
 4c0:	6a 10                	push   $0x10
 4c2:	50                   	push   %eax
 4c3:	ff 75 08             	push   0x8(%ebp)
 4c6:	e8 99 fe ff ff       	call   364 <printint>
 4cb:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d2:	e9 ae 00 00 00       	jmp    585 <printf+0x170>
      } else if(c == 's'){
 4d7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4db:	75 43                	jne    520 <printf+0x10b>
        s = (char*)*ap;
 4dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e0:	8b 00                	mov    (%eax),%eax
 4e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ed:	75 25                	jne    514 <printf+0xff>
          s = "(null)";
 4ef:	c7 45 f4 d9 07 00 00 	movl   $0x7d9,-0xc(%ebp)
        while(*s != 0){
 4f6:	eb 1c                	jmp    514 <printf+0xff>
          putc(fd, *s);
 4f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fb:	0f b6 00             	movzbl (%eax),%eax
 4fe:	0f be c0             	movsbl %al,%eax
 501:	83 ec 08             	sub    $0x8,%esp
 504:	50                   	push   %eax
 505:	ff 75 08             	push   0x8(%ebp)
 508:	e8 34 fe ff ff       	call   341 <putc>
 50d:	83 c4 10             	add    $0x10,%esp
          s++;
 510:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 514:	8b 45 f4             	mov    -0xc(%ebp),%eax
 517:	0f b6 00             	movzbl (%eax),%eax
 51a:	84 c0                	test   %al,%al
 51c:	75 da                	jne    4f8 <printf+0xe3>
 51e:	eb 65                	jmp    585 <printf+0x170>
        }
      } else if(c == 'c'){
 520:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 524:	75 1d                	jne    543 <printf+0x12e>
        putc(fd, *ap);
 526:	8b 45 e8             	mov    -0x18(%ebp),%eax
 529:	8b 00                	mov    (%eax),%eax
 52b:	0f be c0             	movsbl %al,%eax
 52e:	83 ec 08             	sub    $0x8,%esp
 531:	50                   	push   %eax
 532:	ff 75 08             	push   0x8(%ebp)
 535:	e8 07 fe ff ff       	call   341 <putc>
 53a:	83 c4 10             	add    $0x10,%esp
        ap++;
 53d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 541:	eb 42                	jmp    585 <printf+0x170>
      } else if(c == '%'){
 543:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 547:	75 17                	jne    560 <printf+0x14b>
        putc(fd, c);
 549:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54c:	0f be c0             	movsbl %al,%eax
 54f:	83 ec 08             	sub    $0x8,%esp
 552:	50                   	push   %eax
 553:	ff 75 08             	push   0x8(%ebp)
 556:	e8 e6 fd ff ff       	call   341 <putc>
 55b:	83 c4 10             	add    $0x10,%esp
 55e:	eb 25                	jmp    585 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 560:	83 ec 08             	sub    $0x8,%esp
 563:	6a 25                	push   $0x25
 565:	ff 75 08             	push   0x8(%ebp)
 568:	e8 d4 fd ff ff       	call   341 <putc>
 56d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 573:	0f be c0             	movsbl %al,%eax
 576:	83 ec 08             	sub    $0x8,%esp
 579:	50                   	push   %eax
 57a:	ff 75 08             	push   0x8(%ebp)
 57d:	e8 bf fd ff ff       	call   341 <putc>
 582:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 585:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 58c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 590:	8b 55 0c             	mov    0xc(%ebp),%edx
 593:	8b 45 f0             	mov    -0x10(%ebp),%eax
 596:	01 d0                	add    %edx,%eax
 598:	0f b6 00             	movzbl (%eax),%eax
 59b:	84 c0                	test   %al,%al
 59d:	0f 85 94 fe ff ff    	jne    437 <printf+0x22>
    }
  }
}
 5a3:	90                   	nop
 5a4:	90                   	nop
 5a5:	c9                   	leave
 5a6:	c3                   	ret

000005a7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a7:	55                   	push   %ebp
 5a8:	89 e5                	mov    %esp,%ebp
 5aa:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ad:	8b 45 08             	mov    0x8(%ebp),%eax
 5b0:	83 e8 08             	sub    $0x8,%eax
 5b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b6:	a1 40 0a 00 00       	mov    0xa40,%eax
 5bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5be:	eb 24                	jmp    5e4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c3:	8b 00                	mov    (%eax),%eax
 5c5:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5c8:	72 12                	jb     5dc <free+0x35>
 5ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5cd:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5d0:	72 24                	jb     5f6 <free+0x4f>
 5d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d5:	8b 00                	mov    (%eax),%eax
 5d7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 5da:	72 1a                	jb     5f6 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5df:	8b 00                	mov    (%eax),%eax
 5e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e7:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5ea:	73 d4                	jae    5c0 <free+0x19>
 5ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ef:	8b 00                	mov    (%eax),%eax
 5f1:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 5f4:	73 ca                	jae    5c0 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f9:	8b 40 04             	mov    0x4(%eax),%eax
 5fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 603:	8b 45 f8             	mov    -0x8(%ebp),%eax
 606:	01 c2                	add    %eax,%edx
 608:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	39 c2                	cmp    %eax,%edx
 60f:	75 24                	jne    635 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 611:	8b 45 f8             	mov    -0x8(%ebp),%eax
 614:	8b 50 04             	mov    0x4(%eax),%edx
 617:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61a:	8b 00                	mov    (%eax),%eax
 61c:	8b 40 04             	mov    0x4(%eax),%eax
 61f:	01 c2                	add    %eax,%edx
 621:	8b 45 f8             	mov    -0x8(%ebp),%eax
 624:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 627:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62a:	8b 00                	mov    (%eax),%eax
 62c:	8b 10                	mov    (%eax),%edx
 62e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 631:	89 10                	mov    %edx,(%eax)
 633:	eb 0a                	jmp    63f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
 638:	8b 10                	mov    (%eax),%edx
 63a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 63f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 642:	8b 40 04             	mov    0x4(%eax),%eax
 645:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	01 d0                	add    %edx,%eax
 651:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 654:	75 20                	jne    676 <free+0xcf>
    p->s.size += bp->s.size;
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 50 04             	mov    0x4(%eax),%edx
 65c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65f:	8b 40 04             	mov    0x4(%eax),%eax
 662:	01 c2                	add    %eax,%edx
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 66a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66d:	8b 10                	mov    (%eax),%edx
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	89 10                	mov    %edx,(%eax)
 674:	eb 08                	jmp    67e <free+0xd7>
  } else
    p->s.ptr = bp;
 676:	8b 45 fc             	mov    -0x4(%ebp),%eax
 679:	8b 55 f8             	mov    -0x8(%ebp),%edx
 67c:	89 10                	mov    %edx,(%eax)
  freep = p;
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	a3 40 0a 00 00       	mov    %eax,0xa40
}
 686:	90                   	nop
 687:	c9                   	leave
 688:	c3                   	ret

00000689 <morecore>:

static Header*
morecore(uint nu)
{
 689:	55                   	push   %ebp
 68a:	89 e5                	mov    %esp,%ebp
 68c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 68f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 696:	77 07                	ja     69f <morecore+0x16>
    nu = 4096;
 698:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 69f:	8b 45 08             	mov    0x8(%ebp),%eax
 6a2:	c1 e0 03             	shl    $0x3,%eax
 6a5:	83 ec 0c             	sub    $0xc,%esp
 6a8:	50                   	push   %eax
 6a9:	e8 63 fc ff ff       	call   311 <sbrk>
 6ae:	83 c4 10             	add    $0x10,%esp
 6b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6b4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6b8:	75 07                	jne    6c1 <morecore+0x38>
    return 0;
 6ba:	b8 00 00 00 00       	mov    $0x0,%eax
 6bf:	eb 26                	jmp    6e7 <morecore+0x5e>
  hp = (Header*)p;
 6c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ca:	8b 55 08             	mov    0x8(%ebp),%edx
 6cd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d3:	83 c0 08             	add    $0x8,%eax
 6d6:	83 ec 0c             	sub    $0xc,%esp
 6d9:	50                   	push   %eax
 6da:	e8 c8 fe ff ff       	call   5a7 <free>
 6df:	83 c4 10             	add    $0x10,%esp
  return freep;
 6e2:	a1 40 0a 00 00       	mov    0xa40,%eax
}
 6e7:	c9                   	leave
 6e8:	c3                   	ret

000006e9 <malloc>:

void*
malloc(uint nbytes)
{
 6e9:	55                   	push   %ebp
 6ea:	89 e5                	mov    %esp,%ebp
 6ec:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ef:	8b 45 08             	mov    0x8(%ebp),%eax
 6f2:	83 c0 07             	add    $0x7,%eax
 6f5:	c1 e8 03             	shr    $0x3,%eax
 6f8:	83 c0 01             	add    $0x1,%eax
 6fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6fe:	a1 40 0a 00 00       	mov    0xa40,%eax
 703:	89 45 f0             	mov    %eax,-0x10(%ebp)
 706:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 70a:	75 23                	jne    72f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 70c:	c7 45 f0 38 0a 00 00 	movl   $0xa38,-0x10(%ebp)
 713:	8b 45 f0             	mov    -0x10(%ebp),%eax
 716:	a3 40 0a 00 00       	mov    %eax,0xa40
 71b:	a1 40 0a 00 00       	mov    0xa40,%eax
 720:	a3 38 0a 00 00       	mov    %eax,0xa38
    base.s.size = 0;
 725:	c7 05 3c 0a 00 00 00 	movl   $0x0,0xa3c
 72c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 732:	8b 00                	mov    (%eax),%eax
 734:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 737:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73a:	8b 40 04             	mov    0x4(%eax),%eax
 73d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 740:	72 4d                	jb     78f <malloc+0xa6>
      if(p->s.size == nunits)
 742:	8b 45 f4             	mov    -0xc(%ebp),%eax
 745:	8b 40 04             	mov    0x4(%eax),%eax
 748:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 74b:	75 0c                	jne    759 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 74d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 750:	8b 10                	mov    (%eax),%edx
 752:	8b 45 f0             	mov    -0x10(%ebp),%eax
 755:	89 10                	mov    %edx,(%eax)
 757:	eb 26                	jmp    77f <malloc+0x96>
      else {
        p->s.size -= nunits;
 759:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75c:	8b 40 04             	mov    0x4(%eax),%eax
 75f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 762:	89 c2                	mov    %eax,%edx
 764:	8b 45 f4             	mov    -0xc(%ebp),%eax
 767:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 76a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76d:	8b 40 04             	mov    0x4(%eax),%eax
 770:	c1 e0 03             	shl    $0x3,%eax
 773:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 776:	8b 45 f4             	mov    -0xc(%ebp),%eax
 779:	8b 55 ec             	mov    -0x14(%ebp),%edx
 77c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 77f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 782:	a3 40 0a 00 00       	mov    %eax,0xa40
      return (void*)(p + 1);
 787:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78a:	83 c0 08             	add    $0x8,%eax
 78d:	eb 3b                	jmp    7ca <malloc+0xe1>
    }
    if(p == freep)
 78f:	a1 40 0a 00 00       	mov    0xa40,%eax
 794:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 797:	75 1e                	jne    7b7 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 799:	83 ec 0c             	sub    $0xc,%esp
 79c:	ff 75 ec             	push   -0x14(%ebp)
 79f:	e8 e5 fe ff ff       	call   689 <morecore>
 7a4:	83 c4 10             	add    $0x10,%esp
 7a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ae:	75 07                	jne    7b7 <malloc+0xce>
        return 0;
 7b0:	b8 00 00 00 00       	mov    $0x0,%eax
 7b5:	eb 13                	jmp    7ca <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c5:	e9 6d ff ff ff       	jmp    737 <malloc+0x4e>
  }
}
 7ca:	c9                   	leave
 7cb:	c3                   	ret
