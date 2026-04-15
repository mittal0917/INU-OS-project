
_hello:     file format elf32-i386


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
   e:	83 ec 04             	sub    $0x4,%esp
	printf(1, "Hello world!\n");
  11:	83 ec 08             	sub    $0x8,%esp
  14:	68 c2 07 00 00       	push   $0x7c2
  19:	6a 01                	push   $0x1
  1b:	e8 eb 03 00 00       	call   40b <printf>
  20:	83 c4 10             	add    $0x10,%esp
	exit();
  23:	e8 57 02 00 00       	call   27f <exit>

00000028 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	57                   	push   %edi
  2c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  30:	8b 55 10             	mov    0x10(%ebp),%edx
  33:	8b 45 0c             	mov    0xc(%ebp),%eax
  36:	89 cb                	mov    %ecx,%ebx
  38:	89 df                	mov    %ebx,%edi
  3a:	89 d1                	mov    %edx,%ecx
  3c:	fc                   	cld
  3d:	f3 aa                	rep stos %al,%es:(%edi)
  3f:	89 ca                	mov    %ecx,%edx
  41:	89 fb                	mov    %edi,%ebx
  43:	89 5d 08             	mov    %ebx,0x8(%ebp)
  46:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  49:	90                   	nop
  4a:	5b                   	pop    %ebx
  4b:	5f                   	pop    %edi
  4c:	5d                   	pop    %ebp
  4d:	c3                   	ret

0000004e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  4e:	55                   	push   %ebp
  4f:	89 e5                	mov    %esp,%ebp
  51:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  54:	8b 45 08             	mov    0x8(%ebp),%eax
  57:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5a:	90                   	nop
  5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  5e:	8d 42 01             	lea    0x1(%edx),%eax
  61:	89 45 0c             	mov    %eax,0xc(%ebp)
  64:	8b 45 08             	mov    0x8(%ebp),%eax
  67:	8d 48 01             	lea    0x1(%eax),%ecx
  6a:	89 4d 08             	mov    %ecx,0x8(%ebp)
  6d:	0f b6 12             	movzbl (%edx),%edx
  70:	88 10                	mov    %dl,(%eax)
  72:	0f b6 00             	movzbl (%eax),%eax
  75:	84 c0                	test   %al,%al
  77:	75 e2                	jne    5b <strcpy+0xd>
    ;
  return os;
  79:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7c:	c9                   	leave
  7d:	c3                   	ret

0000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  81:	eb 08                	jmp    8b <strcmp+0xd>
    p++, q++;
  83:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  87:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  8b:	8b 45 08             	mov    0x8(%ebp),%eax
  8e:	0f b6 00             	movzbl (%eax),%eax
  91:	84 c0                	test   %al,%al
  93:	74 10                	je     a5 <strcmp+0x27>
  95:	8b 45 08             	mov    0x8(%ebp),%eax
  98:	0f b6 10             	movzbl (%eax),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	0f b6 00             	movzbl (%eax),%eax
  a1:	38 c2                	cmp    %al,%dl
  a3:	74 de                	je     83 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	0f b6 00             	movzbl (%eax),%eax
  ab:	0f b6 d0             	movzbl %al,%edx
  ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  b1:	0f b6 00             	movzbl (%eax),%eax
  b4:	0f b6 c0             	movzbl %al,%eax
  b7:	29 c2                	sub    %eax,%edx
  b9:	89 d0                	mov    %edx,%eax
}
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret

000000bd <strlen>:

uint
strlen(char *s)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  c0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ca:	eb 04                	jmp    d0 <strlen+0x13>
  cc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	01 d0                	add    %edx,%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	75 ed                	jne    cc <strlen+0xf>
    ;
  return n;
  df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e2:	c9                   	leave
  e3:	c3                   	ret

000000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e7:	8b 45 10             	mov    0x10(%ebp),%eax
  ea:	50                   	push   %eax
  eb:	ff 75 0c             	push   0xc(%ebp)
  ee:	ff 75 08             	push   0x8(%ebp)
  f1:	e8 32 ff ff ff       	call   28 <stosb>
  f6:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  fc:	c9                   	leave
  fd:	c3                   	ret

000000fe <strchr>:

