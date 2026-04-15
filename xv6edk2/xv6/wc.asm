
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 58                	jmp    83 <wc+0x83>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 20 0c 00 00       	add    $0xc20,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 20 0c 00 00       	add    $0xc20,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 57 09 00 00       	push   $0x957
  59:	e8 35 02 00 00       	call   293 <strchr>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
  65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
  6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  72:	75 0b                	jne    7f <wc+0x7f>
        w++;
  74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
  7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  89:	7c a0                	jl     2b <wc+0x2b>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8b:	83 ec 04             	sub    $0x4,%esp
  8e:	68 00 02 00 00       	push   $0x200
  93:	68 20 0c 00 00       	push   $0xc20
  98:	ff 75 08             	push   0x8(%ebp)
  9b:	e8 8c 03 00 00       	call   42c <read>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
      }
    }
  }
  if(n < 0){
  b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 5d 09 00 00       	push   $0x95d
  be:	6a 01                	push   $0x1
  c0:	e8 db 04 00 00       	call   5a0 <printf>
  c5:	83 c4 10             	add    $0x10,%esp
    exit();
  c8:	e8 47 03 00 00       	call   414 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	ff 75 0c             	push   0xc(%ebp)
  d3:	ff 75 e8             	push   -0x18(%ebp)
  d6:	ff 75 ec             	push   -0x14(%ebp)
  d9:	ff 75 f0             	push   -0x10(%ebp)
  dc:	68 6d 09 00 00       	push   $0x96d
  e1:	6a 01                	push   $0x1
  e3:	e8 b8 04 00 00       	call   5a0 <printf>
  e8:	83 c4 20             	add    $0x20,%esp
}
  eb:	90                   	nop
  ec:	c9                   	leave
  ed:	c3                   	ret

000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f2:	83 e4 f0             	and    $0xfffffff0,%esp
  f5:	ff 71 fc             	push   -0x4(%ecx)
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	53                   	push   %ebx
  fc:	51                   	push   %ecx
  fd:	83 ec 10             	sub    $0x10,%esp
 100:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 102:	83 3b 01             	cmpl   $0x1,(%ebx)
 105:	7f 17                	jg     11e <main+0x30>
    wc(0, "");
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	68 7a 09 00 00       	push   $0x97a
 10f:	6a 00                	push   $0x0
 111:	e8 ea fe ff ff       	call   0 <wc>
 116:	83 c4 10             	add    $0x10,%esp
    exit();
 119:	e8 f6 02 00 00       	call   414 <exit>
  }

  for(i = 1; i < argc; i++){
 11e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 125:	e9 83 00 00 00       	jmp    1ad <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
 12a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 134:	8b 43 04             	mov    0x4(%ebx),%eax
 137:	01 d0                	add    %edx,%eax
 139:	8b 00                	mov    (%eax),%eax
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	6a 00                	push   $0x0
 140:	50                   	push   %eax
 141:	e8 0e 03 00 00       	call   454 <open>
 146:	83 c4 10             	add    $0x10,%esp
 149:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 150:	79 29                	jns    17b <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 152:	8b 45 f4             	mov    -0xc(%ebp),%eax
 155:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15c:	8b 43 04             	mov    0x4(%ebx),%eax
 15f:	01 d0                	add    %edx,%eax
 161:	8b 00                	mov    (%eax),%eax
 163:	83 ec 04             	sub    $0x4,%esp
 166:	50                   	push   %eax
 167:	68 7b 09 00 00       	push   $0x97b
 16c:	6a 01                	push   $0x1
 16e:	e8 2d 04 00 00       	call   5a0 <printf>
 173:	83 c4 10             	add    $0x10,%esp
      exit();
 176:	e8 99 02 00 00       	call   414 <exit>
    }
    wc(fd, argv[i]);
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 185:	8b 43 04             	mov    0x4(%ebx),%eax
 188:	01 d0                	add    %edx,%eax
 18a:	8b 00                	mov    (%eax),%eax
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	50                   	push   %eax
 190:	ff 75 f0             	push   -0x10(%ebp)
 193:	e8 68 fe ff ff       	call   0 <wc>
 198:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19b:	83 ec 0c             	sub    $0xc,%esp
 19e:	ff 75 f0             	push   -0x10(%ebp)
 1a1:	e8 96 02 00 00       	call   43c <close>
 1a6:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
 1a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	3b 03                	cmp    (%ebx),%eax
 1b2:	0f 8c 72 ff ff ff    	jl     12a <main+0x3c>
  }
  exit();
 1b8:	e8 57 02 00 00       	call   414 <exit>

