
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 9e 08 00 00       	push   $0x89e
  1b:	e8 78 03 00 00       	call   398 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 9e 08 00 00       	push   $0x89e
  33:	e8 68 03 00 00       	call   3a0 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 9e 08 00 00       	push   $0x89e
  45:	e8 4e 03 00 00       	call   398 <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 79 03 00 00       	call   3d0 <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 6c 03 00 00       	call   3d0 <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 a6 08 00 00       	push   $0x8a6
  6f:	6a 01                	push   $0x1
  71:	e8 6e 04 00 00       	call   4e4 <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 d2 02 00 00       	call   350 <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 b9 08 00 00       	push   $0x8b9
  8f:	6a 01                	push   $0x1
  91:	e8 4e 04 00 00       	call   4e4 <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 ba 02 00 00       	call   358 <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 3e                	jne    e2 <main+0xe2>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 38 0b 00 00       	push   $0xb38
  ac:	68 9b 08 00 00       	push   $0x89b
  b1:	e8 da 02 00 00       	call   390 <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 cc 08 00 00       	push   $0x8cc
  c1:	6a 01                	push   $0x1
  c3:	e8 1c 04 00 00       	call   4e4 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 88 02 00 00       	call   358 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 e2 08 00 00       	push   $0x8e2
  d8:	6a 01                	push   $0x1
  da:	e8 05 04 00 00       	call   4e4 <printf>
  df:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait()) >= 0 && wpid != pid)
  e2:	e8 79 02 00 00       	call   360 <wait>
  e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  ee:	0f 88 73 ff ff ff    	js     67 <main+0x67>
  f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  fa:	75 d4                	jne    d0 <main+0xd0>
    printf(1, "init: starting sh\n");
  fc:	e9 66 ff ff ff       	jmp    67 <main+0x67>

00000101 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	57                   	push   %edi
 105:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 55 10             	mov    0x10(%ebp),%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	89 cb                	mov    %ecx,%ebx
 111:	89 df                	mov    %ebx,%edi
 113:	89 d1                	mov    %edx,%ecx
 115:	fc                   	cld
 116:	f3 aa                	rep stos %al,%es:(%edi)
 118:	89 ca                	mov    %ecx,%edx
 11a:	89 fb                	mov    %edi,%ebx
 11c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 122:	90                   	nop
 123:	5b                   	pop    %ebx
 124:	5f                   	pop    %edi
 125:	5d                   	pop    %ebp
 126:	c3                   	ret

00000127 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 133:	90                   	nop
 134:	8b 55 0c             	mov    0xc(%ebp),%edx
 137:	8d 42 01             	lea    0x1(%edx),%eax
 13a:	89 45 0c             	mov    %eax,0xc(%ebp)
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	8d 48 01             	lea    0x1(%eax),%ecx
 143:	89 4d 08             	mov    %ecx,0x8(%ebp)
 146:	0f b6 12             	movzbl (%edx),%edx
 149:	88 10                	mov    %dl,(%eax)
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	84 c0                	test   %al,%al
 150:	75 e2                	jne    134 <strcpy+0xd>
    ;
  return os;
 152:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 155:	c9                   	leave
 156:	c3                   	ret

00000157 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 15a:	eb 08                	jmp    164 <strcmp+0xd>
    p++, q++;
 15c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 160:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	84 c0                	test   %al,%al
 16c:	74 10                	je     17e <strcmp+0x27>
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 10             	movzbl (%eax),%edx
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	38 c2                	cmp    %al,%dl
 17c:	74 de                	je     15c <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	0f b6 d0             	movzbl %al,%edx
 187:	8b 45 0c             	mov    0xc(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	0f b6 c0             	movzbl %al,%eax
 190:	29 c2                	sub    %eax,%edx
 192:	89 d0                	mov    %edx,%eax
}
 194:	5d                   	pop    %ebp
 195:	c3                   	ret

00000196 <strlen>:

uint
strlen(char *s)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 19c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a3:	eb 04                	jmp    1a9 <strlen+0x13>
 1a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	01 d0                	add    %edx,%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	84 c0                	test   %al,%al
 1b6:	75 ed                	jne    1a5 <strlen+0xf>
    ;
  return n;
 1b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1bb:	c9                   	leave
 1bc:	c3                   	ret

