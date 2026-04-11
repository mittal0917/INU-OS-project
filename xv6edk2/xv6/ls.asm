
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	push   0x8(%ebp)
   d:	e8 c7 03 00 00       	call   3d9 <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	8b 55 08             	mov    0x8(%ebp),%edx
  18:	01 d0                	add    %edx,%eax
  1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1d:	eb 04                	jmp    23 <fmtname+0x23>
  1f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  26:	3b 45 08             	cmp    0x8(%ebp),%eax
  29:	72 0a                	jb     35 <fmtname+0x35>
  2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2e:	0f b6 00             	movzbl (%eax),%eax
  31:	3c 2f                	cmp    $0x2f,%al
  33:	75 ea                	jne    1f <fmtname+0x1f>
    ;
  p++;
  35:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  39:	83 ec 0c             	sub    $0xc,%esp
  3c:	ff 75 f4             	push   -0xc(%ebp)
  3f:	e8 95 03 00 00       	call   3d9 <strlen>
  44:	83 c4 10             	add    $0x10,%esp
  47:	83 f8 0d             	cmp    $0xd,%eax
  4a:	76 05                	jbe    51 <fmtname+0x51>
    return p;
  4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4f:	eb 60                	jmp    b1 <fmtname+0xb1>
  memmove(buf, p, strlen(p));
  51:	83 ec 0c             	sub    $0xc,%esp
  54:	ff 75 f4             	push   -0xc(%ebp)
  57:	e8 7d 03 00 00       	call   3d9 <strlen>
  5c:	83 c4 10             	add    $0x10,%esp
  5f:	83 ec 04             	sub    $0x4,%esp
  62:	50                   	push   %eax
  63:	ff 75 f4             	push   -0xc(%ebp)
  66:	68 e0 0d 00 00       	push   $0xde0
  6b:	e8 e6 04 00 00       	call   556 <memmove>
  70:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  73:	83 ec 0c             	sub    $0xc,%esp
  76:	ff 75 f4             	push   -0xc(%ebp)
  79:	e8 5b 03 00 00       	call   3d9 <strlen>
  7e:	83 c4 10             	add    $0x10,%esp
  81:	ba 0e 00 00 00       	mov    $0xe,%edx
  86:	89 d3                	mov    %edx,%ebx
  88:	29 c3                	sub    %eax,%ebx
  8a:	83 ec 0c             	sub    $0xc,%esp
  8d:	ff 75 f4             	push   -0xc(%ebp)
  90:	e8 44 03 00 00       	call   3d9 <strlen>
  95:	83 c4 10             	add    $0x10,%esp
  98:	05 e0 0d 00 00       	add    $0xde0,%eax
  9d:	83 ec 04             	sub    $0x4,%esp
  a0:	53                   	push   %ebx
  a1:	6a 20                	push   $0x20
  a3:	50                   	push   %eax
  a4:	e8 57 03 00 00       	call   400 <memset>
  a9:	83 c4 10             	add    $0x10,%esp
  return buf;
  ac:	b8 e0 0d 00 00       	mov    $0xde0,%eax
}
  b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b4:	c9                   	leave
  b5:	c3                   	ret

000000b6 <ls>:

void
ls(char *path)
{
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	57                   	push   %edi
  ba:	56                   	push   %esi
  bb:	53                   	push   %ebx
  bc:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  c2:	83 ec 08             	sub    $0x8,%esp
  c5:	6a 00                	push   $0x0
  c7:	ff 75 08             	push   0x8(%ebp)
  ca:	e8 0c 05 00 00       	call   5db <open>
  cf:	83 c4 10             	add    $0x10,%esp
  d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d9:	79 1a                	jns    f5 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  db:	83 ec 04             	sub    $0x4,%esp
  de:	ff 75 08             	push   0x8(%ebp)
  e1:	68 de 0a 00 00       	push   $0xade
  e6:	6a 02                	push   $0x2
  e8:	e8 3a 06 00 00       	call   727 <printf>
  ed:	83 c4 10             	add    $0x10,%esp
    return;
  f0:	e9 e3 01 00 00       	jmp    2d8 <ls+0x222>
  }

  if(fstat(fd, &st) < 0){
  f5:	83 ec 08             	sub    $0x8,%esp
  f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fe:	50                   	push   %eax
  ff:	ff 75 e4             	push   -0x1c(%ebp)
 102:	e8 ec 04 00 00       	call   5f3 <fstat>
 107:	83 c4 10             	add    $0x10,%esp
 10a:	85 c0                	test   %eax,%eax
 10c:	79 28                	jns    136 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 10e:	83 ec 04             	sub    $0x4,%esp
 111:	ff 75 08             	push   0x8(%ebp)
 114:	68 f2 0a 00 00       	push   $0xaf2
 119:	6a 02                	push   $0x2
 11b:	e8 07 06 00 00       	call   727 <printf>
 120:	83 c4 10             	add    $0x10,%esp
    close(fd);
 123:	83 ec 0c             	sub    $0xc,%esp
 126:	ff 75 e4             	push   -0x1c(%ebp)
 129:	e8 95 04 00 00       	call   5c3 <close>
 12e:	83 c4 10             	add    $0x10,%esp
    return;
 131:	e9 a2 01 00 00       	jmp    2d8 <ls+0x222>
  }

  switch(st.type){
 136:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 13d:	98                   	cwtl
 13e:	83 f8 01             	cmp    $0x1,%eax
 141:	74 48                	je     18b <ls+0xd5>
 143:	83 f8 02             	cmp    $0x2,%eax
 146:	0f 85 7e 01 00 00    	jne    2ca <ls+0x214>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 14c:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 152:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 158:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 15f:	0f bf d8             	movswl %ax,%ebx
 162:	83 ec 0c             	sub    $0xc,%esp
 165:	ff 75 08             	push   0x8(%ebp)
 168:	e8 93 fe ff ff       	call   0 <fmtname>
 16d:	83 c4 10             	add    $0x10,%esp
 170:	83 ec 08             	sub    $0x8,%esp
 173:	57                   	push   %edi
 174:	56                   	push   %esi
 175:	53                   	push   %ebx
 176:	50                   	push   %eax
 177:	68 06 0b 00 00       	push   $0xb06
 17c:	6a 01                	push   $0x1
 17e:	e8 a4 05 00 00       	call   727 <printf>
 183:	83 c4 20             	add    $0x20,%esp
    break;
 186:	e9 3f 01 00 00       	jmp    2ca <ls+0x214>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 18b:	83 ec 0c             	sub    $0xc,%esp
 18e:	ff 75 08             	push   0x8(%ebp)
 191:	e8 43 02 00 00       	call   3d9 <strlen>
 196:	83 c4 10             	add    $0x10,%esp
 199:	83 c0 10             	add    $0x10,%eax
 19c:	3d 00 02 00 00       	cmp    $0x200,%eax
 1a1:	76 17                	jbe    1ba <ls+0x104>
      printf(1, "ls: path too long\n");
 1a3:	83 ec 08             	sub    $0x8,%esp
 1a6:	68 13 0b 00 00       	push   $0xb13
 1ab:	6a 01                	push   $0x1
 1ad:	e8 75 05 00 00       	call   727 <printf>
 1b2:	83 c4 10             	add    $0x10,%esp
      break;
 1b5:	e9 10 01 00 00       	jmp    2ca <ls+0x214>
    }
    strcpy(buf, path);
 1ba:	83 ec 08             	sub    $0x8,%esp
 1bd:	ff 75 08             	push   0x8(%ebp)
 1c0:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1c6:	50                   	push   %eax
 1c7:	e8 9e 01 00 00       	call   36a <strcpy>
 1cc:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1cf:	83 ec 0c             	sub    $0xc,%esp
 1d2:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d8:	50                   	push   %eax
 1d9:	e8 fb 01 00 00       	call   3d9 <strlen>
 1de:	83 c4 10             	add    $0x10,%esp
 1e1:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1e7:	01 d0                	add    %edx,%eax
 1e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1ef:	8d 50 01             	lea    0x1(%eax),%edx
 1f2:	89 55 e0             	mov    %edx,-0x20(%ebp)
 1f5:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f8:	e9 ac 00 00 00       	jmp    2a9 <ls+0x1f3>
      if(de.inum == 0)
 1fd:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 204:	66 85 c0             	test   %ax,%ax
 207:	0f 84 9b 00 00 00    	je     2a8 <ls+0x1f2>
        continue;
      memmove(p, de.name, DIRSIZ);
 20d:	83 ec 04             	sub    $0x4,%esp
 210:	6a 0e                	push   $0xe
 212:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 218:	83 c0 02             	add    $0x2,%eax
 21b:	50                   	push   %eax
 21c:	ff 75 e0             	push   -0x20(%ebp)
 21f:	e8 32 03 00 00       	call   556 <memmove>
 224:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 227:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22a:	83 c0 0e             	add    $0xe,%eax
 22d:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 230:	83 ec 08             	sub    $0x8,%esp
 233:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 239:	50                   	push   %eax
 23a:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 240:	50                   	push   %eax
 241:	e8 76 02 00 00       	call   4bc <stat>
 246:	83 c4 10             	add    $0x10,%esp
 249:	85 c0                	test   %eax,%eax
 24b:	79 1b                	jns    268 <ls+0x1b2>
        printf(1, "ls: cannot stat %s\n", buf);
 24d:	83 ec 04             	sub    $0x4,%esp
 250:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 256:	50                   	push   %eax
 257:	68 f2 0a 00 00       	push   $0xaf2
 25c:	6a 01                	push   $0x1
 25e:	e8 c4 04 00 00       	call   727 <printf>
 263:	83 c4 10             	add    $0x10,%esp
        continue;
 266:	eb 41                	jmp    2a9 <ls+0x1f3>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 268:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 26e:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 274:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 27b:	0f bf d8             	movswl %ax,%ebx
 27e:	83 ec 0c             	sub    $0xc,%esp
 281:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 287:	50                   	push   %eax
 288:	e8 73 fd ff ff       	call   0 <fmtname>
 28d:	83 c4 10             	add    $0x10,%esp
 290:	83 ec 08             	sub    $0x8,%esp
 293:	57                   	push   %edi
 294:	56                   	push   %esi
 295:	53                   	push   %ebx
 296:	50                   	push   %eax
 297:	68 06 0b 00 00       	push   $0xb06
 29c:	6a 01                	push   $0x1
 29e:	e8 84 04 00 00       	call   727 <printf>
 2a3:	83 c4 20             	add    $0x20,%esp
 2a6:	eb 01                	jmp    2a9 <ls+0x1f3>
        continue;
 2a8:	90                   	nop
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2a9:	83 ec 04             	sub    $0x4,%esp
 2ac:	6a 10                	push   $0x10
 2ae:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2b4:	50                   	push   %eax
 2b5:	ff 75 e4             	push   -0x1c(%ebp)
 2b8:	e8 f6 02 00 00       	call   5b3 <read>
 2bd:	83 c4 10             	add    $0x10,%esp
 2c0:	83 f8 10             	cmp    $0x10,%eax
 2c3:	0f 84 34 ff ff ff    	je     1fd <ls+0x147>
    }
    break;
 2c9:	90                   	nop
  }
  close(fd);
 2ca:	83 ec 0c             	sub    $0xc,%esp
 2cd:	ff 75 e4             	push   -0x1c(%ebp)
 2d0:	e8 ee 02 00 00       	call   5c3 <close>
 2d5:	83 c4 10             	add    $0x10,%esp
}
 2d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2db:	5b                   	pop    %ebx
 2dc:	5e                   	pop    %esi
 2dd:	5f                   	pop    %edi
 2de:	5d                   	pop    %ebp
 2df:	c3                   	ret