000001bd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	57                   	push   %edi
 1c1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c5:	8b 55 10             	mov    0x10(%ebp),%edx
 1c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cb:	89 cb                	mov    %ecx,%ebx
 1cd:	89 df                	mov    %ebx,%edi
 1cf:	89 d1                	mov    %edx,%ecx
 1d1:	fc                   	cld
 1d2:	f3 aa                	rep stos %al,%es:(%edi)
 1d4:	89 ca                	mov    %ecx,%edx
 1d6:	89 fb                	mov    %edi,%ebx
 1d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1db:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1de:	90                   	nop
 1df:	5b                   	pop    %ebx
 1e0:	5f                   	pop    %edi
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret

000001e3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ef:	90                   	nop
 1f0:	8b 55 0c             	mov    0xc(%ebp),%edx
 1f3:	8d 42 01             	lea    0x1(%edx),%eax
 1f6:	89 45 0c             	mov    %eax,0xc(%ebp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	8d 48 01             	lea    0x1(%eax),%ecx
 1ff:	89 4d 08             	mov    %ecx,0x8(%ebp)
 202:	0f b6 12             	movzbl (%edx),%edx
 205:	88 10                	mov    %dl,(%eax)
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	84 c0                	test   %al,%al
 20c:	75 e2                	jne    1f0 <strcpy+0xd>
    ;
  return os;
 20e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 211:	c9                   	leave
 212:	c3                   	ret

00000213 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 216:	eb 08                	jmp    220 <strcmp+0xd>
    p++, q++;
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	74 10                	je     23a <strcmp+0x27>
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	0f b6 10             	movzbl (%eax),%edx
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	38 c2                	cmp    %al,%dl
 238:	74 de                	je     218 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	0f b6 d0             	movzbl %al,%edx
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 c0             	movzbl %al,%eax
 24c:	29 c2                	sub    %eax,%edx
 24e:	89 d0                	mov    %edx,%eax
}
 250:	5d                   	pop    %ebp
 251:	c3                   	ret

00000252 <strlen>:

uint
strlen(char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25f:	eb 04                	jmp    265 <strlen+0x13>
 261:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	84 c0                	test   %al,%al
 272:	75 ed                	jne    261 <strlen+0xf>
    ;
  return n;
 274:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 277:	c9                   	leave
 278:	c3                   	ret

00000279 <memset>:

void*
memset(void *dst, int c, uint n)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	50                   	push   %eax
 280:	ff 75 0c             	push   0xc(%ebp)
 283:	ff 75 08             	push   0x8(%ebp)
 286:	e8 32 ff ff ff       	call   1bd <stosb>
 28b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 291:	c9                   	leave
 292:	c3                   	ret

00000293 <strchr>:

char*
strchr(const char *s, char c)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	83 ec 04             	sub    $0x4,%esp
 299:	8b 45 0c             	mov    0xc(%ebp),%eax
 29c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29f:	eb 14                	jmp    2b5 <strchr+0x22>
    if(*s == c)
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	38 45 fc             	cmp    %al,-0x4(%ebp)
 2aa:	75 05                	jne    2b1 <strchr+0x1e>
      return (char*)s;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	eb 13                	jmp    2c4 <strchr+0x31>
  for(; *s; s++)
 2b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	84 c0                	test   %al,%al
 2bd:	75 e2                	jne    2a1 <strchr+0xe>
  return 0;
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c4:	c9                   	leave
 2c5:	c3                   	ret

000002c6 <gets>:

char*
gets(char *buf, int max)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d3:	eb 42                	jmp    317 <gets+0x51>
    cc = read(0, &c, 1);
 2d5:	83 ec 04             	sub    $0x4,%esp
 2d8:	6a 01                	push   $0x1
 2da:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2dd:	50                   	push   %eax
 2de:	6a 00                	push   $0x0
 2e0:	e8 47 01 00 00       	call   42c <read>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ef:	7e 33                	jle    324 <gets+0x5e>
      break;
    buf[i++] = c;
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	01 c2                	add    %eax,%edx
 301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	3c 0a                	cmp    $0xa,%al
 30d:	74 16                	je     325 <gets+0x5f>
 30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 313:	3c 0d                	cmp    $0xd,%al
 315:	74 0e                	je     325 <gets+0x5f>
  for(i=0; i+1 < max; ){
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	83 c0 01             	add    $0x1,%eax
 31d:	39 45 0c             	cmp    %eax,0xc(%ebp)
 320:	7f b3                	jg     2d5 <gets+0xf>
 322:	eb 01                	jmp    325 <gets+0x5f>
      break;
 324:	90                   	nop
      break;
  }
  buf[i] = '\0';
 325:	8b 55 f4             	mov    -0xc(%ebp),%edx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
}
 333:	c9                   	leave
 334:	c3                   	ret

