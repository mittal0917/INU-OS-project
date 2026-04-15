
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 0e 08 00 00       	push   $0x80e
  1e:	6a 02                	push   $0x2
  20:	e8 32 04 00 00       	call   457 <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 9e 02 00 00       	call   2cb <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 e4 02 00 00       	call   32b <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 21 08 00 00       	push   $0x821
  65:	6a 02                	push   $0x2
  67:	e8 eb 03 00 00       	call   457 <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 57 02 00 00       	call   2cb <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	90                   	nop
  96:	5b                   	pop    %ebx
  97:	5f                   	pop    %edi
  98:	5d                   	pop    %ebp
  99:	c3                   	ret

0000009a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a6:	90                   	nop
  a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  aa:	8d 42 01             	lea    0x1(%edx),%eax
  ad:	89 45 0c             	mov    %eax,0xc(%ebp)
  b0:	8b 45 08             	mov    0x8(%ebp),%eax
  b3:	8d 48 01             	lea    0x1(%eax),%ecx
  b6:	89 4d 08             	mov    %ecx,0x8(%ebp)
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	88 10                	mov    %dl,(%eax)
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 e2                	jne    a7 <strcpy+0xd>
    ;
  return os;
  c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c8:	c9                   	leave
  c9:	c3                   	ret

000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cd:	eb 08                	jmp    d7 <strcmp+0xd>
    p++, q++;
  cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 10                	je     f1 <strcmp+0x27>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 de                	je     cf <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 d0             	movzbl %al,%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 c0             	movzbl %al,%eax
 103:	29 c2                	sub    %eax,%edx
 105:	89 d0                	mov    %edx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret

00000109 <strlen>:

uint
strlen(char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 116:	eb 04                	jmp    11c <strlen+0x13>
 118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	01 d0                	add    %edx,%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 ed                	jne    118 <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave
 12f:	c3                   	ret

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	50                   	push   %eax
 137:	ff 75 0c             	push   0xc(%ebp)
 13a:	ff 75 08             	push   0x8(%ebp)
 13d:	e8 32 ff ff ff       	call   74 <stosb>
 142:	83 c4 0c             	add    $0xc,%esp
  return dst;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
}
 148:	c9                   	leave
 149:	c3                   	ret