000001bd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c0:	8b 45 10             	mov    0x10(%ebp),%eax
 1c3:	50                   	push   %eax
 1c4:	ff 75 0c             	push   0xc(%ebp)
 1c7:	ff 75 08             	push   0x8(%ebp)
 1ca:	e8 32 ff ff ff       	call   101 <stosb>
 1cf:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d5:	c9                   	leave
 1d6:	c3                   	ret

000001d7 <strchr>:

char*
strchr(const char *s, char c)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e3:	eb 14                	jmp    1f9 <strchr+0x22>
    if(*s == c)
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 00             	movzbl (%eax),%eax
 1eb:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1ee:	75 05                	jne    1f5 <strchr+0x1e>
      return (char*)s;
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	eb 13                	jmp    208 <strchr+0x31>
  for(; *s; s++)
 1f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	84 c0                	test   %al,%al
 201:	75 e2                	jne    1e5 <strchr+0xe>
  return 0;
 203:	b8 00 00 00 00       	mov    $0x0,%eax
}
 208:	c9                   	leave
 209:	c3                   	ret

0000020a <gets>:

char*
gets(char *buf, int max)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 217:	eb 42                	jmp    25b <gets+0x51>
    cc = read(0, &c, 1);
 219:	83 ec 04             	sub    $0x4,%esp
 21c:	6a 01                	push   $0x1
 21e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 221:	50                   	push   %eax
 222:	6a 00                	push   $0x0
 224:	e8 47 01 00 00       	call   370 <read>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 233:	7e 33                	jle    268 <gets+0x5e>
      break;
    buf[i++] = c;
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	8d 50 01             	lea    0x1(%eax),%edx
 23b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23e:	89 c2                	mov    %eax,%edx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	01 c2                	add    %eax,%edx
 245:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 249:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24f:	3c 0a                	cmp    $0xa,%al
 251:	74 16                	je     269 <gets+0x5f>
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	3c 0d                	cmp    $0xd,%al
 259:	74 0e                	je     269 <gets+0x5f>
  for(i=0; i+1 < max; ){
 25b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25e:	83 c0 01             	add    $0x1,%eax
 261:	39 45 0c             	cmp    %eax,0xc(%ebp)
 264:	7f b3                	jg     219 <gets+0xf>
 266:	eb 01                	jmp    269 <gets+0x5f>
      break;
 268:	90                   	nop
      break;
  }
  buf[i] = '\0';
 269:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	01 d0                	add    %edx,%eax
 271:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 274:	8b 45 08             	mov    0x8(%ebp),%eax
}
 277:	c9                   	leave
 278:	c3                   	ret

00000279 <stat>:

int
stat(char *n, struct stat *st)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27f:	83 ec 08             	sub    $0x8,%esp
 282:	6a 00                	push   $0x0
 284:	ff 75 08             	push   0x8(%ebp)
 287:	e8 0c 01 00 00       	call   398 <open>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 292:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 296:	79 07                	jns    29f <stat+0x26>
    return -1;
 298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29d:	eb 25                	jmp    2c4 <stat+0x4b>
  r = fstat(fd, st);
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	ff 75 0c             	push   0xc(%ebp)
 2a5:	ff 75 f4             	push   -0xc(%ebp)
 2a8:	e8 03 01 00 00       	call   3b0 <fstat>
 2ad:	83 c4 10             	add    $0x10,%esp
 2b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b3:	83 ec 0c             	sub    $0xc,%esp
 2b6:	ff 75 f4             	push   -0xc(%ebp)
 2b9:	e8 c2 00 00 00       	call   380 <close>
 2be:	83 c4 10             	add    $0x10,%esp
  return r;
 2c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c4:	c9                   	leave
 2c5:	c3                   	ret

000002c6 <atoi>:

int
atoi(const char *s)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2d3:	eb 25                	jmp    2fa <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d8:	89 d0                	mov    %edx,%eax
 2da:	c1 e0 02             	shl    $0x2,%eax
 2dd:	01 d0                	add    %edx,%eax
 2df:	01 c0                	add    %eax,%eax
 2e1:	89 c1                	mov    %eax,%ecx
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	8d 50 01             	lea    0x1(%eax),%edx
 2e9:	89 55 08             	mov    %edx,0x8(%ebp)
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	0f be c0             	movsbl %al,%eax
 2f2:	01 c8                	add    %ecx,%eax
 2f4:	83 e8 30             	sub    $0x30,%eax
 2f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	3c 2f                	cmp    $0x2f,%al
 302:	7e 0a                	jle    30e <atoi+0x48>
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	0f b6 00             	movzbl (%eax),%eax
 30a:	3c 39                	cmp    $0x39,%al
 30c:	7e c7                	jle    2d5 <atoi+0xf>
  return n;
 30e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 311:	c9                   	leave
 312:	c3                   	ret

00000313 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 313:	55                   	push   %ebp
 314:	89 e5                	mov    %esp,%ebp
 316:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31f:	8b 45 0c             	mov    0xc(%ebp),%eax
 322:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 325:	eb 17                	jmp    33e <memmove+0x2b>
    *dst++ = *src++;
 327:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32a:	8d 42 01             	lea    0x1(%edx),%eax
 32d:	89 45 f8             	mov    %eax,-0x8(%ebp)
 330:	8b 45 fc             	mov    -0x4(%ebp),%eax
 333:	8d 48 01             	lea    0x1(%eax),%ecx
 336:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 339:	0f b6 12             	movzbl (%edx),%edx
 33c:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 33e:	8b 45 10             	mov    0x10(%ebp),%eax
 341:	8d 50 ff             	lea    -0x1(%eax),%edx
 344:	89 55 10             	mov    %edx,0x10(%ebp)
 347:	85 c0                	test   %eax,%eax
 349:	7f dc                	jg     327 <memmove+0x14>
  return vdst;
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34e:	c9                   	leave
 34f:	c3                   	ret

00000350 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 350:	b8 01 00 00 00       	mov    $0x1,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret

00000358 <exit>:
SYSCALL(exit)
 358:	b8 02 00 00 00       	mov    $0x2,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret

00000360 <wait>:
SYSCALL(wait)
 360:	b8 03 00 00 00       	mov    $0x3,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret

00000368 <pipe>:
SYSCALL(pipe)
 368:	b8 04 00 00 00       	mov    $0x4,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret

00000370 <read>:
SYSCALL(read)
 370:	b8 05 00 00 00       	mov    $0x5,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret

00000378 <write>:
SYSCALL(write)
 378:	b8 10 00 00 00       	mov    $0x10,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret

00000380 <close>:
SYSCALL(close)
 380:	b8 15 00 00 00       	mov    $0x15,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret

00000388 <kill>:
SYSCALL(kill)
 388:	b8 06 00 00 00       	mov    $0x6,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret

00000390 <exec>:
SYSCALL(exec)
 390:	b8 07 00 00 00       	mov    $0x7,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret

00000398 <open>:
SYSCALL(open)
 398:	b8 0f 00 00 00       	mov    $0xf,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret

000003a0 <mknod>:
SYSCALL(mknod)
 3a0:	b8 11 00 00 00       	mov    $0x11,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret

000003a8 <unlink>:
SYSCALL(unlink)
 3a8:	b8 12 00 00 00       	mov    $0x12,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret

000003b0 <fstat>:
SYSCALL(fstat)
 3b0:	b8 08 00 00 00       	mov    $0x8,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret

000003b8 <link>:
SYSCALL(link)
 3b8:	b8 13 00 00 00       	mov    $0x13,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret

000003c0 <mkdir>:
SYSCALL(mkdir)
 3c0:	b8 14 00 00 00       	mov    $0x14,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret

000003c8 <chdir>:
SYSCALL(chdir)
 3c8:	b8 09 00 00 00       	mov    $0x9,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret

000003d0 <dup>:
SYSCALL(dup)
 3d0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret

000003d8 <getpid>:
SYSCALL(getpid)
 3d8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret

000003e0 <sbrk>:
SYSCALL(sbrk)
 3e0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret

000003e8 <sleep>:
SYSCALL(sleep)
 3e8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret

000003f0 <uptime>:
SYSCALL(uptime)
 3f0:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret

000003f8 <wait2>:
SYSCALL(wait2)
 3f8:	b8 17 00 00 00       	mov    $0x17,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret

00000400 <exit2>:
SYSCALL(exit2)
 400:	b8 16 00 00 00       	mov    $0x16,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret

00000408 <uthread_init>:
 408:	b8 18 00 00 00       	mov    $0x18,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret

00000410 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	83 ec 18             	sub    $0x18,%esp
 416:	8b 45 0c             	mov    0xc(%ebp),%eax
 419:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 41c:	83 ec 04             	sub    $0x4,%esp
 41f:	6a 01                	push   $0x1
 421:	8d 45 f4             	lea    -0xc(%ebp),%eax
 424:	50                   	push   %eax
 425:	ff 75 08             	push   0x8(%ebp)
 428:	e8 4b ff ff ff       	call   378 <write>
 42d:	83 c4 10             	add    $0x10,%esp
}
 430:	90                   	nop
 431:	c9                   	leave
 432:	c3                   	ret

00000433 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 433:	55                   	push   %ebp
 434:	89 e5                	mov    %esp,%ebp
 436:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 439:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 440:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 444:	74 17                	je     45d <printint+0x2a>
 446:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 44a:	79 11                	jns    45d <printint+0x2a>
    neg = 1;
 44c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 453:	8b 45 0c             	mov    0xc(%ebp),%eax
 456:	f7 d8                	neg    %eax
 458:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45b:	eb 06                	jmp    463 <printint+0x30>
  } else {
    x = xx;
 45d:	8b 45 0c             	mov    0xc(%ebp),%eax
 460:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 463:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 46a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 46d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 470:	ba 00 00 00 00       	mov    $0x0,%edx
 475:	f7 f1                	div    %ecx
 477:	89 d1                	mov    %edx,%ecx
 479:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47c:	8d 50 01             	lea    0x1(%eax),%edx
 47f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 482:	0f b6 91 40 0b 00 00 	movzbl 0xb40(%ecx),%edx
 489:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 48d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 490:	8b 45 ec             	mov    -0x14(%ebp),%eax
 493:	ba 00 00 00 00       	mov    $0x0,%edx
 498:	f7 f1                	div    %ecx
 49a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 49d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a1:	75 c7                	jne    46a <printint+0x37>
  if(neg)
 4a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a7:	74 2d                	je     4d6 <printint+0xa3>
    buf[i++] = '-';
 4a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ac:	8d 50 01             	lea    0x1(%eax),%edx
 4af:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4b7:	eb 1d                	jmp    4d6 <printint+0xa3>
    putc(fd, buf[i]);
 4b9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bf:	01 d0                	add    %edx,%eax
 4c1:	0f b6 00             	movzbl (%eax),%eax
 4c4:	0f be c0             	movsbl %al,%eax
 4c7:	83 ec 08             	sub    $0x8,%esp
 4ca:	50                   	push   %eax
 4cb:	ff 75 08             	push   0x8(%ebp)
 4ce:	e8 3d ff ff ff       	call   410 <putc>
 4d3:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4d6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4de:	79 d9                	jns    4b9 <printint+0x86>
}
 4e0:	90                   	nop
 4e1:	90                   	nop
 4e2:	c9                   	leave
 4e3:	c3                   	ret