char*
strchr(const char *s, char c)
{
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	83 ec 04             	sub    $0x4,%esp
 104:	8b 45 0c             	mov    0xc(%ebp),%eax
 107:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10a:	eb 14                	jmp    120 <strchr+0x22>
    if(*s == c)
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	38 45 fc             	cmp    %al,-0x4(%ebp)
 115:	75 05                	jne    11c <strchr+0x1e>
      return (char*)s;
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	eb 13                	jmp    12f <strchr+0x31>
  for(; *s; s++)
 11c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	0f b6 00             	movzbl (%eax),%eax
 126:	84 c0                	test   %al,%al
 128:	75 e2                	jne    10c <strchr+0xe>
  return 0;
 12a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12f:	c9                   	leave
 130:	c3                   	ret

00000131 <gets>:

char*
gets(char *buf, int max)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 137:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13e:	eb 42                	jmp    182 <gets+0x51>
    cc = read(0, &c, 1);
 140:	83 ec 04             	sub    $0x4,%esp
 143:	6a 01                	push   $0x1
 145:	8d 45 ef             	lea    -0x11(%ebp),%eax
 148:	50                   	push   %eax
 149:	6a 00                	push   $0x0
 14b:	e8 47 01 00 00       	call   297 <read>
 150:	83 c4 10             	add    $0x10,%esp
 153:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 156:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15a:	7e 33                	jle    18f <gets+0x5e>
      break;
    buf[i++] = c;
 15c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15f:	8d 50 01             	lea    0x1(%eax),%edx
 162:	89 55 f4             	mov    %edx,-0xc(%ebp)
 165:	89 c2                	mov    %eax,%edx
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	01 c2                	add    %eax,%edx
 16c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 170:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 172:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 176:	3c 0a                	cmp    $0xa,%al
 178:	74 16                	je     190 <gets+0x5f>
 17a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17e:	3c 0d                	cmp    $0xd,%al
 180:	74 0e                	je     190 <gets+0x5f>
  for(i=0; i+1 < max; ){
 182:	8b 45 f4             	mov    -0xc(%ebp),%eax
 185:	83 c0 01             	add    $0x1,%eax
 188:	39 45 0c             	cmp    %eax,0xc(%ebp)
 18b:	7f b3                	jg     140 <gets+0xf>
 18d:	eb 01                	jmp    190 <gets+0x5f>
      break;
 18f:	90                   	nop
      break;
  }
  buf[i] = '\0';
 190:	8b 55 f4             	mov    -0xc(%ebp),%edx
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	01 d0                	add    %edx,%eax
 198:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19e:	c9                   	leave
 19f:	c3                   	ret

000001a0 <stat>:

int
stat(char *n, struct stat *st)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a6:	83 ec 08             	sub    $0x8,%esp
 1a9:	6a 00                	push   $0x0
 1ab:	ff 75 08             	push   0x8(%ebp)
 1ae:	e8 0c 01 00 00       	call   2bf <open>
 1b3:	83 c4 10             	add    $0x10,%esp
 1b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1bd:	79 07                	jns    1c6 <stat+0x26>
    return -1;
 1bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c4:	eb 25                	jmp    1eb <stat+0x4b>
  r = fstat(fd, st);
 1c6:	83 ec 08             	sub    $0x8,%esp
 1c9:	ff 75 0c             	push   0xc(%ebp)
 1cc:	ff 75 f4             	push   -0xc(%ebp)
 1cf:	e8 03 01 00 00       	call   2d7 <fstat>
 1d4:	83 c4 10             	add    $0x10,%esp
 1d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1da:	83 ec 0c             	sub    $0xc,%esp
 1dd:	ff 75 f4             	push   -0xc(%ebp)
 1e0:	e8 c2 00 00 00       	call   2a7 <close>
 1e5:	83 c4 10             	add    $0x10,%esp
  return r;
 1e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1eb:	c9                   	leave
 1ec:	c3                   	ret

000001ed <atoi>:

int
atoi(const char *s)
{
 1ed:	55                   	push   %ebp
 1ee:	89 e5                	mov    %esp,%ebp
 1f0:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fa:	eb 25                	jmp    221 <atoi+0x34>
    n = n*10 + *s++ - '0';
 1fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ff:	89 d0                	mov    %edx,%eax
 201:	c1 e0 02             	shl    $0x2,%eax
 204:	01 d0                	add    %edx,%eax
 206:	01 c0                	add    %eax,%eax
 208:	89 c1                	mov    %eax,%ecx
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	8d 50 01             	lea    0x1(%eax),%edx
 210:	89 55 08             	mov    %edx,0x8(%ebp)
 213:	0f b6 00             	movzbl (%eax),%eax
 216:	0f be c0             	movsbl %al,%eax
 219:	01 c8                	add    %ecx,%eax
 21b:	83 e8 30             	sub    $0x30,%eax
 21e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	0f b6 00             	movzbl (%eax),%eax
 227:	3c 2f                	cmp    $0x2f,%al
 229:	7e 0a                	jle    235 <atoi+0x48>
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	0f b6 00             	movzbl (%eax),%eax
 231:	3c 39                	cmp    $0x39,%al
 233:	7e c7                	jle    1fc <atoi+0xf>
  return n;
 235:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 238:	c9                   	leave
 239:	c3                   	ret

0000023a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 23a:	55                   	push   %ebp
 23b:	89 e5                	mov    %esp,%ebp
 23d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 246:	8b 45 0c             	mov    0xc(%ebp),%eax
 249:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 24c:	eb 17                	jmp    265 <memmove+0x2b>
    *dst++ = *src++;
 24e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 251:	8d 42 01             	lea    0x1(%edx),%eax
 254:	89 45 f8             	mov    %eax,-0x8(%ebp)
 257:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25a:	8d 48 01             	lea    0x1(%eax),%ecx
 25d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 260:	0f b6 12             	movzbl (%edx),%edx
 263:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 265:	8b 45 10             	mov    0x10(%ebp),%eax
 268:	8d 50 ff             	lea    -0x1(%eax),%edx
 26b:	89 55 10             	mov    %edx,0x10(%ebp)
 26e:	85 c0                	test   %eax,%eax
 270:	7f dc                	jg     24e <memmove+0x14>
  return vdst;
 272:	8b 45 08             	mov    0x8(%ebp),%eax
}
 275:	c9                   	leave
 276:	c3                   	ret

00000277 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 277:	b8 01 00 00 00       	mov    $0x1,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret

0000027f <exit>:
SYSCALL(exit)
 27f:	b8 02 00 00 00       	mov    $0x2,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret

00000287 <wait>:
SYSCALL(wait)
 287:	b8 03 00 00 00       	mov    $0x3,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret

0000028f <pipe>:
SYSCALL(pipe)
 28f:	b8 04 00 00 00       	mov    $0x4,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret

00000297 <read>:
SYSCALL(read)
 297:	b8 05 00 00 00       	mov    $0x5,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret

0000029f <write>:
SYSCALL(write)
 29f:	b8 10 00 00 00       	mov    $0x10,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret

000002a7 <close>:
SYSCALL(close)
 2a7:	b8 15 00 00 00       	mov    $0x15,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret

000002af <kill>:
SYSCALL(kill)
 2af:	b8 06 00 00 00       	mov    $0x6,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret

000002b7 <exec>:
SYSCALL(exec)
 2b7:	b8 07 00 00 00       	mov    $0x7,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret

000002bf <open>:
SYSCALL(open)
 2bf:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret

000002c7 <mknod>:
SYSCALL(mknod)
 2c7:	b8 11 00 00 00       	mov    $0x11,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret

000002cf <unlink>:
SYSCALL(unlink)
 2cf:	b8 12 00 00 00       	mov    $0x12,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret

000002d7 <fstat>:
SYSCALL(fstat)
 2d7:	b8 08 00 00 00       	mov    $0x8,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret

000002df <link>:
SYSCALL(link)
 2df:	b8 13 00 00 00       	mov    $0x13,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret

000002e7 <mkdir>:
SYSCALL(mkdir)
 2e7:	b8 14 00 00 00       	mov    $0x14,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret

000002ef <chdir>:
SYSCALL(chdir)
 2ef:	b8 09 00 00 00       	mov    $0x9,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret

000002f7 <dup>:
SYSCALL(dup)
 2f7:	b8 0a 00 00 00       	mov    $0xa,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret

000002ff <getpid>:
SYSCALL(getpid)
 2ff:	b8 0b 00 00 00       	mov    $0xb,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret

00000307 <sbrk>:
SYSCALL(sbrk)
 307:	b8 0c 00 00 00       	mov    $0xc,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret

0000030f <sleep>:
SYSCALL(sleep)
 30f:	b8 0d 00 00 00       	mov    $0xd,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret

00000317 <uptime>:
SYSCALL(uptime)
 317:	b8 0e 00 00 00       	mov    $0xe,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret

0000031f <wait2>:
SYSCALL(wait2)
 31f:	b8 17 00 00 00       	mov    $0x17,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret

00000327 <exit2>:
SYSCALL(exit2)
 327:	b8 16 00 00 00       	mov    $0x16,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret

0000032f <uthread_init>:
 32f:	b8 18 00 00 00       	mov    $0x18,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret

00000337 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 337:	55                   	push   %ebp
 338:	89 e5                	mov    %esp,%ebp
 33a:	83 ec 18             	sub    $0x18,%esp
 33d:	8b 45 0c             	mov    0xc(%ebp),%eax
 340:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 343:	83 ec 04             	sub    $0x4,%esp
 346:	6a 01                	push   $0x1
 348:	8d 45 f4             	lea    -0xc(%ebp),%eax
 34b:	50                   	push   %eax
 34c:	ff 75 08             	push   0x8(%ebp)
 34f:	e8 4b ff ff ff       	call   29f <write>
 354:	83 c4 10             	add    $0x10,%esp
}
 357:	90                   	nop
 358:	c9                   	leave
 359:	c3                   	ret