0000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 156:	eb 14                	jmp    16c <strchr+0x22>
    if(*s == c)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	38 45 fc             	cmp    %al,-0x4(%ebp)
 161:	75 05                	jne    168 <strchr+0x1e>
      return (char*)s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
  for(; *s; s++)
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	c9                   	leave
 17c:	c3                   	ret

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18a:	eb 42                	jmp    1ce <gets+0x51>
    cc = read(0, &c, 1);
 18c:	83 ec 04             	sub    $0x4,%esp
 18f:	6a 01                	push   $0x1
 191:	8d 45 ef             	lea    -0x11(%ebp),%eax
 194:	50                   	push   %eax
 195:	6a 00                	push   $0x0
 197:	e8 47 01 00 00       	call   2e3 <read>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a6:	7e 33                	jle    1db <gets+0x5e>
      break;
    buf[i++] = c;
 1a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ab:	8d 50 01             	lea    0x1(%eax),%edx
 1ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b1:	89 c2                	mov    %eax,%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 c2                	add    %eax,%edx
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0a                	cmp    $0xa,%al
 1c4:	74 16                	je     1dc <gets+0x5f>
 1c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ca:	3c 0d                	cmp    $0xd,%al
 1cc:	74 0e                	je     1dc <gets+0x5f>
  for(i=0; i+1 < max; ){
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	83 c0 01             	add    $0x1,%eax
 1d4:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1d7:	7f b3                	jg     18c <gets+0xf>
 1d9:	eb 01                	jmp    1dc <gets+0x5f>
      break;
 1db:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	01 d0                	add    %edx,%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave
 1eb:	c3                   	ret

000001ec <stat>:

int
stat(char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	83 ec 08             	sub    $0x8,%esp
 1f5:	6a 00                	push   $0x0
 1f7:	ff 75 08             	push   0x8(%ebp)
 1fa:	e8 0c 01 00 00       	call   30b <open>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 209:	79 07                	jns    212 <stat+0x26>
    return -1;
 20b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 210:	eb 25                	jmp    237 <stat+0x4b>
  r = fstat(fd, st);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	ff 75 0c             	push   0xc(%ebp)
 218:	ff 75 f4             	push   -0xc(%ebp)
 21b:	e8 03 01 00 00       	call   323 <fstat>
 220:	83 c4 10             	add    $0x10,%esp
 223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 226:	83 ec 0c             	sub    $0xc,%esp
 229:	ff 75 f4             	push   -0xc(%ebp)
 22c:	e8 c2 00 00 00       	call   2f3 <close>
 231:	83 c4 10             	add    $0x10,%esp
  return r;
 234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 237:	c9                   	leave
 238:	c3                   	ret

00000239 <atoi>:

int
atoi(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 246:	eb 25                	jmp    26d <atoi+0x34>
    n = n*10 + *s++ - '0';
 248:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24b:	89 d0                	mov    %edx,%eax
 24d:	c1 e0 02             	shl    $0x2,%eax
 250:	01 d0                	add    %edx,%eax
 252:	01 c0                	add    %eax,%eax
 254:	89 c1                	mov    %eax,%ecx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 08             	mov    %edx,0x8(%ebp)
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	0f be c0             	movsbl %al,%eax
 265:	01 c8                	add    %ecx,%eax
 267:	83 e8 30             	sub    $0x30,%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x48>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c7                	jle    248 <atoi+0xf>
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave
 285:	c3                   	ret

00000286 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 298:	eb 17                	jmp    2b1 <memmove+0x2b>
    *dst++ = *src++;
 29a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29d:	8d 42 01             	lea    0x1(%edx),%eax
 2a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a6:	8d 48 01             	lea    0x1(%eax),%ecx
 2a9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2ac:	0f b6 12             	movzbl (%edx),%edx
 2af:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2b1:	8b 45 10             	mov    0x10(%ebp),%eax
 2b4:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b7:	89 55 10             	mov    %edx,0x10(%ebp)
 2ba:	85 c0                	test   %eax,%eax
 2bc:	7f dc                	jg     29a <memmove+0x14>
  return vdst;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave
 2c2:	c3                   	ret

000002c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c3:	b8 01 00 00 00       	mov    $0x1,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <exit>:
SYSCALL(exit)
 2cb:	b8 02 00 00 00       	mov    $0x2,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <wait>:
SYSCALL(wait)
 2d3:	b8 03 00 00 00       	mov    $0x3,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <pipe>:
SYSCALL(pipe)
 2db:	b8 04 00 00 00       	mov    $0x4,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <read>:
SYSCALL(read)
 2e3:	b8 05 00 00 00       	mov    $0x5,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <write>:
SYSCALL(write)
 2eb:	b8 10 00 00 00       	mov    $0x10,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <close>:
SYSCALL(close)
 2f3:	b8 15 00 00 00       	mov    $0x15,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <kill>:
SYSCALL(kill)
 2fb:	b8 06 00 00 00       	mov    $0x6,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <exec>:
SYSCALL(exec)
 303:	b8 07 00 00 00       	mov    $0x7,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <open>:
SYSCALL(open)
 30b:	b8 0f 00 00 00       	mov    $0xf,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <mknod>:
SYSCALL(mknod)
 313:	b8 11 00 00 00       	mov    $0x11,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <unlink>:
SYSCALL(unlink)
 31b:	b8 12 00 00 00       	mov    $0x12,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <fstat>:
SYSCALL(fstat)
 323:	b8 08 00 00 00       	mov    $0x8,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <link>:
SYSCALL(link)
 32b:	b8 13 00 00 00       	mov    $0x13,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <mkdir>:
SYSCALL(mkdir)
 333:	b8 14 00 00 00       	mov    $0x14,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <chdir>:
SYSCALL(chdir)
 33b:	b8 09 00 00 00       	mov    $0x9,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <dup>:
SYSCALL(dup)
 343:	b8 0a 00 00 00       	mov    $0xa,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <getpid>:
SYSCALL(getpid)
 34b:	b8 0b 00 00 00       	mov    $0xb,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <sbrk>:
SYSCALL(sbrk)
 353:	b8 0c 00 00 00       	mov    $0xc,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <sleep>:
SYSCALL(sleep)
 35b:	b8 0d 00 00 00       	mov    $0xd,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <uptime>:
SYSCALL(uptime)
 363:	b8 0e 00 00 00       	mov    $0xe,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <wait2>:
SYSCALL(wait2)
 36b:	b8 17 00 00 00       	mov    $0x17,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <exit2>:
SYSCALL(exit2)
 373:	b8 16 00 00 00       	mov    $0x16,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <uthread_init>:
 37b:	b8 18 00 00 00       	mov    $0x18,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret

00000383 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 383:	55                   	push   %ebp
 384:	89 e5                	mov    %esp,%ebp
 386:	83 ec 18             	sub    $0x18,%esp
 389:	8b 45 0c             	mov    0xc(%ebp),%eax
 38c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 38f:	83 ec 04             	sub    $0x4,%esp
 392:	6a 01                	push   $0x1
 394:	8d 45 f4             	lea    -0xc(%ebp),%eax
 397:	50                   	push   %eax
 398:	ff 75 08             	push   0x8(%ebp)
 39b:	e8 4b ff ff ff       	call   2eb <write>
 3a0:	83 c4 10             	add    $0x10,%esp
}
 3a3:	90                   	nop
 3a4:	c9                   	leave
 3a5:	c3                   	ret

000003a6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a6:	55                   	push   %ebp
 3a7:	89 e5                	mov    %esp,%ebp
 3a9:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b7:	74 17                	je     3d0 <printint+0x2a>
 3b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3bd:	79 11                	jns    3d0 <printint+0x2a>
    neg = 1;
 3bf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c9:	f7 d8                	neg    %eax
 3cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ce:	eb 06                	jmp    3d6 <printint+0x30>
  } else {
    x = xx;
 3d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e3:	ba 00 00 00 00       	mov    $0x0,%edx
 3e8:	f7 f1                	div    %ecx
 3ea:	89 d1                	mov    %edx,%ecx
 3ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ef:	8d 50 01             	lea    0x1(%eax),%edx
 3f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3f5:	0f b6 91 84 0a 00 00 	movzbl 0xa84(%ecx),%edx
 3fc:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 400:	8b 4d 10             	mov    0x10(%ebp),%ecx
 403:	8b 45 ec             	mov    -0x14(%ebp),%eax
 406:	ba 00 00 00 00       	mov    $0x0,%edx
 40b:	f7 f1                	div    %ecx
 40d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 410:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 414:	75 c7                	jne    3dd <printint+0x37>
  if(neg)
 416:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 41a:	74 2d                	je     449 <printint+0xa3>
    buf[i++] = '-';
 41c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41f:	8d 50 01             	lea    0x1(%eax),%edx
 422:	89 55 f4             	mov    %edx,-0xc(%ebp)
 425:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 42a:	eb 1d                	jmp    449 <printint+0xa3>
    putc(fd, buf[i]);
 42c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 42f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 432:	01 d0                	add    %edx,%eax
 434:	0f b6 00             	movzbl (%eax),%eax
 437:	0f be c0             	movsbl %al,%eax
 43a:	83 ec 08             	sub    $0x8,%esp
 43d:	50                   	push   %eax
 43e:	ff 75 08             	push   0x8(%ebp)
 441:	e8 3d ff ff ff       	call   383 <putc>
 446:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 449:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 44d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 451:	79 d9                	jns    42c <printint+0x86>
}
 453:	90                   	nop
 454:	90                   	nop
 455:	c9                   	leave
 456:	c3                   	ret

00000457 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 457:	55                   	push   %ebp
 458:	89 e5                	mov    %esp,%ebp
 45a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 45d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 464:	8d 45 0c             	lea    0xc(%ebp),%eax
 467:	83 c0 04             	add    $0x4,%eax
 46a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 46d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 474:	e9 59 01 00 00       	jmp    5d2 <printf+0x17b>
    c = fmt[i] & 0xff;
 479:	8b 55 0c             	mov    0xc(%ebp),%edx
 47c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 47f:	01 d0                	add    %edx,%eax
 481:	0f b6 00             	movzbl (%eax),%eax
 484:	0f be c0             	movsbl %al,%eax
 487:	25 ff 00 00 00       	and    $0xff,%eax
 48c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 48f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 493:	75 2c                	jne    4c1 <printf+0x6a>
      if(c == '%'){
 495:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 499:	75 0c                	jne    4a7 <printf+0x50>
        state = '%';
 49b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a2:	e9 27 01 00 00       	jmp    5ce <printf+0x177>
      } else {
        putc(fd, c);
 4a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4aa:	0f be c0             	movsbl %al,%eax
 4ad:	83 ec 08             	sub    $0x8,%esp
 4b0:	50                   	push   %eax
 4b1:	ff 75 08             	push   0x8(%ebp)
 4b4:	e8 ca fe ff ff       	call   383 <putc>
 4b9:	83 c4 10             	add    $0x10,%esp
 4bc:	e9 0d 01 00 00       	jmp    5ce <printf+0x177>
      }
    } else if(state == '%'){
 4c1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c5:	0f 85 03 01 00 00    	jne    5ce <printf+0x177>
      if(c == 'd'){
 4cb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4cf:	75 1e                	jne    4ef <printf+0x98>
        printint(fd, *ap, 10, 1);
 4d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d4:	8b 00                	mov    (%eax),%eax
 4d6:	6a 01                	push   $0x1
 4d8:	6a 0a                	push   $0xa
 4da:	50                   	push   %eax
 4db:	ff 75 08             	push   0x8(%ebp)
 4de:	e8 c3 fe ff ff       	call   3a6 <printint>
 4e3:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ea:	e9 d8 00 00 00       	jmp    5c7 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4ef:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f3:	74 06                	je     4fb <printf+0xa4>
 4f5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f9:	75 1e                	jne    519 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fe:	8b 00                	mov    (%eax),%eax
 500:	6a 00                	push   $0x0
 502:	6a 10                	push   $0x10
 504:	50                   	push   %eax
 505:	ff 75 08             	push   0x8(%ebp)
 508:	e8 99 fe ff ff       	call   3a6 <printint>
 50d:	83 c4 10             	add    $0x10,%esp
        ap++;
 510:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 514:	e9 ae 00 00 00       	jmp    5c7 <printf+0x170>
      } else if(c == 's'){
 519:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 51d:	75 43                	jne    562 <printf+0x10b>
        s = (char*)*ap;
 51f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 522:	8b 00                	mov    (%eax),%eax
 524:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 527:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 52b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52f:	75 25                	jne    556 <printf+0xff>
          s = "(null)";
 531:	c7 45 f4 35 08 00 00 	movl   $0x835,-0xc(%ebp)
        while(*s != 0){
 538:	eb 1c                	jmp    556 <printf+0xff>
          putc(fd, *s);
 53a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53d:	0f b6 00             	movzbl (%eax),%eax
 540:	0f be c0             	movsbl %al,%eax
 543:	83 ec 08             	sub    $0x8,%esp
 546:	50                   	push   %eax
 547:	ff 75 08             	push   0x8(%ebp)
 54a:	e8 34 fe ff ff       	call   383 <putc>
 54f:	83 c4 10             	add    $0x10,%esp
          s++;
 552:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 556:	8b 45 f4             	mov    -0xc(%ebp),%eax
 559:	0f b6 00             	movzbl (%eax),%eax
 55c:	84 c0                	test   %al,%al
 55e:	75 da                	jne    53a <printf+0xe3>
 560:	eb 65                	jmp    5c7 <printf+0x170>
        }
      } else if(c == 'c'){
 562:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 566:	75 1d                	jne    585 <printf+0x12e>
        putc(fd, *ap);
 568:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56b:	8b 00                	mov    (%eax),%eax
 56d:	0f be c0             	movsbl %al,%eax
 570:	83 ec 08             	sub    $0x8,%esp
 573:	50                   	push   %eax
 574:	ff 75 08             	push   0x8(%ebp)
 577:	e8 07 fe ff ff       	call   383 <putc>
 57c:	83 c4 10             	add    $0x10,%esp
        ap++;
 57f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 583:	eb 42                	jmp    5c7 <printf+0x170>
      } else if(c == '%'){
 585:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 589:	75 17                	jne    5a2 <printf+0x14b>
        putc(fd, c);
 58b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58e:	0f be c0             	movsbl %al,%eax
 591:	83 ec 08             	sub    $0x8,%esp
 594:	50                   	push   %eax
 595:	ff 75 08             	push   0x8(%ebp)
 598:	e8 e6 fd ff ff       	call   383 <putc>
 59d:	83 c4 10             	add    $0x10,%esp
 5a0:	eb 25                	jmp    5c7 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a2:	83 ec 08             	sub    $0x8,%esp
 5a5:	6a 25                	push   $0x25
 5a7:	ff 75 08             	push   0x8(%ebp)
 5aa:	e8 d4 fd ff ff       	call   383 <putc>
 5af:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b5:	0f be c0             	movsbl %al,%eax
 5b8:	83 ec 08             	sub    $0x8,%esp
 5bb:	50                   	push   %eax
 5bc:	ff 75 08             	push   0x8(%ebp)
 5bf:	e8 bf fd ff ff       	call   383 <putc>
 5c4:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5ce:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d8:	01 d0                	add    %edx,%eax
 5da:	0f b6 00             	movzbl (%eax),%eax
 5dd:	84 c0                	test   %al,%al
 5df:	0f 85 94 fe ff ff    	jne    479 <printf+0x22>
    }
  }
}
 5e5:	90                   	nop
 5e6:	90                   	nop
 5e7:	c9                   	leave
 5e8:	c3                   	ret