00000335 <stat>:

int
stat(char *n, struct stat *st)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33b:	83 ec 08             	sub    $0x8,%esp
 33e:	6a 00                	push   $0x0
 340:	ff 75 08             	push   0x8(%ebp)
 343:	e8 0c 01 00 00       	call   454 <open>
 348:	83 c4 10             	add    $0x10,%esp
 34b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 352:	79 07                	jns    35b <stat+0x26>
    return -1;
 354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 359:	eb 25                	jmp    380 <stat+0x4b>
  r = fstat(fd, st);
 35b:	83 ec 08             	sub    $0x8,%esp
 35e:	ff 75 0c             	push   0xc(%ebp)
 361:	ff 75 f4             	push   -0xc(%ebp)
 364:	e8 03 01 00 00       	call   46c <fstat>
 369:	83 c4 10             	add    $0x10,%esp
 36c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36f:	83 ec 0c             	sub    $0xc,%esp
 372:	ff 75 f4             	push   -0xc(%ebp)
 375:	e8 c2 00 00 00       	call   43c <close>
 37a:	83 c4 10             	add    $0x10,%esp
  return r;
 37d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 380:	c9                   	leave
 381:	c3                   	ret

00000382 <atoi>:

int
atoi(const char *s)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 38f:	eb 25                	jmp    3b6 <atoi+0x34>
    n = n*10 + *s++ - '0';
 391:	8b 55 fc             	mov    -0x4(%ebp),%edx
 394:	89 d0                	mov    %edx,%eax
 396:	c1 e0 02             	shl    $0x2,%eax
 399:	01 d0                	add    %edx,%eax
 39b:	01 c0                	add    %eax,%eax
 39d:	89 c1                	mov    %eax,%ecx
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	8d 50 01             	lea    0x1(%eax),%edx
 3a5:	89 55 08             	mov    %edx,0x8(%ebp)
 3a8:	0f b6 00             	movzbl (%eax),%eax
 3ab:	0f be c0             	movsbl %al,%eax
 3ae:	01 c8                	add    %ecx,%eax
 3b0:	83 e8 30             	sub    $0x30,%eax
 3b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	0f b6 00             	movzbl (%eax),%eax
 3bc:	3c 2f                	cmp    $0x2f,%al
 3be:	7e 0a                	jle    3ca <atoi+0x48>
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	0f b6 00             	movzbl (%eax),%eax
 3c6:	3c 39                	cmp    $0x39,%al
 3c8:	7e c7                	jle    391 <atoi+0xf>
  return n;
 3ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3cd:	c9                   	leave
 3ce:	c3                   	ret