0000035a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 35a:	55                   	push   %ebp
 35b:	89 e5                	mov    %esp,%ebp
 35d:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 360:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 367:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 36b:	74 17                	je     384 <printint+0x2a>
 36d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 371:	79 11                	jns    384 <printint+0x2a>
    neg = 1;
 373:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	f7 d8                	neg    %eax
 37f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 382:	eb 06                	jmp    38a <printint+0x30>
  } else {
    x = xx;
 384:	8b 45 0c             	mov    0xc(%ebp),%eax
 387:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 38a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 391:	8b 4d 10             	mov    0x10(%ebp),%ecx
 394:	8b 45 ec             	mov    -0x14(%ebp),%eax
 397:	ba 00 00 00 00       	mov    $0x0,%edx
 39c:	f7 f1                	div    %ecx
 39e:	89 d1                	mov    %edx,%ecx
 3a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a3:	8d 50 01             	lea    0x1(%eax),%edx
 3a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3a9:	0f b6 91 1c 0a 00 00 	movzbl 0xa1c(%ecx),%edx
 3b0:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 3b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ba:	ba 00 00 00 00       	mov    $0x0,%edx
 3bf:	f7 f1                	div    %ecx
 3c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3c8:	75 c7                	jne    391 <printint+0x37>
  if(neg)
 3ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3ce:	74 2d                	je     3fd <printint+0xa3>
    buf[i++] = '-';
 3d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d3:	8d 50 01             	lea    0x1(%eax),%edx
 3d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3d9:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3de:	eb 1d                	jmp    3fd <printint+0xa3>
    putc(fd, buf[i]);
 3e0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e6:	01 d0                	add    %edx,%eax
 3e8:	0f b6 00             	movzbl (%eax),%eax
 3eb:	0f be c0             	movsbl %al,%eax
 3ee:	83 ec 08             	sub    $0x8,%esp
 3f1:	50                   	push   %eax
 3f2:	ff 75 08             	push   0x8(%ebp)
 3f5:	e8 3d ff ff ff       	call   337 <putc>
 3fa:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 3fd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 401:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 405:	79 d9                	jns    3e0 <printint+0x86>
}
 407:	90                   	nop
 408:	90                   	nop
 409:	c9                   	leave
 40a:	c3                   	ret