000005e9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e9:	55                   	push   %ebp
 5ea:	89 e5                	mov    %esp,%ebp
 5ec:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ef:	8b 45 08             	mov    0x8(%ebp),%eax
 5f2:	83 e8 08             	sub    $0x8,%eax
 5f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f8:	a1 a0 0a 00 00       	mov    0xaa0,%eax
 5fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 600:	eb 24                	jmp    626 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 602:	8b 45 fc             	mov    -0x4(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 60a:	72 12                	jb     61e <free+0x35>
 60c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 612:	72 24                	jb     638 <free+0x4f>
 614:	8b 45 fc             	mov    -0x4(%ebp),%eax
 617:	8b 00                	mov    (%eax),%eax
 619:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 61c:	72 1a                	jb     638 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 621:	8b 00                	mov    (%eax),%eax
 623:	89 45 fc             	mov    %eax,-0x4(%ebp)
 626:	8b 45 f8             	mov    -0x8(%ebp),%eax
 629:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 62c:	73 d4                	jae    602 <free+0x19>
 62e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 631:	8b 00                	mov    (%eax),%eax
 633:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 636:	73 ca                	jae    602 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 638:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63b:	8b 40 04             	mov    0x4(%eax),%eax
 63e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	01 c2                	add    %eax,%edx
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	8b 00                	mov    (%eax),%eax
 64f:	39 c2                	cmp    %eax,%edx
 651:	75 24                	jne    677 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	8b 50 04             	mov    0x4(%eax),%edx
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	8b 40 04             	mov    0x4(%eax),%eax
 661:	01 c2                	add    %eax,%edx
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	8b 10                	mov    (%eax),%edx
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	89 10                	mov    %edx,(%eax)
 675:	eb 0a                	jmp    681 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 10                	mov    (%eax),%edx
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 40 04             	mov    0x4(%eax),%eax
 687:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	01 d0                	add    %edx,%eax
 693:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 696:	75 20                	jne    6b8 <free+0xcf>
    p->s.size += bp->s.size;
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 50 04             	mov    0x4(%eax),%edx
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	8b 40 04             	mov    0x4(%eax),%eax
 6a4:	01 c2                	add    %eax,%edx
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	8b 10                	mov    (%eax),%edx
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	89 10                	mov    %edx,(%eax)
 6b6:	eb 08                	jmp    6c0 <free+0xd7>
  } else
    p->s.ptr = bp;
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6be:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	a3 a0 0a 00 00       	mov    %eax,0xaa0
}
 6c8:	90                   	nop
 6c9:	c9                   	leave
 6ca:	c3                   	ret