000004e4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f1:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f4:	83 c0 04             	add    $0x4,%eax
 4f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 501:	e9 59 01 00 00       	jmp    65f <printf+0x17b>
    c = fmt[i] & 0xff;
 506:	8b 55 0c             	mov    0xc(%ebp),%edx
 509:	8b 45 f0             	mov    -0x10(%ebp),%eax
 50c:	01 d0                	add    %edx,%eax
 50e:	0f b6 00             	movzbl (%eax),%eax
 511:	0f be c0             	movsbl %al,%eax
 514:	25 ff 00 00 00       	and    $0xff,%eax
 519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 51c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 520:	75 2c                	jne    54e <printf+0x6a>
      if(c == '%'){
 522:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 526:	75 0c                	jne    534 <printf+0x50>
        state = '%';
 528:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 52f:	e9 27 01 00 00       	jmp    65b <printf+0x177>
      } else {
        putc(fd, c);
 534:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 537:	0f be c0             	movsbl %al,%eax
 53a:	83 ec 08             	sub    $0x8,%esp
 53d:	50                   	push   %eax
 53e:	ff 75 08             	push   0x8(%ebp)
 541:	e8 ca fe ff ff       	call   410 <putc>
 546:	83 c4 10             	add    $0x10,%esp
 549:	e9 0d 01 00 00       	jmp    65b <printf+0x177>
      }
    } else if(state == '%'){
 54e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 552:	0f 85 03 01 00 00    	jne    65b <printf+0x177>
      if(c == 'd'){
 558:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 55c:	75 1e                	jne    57c <printf+0x98>
        printint(fd, *ap, 10, 1);
 55e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 561:	8b 00                	mov    (%eax),%eax
 563:	6a 01                	push   $0x1
 565:	6a 0a                	push   $0xa
 567:	50                   	push   %eax
 568:	ff 75 08             	push   0x8(%ebp)
 56b:	e8 c3 fe ff ff       	call   433 <printint>
 570:	83 c4 10             	add    $0x10,%esp
        ap++;
 573:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 577:	e9 d8 00 00 00       	jmp    654 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 57c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 580:	74 06                	je     588 <printf+0xa4>
 582:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 586:	75 1e                	jne    5a6 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 588:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58b:	8b 00                	mov    (%eax),%eax
 58d:	6a 00                	push   $0x0
 58f:	6a 10                	push   $0x10
 591:	50                   	push   %eax
 592:	ff 75 08             	push   0x8(%ebp)
 595:	e8 99 fe ff ff       	call   433 <printint>
 59a:	83 c4 10             	add    $0x10,%esp
        ap++;
 59d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a1:	e9 ae 00 00 00       	jmp    654 <printf+0x170>
      } else if(c == 's'){
 5a6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5aa:	75 43                	jne    5ef <printf+0x10b>
        s = (char*)*ap;
 5ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5af:	8b 00                	mov    (%eax),%eax
 5b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5bc:	75 25                	jne    5e3 <printf+0xff>
          s = "(null)";
 5be:	c7 45 f4 eb 08 00 00 	movl   $0x8eb,-0xc(%ebp)
        while(*s != 0){
 5c5:	eb 1c                	jmp    5e3 <printf+0xff>
          putc(fd, *s);
 5c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ca:	0f b6 00             	movzbl (%eax),%eax
 5cd:	0f be c0             	movsbl %al,%eax
 5d0:	83 ec 08             	sub    $0x8,%esp
 5d3:	50                   	push   %eax
 5d4:	ff 75 08             	push   0x8(%ebp)
 5d7:	e8 34 fe ff ff       	call   410 <putc>
 5dc:	83 c4 10             	add    $0x10,%esp
          s++;
 5df:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e6:	0f b6 00             	movzbl (%eax),%eax
 5e9:	84 c0                	test   %al,%al
 5eb:	75 da                	jne    5c7 <printf+0xe3>
 5ed:	eb 65                	jmp    654 <printf+0x170>
        }
      } else if(c == 'c'){
 5ef:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5f3:	75 1d                	jne    612 <printf+0x12e>
        putc(fd, *ap);
 5f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f8:	8b 00                	mov    (%eax),%eax
 5fa:	0f be c0             	movsbl %al,%eax
 5fd:	83 ec 08             	sub    $0x8,%esp
 600:	50                   	push   %eax
 601:	ff 75 08             	push   0x8(%ebp)
 604:	e8 07 fe ff ff       	call   410 <putc>
 609:	83 c4 10             	add    $0x10,%esp
        ap++;
 60c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 610:	eb 42                	jmp    654 <printf+0x170>
      } else if(c == '%'){
 612:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 616:	75 17                	jne    62f <printf+0x14b>
        putc(fd, c);
 618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61b:	0f be c0             	movsbl %al,%eax
 61e:	83 ec 08             	sub    $0x8,%esp
 621:	50                   	push   %eax
 622:	ff 75 08             	push   0x8(%ebp)
 625:	e8 e6 fd ff ff       	call   410 <putc>
 62a:	83 c4 10             	add    $0x10,%esp
 62d:	eb 25                	jmp    654 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 62f:	83 ec 08             	sub    $0x8,%esp
 632:	6a 25                	push   $0x25
 634:	ff 75 08             	push   0x8(%ebp)
 637:	e8 d4 fd ff ff       	call   410 <putc>
 63c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 63f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 642:	0f be c0             	movsbl %al,%eax
 645:	83 ec 08             	sub    $0x8,%esp
 648:	50                   	push   %eax
 649:	ff 75 08             	push   0x8(%ebp)
 64c:	e8 bf fd ff ff       	call   410 <putc>
 651:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 654:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 65b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 65f:	8b 55 0c             	mov    0xc(%ebp),%edx
 662:	8b 45 f0             	mov    -0x10(%ebp),%eax
 665:	01 d0                	add    %edx,%eax
 667:	0f b6 00             	movzbl (%eax),%eax
 66a:	84 c0                	test   %al,%al
 66c:	0f 85 94 fe ff ff    	jne    506 <printf+0x22>
    }
  }
}
 672:	90                   	nop
 673:	90                   	nop
 674:	c9                   	leave
 675:	c3                   	ret