000003cf <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e1:	eb 17                	jmp    3fa <memmove+0x2b>
    *dst++ = *src++;
 3e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3e6:	8d 42 01             	lea    0x1(%edx),%eax
 3e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
 3ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ef:	8d 48 01             	lea    0x1(%eax),%ecx
 3f2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 3f5:	0f b6 12             	movzbl (%edx),%edx
 3f8:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 3fa:	8b 45 10             	mov    0x10(%ebp),%eax
 3fd:	8d 50 ff             	lea    -0x1(%eax),%edx
 400:	89 55 10             	mov    %edx,0x10(%ebp)
 403:	85 c0                	test   %eax,%eax
 405:	7f dc                	jg     3e3 <memmove+0x14>
  return vdst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave
 40b:	c3                   	ret

0000040c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 40c:	b8 01 00 00 00       	mov    $0x1,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret

00000414 <exit>:
SYSCALL(exit)
 414:	b8 02 00 00 00       	mov    $0x2,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret

0000041c <wait>:
SYSCALL(wait)
 41c:	b8 03 00 00 00       	mov    $0x3,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret

00000424 <pipe>:
SYSCALL(pipe)
 424:	b8 04 00 00 00       	mov    $0x4,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret

0000042c <read>:
SYSCALL(read)
 42c:	b8 05 00 00 00       	mov    $0x5,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret

00000434 <write>:
SYSCALL(write)
 434:	b8 10 00 00 00       	mov    $0x10,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret

0000043c <close>:
SYSCALL(close)
 43c:	b8 15 00 00 00       	mov    $0x15,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret

00000444 <kill>:
SYSCALL(kill)
 444:	b8 06 00 00 00       	mov    $0x6,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret

0000044c <exec>:
SYSCALL(exec)
 44c:	b8 07 00 00 00       	mov    $0x7,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret

00000454 <open>:
SYSCALL(open)
 454:	b8 0f 00 00 00       	mov    $0xf,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret

0000045c <mknod>:
SYSCALL(mknod)
 45c:	b8 11 00 00 00       	mov    $0x11,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret

00000464 <unlink>:
SYSCALL(unlink)
 464:	b8 12 00 00 00       	mov    $0x12,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret

0000046c <fstat>:
SYSCALL(fstat)
 46c:	b8 08 00 00 00       	mov    $0x8,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret

00000474 <link>:
SYSCALL(link)
 474:	b8 13 00 00 00       	mov    $0x13,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret

0000047c <mkdir>:
SYSCALL(mkdir)
 47c:	b8 14 00 00 00       	mov    $0x14,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret

00000484 <chdir>:
SYSCALL(chdir)
 484:	b8 09 00 00 00       	mov    $0x9,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret

0000048c <dup>:
SYSCALL(dup)
 48c:	b8 0a 00 00 00       	mov    $0xa,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret

00000494 <getpid>:
SYSCALL(getpid)
 494:	b8 0b 00 00 00       	mov    $0xb,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret

0000049c <sbrk>:
SYSCALL(sbrk)
 49c:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret

000004a4 <sleep>:
SYSCALL(sleep)
 4a4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret

000004ac <uptime>:
SYSCALL(uptime)
 4ac:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret

000004b4 <wait2>:
SYSCALL(wait2)
 4b4:	b8 17 00 00 00       	mov    $0x17,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret

000004bc <exit2>:
SYSCALL(exit2)
 4bc:	b8 16 00 00 00       	mov    $0x16,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret

000004c4 <uthread_init>:
 4c4:	b8 18 00 00 00       	mov    $0x18,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret

000004cc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4cc:	55                   	push   %ebp
 4cd:	89 e5                	mov    %esp,%ebp
 4cf:	83 ec 18             	sub    $0x18,%esp
 4d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d8:	83 ec 04             	sub    $0x4,%esp
 4db:	6a 01                	push   $0x1
 4dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4e0:	50                   	push   %eax
 4e1:	ff 75 08             	push   0x8(%ebp)
 4e4:	e8 4b ff ff ff       	call   434 <write>
 4e9:	83 c4 10             	add    $0x10,%esp
}
 4ec:	90                   	nop
 4ed:	c9                   	leave
 4ee:	c3                   	ret