000006cb <morecore>:

static Header*
morecore(uint nu)
{
 6cb:	55                   	push   %ebp
 6cc:	89 e5                	mov    %esp,%ebp
 6ce:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d8:	77 07                	ja     6e1 <morecore+0x16>
    nu = 4096;
 6da:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e1:	8b 45 08             	mov    0x8(%ebp),%eax
 6e4:	c1 e0 03             	shl    $0x3,%eax
 6e7:	83 ec 0c             	sub    $0xc,%esp
 6ea:	50                   	push   %eax
 6eb:	e8 63 fc ff ff       	call   353 <sbrk>
 6f0:	83 c4 10             	add    $0x10,%esp
 6f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6fa:	75 07                	jne    703 <morecore+0x38>
    return 0;
 6fc:	b8 00 00 00 00       	mov    $0x0,%eax
 701:	eb 26                	jmp    729 <morecore+0x5e>
  hp = (Header*)p;
 703:	8b 45 f4             	mov    -0xc(%ebp),%eax
 706:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 709:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70c:	8b 55 08             	mov    0x8(%ebp),%edx
 70f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 712:	8b 45 f0             	mov    -0x10(%ebp),%eax
 715:	83 c0 08             	add    $0x8,%eax
 718:	83 ec 0c             	sub    $0xc,%esp
 71b:	50                   	push   %eax
 71c:	e8 c8 fe ff ff       	call   5e9 <free>
 721:	83 c4 10             	add    $0x10,%esp
  return freep;
 724:	a1 a0 0a 00 00       	mov    0xaa0,%eax
}
 729:	c9                   	leave
 72a:	c3                   	ret