0000040b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 40b:	55                   	push   %ebp
 40c:	89 e5                	mov    %esp,%ebp
 40e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 411:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 418:	8d 45 0c             	lea    0xc(%ebp),%eax
 41b:	83 c0 04             	add    $0x4,%eax
 41e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 421:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 428:	e9 59 01 00 00       	jmp    586 <printf+0x17b>
    c = fmt[i] & 0xff;
 42d:	8b 55 0c             	mov    0xc(%ebp),%edx
 430:	8b 45 f0             	mov    -0x10(%ebp),%eax
 433:	01 d0                	add    %edx,%eax
 435:	0f b6 00             	movzbl (%eax),%eax
 438:	0f be c0             	movsbl %al,%eax
 43b:	25 ff 00 00 00       	and    $0xff,%eax
 440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 443:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 447:	75 2c                	jne    475 <printf+0x6a>
      if(c == '%'){
 449:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 44d:	75 0c                	jne    45b <printf+0x50>
        state = '%';
 44f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 456:	e9 27 01 00 00       	jmp    582 <printf+0x177>
      } else {
        putc(fd, c);
 45b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 45e:	0f be c0             	movsbl %al,%eax
 461:	83 ec 08             	sub    $0x8,%esp
 464:	50                   	push   %eax
 465:	ff 75 08             	push   0x8(%ebp)
 468:	e8 ca fe ff ff       	call   337 <putc>
 46d:	83 c4 10             	add    $0x10,%esp
 470:	e9 0d 01 00 00       	jmp    582 <printf+0x177>
      }
    } else if(state == '%'){
 475:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 479:	0f 85 03 01 00 00    	jne    582 <printf+0x177>
      if(c == 'd'){
 47f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 483:	75 1e                	jne    4a3 <printf+0x98>
        printint(fd, *ap, 10, 1);
 485:	8b 45 e8             	mov    -0x18(%ebp),%eax
 488:	8b 00                	mov    (%eax),%eax
 48a:	6a 01                	push   $0x1
 48c:	6a 0a                	push   $0xa
 48e:	50                   	push   %eax
 48f:	ff 75 08             	push   0x8(%ebp)
 492:	e8 c3 fe ff ff       	call   35a <printint>
 497:	83 c4 10             	add    $0x10,%esp
        ap++;
 49a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 49e:	e9 d8 00 00 00       	jmp    57b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4a3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4a7:	74 06                	je     4af <printf+0xa4>
 4a9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4ad:	75 1e                	jne    4cd <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b2:	8b 00                	mov    (%eax),%eax
 4b4:	6a 00                	push   $0x0
 4b6:	6a 10                	push   $0x10
 4b8:	50                   	push   %eax
 4b9:	ff 75 08             	push   0x8(%ebp)
 4bc:	e8 99 fe ff ff       	call   35a <printint>
 4c1:	83 c4 10             	add    $0x10,%esp
        ap++;
 4c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c8:	e9 ae 00 00 00       	jmp    57b <printf+0x170>
      } else if(c == 's'){
 4cd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4d1:	75 43                	jne    516 <printf+0x10b>
        s = (char*)*ap;
 4d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d6:	8b 00                	mov    (%eax),%eax
 4d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e3:	75 25                	jne    50a <printf+0xff>
          s = "(null)";
 4e5:	c7 45 f4 d0 07 00 00 	movl   $0x7d0,-0xc(%ebp)
        while(*s != 0){
 4ec:	eb 1c                	jmp    50a <printf+0xff>
          putc(fd, *s);
 4ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f1:	0f b6 00             	movzbl (%eax),%eax
 4f4:	0f be c0             	movsbl %al,%eax
 4f7:	83 ec 08             	sub    $0x8,%esp
 4fa:	50                   	push   %eax
 4fb:	ff 75 08             	push   0x8(%ebp)
 4fe:	e8 34 fe ff ff       	call   337 <putc>
 503:	83 c4 10             	add    $0x10,%esp
          s++;
 506:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 50a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50d:	0f b6 00             	movzbl (%eax),%eax
 510:	84 c0                	test   %al,%al
 512:	75 da                	jne    4ee <printf+0xe3>
 514:	eb 65                	jmp    57b <printf+0x170>
        }
      } else if(c == 'c'){
 516:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 51a:	75 1d                	jne    539 <printf+0x12e>
        putc(fd, *ap);
 51c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51f:	8b 00                	mov    (%eax),%eax
 521:	0f be c0             	movsbl %al,%eax
 524:	83 ec 08             	sub    $0x8,%esp
 527:	50                   	push   %eax
 528:	ff 75 08             	push   0x8(%ebp)
 52b:	e8 07 fe ff ff       	call   337 <putc>
 530:	83 c4 10             	add    $0x10,%esp
        ap++;
 533:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 537:	eb 42                	jmp    57b <printf+0x170>
      } else if(c == '%'){
 539:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 53d:	75 17                	jne    556 <printf+0x14b>
        putc(fd, c);
 53f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 542:	0f be c0             	movsbl %al,%eax
 545:	83 ec 08             	sub    $0x8,%esp
 548:	50                   	push   %eax
 549:	ff 75 08             	push   0x8(%ebp)
 54c:	e8 e6 fd ff ff       	call   337 <putc>
 551:	83 c4 10             	add    $0x10,%esp
 554:	eb 25                	jmp    57b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 556:	83 ec 08             	sub    $0x8,%esp
 559:	6a 25                	push   $0x25
 55b:	ff 75 08             	push   0x8(%ebp)
 55e:	e8 d4 fd ff ff       	call   337 <putc>
 563:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 566:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 569:	0f be c0             	movsbl %al,%eax
 56c:	83 ec 08             	sub    $0x8,%esp
 56f:	50                   	push   %eax
 570:	ff 75 08             	push   0x8(%ebp)
 573:	e8 bf fd ff ff       	call   337 <putc>
 578:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 57b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 582:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 586:	8b 55 0c             	mov    0xc(%ebp),%edx
 589:	8b 45 f0             	mov    -0x10(%ebp),%eax
 58c:	01 d0                	add    %edx,%eax
 58e:	0f b6 00             	movzbl (%eax),%eax
 591:	84 c0                	test   %al,%al
 593:	0f 85 94 fe ff ff    	jne    42d <printf+0x22>
    }
  }
}
 599:	90                   	nop
 59a:	90                   	nop
 59b:	c9                   	leave
 59c:	c3                   	ret