000002e0 <main>:

int
main(int argc, char *argv[])
{
 2e0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2e4:	83 e4 f0             	and    $0xfffffff0,%esp
 2e7:	ff 71 fc             	push   -0x4(%ecx)
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	53                   	push   %ebx
 2ee:	51                   	push   %ecx
 2ef:	83 ec 10             	sub    $0x10,%esp
 2f2:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 2f4:	83 3b 01             	cmpl   $0x1,(%ebx)
 2f7:	7f 15                	jg     30e <main+0x2e>
    ls(".");
 2f9:	83 ec 0c             	sub    $0xc,%esp
 2fc:	68 26 0b 00 00       	push   $0xb26
 301:	e8 b0 fd ff ff       	call   b6 <ls>
 306:	83 c4 10             	add    $0x10,%esp
    exit();
 309:	e8 8d 02 00 00       	call   59b <exit>
  }
  for(i=1; i<argc; i++)
 30e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 315:	eb 21                	jmp    338 <main+0x58>
    ls(argv[i]);
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 321:	8b 43 04             	mov    0x4(%ebx),%eax
 324:	01 d0                	add    %edx,%eax
 326:	8b 00                	mov    (%eax),%eax
 328:	83 ec 0c             	sub    $0xc,%esp
 32b:	50                   	push   %eax
 32c:	e8 85 fd ff ff       	call   b6 <ls>
 331:	83 c4 10             	add    $0x10,%esp
  for(i=1; i<argc; i++)
 334:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 338:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33b:	3b 03                	cmp    (%ebx),%eax
 33d:	7c d8                	jl     317 <main+0x37>
  exit();
 33f:	e8 57 02 00 00       	call   59b <exit>

00000344 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	57                   	push   %edi
 348:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 349:	8b 4d 08             	mov    0x8(%ebp),%ecx
 34c:	8b 55 10             	mov    0x10(%ebp),%edx
 34f:	8b 45 0c             	mov    0xc(%ebp),%eax
 352:	89 cb                	mov    %ecx,%ebx
 354:	89 df                	mov    %ebx,%edi
 356:	89 d1                	mov    %edx,%ecx
 358:	fc                   	cld
 359:	f3 aa                	rep stos %al,%es:(%edi)
 35b:	89 ca                	mov    %ecx,%edx
 35d:	89 fb                	mov    %edi,%ebx
 35f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 362:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 365:	90                   	nop
 366:	5b                   	pop    %ebx
 367:	5f                   	pop    %edi
 368:	5d                   	pop    %ebp
 369:	c3                   	ret

0000036a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 36a:	55                   	push   %ebp
 36b:	89 e5                	mov    %esp,%ebp
 36d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 370:	8b 45 08             	mov    0x8(%ebp),%eax
 373:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 376:	90                   	nop
 377:	8b 55 0c             	mov    0xc(%ebp),%edx
 37a:	8d 42 01             	lea    0x1(%edx),%eax
 37d:	89 45 0c             	mov    %eax,0xc(%ebp)
 380:	8b 45 08             	mov    0x8(%ebp),%eax
 383:	8d 48 01             	lea    0x1(%eax),%ecx
 386:	89 4d 08             	mov    %ecx,0x8(%ebp)
 389:	0f b6 12             	movzbl (%edx),%edx
 38c:	88 10                	mov    %dl,(%eax)
 38e:	0f b6 00             	movzbl (%eax),%eax
 391:	84 c0                	test   %al,%al
 393:	75 e2                	jne    377 <strcpy+0xd>
    ;
  return os;
 395:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 398:	c9                   	leave
 399:	c3                   	ret

0000039a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39a:	55                   	push   %ebp
 39b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 39d:	eb 08                	jmp    3a7 <strcmp+0xd>
    p++, q++;
 39f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
 3aa:	0f b6 00             	movzbl (%eax),%eax
 3ad:	84 c0                	test   %al,%al
 3af:	74 10                	je     3c1 <strcmp+0x27>
 3b1:	8b 45 08             	mov    0x8(%ebp),%eax
 3b4:	0f b6 10             	movzbl (%eax),%edx
 3b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ba:	0f b6 00             	movzbl (%eax),%eax
 3bd:	38 c2                	cmp    %al,%dl
 3bf:	74 de                	je     39f <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	0f b6 00             	movzbl (%eax),%eax
 3c7:	0f b6 d0             	movzbl %al,%edx
 3ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cd:	0f b6 00             	movzbl (%eax),%eax
 3d0:	0f b6 c0             	movzbl %al,%eax
 3d3:	29 c2                	sub    %eax,%edx
 3d5:	89 d0                	mov    %edx,%eax
}
 3d7:	5d                   	pop    %ebp
 3d8:	c3                   	ret

000003d9 <strlen>:

uint
strlen(char *s)
{
 3d9:	55                   	push   %ebp
 3da:	89 e5                	mov    %esp,%ebp
 3dc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3e6:	eb 04                	jmp    3ec <strlen+0x13>
 3e8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3ef:	8b 45 08             	mov    0x8(%ebp),%eax
 3f2:	01 d0                	add    %edx,%eax
 3f4:	0f b6 00             	movzbl (%eax),%eax
 3f7:	84 c0                	test   %al,%al
 3f9:	75 ed                	jne    3e8 <strlen+0xf>
    ;
  return n;
 3fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3fe:	c9                   	leave
 3ff:	c3                   	ret

00000400 <memset>:

void*
memset(void *dst, int c, uint n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 403:	8b 45 10             	mov    0x10(%ebp),%eax
 406:	50                   	push   %eax
 407:	ff 75 0c             	push   0xc(%ebp)
 40a:	ff 75 08             	push   0x8(%ebp)
 40d:	e8 32 ff ff ff       	call   344 <stosb>
 412:	83 c4 0c             	add    $0xc,%esp
  return dst;
 415:	8b 45 08             	mov    0x8(%ebp),%eax
}
 418:	c9                   	leave
 419:	c3                   	ret

0000041a <strchr>:

char*
strchr(const char *s, char c)
{
 41a:	55                   	push   %ebp
 41b:	89 e5                	mov    %esp,%ebp
 41d:	83 ec 04             	sub    $0x4,%esp
 420:	8b 45 0c             	mov    0xc(%ebp),%eax
 423:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 426:	eb 14                	jmp    43c <strchr+0x22>
    if(*s == c)
 428:	8b 45 08             	mov    0x8(%ebp),%eax
 42b:	0f b6 00             	movzbl (%eax),%eax
 42e:	38 45 fc             	cmp    %al,-0x4(%ebp)
 431:	75 05                	jne    438 <strchr+0x1e>
      return (char*)s;
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	eb 13                	jmp    44b <strchr+0x31>
  for(; *s; s++)
 438:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 43c:	8b 45 08             	mov    0x8(%ebp),%eax
 43f:	0f b6 00             	movzbl (%eax),%eax
 442:	84 c0                	test   %al,%al
 444:	75 e2                	jne    428 <strchr+0xe>
  return 0;
 446:	b8 00 00 00 00       	mov    $0x0,%eax
}
 44b:	c9                   	leave
 44c:	c3                   	ret

0000044d <gets>:

char*
gets(char *buf, int max)
{
 44d:	55                   	push   %ebp
 44e:	89 e5                	mov    %esp,%ebp
 450:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 453:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 45a:	eb 42                	jmp    49e <gets+0x51>
    cc = read(0, &c, 1);
 45c:	83 ec 04             	sub    $0x4,%esp
 45f:	6a 01                	push   $0x1
 461:	8d 45 ef             	lea    -0x11(%ebp),%eax
 464:	50                   	push   %eax
 465:	6a 00                	push   $0x0
 467:	e8 47 01 00 00       	call   5b3 <read>
 46c:	83 c4 10             	add    $0x10,%esp
 46f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 472:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 476:	7e 33                	jle    4ab <gets+0x5e>
      break;
    buf[i++] = c;
 478:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47b:	8d 50 01             	lea    0x1(%eax),%edx
 47e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 481:	89 c2                	mov    %eax,%edx
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	01 c2                	add    %eax,%edx
 488:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 48e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 492:	3c 0a                	cmp    $0xa,%al
 494:	74 16                	je     4ac <gets+0x5f>
 496:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 49a:	3c 0d                	cmp    $0xd,%al
 49c:	74 0e                	je     4ac <gets+0x5f>
  for(i=0; i+1 < max; ){
 49e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a1:	83 c0 01             	add    $0x1,%eax
 4a4:	39 45 0c             	cmp    %eax,0xc(%ebp)
 4a7:	7f b3                	jg     45c <gets+0xf>
 4a9:	eb 01                	jmp    4ac <gets+0x5f>
      break;
 4ab:	90                   	nop
      break;
  }
  buf[i] = '\0';
 4ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	01 d0                	add    %edx,%eax
 4b4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ba:	c9                   	leave
 4bb:	c3                   	ret

000004bc <stat>:

int
stat(char *n, struct stat *st)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c2:	83 ec 08             	sub    $0x8,%esp
 4c5:	6a 00                	push   $0x0
 4c7:	ff 75 08             	push   0x8(%ebp)
 4ca:	e8 0c 01 00 00       	call   5db <open>
 4cf:	83 c4 10             	add    $0x10,%esp
 4d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d9:	79 07                	jns    4e2 <stat+0x26>
    return -1;
 4db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4e0:	eb 25                	jmp    507 <stat+0x4b>
  r = fstat(fd, st);
 4e2:	83 ec 08             	sub    $0x8,%esp
 4e5:	ff 75 0c             	push   0xc(%ebp)
 4e8:	ff 75 f4             	push   -0xc(%ebp)
 4eb:	e8 03 01 00 00       	call   5f3 <fstat>
 4f0:	83 c4 10             	add    $0x10,%esp
 4f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4f6:	83 ec 0c             	sub    $0xc,%esp
 4f9:	ff 75 f4             	push   -0xc(%ebp)
 4fc:	e8 c2 00 00 00       	call   5c3 <close>
 501:	83 c4 10             	add    $0x10,%esp
  return r;
 504:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 507:	c9                   	leave
 508:	c3                   	ret

00000509 <atoi>:

int
atoi(const char *s)
{
 509:	55                   	push   %ebp
 50a:	89 e5                	mov    %esp,%ebp
 50c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 50f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 516:	eb 25                	jmp    53d <atoi+0x34>
    n = n*10 + *s++ - '0';
 518:	8b 55 fc             	mov    -0x4(%ebp),%edx
 51b:	89 d0                	mov    %edx,%eax
 51d:	c1 e0 02             	shl    $0x2,%eax
 520:	01 d0                	add    %edx,%eax
 522:	01 c0                	add    %eax,%eax
 524:	89 c1                	mov    %eax,%ecx
 526:	8b 45 08             	mov    0x8(%ebp),%eax
 529:	8d 50 01             	lea    0x1(%eax),%edx
 52c:	89 55 08             	mov    %edx,0x8(%ebp)
 52f:	0f b6 00             	movzbl (%eax),%eax
 532:	0f be c0             	movsbl %al,%eax
 535:	01 c8                	add    %ecx,%eax
 537:	83 e8 30             	sub    $0x30,%eax
 53a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	0f b6 00             	movzbl (%eax),%eax
 543:	3c 2f                	cmp    $0x2f,%al
 545:	7e 0a                	jle    551 <atoi+0x48>
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	0f b6 00             	movzbl (%eax),%eax
 54d:	3c 39                	cmp    $0x39,%al
 54f:	7e c7                	jle    518 <atoi+0xf>
  return n;
 551:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 554:	c9                   	leave
 555:	c3                   	ret

00000556 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 556:	55                   	push   %ebp
 557:	89 e5                	mov    %esp,%ebp
 559:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
 55f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 562:	8b 45 0c             	mov    0xc(%ebp),%eax
 565:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 568:	eb 17                	jmp    581 <memmove+0x2b>
    *dst++ = *src++;
 56a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 56d:	8d 42 01             	lea    0x1(%edx),%eax
 570:	89 45 f8             	mov    %eax,-0x8(%ebp)
 573:	8b 45 fc             	mov    -0x4(%ebp),%eax
 576:	8d 48 01             	lea    0x1(%eax),%ecx
 579:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 57c:	0f b6 12             	movzbl (%edx),%edx
 57f:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 581:	8b 45 10             	mov    0x10(%ebp),%eax
 584:	8d 50 ff             	lea    -0x1(%eax),%edx
 587:	89 55 10             	mov    %edx,0x10(%ebp)
 58a:	85 c0                	test   %eax,%eax
 58c:	7f dc                	jg     56a <memmove+0x14>
  return vdst;
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 591:	c9                   	leave
 592:	c3                   	ret

00000593 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 593:	b8 01 00 00 00       	mov    $0x1,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret

0000059b <exit>:
SYSCALL(exit)
 59b:	b8 02 00 00 00       	mov    $0x2,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret

000005a3 <wait>:
SYSCALL(wait)
 5a3:	b8 03 00 00 00       	mov    $0x3,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret

000005ab <pipe>:
SYSCALL(pipe)
 5ab:	b8 04 00 00 00       	mov    $0x4,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret

000005b3 <read>:
SYSCALL(read)
 5b3:	b8 05 00 00 00       	mov    $0x5,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret

000005bb <write>:
SYSCALL(write)
 5bb:	b8 10 00 00 00       	mov    $0x10,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret

000005c3 <close>:
SYSCALL(close)
 5c3:	b8 15 00 00 00       	mov    $0x15,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret

000005cb <kill>:
SYSCALL(kill)
 5cb:	b8 06 00 00 00       	mov    $0x6,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret

000005d3 <exec>:
SYSCALL(exec)
 5d3:	b8 07 00 00 00       	mov    $0x7,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret

000005db <open>:
SYSCALL(open)
 5db:	b8 0f 00 00 00       	mov    $0xf,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret

000005e3 <mknod>:
SYSCALL(mknod)
 5e3:	b8 11 00 00 00       	mov    $0x11,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret

000005eb <unlink>:
SYSCALL(unlink)
 5eb:	b8 12 00 00 00       	mov    $0x12,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret

000005f3 <fstat>:
SYSCALL(fstat)
 5f3:	b8 08 00 00 00       	mov    $0x8,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret

000005fb <link>:
SYSCALL(link)
 5fb:	b8 13 00 00 00       	mov    $0x13,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret

00000603 <mkdir>:
SYSCALL(mkdir)
 603:	b8 14 00 00 00       	mov    $0x14,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret

0000060b <chdir>:
SYSCALL(chdir)
 60b:	b8 09 00 00 00       	mov    $0x9,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret

00000613 <dup>:
SYSCALL(dup)
 613:	b8 0a 00 00 00       	mov    $0xa,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret

0000061b <getpid>:
SYSCALL(getpid)
 61b:	b8 0b 00 00 00       	mov    $0xb,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret

00000623 <sbrk>:
SYSCALL(sbrk)
 623:	b8 0c 00 00 00       	mov    $0xc,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret

0000062b <sleep>:
SYSCALL(sleep)
 62b:	b8 0d 00 00 00       	mov    $0xd,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret

00000633 <uptime>:
SYSCALL(uptime)
 633:	b8 0e 00 00 00       	mov    $0xe,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret

0000063b <wait2>:
SYSCALL(wait2)
 63b:	b8 17 00 00 00       	mov    $0x17,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret

00000643 <exit2>:
SYSCALL(exit2)
 643:	b8 16 00 00 00       	mov    $0x16,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret

0000064b <uthread_init>:
 64b:	b8 18 00 00 00       	mov    $0x18,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret

00000653 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 653:	55                   	push   %ebp
 654:	89 e5                	mov    %esp,%ebp
 656:	83 ec 18             	sub    $0x18,%esp
 659:	8b 45 0c             	mov    0xc(%ebp),%eax
 65c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 65f:	83 ec 04             	sub    $0x4,%esp
 662:	6a 01                	push   $0x1
 664:	8d 45 f4             	lea    -0xc(%ebp),%eax
 667:	50                   	push   %eax
 668:	ff 75 08             	push   0x8(%ebp)
 66b:	e8 4b ff ff ff       	call   5bb <write>
 670:	83 c4 10             	add    $0x10,%esp
}
 673:	90                   	nop
 674:	c9                   	leave
 675:	c3                   	ret

00000676 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 676:	55                   	push   %ebp
 677:	89 e5                	mov    %esp,%ebp
 679:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 67c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 683:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 687:	74 17                	je     6a0 <printint+0x2a>
 689:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 68d:	79 11                	jns    6a0 <printint+0x2a>
    neg = 1;
 68f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 696:	8b 45 0c             	mov    0xc(%ebp),%eax
 699:	f7 d8                	neg    %eax
 69b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 69e:	eb 06                	jmp    6a6 <printint+0x30>
  } else {
    x = xx;
 6a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6b3:	ba 00 00 00 00       	mov    $0x0,%edx
 6b8:	f7 f1                	div    %ecx
 6ba:	89 d1                	mov    %edx,%ecx
 6bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bf:	8d 50 01             	lea    0x1(%eax),%edx
 6c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6c5:	0f b6 91 cc 0d 00 00 	movzbl 0xdcc(%ecx),%edx
 6cc:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 6d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6d6:	ba 00 00 00 00       	mov    $0x0,%edx
 6db:	f7 f1                	div    %ecx
 6dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6e4:	75 c7                	jne    6ad <printint+0x37>
  if(neg)
 6e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6ea:	74 2d                	je     719 <printint+0xa3>
    buf[i++] = '-';
 6ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ef:	8d 50 01             	lea    0x1(%eax),%edx
 6f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6f5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6fa:	eb 1d                	jmp    719 <printint+0xa3>
    putc(fd, buf[i]);
 6fc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 702:	01 d0                	add    %edx,%eax
 704:	0f b6 00             	movzbl (%eax),%eax
 707:	0f be c0             	movsbl %al,%eax
 70a:	83 ec 08             	sub    $0x8,%esp
 70d:	50                   	push   %eax
 70e:	ff 75 08             	push   0x8(%ebp)
 711:	e8 3d ff ff ff       	call   653 <putc>
 716:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 719:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 71d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 721:	79 d9                	jns    6fc <printint+0x86>
}
 723:	90                   	nop
 724:	90                   	nop
 725:	c9                   	leave
 726:	c3                   	ret

00000727 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 727:	55                   	push   %ebp
 728:	89 e5                	mov    %esp,%ebp
 72a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 72d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 734:	8d 45 0c             	lea    0xc(%ebp),%eax
 737:	83 c0 04             	add    $0x4,%eax
 73a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 73d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 744:	e9 59 01 00 00       	jmp    8a2 <printf+0x17b>
    c = fmt[i] & 0xff;
 749:	8b 55 0c             	mov    0xc(%ebp),%edx
 74c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74f:	01 d0                	add    %edx,%eax
 751:	0f b6 00             	movzbl (%eax),%eax
 754:	0f be c0             	movsbl %al,%eax
 757:	25 ff 00 00 00       	and    $0xff,%eax
 75c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 75f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 763:	75 2c                	jne    791 <printf+0x6a>
      if(c == '%'){
 765:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 769:	75 0c                	jne    777 <printf+0x50>
        state = '%';
 76b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 772:	e9 27 01 00 00       	jmp    89e <printf+0x177>
      } else {
        putc(fd, c);
 777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 77a:	0f be c0             	movsbl %al,%eax
 77d:	83 ec 08             	sub    $0x8,%esp
 780:	50                   	push   %eax
 781:	ff 75 08             	push   0x8(%ebp)
 784:	e8 ca fe ff ff       	call   653 <putc>
 789:	83 c4 10             	add    $0x10,%esp
 78c:	e9 0d 01 00 00       	jmp    89e <printf+0x177>
      }
    } else if(state == '%'){
 791:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 795:	0f 85 03 01 00 00    	jne    89e <printf+0x177>
      if(c == 'd'){
 79b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 79f:	75 1e                	jne    7bf <printf+0x98>
        printint(fd, *ap, 10, 1);
 7a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	6a 01                	push   $0x1
 7a8:	6a 0a                	push   $0xa
 7aa:	50                   	push   %eax
 7ab:	ff 75 08             	push   0x8(%ebp)
 7ae:	e8 c3 fe ff ff       	call   676 <printint>
 7b3:	83 c4 10             	add    $0x10,%esp
        ap++;
 7b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ba:	e9 d8 00 00 00       	jmp    897 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7bf:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7c3:	74 06                	je     7cb <printf+0xa4>
 7c5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7c9:	75 1e                	jne    7e9 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ce:	8b 00                	mov    (%eax),%eax
 7d0:	6a 00                	push   $0x0
 7d2:	6a 10                	push   $0x10
 7d4:	50                   	push   %eax
 7d5:	ff 75 08             	push   0x8(%ebp)
 7d8:	e8 99 fe ff ff       	call   676 <printint>
 7dd:	83 c4 10             	add    $0x10,%esp
        ap++;
 7e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7e4:	e9 ae 00 00 00       	jmp    897 <printf+0x170>
      } else if(c == 's'){
 7e9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7ed:	75 43                	jne    832 <printf+0x10b>
        s = (char*)*ap;
 7ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f2:	8b 00                	mov    (%eax),%eax
 7f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ff:	75 25                	jne    826 <printf+0xff>
          s = "(null)";
 801:	c7 45 f4 28 0b 00 00 	movl   $0xb28,-0xc(%ebp)
        while(*s != 0){
 808:	eb 1c                	jmp    826 <printf+0xff>
          putc(fd, *s);
 80a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80d:	0f b6 00             	movzbl (%eax),%eax
 810:	0f be c0             	movsbl %al,%eax
 813:	83 ec 08             	sub    $0x8,%esp
 816:	50                   	push   %eax
 817:	ff 75 08             	push   0x8(%ebp)
 81a:	e8 34 fe ff ff       	call   653 <putc>
 81f:	83 c4 10             	add    $0x10,%esp
          s++;
 822:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 826:	8b 45 f4             	mov    -0xc(%ebp),%eax
 829:	0f b6 00             	movzbl (%eax),%eax
 82c:	84 c0                	test   %al,%al
 82e:	75 da                	jne    80a <printf+0xe3>
 830:	eb 65                	jmp    897 <printf+0x170>
        }
      } else if(c == 'c'){
 832:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 836:	75 1d                	jne    855 <printf+0x12e>
        putc(fd, *ap);
 838:	8b 45 e8             	mov    -0x18(%ebp),%eax
 83b:	8b 00                	mov    (%eax),%eax
 83d:	0f be c0             	movsbl %al,%eax
 840:	83 ec 08             	sub    $0x8,%esp
 843:	50                   	push   %eax
 844:	ff 75 08             	push   0x8(%ebp)
 847:	e8 07 fe ff ff       	call   653 <putc>
 84c:	83 c4 10             	add    $0x10,%esp
        ap++;
 84f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 853:	eb 42                	jmp    897 <printf+0x170>
      } else if(c == '%'){
 855:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 859:	75 17                	jne    872 <printf+0x14b>
        putc(fd, c);
 85b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 85e:	0f be c0             	movsbl %al,%eax
 861:	83 ec 08             	sub    $0x8,%esp
 864:	50                   	push   %eax
 865:	ff 75 08             	push   0x8(%ebp)
 868:	e8 e6 fd ff ff       	call   653 <putc>
 86d:	83 c4 10             	add    $0x10,%esp
 870:	eb 25                	jmp    897 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 872:	83 ec 08             	sub    $0x8,%esp
 875:	6a 25                	push   $0x25
 877:	ff 75 08             	push   0x8(%ebp)
 87a:	e8 d4 fd ff ff       	call   653 <putc>
 87f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 885:	0f be c0             	movsbl %al,%eax
 888:	83 ec 08             	sub    $0x8,%esp
 88b:	50                   	push   %eax
 88c:	ff 75 08             	push   0x8(%ebp)
 88f:	e8 bf fd ff ff       	call   653 <putc>
 894:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 897:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 89e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8a2:	8b 55 0c             	mov    0xc(%ebp),%edx
 8a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a8:	01 d0                	add    %edx,%eax
 8aa:	0f b6 00             	movzbl (%eax),%eax
 8ad:	84 c0                	test   %al,%al
 8af:	0f 85 94 fe ff ff    	jne    749 <printf+0x22>
    }
  }
}
 8b5:	90                   	nop
 8b6:	90                   	nop
 8b7:	c9                   	leave
 8b8:	c3                   	ret