000004ef <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ef:	55                   	push   %ebp
 4f0:	89 e5                	mov    %esp,%ebp
 4f2:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4fc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 500:	74 17                	je     519 <printint+0x2a>
 502:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 506:	79 11                	jns    519 <printint+0x2a>
    neg = 1;
 508:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 50f:	8b 45 0c             	mov    0xc(%ebp),%eax
 512:	f7 d8                	neg    %eax
 514:	89 45 ec             	mov    %eax,-0x14(%ebp)
 517:	eb 06                	jmp    51f <printint+0x30>
  } else {
    x = xx;
 519:	8b 45 0c             	mov    0xc(%ebp),%eax
 51c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 51f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 526:	8b 4d 10             	mov    0x10(%ebp),%ecx
 529:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52c:	ba 00 00 00 00       	mov    $0x0,%edx
 531:	f7 f1                	div    %ecx
 533:	89 d1                	mov    %edx,%ecx
 535:	8b 45 f4             	mov    -0xc(%ebp),%eax
 538:	8d 50 01             	lea    0x1(%eax),%edx
 53b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 53e:	0f b6 91 00 0c 00 00 	movzbl 0xc00(%ecx),%edx
 545:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 549:	8b 4d 10             	mov    0x10(%ebp),%ecx
 54c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 54f:	ba 00 00 00 00       	mov    $0x0,%edx
 554:	f7 f1                	div    %ecx
 556:	89 45 ec             	mov    %eax,-0x14(%ebp)
 559:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55d:	75 c7                	jne    526 <printint+0x37>
  if(neg)
 55f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 563:	74 2d                	je     592 <printint+0xa3>
    buf[i++] = '-';
 565:	8b 45 f4             	mov    -0xc(%ebp),%eax
 568:	8d 50 01             	lea    0x1(%eax),%edx
 56b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 56e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 573:	eb 1d                	jmp    592 <printint+0xa3>
    putc(fd, buf[i]);
 575:	8d 55 dc             	lea    -0x24(%ebp),%edx
 578:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57b:	01 d0                	add    %edx,%eax
 57d:	0f b6 00             	movzbl (%eax),%eax
 580:	0f be c0             	movsbl %al,%eax
 583:	83 ec 08             	sub    $0x8,%esp
 586:	50                   	push   %eax
 587:	ff 75 08             	push   0x8(%ebp)
 58a:	e8 3d ff ff ff       	call   4cc <putc>
 58f:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 592:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59a:	79 d9                	jns    575 <printint+0x86>
}
 59c:	90                   	nop
 59d:	90                   	nop
 59e:	c9                   	leave
 59f:	c3                   	ret