0000059d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 59d:	55                   	push   %ebp
 59e:	89 e5                	mov    %esp,%ebp
 5a0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5a3:	8b 45 08             	mov    0x8(%ebp),%eax
 5a6:	83 e8 08             	sub    $0x8,%eax
 5a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ac:	a1 38 0a 00 00       	mov    0xa38,%eax
 5b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5b4:	eb 24                	jmp    5da <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b9:	8b 00                	mov    (%eax),%eax
 5bb:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5be:	72 12                	jb     5d2 <free+0x35>
 5c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5c3:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5c6:	72 24                	jb     5ec <free+0x4f>
 5c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5cb:	8b 00                	mov    (%eax),%eax
 5cd:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 5d0:	72 1a                	jb     5ec <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d5:	8b 00                	mov    (%eax),%eax
 5d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5dd:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 5e0:	73 d4                	jae    5b6 <free+0x19>
 5e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e5:	8b 00                	mov    (%eax),%eax
 5e7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 5ea:	73 ca                	jae    5b6 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ef:	8b 40 04             	mov    0x4(%eax),%eax
 5f2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 5f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fc:	01 c2                	add    %eax,%edx
 5fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 601:	8b 00                	mov    (%eax),%eax
 603:	39 c2                	cmp    %eax,%edx
 605:	75 24                	jne    62b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 607:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60a:	8b 50 04             	mov    0x4(%eax),%edx
 60d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 610:	8b 00                	mov    (%eax),%eax
 612:	8b 40 04             	mov    0x4(%eax),%eax
 615:	01 c2                	add    %eax,%edx
 617:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	8b 10                	mov    (%eax),%edx
 624:	8b 45 f8             	mov    -0x8(%ebp),%eax
 627:	89 10                	mov    %edx,(%eax)
 629:	eb 0a                	jmp    635 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 62b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62e:	8b 10                	mov    (%eax),%edx
 630:	8b 45 f8             	mov    -0x8(%ebp),%eax
 633:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
 638:	8b 40 04             	mov    0x4(%eax),%eax
 63b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 642:	8b 45 fc             	mov    -0x4(%ebp),%eax
 645:	01 d0                	add    %edx,%eax
 647:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 64a:	75 20                	jne    66c <free+0xcf>
    p->s.size += bp->s.size;
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 50 04             	mov    0x4(%eax),%edx
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	8b 40 04             	mov    0x4(%eax),%eax
 658:	01 c2                	add    %eax,%edx
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	8b 10                	mov    (%eax),%edx
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	89 10                	mov    %edx,(%eax)
 66a:	eb 08                	jmp    674 <free+0xd7>
  } else
    p->s.ptr = bp;
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 672:	89 10                	mov    %edx,(%eax)
  freep = p;
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	a3 38 0a 00 00       	mov    %eax,0xa38
}
 67c:	90                   	nop
 67d:	c9                   	leave
 67e:	c3                   	ret