000008b9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b9:	55                   	push   %ebp
 8ba:	89 e5                	mov    %esp,%ebp
 8bc:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8bf:	8b 45 08             	mov    0x8(%ebp),%eax
 8c2:	83 e8 08             	sub    $0x8,%eax
 8c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c8:	a1 f8 0d 00 00       	mov    0xdf8,%eax
 8cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8d0:	eb 24                	jmp    8f6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d5:	8b 00                	mov    (%eax),%eax
 8d7:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8da:	72 12                	jb     8ee <free+0x35>
 8dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8df:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8e2:	72 24                	jb     908 <free+0x4f>
 8e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e7:	8b 00                	mov    (%eax),%eax
 8e9:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8ec:	72 1a                	jb     908 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f1:	8b 00                	mov    (%eax),%eax
 8f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f9:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8fc:	73 d4                	jae    8d2 <free+0x19>
 8fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 901:	8b 00                	mov    (%eax),%eax
 903:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 906:	73 ca                	jae    8d2 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 908:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90b:	8b 40 04             	mov    0x4(%eax),%eax
 90e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 915:	8b 45 f8             	mov    -0x8(%ebp),%eax
 918:	01 c2                	add    %eax,%edx
 91a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91d:	8b 00                	mov    (%eax),%eax
 91f:	39 c2                	cmp    %eax,%edx
 921:	75 24                	jne    947 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 923:	8b 45 f8             	mov    -0x8(%ebp),%eax
 926:	8b 50 04             	mov    0x4(%eax),%edx
 929:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92c:	8b 00                	mov    (%eax),%eax
 92e:	8b 40 04             	mov    0x4(%eax),%eax
 931:	01 c2                	add    %eax,%edx
 933:	8b 45 f8             	mov    -0x8(%ebp),%eax
 936:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 939:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93c:	8b 00                	mov    (%eax),%eax
 93e:	8b 10                	mov    (%eax),%edx
 940:	8b 45 f8             	mov    -0x8(%ebp),%eax
 943:	89 10                	mov    %edx,(%eax)
 945:	eb 0a                	jmp    951 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 947:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94a:	8b 10                	mov    (%eax),%edx
 94c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 951:	8b 45 fc             	mov    -0x4(%ebp),%eax
 954:	8b 40 04             	mov    0x4(%eax),%eax
 957:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 95e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 961:	01 d0                	add    %edx,%eax
 963:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 966:	75 20                	jne    988 <free+0xcf>
    p->s.size += bp->s.size;
 968:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96b:	8b 50 04             	mov    0x4(%eax),%edx
 96e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 971:	8b 40 04             	mov    0x4(%eax),%eax
 974:	01 c2                	add    %eax,%edx
 976:	8b 45 fc             	mov    -0x4(%ebp),%eax
 979:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 97c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97f:	8b 10                	mov    (%eax),%edx
 981:	8b 45 fc             	mov    -0x4(%ebp),%eax
 984:	89 10                	mov    %edx,(%eax)
 986:	eb 08                	jmp    990 <free+0xd7>
  } else
    p->s.ptr = bp;
 988:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 98e:	89 10                	mov    %edx,(%eax)
  freep = p;
 990:	8b 45 fc             	mov    -0x4(%ebp),%eax
 993:	a3 f8 0d 00 00       	mov    %eax,0xdf8
}
 998:	90                   	nop
 999:	c9                   	leave
 99a:	c3                   	ret