0000072b <malloc>:

void*
malloc(uint nbytes)
{
 72b:	55                   	push   %ebp
 72c:	89 e5                	mov    %esp,%ebp
 72e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 731:	8b 45 08             	mov    0x8(%ebp),%eax
 734:	83 c0 07             	add    $0x7,%eax
 737:	c1 e8 03             	shr    $0x3,%eax
 73a:	83 c0 01             	add    $0x1,%eax
 73d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 740:	a1 a0 0a 00 00       	mov    0xaa0,%eax
 745:	89 45 f0             	mov    %eax,-0x10(%ebp)
 748:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74c:	75 23                	jne    771 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 74e:	c7 45 f0 98 0a 00 00 	movl   $0xa98,-0x10(%ebp)
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	a3 a0 0a 00 00       	mov    %eax,0xaa0
 75d:	a1 a0 0a 00 00       	mov    0xaa0,%eax
 762:	a3 98 0a 00 00       	mov    %eax,0xa98
    base.s.size = 0;
 767:	c7 05 9c 0a 00 00 00 	movl   $0x0,0xa9c
 76e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 771:	8b 45 f0             	mov    -0x10(%ebp),%eax
 774:	8b 00                	mov    (%eax),%eax
 776:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	8b 40 04             	mov    0x4(%eax),%eax
 77f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 782:	72 4d                	jb     7d1 <malloc+0xa6>
      if(p->s.size == nunits)
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	8b 40 04             	mov    0x4(%eax),%eax
 78a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 78d:	75 0c                	jne    79b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	8b 10                	mov    (%eax),%edx
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	89 10                	mov    %edx,(%eax)
 799:	eb 26                	jmp    7c1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	8b 40 04             	mov    0x4(%eax),%eax
 7a1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a4:	89 c2                	mov    %eax,%edx
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	c1 e0 03             	shl    $0x3,%eax
 7b5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7be:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	a3 a0 0a 00 00       	mov    %eax,0xaa0
      return (void*)(p + 1);
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	83 c0 08             	add    $0x8,%eax
 7cf:	eb 3b                	jmp    80c <malloc+0xe1>
    }
    if(p == freep)
 7d1:	a1 a0 0a 00 00       	mov    0xaa0,%eax
 7d6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7d9:	75 1e                	jne    7f9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7db:	83 ec 0c             	sub    $0xc,%esp
 7de:	ff 75 ec             	push   -0x14(%ebp)
 7e1:	e8 e5 fe ff ff       	call   6cb <morecore>
 7e6:	83 c4 10             	add    $0x10,%esp
 7e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f0:	75 07                	jne    7f9 <malloc+0xce>
        return 0;
 7f2:	b8 00 00 00 00       	mov    $0x0,%eax
 7f7:	eb 13                	jmp    80c <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 807:	e9 6d ff ff ff       	jmp    779 <malloc+0x4e>
  }
}
 80c:	c9                   	leave
 80d:	c3                   	ret