0000067f <morecore>:

static Header*
morecore(uint nu)
{
 67f:	55                   	push   %ebp
 680:	89 e5                	mov    %esp,%ebp
 682:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 685:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 68c:	77 07                	ja     695 <morecore+0x16>
    nu = 4096;
 68e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 695:	8b 45 08             	mov    0x8(%ebp),%eax
 698:	c1 e0 03             	shl    $0x3,%eax
 69b:	83 ec 0c             	sub    $0xc,%esp
 69e:	50                   	push   %eax
 69f:	e8 63 fc ff ff       	call   307 <sbrk>
 6a4:	83 c4 10             	add    $0x10,%esp
 6a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6aa:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6ae:	75 07                	jne    6b7 <morecore+0x38>
    return 0;
 6b0:	b8 00 00 00 00       	mov    $0x0,%eax
 6b5:	eb 26                	jmp    6dd <morecore+0x5e>
  hp = (Header*)p;
 6b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c0:	8b 55 08             	mov    0x8(%ebp),%edx
 6c3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c9:	83 c0 08             	add    $0x8,%eax
 6cc:	83 ec 0c             	sub    $0xc,%esp
 6cf:	50                   	push   %eax
 6d0:	e8 c8 fe ff ff       	call   59d <free>
 6d5:	83 c4 10             	add    $0x10,%esp
  return freep;
 6d8:	a1 38 0a 00 00       	mov    0xa38,%eax
}
 6dd:	c9                   	leave
 6de:	c3                   	ret