0000099b <morecore>:

static Header*
morecore(uint nu)
{
 99b:	55                   	push   %ebp
 99c:	89 e5                	mov    %esp,%ebp
 99e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9a1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9a8:	77 07                	ja     9b1 <morecore+0x16>
    nu = 4096;
 9aa:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9b1:	8b 45 08             	mov    0x8(%ebp),%eax
 9b4:	c1 e0 03             	shl    $0x3,%eax
 9b7:	83 ec 0c             	sub    $0xc,%esp
 9ba:	50                   	push   %eax
 9bb:	e8 63 fc ff ff       	call   623 <sbrk>
 9c0:	83 c4 10             	add    $0x10,%esp
 9c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9c6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9ca:	75 07                	jne    9d3 <morecore+0x38>
    return 0;
 9cc:	b8 00 00 00 00       	mov    $0x0,%eax
 9d1:	eb 26                	jmp    9f9 <morecore+0x5e>
  hp = (Header*)p;
 9d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9dc:	8b 55 08             	mov    0x8(%ebp),%edx
 9df:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e5:	83 c0 08             	add    $0x8,%eax
 9e8:	83 ec 0c             	sub    $0xc,%esp
 9eb:	50                   	push   %eax
 9ec:	e8 c8 fe ff ff       	call   8b9 <free>
 9f1:	83 c4 10             	add    $0x10,%esp
  return freep;
 9f4:	a1 f8 0d 00 00       	mov    0xdf8,%eax
}
 9f9:	c9                   	leave
 9fa:	c3                   	ret