000005a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ad:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b0:	83 c0 04             	add    $0x4,%eax
 5b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5bd:	e9 59 01 00 00       	jmp    71b <printf+0x17b>
    c = fmt[i] & 0xff;
 5c2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c8:	01 d0                	add    %edx,%eax
 5ca:	0f b6 00             	movzbl (%eax),%eax
 5cd:	0f be c0             	movsbl %al,%eax
 5d0:	25 ff 00 00 00       	and    $0xff,%eax
 5d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5dc:	75 2c                	jne    60a <printf+0x6a>
      if(c == '%'){
 5de:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e2:	75 0c                	jne    5f0 <printf+0x50>
        state = '%';
 5e4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5eb:	e9 27 01 00 00       	jmp    717 <printf+0x177>
      } else {
        putc(fd, c);
 5f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f3:	0f be c0             	movsbl %al,%eax
 5f6:	83 ec 08             	sub    $0x8,%esp
 5f9:	50                   	push   %eax
 5fa:	ff 75 08             	push   0x8(%ebp)
 5fd:	e8 ca fe ff ff       	call   4cc <putc>
 602:	83 c4 10             	add    $0x10,%esp
 605:	e9 0d 01 00 00       	jmp    717 <printf+0x177>
      }
    } else if(state == '%'){
 60a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 60e:	0f 85 03 01 00 00    	jne    717 <printf+0x177>
      if(c == 'd'){
 614:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 618:	75 1e                	jne    638 <printf+0x98>
        printint(fd, *ap, 10, 1);
 61a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61d:	8b 00                	mov    (%eax),%eax
 61f:	6a 01                	push   $0x1
 621:	6a 0a                	push   $0xa
 623:	50                   	push   %eax
 624:	ff 75 08             	push   0x8(%ebp)
 627:	e8 c3 fe ff ff       	call   4ef <printint>
 62c:	83 c4 10             	add    $0x10,%esp
        ap++;
 62f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 633:	e9 d8 00 00 00       	jmp    710 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 638:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 63c:	74 06                	je     644 <printf+0xa4>
 63e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 642:	75 1e                	jne    662 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 644:	8b 45 e8             	mov    -0x18(%ebp),%eax
 647:	8b 00                	mov    (%eax),%eax
 649:	6a 00                	push   $0x0
 64b:	6a 10                	push   $0x10
 64d:	50                   	push   %eax
 64e:	ff 75 08             	push   0x8(%ebp)
 651:	e8 99 fe ff ff       	call   4ef <printint>
 656:	83 c4 10             	add    $0x10,%esp
        ap++;
 659:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65d:	e9 ae 00 00 00       	jmp    710 <printf+0x170>
      } else if(c == 's'){
 662:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 666:	75 43                	jne    6ab <printf+0x10b>
        s = (char*)*ap;
 668:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 670:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 674:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 678:	75 25                	jne    69f <printf+0xff>
          s = "(null)";
 67a:	c7 45 f4 8f 09 00 00 	movl   $0x98f,-0xc(%ebp)
        while(*s != 0){
 681:	eb 1c                	jmp    69f <printf+0xff>
          putc(fd, *s);
 683:	8b 45 f4             	mov    -0xc(%ebp),%eax
 686:	0f b6 00             	movzbl (%eax),%eax
 689:	0f be c0             	movsbl %al,%eax
 68c:	83 ec 08             	sub    $0x8,%esp
 68f:	50                   	push   %eax
 690:	ff 75 08             	push   0x8(%ebp)
 693:	e8 34 fe ff ff       	call   4cc <putc>
 698:	83 c4 10             	add    $0x10,%esp
          s++;
 69b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 69f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a2:	0f b6 00             	movzbl (%eax),%eax
 6a5:	84 c0                	test   %al,%al
 6a7:	75 da                	jne    683 <printf+0xe3>
 6a9:	eb 65                	jmp    710 <printf+0x170>
        }
      } else if(c == 'c'){
 6ab:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6af:	75 1d                	jne    6ce <printf+0x12e>
        putc(fd, *ap);
 6b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b4:	8b 00                	mov    (%eax),%eax
 6b6:	0f be c0             	movsbl %al,%eax
 6b9:	83 ec 08             	sub    $0x8,%esp
 6bc:	50                   	push   %eax
 6bd:	ff 75 08             	push   0x8(%ebp)
 6c0:	e8 07 fe ff ff       	call   4cc <putc>
 6c5:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6cc:	eb 42                	jmp    710 <printf+0x170>
      } else if(c == '%'){
 6ce:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d2:	75 17                	jne    6eb <printf+0x14b>
        putc(fd, c);
 6d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d7:	0f be c0             	movsbl %al,%eax
 6da:	83 ec 08             	sub    $0x8,%esp
 6dd:	50                   	push   %eax
 6de:	ff 75 08             	push   0x8(%ebp)
 6e1:	e8 e6 fd ff ff       	call   4cc <putc>
 6e6:	83 c4 10             	add    $0x10,%esp
 6e9:	eb 25                	jmp    710 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6eb:	83 ec 08             	sub    $0x8,%esp
 6ee:	6a 25                	push   $0x25
 6f0:	ff 75 08             	push   0x8(%ebp)
 6f3:	e8 d4 fd ff ff       	call   4cc <putc>
 6f8:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6fe:	0f be c0             	movsbl %al,%eax
 701:	83 ec 08             	sub    $0x8,%esp
 704:	50                   	push   %eax
 705:	ff 75 08             	push   0x8(%ebp)
 708:	e8 bf fd ff ff       	call   4cc <putc>
 70d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 710:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 717:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 71b:	8b 55 0c             	mov    0xc(%ebp),%edx
 71e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 721:	01 d0                	add    %edx,%eax
 723:	0f b6 00             	movzbl (%eax),%eax
 726:	84 c0                	test   %al,%al
 728:	0f 85 94 fe ff ff    	jne    5c2 <printf+0x22>
    }
  }
}
 72e:	90                   	nop
 72f:	90                   	nop
 730:	c9                   	leave
 731:	c3                   	ret