000006df <malloc>:

void*
malloc(uint nbytes)
{
 6df:	55                   	push   %ebp
 6e0:	89 e5                	mov    %esp,%ebp
 6e2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e5:	8b 45 08             	mov    0x8(%ebp),%eax
 6e8:	83 c0 07             	add    $0x7,%eax
 6eb:	c1 e8 03             	shr    $0x3,%eax
 6ee:	83 c0 01             	add    $0x1,%eax
 6f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6f4:	a1 38 0a 00 00       	mov    0xa38,%eax
 6f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 700:	75 23                	jne    725 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 702:	c7 45 f0 30 0a 00 00 	movl   $0xa30,-0x10(%ebp)
 709:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70c:	a3 38 0a 00 00       	mov    %eax,0xa38
 711:	a1 38 0a 00 00       	mov    0xa38,%eax
 716:	a3 30 0a 00 00       	mov    %eax,0xa30
    base.s.size = 0;
 71b:	c7 05 34 0a 00 00 00 	movl   $0x0,0xa34
 722:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 725:	8b 45 f0             	mov    -0x10(%ebp),%eax
 728:	8b 00                	mov    (%eax),%eax
 72a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 72d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 730:	8b 40 04             	mov    0x4(%eax),%eax
 733:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 736:	72 4d                	jb     785 <malloc+0xa6>
      if(p->s.size == nunits)
 738:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73b:	8b 40 04             	mov    0x4(%eax),%eax
 73e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 741:	75 0c                	jne    74f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 743:	8b 45 f4             	mov    -0xc(%ebp),%eax
 746:	8b 10                	mov    (%eax),%edx
 748:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74b:	89 10                	mov    %edx,(%eax)
 74d:	eb 26                	jmp    775 <malloc+0x96>
      else {
        p->s.size -= nunits;
 74f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 752:	8b 40 04             	mov    0x4(%eax),%eax
 755:	2b 45 ec             	sub    -0x14(%ebp),%eax
 758:	89 c2                	mov    %eax,%edx
 75a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 760:	8b 45 f4             	mov    -0xc(%ebp),%eax
 763:	8b 40 04             	mov    0x4(%eax),%eax
 766:	c1 e0 03             	shl    $0x3,%eax
 769:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 76c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 772:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 775:	8b 45 f0             	mov    -0x10(%ebp),%eax
 778:	a3 38 0a 00 00       	mov    %eax,0xa38
      return (void*)(p + 1);
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	83 c0 08             	add    $0x8,%eax
 783:	eb 3b                	jmp    7c0 <malloc+0xe1>
    }
    if(p == freep)
 785:	a1 38 0a 00 00       	mov    0xa38,%eax
 78a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 78d:	75 1e                	jne    7ad <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 78f:	83 ec 0c             	sub    $0xc,%esp
 792:	ff 75 ec             	push   -0x14(%ebp)
 795:	e8 e5 fe ff ff       	call   67f <morecore>
 79a:	83 c4 10             	add    $0x10,%esp
 79d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7a4:	75 07                	jne    7ad <malloc+0xce>
        return 0;
 7a6:	b8 00 00 00 00       	mov    $0x0,%eax
 7ab:	eb 13                	jmp    7c0 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	8b 00                	mov    (%eax),%eax
 7b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7bb:	e9 6d ff ff ff       	jmp    72d <malloc+0x4e>
  }
}
 7c0:	c9                   	leave
 7c1:	c3                   	ret