00000676 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 676:	55                   	push   %ebp
 677:	89 e5                	mov    %esp,%ebp
 679:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67c:	8b 45 08             	mov    0x8(%ebp),%eax
 67f:	83 e8 08             	sub    $0x8,%eax
 682:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 685:	a1 5c 0b 00 00       	mov    0xb5c,%eax
 68a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68d:	eb 24                	jmp    6b3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 697:	72 12                	jb     6ab <free+0x35>
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 69f:	72 24                	jb     6c5 <free+0x4f>
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6a9:	72 1a                	jb     6c5 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6b9:	73 d4                	jae    68f <free+0x19>
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 00                	mov    (%eax),%eax
 6c0:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6c3:	73 ca                	jae    68f <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c8:	8b 40 04             	mov    0x4(%eax),%eax
 6cb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	01 c2                	add    %eax,%edx
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	39 c2                	cmp    %eax,%edx
 6de:	75 24                	jne    704 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	8b 50 04             	mov    0x4(%eax),%edx
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	8b 00                	mov    (%eax),%eax
 6eb:	8b 40 04             	mov    0x4(%eax),%eax
 6ee:	01 c2                	add    %eax,%edx
 6f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	8b 00                	mov    (%eax),%eax
 6fb:	8b 10                	mov    (%eax),%edx
 6fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 700:	89 10                	mov    %edx,(%eax)
 702:	eb 0a                	jmp    70e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 10                	mov    (%eax),%edx
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 40 04             	mov    0x4(%eax),%eax
 714:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	01 d0                	add    %edx,%eax
 720:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 723:	75 20                	jne    745 <free+0xcf>
    p->s.size += bp->s.size;
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	8b 50 04             	mov    0x4(%eax),%edx
 72b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72e:	8b 40 04             	mov    0x4(%eax),%eax
 731:	01 c2                	add    %eax,%edx
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 739:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73c:	8b 10                	mov    (%eax),%edx
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	89 10                	mov    %edx,(%eax)
 743:	eb 08                	jmp    74d <free+0xd7>
  } else
    p->s.ptr = bp;
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 55 f8             	mov    -0x8(%ebp),%edx
 74b:	89 10                	mov    %edx,(%eax)
  freep = p;
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	a3 5c 0b 00 00       	mov    %eax,0xb5c
}
 755:	90                   	nop
 756:	c9                   	leave
 757:	c3                   	ret

00000758 <morecore>:

static Header*
morecore(uint nu)
{
 758:	55                   	push   %ebp
 759:	89 e5                	mov    %esp,%ebp
 75b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 75e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 765:	77 07                	ja     76e <morecore+0x16>
    nu = 4096;
 767:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 76e:	8b 45 08             	mov    0x8(%ebp),%eax
 771:	c1 e0 03             	shl    $0x3,%eax
 774:	83 ec 0c             	sub    $0xc,%esp
 777:	50                   	push   %eax
 778:	e8 63 fc ff ff       	call   3e0 <sbrk>
 77d:	83 c4 10             	add    $0x10,%esp
 780:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 783:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 787:	75 07                	jne    790 <morecore+0x38>
    return 0;
 789:	b8 00 00 00 00       	mov    $0x0,%eax
 78e:	eb 26                	jmp    7b6 <morecore+0x5e>
  hp = (Header*)p;
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 796:	8b 45 f0             	mov    -0x10(%ebp),%eax
 799:	8b 55 08             	mov    0x8(%ebp),%edx
 79c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 79f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a2:	83 c0 08             	add    $0x8,%eax
 7a5:	83 ec 0c             	sub    $0xc,%esp
 7a8:	50                   	push   %eax
 7a9:	e8 c8 fe ff ff       	call   676 <free>
 7ae:	83 c4 10             	add    $0x10,%esp
  return freep;
 7b1:	a1 5c 0b 00 00       	mov    0xb5c,%eax
}
 7b6:	c9                   	leave
 7b7:	c3                   	ret

000007b8 <malloc>:

void*
malloc(uint nbytes)
{
 7b8:	55                   	push   %ebp
 7b9:	89 e5                	mov    %esp,%ebp
 7bb:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7be:	8b 45 08             	mov    0x8(%ebp),%eax
 7c1:	83 c0 07             	add    $0x7,%eax
 7c4:	c1 e8 03             	shr    $0x3,%eax
 7c7:	83 c0 01             	add    $0x1,%eax
 7ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7cd:	a1 5c 0b 00 00       	mov    0xb5c,%eax
 7d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7d9:	75 23                	jne    7fe <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7db:	c7 45 f0 54 0b 00 00 	movl   $0xb54,-0x10(%ebp)
 7e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e5:	a3 5c 0b 00 00       	mov    %eax,0xb5c
 7ea:	a1 5c 0b 00 00       	mov    0xb5c,%eax
 7ef:	a3 54 0b 00 00       	mov    %eax,0xb54
    base.s.size = 0;
 7f4:	c7 05 58 0b 00 00 00 	movl   $0x0,0xb58
 7fb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 801:	8b 00                	mov    (%eax),%eax
 803:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	8b 40 04             	mov    0x4(%eax),%eax
 80c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80f:	72 4d                	jb     85e <malloc+0xa6>
      if(p->s.size == nunits)
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	8b 40 04             	mov    0x4(%eax),%eax
 817:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 81a:	75 0c                	jne    828 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 81c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81f:	8b 10                	mov    (%eax),%edx
 821:	8b 45 f0             	mov    -0x10(%ebp),%eax
 824:	89 10                	mov    %edx,(%eax)
 826:	eb 26                	jmp    84e <malloc+0x96>
      else {
        p->s.size -= nunits;
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 40 04             	mov    0x4(%eax),%eax
 82e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 831:	89 c2                	mov    %eax,%edx
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	8b 40 04             	mov    0x4(%eax),%eax
 83f:	c1 e0 03             	shl    $0x3,%eax
 842:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	8b 55 ec             	mov    -0x14(%ebp),%edx
 84b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 84e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 851:	a3 5c 0b 00 00       	mov    %eax,0xb5c
      return (void*)(p + 1);
 856:	8b 45 f4             	mov    -0xc(%ebp),%eax
 859:	83 c0 08             	add    $0x8,%eax
 85c:	eb 3b                	jmp    899 <malloc+0xe1>
    }
    if(p == freep)
 85e:	a1 5c 0b 00 00       	mov    0xb5c,%eax
 863:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 866:	75 1e                	jne    886 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 868:	83 ec 0c             	sub    $0xc,%esp
 86b:	ff 75 ec             	push   -0x14(%ebp)
 86e:	e8 e5 fe ff ff       	call   758 <morecore>
 873:	83 c4 10             	add    $0x10,%esp
 876:	89 45 f4             	mov    %eax,-0xc(%ebp)
 879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 87d:	75 07                	jne    886 <malloc+0xce>
        return 0;
 87f:	b8 00 00 00 00       	mov    $0x0,%eax
 884:	eb 13                	jmp    899 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	89 45 f0             	mov    %eax,-0x10(%ebp)
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	8b 00                	mov    (%eax),%eax
 891:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 894:	e9 6d ff ff ff       	jmp    806 <malloc+0x4e>
  }
}
 899:	c9                   	leave
 89a:	c3                   	ret