00000732 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 732:	55                   	push   %ebp
 733:	89 e5                	mov    %esp,%ebp
 735:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 738:	8b 45 08             	mov    0x8(%ebp),%eax
 73b:	83 e8 08             	sub    $0x8,%eax
 73e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 741:	a1 28 0e 00 00       	mov    0xe28,%eax
 746:	89 45 fc             	mov    %eax,-0x4(%ebp)
 749:	eb 24                	jmp    76f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	8b 00                	mov    (%eax),%eax
 750:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 753:	72 12                	jb     767 <free+0x35>
 755:	8b 45 f8             	mov    -0x8(%ebp),%eax
 758:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 75b:	72 24                	jb     781 <free+0x4f>
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	8b 00                	mov    (%eax),%eax
 762:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 765:	72 1a                	jb     781 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 775:	73 d4                	jae    74b <free+0x19>
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	8b 00                	mov    (%eax),%eax
 77c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 77f:	73 ca                	jae    74b <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 781:	8b 45 f8             	mov    -0x8(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 78e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 791:	01 c2                	add    %eax,%edx
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	39 c2                	cmp    %eax,%edx
 79a:	75 24                	jne    7c0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 79c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79f:	8b 50 04             	mov    0x4(%eax),%edx
 7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a5:	8b 00                	mov    (%eax),%eax
 7a7:	8b 40 04             	mov    0x4(%eax),%eax
 7aa:	01 c2                	add    %eax,%edx
 7ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7af:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b5:	8b 00                	mov    (%eax),%eax
 7b7:	8b 10                	mov    (%eax),%edx
 7b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bc:	89 10                	mov    %edx,(%eax)
 7be:	eb 0a                	jmp    7ca <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c3:	8b 10                	mov    (%eax),%edx
 7c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cd:	8b 40 04             	mov    0x4(%eax),%eax
 7d0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7da:	01 d0                	add    %edx,%eax
 7dc:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7df:	75 20                	jne    801 <free+0xcf>
    p->s.size += bp->s.size;
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	8b 50 04             	mov    0x4(%eax),%edx
 7e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ea:	8b 40 04             	mov    0x4(%eax),%eax
 7ed:	01 c2                	add    %eax,%edx
 7ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	8b 10                	mov    (%eax),%edx
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	89 10                	mov    %edx,(%eax)
 7ff:	eb 08                	jmp    809 <free+0xd7>
  } else
    p->s.ptr = bp;
 801:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804:	8b 55 f8             	mov    -0x8(%ebp),%edx
 807:	89 10                	mov    %edx,(%eax)
  freep = p;
 809:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80c:	a3 28 0e 00 00       	mov    %eax,0xe28
}
 811:	90                   	nop
 812:	c9                   	leave
 813:	c3                   	ret

00000814 <morecore>:

static Header*
morecore(uint nu)
{
 814:	55                   	push   %ebp
 815:	89 e5                	mov    %esp,%ebp
 817:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 81a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 821:	77 07                	ja     82a <morecore+0x16>
    nu = 4096;
 823:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 82a:	8b 45 08             	mov    0x8(%ebp),%eax
 82d:	c1 e0 03             	shl    $0x3,%eax
 830:	83 ec 0c             	sub    $0xc,%esp
 833:	50                   	push   %eax
 834:	e8 63 fc ff ff       	call   49c <sbrk>
 839:	83 c4 10             	add    $0x10,%esp
 83c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 83f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 843:	75 07                	jne    84c <morecore+0x38>
    return 0;
 845:	b8 00 00 00 00       	mov    $0x0,%eax
 84a:	eb 26                	jmp    872 <morecore+0x5e>
  hp = (Header*)p;
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 852:	8b 45 f0             	mov    -0x10(%ebp),%eax
 855:	8b 55 08             	mov    0x8(%ebp),%edx
 858:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 85b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85e:	83 c0 08             	add    $0x8,%eax
 861:	83 ec 0c             	sub    $0xc,%esp
 864:	50                   	push   %eax
 865:	e8 c8 fe ff ff       	call   732 <free>
 86a:	83 c4 10             	add    $0x10,%esp
  return freep;
 86d:	a1 28 0e 00 00       	mov    0xe28,%eax
}
 872:	c9                   	leave
 873:	c3                   	ret