000009fb <malloc>:

void*
malloc(uint nbytes)
{
 9fb:	55                   	push   %ebp
 9fc:	89 e5                	mov    %esp,%ebp
 9fe:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a01:	8b 45 08             	mov    0x8(%ebp),%eax
 a04:	83 c0 07             	add    $0x7,%eax
 a07:	c1 e8 03             	shr    $0x3,%eax
 a0a:	83 c0 01             	add    $0x1,%eax
 a0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a10:	a1 f8 0d 00 00       	mov    0xdf8,%eax
 a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a1c:	75 23                	jne    a41 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a1e:	c7 45 f0 f0 0d 00 00 	movl   $0xdf0,-0x10(%ebp)
 a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a28:	a3 f8 0d 00 00       	mov    %eax,0xdf8
 a2d:	a1 f8 0d 00 00       	mov    0xdf8,%eax
 a32:	a3 f0 0d 00 00       	mov    %eax,0xdf0
    base.s.size = 0;
 a37:	c7 05 f4 0d 00 00 00 	movl   $0x0,0xdf4
 a3e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a44:	8b 00                	mov    (%eax),%eax
 a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4c:	8b 40 04             	mov    0x4(%eax),%eax
 a4f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a52:	72 4d                	jb     aa1 <malloc+0xa6>
      if(p->s.size == nunits)
 a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a57:	8b 40 04             	mov    0x4(%eax),%eax
 a5a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a5d:	75 0c                	jne    a6b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a62:	8b 10                	mov    (%eax),%edx
 a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a67:	89 10                	mov    %edx,(%eax)
 a69:	eb 26                	jmp    a91 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6e:	8b 40 04             	mov    0x4(%eax),%eax
 a71:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a74:	89 c2                	mov    %eax,%edx
 a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a79:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7f:	8b 40 04             	mov    0x4(%eax),%eax
 a82:	c1 e0 03             	shl    $0x3,%eax
 a85:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a8e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a94:	a3 f8 0d 00 00       	mov    %eax,0xdf8
      return (void*)(p + 1);
 a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9c:	83 c0 08             	add    $0x8,%eax
 a9f:	eb 3b                	jmp    adc <malloc+0xe1>
    }
    if(p == freep)
 aa1:	a1 f8 0d 00 00       	mov    0xdf8,%eax
 aa6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 aa9:	75 1e                	jne    ac9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 aab:	83 ec 0c             	sub    $0xc,%esp
 aae:	ff 75 ec             	push   -0x14(%ebp)
 ab1:	e8 e5 fe ff ff       	call   99b <morecore>
 ab6:	83 c4 10             	add    $0x10,%esp
 ab9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 abc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ac0:	75 07                	jne    ac9 <malloc+0xce>
        return 0;
 ac2:	b8 00 00 00 00       	mov    $0x0,%eax
 ac7:	eb 13                	jmp    adc <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad2:	8b 00                	mov    (%eax),%eax
 ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ad7:	e9 6d ff ff ff       	jmp    a49 <malloc+0x4e>
  }
}
 adc:	c9                   	leave
 add:	c3                   	ret