00000874 <malloc>:

void*
malloc(uint nbytes)
{
 874:	55                   	push   %ebp
 875:	89 e5                	mov    %esp,%ebp
 877:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87a:	8b 45 08             	mov    0x8(%ebp),%eax
 87d:	83 c0 07             	add    $0x7,%eax
 880:	c1 e8 03             	shr    $0x3,%eax
 883:	83 c0 01             	add    $0x1,%eax
 886:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 889:	a1 28 0e 00 00       	mov    0xe28,%eax
 88e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 891:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 895:	75 23                	jne    8ba <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 897:	c7 45 f0 20 0e 00 00 	movl   $0xe20,-0x10(%ebp)
 89e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a1:	a3 28 0e 00 00       	mov    %eax,0xe28
 8a6:	a1 28 0e 00 00       	mov    0xe28,%eax
 8ab:	a3 20 0e 00 00       	mov    %eax,0xe20
    base.s.size = 0;
 8b0:	c7 05 24 0e 00 00 00 	movl   $0x0,0xe24
 8b7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bd:	8b 00                	mov    (%eax),%eax
 8bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c5:	8b 40 04             	mov    0x4(%eax),%eax
 8c8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8cb:	72 4d                	jb     91a <malloc+0xa6>
      if(p->s.size == nunits)
 8cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d0:	8b 40 04             	mov    0x4(%eax),%eax
 8d3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8d6:	75 0c                	jne    8e4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	8b 10                	mov    (%eax),%edx
 8dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e0:	89 10                	mov    %edx,(%eax)
 8e2:	eb 26                	jmp    90a <malloc+0x96>
      else {
        p->s.size -= nunits;
 8e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e7:	8b 40 04             	mov    0x4(%eax),%eax
 8ea:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8ed:	89 c2                	mov    %eax,%edx
 8ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f8:	8b 40 04             	mov    0x4(%eax),%eax
 8fb:	c1 e0 03             	shl    $0x3,%eax
 8fe:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 901:	8b 45 f4             	mov    -0xc(%ebp),%eax
 904:	8b 55 ec             	mov    -0x14(%ebp),%edx
 907:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 90a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90d:	a3 28 0e 00 00       	mov    %eax,0xe28
      return (void*)(p + 1);
 912:	8b 45 f4             	mov    -0xc(%ebp),%eax
 915:	83 c0 08             	add    $0x8,%eax
 918:	eb 3b                	jmp    955 <malloc+0xe1>
    }
    if(p == freep)
 91a:	a1 28 0e 00 00       	mov    0xe28,%eax
 91f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 922:	75 1e                	jne    942 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 924:	83 ec 0c             	sub    $0xc,%esp
 927:	ff 75 ec             	push   -0x14(%ebp)
 92a:	e8 e5 fe ff ff       	call   814 <morecore>
 92f:	83 c4 10             	add    $0x10,%esp
 932:	89 45 f4             	mov    %eax,-0xc(%ebp)
 935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 939:	75 07                	jne    942 <malloc+0xce>
        return 0;
 93b:	b8 00 00 00 00       	mov    $0x0,%eax
 940:	eb 13                	jmp    955 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 942:	8b 45 f4             	mov    -0xc(%ebp),%eax
 945:	89 45 f0             	mov    %eax,-0x10(%ebp)
 948:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94b:	8b 00                	mov    (%eax),%eax
 94d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 950:	e9 6d ff ff ff       	jmp    8c2 <malloc+0x4e>
  }
}
 955:	c9                   	leave
 956:	c3                   	ret
