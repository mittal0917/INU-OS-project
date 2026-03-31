
kernelmemfs:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <wait_main>:
8010000c:	00 00                	add    %al,(%eax)
	...

80100010 <entry>:
  .long 0
# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  #Set Data Segment
  mov $0x10,%ax
80100010:	66 b8 10 00          	mov    $0x10,%ax
  mov %ax,%ds
80100014:	8e d8                	mov    %eax,%ds
  mov %ax,%es
80100016:	8e c0                	mov    %eax,%es
  mov %ax,%ss
80100018:	8e d0                	mov    %eax,%ss
  mov $0,%ax
8010001a:	66 b8 00 00          	mov    $0x0,%ax
  mov %ax,%fs
8010001e:	8e e0                	mov    %eax,%fs
  mov %ax,%gs
80100020:	8e e8                	mov    %eax,%gs

  #Turn off paing
  movl %cr0,%eax
80100022:	0f 20 c0             	mov    %cr0,%eax
  andl $0x7fffffff,%eax
80100025:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  movl %eax,%cr0 
8010002a:	0f 22 c0             	mov    %eax,%cr0

  #Set Page Table Base Address
  movl    $(V2P_WO(entrypgdir)), %eax
8010002d:	b8 00 e0 10 00       	mov    $0x10e000,%eax
  movl    %eax, %cr3
80100032:	0f 22 d8             	mov    %eax,%cr3
  
  #Disable IA32e mode
  movl $0x0c0000080,%ecx
80100035:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  rdmsr
8010003a:	0f 32                	rdmsr
  andl $0xFFFFFEFF,%eax
8010003c:	25 ff fe ff ff       	and    $0xfffffeff,%eax
  wrmsr
80100041:	0f 30                	wrmsr

  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
80100043:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
80100046:	83 c8 10             	or     $0x10,%eax
  andl    $0xFFFFFFDF, %eax
80100049:	83 e0 df             	and    $0xffffffdf,%eax
  movl    %eax, %cr4
8010004c:	0f 22 e0             	mov    %eax,%cr4

  #Turn on Paging
  movl    %cr0, %eax
8010004f:	0f 20 c0             	mov    %cr0,%eax
  orl     $0x80010001, %eax
80100052:	0d 01 00 01 80       	or     $0x80010001,%eax
  movl    %eax, %cr0
80100057:	0f 22 c0             	mov    %eax,%cr0




  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
8010005a:	bc 80 80 19 80       	mov    $0x80198080,%esp
  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
#  jz .waiting_main
  movl $main, %edx
8010005f:	ba 67 33 10 80       	mov    $0x80103367,%edx
  jmp %edx
80100064:	ff e2                	jmp    *%edx

80100066 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100066:	55                   	push   %ebp
80100067:	89 e5                	mov    %esp,%ebp
80100069:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010006c:	83 ec 08             	sub    $0x8,%esp
8010006f:	68 40 a2 10 80       	push   $0x8010a240
80100074:	68 00 d0 18 80       	push   $0x8018d000
80100079:	e8 b2 48 00 00       	call   80104930 <initlock>
8010007e:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100081:	c7 05 4c 17 19 80 fc 	movl   $0x801916fc,0x8019174c
80100088:	16 19 80 
  bcache.head.next = &bcache.head;
8010008b:	c7 05 50 17 19 80 fc 	movl   $0x801916fc,0x80191750
80100092:	16 19 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100095:	c7 45 f4 34 d0 18 80 	movl   $0x8018d034,-0xc(%ebp)
8010009c:	eb 47                	jmp    801000e5 <binit+0x7f>
    b->next = bcache.head.next;
8010009e:	8b 15 50 17 19 80    	mov    0x80191750,%edx
801000a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a7:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801000aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ad:	c7 40 50 fc 16 19 80 	movl   $0x801916fc,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
801000b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000b7:	83 c0 0c             	add    $0xc,%eax
801000ba:	83 ec 08             	sub    $0x8,%esp
801000bd:	68 47 a2 10 80       	push   $0x8010a247
801000c2:	50                   	push   %eax
801000c3:	e8 0b 47 00 00       	call   801047d3 <initsleeplock>
801000c8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000cb:	a1 50 17 19 80       	mov    0x80191750,%eax
801000d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000d3:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d9:	a3 50 17 19 80       	mov    %eax,0x80191750
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000de:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000e5:	b8 fc 16 19 80       	mov    $0x801916fc,%eax
801000ea:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ed:	72 af                	jb     8010009e <binit+0x38>
  }
}
801000ef:	90                   	nop
801000f0:	90                   	nop
801000f1:	c9                   	leave
801000f2:	c3                   	ret

801000f3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000f3:	55                   	push   %ebp
801000f4:	89 e5                	mov    %esp,%ebp
801000f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000f9:	83 ec 0c             	sub    $0xc,%esp
801000fc:	68 00 d0 18 80       	push   $0x8018d000
80100101:	e8 4c 48 00 00       	call   80104952 <acquire>
80100106:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100109:	a1 50 17 19 80       	mov    0x80191750,%eax
8010010e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100111:	eb 58                	jmp    8010016b <bget+0x78>
    if(b->dev == dev && b->blockno == blockno){
80100113:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100116:	8b 40 04             	mov    0x4(%eax),%eax
80100119:	39 45 08             	cmp    %eax,0x8(%ebp)
8010011c:	75 44                	jne    80100162 <bget+0x6f>
8010011e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100121:	8b 40 08             	mov    0x8(%eax),%eax
80100124:	39 45 0c             	cmp    %eax,0xc(%ebp)
80100127:	75 39                	jne    80100162 <bget+0x6f>
      b->refcnt++;
80100129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010012c:	8b 40 4c             	mov    0x4c(%eax),%eax
8010012f:	8d 50 01             	lea    0x1(%eax),%edx
80100132:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100135:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
80100138:	83 ec 0c             	sub    $0xc,%esp
8010013b:	68 00 d0 18 80       	push   $0x8018d000
80100140:	e8 7b 48 00 00       	call   801049c0 <release>
80100145:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 b8 46 00 00       	call   8010480f <acquiresleep>
80100157:	83 c4 10             	add    $0x10,%esp
      return b;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	e9 9d 00 00 00       	jmp    801001ff <bget+0x10c>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100165:	8b 40 54             	mov    0x54(%eax),%eax
80100168:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010016b:	81 7d f4 fc 16 19 80 	cmpl   $0x801916fc,-0xc(%ebp)
80100172:	75 9f                	jne    80100113 <bget+0x20>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100174:	a1 4c 17 19 80       	mov    0x8019174c,%eax
80100179:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010017c:	eb 6b                	jmp    801001e9 <bget+0xf6>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010017e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100181:	8b 40 4c             	mov    0x4c(%eax),%eax
80100184:	85 c0                	test   %eax,%eax
80100186:	75 58                	jne    801001e0 <bget+0xed>
80100188:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010018b:	8b 00                	mov    (%eax),%eax
8010018d:	83 e0 04             	and    $0x4,%eax
80100190:	85 c0                	test   %eax,%eax
80100192:	75 4c                	jne    801001e0 <bget+0xed>
      b->dev = dev;
80100194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100197:	8b 55 08             	mov    0x8(%ebp),%edx
8010019a:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010019d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801001a3:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
801001a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
801001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b2:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
801001b9:	83 ec 0c             	sub    $0xc,%esp
801001bc:	68 00 d0 18 80       	push   $0x8018d000
801001c1:	e8 fa 47 00 00       	call   801049c0 <release>
801001c6:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 37 46 00 00       	call   8010480f <acquiresleep>
801001d8:	83 c4 10             	add    $0x10,%esp
      return b;
801001db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001de:	eb 1f                	jmp    801001ff <bget+0x10c>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001e3:	8b 40 50             	mov    0x50(%eax),%eax
801001e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001e9:	81 7d f4 fc 16 19 80 	cmpl   $0x801916fc,-0xc(%ebp)
801001f0:	75 8c                	jne    8010017e <bget+0x8b>
    }
  }
  panic("bget: no buffers");
801001f2:	83 ec 0c             	sub    $0xc,%esp
801001f5:	68 4e a2 10 80       	push   $0x8010a24e
801001fa:	e8 aa 03 00 00       	call   801005a9 <panic>
}
801001ff:	c9                   	leave
80100200:	c3                   	ret

80100201 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100201:	55                   	push   %ebp
80100202:	89 e5                	mov    %esp,%ebp
80100204:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100207:	83 ec 08             	sub    $0x8,%esp
8010020a:	ff 75 0c             	push   0xc(%ebp)
8010020d:	ff 75 08             	push   0x8(%ebp)
80100210:	e8 de fe ff ff       	call   801000f3 <bget>
80100215:	83 c4 10             	add    $0x10,%esp
80100218:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
8010021b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010021e:	8b 00                	mov    (%eax),%eax
80100220:	83 e0 02             	and    $0x2,%eax
80100223:	85 c0                	test   %eax,%eax
80100225:	75 0e                	jne    80100235 <bread+0x34>
    iderw(b);
80100227:	83 ec 0c             	sub    $0xc,%esp
8010022a:	ff 75 f4             	push   -0xc(%ebp)
8010022d:	e8 00 9f 00 00       	call   8010a132 <iderw>
80100232:	83 c4 10             	add    $0x10,%esp
  }
  return b;
80100235:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100238:	c9                   	leave
80100239:	c3                   	ret

8010023a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
8010023a:	55                   	push   %ebp
8010023b:	89 e5                	mov    %esp,%ebp
8010023d:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100240:	8b 45 08             	mov    0x8(%ebp),%eax
80100243:	83 c0 0c             	add    $0xc,%eax
80100246:	83 ec 0c             	sub    $0xc,%esp
80100249:	50                   	push   %eax
8010024a:	e8 72 46 00 00       	call   801048c1 <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
    panic("bwrite");
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 5f a2 10 80       	push   $0x8010a25f
8010025e:	e8 46 03 00 00       	call   801005a9 <panic>
  b->flags |= B_DIRTY;
80100263:	8b 45 08             	mov    0x8(%ebp),%eax
80100266:	8b 00                	mov    (%eax),%eax
80100268:	83 c8 04             	or     $0x4,%eax
8010026b:	89 c2                	mov    %eax,%edx
8010026d:	8b 45 08             	mov    0x8(%ebp),%eax
80100270:	89 10                	mov    %edx,(%eax)
  iderw(b);
80100272:	83 ec 0c             	sub    $0xc,%esp
80100275:	ff 75 08             	push   0x8(%ebp)
80100278:	e8 b5 9e 00 00       	call   8010a132 <iderw>
8010027d:	83 c4 10             	add    $0x10,%esp
}
80100280:	90                   	nop
80100281:	c9                   	leave
80100282:	c3                   	ret

80100283 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100283:	55                   	push   %ebp
80100284:	89 e5                	mov    %esp,%ebp
80100286:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
80100289:	8b 45 08             	mov    0x8(%ebp),%eax
8010028c:	83 c0 0c             	add    $0xc,%eax
8010028f:	83 ec 0c             	sub    $0xc,%esp
80100292:	50                   	push   %eax
80100293:	e8 29 46 00 00       	call   801048c1 <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
    panic("brelse");
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 66 a2 10 80       	push   $0x8010a266
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>

  releasesleep(&b->lock);
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 b8 45 00 00       	call   80104873 <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 d0 18 80       	push   $0x8018d000
801002c6:	e8 87 46 00 00       	call   80104952 <acquire>
801002cb:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
801002ce:	8b 45 08             	mov    0x8(%ebp),%eax
801002d1:	8b 40 4c             	mov    0x4c(%eax),%eax
801002d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801002d7:	8b 45 08             	mov    0x8(%ebp),%eax
801002da:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002dd:	8b 45 08             	mov    0x8(%ebp),%eax
801002e0:	8b 40 4c             	mov    0x4c(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	75 47                	jne    8010032e <brelse+0xab>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002e7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ea:	8b 40 54             	mov    0x54(%eax),%eax
801002ed:	8b 55 08             	mov    0x8(%ebp),%edx
801002f0:	8b 52 50             	mov    0x50(%edx),%edx
801002f3:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002f6:	8b 45 08             	mov    0x8(%ebp),%eax
801002f9:	8b 40 50             	mov    0x50(%eax),%eax
801002fc:	8b 55 08             	mov    0x8(%ebp),%edx
801002ff:	8b 52 54             	mov    0x54(%edx),%edx
80100302:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100305:	8b 15 50 17 19 80    	mov    0x80191750,%edx
8010030b:	8b 45 08             	mov    0x8(%ebp),%eax
8010030e:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	c7 40 50 fc 16 19 80 	movl   $0x801916fc,0x50(%eax)
    bcache.head.next->prev = b;
8010031b:	a1 50 17 19 80       	mov    0x80191750,%eax
80100320:	8b 55 08             	mov    0x8(%ebp),%edx
80100323:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
80100326:	8b 45 08             	mov    0x8(%ebp),%eax
80100329:	a3 50 17 19 80       	mov    %eax,0x80191750
  }
  
  release(&bcache.lock);
8010032e:	83 ec 0c             	sub    $0xc,%esp
80100331:	68 00 d0 18 80       	push   $0x8018d000
80100336:	e8 85 46 00 00       	call   801049c0 <release>
8010033b:	83 c4 10             	add    $0x10,%esp
}
8010033e:	90                   	nop
8010033f:	c9                   	leave
80100340:	c3                   	ret

80100341 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100341:	55                   	push   %ebp
80100342:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100344:	fa                   	cli
}
80100345:	90                   	nop
80100346:	5d                   	pop    %ebp
80100347:	c3                   	ret

80100348 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100348:	55                   	push   %ebp
80100349:	89 e5                	mov    %esp,%ebp
8010034b:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010034e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100352:	74 1c                	je     80100370 <printint+0x28>
80100354:	8b 45 08             	mov    0x8(%ebp),%eax
80100357:	c1 e8 1f             	shr    $0x1f,%eax
8010035a:	0f b6 c0             	movzbl %al,%eax
8010035d:	89 45 10             	mov    %eax,0x10(%ebp)
80100360:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100364:	74 0a                	je     80100370 <printint+0x28>
    x = -xx;
80100366:	8b 45 08             	mov    0x8(%ebp),%eax
80100369:	f7 d8                	neg    %eax
8010036b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010036e:	eb 06                	jmp    80100376 <printint+0x2e>
  else
    x = xx;
80100370:	8b 45 08             	mov    0x8(%ebp),%eax
80100373:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100376:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010037d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100380:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100383:	ba 00 00 00 00       	mov    $0x0,%edx
80100388:	f7 f1                	div    %ecx
8010038a:	89 d1                	mov    %edx,%ecx
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	0f b6 91 04 d0 10 80 	movzbl -0x7fef2ffc(%ecx),%edx
8010039c:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
801003a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003a6:	ba 00 00 00 00       	mov    $0x0,%edx
801003ab:	f7 f1                	div    %ecx
801003ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003b4:	75 c7                	jne    8010037d <printint+0x35>

  if(sign)
801003b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003ba:	74 2a                	je     801003e6 <printint+0x9e>
    buf[i++] = '-';
801003bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003bf:	8d 50 01             	lea    0x1(%eax),%edx
801003c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003c5:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003ca:	eb 1a                	jmp    801003e6 <printint+0x9e>
    consputc(buf[i]);
801003cc:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003d2:	01 d0                	add    %edx,%eax
801003d4:	0f b6 00             	movzbl (%eax),%eax
801003d7:	0f be c0             	movsbl %al,%eax
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	50                   	push   %eax
801003de:	e8 8b 03 00 00       	call   8010076e <consputc>
801003e3:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003e6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003ee:	79 dc                	jns    801003cc <printint+0x84>
}
801003f0:	90                   	nop
801003f1:	90                   	nop
801003f2:	c9                   	leave
801003f3:	c3                   	ret

801003f4 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003f4:	55                   	push   %ebp
801003f5:	89 e5                	mov    %esp,%ebp
801003f7:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003fa:	a1 34 1a 19 80       	mov    0x80191a34,%eax
801003ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
80100402:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100406:	74 10                	je     80100418 <cprintf+0x24>
    acquire(&cons.lock);
80100408:	83 ec 0c             	sub    $0xc,%esp
8010040b:	68 00 1a 19 80       	push   $0x80191a00
80100410:	e8 3d 45 00 00       	call   80104952 <acquire>
80100415:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
    panic("null fmt");
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 6d a2 10 80       	push   $0x8010a26d
80100427:	e8 7d 01 00 00       	call   801005a9 <panic>


  argp = (uint*)(void*)(&fmt + 1);
8010042c:	8d 45 0c             	lea    0xc(%ebp),%eax
8010042f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100432:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100439:	e9 2f 01 00 00       	jmp    8010056d <cprintf+0x179>
    if(c != '%'){
8010043e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100442:	74 13                	je     80100457 <cprintf+0x63>
      consputc(c);
80100444:	83 ec 0c             	sub    $0xc,%esp
80100447:	ff 75 e4             	push   -0x1c(%ebp)
8010044a:	e8 1f 03 00 00       	call   8010076e <consputc>
8010044f:	83 c4 10             	add    $0x10,%esp
      continue;
80100452:	e9 12 01 00 00       	jmp    80100569 <cprintf+0x175>
    }
    c = fmt[++i] & 0xff;
80100457:	8b 55 08             	mov    0x8(%ebp),%edx
8010045a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010045e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100461:	01 d0                	add    %edx,%eax
80100463:	0f b6 00             	movzbl (%eax),%eax
80100466:	0f be c0             	movsbl %al,%eax
80100469:	25 ff 00 00 00       	and    $0xff,%eax
8010046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100471:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100475:	0f 84 14 01 00 00    	je     8010058f <cprintf+0x19b>
      break;
    switch(c){
8010047b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
8010047f:	74 5e                	je     801004df <cprintf+0xeb>
80100481:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100485:	0f 8f c2 00 00 00    	jg     8010054d <cprintf+0x159>
8010048b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
8010048f:	74 6b                	je     801004fc <cprintf+0x108>
80100491:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100495:	0f 8f b2 00 00 00    	jg     8010054d <cprintf+0x159>
8010049b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
8010049f:	74 3e                	je     801004df <cprintf+0xeb>
801004a1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
801004a5:	0f 8f a2 00 00 00    	jg     8010054d <cprintf+0x159>
801004ab:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004af:	0f 84 89 00 00 00    	je     8010053e <cprintf+0x14a>
801004b5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
801004b9:	0f 85 8e 00 00 00    	jne    8010054d <cprintf+0x159>
    case 'd':
      printint(*argp++, 10, 1);
801004bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c2:	8d 50 04             	lea    0x4(%eax),%edx
801004c5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c8:	8b 00                	mov    (%eax),%eax
801004ca:	83 ec 04             	sub    $0x4,%esp
801004cd:	6a 01                	push   $0x1
801004cf:	6a 0a                	push   $0xa
801004d1:	50                   	push   %eax
801004d2:	e8 71 fe ff ff       	call   80100348 <printint>
801004d7:	83 c4 10             	add    $0x10,%esp
      break;
801004da:	e9 8a 00 00 00       	jmp    80100569 <cprintf+0x175>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004e2:	8d 50 04             	lea    0x4(%eax),%edx
801004e5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004e8:	8b 00                	mov    (%eax),%eax
801004ea:	83 ec 04             	sub    $0x4,%esp
801004ed:	6a 00                	push   $0x0
801004ef:	6a 10                	push   $0x10
801004f1:	50                   	push   %eax
801004f2:	e8 51 fe ff ff       	call   80100348 <printint>
801004f7:	83 c4 10             	add    $0x10,%esp
      break;
801004fa:	eb 6d                	jmp    80100569 <cprintf+0x175>
    case 's':
      if((s = (char*)*argp++) == 0)
801004fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004ff:	8d 50 04             	lea    0x4(%eax),%edx
80100502:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100505:	8b 00                	mov    (%eax),%eax
80100507:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010050a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010050e:	75 22                	jne    80100532 <cprintf+0x13e>
        s = "(null)";
80100510:	c7 45 ec 76 a2 10 80 	movl   $0x8010a276,-0x14(%ebp)
      for(; *s; s++)
80100517:	eb 19                	jmp    80100532 <cprintf+0x13e>
        consputc(*s);
80100519:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010051c:	0f b6 00             	movzbl (%eax),%eax
8010051f:	0f be c0             	movsbl %al,%eax
80100522:	83 ec 0c             	sub    $0xc,%esp
80100525:	50                   	push   %eax
80100526:	e8 43 02 00 00       	call   8010076e <consputc>
8010052b:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
8010052e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100535:	0f b6 00             	movzbl (%eax),%eax
80100538:	84 c0                	test   %al,%al
8010053a:	75 dd                	jne    80100519 <cprintf+0x125>
      break;
8010053c:	eb 2b                	jmp    80100569 <cprintf+0x175>
    case '%':
      consputc('%');
8010053e:	83 ec 0c             	sub    $0xc,%esp
80100541:	6a 25                	push   $0x25
80100543:	e8 26 02 00 00       	call   8010076e <consputc>
80100548:	83 c4 10             	add    $0x10,%esp
      break;
8010054b:	eb 1c                	jmp    80100569 <cprintf+0x175>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010054d:	83 ec 0c             	sub    $0xc,%esp
80100550:	6a 25                	push   $0x25
80100552:	e8 17 02 00 00       	call   8010076e <consputc>
80100557:	83 c4 10             	add    $0x10,%esp
      consputc(c);
8010055a:	83 ec 0c             	sub    $0xc,%esp
8010055d:	ff 75 e4             	push   -0x1c(%ebp)
80100560:	e8 09 02 00 00       	call   8010076e <consputc>
80100565:	83 c4 10             	add    $0x10,%esp
      break;
80100568:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100569:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010056d:	8b 55 08             	mov    0x8(%ebp),%edx
80100570:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100573:	01 d0                	add    %edx,%eax
80100575:	0f b6 00             	movzbl (%eax),%eax
80100578:	0f be c0             	movsbl %al,%eax
8010057b:	25 ff 00 00 00       	and    $0xff,%eax
80100580:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100583:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100587:	0f 85 b1 fe ff ff    	jne    8010043e <cprintf+0x4a>
8010058d:	eb 01                	jmp    80100590 <cprintf+0x19c>
      break;
8010058f:	90                   	nop
    }
  }

  if(locking)
80100590:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100594:	74 10                	je     801005a6 <cprintf+0x1b2>
    release(&cons.lock);
80100596:	83 ec 0c             	sub    $0xc,%esp
80100599:	68 00 1a 19 80       	push   $0x80191a00
8010059e:	e8 1d 44 00 00       	call   801049c0 <release>
801005a3:	83 c4 10             	add    $0x10,%esp
}
801005a6:	90                   	nop
801005a7:	c9                   	leave
801005a8:	c3                   	ret

801005a9 <panic>:

void
panic(char *s)
{
801005a9:	55                   	push   %ebp
801005aa:	89 e5                	mov    %esp,%ebp
801005ac:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
801005af:	e8 8d fd ff ff       	call   80100341 <cli>
  cons.locking = 0;
801005b4:	c7 05 34 1a 19 80 00 	movl   $0x0,0x80191a34
801005bb:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801005be:	e8 39 25 00 00       	call   80102afc <lapicid>
801005c3:	83 ec 08             	sub    $0x8,%esp
801005c6:	50                   	push   %eax
801005c7:	68 7d a2 10 80       	push   $0x8010a27d
801005cc:	e8 23 fe ff ff       	call   801003f4 <cprintf>
801005d1:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005d4:	8b 45 08             	mov    0x8(%ebp),%eax
801005d7:	83 ec 0c             	sub    $0xc,%esp
801005da:	50                   	push   %eax
801005db:	e8 14 fe ff ff       	call   801003f4 <cprintf>
801005e0:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005e3:	83 ec 0c             	sub    $0xc,%esp
801005e6:	68 91 a2 10 80       	push   $0x8010a291
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 0f 44 00 00       	call   80104a12 <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
    cprintf(" %p", pcs[i]);
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 93 a2 10 80       	push   $0x8010a293
8010061f:	e8 d0 fd ff ff       	call   801003f4 <cprintf>
80100624:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100627:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010062b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010062f:	7e de                	jle    8010060f <panic+0x66>
  panicked = 1; // freeze other CPU
80100631:	c7 05 ec 19 19 80 01 	movl   $0x1,0x801919ec
80100638:	00 00 00 
  for(;;)
8010063b:	90                   	nop
8010063c:	eb fd                	jmp    8010063b <panic+0x92>

8010063e <graphic_putc>:

#define CONSOLE_HORIZONTAL_MAX 53
#define CONSOLE_VERTICAL_MAX 20
int console_pos = CONSOLE_HORIZONTAL_MAX*(CONSOLE_VERTICAL_MAX);
//int console_pos = 0;
void graphic_putc(int c){
8010063e:	55                   	push   %ebp
8010063f:	89 e5                	mov    %esp,%ebp
80100641:	83 ec 18             	sub    $0x18,%esp
  if(c == '\n'){
80100644:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100648:	75 64                	jne    801006ae <graphic_putc+0x70>
    console_pos += CONSOLE_HORIZONTAL_MAX - console_pos%CONSOLE_HORIZONTAL_MAX;
8010064a:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100650:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100655:	89 c8                	mov    %ecx,%eax
80100657:	f7 ea                	imul   %edx
80100659:	89 d0                	mov    %edx,%eax
8010065b:	c1 f8 04             	sar    $0x4,%eax
8010065e:	89 ca                	mov    %ecx,%edx
80100660:	c1 fa 1f             	sar    $0x1f,%edx
80100663:	29 d0                	sub    %edx,%eax
80100665:	6b d0 35             	imul   $0x35,%eax,%edx
80100668:	89 c8                	mov    %ecx,%eax
8010066a:	29 d0                	sub    %edx,%eax
8010066c:	ba 35 00 00 00       	mov    $0x35,%edx
80100671:	29 c2                	sub    %eax,%edx
80100673:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100678:	01 d0                	add    %edx,%eax
8010067a:	a3 00 d0 10 80       	mov    %eax,0x8010d000
    if(console_pos >= CONSOLE_VERTICAL_MAX * CONSOLE_HORIZONTAL_MAX){
8010067f:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100684:	3d 23 04 00 00       	cmp    $0x423,%eax
80100689:	0f 8e dc 00 00 00    	jle    8010076b <graphic_putc+0x12d>
      console_pos -= CONSOLE_HORIZONTAL_MAX;
8010068f:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100694:	83 e8 35             	sub    $0x35,%eax
80100697:	a3 00 d0 10 80       	mov    %eax,0x8010d000
      graphic_scroll_up(30);
8010069c:	83 ec 0c             	sub    $0xc,%esp
8010069f:	6a 1e                	push   $0x1e
801006a1:	e8 f9 79 00 00       	call   8010809f <graphic_scroll_up>
801006a6:	83 c4 10             	add    $0x10,%esp
    int x = (console_pos%CONSOLE_HORIZONTAL_MAX)*FONT_WIDTH + 2;
    int y = (console_pos/CONSOLE_HORIZONTAL_MAX)*FONT_HEIGHT;
    font_render(x,y,c);
    console_pos++;
  }
}
801006a9:	e9 bd 00 00 00       	jmp    8010076b <graphic_putc+0x12d>
  }else if(c == BACKSPACE){
801006ae:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006b5:	75 1f                	jne    801006d6 <graphic_putc+0x98>
    if(console_pos>0) --console_pos;
801006b7:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006bc:	85 c0                	test   %eax,%eax
801006be:	0f 8e a7 00 00 00    	jle    8010076b <graphic_putc+0x12d>
801006c4:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006c9:	83 e8 01             	sub    $0x1,%eax
801006cc:	a3 00 d0 10 80       	mov    %eax,0x8010d000
}
801006d1:	e9 95 00 00 00       	jmp    8010076b <graphic_putc+0x12d>
    if(console_pos >= CONSOLE_VERTICAL_MAX * CONSOLE_HORIZONTAL_MAX){
801006d6:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006db:	3d 23 04 00 00       	cmp    $0x423,%eax
801006e0:	7e 1a                	jle    801006fc <graphic_putc+0xbe>
      console_pos -= CONSOLE_HORIZONTAL_MAX;
801006e2:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801006e7:	83 e8 35             	sub    $0x35,%eax
801006ea:	a3 00 d0 10 80       	mov    %eax,0x8010d000
      graphic_scroll_up(30);
801006ef:	83 ec 0c             	sub    $0xc,%esp
801006f2:	6a 1e                	push   $0x1e
801006f4:	e8 a6 79 00 00       	call   8010809f <graphic_scroll_up>
801006f9:	83 c4 10             	add    $0x10,%esp
    int x = (console_pos%CONSOLE_HORIZONTAL_MAX)*FONT_WIDTH + 2;
801006fc:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100702:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100707:	89 c8                	mov    %ecx,%eax
80100709:	f7 ea                	imul   %edx
8010070b:	89 d0                	mov    %edx,%eax
8010070d:	c1 f8 04             	sar    $0x4,%eax
80100710:	89 ca                	mov    %ecx,%edx
80100712:	c1 fa 1f             	sar    $0x1f,%edx
80100715:	29 d0                	sub    %edx,%eax
80100717:	6b d0 35             	imul   $0x35,%eax,%edx
8010071a:	89 c8                	mov    %ecx,%eax
8010071c:	29 d0                	sub    %edx,%eax
8010071e:	89 c2                	mov    %eax,%edx
80100720:	c1 e2 04             	shl    $0x4,%edx
80100723:	29 c2                	sub    %eax,%edx
80100725:	8d 42 02             	lea    0x2(%edx),%eax
80100728:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int y = (console_pos/CONSOLE_HORIZONTAL_MAX)*FONT_HEIGHT;
8010072b:	8b 0d 00 d0 10 80    	mov    0x8010d000,%ecx
80100731:	ba ed 73 48 4d       	mov    $0x4d4873ed,%edx
80100736:	89 c8                	mov    %ecx,%eax
80100738:	f7 ea                	imul   %edx
8010073a:	c1 fa 04             	sar    $0x4,%edx
8010073d:	89 c8                	mov    %ecx,%eax
8010073f:	c1 f8 1f             	sar    $0x1f,%eax
80100742:	29 c2                	sub    %eax,%edx
80100744:	6b c2 1e             	imul   $0x1e,%edx,%eax
80100747:	89 45 f0             	mov    %eax,-0x10(%ebp)
    font_render(x,y,c);
8010074a:	83 ec 04             	sub    $0x4,%esp
8010074d:	ff 75 08             	push   0x8(%ebp)
80100750:	ff 75 f0             	push   -0x10(%ebp)
80100753:	ff 75 f4             	push   -0xc(%ebp)
80100756:	e8 b1 79 00 00       	call   8010810c <font_render>
8010075b:	83 c4 10             	add    $0x10,%esp
    console_pos++;
8010075e:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80100763:	83 c0 01             	add    $0x1,%eax
80100766:	a3 00 d0 10 80       	mov    %eax,0x8010d000
}
8010076b:	90                   	nop
8010076c:	c9                   	leave
8010076d:	c3                   	ret

8010076e <consputc>:


void
consputc(int c)
{
8010076e:	55                   	push   %ebp
8010076f:	89 e5                	mov    %esp,%ebp
80100771:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100774:	a1 ec 19 19 80       	mov    0x801919ec,%eax
80100779:	85 c0                	test   %eax,%eax
8010077b:	74 08                	je     80100785 <consputc+0x17>
    cli();
8010077d:	e8 bf fb ff ff       	call   80100341 <cli>
    for(;;)
80100782:	90                   	nop
80100783:	eb fd                	jmp    80100782 <consputc+0x14>
      ;
  }

  if(c == BACKSPACE){
80100785:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010078c:	75 29                	jne    801007b7 <consputc+0x49>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010078e:	83 ec 0c             	sub    $0xc,%esp
80100791:	6a 08                	push   $0x8
80100793:	e8 80 5d 00 00       	call   80106518 <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 73 5d 00 00       	call   80106518 <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 66 5d 00 00       	call   80106518 <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x57>
  } else {
    uartputc(c);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 56 5d 00 00       	call   80106518 <uartputc>
801007c2:	83 c4 10             	add    $0x10,%esp
  }
  graphic_putc(c);
801007c5:	83 ec 0c             	sub    $0xc,%esp
801007c8:	ff 75 08             	push   0x8(%ebp)
801007cb:	e8 6e fe ff ff       	call   8010063e <graphic_putc>
801007d0:	83 c4 10             	add    $0x10,%esp
}
801007d3:	90                   	nop
801007d4:	c9                   	leave
801007d5:	c3                   	ret

801007d6 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007d6:	55                   	push   %ebp
801007d7:	89 e5                	mov    %esp,%ebp
801007d9:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801007dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007e3:	83 ec 0c             	sub    $0xc,%esp
801007e6:	68 00 1a 19 80       	push   $0x80191a00
801007eb:	e8 62 41 00 00       	call   80104952 <acquire>
801007f0:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007f3:	e9 58 01 00 00       	jmp    80100950 <consoleintr+0x17a>
    switch(c){
801007f8:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
801007fc:	0f 84 81 00 00 00    	je     80100883 <consoleintr+0xad>
80100802:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80100806:	0f 8f ac 00 00 00    	jg     801008b8 <consoleintr+0xe2>
8010080c:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100810:	74 43                	je     80100855 <consoleintr+0x7f>
80100812:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100816:	0f 8f 9c 00 00 00    	jg     801008b8 <consoleintr+0xe2>
8010081c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
80100820:	74 61                	je     80100883 <consoleintr+0xad>
80100822:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
80100826:	0f 85 8c 00 00 00    	jne    801008b8 <consoleintr+0xe2>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
8010082c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100833:	e9 18 01 00 00       	jmp    80100950 <consoleintr+0x17a>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100838:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010083d:	83 e8 01             	sub    $0x1,%eax
80100840:	a3 e8 19 19 80       	mov    %eax,0x801919e8
        consputc(BACKSPACE);
80100845:	83 ec 0c             	sub    $0xc,%esp
80100848:	68 00 01 00 00       	push   $0x100
8010084d:	e8 1c ff ff ff       	call   8010076e <consputc>
80100852:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
80100855:	8b 15 e8 19 19 80    	mov    0x801919e8,%edx
8010085b:	a1 e4 19 19 80       	mov    0x801919e4,%eax
80100860:	39 c2                	cmp    %eax,%edx
80100862:	0f 84 e1 00 00 00    	je     80100949 <consoleintr+0x173>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100868:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010086d:	83 e8 01             	sub    $0x1,%eax
80100870:	83 e0 7f             	and    $0x7f,%eax
80100873:	0f b6 80 60 19 19 80 	movzbl -0x7fe6e6a0(%eax),%eax
      while(input.e != input.w &&
8010087a:	3c 0a                	cmp    $0xa,%al
8010087c:	75 ba                	jne    80100838 <consoleintr+0x62>
      }
      break;
8010087e:	e9 c6 00 00 00       	jmp    80100949 <consoleintr+0x173>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100883:	8b 15 e8 19 19 80    	mov    0x801919e8,%edx
80100889:	a1 e4 19 19 80       	mov    0x801919e4,%eax
8010088e:	39 c2                	cmp    %eax,%edx
80100890:	0f 84 b6 00 00 00    	je     8010094c <consoleintr+0x176>
        input.e--;
80100896:	a1 e8 19 19 80       	mov    0x801919e8,%eax
8010089b:	83 e8 01             	sub    $0x1,%eax
8010089e:	a3 e8 19 19 80       	mov    %eax,0x801919e8
        consputc(BACKSPACE);
801008a3:	83 ec 0c             	sub    $0xc,%esp
801008a6:	68 00 01 00 00       	push   $0x100
801008ab:	e8 be fe ff ff       	call   8010076e <consputc>
801008b0:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008b3:	e9 94 00 00 00       	jmp    8010094c <consoleintr+0x176>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008bc:	0f 84 8d 00 00 00    	je     8010094f <consoleintr+0x179>
801008c2:	8b 15 e8 19 19 80    	mov    0x801919e8,%edx
801008c8:	a1 e0 19 19 80       	mov    0x801919e0,%eax
801008cd:	29 c2                	sub    %eax,%edx
801008cf:	83 fa 7f             	cmp    $0x7f,%edx
801008d2:	77 7b                	ja     8010094f <consoleintr+0x179>
        c = (c == '\r') ? '\n' : c;
801008d4:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008d8:	74 05                	je     801008df <consoleintr+0x109>
801008da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008dd:	eb 05                	jmp    801008e4 <consoleintr+0x10e>
801008df:	b8 0a 00 00 00       	mov    $0xa,%eax
801008e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008e7:	a1 e8 19 19 80       	mov    0x801919e8,%eax
801008ec:	8d 50 01             	lea    0x1(%eax),%edx
801008ef:	89 15 e8 19 19 80    	mov    %edx,0x801919e8
801008f5:	83 e0 7f             	and    $0x7f,%eax
801008f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801008fb:	88 90 60 19 19 80    	mov    %dl,-0x7fe6e6a0(%eax)
        consputc(c);
80100901:	83 ec 0c             	sub    $0xc,%esp
80100904:	ff 75 f0             	push   -0x10(%ebp)
80100907:	e8 62 fe ff ff       	call   8010076e <consputc>
8010090c:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010090f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100913:	74 18                	je     8010092d <consoleintr+0x157>
80100915:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100919:	74 12                	je     8010092d <consoleintr+0x157>
8010091b:	8b 15 e8 19 19 80    	mov    0x801919e8,%edx
80100921:	a1 e0 19 19 80       	mov    0x801919e0,%eax
80100926:	83 e8 80             	sub    $0xffffff80,%eax
80100929:	39 c2                	cmp    %eax,%edx
8010092b:	75 22                	jne    8010094f <consoleintr+0x179>
          input.w = input.e;
8010092d:	a1 e8 19 19 80       	mov    0x801919e8,%eax
80100932:	a3 e4 19 19 80       	mov    %eax,0x801919e4
          wakeup(&input.r);
80100937:	83 ec 0c             	sub    $0xc,%esp
8010093a:	68 e0 19 19 80       	push   $0x801919e0
8010093f:	e8 7c 3a 00 00       	call   801043c0 <wakeup>
80100944:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100947:	eb 06                	jmp    8010094f <consoleintr+0x179>
      break;
80100949:	90                   	nop
8010094a:	eb 04                	jmp    80100950 <consoleintr+0x17a>
      break;
8010094c:	90                   	nop
8010094d:	eb 01                	jmp    80100950 <consoleintr+0x17a>
      break;
8010094f:	90                   	nop
  while((c = getc()) >= 0){
80100950:	8b 45 08             	mov    0x8(%ebp),%eax
80100953:	ff d0                	call   *%eax
80100955:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100958:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010095c:	0f 89 96 fe ff ff    	jns    801007f8 <consoleintr+0x22>
    }
  }
  release(&cons.lock);
80100962:	83 ec 0c             	sub    $0xc,%esp
80100965:	68 00 1a 19 80       	push   $0x80191a00
8010096a:	e8 51 40 00 00       	call   801049c0 <release>
8010096f:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
80100972:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100976:	74 05                	je     8010097d <consoleintr+0x1a7>
    procdump();  // now call procdump() wo. cons.lock held
80100978:	e8 fe 3a 00 00       	call   8010447b <procdump>
  }
}
8010097d:	90                   	nop
8010097e:	c9                   	leave
8010097f:	c3                   	ret

80100980 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100980:	55                   	push   %ebp
80100981:	89 e5                	mov    %esp,%ebp
80100983:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100986:	83 ec 0c             	sub    $0xc,%esp
80100989:	ff 75 08             	push   0x8(%ebp)
8010098c:	e8 74 11 00 00       	call   80101b05 <iunlock>
80100991:	83 c4 10             	add    $0x10,%esp
  target = n;
80100994:	8b 45 10             	mov    0x10(%ebp),%eax
80100997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
8010099a:	83 ec 0c             	sub    $0xc,%esp
8010099d:	68 00 1a 19 80       	push   $0x80191a00
801009a2:	e8 ab 3f 00 00       	call   80104952 <acquire>
801009a7:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009aa:	e9 ab 00 00 00       	jmp    80100a5a <consoleread+0xda>
    while(input.r == input.w){
      if(myproc()->killed){
801009af:	e8 7c 30 00 00       	call   80103a30 <myproc>
801009b4:	8b 40 24             	mov    0x24(%eax),%eax
801009b7:	85 c0                	test   %eax,%eax
801009b9:	74 28                	je     801009e3 <consoleread+0x63>
        release(&cons.lock);
801009bb:	83 ec 0c             	sub    $0xc,%esp
801009be:	68 00 1a 19 80       	push   $0x80191a00
801009c3:	e8 f8 3f 00 00       	call   801049c0 <release>
801009c8:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009cb:	83 ec 0c             	sub    $0xc,%esp
801009ce:	ff 75 08             	push   0x8(%ebp)
801009d1:	e8 1c 10 00 00       	call   801019f2 <ilock>
801009d6:	83 c4 10             	add    $0x10,%esp
        return -1;
801009d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009de:	e9 ab 00 00 00       	jmp    80100a8e <consoleread+0x10e>
      }
      sleep(&input.r, &cons.lock);
801009e3:	83 ec 08             	sub    $0x8,%esp
801009e6:	68 00 1a 19 80       	push   $0x80191a00
801009eb:	68 e0 19 19 80       	push   $0x801919e0
801009f0:	e8 e4 38 00 00       	call   801042d9 <sleep>
801009f5:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
801009f8:	8b 15 e0 19 19 80    	mov    0x801919e0,%edx
801009fe:	a1 e4 19 19 80       	mov    0x801919e4,%eax
80100a03:	39 c2                	cmp    %eax,%edx
80100a05:	74 a8                	je     801009af <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a07:	a1 e0 19 19 80       	mov    0x801919e0,%eax
80100a0c:	8d 50 01             	lea    0x1(%eax),%edx
80100a0f:	89 15 e0 19 19 80    	mov    %edx,0x801919e0
80100a15:	83 e0 7f             	and    $0x7f,%eax
80100a18:	0f b6 80 60 19 19 80 	movzbl -0x7fe6e6a0(%eax),%eax
80100a1f:	0f be c0             	movsbl %al,%eax
80100a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a25:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a29:	75 17                	jne    80100a42 <consoleread+0xc2>
      if(n < target){
80100a2b:	8b 45 10             	mov    0x10(%ebp),%eax
80100a2e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a31:	73 2f                	jae    80100a62 <consoleread+0xe2>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a33:	a1 e0 19 19 80       	mov    0x801919e0,%eax
80100a38:	83 e8 01             	sub    $0x1,%eax
80100a3b:	a3 e0 19 19 80       	mov    %eax,0x801919e0
      }
      break;
80100a40:	eb 20                	jmp    80100a62 <consoleread+0xe2>
    }
    *dst++ = c;
80100a42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a45:	8d 50 01             	lea    0x1(%eax),%edx
80100a48:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a4e:	88 10                	mov    %dl,(%eax)
    --n;
80100a50:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a54:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a58:	74 0b                	je     80100a65 <consoleread+0xe5>
  while(n > 0){
80100a5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a5e:	7f 98                	jg     801009f8 <consoleread+0x78>
80100a60:	eb 04                	jmp    80100a66 <consoleread+0xe6>
      break;
80100a62:	90                   	nop
80100a63:	eb 01                	jmp    80100a66 <consoleread+0xe6>
      break;
80100a65:	90                   	nop
  }
  release(&cons.lock);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	68 00 1a 19 80       	push   $0x80191a00
80100a6e:	e8 4d 3f 00 00       	call   801049c0 <release>
80100a73:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a76:	83 ec 0c             	sub    $0xc,%esp
80100a79:	ff 75 08             	push   0x8(%ebp)
80100a7c:	e8 71 0f 00 00       	call   801019f2 <ilock>
80100a81:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a84:	8b 45 10             	mov    0x10(%ebp),%eax
80100a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a8a:	29 c2                	sub    %eax,%edx
80100a8c:	89 d0                	mov    %edx,%eax
}
80100a8e:	c9                   	leave
80100a8f:	c3                   	ret

80100a90 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a90:	55                   	push   %ebp
80100a91:	89 e5                	mov    %esp,%ebp
80100a93:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a96:	83 ec 0c             	sub    $0xc,%esp
80100a99:	ff 75 08             	push   0x8(%ebp)
80100a9c:	e8 64 10 00 00       	call   80101b05 <iunlock>
80100aa1:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100aa4:	83 ec 0c             	sub    $0xc,%esp
80100aa7:	68 00 1a 19 80       	push   $0x80191a00
80100aac:	e8 a1 3e 00 00       	call   80104952 <acquire>
80100ab1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ab4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100abb:	eb 21                	jmp    80100ade <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100abd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ac3:	01 d0                	add    %edx,%eax
80100ac5:	0f b6 00             	movzbl (%eax),%eax
80100ac8:	0f be c0             	movsbl %al,%eax
80100acb:	0f b6 c0             	movzbl %al,%eax
80100ace:	83 ec 0c             	sub    $0xc,%esp
80100ad1:	50                   	push   %eax
80100ad2:	e8 97 fc ff ff       	call   8010076e <consputc>
80100ad7:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ada:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ae1:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ae4:	7c d7                	jl     80100abd <consolewrite+0x2d>
  release(&cons.lock);
80100ae6:	83 ec 0c             	sub    $0xc,%esp
80100ae9:	68 00 1a 19 80       	push   $0x80191a00
80100aee:	e8 cd 3e 00 00       	call   801049c0 <release>
80100af3:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100af6:	83 ec 0c             	sub    $0xc,%esp
80100af9:	ff 75 08             	push   0x8(%ebp)
80100afc:	e8 f1 0e 00 00       	call   801019f2 <ilock>
80100b01:	83 c4 10             	add    $0x10,%esp

  return n;
80100b04:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b07:	c9                   	leave
80100b08:	c3                   	ret

80100b09 <consoleinit>:

void
consoleinit(void)
{
80100b09:	55                   	push   %ebp
80100b0a:	89 e5                	mov    %esp,%ebp
80100b0c:	83 ec 18             	sub    $0x18,%esp
  panicked = 0;
80100b0f:	c7 05 ec 19 19 80 00 	movl   $0x0,0x801919ec
80100b16:	00 00 00 
  initlock(&cons.lock, "console");
80100b19:	83 ec 08             	sub    $0x8,%esp
80100b1c:	68 97 a2 10 80       	push   $0x8010a297
80100b21:	68 00 1a 19 80       	push   $0x80191a00
80100b26:	e8 05 3e 00 00       	call   80104930 <initlock>
80100b2b:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b2e:	c7 05 4c 1a 19 80 90 	movl   $0x80100a90,0x80191a4c
80100b35:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b38:	c7 05 48 1a 19 80 80 	movl   $0x80100980,0x80191a48
80100b3f:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b42:	c7 45 f4 9f a2 10 80 	movl   $0x8010a29f,-0xc(%ebp)
80100b49:	eb 19                	jmp    80100b64 <consoleinit+0x5b>
    graphic_putc(*p);
80100b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b4e:	0f b6 00             	movzbl (%eax),%eax
80100b51:	0f be c0             	movsbl %al,%eax
80100b54:	83 ec 0c             	sub    $0xc,%esp
80100b57:	50                   	push   %eax
80100b58:	e8 e1 fa ff ff       	call   8010063e <graphic_putc>
80100b5d:	83 c4 10             	add    $0x10,%esp
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b60:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b67:	0f b6 00             	movzbl (%eax),%eax
80100b6a:	84 c0                	test   %al,%al
80100b6c:	75 dd                	jne    80100b4b <consoleinit+0x42>
  
  cons.locking = 1;
80100b6e:	c7 05 34 1a 19 80 01 	movl   $0x1,0x80191a34
80100b75:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b78:	83 ec 08             	sub    $0x8,%esp
80100b7b:	6a 00                	push   $0x0
80100b7d:	6a 01                	push   $0x1
80100b7f:	e8 b2 1a 00 00       	call   80102636 <ioapicenable>
80100b84:	83 c4 10             	add    $0x10,%esp
}
80100b87:	90                   	nop
80100b88:	c9                   	leave
80100b89:	c3                   	ret

80100b8a <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b8a:	55                   	push   %ebp
80100b8b:	89 e5                	mov    %esp,%ebp
80100b8d:	81 ec 18 01 00 00    	sub    $0x118,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b93:	e8 98 2e 00 00       	call   80103a30 <myproc>
80100b98:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100b9b:	e8 9e 24 00 00       	call   8010303e <begin_op>

  if((ip = namei(path)) == 0){
80100ba0:	83 ec 0c             	sub    $0xc,%esp
80100ba3:	ff 75 08             	push   0x8(%ebp)
80100ba6:	e8 7a 19 00 00       	call   80102525 <namei>
80100bab:	83 c4 10             	add    $0x10,%esp
80100bae:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bb1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bb5:	75 1f                	jne    80100bd6 <exec+0x4c>
    end_op();
80100bb7:	e8 0e 25 00 00       	call   801030ca <end_op>
    cprintf("exec: fail\n");
80100bbc:	83 ec 0c             	sub    $0xc,%esp
80100bbf:	68 b5 a2 10 80       	push   $0x8010a2b5
80100bc4:	e8 2b f8 ff ff       	call   801003f4 <cprintf>
80100bc9:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd1:	e9 f1 03 00 00       	jmp    80100fc7 <exec+0x43d>
  }
  ilock(ip);
80100bd6:	83 ec 0c             	sub    $0xc,%esp
80100bd9:	ff 75 d8             	push   -0x28(%ebp)
80100bdc:	e8 11 0e 00 00       	call   801019f2 <ilock>
80100be1:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100be4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100beb:	6a 34                	push   $0x34
80100bed:	6a 00                	push   $0x0
80100bef:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100bf5:	50                   	push   %eax
80100bf6:	ff 75 d8             	push   -0x28(%ebp)
80100bf9:	e8 e0 12 00 00       	call   80101ede <readi>
80100bfe:	83 c4 10             	add    $0x10,%esp
80100c01:	83 f8 34             	cmp    $0x34,%eax
80100c04:	0f 85 66 03 00 00    	jne    80100f70 <exec+0x3e6>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c0a:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c10:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c15:	0f 85 58 03 00 00    	jne    80100f73 <exec+0x3e9>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c1b:	e8 f4 68 00 00       	call   80107514 <setupkvm>
80100c20:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c23:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c27:	0f 84 49 03 00 00    	je     80100f76 <exec+0x3ec>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c2d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c34:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c3b:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c41:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c44:	e9 de 00 00 00       	jmp    80100d27 <exec+0x19d>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c49:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c4c:	6a 20                	push   $0x20
80100c4e:	50                   	push   %eax
80100c4f:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c55:	50                   	push   %eax
80100c56:	ff 75 d8             	push   -0x28(%ebp)
80100c59:	e8 80 12 00 00       	call   80101ede <readi>
80100c5e:	83 c4 10             	add    $0x10,%esp
80100c61:	83 f8 20             	cmp    $0x20,%eax
80100c64:	0f 85 0f 03 00 00    	jne    80100f79 <exec+0x3ef>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c6a:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100c70:	83 f8 01             	cmp    $0x1,%eax
80100c73:	0f 85 a0 00 00 00    	jne    80100d19 <exec+0x18f>
      continue;
    if(ph.memsz < ph.filesz)
80100c79:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c7f:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c85:	39 c2                	cmp    %eax,%edx
80100c87:	0f 82 ef 02 00 00    	jb     80100f7c <exec+0x3f2>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c8d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c93:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c99:	01 c2                	add    %eax,%edx
80100c9b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ca1:	39 c2                	cmp    %eax,%edx
80100ca3:	0f 82 d6 02 00 00    	jb     80100f7f <exec+0x3f5>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ca9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100caf:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cb5:	01 d0                	add    %edx,%eax
80100cb7:	83 ec 04             	sub    $0x4,%esp
80100cba:	50                   	push   %eax
80100cbb:	ff 75 e0             	push   -0x20(%ebp)
80100cbe:	ff 75 d4             	push   -0x2c(%ebp)
80100cc1:	e8 48 6c 00 00       	call   8010790e <allocuvm>
80100cc6:	83 c4 10             	add    $0x10,%esp
80100cc9:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ccc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cd0:	0f 84 ac 02 00 00    	je     80100f82 <exec+0x3f8>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100cd6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cdc:	25 ff 0f 00 00       	and    $0xfff,%eax
80100ce1:	85 c0                	test   %eax,%eax
80100ce3:	0f 85 9c 02 00 00    	jne    80100f85 <exec+0x3fb>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ce9:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100cef:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100cf5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100cfb:	83 ec 0c             	sub    $0xc,%esp
80100cfe:	52                   	push   %edx
80100cff:	50                   	push   %eax
80100d00:	ff 75 d8             	push   -0x28(%ebp)
80100d03:	51                   	push   %ecx
80100d04:	ff 75 d4             	push   -0x2c(%ebp)
80100d07:	e8 35 6b 00 00       	call   80107841 <loaduvm>
80100d0c:	83 c4 20             	add    $0x20,%esp
80100d0f:	85 c0                	test   %eax,%eax
80100d11:	0f 88 71 02 00 00    	js     80100f88 <exec+0x3fe>
80100d17:	eb 01                	jmp    80100d1a <exec+0x190>
      continue;
80100d19:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d1a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d21:	83 c0 20             	add    $0x20,%eax
80100d24:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d27:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100d2e:	0f b7 c0             	movzwl %ax,%eax
80100d31:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100d34:	0f 8c 0f ff ff ff    	jl     80100c49 <exec+0xbf>
      goto bad;
  }
  iunlockput(ip);
80100d3a:	83 ec 0c             	sub    $0xc,%esp
80100d3d:	ff 75 d8             	push   -0x28(%ebp)
80100d40:	e8 de 0e 00 00       	call   80101c23 <iunlockput>
80100d45:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d48:	e8 7d 23 00 00       	call   801030ca <end_op>
  ip = 0;
80100d4d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d57:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d5c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d67:	05 00 20 00 00       	add    $0x2000,%eax
80100d6c:	83 ec 04             	sub    $0x4,%esp
80100d6f:	50                   	push   %eax
80100d70:	ff 75 e0             	push   -0x20(%ebp)
80100d73:	ff 75 d4             	push   -0x2c(%ebp)
80100d76:	e8 93 6b 00 00       	call   8010790e <allocuvm>
80100d7b:	83 c4 10             	add    $0x10,%esp
80100d7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d81:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d85:	0f 84 00 02 00 00    	je     80100f8b <exec+0x401>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d8e:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d93:	83 ec 08             	sub    $0x8,%esp
80100d96:	50                   	push   %eax
80100d97:	ff 75 d4             	push   -0x2c(%ebp)
80100d9a:	e8 d1 6d 00 00       	call   80107b70 <clearpteu>
80100d9f:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100da2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da5:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100da8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100daf:	e9 96 00 00 00       	jmp    80100e4a <exec+0x2c0>
    if(argc >= MAXARG)
80100db4:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100db8:	0f 87 d0 01 00 00    	ja     80100f8e <exec+0x404>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dcb:	01 d0                	add    %edx,%eax
80100dcd:	8b 00                	mov    (%eax),%eax
80100dcf:	83 ec 0c             	sub    $0xc,%esp
80100dd2:	50                   	push   %eax
80100dd3:	e8 3e 40 00 00       	call   80104e16 <strlen>
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	89 c2                	mov    %eax,%edx
80100ddd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de0:	29 d0                	sub    %edx,%eax
80100de2:	83 e8 01             	sub    $0x1,%eax
80100de5:	83 e0 fc             	and    $0xfffffffc,%eax
80100de8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100deb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100df5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100df8:	01 d0                	add    %edx,%eax
80100dfa:	8b 00                	mov    (%eax),%eax
80100dfc:	83 ec 0c             	sub    $0xc,%esp
80100dff:	50                   	push   %eax
80100e00:	e8 11 40 00 00       	call   80104e16 <strlen>
80100e05:	83 c4 10             	add    $0x10,%esp
80100e08:	83 c0 01             	add    $0x1,%eax
80100e0b:	89 c1                	mov    %eax,%ecx
80100e0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e17:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e1a:	01 d0                	add    %edx,%eax
80100e1c:	8b 00                	mov    (%eax),%eax
80100e1e:	51                   	push   %ecx
80100e1f:	50                   	push   %eax
80100e20:	ff 75 dc             	push   -0x24(%ebp)
80100e23:	ff 75 d4             	push   -0x2c(%ebp)
80100e26:	e8 e4 6e 00 00       	call   80107d0f <copyout>
80100e2b:	83 c4 10             	add    $0x10,%esp
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	0f 88 5b 01 00 00    	js     80100f91 <exec+0x407>
      goto bad;
    ustack[3+argc] = sp;
80100e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e39:	8d 50 03             	lea    0x3(%eax),%edx
80100e3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e3f:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e46:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e54:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e57:	01 d0                	add    %edx,%eax
80100e59:	8b 00                	mov    (%eax),%eax
80100e5b:	85 c0                	test   %eax,%eax
80100e5d:	0f 85 51 ff ff ff    	jne    80100db4 <exec+0x22a>
  }
  ustack[3+argc] = 0;
80100e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e66:	83 c0 03             	add    $0x3,%eax
80100e69:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100e70:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e74:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100e7b:	ff ff ff 
  ustack[1] = argc;
80100e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e81:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e8a:	83 c0 01             	add    $0x1,%eax
80100e8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e94:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e97:	29 d0                	sub    %edx,%eax
80100e99:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100e9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea2:	83 c0 04             	add    $0x4,%eax
80100ea5:	c1 e0 02             	shl    $0x2,%eax
80100ea8:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eae:	83 c0 04             	add    $0x4,%eax
80100eb1:	c1 e0 02             	shl    $0x2,%eax
80100eb4:	50                   	push   %eax
80100eb5:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100ebb:	50                   	push   %eax
80100ebc:	ff 75 dc             	push   -0x24(%ebp)
80100ebf:	ff 75 d4             	push   -0x2c(%ebp)
80100ec2:	e8 48 6e 00 00       	call   80107d0f <copyout>
80100ec7:	83 c4 10             	add    $0x10,%esp
80100eca:	85 c0                	test   %eax,%eax
80100ecc:	0f 88 c2 00 00 00    	js     80100f94 <exec+0x40a>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ed2:	8b 45 08             	mov    0x8(%ebp),%eax
80100ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ede:	eb 17                	jmp    80100ef7 <exec+0x36d>
    if(*s == '/')
80100ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ee3:	0f b6 00             	movzbl (%eax),%eax
80100ee6:	3c 2f                	cmp    $0x2f,%al
80100ee8:	75 09                	jne    80100ef3 <exec+0x369>
      last = s+1;
80100eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eed:	83 c0 01             	add    $0x1,%eax
80100ef0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100ef3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100efa:	0f b6 00             	movzbl (%eax),%eax
80100efd:	84 c0                	test   %al,%al
80100eff:	75 df                	jne    80100ee0 <exec+0x356>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f01:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f04:	83 c0 6c             	add    $0x6c,%eax
80100f07:	83 ec 04             	sub    $0x4,%esp
80100f0a:	6a 10                	push   $0x10
80100f0c:	ff 75 f0             	push   -0x10(%ebp)
80100f0f:	50                   	push   %eax
80100f10:	e8 b6 3e 00 00       	call   80104dcb <safestrcpy>
80100f15:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100f18:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f1b:	8b 40 04             	mov    0x4(%eax),%eax
80100f1e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100f21:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f24:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f27:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100f2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f30:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f32:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f35:	8b 40 18             	mov    0x18(%eax),%eax
80100f38:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f3e:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f41:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f44:	8b 40 18             	mov    0x18(%eax),%eax
80100f47:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f4a:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 d0             	push   -0x30(%ebp)
80100f53:	e8 da 66 00 00       	call   80107632 <switchuvm>
80100f58:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f5b:	83 ec 0c             	sub    $0xc,%esp
80100f5e:	ff 75 cc             	push   -0x34(%ebp)
80100f61:	e8 71 6b 00 00       	call   80107ad7 <freevm>
80100f66:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f69:	b8 00 00 00 00       	mov    $0x0,%eax
80100f6e:	eb 57                	jmp    80100fc7 <exec+0x43d>
    goto bad;
80100f70:	90                   	nop
80100f71:	eb 22                	jmp    80100f95 <exec+0x40b>
    goto bad;
80100f73:	90                   	nop
80100f74:	eb 1f                	jmp    80100f95 <exec+0x40b>
    goto bad;
80100f76:	90                   	nop
80100f77:	eb 1c                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f79:	90                   	nop
80100f7a:	eb 19                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f7c:	90                   	nop
80100f7d:	eb 16                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f7f:	90                   	nop
80100f80:	eb 13                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f82:	90                   	nop
80100f83:	eb 10                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f85:	90                   	nop
80100f86:	eb 0d                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f88:	90                   	nop
80100f89:	eb 0a                	jmp    80100f95 <exec+0x40b>
    goto bad;
80100f8b:	90                   	nop
80100f8c:	eb 07                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f8e:	90                   	nop
80100f8f:	eb 04                	jmp    80100f95 <exec+0x40b>
      goto bad;
80100f91:	90                   	nop
80100f92:	eb 01                	jmp    80100f95 <exec+0x40b>
    goto bad;
80100f94:	90                   	nop

 bad:
  if(pgdir)
80100f95:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f99:	74 0e                	je     80100fa9 <exec+0x41f>
    freevm(pgdir);
80100f9b:	83 ec 0c             	sub    $0xc,%esp
80100f9e:	ff 75 d4             	push   -0x2c(%ebp)
80100fa1:	e8 31 6b 00 00       	call   80107ad7 <freevm>
80100fa6:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100fa9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fad:	74 13                	je     80100fc2 <exec+0x438>
    iunlockput(ip);
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	ff 75 d8             	push   -0x28(%ebp)
80100fb5:	e8 69 0c 00 00       	call   80101c23 <iunlockput>
80100fba:	83 c4 10             	add    $0x10,%esp
    end_op();
80100fbd:	e8 08 21 00 00       	call   801030ca <end_op>
  }
  return -1;
80100fc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fc7:	c9                   	leave
80100fc8:	c3                   	ret

80100fc9 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fc9:	55                   	push   %ebp
80100fca:	89 e5                	mov    %esp,%ebp
80100fcc:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100fcf:	83 ec 08             	sub    $0x8,%esp
80100fd2:	68 c1 a2 10 80       	push   $0x8010a2c1
80100fd7:	68 a0 1a 19 80       	push   $0x80191aa0
80100fdc:	e8 4f 39 00 00       	call   80104930 <initlock>
80100fe1:	83 c4 10             	add    $0x10,%esp
}
80100fe4:	90                   	nop
80100fe5:	c9                   	leave
80100fe6:	c3                   	ret

80100fe7 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fe7:	55                   	push   %ebp
80100fe8:	89 e5                	mov    %esp,%ebp
80100fea:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fed:	83 ec 0c             	sub    $0xc,%esp
80100ff0:	68 a0 1a 19 80       	push   $0x80191aa0
80100ff5:	e8 58 39 00 00       	call   80104952 <acquire>
80100ffa:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ffd:	c7 45 f4 d4 1a 19 80 	movl   $0x80191ad4,-0xc(%ebp)
80101004:	eb 2d                	jmp    80101033 <filealloc+0x4c>
    if(f->ref == 0){
80101006:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101009:	8b 40 04             	mov    0x4(%eax),%eax
8010100c:	85 c0                	test   %eax,%eax
8010100e:	75 1f                	jne    8010102f <filealloc+0x48>
      f->ref = 1;
80101010:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101013:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010101a:	83 ec 0c             	sub    $0xc,%esp
8010101d:	68 a0 1a 19 80       	push   $0x80191aa0
80101022:	e8 99 39 00 00       	call   801049c0 <release>
80101027:	83 c4 10             	add    $0x10,%esp
      return f;
8010102a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010102d:	eb 23                	jmp    80101052 <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010102f:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101033:	b8 34 24 19 80       	mov    $0x80192434,%eax
80101038:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010103b:	72 c9                	jb     80101006 <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
8010103d:	83 ec 0c             	sub    $0xc,%esp
80101040:	68 a0 1a 19 80       	push   $0x80191aa0
80101045:	e8 76 39 00 00       	call   801049c0 <release>
8010104a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010104d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101052:	c9                   	leave
80101053:	c3                   	ret

80101054 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101054:	55                   	push   %ebp
80101055:	89 e5                	mov    %esp,%ebp
80101057:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
8010105a:	83 ec 0c             	sub    $0xc,%esp
8010105d:	68 a0 1a 19 80       	push   $0x80191aa0
80101062:	e8 eb 38 00 00       	call   80104952 <acquire>
80101067:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010106a:	8b 45 08             	mov    0x8(%ebp),%eax
8010106d:	8b 40 04             	mov    0x4(%eax),%eax
80101070:	85 c0                	test   %eax,%eax
80101072:	7f 0d                	jg     80101081 <filedup+0x2d>
    panic("filedup");
80101074:	83 ec 0c             	sub    $0xc,%esp
80101077:	68 c8 a2 10 80       	push   $0x8010a2c8
8010107c:	e8 28 f5 ff ff       	call   801005a9 <panic>
  f->ref++;
80101081:	8b 45 08             	mov    0x8(%ebp),%eax
80101084:	8b 40 04             	mov    0x4(%eax),%eax
80101087:	8d 50 01             	lea    0x1(%eax),%edx
8010108a:	8b 45 08             	mov    0x8(%ebp),%eax
8010108d:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101090:	83 ec 0c             	sub    $0xc,%esp
80101093:	68 a0 1a 19 80       	push   $0x80191aa0
80101098:	e8 23 39 00 00       	call   801049c0 <release>
8010109d:	83 c4 10             	add    $0x10,%esp
  return f;
801010a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010a3:	c9                   	leave
801010a4:	c3                   	ret

801010a5 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010a5:	55                   	push   %ebp
801010a6:	89 e5                	mov    %esp,%ebp
801010a8:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	68 a0 1a 19 80       	push   $0x80191aa0
801010b3:	e8 9a 38 00 00       	call   80104952 <acquire>
801010b8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010bb:	8b 45 08             	mov    0x8(%ebp),%eax
801010be:	8b 40 04             	mov    0x4(%eax),%eax
801010c1:	85 c0                	test   %eax,%eax
801010c3:	7f 0d                	jg     801010d2 <fileclose+0x2d>
    panic("fileclose");
801010c5:	83 ec 0c             	sub    $0xc,%esp
801010c8:	68 d0 a2 10 80       	push   $0x8010a2d0
801010cd:	e8 d7 f4 ff ff       	call   801005a9 <panic>
  if(--f->ref > 0){
801010d2:	8b 45 08             	mov    0x8(%ebp),%eax
801010d5:	8b 40 04             	mov    0x4(%eax),%eax
801010d8:	8d 50 ff             	lea    -0x1(%eax),%edx
801010db:	8b 45 08             	mov    0x8(%ebp),%eax
801010de:	89 50 04             	mov    %edx,0x4(%eax)
801010e1:	8b 45 08             	mov    0x8(%ebp),%eax
801010e4:	8b 40 04             	mov    0x4(%eax),%eax
801010e7:	85 c0                	test   %eax,%eax
801010e9:	7e 15                	jle    80101100 <fileclose+0x5b>
    release(&ftable.lock);
801010eb:	83 ec 0c             	sub    $0xc,%esp
801010ee:	68 a0 1a 19 80       	push   $0x80191aa0
801010f3:	e8 c8 38 00 00       	call   801049c0 <release>
801010f8:	83 c4 10             	add    $0x10,%esp
801010fb:	e9 8b 00 00 00       	jmp    8010118b <fileclose+0xe6>
    return;
  }
  ff = *f;
80101100:	8b 45 08             	mov    0x8(%ebp),%eax
80101103:	8b 10                	mov    (%eax),%edx
80101105:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101108:	8b 50 04             	mov    0x4(%eax),%edx
8010110b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010110e:	8b 50 08             	mov    0x8(%eax),%edx
80101111:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101114:	8b 50 0c             	mov    0xc(%eax),%edx
80101117:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010111a:	8b 50 10             	mov    0x10(%eax),%edx
8010111d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101120:	8b 40 14             	mov    0x14(%eax),%eax
80101123:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101126:	8b 45 08             	mov    0x8(%ebp),%eax
80101129:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101130:	8b 45 08             	mov    0x8(%ebp),%eax
80101133:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101139:	83 ec 0c             	sub    $0xc,%esp
8010113c:	68 a0 1a 19 80       	push   $0x80191aa0
80101141:	e8 7a 38 00 00       	call   801049c0 <release>
80101146:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
80101149:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010114c:	83 f8 01             	cmp    $0x1,%eax
8010114f:	75 19                	jne    8010116a <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
80101151:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101155:	0f be d0             	movsbl %al,%edx
80101158:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010115b:	83 ec 08             	sub    $0x8,%esp
8010115e:	52                   	push   %edx
8010115f:	50                   	push   %eax
80101160:	e8 5a 25 00 00       	call   801036bf <pipeclose>
80101165:	83 c4 10             	add    $0x10,%esp
80101168:	eb 21                	jmp    8010118b <fileclose+0xe6>
  else if(ff.type == FD_INODE){
8010116a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010116d:	83 f8 02             	cmp    $0x2,%eax
80101170:	75 19                	jne    8010118b <fileclose+0xe6>
    begin_op();
80101172:	e8 c7 1e 00 00       	call   8010303e <begin_op>
    iput(ff.ip);
80101177:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010117a:	83 ec 0c             	sub    $0xc,%esp
8010117d:	50                   	push   %eax
8010117e:	e8 d0 09 00 00       	call   80101b53 <iput>
80101183:	83 c4 10             	add    $0x10,%esp
    end_op();
80101186:	e8 3f 1f 00 00       	call   801030ca <end_op>
  }
}
8010118b:	c9                   	leave
8010118c:	c3                   	ret

8010118d <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010118d:	55                   	push   %ebp
8010118e:	89 e5                	mov    %esp,%ebp
80101190:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101193:	8b 45 08             	mov    0x8(%ebp),%eax
80101196:	8b 00                	mov    (%eax),%eax
80101198:	83 f8 02             	cmp    $0x2,%eax
8010119b:	75 40                	jne    801011dd <filestat+0x50>
    ilock(f->ip);
8010119d:	8b 45 08             	mov    0x8(%ebp),%eax
801011a0:	8b 40 10             	mov    0x10(%eax),%eax
801011a3:	83 ec 0c             	sub    $0xc,%esp
801011a6:	50                   	push   %eax
801011a7:	e8 46 08 00 00       	call   801019f2 <ilock>
801011ac:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011af:	8b 45 08             	mov    0x8(%ebp),%eax
801011b2:	8b 40 10             	mov    0x10(%eax),%eax
801011b5:	83 ec 08             	sub    $0x8,%esp
801011b8:	ff 75 0c             	push   0xc(%ebp)
801011bb:	50                   	push   %eax
801011bc:	e8 d7 0c 00 00       	call   80101e98 <stati>
801011c1:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801011c4:	8b 45 08             	mov    0x8(%ebp),%eax
801011c7:	8b 40 10             	mov    0x10(%eax),%eax
801011ca:	83 ec 0c             	sub    $0xc,%esp
801011cd:	50                   	push   %eax
801011ce:	e8 32 09 00 00       	call   80101b05 <iunlock>
801011d3:	83 c4 10             	add    $0x10,%esp
    return 0;
801011d6:	b8 00 00 00 00       	mov    $0x0,%eax
801011db:	eb 05                	jmp    801011e2 <filestat+0x55>
  }
  return -1;
801011dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011e2:	c9                   	leave
801011e3:	c3                   	ret

801011e4 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011e4:	55                   	push   %ebp
801011e5:	89 e5                	mov    %esp,%ebp
801011e7:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801011ea:	8b 45 08             	mov    0x8(%ebp),%eax
801011ed:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011f1:	84 c0                	test   %al,%al
801011f3:	75 0a                	jne    801011ff <fileread+0x1b>
    return -1;
801011f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011fa:	e9 9b 00 00 00       	jmp    8010129a <fileread+0xb6>
  if(f->type == FD_PIPE)
801011ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101202:	8b 00                	mov    (%eax),%eax
80101204:	83 f8 01             	cmp    $0x1,%eax
80101207:	75 1a                	jne    80101223 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101209:	8b 45 08             	mov    0x8(%ebp),%eax
8010120c:	8b 40 0c             	mov    0xc(%eax),%eax
8010120f:	83 ec 04             	sub    $0x4,%esp
80101212:	ff 75 10             	push   0x10(%ebp)
80101215:	ff 75 0c             	push   0xc(%ebp)
80101218:	50                   	push   %eax
80101219:	e8 4e 26 00 00       	call   8010386c <piperead>
8010121e:	83 c4 10             	add    $0x10,%esp
80101221:	eb 77                	jmp    8010129a <fileread+0xb6>
  if(f->type == FD_INODE){
80101223:	8b 45 08             	mov    0x8(%ebp),%eax
80101226:	8b 00                	mov    (%eax),%eax
80101228:	83 f8 02             	cmp    $0x2,%eax
8010122b:	75 60                	jne    8010128d <fileread+0xa9>
    ilock(f->ip);
8010122d:	8b 45 08             	mov    0x8(%ebp),%eax
80101230:	8b 40 10             	mov    0x10(%eax),%eax
80101233:	83 ec 0c             	sub    $0xc,%esp
80101236:	50                   	push   %eax
80101237:	e8 b6 07 00 00       	call   801019f2 <ilock>
8010123c:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010123f:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101242:	8b 45 08             	mov    0x8(%ebp),%eax
80101245:	8b 50 14             	mov    0x14(%eax),%edx
80101248:	8b 45 08             	mov    0x8(%ebp),%eax
8010124b:	8b 40 10             	mov    0x10(%eax),%eax
8010124e:	51                   	push   %ecx
8010124f:	52                   	push   %edx
80101250:	ff 75 0c             	push   0xc(%ebp)
80101253:	50                   	push   %eax
80101254:	e8 85 0c 00 00       	call   80101ede <readi>
80101259:	83 c4 10             	add    $0x10,%esp
8010125c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010125f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101263:	7e 11                	jle    80101276 <fileread+0x92>
      f->off += r;
80101265:	8b 45 08             	mov    0x8(%ebp),%eax
80101268:	8b 50 14             	mov    0x14(%eax),%edx
8010126b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010126e:	01 c2                	add    %eax,%edx
80101270:	8b 45 08             	mov    0x8(%ebp),%eax
80101273:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101276:	8b 45 08             	mov    0x8(%ebp),%eax
80101279:	8b 40 10             	mov    0x10(%eax),%eax
8010127c:	83 ec 0c             	sub    $0xc,%esp
8010127f:	50                   	push   %eax
80101280:	e8 80 08 00 00       	call   80101b05 <iunlock>
80101285:	83 c4 10             	add    $0x10,%esp
    return r;
80101288:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010128b:	eb 0d                	jmp    8010129a <fileread+0xb6>
  }
  panic("fileread");
8010128d:	83 ec 0c             	sub    $0xc,%esp
80101290:	68 da a2 10 80       	push   $0x8010a2da
80101295:	e8 0f f3 ff ff       	call   801005a9 <panic>
}
8010129a:	c9                   	leave
8010129b:	c3                   	ret

8010129c <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010129c:	55                   	push   %ebp
8010129d:	89 e5                	mov    %esp,%ebp
8010129f:	53                   	push   %ebx
801012a0:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012a3:	8b 45 08             	mov    0x8(%ebp),%eax
801012a6:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012aa:	84 c0                	test   %al,%al
801012ac:	75 0a                	jne    801012b8 <filewrite+0x1c>
    return -1;
801012ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012b3:	e9 1b 01 00 00       	jmp    801013d3 <filewrite+0x137>
  if(f->type == FD_PIPE)
801012b8:	8b 45 08             	mov    0x8(%ebp),%eax
801012bb:	8b 00                	mov    (%eax),%eax
801012bd:	83 f8 01             	cmp    $0x1,%eax
801012c0:	75 1d                	jne    801012df <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801012c2:	8b 45 08             	mov    0x8(%ebp),%eax
801012c5:	8b 40 0c             	mov    0xc(%eax),%eax
801012c8:	83 ec 04             	sub    $0x4,%esp
801012cb:	ff 75 10             	push   0x10(%ebp)
801012ce:	ff 75 0c             	push   0xc(%ebp)
801012d1:	50                   	push   %eax
801012d2:	e8 93 24 00 00       	call   8010376a <pipewrite>
801012d7:	83 c4 10             	add    $0x10,%esp
801012da:	e9 f4 00 00 00       	jmp    801013d3 <filewrite+0x137>
  if(f->type == FD_INODE){
801012df:	8b 45 08             	mov    0x8(%ebp),%eax
801012e2:	8b 00                	mov    (%eax),%eax
801012e4:	83 f8 02             	cmp    $0x2,%eax
801012e7:	0f 85 d9 00 00 00    	jne    801013c6 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
801012ed:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
801012f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012fb:	e9 a3 00 00 00       	jmp    801013a3 <filewrite+0x107>
      int n1 = n - i;
80101300:	8b 45 10             	mov    0x10(%ebp),%eax
80101303:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101306:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101309:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010130c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010130f:	7e 06                	jle    80101317 <filewrite+0x7b>
        n1 = max;
80101311:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101314:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101317:	e8 22 1d 00 00       	call   8010303e <begin_op>
      ilock(f->ip);
8010131c:	8b 45 08             	mov    0x8(%ebp),%eax
8010131f:	8b 40 10             	mov    0x10(%eax),%eax
80101322:	83 ec 0c             	sub    $0xc,%esp
80101325:	50                   	push   %eax
80101326:	e8 c7 06 00 00       	call   801019f2 <ilock>
8010132b:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010132e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101331:	8b 45 08             	mov    0x8(%ebp),%eax
80101334:	8b 50 14             	mov    0x14(%eax),%edx
80101337:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010133a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010133d:	01 c3                	add    %eax,%ebx
8010133f:	8b 45 08             	mov    0x8(%ebp),%eax
80101342:	8b 40 10             	mov    0x10(%eax),%eax
80101345:	51                   	push   %ecx
80101346:	52                   	push   %edx
80101347:	53                   	push   %ebx
80101348:	50                   	push   %eax
80101349:	e8 e5 0c 00 00       	call   80102033 <writei>
8010134e:	83 c4 10             	add    $0x10,%esp
80101351:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101354:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101358:	7e 11                	jle    8010136b <filewrite+0xcf>
        f->off += r;
8010135a:	8b 45 08             	mov    0x8(%ebp),%eax
8010135d:	8b 50 14             	mov    0x14(%eax),%edx
80101360:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101363:	01 c2                	add    %eax,%edx
80101365:	8b 45 08             	mov    0x8(%ebp),%eax
80101368:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010136b:	8b 45 08             	mov    0x8(%ebp),%eax
8010136e:	8b 40 10             	mov    0x10(%eax),%eax
80101371:	83 ec 0c             	sub    $0xc,%esp
80101374:	50                   	push   %eax
80101375:	e8 8b 07 00 00       	call   80101b05 <iunlock>
8010137a:	83 c4 10             	add    $0x10,%esp
      end_op();
8010137d:	e8 48 1d 00 00       	call   801030ca <end_op>

      if(r < 0)
80101382:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101386:	78 29                	js     801013b1 <filewrite+0x115>
        break;
      if(r != n1)
80101388:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010138b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010138e:	74 0d                	je     8010139d <filewrite+0x101>
        panic("short filewrite");
80101390:	83 ec 0c             	sub    $0xc,%esp
80101393:	68 e3 a2 10 80       	push   $0x8010a2e3
80101398:	e8 0c f2 ff ff       	call   801005a9 <panic>
      i += r;
8010139d:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013a0:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
801013a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a6:	3b 45 10             	cmp    0x10(%ebp),%eax
801013a9:	0f 8c 51 ff ff ff    	jl     80101300 <filewrite+0x64>
801013af:	eb 01                	jmp    801013b2 <filewrite+0x116>
        break;
801013b1:	90                   	nop
    }
    return i == n ? n : -1;
801013b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b5:	3b 45 10             	cmp    0x10(%ebp),%eax
801013b8:	75 05                	jne    801013bf <filewrite+0x123>
801013ba:	8b 45 10             	mov    0x10(%ebp),%eax
801013bd:	eb 14                	jmp    801013d3 <filewrite+0x137>
801013bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013c4:	eb 0d                	jmp    801013d3 <filewrite+0x137>
  }
  panic("filewrite");
801013c6:	83 ec 0c             	sub    $0xc,%esp
801013c9:	68 f3 a2 10 80       	push   $0x8010a2f3
801013ce:	e8 d6 f1 ff ff       	call   801005a9 <panic>
}
801013d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013d6:	c9                   	leave
801013d7:	c3                   	ret

801013d8 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013d8:	55                   	push   %ebp
801013d9:	89 e5                	mov    %esp,%ebp
801013db:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013de:	8b 45 08             	mov    0x8(%ebp),%eax
801013e1:	83 ec 08             	sub    $0x8,%esp
801013e4:	6a 01                	push   $0x1
801013e6:	50                   	push   %eax
801013e7:	e8 15 ee ff ff       	call   80100201 <bread>
801013ec:	83 c4 10             	add    $0x10,%esp
801013ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f5:	83 c0 5c             	add    $0x5c,%eax
801013f8:	83 ec 04             	sub    $0x4,%esp
801013fb:	6a 1c                	push   $0x1c
801013fd:	50                   	push   %eax
801013fe:	ff 75 0c             	push   0xc(%ebp)
80101401:	e8 81 38 00 00       	call   80104c87 <memmove>
80101406:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101409:	83 ec 0c             	sub    $0xc,%esp
8010140c:	ff 75 f4             	push   -0xc(%ebp)
8010140f:	e8 6f ee ff ff       	call   80100283 <brelse>
80101414:	83 c4 10             	add    $0x10,%esp
}
80101417:	90                   	nop
80101418:	c9                   	leave
80101419:	c3                   	ret

8010141a <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010141a:	55                   	push   %ebp
8010141b:	89 e5                	mov    %esp,%ebp
8010141d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101420:	8b 55 0c             	mov    0xc(%ebp),%edx
80101423:	8b 45 08             	mov    0x8(%ebp),%eax
80101426:	83 ec 08             	sub    $0x8,%esp
80101429:	52                   	push   %edx
8010142a:	50                   	push   %eax
8010142b:	e8 d1 ed ff ff       	call   80100201 <bread>
80101430:	83 c4 10             	add    $0x10,%esp
80101433:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101436:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101439:	83 c0 5c             	add    $0x5c,%eax
8010143c:	83 ec 04             	sub    $0x4,%esp
8010143f:	68 00 02 00 00       	push   $0x200
80101444:	6a 00                	push   $0x0
80101446:	50                   	push   %eax
80101447:	e8 7c 37 00 00       	call   80104bc8 <memset>
8010144c:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010144f:	83 ec 0c             	sub    $0xc,%esp
80101452:	ff 75 f4             	push   -0xc(%ebp)
80101455:	e8 1d 1e 00 00       	call   80103277 <log_write>
8010145a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010145d:	83 ec 0c             	sub    $0xc,%esp
80101460:	ff 75 f4             	push   -0xc(%ebp)
80101463:	e8 1b ee ff ff       	call   80100283 <brelse>
80101468:	83 c4 10             	add    $0x10,%esp
}
8010146b:	90                   	nop
8010146c:	c9                   	leave
8010146d:	c3                   	ret

8010146e <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010146e:	55                   	push   %ebp
8010146f:	89 e5                	mov    %esp,%ebp
80101471:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101474:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010147b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101482:	e9 0b 01 00 00       	jmp    80101592 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
80101487:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010148a:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101490:	85 c0                	test   %eax,%eax
80101492:	0f 48 c2             	cmovs  %edx,%eax
80101495:	c1 f8 0c             	sar    $0xc,%eax
80101498:	89 c2                	mov    %eax,%edx
8010149a:	a1 58 24 19 80       	mov    0x80192458,%eax
8010149f:	01 d0                	add    %edx,%eax
801014a1:	83 ec 08             	sub    $0x8,%esp
801014a4:	50                   	push   %eax
801014a5:	ff 75 08             	push   0x8(%ebp)
801014a8:	e8 54 ed ff ff       	call   80100201 <bread>
801014ad:	83 c4 10             	add    $0x10,%esp
801014b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014ba:	e9 9e 00 00 00       	jmp    8010155d <balloc+0xef>
      m = 1 << (bi % 8);
801014bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014c2:	83 e0 07             	and    $0x7,%eax
801014c5:	ba 01 00 00 00       	mov    $0x1,%edx
801014ca:	89 c1                	mov    %eax,%ecx
801014cc:	d3 e2                	shl    %cl,%edx
801014ce:	89 d0                	mov    %edx,%eax
801014d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d6:	8d 50 07             	lea    0x7(%eax),%edx
801014d9:	85 c0                	test   %eax,%eax
801014db:	0f 48 c2             	cmovs  %edx,%eax
801014de:	c1 f8 03             	sar    $0x3,%eax
801014e1:	89 c2                	mov    %eax,%edx
801014e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014e6:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801014eb:	0f b6 c0             	movzbl %al,%eax
801014ee:	23 45 e8             	and    -0x18(%ebp),%eax
801014f1:	85 c0                	test   %eax,%eax
801014f3:	75 64                	jne    80101559 <balloc+0xeb>
        bp->data[bi/8] |= m;  // Mark block in use.
801014f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014f8:	8d 50 07             	lea    0x7(%eax),%edx
801014fb:	85 c0                	test   %eax,%eax
801014fd:	0f 48 c2             	cmovs  %edx,%eax
80101500:	c1 f8 03             	sar    $0x3,%eax
80101503:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101506:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010150b:	89 d1                	mov    %edx,%ecx
8010150d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101510:	09 ca                	or     %ecx,%edx
80101512:	89 d1                	mov    %edx,%ecx
80101514:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101517:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
8010151b:	83 ec 0c             	sub    $0xc,%esp
8010151e:	ff 75 ec             	push   -0x14(%ebp)
80101521:	e8 51 1d 00 00       	call   80103277 <log_write>
80101526:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101529:	83 ec 0c             	sub    $0xc,%esp
8010152c:	ff 75 ec             	push   -0x14(%ebp)
8010152f:	e8 4f ed ff ff       	call   80100283 <brelse>
80101534:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101537:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010153a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010153d:	01 c2                	add    %eax,%edx
8010153f:	8b 45 08             	mov    0x8(%ebp),%eax
80101542:	83 ec 08             	sub    $0x8,%esp
80101545:	52                   	push   %edx
80101546:	50                   	push   %eax
80101547:	e8 ce fe ff ff       	call   8010141a <bzero>
8010154c:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010154f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101552:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101555:	01 d0                	add    %edx,%eax
80101557:	eb 56                	jmp    801015af <balloc+0x141>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101559:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010155d:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101564:	7f 17                	jg     8010157d <balloc+0x10f>
80101566:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101569:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156c:	01 d0                	add    %edx,%eax
8010156e:	89 c2                	mov    %eax,%edx
80101570:	a1 40 24 19 80       	mov    0x80192440,%eax
80101575:	39 c2                	cmp    %eax,%edx
80101577:	0f 82 42 ff ff ff    	jb     801014bf <balloc+0x51>
      }
    }
    brelse(bp);
8010157d:	83 ec 0c             	sub    $0xc,%esp
80101580:	ff 75 ec             	push   -0x14(%ebp)
80101583:	e8 fb ec ff ff       	call   80100283 <brelse>
80101588:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
8010158b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101592:	a1 40 24 19 80       	mov    0x80192440,%eax
80101597:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010159a:	39 c2                	cmp    %eax,%edx
8010159c:	0f 82 e5 fe ff ff    	jb     80101487 <balloc+0x19>
  }
  panic("balloc: out of blocks");
801015a2:	83 ec 0c             	sub    $0xc,%esp
801015a5:	68 00 a3 10 80       	push   $0x8010a300
801015aa:	e8 fa ef ff ff       	call   801005a9 <panic>
}
801015af:	c9                   	leave
801015b0:	c3                   	ret

801015b1 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015b1:	55                   	push   %ebp
801015b2:	89 e5                	mov    %esp,%ebp
801015b4:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801015b7:	83 ec 08             	sub    $0x8,%esp
801015ba:	68 40 24 19 80       	push   $0x80192440
801015bf:	ff 75 08             	push   0x8(%ebp)
801015c2:	e8 11 fe ff ff       	call   801013d8 <readsb>
801015c7:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801015cd:	c1 e8 0c             	shr    $0xc,%eax
801015d0:	89 c2                	mov    %eax,%edx
801015d2:	a1 58 24 19 80       	mov    0x80192458,%eax
801015d7:	01 c2                	add    %eax,%edx
801015d9:	8b 45 08             	mov    0x8(%ebp),%eax
801015dc:	83 ec 08             	sub    $0x8,%esp
801015df:	52                   	push   %edx
801015e0:	50                   	push   %eax
801015e1:	e8 1b ec ff ff       	call   80100201 <bread>
801015e6:	83 c4 10             	add    $0x10,%esp
801015e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801015ef:	25 ff 0f 00 00       	and    $0xfff,%eax
801015f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015fa:	83 e0 07             	and    $0x7,%eax
801015fd:	ba 01 00 00 00       	mov    $0x1,%edx
80101602:	89 c1                	mov    %eax,%ecx
80101604:	d3 e2                	shl    %cl,%edx
80101606:	89 d0                	mov    %edx,%eax
80101608:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010160b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010160e:	8d 50 07             	lea    0x7(%eax),%edx
80101611:	85 c0                	test   %eax,%eax
80101613:	0f 48 c2             	cmovs  %edx,%eax
80101616:	c1 f8 03             	sar    $0x3,%eax
80101619:	89 c2                	mov    %eax,%edx
8010161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010161e:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101623:	0f b6 c0             	movzbl %al,%eax
80101626:	23 45 ec             	and    -0x14(%ebp),%eax
80101629:	85 c0                	test   %eax,%eax
8010162b:	75 0d                	jne    8010163a <bfree+0x89>
    panic("freeing free block");
8010162d:	83 ec 0c             	sub    $0xc,%esp
80101630:	68 16 a3 10 80       	push   $0x8010a316
80101635:	e8 6f ef ff ff       	call   801005a9 <panic>
  bp->data[bi/8] &= ~m;
8010163a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010163d:	8d 50 07             	lea    0x7(%eax),%edx
80101640:	85 c0                	test   %eax,%eax
80101642:	0f 48 c2             	cmovs  %edx,%eax
80101645:	c1 f8 03             	sar    $0x3,%eax
80101648:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010164b:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101650:	89 d1                	mov    %edx,%ecx
80101652:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101655:	f7 d2                	not    %edx
80101657:	21 ca                	and    %ecx,%edx
80101659:	89 d1                	mov    %edx,%ecx
8010165b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010165e:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101662:	83 ec 0c             	sub    $0xc,%esp
80101665:	ff 75 f4             	push   -0xc(%ebp)
80101668:	e8 0a 1c 00 00       	call   80103277 <log_write>
8010166d:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101670:	83 ec 0c             	sub    $0xc,%esp
80101673:	ff 75 f4             	push   -0xc(%ebp)
80101676:	e8 08 ec ff ff       	call   80100283 <brelse>
8010167b:	83 c4 10             	add    $0x10,%esp
}
8010167e:	90                   	nop
8010167f:	c9                   	leave
80101680:	c3                   	ret

80101681 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101681:	55                   	push   %ebp
80101682:	89 e5                	mov    %esp,%ebp
80101684:	57                   	push   %edi
80101685:	56                   	push   %esi
80101686:	53                   	push   %ebx
80101687:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
8010168a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
80101691:	83 ec 08             	sub    $0x8,%esp
80101694:	68 29 a3 10 80       	push   $0x8010a329
80101699:	68 60 24 19 80       	push   $0x80192460
8010169e:	e8 8d 32 00 00       	call   80104930 <initlock>
801016a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801016ad:	eb 2d                	jmp    801016dc <iinit+0x5b>
    initsleeplock(&icache.inode[i].lock, "inode");
801016af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016b2:	89 d0                	mov    %edx,%eax
801016b4:	c1 e0 03             	shl    $0x3,%eax
801016b7:	01 d0                	add    %edx,%eax
801016b9:	c1 e0 04             	shl    $0x4,%eax
801016bc:	83 c0 30             	add    $0x30,%eax
801016bf:	05 60 24 19 80       	add    $0x80192460,%eax
801016c4:	83 c0 10             	add    $0x10,%eax
801016c7:	83 ec 08             	sub    $0x8,%esp
801016ca:	68 30 a3 10 80       	push   $0x8010a330
801016cf:	50                   	push   %eax
801016d0:	e8 fe 30 00 00       	call   801047d3 <initsleeplock>
801016d5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801016d8:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801016dc:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801016e0:	7e cd                	jle    801016af <iinit+0x2e>
  }

  readsb(dev, &sb);
801016e2:	83 ec 08             	sub    $0x8,%esp
801016e5:	68 40 24 19 80       	push   $0x80192440
801016ea:	ff 75 08             	push   0x8(%ebp)
801016ed:	e8 e6 fc ff ff       	call   801013d8 <readsb>
801016f2:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016f5:	a1 58 24 19 80       	mov    0x80192458,%eax
801016fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801016fd:	8b 3d 54 24 19 80    	mov    0x80192454,%edi
80101703:	8b 35 50 24 19 80    	mov    0x80192450,%esi
80101709:	8b 1d 4c 24 19 80    	mov    0x8019244c,%ebx
8010170f:	8b 0d 48 24 19 80    	mov    0x80192448,%ecx
80101715:	8b 15 44 24 19 80    	mov    0x80192444,%edx
8010171b:	a1 40 24 19 80       	mov    0x80192440,%eax
80101720:	ff 75 d4             	push   -0x2c(%ebp)
80101723:	57                   	push   %edi
80101724:	56                   	push   %esi
80101725:	53                   	push   %ebx
80101726:	51                   	push   %ecx
80101727:	52                   	push   %edx
80101728:	50                   	push   %eax
80101729:	68 38 a3 10 80       	push   $0x8010a338
8010172e:	e8 c1 ec ff ff       	call   801003f4 <cprintf>
80101733:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101736:	90                   	nop
80101737:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010173a:	5b                   	pop    %ebx
8010173b:	5e                   	pop    %esi
8010173c:	5f                   	pop    %edi
8010173d:	5d                   	pop    %ebp
8010173e:	c3                   	ret

8010173f <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
8010173f:	55                   	push   %ebp
80101740:	89 e5                	mov    %esp,%ebp
80101742:	83 ec 28             	sub    $0x28,%esp
80101745:	8b 45 0c             	mov    0xc(%ebp),%eax
80101748:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010174c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101753:	e9 9e 00 00 00       	jmp    801017f6 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101758:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010175b:	c1 e8 03             	shr    $0x3,%eax
8010175e:	89 c2                	mov    %eax,%edx
80101760:	a1 54 24 19 80       	mov    0x80192454,%eax
80101765:	01 d0                	add    %edx,%eax
80101767:	83 ec 08             	sub    $0x8,%esp
8010176a:	50                   	push   %eax
8010176b:	ff 75 08             	push   0x8(%ebp)
8010176e:	e8 8e ea ff ff       	call   80100201 <bread>
80101773:	83 c4 10             	add    $0x10,%esp
80101776:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101779:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010177c:	8d 50 5c             	lea    0x5c(%eax),%edx
8010177f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101782:	83 e0 07             	and    $0x7,%eax
80101785:	c1 e0 06             	shl    $0x6,%eax
80101788:	01 d0                	add    %edx,%eax
8010178a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010178d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101790:	0f b7 00             	movzwl (%eax),%eax
80101793:	66 85 c0             	test   %ax,%ax
80101796:	75 4c                	jne    801017e4 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
80101798:	83 ec 04             	sub    $0x4,%esp
8010179b:	6a 40                	push   $0x40
8010179d:	6a 00                	push   $0x0
8010179f:	ff 75 ec             	push   -0x14(%ebp)
801017a2:	e8 21 34 00 00       	call   80104bc8 <memset>
801017a7:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017ad:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017b1:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017b4:	83 ec 0c             	sub    $0xc,%esp
801017b7:	ff 75 f0             	push   -0x10(%ebp)
801017ba:	e8 b8 1a 00 00       	call   80103277 <log_write>
801017bf:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017c2:	83 ec 0c             	sub    $0xc,%esp
801017c5:	ff 75 f0             	push   -0x10(%ebp)
801017c8:	e8 b6 ea ff ff       	call   80100283 <brelse>
801017cd:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d3:	83 ec 08             	sub    $0x8,%esp
801017d6:	50                   	push   %eax
801017d7:	ff 75 08             	push   0x8(%ebp)
801017da:	e8 f7 00 00 00       	call   801018d6 <iget>
801017df:	83 c4 10             	add    $0x10,%esp
801017e2:	eb 2f                	jmp    80101813 <ialloc+0xd4>
    }
    brelse(bp);
801017e4:	83 ec 0c             	sub    $0xc,%esp
801017e7:	ff 75 f0             	push   -0x10(%ebp)
801017ea:	e8 94 ea ff ff       	call   80100283 <brelse>
801017ef:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801017f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801017f6:	a1 48 24 19 80       	mov    0x80192448,%eax
801017fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801017fe:	39 c2                	cmp    %eax,%edx
80101800:	0f 82 52 ff ff ff    	jb     80101758 <ialloc+0x19>
  }
  panic("ialloc: no inodes");
80101806:	83 ec 0c             	sub    $0xc,%esp
80101809:	68 8b a3 10 80       	push   $0x8010a38b
8010180e:	e8 96 ed ff ff       	call   801005a9 <panic>
}
80101813:	c9                   	leave
80101814:	c3                   	ret

80101815 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101815:	55                   	push   %ebp
80101816:	89 e5                	mov    %esp,%ebp
80101818:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010181b:	8b 45 08             	mov    0x8(%ebp),%eax
8010181e:	8b 40 04             	mov    0x4(%eax),%eax
80101821:	c1 e8 03             	shr    $0x3,%eax
80101824:	89 c2                	mov    %eax,%edx
80101826:	a1 54 24 19 80       	mov    0x80192454,%eax
8010182b:	01 c2                	add    %eax,%edx
8010182d:	8b 45 08             	mov    0x8(%ebp),%eax
80101830:	8b 00                	mov    (%eax),%eax
80101832:	83 ec 08             	sub    $0x8,%esp
80101835:	52                   	push   %edx
80101836:	50                   	push   %eax
80101837:	e8 c5 e9 ff ff       	call   80100201 <bread>
8010183c:	83 c4 10             	add    $0x10,%esp
8010183f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101842:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101845:	8d 50 5c             	lea    0x5c(%eax),%edx
80101848:	8b 45 08             	mov    0x8(%ebp),%eax
8010184b:	8b 40 04             	mov    0x4(%eax),%eax
8010184e:	83 e0 07             	and    $0x7,%eax
80101851:	c1 e0 06             	shl    $0x6,%eax
80101854:	01 d0                	add    %edx,%eax
80101856:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101859:	8b 45 08             	mov    0x8(%ebp),%eax
8010185c:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101860:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101863:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101866:	8b 45 08             	mov    0x8(%ebp),%eax
80101869:	0f b7 50 52          	movzwl 0x52(%eax),%edx
8010186d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101870:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101874:	8b 45 08             	mov    0x8(%ebp),%eax
80101877:	0f b7 50 54          	movzwl 0x54(%eax),%edx
8010187b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010187e:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101882:	8b 45 08             	mov    0x8(%ebp),%eax
80101885:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101889:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010188c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101890:	8b 45 08             	mov    0x8(%ebp),%eax
80101893:	8b 50 58             	mov    0x58(%eax),%edx
80101896:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101899:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010189c:	8b 45 08             	mov    0x8(%ebp),%eax
8010189f:	8d 50 5c             	lea    0x5c(%eax),%edx
801018a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a5:	83 c0 0c             	add    $0xc,%eax
801018a8:	83 ec 04             	sub    $0x4,%esp
801018ab:	6a 34                	push   $0x34
801018ad:	52                   	push   %edx
801018ae:	50                   	push   %eax
801018af:	e8 d3 33 00 00       	call   80104c87 <memmove>
801018b4:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018b7:	83 ec 0c             	sub    $0xc,%esp
801018ba:	ff 75 f4             	push   -0xc(%ebp)
801018bd:	e8 b5 19 00 00       	call   80103277 <log_write>
801018c2:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018c5:	83 ec 0c             	sub    $0xc,%esp
801018c8:	ff 75 f4             	push   -0xc(%ebp)
801018cb:	e8 b3 e9 ff ff       	call   80100283 <brelse>
801018d0:	83 c4 10             	add    $0x10,%esp
}
801018d3:	90                   	nop
801018d4:	c9                   	leave
801018d5:	c3                   	ret

801018d6 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018d6:	55                   	push   %ebp
801018d7:	89 e5                	mov    %esp,%ebp
801018d9:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018dc:	83 ec 0c             	sub    $0xc,%esp
801018df:	68 60 24 19 80       	push   $0x80192460
801018e4:	e8 69 30 00 00       	call   80104952 <acquire>
801018e9:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801018ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018f3:	c7 45 f4 94 24 19 80 	movl   $0x80192494,-0xc(%ebp)
801018fa:	eb 60                	jmp    8010195c <iget+0x86>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ff:	8b 40 08             	mov    0x8(%eax),%eax
80101902:	85 c0                	test   %eax,%eax
80101904:	7e 39                	jle    8010193f <iget+0x69>
80101906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101909:	8b 00                	mov    (%eax),%eax
8010190b:	39 45 08             	cmp    %eax,0x8(%ebp)
8010190e:	75 2f                	jne    8010193f <iget+0x69>
80101910:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101913:	8b 40 04             	mov    0x4(%eax),%eax
80101916:	39 45 0c             	cmp    %eax,0xc(%ebp)
80101919:	75 24                	jne    8010193f <iget+0x69>
      ip->ref++;
8010191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191e:	8b 40 08             	mov    0x8(%eax),%eax
80101921:	8d 50 01             	lea    0x1(%eax),%edx
80101924:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101927:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010192a:	83 ec 0c             	sub    $0xc,%esp
8010192d:	68 60 24 19 80       	push   $0x80192460
80101932:	e8 89 30 00 00       	call   801049c0 <release>
80101937:	83 c4 10             	add    $0x10,%esp
      return ip;
8010193a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193d:	eb 77                	jmp    801019b6 <iget+0xe0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010193f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101943:	75 10                	jne    80101955 <iget+0x7f>
80101945:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101948:	8b 40 08             	mov    0x8(%eax),%eax
8010194b:	85 c0                	test   %eax,%eax
8010194d:	75 06                	jne    80101955 <iget+0x7f>
      empty = ip;
8010194f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101952:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101955:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
8010195c:	81 7d f4 b4 40 19 80 	cmpl   $0x801940b4,-0xc(%ebp)
80101963:	72 97                	jb     801018fc <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101965:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101969:	75 0d                	jne    80101978 <iget+0xa2>
    panic("iget: no inodes");
8010196b:	83 ec 0c             	sub    $0xc,%esp
8010196e:	68 9d a3 10 80       	push   $0x8010a39d
80101973:	e8 31 ec ff ff       	call   801005a9 <panic>

  ip = empty;
80101978:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010197b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010197e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101981:	8b 55 08             	mov    0x8(%ebp),%edx
80101984:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101986:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101989:	8b 55 0c             	mov    0xc(%ebp),%edx
8010198c:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010198f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101992:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101999:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010199c:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
801019a3:	83 ec 0c             	sub    $0xc,%esp
801019a6:	68 60 24 19 80       	push   $0x80192460
801019ab:	e8 10 30 00 00       	call   801049c0 <release>
801019b0:	83 c4 10             	add    $0x10,%esp

  return ip;
801019b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019b6:	c9                   	leave
801019b7:	c3                   	ret

801019b8 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019b8:	55                   	push   %ebp
801019b9:	89 e5                	mov    %esp,%ebp
801019bb:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019be:	83 ec 0c             	sub    $0xc,%esp
801019c1:	68 60 24 19 80       	push   $0x80192460
801019c6:	e8 87 2f 00 00       	call   80104952 <acquire>
801019cb:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019ce:	8b 45 08             	mov    0x8(%ebp),%eax
801019d1:	8b 40 08             	mov    0x8(%eax),%eax
801019d4:	8d 50 01             	lea    0x1(%eax),%edx
801019d7:	8b 45 08             	mov    0x8(%ebp),%eax
801019da:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019dd:	83 ec 0c             	sub    $0xc,%esp
801019e0:	68 60 24 19 80       	push   $0x80192460
801019e5:	e8 d6 2f 00 00       	call   801049c0 <release>
801019ea:	83 c4 10             	add    $0x10,%esp
  return ip;
801019ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
801019f0:	c9                   	leave
801019f1:	c3                   	ret

801019f2 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801019f2:	55                   	push   %ebp
801019f3:	89 e5                	mov    %esp,%ebp
801019f5:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801019f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019fc:	74 0a                	je     80101a08 <ilock+0x16>
801019fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101a01:	8b 40 08             	mov    0x8(%eax),%eax
80101a04:	85 c0                	test   %eax,%eax
80101a06:	7f 0d                	jg     80101a15 <ilock+0x23>
    panic("ilock");
80101a08:	83 ec 0c             	sub    $0xc,%esp
80101a0b:	68 ad a3 10 80       	push   $0x8010a3ad
80101a10:	e8 94 eb ff ff       	call   801005a9 <panic>

  acquiresleep(&ip->lock);
80101a15:	8b 45 08             	mov    0x8(%ebp),%eax
80101a18:	83 c0 0c             	add    $0xc,%eax
80101a1b:	83 ec 0c             	sub    $0xc,%esp
80101a1e:	50                   	push   %eax
80101a1f:	e8 eb 2d 00 00       	call   8010480f <acquiresleep>
80101a24:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101a27:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a2d:	85 c0                	test   %eax,%eax
80101a2f:	0f 85 cd 00 00 00    	jne    80101b02 <ilock+0x110>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a35:	8b 45 08             	mov    0x8(%ebp),%eax
80101a38:	8b 40 04             	mov    0x4(%eax),%eax
80101a3b:	c1 e8 03             	shr    $0x3,%eax
80101a3e:	89 c2                	mov    %eax,%edx
80101a40:	a1 54 24 19 80       	mov    0x80192454,%eax
80101a45:	01 c2                	add    %eax,%edx
80101a47:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4a:	8b 00                	mov    (%eax),%eax
80101a4c:	83 ec 08             	sub    $0x8,%esp
80101a4f:	52                   	push   %edx
80101a50:	50                   	push   %eax
80101a51:	e8 ab e7 ff ff       	call   80100201 <bread>
80101a56:	83 c4 10             	add    $0x10,%esp
80101a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a5f:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a62:	8b 45 08             	mov    0x8(%ebp),%eax
80101a65:	8b 40 04             	mov    0x4(%eax),%eax
80101a68:	83 e0 07             	and    $0x7,%eax
80101a6b:	c1 e0 06             	shl    $0x6,%eax
80101a6e:	01 d0                	add    %edx,%eax
80101a70:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a76:	0f b7 10             	movzwl (%eax),%edx
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a83:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a87:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8a:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a91:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a95:	8b 45 08             	mov    0x8(%ebp),%eax
80101a98:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a9f:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aad:	8b 50 08             	mov    0x8(%eax),%edx
80101ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab3:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ab9:	8d 50 0c             	lea    0xc(%eax),%edx
80101abc:	8b 45 08             	mov    0x8(%ebp),%eax
80101abf:	83 c0 5c             	add    $0x5c,%eax
80101ac2:	83 ec 04             	sub    $0x4,%esp
80101ac5:	6a 34                	push   $0x34
80101ac7:	52                   	push   %edx
80101ac8:	50                   	push   %eax
80101ac9:	e8 b9 31 00 00       	call   80104c87 <memmove>
80101ace:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101ad1:	83 ec 0c             	sub    $0xc,%esp
80101ad4:	ff 75 f4             	push   -0xc(%ebp)
80101ad7:	e8 a7 e7 ff ff       	call   80100283 <brelse>
80101adc:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101adf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae2:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aec:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101af0:	66 85 c0             	test   %ax,%ax
80101af3:	75 0d                	jne    80101b02 <ilock+0x110>
      panic("ilock: no type");
80101af5:	83 ec 0c             	sub    $0xc,%esp
80101af8:	68 b3 a3 10 80       	push   $0x8010a3b3
80101afd:	e8 a7 ea ff ff       	call   801005a9 <panic>
  }
}
80101b02:	90                   	nop
80101b03:	c9                   	leave
80101b04:	c3                   	ret

80101b05 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b05:	55                   	push   %ebp
80101b06:	89 e5                	mov    %esp,%ebp
80101b08:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b0f:	74 20                	je     80101b31 <iunlock+0x2c>
80101b11:	8b 45 08             	mov    0x8(%ebp),%eax
80101b14:	83 c0 0c             	add    $0xc,%eax
80101b17:	83 ec 0c             	sub    $0xc,%esp
80101b1a:	50                   	push   %eax
80101b1b:	e8 a1 2d 00 00       	call   801048c1 <holdingsleep>
80101b20:	83 c4 10             	add    $0x10,%esp
80101b23:	85 c0                	test   %eax,%eax
80101b25:	74 0a                	je     80101b31 <iunlock+0x2c>
80101b27:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2a:	8b 40 08             	mov    0x8(%eax),%eax
80101b2d:	85 c0                	test   %eax,%eax
80101b2f:	7f 0d                	jg     80101b3e <iunlock+0x39>
    panic("iunlock");
80101b31:	83 ec 0c             	sub    $0xc,%esp
80101b34:	68 c2 a3 10 80       	push   $0x8010a3c2
80101b39:	e8 6b ea ff ff       	call   801005a9 <panic>

  releasesleep(&ip->lock);
80101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b41:	83 c0 0c             	add    $0xc,%eax
80101b44:	83 ec 0c             	sub    $0xc,%esp
80101b47:	50                   	push   %eax
80101b48:	e8 26 2d 00 00       	call   80104873 <releasesleep>
80101b4d:	83 c4 10             	add    $0x10,%esp
}
80101b50:	90                   	nop
80101b51:	c9                   	leave
80101b52:	c3                   	ret

80101b53 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b53:	55                   	push   %ebp
80101b54:	89 e5                	mov    %esp,%ebp
80101b56:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101b59:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5c:	83 c0 0c             	add    $0xc,%eax
80101b5f:	83 ec 0c             	sub    $0xc,%esp
80101b62:	50                   	push   %eax
80101b63:	e8 a7 2c 00 00       	call   8010480f <acquiresleep>
80101b68:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101b6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6e:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 6a                	je     80101bdf <iput+0x8c>
80101b75:	8b 45 08             	mov    0x8(%ebp),%eax
80101b78:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101b7c:	66 85 c0             	test   %ax,%ax
80101b7f:	75 5e                	jne    80101bdf <iput+0x8c>
    acquire(&icache.lock);
80101b81:	83 ec 0c             	sub    $0xc,%esp
80101b84:	68 60 24 19 80       	push   $0x80192460
80101b89:	e8 c4 2d 00 00       	call   80104952 <acquire>
80101b8e:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101b91:	8b 45 08             	mov    0x8(%ebp),%eax
80101b94:	8b 40 08             	mov    0x8(%eax),%eax
80101b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b9a:	83 ec 0c             	sub    $0xc,%esp
80101b9d:	68 60 24 19 80       	push   $0x80192460
80101ba2:	e8 19 2e 00 00       	call   801049c0 <release>
80101ba7:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101baa:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101bae:	75 2f                	jne    80101bdf <iput+0x8c>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101bb0:	83 ec 0c             	sub    $0xc,%esp
80101bb3:	ff 75 08             	push   0x8(%ebp)
80101bb6:	e8 ad 01 00 00       	call   80101d68 <itrunc>
80101bbb:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101bbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc1:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101bc7:	83 ec 0c             	sub    $0xc,%esp
80101bca:	ff 75 08             	push   0x8(%ebp)
80101bcd:	e8 43 fc ff ff       	call   80101815 <iupdate>
80101bd2:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd8:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101bdf:	8b 45 08             	mov    0x8(%ebp),%eax
80101be2:	83 c0 0c             	add    $0xc,%eax
80101be5:	83 ec 0c             	sub    $0xc,%esp
80101be8:	50                   	push   %eax
80101be9:	e8 85 2c 00 00       	call   80104873 <releasesleep>
80101bee:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101bf1:	83 ec 0c             	sub    $0xc,%esp
80101bf4:	68 60 24 19 80       	push   $0x80192460
80101bf9:	e8 54 2d 00 00       	call   80104952 <acquire>
80101bfe:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101c01:	8b 45 08             	mov    0x8(%ebp),%eax
80101c04:	8b 40 08             	mov    0x8(%eax),%eax
80101c07:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0d:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c10:	83 ec 0c             	sub    $0xc,%esp
80101c13:	68 60 24 19 80       	push   $0x80192460
80101c18:	e8 a3 2d 00 00       	call   801049c0 <release>
80101c1d:	83 c4 10             	add    $0x10,%esp
}
80101c20:	90                   	nop
80101c21:	c9                   	leave
80101c22:	c3                   	ret

80101c23 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c23:	55                   	push   %ebp
80101c24:	89 e5                	mov    %esp,%ebp
80101c26:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c29:	83 ec 0c             	sub    $0xc,%esp
80101c2c:	ff 75 08             	push   0x8(%ebp)
80101c2f:	e8 d1 fe ff ff       	call   80101b05 <iunlock>
80101c34:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c37:	83 ec 0c             	sub    $0xc,%esp
80101c3a:	ff 75 08             	push   0x8(%ebp)
80101c3d:	e8 11 ff ff ff       	call   80101b53 <iput>
80101c42:	83 c4 10             	add    $0x10,%esp
}
80101c45:	90                   	nop
80101c46:	c9                   	leave
80101c47:	c3                   	ret

80101c48 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c48:	55                   	push   %ebp
80101c49:	89 e5                	mov    %esp,%ebp
80101c4b:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c4e:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c52:	77 42                	ja     80101c96 <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
80101c54:	8b 45 08             	mov    0x8(%ebp),%eax
80101c57:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c5a:	83 c2 14             	add    $0x14,%edx
80101c5d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c68:	75 24                	jne    80101c8e <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6d:	8b 00                	mov    (%eax),%eax
80101c6f:	83 ec 0c             	sub    $0xc,%esp
80101c72:	50                   	push   %eax
80101c73:	e8 f6 f7 ff ff       	call   8010146e <balloc>
80101c78:	83 c4 10             	add    $0x10,%esp
80101c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c81:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c84:	8d 4a 14             	lea    0x14(%edx),%ecx
80101c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c8a:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c91:	e9 d0 00 00 00       	jmp    80101d66 <bmap+0x11e>
  }
  bn -= NDIRECT;
80101c96:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c9a:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c9e:	0f 87 b5 00 00 00    	ja     80101d59 <bmap+0x111>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca7:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cb4:	75 20                	jne    80101cd6 <bmap+0x8e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb9:	8b 00                	mov    (%eax),%eax
80101cbb:	83 ec 0c             	sub    $0xc,%esp
80101cbe:	50                   	push   %eax
80101cbf:	e8 aa f7 ff ff       	call   8010146e <balloc>
80101cc4:	83 c4 10             	add    $0x10,%esp
80101cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cca:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cd0:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101cd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd9:	8b 00                	mov    (%eax),%eax
80101cdb:	83 ec 08             	sub    $0x8,%esp
80101cde:	ff 75 f4             	push   -0xc(%ebp)
80101ce1:	50                   	push   %eax
80101ce2:	e8 1a e5 ff ff       	call   80100201 <bread>
80101ce7:	83 c4 10             	add    $0x10,%esp
80101cea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cf0:	83 c0 5c             	add    $0x5c,%eax
80101cf3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cf9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d03:	01 d0                	add    %edx,%eax
80101d05:	8b 00                	mov    (%eax),%eax
80101d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d0e:	75 36                	jne    80101d46 <bmap+0xfe>
      a[bn] = addr = balloc(ip->dev);
80101d10:	8b 45 08             	mov    0x8(%ebp),%eax
80101d13:	8b 00                	mov    (%eax),%eax
80101d15:	83 ec 0c             	sub    $0xc,%esp
80101d18:	50                   	push   %eax
80101d19:	e8 50 f7 ff ff       	call   8010146e <balloc>
80101d1e:	83 c4 10             	add    $0x10,%esp
80101d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d24:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d31:	01 c2                	add    %eax,%edx
80101d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d36:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101d38:	83 ec 0c             	sub    $0xc,%esp
80101d3b:	ff 75 f0             	push   -0x10(%ebp)
80101d3e:	e8 34 15 00 00       	call   80103277 <log_write>
80101d43:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d46:	83 ec 0c             	sub    $0xc,%esp
80101d49:	ff 75 f0             	push   -0x10(%ebp)
80101d4c:	e8 32 e5 ff ff       	call   80100283 <brelse>
80101d51:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d57:	eb 0d                	jmp    80101d66 <bmap+0x11e>
  }

  panic("bmap: out of range");
80101d59:	83 ec 0c             	sub    $0xc,%esp
80101d5c:	68 ca a3 10 80       	push   $0x8010a3ca
80101d61:	e8 43 e8 ff ff       	call   801005a9 <panic>
}
80101d66:	c9                   	leave
80101d67:	c3                   	ret

80101d68 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d68:	55                   	push   %ebp
80101d69:	89 e5                	mov    %esp,%ebp
80101d6b:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d75:	eb 45                	jmp    80101dbc <itrunc+0x54>
    if(ip->addrs[i]){
80101d77:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d7d:	83 c2 14             	add    $0x14,%edx
80101d80:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d84:	85 c0                	test   %eax,%eax
80101d86:	74 30                	je     80101db8 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d88:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d8e:	83 c2 14             	add    $0x14,%edx
80101d91:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d95:	8b 55 08             	mov    0x8(%ebp),%edx
80101d98:	8b 12                	mov    (%edx),%edx
80101d9a:	83 ec 08             	sub    $0x8,%esp
80101d9d:	50                   	push   %eax
80101d9e:	52                   	push   %edx
80101d9f:	e8 0d f8 ff ff       	call   801015b1 <bfree>
80101da4:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101da7:	8b 45 08             	mov    0x8(%ebp),%eax
80101daa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dad:	83 c2 14             	add    $0x14,%edx
80101db0:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101db7:	00 
  for(i = 0; i < NDIRECT; i++){
80101db8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101dbc:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101dc0:	7e b5                	jle    80101d77 <itrunc+0xf>
    }
  }

  if(ip->addrs[NDIRECT]){
80101dc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc5:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101dcb:	85 c0                	test   %eax,%eax
80101dcd:	0f 84 aa 00 00 00    	je     80101e7d <itrunc+0x115>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101dd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd6:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101ddc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ddf:	8b 00                	mov    (%eax),%eax
80101de1:	83 ec 08             	sub    $0x8,%esp
80101de4:	52                   	push   %edx
80101de5:	50                   	push   %eax
80101de6:	e8 16 e4 ff ff       	call   80100201 <bread>
80101deb:	83 c4 10             	add    $0x10,%esp
80101dee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101df4:	83 c0 5c             	add    $0x5c,%eax
80101df7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101dfa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e01:	eb 3c                	jmp    80101e3f <itrunc+0xd7>
      if(a[j])
80101e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e06:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e10:	01 d0                	add    %edx,%eax
80101e12:	8b 00                	mov    (%eax),%eax
80101e14:	85 c0                	test   %eax,%eax
80101e16:	74 23                	je     80101e3b <itrunc+0xd3>
        bfree(ip->dev, a[j]);
80101e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e1b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e25:	01 d0                	add    %edx,%eax
80101e27:	8b 00                	mov    (%eax),%eax
80101e29:	8b 55 08             	mov    0x8(%ebp),%edx
80101e2c:	8b 12                	mov    (%edx),%edx
80101e2e:	83 ec 08             	sub    $0x8,%esp
80101e31:	50                   	push   %eax
80101e32:	52                   	push   %edx
80101e33:	e8 79 f7 ff ff       	call   801015b1 <bfree>
80101e38:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101e3b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e42:	83 f8 7f             	cmp    $0x7f,%eax
80101e45:	76 bc                	jbe    80101e03 <itrunc+0x9b>
    }
    brelse(bp);
80101e47:	83 ec 0c             	sub    $0xc,%esp
80101e4a:	ff 75 ec             	push   -0x14(%ebp)
80101e4d:	e8 31 e4 ff ff       	call   80100283 <brelse>
80101e52:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e55:	8b 45 08             	mov    0x8(%ebp),%eax
80101e58:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e5e:	8b 55 08             	mov    0x8(%ebp),%edx
80101e61:	8b 12                	mov    (%edx),%edx
80101e63:	83 ec 08             	sub    $0x8,%esp
80101e66:	50                   	push   %eax
80101e67:	52                   	push   %edx
80101e68:	e8 44 f7 ff ff       	call   801015b1 <bfree>
80101e6d:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e70:	8b 45 08             	mov    0x8(%ebp),%eax
80101e73:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101e7a:	00 00 00 
  }

  ip->size = 0;
80101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e80:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101e87:	83 ec 0c             	sub    $0xc,%esp
80101e8a:	ff 75 08             	push   0x8(%ebp)
80101e8d:	e8 83 f9 ff ff       	call   80101815 <iupdate>
80101e92:	83 c4 10             	add    $0x10,%esp
}
80101e95:	90                   	nop
80101e96:	c9                   	leave
80101e97:	c3                   	ret

80101e98 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101e98:	55                   	push   %ebp
80101e99:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9e:	8b 00                	mov    (%eax),%eax
80101ea0:	89 c2                	mov    %eax,%edx
80101ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea5:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101ea8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eab:	8b 50 04             	mov    0x4(%eax),%edx
80101eae:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb1:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101eb4:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb7:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ebe:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101ec1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec4:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ecb:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed2:	8b 50 58             	mov    0x58(%eax),%edx
80101ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed8:	89 50 10             	mov    %edx,0x10(%eax)
}
80101edb:	90                   	nop
80101edc:	5d                   	pop    %ebp
80101edd:	c3                   	ret

80101ede <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ede:	55                   	push   %ebp
80101edf:	89 e5                	mov    %esp,%ebp
80101ee1:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee7:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101eeb:	66 83 f8 03          	cmp    $0x3,%ax
80101eef:	75 5c                	jne    80101f4d <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ef1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef4:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101ef8:	66 85 c0             	test   %ax,%ax
80101efb:	78 20                	js     80101f1d <readi+0x3f>
80101efd:	8b 45 08             	mov    0x8(%ebp),%eax
80101f00:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f04:	66 83 f8 09          	cmp    $0x9,%ax
80101f08:	7f 13                	jg     80101f1d <readi+0x3f>
80101f0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0d:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f11:	98                   	cwtl
80101f12:	8b 04 c5 40 1a 19 80 	mov    -0x7fe6e5c0(,%eax,8),%eax
80101f19:	85 c0                	test   %eax,%eax
80101f1b:	75 0a                	jne    80101f27 <readi+0x49>
      return -1;
80101f1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f22:	e9 0a 01 00 00       	jmp    80102031 <readi+0x153>
    return devsw[ip->major].read(ip, dst, n);
80101f27:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f2e:	98                   	cwtl
80101f2f:	8b 04 c5 40 1a 19 80 	mov    -0x7fe6e5c0(,%eax,8),%eax
80101f36:	8b 55 14             	mov    0x14(%ebp),%edx
80101f39:	83 ec 04             	sub    $0x4,%esp
80101f3c:	52                   	push   %edx
80101f3d:	ff 75 0c             	push   0xc(%ebp)
80101f40:	ff 75 08             	push   0x8(%ebp)
80101f43:	ff d0                	call   *%eax
80101f45:	83 c4 10             	add    $0x10,%esp
80101f48:	e9 e4 00 00 00       	jmp    80102031 <readi+0x153>
  }

  if(off > ip->size || off + n < off)
80101f4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f50:	8b 40 58             	mov    0x58(%eax),%eax
80101f53:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f56:	72 0d                	jb     80101f65 <readi+0x87>
80101f58:	8b 55 10             	mov    0x10(%ebp),%edx
80101f5b:	8b 45 14             	mov    0x14(%ebp),%eax
80101f5e:	01 d0                	add    %edx,%eax
80101f60:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f63:	73 0a                	jae    80101f6f <readi+0x91>
    return -1;
80101f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f6a:	e9 c2 00 00 00       	jmp    80102031 <readi+0x153>
  if(off + n > ip->size)
80101f6f:	8b 55 10             	mov    0x10(%ebp),%edx
80101f72:	8b 45 14             	mov    0x14(%ebp),%eax
80101f75:	01 c2                	add    %eax,%edx
80101f77:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7a:	8b 40 58             	mov    0x58(%eax),%eax
80101f7d:	39 d0                	cmp    %edx,%eax
80101f7f:	73 0c                	jae    80101f8d <readi+0xaf>
    n = ip->size - off;
80101f81:	8b 45 08             	mov    0x8(%ebp),%eax
80101f84:	8b 40 58             	mov    0x58(%eax),%eax
80101f87:	2b 45 10             	sub    0x10(%ebp),%eax
80101f8a:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f94:	e9 89 00 00 00       	jmp    80102022 <readi+0x144>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f99:	8b 45 10             	mov    0x10(%ebp),%eax
80101f9c:	c1 e8 09             	shr    $0x9,%eax
80101f9f:	83 ec 08             	sub    $0x8,%esp
80101fa2:	50                   	push   %eax
80101fa3:	ff 75 08             	push   0x8(%ebp)
80101fa6:	e8 9d fc ff ff       	call   80101c48 <bmap>
80101fab:	83 c4 10             	add    $0x10,%esp
80101fae:	8b 55 08             	mov    0x8(%ebp),%edx
80101fb1:	8b 12                	mov    (%edx),%edx
80101fb3:	83 ec 08             	sub    $0x8,%esp
80101fb6:	50                   	push   %eax
80101fb7:	52                   	push   %edx
80101fb8:	e8 44 e2 ff ff       	call   80100201 <bread>
80101fbd:	83 c4 10             	add    $0x10,%esp
80101fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc3:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fcb:	ba 00 02 00 00       	mov    $0x200,%edx
80101fd0:	29 c2                	sub    %eax,%edx
80101fd2:	8b 45 14             	mov    0x14(%ebp),%eax
80101fd5:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101fd8:	39 c2                	cmp    %eax,%edx
80101fda:	0f 46 c2             	cmovbe %edx,%eax
80101fdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fe3:	8d 50 5c             	lea    0x5c(%eax),%edx
80101fe6:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fee:	01 d0                	add    %edx,%eax
80101ff0:	83 ec 04             	sub    $0x4,%esp
80101ff3:	ff 75 ec             	push   -0x14(%ebp)
80101ff6:	50                   	push   %eax
80101ff7:	ff 75 0c             	push   0xc(%ebp)
80101ffa:	e8 88 2c 00 00       	call   80104c87 <memmove>
80101fff:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102002:	83 ec 0c             	sub    $0xc,%esp
80102005:	ff 75 f0             	push   -0x10(%ebp)
80102008:	e8 76 e2 ff ff       	call   80100283 <brelse>
8010200d:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102010:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102013:	01 45 f4             	add    %eax,-0xc(%ebp)
80102016:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102019:	01 45 10             	add    %eax,0x10(%ebp)
8010201c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010201f:	01 45 0c             	add    %eax,0xc(%ebp)
80102022:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102025:	3b 45 14             	cmp    0x14(%ebp),%eax
80102028:	0f 82 6b ff ff ff    	jb     80101f99 <readi+0xbb>
  }
  return n;
8010202e:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102031:	c9                   	leave
80102032:	c3                   	ret

80102033 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102033:	55                   	push   %ebp
80102034:	89 e5                	mov    %esp,%ebp
80102036:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102039:	8b 45 08             	mov    0x8(%ebp),%eax
8010203c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102040:	66 83 f8 03          	cmp    $0x3,%ax
80102044:	75 5c                	jne    801020a2 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102046:	8b 45 08             	mov    0x8(%ebp),%eax
80102049:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010204d:	66 85 c0             	test   %ax,%ax
80102050:	78 20                	js     80102072 <writei+0x3f>
80102052:	8b 45 08             	mov    0x8(%ebp),%eax
80102055:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102059:	66 83 f8 09          	cmp    $0x9,%ax
8010205d:	7f 13                	jg     80102072 <writei+0x3f>
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
80102062:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102066:	98                   	cwtl
80102067:	8b 04 c5 44 1a 19 80 	mov    -0x7fe6e5bc(,%eax,8),%eax
8010206e:	85 c0                	test   %eax,%eax
80102070:	75 0a                	jne    8010207c <writei+0x49>
      return -1;
80102072:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102077:	e9 3b 01 00 00       	jmp    801021b7 <writei+0x184>
    return devsw[ip->major].write(ip, src, n);
8010207c:	8b 45 08             	mov    0x8(%ebp),%eax
8010207f:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102083:	98                   	cwtl
80102084:	8b 04 c5 44 1a 19 80 	mov    -0x7fe6e5bc(,%eax,8),%eax
8010208b:	8b 55 14             	mov    0x14(%ebp),%edx
8010208e:	83 ec 04             	sub    $0x4,%esp
80102091:	52                   	push   %edx
80102092:	ff 75 0c             	push   0xc(%ebp)
80102095:	ff 75 08             	push   0x8(%ebp)
80102098:	ff d0                	call   *%eax
8010209a:	83 c4 10             	add    $0x10,%esp
8010209d:	e9 15 01 00 00       	jmp    801021b7 <writei+0x184>
  }

  if(off > ip->size || off + n < off)
801020a2:	8b 45 08             	mov    0x8(%ebp),%eax
801020a5:	8b 40 58             	mov    0x58(%eax),%eax
801020a8:	3b 45 10             	cmp    0x10(%ebp),%eax
801020ab:	72 0d                	jb     801020ba <writei+0x87>
801020ad:	8b 55 10             	mov    0x10(%ebp),%edx
801020b0:	8b 45 14             	mov    0x14(%ebp),%eax
801020b3:	01 d0                	add    %edx,%eax
801020b5:	3b 45 10             	cmp    0x10(%ebp),%eax
801020b8:	73 0a                	jae    801020c4 <writei+0x91>
    return -1;
801020ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020bf:	e9 f3 00 00 00       	jmp    801021b7 <writei+0x184>
  if(off + n > MAXFILE*BSIZE)
801020c4:	8b 55 10             	mov    0x10(%ebp),%edx
801020c7:	8b 45 14             	mov    0x14(%ebp),%eax
801020ca:	01 d0                	add    %edx,%eax
801020cc:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020d1:	76 0a                	jbe    801020dd <writei+0xaa>
    return -1;
801020d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d8:	e9 da 00 00 00       	jmp    801021b7 <writei+0x184>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020e4:	e9 97 00 00 00       	jmp    80102180 <writei+0x14d>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020e9:	8b 45 10             	mov    0x10(%ebp),%eax
801020ec:	c1 e8 09             	shr    $0x9,%eax
801020ef:	83 ec 08             	sub    $0x8,%esp
801020f2:	50                   	push   %eax
801020f3:	ff 75 08             	push   0x8(%ebp)
801020f6:	e8 4d fb ff ff       	call   80101c48 <bmap>
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	8b 55 08             	mov    0x8(%ebp),%edx
80102101:	8b 12                	mov    (%edx),%edx
80102103:	83 ec 08             	sub    $0x8,%esp
80102106:	50                   	push   %eax
80102107:	52                   	push   %edx
80102108:	e8 f4 e0 ff ff       	call   80100201 <bread>
8010210d:	83 c4 10             	add    $0x10,%esp
80102110:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102113:	8b 45 10             	mov    0x10(%ebp),%eax
80102116:	25 ff 01 00 00       	and    $0x1ff,%eax
8010211b:	ba 00 02 00 00       	mov    $0x200,%edx
80102120:	29 c2                	sub    %eax,%edx
80102122:	8b 45 14             	mov    0x14(%ebp),%eax
80102125:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102128:	39 c2                	cmp    %eax,%edx
8010212a:	0f 46 c2             	cmovbe %edx,%eax
8010212d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102130:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102133:	8d 50 5c             	lea    0x5c(%eax),%edx
80102136:	8b 45 10             	mov    0x10(%ebp),%eax
80102139:	25 ff 01 00 00       	and    $0x1ff,%eax
8010213e:	01 d0                	add    %edx,%eax
80102140:	83 ec 04             	sub    $0x4,%esp
80102143:	ff 75 ec             	push   -0x14(%ebp)
80102146:	ff 75 0c             	push   0xc(%ebp)
80102149:	50                   	push   %eax
8010214a:	e8 38 2b 00 00       	call   80104c87 <memmove>
8010214f:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102152:	83 ec 0c             	sub    $0xc,%esp
80102155:	ff 75 f0             	push   -0x10(%ebp)
80102158:	e8 1a 11 00 00       	call   80103277 <log_write>
8010215d:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	ff 75 f0             	push   -0x10(%ebp)
80102166:	e8 18 e1 ff ff       	call   80100283 <brelse>
8010216b:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010216e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102171:	01 45 f4             	add    %eax,-0xc(%ebp)
80102174:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102177:	01 45 10             	add    %eax,0x10(%ebp)
8010217a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010217d:	01 45 0c             	add    %eax,0xc(%ebp)
80102180:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102183:	3b 45 14             	cmp    0x14(%ebp),%eax
80102186:	0f 82 5d ff ff ff    	jb     801020e9 <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
8010218c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102190:	74 22                	je     801021b4 <writei+0x181>
80102192:	8b 45 08             	mov    0x8(%ebp),%eax
80102195:	8b 40 58             	mov    0x58(%eax),%eax
80102198:	3b 45 10             	cmp    0x10(%ebp),%eax
8010219b:	73 17                	jae    801021b4 <writei+0x181>
    ip->size = off;
8010219d:	8b 45 08             	mov    0x8(%ebp),%eax
801021a0:	8b 55 10             	mov    0x10(%ebp),%edx
801021a3:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801021a6:	83 ec 0c             	sub    $0xc,%esp
801021a9:	ff 75 08             	push   0x8(%ebp)
801021ac:	e8 64 f6 ff ff       	call   80101815 <iupdate>
801021b1:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801021b4:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021b7:	c9                   	leave
801021b8:	c3                   	ret

801021b9 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021b9:	55                   	push   %ebp
801021ba:	89 e5                	mov    %esp,%ebp
801021bc:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801021bf:	83 ec 04             	sub    $0x4,%esp
801021c2:	6a 0e                	push   $0xe
801021c4:	ff 75 0c             	push   0xc(%ebp)
801021c7:	ff 75 08             	push   0x8(%ebp)
801021ca:	e8 4e 2b 00 00       	call   80104d1d <strncmp>
801021cf:	83 c4 10             	add    $0x10,%esp
}
801021d2:	c9                   	leave
801021d3:	c3                   	ret

801021d4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021d4:	55                   	push   %ebp
801021d5:	89 e5                	mov    %esp,%ebp
801021d7:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021da:	8b 45 08             	mov    0x8(%ebp),%eax
801021dd:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801021e1:	66 83 f8 01          	cmp    $0x1,%ax
801021e5:	74 0d                	je     801021f4 <dirlookup+0x20>
    panic("dirlookup not DIR");
801021e7:	83 ec 0c             	sub    $0xc,%esp
801021ea:	68 dd a3 10 80       	push   $0x8010a3dd
801021ef:	e8 b5 e3 ff ff       	call   801005a9 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021fb:	eb 7b                	jmp    80102278 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021fd:	6a 10                	push   $0x10
801021ff:	ff 75 f4             	push   -0xc(%ebp)
80102202:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102205:	50                   	push   %eax
80102206:	ff 75 08             	push   0x8(%ebp)
80102209:	e8 d0 fc ff ff       	call   80101ede <readi>
8010220e:	83 c4 10             	add    $0x10,%esp
80102211:	83 f8 10             	cmp    $0x10,%eax
80102214:	74 0d                	je     80102223 <dirlookup+0x4f>
      panic("dirlookup read");
80102216:	83 ec 0c             	sub    $0xc,%esp
80102219:	68 ef a3 10 80       	push   $0x8010a3ef
8010221e:	e8 86 e3 ff ff       	call   801005a9 <panic>
    if(de.inum == 0)
80102223:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102227:	66 85 c0             	test   %ax,%ax
8010222a:	74 47                	je     80102273 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
8010222c:	83 ec 08             	sub    $0x8,%esp
8010222f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102232:	83 c0 02             	add    $0x2,%eax
80102235:	50                   	push   %eax
80102236:	ff 75 0c             	push   0xc(%ebp)
80102239:	e8 7b ff ff ff       	call   801021b9 <namecmp>
8010223e:	83 c4 10             	add    $0x10,%esp
80102241:	85 c0                	test   %eax,%eax
80102243:	75 2f                	jne    80102274 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102245:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102249:	74 08                	je     80102253 <dirlookup+0x7f>
        *poff = off;
8010224b:	8b 45 10             	mov    0x10(%ebp),%eax
8010224e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102251:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102253:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102257:	0f b7 c0             	movzwl %ax,%eax
8010225a:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010225d:	8b 45 08             	mov    0x8(%ebp),%eax
80102260:	8b 00                	mov    (%eax),%eax
80102262:	83 ec 08             	sub    $0x8,%esp
80102265:	ff 75 f0             	push   -0x10(%ebp)
80102268:	50                   	push   %eax
80102269:	e8 68 f6 ff ff       	call   801018d6 <iget>
8010226e:	83 c4 10             	add    $0x10,%esp
80102271:	eb 19                	jmp    8010228c <dirlookup+0xb8>
      continue;
80102273:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
80102274:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102278:	8b 45 08             	mov    0x8(%ebp),%eax
8010227b:	8b 40 58             	mov    0x58(%eax),%eax
8010227e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102281:	0f 82 76 ff ff ff    	jb     801021fd <dirlookup+0x29>
    }
  }

  return 0;
80102287:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010228c:	c9                   	leave
8010228d:	c3                   	ret

8010228e <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010228e:	55                   	push   %ebp
8010228f:	89 e5                	mov    %esp,%ebp
80102291:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102294:	83 ec 04             	sub    $0x4,%esp
80102297:	6a 00                	push   $0x0
80102299:	ff 75 0c             	push   0xc(%ebp)
8010229c:	ff 75 08             	push   0x8(%ebp)
8010229f:	e8 30 ff ff ff       	call   801021d4 <dirlookup>
801022a4:	83 c4 10             	add    $0x10,%esp
801022a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022ae:	74 18                	je     801022c8 <dirlink+0x3a>
    iput(ip);
801022b0:	83 ec 0c             	sub    $0xc,%esp
801022b3:	ff 75 f0             	push   -0x10(%ebp)
801022b6:	e8 98 f8 ff ff       	call   80101b53 <iput>
801022bb:	83 c4 10             	add    $0x10,%esp
    return -1;
801022be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022c3:	e9 9c 00 00 00       	jmp    80102364 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022cf:	eb 39                	jmp    8010230a <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022d4:	6a 10                	push   $0x10
801022d6:	50                   	push   %eax
801022d7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022da:	50                   	push   %eax
801022db:	ff 75 08             	push   0x8(%ebp)
801022de:	e8 fb fb ff ff       	call   80101ede <readi>
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	83 f8 10             	cmp    $0x10,%eax
801022e9:	74 0d                	je     801022f8 <dirlink+0x6a>
      panic("dirlink read");
801022eb:	83 ec 0c             	sub    $0xc,%esp
801022ee:	68 fe a3 10 80       	push   $0x8010a3fe
801022f3:	e8 b1 e2 ff ff       	call   801005a9 <panic>
    if(de.inum == 0)
801022f8:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022fc:	66 85 c0             	test   %ax,%ax
801022ff:	74 18                	je     80102319 <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102304:	83 c0 10             	add    $0x10,%eax
80102307:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010230a:	8b 45 08             	mov    0x8(%ebp),%eax
8010230d:	8b 40 58             	mov    0x58(%eax),%eax
80102310:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102313:	39 c2                	cmp    %eax,%edx
80102315:	72 ba                	jb     801022d1 <dirlink+0x43>
80102317:	eb 01                	jmp    8010231a <dirlink+0x8c>
      break;
80102319:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
8010231a:	83 ec 04             	sub    $0x4,%esp
8010231d:	6a 0e                	push   $0xe
8010231f:	ff 75 0c             	push   0xc(%ebp)
80102322:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102325:	83 c0 02             	add    $0x2,%eax
80102328:	50                   	push   %eax
80102329:	e8 45 2a 00 00       	call   80104d73 <strncpy>
8010232e:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102331:	8b 45 10             	mov    0x10(%ebp),%eax
80102334:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010233b:	6a 10                	push   $0x10
8010233d:	50                   	push   %eax
8010233e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102341:	50                   	push   %eax
80102342:	ff 75 08             	push   0x8(%ebp)
80102345:	e8 e9 fc ff ff       	call   80102033 <writei>
8010234a:	83 c4 10             	add    $0x10,%esp
8010234d:	83 f8 10             	cmp    $0x10,%eax
80102350:	74 0d                	je     8010235f <dirlink+0xd1>
    panic("dirlink");
80102352:	83 ec 0c             	sub    $0xc,%esp
80102355:	68 0b a4 10 80       	push   $0x8010a40b
8010235a:	e8 4a e2 ff ff       	call   801005a9 <panic>

  return 0;
8010235f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102364:	c9                   	leave
80102365:	c3                   	ret

80102366 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102366:	55                   	push   %ebp
80102367:	89 e5                	mov    %esp,%ebp
80102369:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010236c:	eb 04                	jmp    80102372 <skipelem+0xc>
    path++;
8010236e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102372:	8b 45 08             	mov    0x8(%ebp),%eax
80102375:	0f b6 00             	movzbl (%eax),%eax
80102378:	3c 2f                	cmp    $0x2f,%al
8010237a:	74 f2                	je     8010236e <skipelem+0x8>
  if(*path == 0)
8010237c:	8b 45 08             	mov    0x8(%ebp),%eax
8010237f:	0f b6 00             	movzbl (%eax),%eax
80102382:	84 c0                	test   %al,%al
80102384:	75 07                	jne    8010238d <skipelem+0x27>
    return 0;
80102386:	b8 00 00 00 00       	mov    $0x0,%eax
8010238b:	eb 77                	jmp    80102404 <skipelem+0x9e>
  s = path;
8010238d:	8b 45 08             	mov    0x8(%ebp),%eax
80102390:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102393:	eb 04                	jmp    80102399 <skipelem+0x33>
    path++;
80102395:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
80102399:	8b 45 08             	mov    0x8(%ebp),%eax
8010239c:	0f b6 00             	movzbl (%eax),%eax
8010239f:	3c 2f                	cmp    $0x2f,%al
801023a1:	74 0a                	je     801023ad <skipelem+0x47>
801023a3:	8b 45 08             	mov    0x8(%ebp),%eax
801023a6:	0f b6 00             	movzbl (%eax),%eax
801023a9:	84 c0                	test   %al,%al
801023ab:	75 e8                	jne    80102395 <skipelem+0x2f>
  len = path - s;
801023ad:	8b 45 08             	mov    0x8(%ebp),%eax
801023b0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801023b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023b6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023ba:	7e 15                	jle    801023d1 <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
801023bc:	83 ec 04             	sub    $0x4,%esp
801023bf:	6a 0e                	push   $0xe
801023c1:	ff 75 f4             	push   -0xc(%ebp)
801023c4:	ff 75 0c             	push   0xc(%ebp)
801023c7:	e8 bb 28 00 00       	call   80104c87 <memmove>
801023cc:	83 c4 10             	add    $0x10,%esp
801023cf:	eb 26                	jmp    801023f7 <skipelem+0x91>
  else {
    memmove(name, s, len);
801023d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023d4:	83 ec 04             	sub    $0x4,%esp
801023d7:	50                   	push   %eax
801023d8:	ff 75 f4             	push   -0xc(%ebp)
801023db:	ff 75 0c             	push   0xc(%ebp)
801023de:	e8 a4 28 00 00       	call   80104c87 <memmove>
801023e3:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801023e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801023ec:	01 d0                	add    %edx,%eax
801023ee:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023f1:	eb 04                	jmp    801023f7 <skipelem+0x91>
    path++;
801023f3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801023f7:	8b 45 08             	mov    0x8(%ebp),%eax
801023fa:	0f b6 00             	movzbl (%eax),%eax
801023fd:	3c 2f                	cmp    $0x2f,%al
801023ff:	74 f2                	je     801023f3 <skipelem+0x8d>
  return path;
80102401:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102404:	c9                   	leave
80102405:	c3                   	ret

80102406 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102406:	55                   	push   %ebp
80102407:	89 e5                	mov    %esp,%ebp
80102409:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010240c:	8b 45 08             	mov    0x8(%ebp),%eax
8010240f:	0f b6 00             	movzbl (%eax),%eax
80102412:	3c 2f                	cmp    $0x2f,%al
80102414:	75 17                	jne    8010242d <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102416:	83 ec 08             	sub    $0x8,%esp
80102419:	6a 01                	push   $0x1
8010241b:	6a 01                	push   $0x1
8010241d:	e8 b4 f4 ff ff       	call   801018d6 <iget>
80102422:	83 c4 10             	add    $0x10,%esp
80102425:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102428:	e9 ba 00 00 00       	jmp    801024e7 <namex+0xe1>
  else
    ip = idup(myproc()->cwd);
8010242d:	e8 fe 15 00 00       	call   80103a30 <myproc>
80102432:	8b 40 68             	mov    0x68(%eax),%eax
80102435:	83 ec 0c             	sub    $0xc,%esp
80102438:	50                   	push   %eax
80102439:	e8 7a f5 ff ff       	call   801019b8 <idup>
8010243e:	83 c4 10             	add    $0x10,%esp
80102441:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102444:	e9 9e 00 00 00       	jmp    801024e7 <namex+0xe1>
    ilock(ip);
80102449:	83 ec 0c             	sub    $0xc,%esp
8010244c:	ff 75 f4             	push   -0xc(%ebp)
8010244f:	e8 9e f5 ff ff       	call   801019f2 <ilock>
80102454:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010245a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010245e:	66 83 f8 01          	cmp    $0x1,%ax
80102462:	74 18                	je     8010247c <namex+0x76>
      iunlockput(ip);
80102464:	83 ec 0c             	sub    $0xc,%esp
80102467:	ff 75 f4             	push   -0xc(%ebp)
8010246a:	e8 b4 f7 ff ff       	call   80101c23 <iunlockput>
8010246f:	83 c4 10             	add    $0x10,%esp
      return 0;
80102472:	b8 00 00 00 00       	mov    $0x0,%eax
80102477:	e9 a7 00 00 00       	jmp    80102523 <namex+0x11d>
    }
    if(nameiparent && *path == '\0'){
8010247c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102480:	74 20                	je     801024a2 <namex+0x9c>
80102482:	8b 45 08             	mov    0x8(%ebp),%eax
80102485:	0f b6 00             	movzbl (%eax),%eax
80102488:	84 c0                	test   %al,%al
8010248a:	75 16                	jne    801024a2 <namex+0x9c>
      // Stop one level early.
      iunlock(ip);
8010248c:	83 ec 0c             	sub    $0xc,%esp
8010248f:	ff 75 f4             	push   -0xc(%ebp)
80102492:	e8 6e f6 ff ff       	call   80101b05 <iunlock>
80102497:	83 c4 10             	add    $0x10,%esp
      return ip;
8010249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010249d:	e9 81 00 00 00       	jmp    80102523 <namex+0x11d>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024a2:	83 ec 04             	sub    $0x4,%esp
801024a5:	6a 00                	push   $0x0
801024a7:	ff 75 10             	push   0x10(%ebp)
801024aa:	ff 75 f4             	push   -0xc(%ebp)
801024ad:	e8 22 fd ff ff       	call   801021d4 <dirlookup>
801024b2:	83 c4 10             	add    $0x10,%esp
801024b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024bc:	75 15                	jne    801024d3 <namex+0xcd>
      iunlockput(ip);
801024be:	83 ec 0c             	sub    $0xc,%esp
801024c1:	ff 75 f4             	push   -0xc(%ebp)
801024c4:	e8 5a f7 ff ff       	call   80101c23 <iunlockput>
801024c9:	83 c4 10             	add    $0x10,%esp
      return 0;
801024cc:	b8 00 00 00 00       	mov    $0x0,%eax
801024d1:	eb 50                	jmp    80102523 <namex+0x11d>
    }
    iunlockput(ip);
801024d3:	83 ec 0c             	sub    $0xc,%esp
801024d6:	ff 75 f4             	push   -0xc(%ebp)
801024d9:	e8 45 f7 ff ff       	call   80101c23 <iunlockput>
801024de:	83 c4 10             	add    $0x10,%esp
    ip = next;
801024e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
801024e7:	83 ec 08             	sub    $0x8,%esp
801024ea:	ff 75 10             	push   0x10(%ebp)
801024ed:	ff 75 08             	push   0x8(%ebp)
801024f0:	e8 71 fe ff ff       	call   80102366 <skipelem>
801024f5:	83 c4 10             	add    $0x10,%esp
801024f8:	89 45 08             	mov    %eax,0x8(%ebp)
801024fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024ff:	0f 85 44 ff ff ff    	jne    80102449 <namex+0x43>
  }
  if(nameiparent){
80102505:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102509:	74 15                	je     80102520 <namex+0x11a>
    iput(ip);
8010250b:	83 ec 0c             	sub    $0xc,%esp
8010250e:	ff 75 f4             	push   -0xc(%ebp)
80102511:	e8 3d f6 ff ff       	call   80101b53 <iput>
80102516:	83 c4 10             	add    $0x10,%esp
    return 0;
80102519:	b8 00 00 00 00       	mov    $0x0,%eax
8010251e:	eb 03                	jmp    80102523 <namex+0x11d>
  }
  return ip;
80102520:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102523:	c9                   	leave
80102524:	c3                   	ret

80102525 <namei>:

struct inode*
namei(char *path)
{
80102525:	55                   	push   %ebp
80102526:	89 e5                	mov    %esp,%ebp
80102528:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010252b:	83 ec 04             	sub    $0x4,%esp
8010252e:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102531:	50                   	push   %eax
80102532:	6a 00                	push   $0x0
80102534:	ff 75 08             	push   0x8(%ebp)
80102537:	e8 ca fe ff ff       	call   80102406 <namex>
8010253c:	83 c4 10             	add    $0x10,%esp
}
8010253f:	c9                   	leave
80102540:	c3                   	ret

80102541 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102541:	55                   	push   %ebp
80102542:	89 e5                	mov    %esp,%ebp
80102544:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102547:	83 ec 04             	sub    $0x4,%esp
8010254a:	ff 75 0c             	push   0xc(%ebp)
8010254d:	6a 01                	push   $0x1
8010254f:	ff 75 08             	push   0x8(%ebp)
80102552:	e8 af fe ff ff       	call   80102406 <namex>
80102557:	83 c4 10             	add    $0x10,%esp
}
8010255a:	c9                   	leave
8010255b:	c3                   	ret

8010255c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010255c:	55                   	push   %ebp
8010255d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010255f:	a1 b4 40 19 80       	mov    0x801940b4,%eax
80102564:	8b 55 08             	mov    0x8(%ebp),%edx
80102567:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102569:	a1 b4 40 19 80       	mov    0x801940b4,%eax
8010256e:	8b 40 10             	mov    0x10(%eax),%eax
}
80102571:	5d                   	pop    %ebp
80102572:	c3                   	ret

80102573 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102573:	55                   	push   %ebp
80102574:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102576:	a1 b4 40 19 80       	mov    0x801940b4,%eax
8010257b:	8b 55 08             	mov    0x8(%ebp),%edx
8010257e:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102580:	a1 b4 40 19 80       	mov    0x801940b4,%eax
80102585:	8b 55 0c             	mov    0xc(%ebp),%edx
80102588:	89 50 10             	mov    %edx,0x10(%eax)
}
8010258b:	90                   	nop
8010258c:	5d                   	pop    %ebp
8010258d:	c3                   	ret

8010258e <ioapicinit>:

void
ioapicinit(void)
{
8010258e:	55                   	push   %ebp
8010258f:	89 e5                	mov    %esp,%ebp
80102591:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102594:	c7 05 b4 40 19 80 00 	movl   $0xfec00000,0x801940b4
8010259b:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010259e:	6a 01                	push   $0x1
801025a0:	e8 b7 ff ff ff       	call   8010255c <ioapicread>
801025a5:	83 c4 04             	add    $0x4,%esp
801025a8:	c1 e8 10             	shr    $0x10,%eax
801025ab:	25 ff 00 00 00       	and    $0xff,%eax
801025b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801025b3:	6a 00                	push   $0x0
801025b5:	e8 a2 ff ff ff       	call   8010255c <ioapicread>
801025ba:	83 c4 04             	add    $0x4,%esp
801025bd:	c1 e8 18             	shr    $0x18,%eax
801025c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801025c3:	0f b6 05 44 6d 19 80 	movzbl 0x80196d44,%eax
801025ca:	0f b6 c0             	movzbl %al,%eax
801025cd:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801025d0:	74 10                	je     801025e2 <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025d2:	83 ec 0c             	sub    $0xc,%esp
801025d5:	68 14 a4 10 80       	push   $0x8010a414
801025da:	e8 15 de ff ff       	call   801003f4 <cprintf>
801025df:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801025e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025e9:	eb 3f                	jmp    8010262a <ioapicinit+0x9c>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025ee:	83 c0 20             	add    $0x20,%eax
801025f1:	0d 00 00 01 00       	or     $0x10000,%eax
801025f6:	89 c2                	mov    %eax,%edx
801025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025fb:	83 c0 08             	add    $0x8,%eax
801025fe:	01 c0                	add    %eax,%eax
80102600:	83 ec 08             	sub    $0x8,%esp
80102603:	52                   	push   %edx
80102604:	50                   	push   %eax
80102605:	e8 69 ff ff ff       	call   80102573 <ioapicwrite>
8010260a:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
8010260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102610:	83 c0 08             	add    $0x8,%eax
80102613:	01 c0                	add    %eax,%eax
80102615:	83 c0 01             	add    $0x1,%eax
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	6a 00                	push   $0x0
8010261d:	50                   	push   %eax
8010261e:	e8 50 ff ff ff       	call   80102573 <ioapicwrite>
80102623:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102626:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010262d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102630:	7e b9                	jle    801025eb <ioapicinit+0x5d>
  }
}
80102632:	90                   	nop
80102633:	90                   	nop
80102634:	c9                   	leave
80102635:	c3                   	ret

80102636 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102636:	55                   	push   %ebp
80102637:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102639:	8b 45 08             	mov    0x8(%ebp),%eax
8010263c:	83 c0 20             	add    $0x20,%eax
8010263f:	89 c2                	mov    %eax,%edx
80102641:	8b 45 08             	mov    0x8(%ebp),%eax
80102644:	83 c0 08             	add    $0x8,%eax
80102647:	01 c0                	add    %eax,%eax
80102649:	52                   	push   %edx
8010264a:	50                   	push   %eax
8010264b:	e8 23 ff ff ff       	call   80102573 <ioapicwrite>
80102650:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102653:	8b 45 0c             	mov    0xc(%ebp),%eax
80102656:	c1 e0 18             	shl    $0x18,%eax
80102659:	89 c2                	mov    %eax,%edx
8010265b:	8b 45 08             	mov    0x8(%ebp),%eax
8010265e:	83 c0 08             	add    $0x8,%eax
80102661:	01 c0                	add    %eax,%eax
80102663:	83 c0 01             	add    $0x1,%eax
80102666:	52                   	push   %edx
80102667:	50                   	push   %eax
80102668:	e8 06 ff ff ff       	call   80102573 <ioapicwrite>
8010266d:	83 c4 08             	add    $0x8,%esp
}
80102670:	90                   	nop
80102671:	c9                   	leave
80102672:	c3                   	ret

80102673 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102673:	55                   	push   %ebp
80102674:	89 e5                	mov    %esp,%ebp
80102676:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102679:	83 ec 08             	sub    $0x8,%esp
8010267c:	68 46 a4 10 80       	push   $0x8010a446
80102681:	68 c0 40 19 80       	push   $0x801940c0
80102686:	e8 a5 22 00 00       	call   80104930 <initlock>
8010268b:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
8010268e:	c7 05 f4 40 19 80 00 	movl   $0x0,0x801940f4
80102695:	00 00 00 
  freerange(vstart, vend);
80102698:	83 ec 08             	sub    $0x8,%esp
8010269b:	ff 75 0c             	push   0xc(%ebp)
8010269e:	ff 75 08             	push   0x8(%ebp)
801026a1:	e8 2a 00 00 00       	call   801026d0 <freerange>
801026a6:	83 c4 10             	add    $0x10,%esp
}
801026a9:	90                   	nop
801026aa:	c9                   	leave
801026ab:	c3                   	ret

801026ac <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801026ac:	55                   	push   %ebp
801026ad:	89 e5                	mov    %esp,%ebp
801026af:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
801026b2:	83 ec 08             	sub    $0x8,%esp
801026b5:	ff 75 0c             	push   0xc(%ebp)
801026b8:	ff 75 08             	push   0x8(%ebp)
801026bb:	e8 10 00 00 00       	call   801026d0 <freerange>
801026c0:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
801026c3:	c7 05 f4 40 19 80 01 	movl   $0x1,0x801940f4
801026ca:	00 00 00 
}
801026cd:	90                   	nop
801026ce:	c9                   	leave
801026cf:	c3                   	ret

801026d0 <freerange>:

void
freerange(void *vstart, void *vend)
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801026d6:	8b 45 08             	mov    0x8(%ebp),%eax
801026d9:	05 ff 0f 00 00       	add    $0xfff,%eax
801026de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801026e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e6:	eb 15                	jmp    801026fd <freerange+0x2d>
    kfree(p);
801026e8:	83 ec 0c             	sub    $0xc,%esp
801026eb:	ff 75 f4             	push   -0xc(%ebp)
801026ee:	e8 1b 00 00 00       	call   8010270e <kfree>
801026f3:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102700:	05 00 10 00 00       	add    $0x1000,%eax
80102705:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102708:	73 de                	jae    801026e8 <freerange+0x18>
}
8010270a:	90                   	nop
8010270b:	90                   	nop
8010270c:	c9                   	leave
8010270d:	c3                   	ret

8010270e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
8010270e:	55                   	push   %ebp
8010270f:	89 e5                	mov    %esp,%ebp
80102711:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102714:	8b 45 08             	mov    0x8(%ebp),%eax
80102717:	25 ff 0f 00 00       	and    $0xfff,%eax
8010271c:	85 c0                	test   %eax,%eax
8010271e:	75 18                	jne    80102738 <kfree+0x2a>
80102720:	81 7d 08 00 90 19 80 	cmpl   $0x80199000,0x8(%ebp)
80102727:	72 0f                	jb     80102738 <kfree+0x2a>
80102729:	8b 45 08             	mov    0x8(%ebp),%eax
8010272c:	05 00 00 00 80       	add    $0x80000000,%eax
80102731:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
80102736:	76 0d                	jbe    80102745 <kfree+0x37>
    panic("kfree");
80102738:	83 ec 0c             	sub    $0xc,%esp
8010273b:	68 4b a4 10 80       	push   $0x8010a44b
80102740:	e8 64 de ff ff       	call   801005a9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102745:	83 ec 04             	sub    $0x4,%esp
80102748:	68 00 10 00 00       	push   $0x1000
8010274d:	6a 01                	push   $0x1
8010274f:	ff 75 08             	push   0x8(%ebp)
80102752:	e8 71 24 00 00       	call   80104bc8 <memset>
80102757:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
8010275a:	a1 f4 40 19 80       	mov    0x801940f4,%eax
8010275f:	85 c0                	test   %eax,%eax
80102761:	74 10                	je     80102773 <kfree+0x65>
    acquire(&kmem.lock);
80102763:	83 ec 0c             	sub    $0xc,%esp
80102766:	68 c0 40 19 80       	push   $0x801940c0
8010276b:	e8 e2 21 00 00       	call   80104952 <acquire>
80102770:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102773:	8b 45 08             	mov    0x8(%ebp),%eax
80102776:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102779:	8b 15 f8 40 19 80    	mov    0x801940f8,%edx
8010277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102782:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102787:	a3 f8 40 19 80       	mov    %eax,0x801940f8
  if(kmem.use_lock)
8010278c:	a1 f4 40 19 80       	mov    0x801940f4,%eax
80102791:	85 c0                	test   %eax,%eax
80102793:	74 10                	je     801027a5 <kfree+0x97>
    release(&kmem.lock);
80102795:	83 ec 0c             	sub    $0xc,%esp
80102798:	68 c0 40 19 80       	push   $0x801940c0
8010279d:	e8 1e 22 00 00       	call   801049c0 <release>
801027a2:	83 c4 10             	add    $0x10,%esp
}
801027a5:	90                   	nop
801027a6:	c9                   	leave
801027a7:	c3                   	ret

801027a8 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801027a8:	55                   	push   %ebp
801027a9:	89 e5                	mov    %esp,%ebp
801027ab:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
801027ae:	a1 f4 40 19 80       	mov    0x801940f4,%eax
801027b3:	85 c0                	test   %eax,%eax
801027b5:	74 10                	je     801027c7 <kalloc+0x1f>
    acquire(&kmem.lock);
801027b7:	83 ec 0c             	sub    $0xc,%esp
801027ba:	68 c0 40 19 80       	push   $0x801940c0
801027bf:	e8 8e 21 00 00       	call   80104952 <acquire>
801027c4:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
801027c7:	a1 f8 40 19 80       	mov    0x801940f8,%eax
801027cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
801027cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027d3:	74 0a                	je     801027df <kalloc+0x37>
    kmem.freelist = r->next;
801027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d8:	8b 00                	mov    (%eax),%eax
801027da:	a3 f8 40 19 80       	mov    %eax,0x801940f8
  if(kmem.use_lock)
801027df:	a1 f4 40 19 80       	mov    0x801940f4,%eax
801027e4:	85 c0                	test   %eax,%eax
801027e6:	74 10                	je     801027f8 <kalloc+0x50>
    release(&kmem.lock);
801027e8:	83 ec 0c             	sub    $0xc,%esp
801027eb:	68 c0 40 19 80       	push   $0x801940c0
801027f0:	e8 cb 21 00 00       	call   801049c0 <release>
801027f5:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801027fb:	c9                   	leave
801027fc:	c3                   	ret

801027fd <inb>:
{
801027fd:	55                   	push   %ebp
801027fe:	89 e5                	mov    %esp,%ebp
80102800:	83 ec 14             	sub    $0x14,%esp
80102803:	8b 45 08             	mov    0x8(%ebp),%eax
80102806:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010280a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010280e:	89 c2                	mov    %eax,%edx
80102810:	ec                   	in     (%dx),%al
80102811:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102814:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102818:	c9                   	leave
80102819:	c3                   	ret

8010281a <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
8010281a:	55                   	push   %ebp
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102820:	6a 64                	push   $0x64
80102822:	e8 d6 ff ff ff       	call   801027fd <inb>
80102827:	83 c4 04             	add    $0x4,%esp
8010282a:	0f b6 c0             	movzbl %al,%eax
8010282d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102830:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102833:	83 e0 01             	and    $0x1,%eax
80102836:	85 c0                	test   %eax,%eax
80102838:	75 0a                	jne    80102844 <kbdgetc+0x2a>
    return -1;
8010283a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010283f:	e9 23 01 00 00       	jmp    80102967 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102844:	6a 60                	push   $0x60
80102846:	e8 b2 ff ff ff       	call   801027fd <inb>
8010284b:	83 c4 04             	add    $0x4,%esp
8010284e:	0f b6 c0             	movzbl %al,%eax
80102851:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102854:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
8010285b:	75 17                	jne    80102874 <kbdgetc+0x5a>
    shift |= E0ESC;
8010285d:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102862:	83 c8 40             	or     $0x40,%eax
80102865:	a3 fc 40 19 80       	mov    %eax,0x801940fc
    return 0;
8010286a:	b8 00 00 00 00       	mov    $0x0,%eax
8010286f:	e9 f3 00 00 00       	jmp    80102967 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102874:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102877:	25 80 00 00 00       	and    $0x80,%eax
8010287c:	85 c0                	test   %eax,%eax
8010287e:	74 45                	je     801028c5 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102880:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102885:	83 e0 40             	and    $0x40,%eax
80102888:	85 c0                	test   %eax,%eax
8010288a:	75 08                	jne    80102894 <kbdgetc+0x7a>
8010288c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010288f:	83 e0 7f             	and    $0x7f,%eax
80102892:	eb 03                	jmp    80102897 <kbdgetc+0x7d>
80102894:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102897:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
8010289a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010289d:	05 20 d0 10 80       	add    $0x8010d020,%eax
801028a2:	0f b6 00             	movzbl (%eax),%eax
801028a5:	83 c8 40             	or     $0x40,%eax
801028a8:	0f b6 c0             	movzbl %al,%eax
801028ab:	f7 d0                	not    %eax
801028ad:	89 c2                	mov    %eax,%edx
801028af:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028b4:	21 d0                	and    %edx,%eax
801028b6:	a3 fc 40 19 80       	mov    %eax,0x801940fc
    return 0;
801028bb:	b8 00 00 00 00       	mov    $0x0,%eax
801028c0:	e9 a2 00 00 00       	jmp    80102967 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
801028c5:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028ca:	83 e0 40             	and    $0x40,%eax
801028cd:	85 c0                	test   %eax,%eax
801028cf:	74 14                	je     801028e5 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028d1:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
801028d8:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028dd:	83 e0 bf             	and    $0xffffffbf,%eax
801028e0:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  }

  shift |= shiftcode[data];
801028e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028e8:	05 20 d0 10 80       	add    $0x8010d020,%eax
801028ed:	0f b6 00             	movzbl (%eax),%eax
801028f0:	0f b6 d0             	movzbl %al,%edx
801028f3:	a1 fc 40 19 80       	mov    0x801940fc,%eax
801028f8:	09 d0                	or     %edx,%eax
801028fa:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  shift ^= togglecode[data];
801028ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102902:	05 20 d1 10 80       	add    $0x8010d120,%eax
80102907:	0f b6 00             	movzbl (%eax),%eax
8010290a:	0f b6 d0             	movzbl %al,%edx
8010290d:	a1 fc 40 19 80       	mov    0x801940fc,%eax
80102912:	31 d0                	xor    %edx,%eax
80102914:	a3 fc 40 19 80       	mov    %eax,0x801940fc
  c = charcode[shift & (CTL | SHIFT)][data];
80102919:	a1 fc 40 19 80       	mov    0x801940fc,%eax
8010291e:	83 e0 03             	and    $0x3,%eax
80102921:	8b 14 85 20 d5 10 80 	mov    -0x7fef2ae0(,%eax,4),%edx
80102928:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010292b:	01 d0                	add    %edx,%eax
8010292d:	0f b6 00             	movzbl (%eax),%eax
80102930:	0f b6 c0             	movzbl %al,%eax
80102933:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102936:	a1 fc 40 19 80       	mov    0x801940fc,%eax
8010293b:	83 e0 08             	and    $0x8,%eax
8010293e:	85 c0                	test   %eax,%eax
80102940:	74 22                	je     80102964 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102942:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102946:	76 0c                	jbe    80102954 <kbdgetc+0x13a>
80102948:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
8010294c:	77 06                	ja     80102954 <kbdgetc+0x13a>
      c += 'A' - 'a';
8010294e:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102952:	eb 10                	jmp    80102964 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102954:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102958:	76 0a                	jbe    80102964 <kbdgetc+0x14a>
8010295a:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
8010295e:	77 04                	ja     80102964 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102960:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102964:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102967:	c9                   	leave
80102968:	c3                   	ret

80102969 <kbdintr>:

void
kbdintr(void)
{
80102969:	55                   	push   %ebp
8010296a:	89 e5                	mov    %esp,%ebp
8010296c:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
8010296f:	83 ec 0c             	sub    $0xc,%esp
80102972:	68 1a 28 10 80       	push   $0x8010281a
80102977:	e8 5a de ff ff       	call   801007d6 <consoleintr>
8010297c:	83 c4 10             	add    $0x10,%esp
}
8010297f:	90                   	nop
80102980:	c9                   	leave
80102981:	c3                   	ret

80102982 <inb>:
{
80102982:	55                   	push   %ebp
80102983:	89 e5                	mov    %esp,%ebp
80102985:	83 ec 14             	sub    $0x14,%esp
80102988:	8b 45 08             	mov    0x8(%ebp),%eax
8010298b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010298f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102993:	89 c2                	mov    %eax,%edx
80102995:	ec                   	in     (%dx),%al
80102996:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102999:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010299d:	c9                   	leave
8010299e:	c3                   	ret

8010299f <outb>:
{
8010299f:	55                   	push   %ebp
801029a0:	89 e5                	mov    %esp,%ebp
801029a2:	83 ec 08             	sub    $0x8,%esp
801029a5:	8b 55 08             	mov    0x8(%ebp),%edx
801029a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801029ab:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801029af:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801029b6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801029ba:	ee                   	out    %al,(%dx)
}
801029bb:	90                   	nop
801029bc:	c9                   	leave
801029bd:	c3                   	ret

801029be <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
801029be:	55                   	push   %ebp
801029bf:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801029c1:	a1 00 41 19 80       	mov    0x80194100,%eax
801029c6:	8b 55 08             	mov    0x8(%ebp),%edx
801029c9:	c1 e2 02             	shl    $0x2,%edx
801029cc:	01 c2                	add    %eax,%edx
801029ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801029d1:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
801029d3:	a1 00 41 19 80       	mov    0x80194100,%eax
801029d8:	83 c0 20             	add    $0x20,%eax
801029db:	8b 00                	mov    (%eax),%eax
}
801029dd:	90                   	nop
801029de:	5d                   	pop    %ebp
801029df:	c3                   	ret

801029e0 <lapicinit>:

void
lapicinit(void)
{
801029e0:	55                   	push   %ebp
801029e1:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029e3:	a1 00 41 19 80       	mov    0x80194100,%eax
801029e8:	85 c0                	test   %eax,%eax
801029ea:	0f 84 09 01 00 00    	je     80102af9 <lapicinit+0x119>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801029f0:	68 3f 01 00 00       	push   $0x13f
801029f5:	6a 3c                	push   $0x3c
801029f7:	e8 c2 ff ff ff       	call   801029be <lapicw>
801029fc:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
801029ff:	6a 0b                	push   $0xb
80102a01:	68 f8 00 00 00       	push   $0xf8
80102a06:	e8 b3 ff ff ff       	call   801029be <lapicw>
80102a0b:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102a0e:	68 20 00 02 00       	push   $0x20020
80102a13:	68 c8 00 00 00       	push   $0xc8
80102a18:	e8 a1 ff ff ff       	call   801029be <lapicw>
80102a1d:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
80102a20:	68 80 96 98 00       	push   $0x989680
80102a25:	68 e0 00 00 00       	push   $0xe0
80102a2a:	e8 8f ff ff ff       	call   801029be <lapicw>
80102a2f:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102a32:	68 00 00 01 00       	push   $0x10000
80102a37:	68 d4 00 00 00       	push   $0xd4
80102a3c:	e8 7d ff ff ff       	call   801029be <lapicw>
80102a41:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102a44:	68 00 00 01 00       	push   $0x10000
80102a49:	68 d8 00 00 00       	push   $0xd8
80102a4e:	e8 6b ff ff ff       	call   801029be <lapicw>
80102a53:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a56:	a1 00 41 19 80       	mov    0x80194100,%eax
80102a5b:	83 c0 30             	add    $0x30,%eax
80102a5e:	8b 00                	mov    (%eax),%eax
80102a60:	25 00 00 fc 00       	and    $0xfc0000,%eax
80102a65:	85 c0                	test   %eax,%eax
80102a67:	74 12                	je     80102a7b <lapicinit+0x9b>
    lapicw(PCINT, MASKED);
80102a69:	68 00 00 01 00       	push   $0x10000
80102a6e:	68 d0 00 00 00       	push   $0xd0
80102a73:	e8 46 ff ff ff       	call   801029be <lapicw>
80102a78:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102a7b:	6a 33                	push   $0x33
80102a7d:	68 dc 00 00 00       	push   $0xdc
80102a82:	e8 37 ff ff ff       	call   801029be <lapicw>
80102a87:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102a8a:	6a 00                	push   $0x0
80102a8c:	68 a0 00 00 00       	push   $0xa0
80102a91:	e8 28 ff ff ff       	call   801029be <lapicw>
80102a96:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102a99:	6a 00                	push   $0x0
80102a9b:	68 a0 00 00 00       	push   $0xa0
80102aa0:	e8 19 ff ff ff       	call   801029be <lapicw>
80102aa5:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102aa8:	6a 00                	push   $0x0
80102aaa:	6a 2c                	push   $0x2c
80102aac:	e8 0d ff ff ff       	call   801029be <lapicw>
80102ab1:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102ab4:	6a 00                	push   $0x0
80102ab6:	68 c4 00 00 00       	push   $0xc4
80102abb:	e8 fe fe ff ff       	call   801029be <lapicw>
80102ac0:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ac3:	68 00 85 08 00       	push   $0x88500
80102ac8:	68 c0 00 00 00       	push   $0xc0
80102acd:	e8 ec fe ff ff       	call   801029be <lapicw>
80102ad2:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102ad5:	90                   	nop
80102ad6:	a1 00 41 19 80       	mov    0x80194100,%eax
80102adb:	05 00 03 00 00       	add    $0x300,%eax
80102ae0:	8b 00                	mov    (%eax),%eax
80102ae2:	25 00 10 00 00       	and    $0x1000,%eax
80102ae7:	85 c0                	test   %eax,%eax
80102ae9:	75 eb                	jne    80102ad6 <lapicinit+0xf6>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102aeb:	6a 00                	push   $0x0
80102aed:	6a 20                	push   $0x20
80102aef:	e8 ca fe ff ff       	call   801029be <lapicw>
80102af4:	83 c4 08             	add    $0x8,%esp
80102af7:	eb 01                	jmp    80102afa <lapicinit+0x11a>
    return;
80102af9:	90                   	nop
}
80102afa:	c9                   	leave
80102afb:	c3                   	ret

80102afc <lapicid>:

int
lapicid(void)
{
80102afc:	55                   	push   %ebp
80102afd:	89 e5                	mov    %esp,%ebp

  if (!lapic){
80102aff:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b04:	85 c0                	test   %eax,%eax
80102b06:	75 07                	jne    80102b0f <lapicid+0x13>
    return 0;
80102b08:	b8 00 00 00 00       	mov    $0x0,%eax
80102b0d:	eb 0d                	jmp    80102b1c <lapicid+0x20>
  }
  return lapic[ID] >> 24;
80102b0f:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b14:	83 c0 20             	add    $0x20,%eax
80102b17:	8b 00                	mov    (%eax),%eax
80102b19:	c1 e8 18             	shr    $0x18,%eax
}
80102b1c:	5d                   	pop    %ebp
80102b1d:	c3                   	ret

80102b1e <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102b1e:	55                   	push   %ebp
80102b1f:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b21:	a1 00 41 19 80       	mov    0x80194100,%eax
80102b26:	85 c0                	test   %eax,%eax
80102b28:	74 0c                	je     80102b36 <lapiceoi+0x18>
    lapicw(EOI, 0);
80102b2a:	6a 00                	push   $0x0
80102b2c:	6a 2c                	push   $0x2c
80102b2e:	e8 8b fe ff ff       	call   801029be <lapicw>
80102b33:	83 c4 08             	add    $0x8,%esp
}
80102b36:	90                   	nop
80102b37:	c9                   	leave
80102b38:	c3                   	ret

80102b39 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b39:	55                   	push   %ebp
80102b3a:	89 e5                	mov    %esp,%ebp
}
80102b3c:	90                   	nop
80102b3d:	5d                   	pop    %ebp
80102b3e:	c3                   	ret

80102b3f <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b3f:	55                   	push   %ebp
80102b40:	89 e5                	mov    %esp,%ebp
80102b42:	83 ec 14             	sub    $0x14,%esp
80102b45:	8b 45 08             	mov    0x8(%ebp),%eax
80102b48:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102b4b:	6a 0f                	push   $0xf
80102b4d:	6a 70                	push   $0x70
80102b4f:	e8 4b fe ff ff       	call   8010299f <outb>
80102b54:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80102b57:	6a 0a                	push   $0xa
80102b59:	6a 71                	push   $0x71
80102b5b:	e8 3f fe ff ff       	call   8010299f <outb>
80102b60:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102b63:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102b6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102b6d:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102b72:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b75:	c1 e8 04             	shr    $0x4,%eax
80102b78:	89 c2                	mov    %eax,%edx
80102b7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102b7d:	83 c0 02             	add    $0x2,%eax
80102b80:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b83:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102b87:	c1 e0 18             	shl    $0x18,%eax
80102b8a:	50                   	push   %eax
80102b8b:	68 c4 00 00 00       	push   $0xc4
80102b90:	e8 29 fe ff ff       	call   801029be <lapicw>
80102b95:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102b98:	68 00 c5 00 00       	push   $0xc500
80102b9d:	68 c0 00 00 00       	push   $0xc0
80102ba2:	e8 17 fe ff ff       	call   801029be <lapicw>
80102ba7:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102baa:	68 c8 00 00 00       	push   $0xc8
80102baf:	e8 85 ff ff ff       	call   80102b39 <microdelay>
80102bb4:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80102bb7:	68 00 85 00 00       	push   $0x8500
80102bbc:	68 c0 00 00 00       	push   $0xc0
80102bc1:	e8 f8 fd ff ff       	call   801029be <lapicw>
80102bc6:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102bc9:	6a 64                	push   $0x64
80102bcb:	e8 69 ff ff ff       	call   80102b39 <microdelay>
80102bd0:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102bd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102bda:	eb 3d                	jmp    80102c19 <lapicstartap+0xda>
    lapicw(ICRHI, apicid<<24);
80102bdc:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102be0:	c1 e0 18             	shl    $0x18,%eax
80102be3:	50                   	push   %eax
80102be4:	68 c4 00 00 00       	push   $0xc4
80102be9:	e8 d0 fd ff ff       	call   801029be <lapicw>
80102bee:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
80102bf4:	c1 e8 0c             	shr    $0xc,%eax
80102bf7:	80 cc 06             	or     $0x6,%ah
80102bfa:	50                   	push   %eax
80102bfb:	68 c0 00 00 00       	push   $0xc0
80102c00:	e8 b9 fd ff ff       	call   801029be <lapicw>
80102c05:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80102c08:	68 c8 00 00 00       	push   $0xc8
80102c0d:	e8 27 ff ff ff       	call   80102b39 <microdelay>
80102c12:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
80102c15:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102c19:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102c1d:	7e bd                	jle    80102bdc <lapicstartap+0x9d>
  }
}
80102c1f:	90                   	nop
80102c20:	90                   	nop
80102c21:	c9                   	leave
80102c22:	c3                   	ret

80102c23 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80102c23:	55                   	push   %ebp
80102c24:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80102c26:	8b 45 08             	mov    0x8(%ebp),%eax
80102c29:	0f b6 c0             	movzbl %al,%eax
80102c2c:	50                   	push   %eax
80102c2d:	6a 70                	push   $0x70
80102c2f:	e8 6b fd ff ff       	call   8010299f <outb>
80102c34:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102c37:	68 c8 00 00 00       	push   $0xc8
80102c3c:	e8 f8 fe ff ff       	call   80102b39 <microdelay>
80102c41:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80102c44:	6a 71                	push   $0x71
80102c46:	e8 37 fd ff ff       	call   80102982 <inb>
80102c4b:	83 c4 04             	add    $0x4,%esp
80102c4e:	0f b6 c0             	movzbl %al,%eax
}
80102c51:	c9                   	leave
80102c52:	c3                   	ret

80102c53 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80102c53:	55                   	push   %ebp
80102c54:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80102c56:	6a 00                	push   $0x0
80102c58:	e8 c6 ff ff ff       	call   80102c23 <cmos_read>
80102c5d:	83 c4 04             	add    $0x4,%esp
80102c60:	8b 55 08             	mov    0x8(%ebp),%edx
80102c63:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80102c65:	6a 02                	push   $0x2
80102c67:	e8 b7 ff ff ff       	call   80102c23 <cmos_read>
80102c6c:	83 c4 04             	add    $0x4,%esp
80102c6f:	8b 55 08             	mov    0x8(%ebp),%edx
80102c72:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80102c75:	6a 04                	push   $0x4
80102c77:	e8 a7 ff ff ff       	call   80102c23 <cmos_read>
80102c7c:	83 c4 04             	add    $0x4,%esp
80102c7f:	8b 55 08             	mov    0x8(%ebp),%edx
80102c82:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80102c85:	6a 07                	push   $0x7
80102c87:	e8 97 ff ff ff       	call   80102c23 <cmos_read>
80102c8c:	83 c4 04             	add    $0x4,%esp
80102c8f:	8b 55 08             	mov    0x8(%ebp),%edx
80102c92:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80102c95:	6a 08                	push   $0x8
80102c97:	e8 87 ff ff ff       	call   80102c23 <cmos_read>
80102c9c:	83 c4 04             	add    $0x4,%esp
80102c9f:	8b 55 08             	mov    0x8(%ebp),%edx
80102ca2:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80102ca5:	6a 09                	push   $0x9
80102ca7:	e8 77 ff ff ff       	call   80102c23 <cmos_read>
80102cac:	83 c4 04             	add    $0x4,%esp
80102caf:	8b 55 08             	mov    0x8(%ebp),%edx
80102cb2:	89 42 14             	mov    %eax,0x14(%edx)
}
80102cb5:	90                   	nop
80102cb6:	c9                   	leave
80102cb7:	c3                   	ret

80102cb8 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102cb8:	55                   	push   %ebp
80102cb9:	89 e5                	mov    %esp,%ebp
80102cbb:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80102cbe:	6a 0b                	push   $0xb
80102cc0:	e8 5e ff ff ff       	call   80102c23 <cmos_read>
80102cc5:	83 c4 04             	add    $0x4,%esp
80102cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80102ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cce:	83 e0 04             	and    $0x4,%eax
80102cd1:	85 c0                	test   %eax,%eax
80102cd3:	0f 94 c0             	sete   %al
80102cd6:	0f b6 c0             	movzbl %al,%eax
80102cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102cdc:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102cdf:	50                   	push   %eax
80102ce0:	e8 6e ff ff ff       	call   80102c53 <fill_rtcdate>
80102ce5:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ce8:	6a 0a                	push   $0xa
80102cea:	e8 34 ff ff ff       	call   80102c23 <cmos_read>
80102cef:	83 c4 04             	add    $0x4,%esp
80102cf2:	25 80 00 00 00       	and    $0x80,%eax
80102cf7:	85 c0                	test   %eax,%eax
80102cf9:	75 27                	jne    80102d22 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80102cfb:	8d 45 c0             	lea    -0x40(%ebp),%eax
80102cfe:	50                   	push   %eax
80102cff:	e8 4f ff ff ff       	call   80102c53 <fill_rtcdate>
80102d04:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d07:	83 ec 04             	sub    $0x4,%esp
80102d0a:	6a 18                	push   $0x18
80102d0c:	8d 45 c0             	lea    -0x40(%ebp),%eax
80102d0f:	50                   	push   %eax
80102d10:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102d13:	50                   	push   %eax
80102d14:	e8 16 1f 00 00       	call   80104c2f <memcmp>
80102d19:	83 c4 10             	add    $0x10,%esp
80102d1c:	85 c0                	test   %eax,%eax
80102d1e:	74 05                	je     80102d25 <cmostime+0x6d>
80102d20:	eb ba                	jmp    80102cdc <cmostime+0x24>
        continue;
80102d22:	90                   	nop
    fill_rtcdate(&t1);
80102d23:	eb b7                	jmp    80102cdc <cmostime+0x24>
      break;
80102d25:	90                   	nop
  }

  // convert
  if(bcd) {
80102d26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102d2a:	0f 84 b4 00 00 00    	je     80102de4 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d30:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102d33:	c1 e8 04             	shr    $0x4,%eax
80102d36:	89 c2                	mov    %eax,%edx
80102d38:	89 d0                	mov    %edx,%eax
80102d3a:	c1 e0 02             	shl    $0x2,%eax
80102d3d:	01 d0                	add    %edx,%eax
80102d3f:	01 c0                	add    %eax,%eax
80102d41:	89 c2                	mov    %eax,%edx
80102d43:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102d46:	83 e0 0f             	and    $0xf,%eax
80102d49:	01 d0                	add    %edx,%eax
80102d4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80102d4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d51:	c1 e8 04             	shr    $0x4,%eax
80102d54:	89 c2                	mov    %eax,%edx
80102d56:	89 d0                	mov    %edx,%eax
80102d58:	c1 e0 02             	shl    $0x2,%eax
80102d5b:	01 d0                	add    %edx,%eax
80102d5d:	01 c0                	add    %eax,%eax
80102d5f:	89 c2                	mov    %eax,%edx
80102d61:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102d64:	83 e0 0f             	and    $0xf,%eax
80102d67:	01 d0                	add    %edx,%eax
80102d69:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80102d6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d6f:	c1 e8 04             	shr    $0x4,%eax
80102d72:	89 c2                	mov    %eax,%edx
80102d74:	89 d0                	mov    %edx,%eax
80102d76:	c1 e0 02             	shl    $0x2,%eax
80102d79:	01 d0                	add    %edx,%eax
80102d7b:	01 c0                	add    %eax,%eax
80102d7d:	89 c2                	mov    %eax,%edx
80102d7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d82:	83 e0 0f             	and    $0xf,%eax
80102d85:	01 d0                	add    %edx,%eax
80102d87:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80102d8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d8d:	c1 e8 04             	shr    $0x4,%eax
80102d90:	89 c2                	mov    %eax,%edx
80102d92:	89 d0                	mov    %edx,%eax
80102d94:	c1 e0 02             	shl    $0x2,%eax
80102d97:	01 d0                	add    %edx,%eax
80102d99:	01 c0                	add    %eax,%eax
80102d9b:	89 c2                	mov    %eax,%edx
80102d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102da0:	83 e0 0f             	and    $0xf,%eax
80102da3:	01 d0                	add    %edx,%eax
80102da5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80102da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102dab:	c1 e8 04             	shr    $0x4,%eax
80102dae:	89 c2                	mov    %eax,%edx
80102db0:	89 d0                	mov    %edx,%eax
80102db2:	c1 e0 02             	shl    $0x2,%eax
80102db5:	01 d0                	add    %edx,%eax
80102db7:	01 c0                	add    %eax,%eax
80102db9:	89 c2                	mov    %eax,%edx
80102dbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102dbe:	83 e0 0f             	and    $0xf,%eax
80102dc1:	01 d0                	add    %edx,%eax
80102dc3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80102dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102dc9:	c1 e8 04             	shr    $0x4,%eax
80102dcc:	89 c2                	mov    %eax,%edx
80102dce:	89 d0                	mov    %edx,%eax
80102dd0:	c1 e0 02             	shl    $0x2,%eax
80102dd3:	01 d0                	add    %edx,%eax
80102dd5:	01 c0                	add    %eax,%eax
80102dd7:	89 c2                	mov    %eax,%edx
80102dd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102ddc:	83 e0 0f             	and    $0xf,%eax
80102ddf:	01 d0                	add    %edx,%eax
80102de1:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80102de4:	8b 45 08             	mov    0x8(%ebp),%eax
80102de7:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102dea:	89 10                	mov    %edx,(%eax)
80102dec:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102def:	89 50 04             	mov    %edx,0x4(%eax)
80102df2:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102df5:	89 50 08             	mov    %edx,0x8(%eax)
80102df8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102dfb:	89 50 0c             	mov    %edx,0xc(%eax)
80102dfe:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102e01:	89 50 10             	mov    %edx,0x10(%eax)
80102e04:	8b 55 ec             	mov    -0x14(%ebp),%edx
80102e07:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80102e0a:	8b 45 08             	mov    0x8(%ebp),%eax
80102e0d:	8b 40 14             	mov    0x14(%eax),%eax
80102e10:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80102e16:	8b 45 08             	mov    0x8(%ebp),%eax
80102e19:	89 50 14             	mov    %edx,0x14(%eax)
}
80102e1c:	90                   	nop
80102e1d:	c9                   	leave
80102e1e:	c3                   	ret

80102e1f <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102e1f:	55                   	push   %ebp
80102e20:	89 e5                	mov    %esp,%ebp
80102e22:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102e25:	83 ec 08             	sub    $0x8,%esp
80102e28:	68 51 a4 10 80       	push   $0x8010a451
80102e2d:	68 20 41 19 80       	push   $0x80194120
80102e32:	e8 f9 1a 00 00       	call   80104930 <initlock>
80102e37:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80102e3a:	83 ec 08             	sub    $0x8,%esp
80102e3d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e40:	50                   	push   %eax
80102e41:	ff 75 08             	push   0x8(%ebp)
80102e44:	e8 8f e5 ff ff       	call   801013d8 <readsb>
80102e49:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80102e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102e4f:	a3 54 41 19 80       	mov    %eax,0x80194154
  log.size = sb.nlog;
80102e54:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102e57:	a3 58 41 19 80       	mov    %eax,0x80194158
  log.dev = dev;
80102e5c:	8b 45 08             	mov    0x8(%ebp),%eax
80102e5f:	a3 64 41 19 80       	mov    %eax,0x80194164
  recover_from_log();
80102e64:	e8 b3 01 00 00       	call   8010301c <recover_from_log>
}
80102e69:	90                   	nop
80102e6a:	c9                   	leave
80102e6b:	c3                   	ret

80102e6c <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102e6c:	55                   	push   %ebp
80102e6d:	89 e5                	mov    %esp,%ebp
80102e6f:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102e79:	e9 95 00 00 00       	jmp    80102f13 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e7e:	8b 15 54 41 19 80    	mov    0x80194154,%edx
80102e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e87:	01 d0                	add    %edx,%eax
80102e89:	83 c0 01             	add    $0x1,%eax
80102e8c:	89 c2                	mov    %eax,%edx
80102e8e:	a1 64 41 19 80       	mov    0x80194164,%eax
80102e93:	83 ec 08             	sub    $0x8,%esp
80102e96:	52                   	push   %edx
80102e97:	50                   	push   %eax
80102e98:	e8 64 d3 ff ff       	call   80100201 <bread>
80102e9d:	83 c4 10             	add    $0x10,%esp
80102ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ea6:	83 c0 10             	add    $0x10,%eax
80102ea9:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
80102eb0:	89 c2                	mov    %eax,%edx
80102eb2:	a1 64 41 19 80       	mov    0x80194164,%eax
80102eb7:	83 ec 08             	sub    $0x8,%esp
80102eba:	52                   	push   %edx
80102ebb:	50                   	push   %eax
80102ebc:	e8 40 d3 ff ff       	call   80100201 <bread>
80102ec1:	83 c4 10             	add    $0x10,%esp
80102ec4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102eca:	8d 50 5c             	lea    0x5c(%eax),%edx
80102ecd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102ed0:	83 c0 5c             	add    $0x5c,%eax
80102ed3:	83 ec 04             	sub    $0x4,%esp
80102ed6:	68 00 02 00 00       	push   $0x200
80102edb:	52                   	push   %edx
80102edc:	50                   	push   %eax
80102edd:	e8 a5 1d 00 00       	call   80104c87 <memmove>
80102ee2:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80102ee5:	83 ec 0c             	sub    $0xc,%esp
80102ee8:	ff 75 ec             	push   -0x14(%ebp)
80102eeb:	e8 4a d3 ff ff       	call   8010023a <bwrite>
80102ef0:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
80102ef3:	83 ec 0c             	sub    $0xc,%esp
80102ef6:	ff 75 f0             	push   -0x10(%ebp)
80102ef9:	e8 85 d3 ff ff       	call   80100283 <brelse>
80102efe:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80102f01:	83 ec 0c             	sub    $0xc,%esp
80102f04:	ff 75 ec             	push   -0x14(%ebp)
80102f07:	e8 77 d3 ff ff       	call   80100283 <brelse>
80102f0c:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102f0f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102f13:	a1 68 41 19 80       	mov    0x80194168,%eax
80102f18:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102f1b:	0f 8c 5d ff ff ff    	jl     80102e7e <install_trans+0x12>
  }
}
80102f21:	90                   	nop
80102f22:	90                   	nop
80102f23:	c9                   	leave
80102f24:	c3                   	ret

80102f25 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80102f25:	55                   	push   %ebp
80102f26:	89 e5                	mov    %esp,%ebp
80102f28:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f2b:	a1 54 41 19 80       	mov    0x80194154,%eax
80102f30:	89 c2                	mov    %eax,%edx
80102f32:	a1 64 41 19 80       	mov    0x80194164,%eax
80102f37:	83 ec 08             	sub    $0x8,%esp
80102f3a:	52                   	push   %edx
80102f3b:	50                   	push   %eax
80102f3c:	e8 c0 d2 ff ff       	call   80100201 <bread>
80102f41:	83 c4 10             	add    $0x10,%esp
80102f44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80102f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102f4a:	83 c0 5c             	add    $0x5c,%eax
80102f4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80102f50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f53:	8b 00                	mov    (%eax),%eax
80102f55:	a3 68 41 19 80       	mov    %eax,0x80194168
  for (i = 0; i < log.lh.n; i++) {
80102f5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102f61:	eb 1b                	jmp    80102f7e <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80102f63:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102f66:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102f69:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80102f6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102f70:	83 c2 10             	add    $0x10,%edx
80102f73:	89 04 95 2c 41 19 80 	mov    %eax,-0x7fe6bed4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f7a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102f7e:	a1 68 41 19 80       	mov    0x80194168,%eax
80102f83:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102f86:	7c db                	jl     80102f63 <read_head+0x3e>
  }
  brelse(buf);
80102f88:	83 ec 0c             	sub    $0xc,%esp
80102f8b:	ff 75 f0             	push   -0x10(%ebp)
80102f8e:	e8 f0 d2 ff ff       	call   80100283 <brelse>
80102f93:	83 c4 10             	add    $0x10,%esp
}
80102f96:	90                   	nop
80102f97:	c9                   	leave
80102f98:	c3                   	ret

80102f99 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f99:	55                   	push   %ebp
80102f9a:	89 e5                	mov    %esp,%ebp
80102f9c:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f9f:	a1 54 41 19 80       	mov    0x80194154,%eax
80102fa4:	89 c2                	mov    %eax,%edx
80102fa6:	a1 64 41 19 80       	mov    0x80194164,%eax
80102fab:	83 ec 08             	sub    $0x8,%esp
80102fae:	52                   	push   %edx
80102faf:	50                   	push   %eax
80102fb0:	e8 4c d2 ff ff       	call   80100201 <bread>
80102fb5:	83 c4 10             	add    $0x10,%esp
80102fb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80102fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102fbe:	83 c0 5c             	add    $0x5c,%eax
80102fc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80102fc4:	8b 15 68 41 19 80    	mov    0x80194168,%edx
80102fca:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102fcd:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102fcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102fd6:	eb 1b                	jmp    80102ff3 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80102fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fdb:	83 c0 10             	add    $0x10,%eax
80102fde:	8b 0c 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%ecx
80102fe5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102fe8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102feb:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102fef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102ff3:	a1 68 41 19 80       	mov    0x80194168,%eax
80102ff8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102ffb:	7c db                	jl     80102fd8 <write_head+0x3f>
  }
  bwrite(buf);
80102ffd:	83 ec 0c             	sub    $0xc,%esp
80103000:	ff 75 f0             	push   -0x10(%ebp)
80103003:	e8 32 d2 ff ff       	call   8010023a <bwrite>
80103008:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
8010300b:	83 ec 0c             	sub    $0xc,%esp
8010300e:	ff 75 f0             	push   -0x10(%ebp)
80103011:	e8 6d d2 ff ff       	call   80100283 <brelse>
80103016:	83 c4 10             	add    $0x10,%esp
}
80103019:	90                   	nop
8010301a:	c9                   	leave
8010301b:	c3                   	ret

8010301c <recover_from_log>:

static void
recover_from_log(void)
{
8010301c:	55                   	push   %ebp
8010301d:	89 e5                	mov    %esp,%ebp
8010301f:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103022:	e8 fe fe ff ff       	call   80102f25 <read_head>
  install_trans(); // if committed, copy from log to disk
80103027:	e8 40 fe ff ff       	call   80102e6c <install_trans>
  log.lh.n = 0;
8010302c:	c7 05 68 41 19 80 00 	movl   $0x0,0x80194168
80103033:	00 00 00 
  write_head(); // clear the log
80103036:	e8 5e ff ff ff       	call   80102f99 <write_head>
}
8010303b:	90                   	nop
8010303c:	c9                   	leave
8010303d:	c3                   	ret

8010303e <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010303e:	55                   	push   %ebp
8010303f:	89 e5                	mov    %esp,%ebp
80103041:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103044:	83 ec 0c             	sub    $0xc,%esp
80103047:	68 20 41 19 80       	push   $0x80194120
8010304c:	e8 01 19 00 00       	call   80104952 <acquire>
80103051:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103054:	a1 60 41 19 80       	mov    0x80194160,%eax
80103059:	85 c0                	test   %eax,%eax
8010305b:	74 17                	je     80103074 <begin_op+0x36>
      sleep(&log, &log.lock);
8010305d:	83 ec 08             	sub    $0x8,%esp
80103060:	68 20 41 19 80       	push   $0x80194120
80103065:	68 20 41 19 80       	push   $0x80194120
8010306a:	e8 6a 12 00 00       	call   801042d9 <sleep>
8010306f:	83 c4 10             	add    $0x10,%esp
80103072:	eb e0                	jmp    80103054 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103074:	8b 0d 68 41 19 80    	mov    0x80194168,%ecx
8010307a:	a1 5c 41 19 80       	mov    0x8019415c,%eax
8010307f:	8d 50 01             	lea    0x1(%eax),%edx
80103082:	89 d0                	mov    %edx,%eax
80103084:	c1 e0 02             	shl    $0x2,%eax
80103087:	01 d0                	add    %edx,%eax
80103089:	01 c0                	add    %eax,%eax
8010308b:	01 c8                	add    %ecx,%eax
8010308d:	83 f8 1e             	cmp    $0x1e,%eax
80103090:	7e 17                	jle    801030a9 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103092:	83 ec 08             	sub    $0x8,%esp
80103095:	68 20 41 19 80       	push   $0x80194120
8010309a:	68 20 41 19 80       	push   $0x80194120
8010309f:	e8 35 12 00 00       	call   801042d9 <sleep>
801030a4:	83 c4 10             	add    $0x10,%esp
801030a7:	eb ab                	jmp    80103054 <begin_op+0x16>
    } else {
      log.outstanding += 1;
801030a9:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801030ae:	83 c0 01             	add    $0x1,%eax
801030b1:	a3 5c 41 19 80       	mov    %eax,0x8019415c
      release(&log.lock);
801030b6:	83 ec 0c             	sub    $0xc,%esp
801030b9:	68 20 41 19 80       	push   $0x80194120
801030be:	e8 fd 18 00 00       	call   801049c0 <release>
801030c3:	83 c4 10             	add    $0x10,%esp
      break;
801030c6:	90                   	nop
    }
  }
}
801030c7:	90                   	nop
801030c8:	c9                   	leave
801030c9:	c3                   	ret

801030ca <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801030ca:	55                   	push   %ebp
801030cb:	89 e5                	mov    %esp,%ebp
801030cd:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801030d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801030d7:	83 ec 0c             	sub    $0xc,%esp
801030da:	68 20 41 19 80       	push   $0x80194120
801030df:	e8 6e 18 00 00       	call   80104952 <acquire>
801030e4:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801030e7:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801030ec:	83 e8 01             	sub    $0x1,%eax
801030ef:	a3 5c 41 19 80       	mov    %eax,0x8019415c
  if(log.committing)
801030f4:	a1 60 41 19 80       	mov    0x80194160,%eax
801030f9:	85 c0                	test   %eax,%eax
801030fb:	74 0d                	je     8010310a <end_op+0x40>
    panic("log.committing");
801030fd:	83 ec 0c             	sub    $0xc,%esp
80103100:	68 55 a4 10 80       	push   $0x8010a455
80103105:	e8 9f d4 ff ff       	call   801005a9 <panic>
  if(log.outstanding == 0){
8010310a:	a1 5c 41 19 80       	mov    0x8019415c,%eax
8010310f:	85 c0                	test   %eax,%eax
80103111:	75 13                	jne    80103126 <end_op+0x5c>
    do_commit = 1;
80103113:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010311a:	c7 05 60 41 19 80 01 	movl   $0x1,0x80194160
80103121:	00 00 00 
80103124:	eb 10                	jmp    80103136 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103126:	83 ec 0c             	sub    $0xc,%esp
80103129:	68 20 41 19 80       	push   $0x80194120
8010312e:	e8 8d 12 00 00       	call   801043c0 <wakeup>
80103133:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103136:	83 ec 0c             	sub    $0xc,%esp
80103139:	68 20 41 19 80       	push   $0x80194120
8010313e:	e8 7d 18 00 00       	call   801049c0 <release>
80103143:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103146:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010314a:	74 3f                	je     8010318b <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010314c:	e8 f6 00 00 00       	call   80103247 <commit>
    acquire(&log.lock);
80103151:	83 ec 0c             	sub    $0xc,%esp
80103154:	68 20 41 19 80       	push   $0x80194120
80103159:	e8 f4 17 00 00       	call   80104952 <acquire>
8010315e:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103161:	c7 05 60 41 19 80 00 	movl   $0x0,0x80194160
80103168:	00 00 00 
    wakeup(&log);
8010316b:	83 ec 0c             	sub    $0xc,%esp
8010316e:	68 20 41 19 80       	push   $0x80194120
80103173:	e8 48 12 00 00       	call   801043c0 <wakeup>
80103178:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010317b:	83 ec 0c             	sub    $0xc,%esp
8010317e:	68 20 41 19 80       	push   $0x80194120
80103183:	e8 38 18 00 00       	call   801049c0 <release>
80103188:	83 c4 10             	add    $0x10,%esp
  }
}
8010318b:	90                   	nop
8010318c:	c9                   	leave
8010318d:	c3                   	ret

8010318e <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
8010318e:	55                   	push   %ebp
8010318f:	89 e5                	mov    %esp,%ebp
80103191:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103194:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010319b:	e9 95 00 00 00       	jmp    80103235 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801031a0:	8b 15 54 41 19 80    	mov    0x80194154,%edx
801031a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031a9:	01 d0                	add    %edx,%eax
801031ab:	83 c0 01             	add    $0x1,%eax
801031ae:	89 c2                	mov    %eax,%edx
801031b0:	a1 64 41 19 80       	mov    0x80194164,%eax
801031b5:	83 ec 08             	sub    $0x8,%esp
801031b8:	52                   	push   %edx
801031b9:	50                   	push   %eax
801031ba:	e8 42 d0 ff ff       	call   80100201 <bread>
801031bf:	83 c4 10             	add    $0x10,%esp
801031c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031c8:	83 c0 10             	add    $0x10,%eax
801031cb:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
801031d2:	89 c2                	mov    %eax,%edx
801031d4:	a1 64 41 19 80       	mov    0x80194164,%eax
801031d9:	83 ec 08             	sub    $0x8,%esp
801031dc:	52                   	push   %edx
801031dd:	50                   	push   %eax
801031de:	e8 1e d0 ff ff       	call   80100201 <bread>
801031e3:	83 c4 10             	add    $0x10,%esp
801031e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801031e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031ec:	8d 50 5c             	lea    0x5c(%eax),%edx
801031ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031f2:	83 c0 5c             	add    $0x5c,%eax
801031f5:	83 ec 04             	sub    $0x4,%esp
801031f8:	68 00 02 00 00       	push   $0x200
801031fd:	52                   	push   %edx
801031fe:	50                   	push   %eax
801031ff:	e8 83 1a 00 00       	call   80104c87 <memmove>
80103204:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103207:	83 ec 0c             	sub    $0xc,%esp
8010320a:	ff 75 f0             	push   -0x10(%ebp)
8010320d:	e8 28 d0 ff ff       	call   8010023a <bwrite>
80103212:	83 c4 10             	add    $0x10,%esp
    brelse(from);
80103215:	83 ec 0c             	sub    $0xc,%esp
80103218:	ff 75 ec             	push   -0x14(%ebp)
8010321b:	e8 63 d0 ff ff       	call   80100283 <brelse>
80103220:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103223:	83 ec 0c             	sub    $0xc,%esp
80103226:	ff 75 f0             	push   -0x10(%ebp)
80103229:	e8 55 d0 ff ff       	call   80100283 <brelse>
8010322e:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103231:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103235:	a1 68 41 19 80       	mov    0x80194168,%eax
8010323a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010323d:	0f 8c 5d ff ff ff    	jl     801031a0 <write_log+0x12>
  }
}
80103243:	90                   	nop
80103244:	90                   	nop
80103245:	c9                   	leave
80103246:	c3                   	ret

80103247 <commit>:

static void
commit()
{
80103247:	55                   	push   %ebp
80103248:	89 e5                	mov    %esp,%ebp
8010324a:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010324d:	a1 68 41 19 80       	mov    0x80194168,%eax
80103252:	85 c0                	test   %eax,%eax
80103254:	7e 1e                	jle    80103274 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103256:	e8 33 ff ff ff       	call   8010318e <write_log>
    write_head();    // Write header to disk -- the real commit
8010325b:	e8 39 fd ff ff       	call   80102f99 <write_head>
    install_trans(); // Now install writes to home locations
80103260:	e8 07 fc ff ff       	call   80102e6c <install_trans>
    log.lh.n = 0;
80103265:	c7 05 68 41 19 80 00 	movl   $0x0,0x80194168
8010326c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010326f:	e8 25 fd ff ff       	call   80102f99 <write_head>
  }
}
80103274:	90                   	nop
80103275:	c9                   	leave
80103276:	c3                   	ret

80103277 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103277:	55                   	push   %ebp
80103278:	89 e5                	mov    %esp,%ebp
8010327a:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010327d:	a1 68 41 19 80       	mov    0x80194168,%eax
80103282:	83 f8 1d             	cmp    $0x1d,%eax
80103285:	7f 12                	jg     80103299 <log_write+0x22>
80103287:	8b 15 68 41 19 80    	mov    0x80194168,%edx
8010328d:	a1 58 41 19 80       	mov    0x80194158,%eax
80103292:	83 e8 01             	sub    $0x1,%eax
80103295:	39 c2                	cmp    %eax,%edx
80103297:	7c 0d                	jl     801032a6 <log_write+0x2f>
    panic("too big a transaction");
80103299:	83 ec 0c             	sub    $0xc,%esp
8010329c:	68 64 a4 10 80       	push   $0x8010a464
801032a1:	e8 03 d3 ff ff       	call   801005a9 <panic>
  if (log.outstanding < 1)
801032a6:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801032ab:	85 c0                	test   %eax,%eax
801032ad:	7f 0d                	jg     801032bc <log_write+0x45>
    panic("log_write outside of trans");
801032af:	83 ec 0c             	sub    $0xc,%esp
801032b2:	68 7a a4 10 80       	push   $0x8010a47a
801032b7:	e8 ed d2 ff ff       	call   801005a9 <panic>

  acquire(&log.lock);
801032bc:	83 ec 0c             	sub    $0xc,%esp
801032bf:	68 20 41 19 80       	push   $0x80194120
801032c4:	e8 89 16 00 00       	call   80104952 <acquire>
801032c9:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
801032cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032d3:	eb 1d                	jmp    801032f2 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032d8:	83 c0 10             	add    $0x10,%eax
801032db:	8b 04 85 2c 41 19 80 	mov    -0x7fe6bed4(,%eax,4),%eax
801032e2:	89 c2                	mov    %eax,%edx
801032e4:	8b 45 08             	mov    0x8(%ebp),%eax
801032e7:	8b 40 08             	mov    0x8(%eax),%eax
801032ea:	39 c2                	cmp    %eax,%edx
801032ec:	74 10                	je     801032fe <log_write+0x87>
  for (i = 0; i < log.lh.n; i++) {
801032ee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801032f2:	a1 68 41 19 80       	mov    0x80194168,%eax
801032f7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801032fa:	7c d9                	jl     801032d5 <log_write+0x5e>
801032fc:	eb 01                	jmp    801032ff <log_write+0x88>
      break;
801032fe:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801032ff:	8b 45 08             	mov    0x8(%ebp),%eax
80103302:	8b 40 08             	mov    0x8(%eax),%eax
80103305:	89 c2                	mov    %eax,%edx
80103307:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010330a:	83 c0 10             	add    $0x10,%eax
8010330d:	89 14 85 2c 41 19 80 	mov    %edx,-0x7fe6bed4(,%eax,4)
  if (i == log.lh.n)
80103314:	a1 68 41 19 80       	mov    0x80194168,%eax
80103319:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010331c:	75 0d                	jne    8010332b <log_write+0xb4>
    log.lh.n++;
8010331e:	a1 68 41 19 80       	mov    0x80194168,%eax
80103323:	83 c0 01             	add    $0x1,%eax
80103326:	a3 68 41 19 80       	mov    %eax,0x80194168
  b->flags |= B_DIRTY; // prevent eviction
8010332b:	8b 45 08             	mov    0x8(%ebp),%eax
8010332e:	8b 00                	mov    (%eax),%eax
80103330:	83 c8 04             	or     $0x4,%eax
80103333:	89 c2                	mov    %eax,%edx
80103335:	8b 45 08             	mov    0x8(%ebp),%eax
80103338:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010333a:	83 ec 0c             	sub    $0xc,%esp
8010333d:	68 20 41 19 80       	push   $0x80194120
80103342:	e8 79 16 00 00       	call   801049c0 <release>
80103347:	83 c4 10             	add    $0x10,%esp
}
8010334a:	90                   	nop
8010334b:	c9                   	leave
8010334c:	c3                   	ret

8010334d <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010334d:	55                   	push   %ebp
8010334e:	89 e5                	mov    %esp,%ebp
80103350:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103353:	8b 55 08             	mov    0x8(%ebp),%edx
80103356:	8b 45 0c             	mov    0xc(%ebp),%eax
80103359:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010335c:	f0 87 02             	lock xchg %eax,(%edx)
8010335f:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103362:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103365:	c9                   	leave
80103366:	c3                   	ret

80103367 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103367:	8d 4c 24 04          	lea    0x4(%esp),%ecx
8010336b:	83 e4 f0             	and    $0xfffffff0,%esp
8010336e:	ff 71 fc             	push   -0x4(%ecx)
80103371:	55                   	push   %ebp
80103372:	89 e5                	mov    %esp,%ebp
80103374:	51                   	push   %ecx
80103375:	83 ec 04             	sub    $0x4,%esp
  graphic_init(); // 화면 출력을 위한 그래픽 시스템
80103378:	e8 67 4c 00 00       	call   80107fe4 <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator 커널이 사용할 수 있는 물리 메모리의 첫 4MB를 할당할 준비를 합니다.
8010337d:	83 ec 08             	sub    $0x8,%esp
80103380:	68 00 00 40 80       	push   $0x80400000
80103385:	68 00 90 19 80       	push   $0x80199000
8010338a:	e8 e4 f2 ff ff       	call   80102673 <kinit1>
8010338f:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table // 가상 메모리 주소를 물리 메모리 주소로 변환할 **커널 페이지 테이블(지도)**을 만듭니다.
80103392:	e8 6a 42 00 00       	call   80107601 <kvmalloc>
  mpinit_uefi(); // 다중 코어(멀티프로세서) 환경을 UEFI 방식에 맞게 파악합니다. CPU가 몇 개인지 확인하는 작업이죠.
80103397:	e8 11 4a 00 00       	call   80107dad <mpinit_uefi>
  lapicinit();     // interrupt controller 키보드나 마우스 등 외부에서 들어오는 신호(인터럽트)를 CPU가 받을 수 있도록 컨트롤러를 켭니다.
8010339c:	e8 3f f6 ff ff       	call   801029e0 <lapicinit>
  seginit();       // segment descriptors 메모리 보호 구역(세그먼트)을 설정하고, 오류나 시스템 콜이 발생했을 때 어디로 가야 할지(트랩 벡터)를 설정합니다.
801033a1:	e8 f2 3c 00 00       	call   80107098 <seginit>
  picinit();    // disable pic
801033a6:	e8 9b 01 00 00       	call   80103546 <picinit>
  ioapicinit();    // another interrupt controller 키보드나 마우스 등 외부에서 들어오는 신호(인터럽트)를 CPU가 받을 수 있도록 컨트롤러를 켭니다.
801033ab:	e8 de f1 ff ff       	call   8010258e <ioapicinit>
  consoleinit();   // console hardware 화면에 글자를 찍고(콘솔), 시리얼 통신을 할 준비를 합니다.
801033b0:	e8 54 d7 ff ff       	call   80100b09 <consoleinit>
  uartinit();      // serial port 화면에 글자를 찍고(콘솔), 시리얼 통신을 할 준비를 합니다.
801033b5:	e8 77 30 00 00       	call   80106431 <uartinit>
  pinit();         // process table 프로세스 장부(프로세스 테이블)를 초기화합니다.
801033ba:	e8 c0 05 00 00       	call   8010397f <pinit>
  tvinit();        // trap vectors 메모리 보호 구역(세그먼트)을 설정하고, 오류나 시스템 콜이 발생했을 때 어디로 가야 할지(트랩 벡터)를 설정합니다.
801033bf:	e8 40 2c 00 00       	call   80106004 <tvinit>
  binit();         // buffer cache 하드디스크(IDE)를 읽고 쓸 준비를 하고, 파일 시스템과 버퍼를 세팅합니다.
801033c4:	e8 9d cc ff ff       	call   80100066 <binit>
  fileinit();      // file table 하드디스크(IDE)를 읽고 쓸 준비를 하고, 파일 시스템과 버퍼를 세팅합니다.
801033c9:	e8 fb db ff ff       	call   80100fc9 <fileinit>
  ideinit();       // disk  하드디스크(IDE)를 읽고 쓸 준비를 하고, 파일 시스템과 버퍼를 세팅합니다.
801033ce:	e8 3c 6d 00 00       	call   8010a10f <ideinit>
  startothers();   // start other processors 잠들어 있는 나머지 CPU들을 깨웁니다. (자세한 건 아래 2번에서 설명할게요)
801033d3:	e8 8a 00 00 00       	call   80103462 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers() 처음 4MB 이후의 나머지 모든 물리 메모리를 운영체제가 사용할 수 있도록 마저 할당합니다.
801033d8:	83 ec 08             	sub    $0x8,%esp
801033db:	68 00 00 00 a0       	push   $0xa0000000
801033e0:	68 00 00 40 80       	push   $0x80400000
801033e5:	e8 c2 f2 ff ff       	call   801026ac <kinit2>
801033ea:	83 c4 10             	add    $0x10,%esp
  pci_init(); // 추가된 네트워크 및 하드웨어 장치를 스캔합니다 
801033ed:	e8 4d 4e 00 00       	call   8010823f <pci_init>
  arp_scan(); // 추가된 네트워크 및 하드웨어 장치를 스캔합니다.
801033f2:	e8 82 5b 00 00       	call   80108f79 <arp_scan>
  //i8254_recv();
  userinit();      // first user process 드디어 대망의 첫 번째 유저 프로그램(보통 init 프로세스)을 메모리에 만듭니다.
801033f7:	e8 61 07 00 00       	call   80103b5d <userinit>

  mpmain();        // finish this processor's setup 준비를 마치고 스케줄러를 가동하여 프로세스들을 실행하기 시작합니다.
801033fc:	e8 1a 00 00 00       	call   8010341b <mpmain>

80103401 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void) // 서브 CPU들의 출근 완료 보고
{
80103401:	55                   	push   %ebp
80103402:	89 e5                	mov    %esp,%ebp
80103404:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103407:	e8 0d 42 00 00       	call   80107619 <switchkvm>
  seginit();
8010340c:	e8 87 3c 00 00       	call   80107098 <seginit>
  lapicinit();
80103411:	e8 ca f5 ff ff       	call   801029e0 <lapicinit>
  mpmain();
80103416:	e8 00 00 00 00       	call   8010341b <mpmain>

8010341b <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void) //서브 CPU들의 출근 완료 보고
{
8010341b:	55                   	push   %ebp
8010341c:	89 e5                	mov    %esp,%ebp
8010341e:	53                   	push   %ebx
8010341f:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103422:	e8 76 05 00 00       	call   8010399d <cpuid>
80103427:	89 c3                	mov    %eax,%ebx
80103429:	e8 6f 05 00 00       	call   8010399d <cpuid>
8010342e:	83 ec 04             	sub    $0x4,%esp
80103431:	53                   	push   %ebx
80103432:	50                   	push   %eax
80103433:	68 95 a4 10 80       	push   $0x8010a495
80103438:	e8 b7 cf ff ff       	call   801003f4 <cprintf>
8010343d:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103440:	e8 35 2d 00 00       	call   8010617a <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103445:	e8 6e 05 00 00       	call   801039b8 <mycpu>
8010344a:	05 a0 00 00 00       	add    $0xa0,%eax
8010344f:	83 ec 08             	sub    $0x8,%esp
80103452:	6a 01                	push   $0x1
80103454:	50                   	push   %eax
80103455:	e8 f3 fe ff ff       	call   8010334d <xchg>
8010345a:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010345d:	e8 86 0c 00 00       	call   801040e8 <scheduler>

80103462 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103462:	55                   	push   %ebp
80103463:	89 e5                	mov    %esp,%ebp
80103465:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103468:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010346f:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103474:	83 ec 04             	sub    $0x4,%esp
80103477:	50                   	push   %eax
80103478:	68 18 f5 10 80       	push   $0x8010f518
8010347d:	ff 75 f0             	push   -0x10(%ebp)
80103480:	e8 02 18 00 00       	call   80104c87 <memmove>
80103485:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103488:	c7 45 f4 80 6a 19 80 	movl   $0x80196a80,-0xc(%ebp)
8010348f:	eb 79                	jmp    8010350a <startothers+0xa8>
    if(c == mycpu()){  // We've started already.
80103491:	e8 22 05 00 00       	call   801039b8 <mycpu>
80103496:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103499:	74 67                	je     80103502 <startothers+0xa0>
      continue;
    }
    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010349b:	e8 08 f3 ff ff       	call   801027a8 <kalloc>
801034a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801034a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034a6:	83 e8 04             	sub    $0x4,%eax
801034a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801034ac:	81 c2 00 10 00 00    	add    $0x1000,%edx
801034b2:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801034b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034b7:	83 e8 08             	sub    $0x8,%eax
801034ba:	c7 00 01 34 10 80    	movl   $0x80103401,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801034c0:	b8 00 e0 10 80       	mov    $0x8010e000,%eax
801034c5:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801034cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034ce:	83 e8 0c             	sub    $0xc,%eax
801034d1:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
801034d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034d6:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034df:	0f b6 00             	movzbl (%eax),%eax
801034e2:	0f b6 c0             	movzbl %al,%eax
801034e5:	83 ec 08             	sub    $0x8,%esp
801034e8:	52                   	push   %edx
801034e9:	50                   	push   %eax
801034ea:	e8 50 f6 ff ff       	call   80102b3f <lapicstartap>
801034ef:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801034f2:	90                   	nop
801034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034f6:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
801034fc:	85 c0                	test   %eax,%eax
801034fe:	74 f3                	je     801034f3 <startothers+0x91>
80103500:	eb 01                	jmp    80103503 <startothers+0xa1>
      continue;
80103502:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103503:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
8010350a:	a1 40 6d 19 80       	mov    0x80196d40,%eax
8010350f:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103515:	05 80 6a 19 80       	add    $0x80196a80,%eax
8010351a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010351d:	0f 82 6e ff ff ff    	jb     80103491 <startothers+0x2f>
      ;
  }
}
80103523:	90                   	nop
80103524:	90                   	nop
80103525:	c9                   	leave
80103526:	c3                   	ret

80103527 <outb>:
{
80103527:	55                   	push   %ebp
80103528:	89 e5                	mov    %esp,%ebp
8010352a:	83 ec 08             	sub    $0x8,%esp
8010352d:	8b 55 08             	mov    0x8(%ebp),%edx
80103530:	8b 45 0c             	mov    0xc(%ebp),%eax
80103533:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103537:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010353a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010353e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103542:	ee                   	out    %al,(%dx)
}
80103543:	90                   	nop
80103544:	c9                   	leave
80103545:	c3                   	ret

80103546 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103546:	55                   	push   %ebp
80103547:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103549:	68 ff 00 00 00       	push   $0xff
8010354e:	6a 21                	push   $0x21
80103550:	e8 d2 ff ff ff       	call   80103527 <outb>
80103555:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103558:	68 ff 00 00 00       	push   $0xff
8010355d:	68 a1 00 00 00       	push   $0xa1
80103562:	e8 c0 ff ff ff       	call   80103527 <outb>
80103567:	83 c4 08             	add    $0x8,%esp
}
8010356a:	90                   	nop
8010356b:	c9                   	leave
8010356c:	c3                   	ret

8010356d <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
8010356d:	55                   	push   %ebp
8010356e:	89 e5                	mov    %esp,%ebp
80103570:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103573:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
8010357a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010357d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103583:	8b 45 0c             	mov    0xc(%ebp),%eax
80103586:	8b 10                	mov    (%eax),%edx
80103588:	8b 45 08             	mov    0x8(%ebp),%eax
8010358b:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010358d:	e8 55 da ff ff       	call   80100fe7 <filealloc>
80103592:	8b 55 08             	mov    0x8(%ebp),%edx
80103595:	89 02                	mov    %eax,(%edx)
80103597:	8b 45 08             	mov    0x8(%ebp),%eax
8010359a:	8b 00                	mov    (%eax),%eax
8010359c:	85 c0                	test   %eax,%eax
8010359e:	0f 84 c8 00 00 00    	je     8010366c <pipealloc+0xff>
801035a4:	e8 3e da ff ff       	call   80100fe7 <filealloc>
801035a9:	8b 55 0c             	mov    0xc(%ebp),%edx
801035ac:	89 02                	mov    %eax,(%edx)
801035ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801035b1:	8b 00                	mov    (%eax),%eax
801035b3:	85 c0                	test   %eax,%eax
801035b5:	0f 84 b1 00 00 00    	je     8010366c <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035bb:	e8 e8 f1 ff ff       	call   801027a8 <kalloc>
801035c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801035c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035c7:	0f 84 a2 00 00 00    	je     8010366f <pipealloc+0x102>
    goto bad;
  p->readopen = 1;
801035cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035d0:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035d7:	00 00 00 
  p->writeopen = 1;
801035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035e4:	00 00 00 
  p->nwrite = 0;
801035e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035ea:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035f1:	00 00 00 
  p->nread = 0;
801035f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035f7:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035fe:	00 00 00 
  initlock(&p->lock, "pipe");
80103601:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103604:	83 ec 08             	sub    $0x8,%esp
80103607:	68 a9 a4 10 80       	push   $0x8010a4a9
8010360c:	50                   	push   %eax
8010360d:	e8 1e 13 00 00       	call   80104930 <initlock>
80103612:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103615:	8b 45 08             	mov    0x8(%ebp),%eax
80103618:	8b 00                	mov    (%eax),%eax
8010361a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103620:	8b 45 08             	mov    0x8(%ebp),%eax
80103623:	8b 00                	mov    (%eax),%eax
80103625:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103629:	8b 45 08             	mov    0x8(%ebp),%eax
8010362c:	8b 00                	mov    (%eax),%eax
8010362e:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103632:	8b 45 08             	mov    0x8(%ebp),%eax
80103635:	8b 00                	mov    (%eax),%eax
80103637:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010363a:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010363d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103640:	8b 00                	mov    (%eax),%eax
80103642:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103648:	8b 45 0c             	mov    0xc(%ebp),%eax
8010364b:	8b 00                	mov    (%eax),%eax
8010364d:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103651:	8b 45 0c             	mov    0xc(%ebp),%eax
80103654:	8b 00                	mov    (%eax),%eax
80103656:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010365a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010365d:	8b 00                	mov    (%eax),%eax
8010365f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103662:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103665:	b8 00 00 00 00       	mov    $0x0,%eax
8010366a:	eb 51                	jmp    801036bd <pipealloc+0x150>
    goto bad;
8010366c:	90                   	nop
8010366d:	eb 01                	jmp    80103670 <pipealloc+0x103>
    goto bad;
8010366f:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
80103670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103674:	74 0e                	je     80103684 <pipealloc+0x117>
    kfree((char*)p);
80103676:	83 ec 0c             	sub    $0xc,%esp
80103679:	ff 75 f4             	push   -0xc(%ebp)
8010367c:	e8 8d f0 ff ff       	call   8010270e <kfree>
80103681:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80103684:	8b 45 08             	mov    0x8(%ebp),%eax
80103687:	8b 00                	mov    (%eax),%eax
80103689:	85 c0                	test   %eax,%eax
8010368b:	74 11                	je     8010369e <pipealloc+0x131>
    fileclose(*f0);
8010368d:	8b 45 08             	mov    0x8(%ebp),%eax
80103690:	8b 00                	mov    (%eax),%eax
80103692:	83 ec 0c             	sub    $0xc,%esp
80103695:	50                   	push   %eax
80103696:	e8 0a da ff ff       	call   801010a5 <fileclose>
8010369b:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010369e:	8b 45 0c             	mov    0xc(%ebp),%eax
801036a1:	8b 00                	mov    (%eax),%eax
801036a3:	85 c0                	test   %eax,%eax
801036a5:	74 11                	je     801036b8 <pipealloc+0x14b>
    fileclose(*f1);
801036a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801036aa:	8b 00                	mov    (%eax),%eax
801036ac:	83 ec 0c             	sub    $0xc,%esp
801036af:	50                   	push   %eax
801036b0:	e8 f0 d9 ff ff       	call   801010a5 <fileclose>
801036b5:	83 c4 10             	add    $0x10,%esp
  return -1;
801036b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036bd:	c9                   	leave
801036be:	c3                   	ret

801036bf <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036bf:	55                   	push   %ebp
801036c0:	89 e5                	mov    %esp,%ebp
801036c2:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801036c5:	8b 45 08             	mov    0x8(%ebp),%eax
801036c8:	83 ec 0c             	sub    $0xc,%esp
801036cb:	50                   	push   %eax
801036cc:	e8 81 12 00 00       	call   80104952 <acquire>
801036d1:	83 c4 10             	add    $0x10,%esp
  if(writable){
801036d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801036d8:	74 23                	je     801036fd <pipeclose+0x3e>
    p->writeopen = 0;
801036da:	8b 45 08             	mov    0x8(%ebp),%eax
801036dd:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801036e4:	00 00 00 
    wakeup(&p->nread);
801036e7:	8b 45 08             	mov    0x8(%ebp),%eax
801036ea:	05 34 02 00 00       	add    $0x234,%eax
801036ef:	83 ec 0c             	sub    $0xc,%esp
801036f2:	50                   	push   %eax
801036f3:	e8 c8 0c 00 00       	call   801043c0 <wakeup>
801036f8:	83 c4 10             	add    $0x10,%esp
801036fb:	eb 21                	jmp    8010371e <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801036fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103700:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103707:	00 00 00 
    wakeup(&p->nwrite);
8010370a:	8b 45 08             	mov    0x8(%ebp),%eax
8010370d:	05 38 02 00 00       	add    $0x238,%eax
80103712:	83 ec 0c             	sub    $0xc,%esp
80103715:	50                   	push   %eax
80103716:	e8 a5 0c 00 00       	call   801043c0 <wakeup>
8010371b:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010371e:	8b 45 08             	mov    0x8(%ebp),%eax
80103721:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103727:	85 c0                	test   %eax,%eax
80103729:	75 2c                	jne    80103757 <pipeclose+0x98>
8010372b:	8b 45 08             	mov    0x8(%ebp),%eax
8010372e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103734:	85 c0                	test   %eax,%eax
80103736:	75 1f                	jne    80103757 <pipeclose+0x98>
    release(&p->lock);
80103738:	8b 45 08             	mov    0x8(%ebp),%eax
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	50                   	push   %eax
8010373f:	e8 7c 12 00 00       	call   801049c0 <release>
80103744:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80103747:	83 ec 0c             	sub    $0xc,%esp
8010374a:	ff 75 08             	push   0x8(%ebp)
8010374d:	e8 bc ef ff ff       	call   8010270e <kfree>
80103752:	83 c4 10             	add    $0x10,%esp
80103755:	eb 10                	jmp    80103767 <pipeclose+0xa8>
  } else
    release(&p->lock);
80103757:	8b 45 08             	mov    0x8(%ebp),%eax
8010375a:	83 ec 0c             	sub    $0xc,%esp
8010375d:	50                   	push   %eax
8010375e:	e8 5d 12 00 00       	call   801049c0 <release>
80103763:	83 c4 10             	add    $0x10,%esp
}
80103766:	90                   	nop
80103767:	90                   	nop
80103768:	c9                   	leave
80103769:	c3                   	ret

8010376a <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010376a:	55                   	push   %ebp
8010376b:	89 e5                	mov    %esp,%ebp
8010376d:	53                   	push   %ebx
8010376e:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80103771:	8b 45 08             	mov    0x8(%ebp),%eax
80103774:	83 ec 0c             	sub    $0xc,%esp
80103777:	50                   	push   %eax
80103778:	e8 d5 11 00 00       	call   80104952 <acquire>
8010377d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80103780:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103787:	e9 ad 00 00 00       	jmp    80103839 <pipewrite+0xcf>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
8010378c:	8b 45 08             	mov    0x8(%ebp),%eax
8010378f:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103795:	85 c0                	test   %eax,%eax
80103797:	74 0c                	je     801037a5 <pipewrite+0x3b>
80103799:	e8 92 02 00 00       	call   80103a30 <myproc>
8010379e:	8b 40 24             	mov    0x24(%eax),%eax
801037a1:	85 c0                	test   %eax,%eax
801037a3:	74 19                	je     801037be <pipewrite+0x54>
        release(&p->lock);
801037a5:	8b 45 08             	mov    0x8(%ebp),%eax
801037a8:	83 ec 0c             	sub    $0xc,%esp
801037ab:	50                   	push   %eax
801037ac:	e8 0f 12 00 00       	call   801049c0 <release>
801037b1:	83 c4 10             	add    $0x10,%esp
        return -1;
801037b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037b9:	e9 a9 00 00 00       	jmp    80103867 <pipewrite+0xfd>
      }
      wakeup(&p->nread);
801037be:	8b 45 08             	mov    0x8(%ebp),%eax
801037c1:	05 34 02 00 00       	add    $0x234,%eax
801037c6:	83 ec 0c             	sub    $0xc,%esp
801037c9:	50                   	push   %eax
801037ca:	e8 f1 0b 00 00       	call   801043c0 <wakeup>
801037cf:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037d2:	8b 45 08             	mov    0x8(%ebp),%eax
801037d5:	8b 55 08             	mov    0x8(%ebp),%edx
801037d8:	81 c2 38 02 00 00    	add    $0x238,%edx
801037de:	83 ec 08             	sub    $0x8,%esp
801037e1:	50                   	push   %eax
801037e2:	52                   	push   %edx
801037e3:	e8 f1 0a 00 00       	call   801042d9 <sleep>
801037e8:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037eb:	8b 45 08             	mov    0x8(%ebp),%eax
801037ee:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801037f4:	8b 45 08             	mov    0x8(%ebp),%eax
801037f7:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801037fd:	05 00 02 00 00       	add    $0x200,%eax
80103802:	39 c2                	cmp    %eax,%edx
80103804:	74 86                	je     8010378c <pipewrite+0x22>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103806:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103809:	8b 45 0c             	mov    0xc(%ebp),%eax
8010380c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010380f:	8b 45 08             	mov    0x8(%ebp),%eax
80103812:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103818:	8d 48 01             	lea    0x1(%eax),%ecx
8010381b:	8b 55 08             	mov    0x8(%ebp),%edx
8010381e:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103824:	25 ff 01 00 00       	and    $0x1ff,%eax
80103829:	89 c1                	mov    %eax,%ecx
8010382b:	0f b6 13             	movzbl (%ebx),%edx
8010382e:	8b 45 08             	mov    0x8(%ebp),%eax
80103831:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80103835:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010383c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010383f:	7c aa                	jl     801037eb <pipewrite+0x81>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103841:	8b 45 08             	mov    0x8(%ebp),%eax
80103844:	05 34 02 00 00       	add    $0x234,%eax
80103849:	83 ec 0c             	sub    $0xc,%esp
8010384c:	50                   	push   %eax
8010384d:	e8 6e 0b 00 00       	call   801043c0 <wakeup>
80103852:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103855:	8b 45 08             	mov    0x8(%ebp),%eax
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	50                   	push   %eax
8010385c:	e8 5f 11 00 00       	call   801049c0 <release>
80103861:	83 c4 10             	add    $0x10,%esp
  return n;
80103864:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103867:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010386a:	c9                   	leave
8010386b:	c3                   	ret

8010386c <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010386c:	55                   	push   %ebp
8010386d:	89 e5                	mov    %esp,%ebp
8010386f:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80103872:	8b 45 08             	mov    0x8(%ebp),%eax
80103875:	83 ec 0c             	sub    $0xc,%esp
80103878:	50                   	push   %eax
80103879:	e8 d4 10 00 00       	call   80104952 <acquire>
8010387e:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103881:	eb 3e                	jmp    801038c1 <piperead+0x55>
    if(myproc()->killed){
80103883:	e8 a8 01 00 00       	call   80103a30 <myproc>
80103888:	8b 40 24             	mov    0x24(%eax),%eax
8010388b:	85 c0                	test   %eax,%eax
8010388d:	74 19                	je     801038a8 <piperead+0x3c>
      release(&p->lock);
8010388f:	8b 45 08             	mov    0x8(%ebp),%eax
80103892:	83 ec 0c             	sub    $0xc,%esp
80103895:	50                   	push   %eax
80103896:	e8 25 11 00 00       	call   801049c0 <release>
8010389b:	83 c4 10             	add    $0x10,%esp
      return -1;
8010389e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038a3:	e9 be 00 00 00       	jmp    80103966 <piperead+0xfa>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038a8:	8b 45 08             	mov    0x8(%ebp),%eax
801038ab:	8b 55 08             	mov    0x8(%ebp),%edx
801038ae:	81 c2 34 02 00 00    	add    $0x234,%edx
801038b4:	83 ec 08             	sub    $0x8,%esp
801038b7:	50                   	push   %eax
801038b8:	52                   	push   %edx
801038b9:	e8 1b 0a 00 00       	call   801042d9 <sleep>
801038be:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038c1:	8b 45 08             	mov    0x8(%ebp),%eax
801038c4:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801038ca:	8b 45 08             	mov    0x8(%ebp),%eax
801038cd:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801038d3:	39 c2                	cmp    %eax,%edx
801038d5:	75 0d                	jne    801038e4 <piperead+0x78>
801038d7:	8b 45 08             	mov    0x8(%ebp),%eax
801038da:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801038e0:	85 c0                	test   %eax,%eax
801038e2:	75 9f                	jne    80103883 <piperead+0x17>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801038eb:	eb 48                	jmp    80103935 <piperead+0xc9>
    if(p->nread == p->nwrite)
801038ed:	8b 45 08             	mov    0x8(%ebp),%eax
801038f0:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801038f6:	8b 45 08             	mov    0x8(%ebp),%eax
801038f9:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801038ff:	39 c2                	cmp    %eax,%edx
80103901:	74 3c                	je     8010393f <piperead+0xd3>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103903:	8b 45 08             	mov    0x8(%ebp),%eax
80103906:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010390c:	8d 48 01             	lea    0x1(%eax),%ecx
8010390f:	8b 55 08             	mov    0x8(%ebp),%edx
80103912:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80103918:	25 ff 01 00 00       	and    $0x1ff,%eax
8010391d:	89 c1                	mov    %eax,%ecx
8010391f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103922:	8b 45 0c             	mov    0xc(%ebp),%eax
80103925:	01 c2                	add    %eax,%edx
80103927:	8b 45 08             	mov    0x8(%ebp),%eax
8010392a:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
8010392f:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103938:	3b 45 10             	cmp    0x10(%ebp),%eax
8010393b:	7c b0                	jl     801038ed <piperead+0x81>
8010393d:	eb 01                	jmp    80103940 <piperead+0xd4>
      break;
8010393f:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103940:	8b 45 08             	mov    0x8(%ebp),%eax
80103943:	05 38 02 00 00       	add    $0x238,%eax
80103948:	83 ec 0c             	sub    $0xc,%esp
8010394b:	50                   	push   %eax
8010394c:	e8 6f 0a 00 00       	call   801043c0 <wakeup>
80103951:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103954:	8b 45 08             	mov    0x8(%ebp),%eax
80103957:	83 ec 0c             	sub    $0xc,%esp
8010395a:	50                   	push   %eax
8010395b:	e8 60 10 00 00       	call   801049c0 <release>
80103960:	83 c4 10             	add    $0x10,%esp
  return i;
80103963:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103966:	c9                   	leave
80103967:	c3                   	ret

80103968 <readeflags>:
{
80103968:	55                   	push   %ebp
80103969:	89 e5                	mov    %esp,%ebp
8010396b:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010396e:	9c                   	pushf
8010396f:	58                   	pop    %eax
80103970:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103973:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103976:	c9                   	leave
80103977:	c3                   	ret

80103978 <sti>:
{
80103978:	55                   	push   %ebp
80103979:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010397b:	fb                   	sti
}
8010397c:	90                   	nop
8010397d:	5d                   	pop    %ebp
8010397e:	c3                   	ret

8010397f <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010397f:	55                   	push   %ebp
80103980:	89 e5                	mov    %esp,%ebp
80103982:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80103985:	83 ec 08             	sub    $0x8,%esp
80103988:	68 b0 a4 10 80       	push   $0x8010a4b0
8010398d:	68 00 42 19 80       	push   $0x80194200
80103992:	e8 99 0f 00 00       	call   80104930 <initlock>
80103997:	83 c4 10             	add    $0x10,%esp
}
8010399a:	90                   	nop
8010399b:	c9                   	leave
8010399c:	c3                   	ret

8010399d <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
8010399d:	55                   	push   %ebp
8010399e:	89 e5                	mov    %esp,%ebp
801039a0:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039a3:	e8 10 00 00 00       	call   801039b8 <mycpu>
801039a8:	2d 80 6a 19 80       	sub    $0x80196a80,%eax
801039ad:	c1 f8 04             	sar    $0x4,%eax
801039b0:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039b6:	c9                   	leave
801039b7:	c3                   	ret

801039b8 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801039b8:	55                   	push   %ebp
801039b9:	89 e5                	mov    %esp,%ebp
801039bb:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF){
801039be:	e8 a5 ff ff ff       	call   80103968 <readeflags>
801039c3:	25 00 02 00 00       	and    $0x200,%eax
801039c8:	85 c0                	test   %eax,%eax
801039ca:	74 0d                	je     801039d9 <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
801039cc:	83 ec 0c             	sub    $0xc,%esp
801039cf:	68 b8 a4 10 80       	push   $0x8010a4b8
801039d4:	e8 d0 cb ff ff       	call   801005a9 <panic>
  }

  apicid = lapicid();
801039d9:	e8 1e f1 ff ff       	call   80102afc <lapicid>
801039de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801039e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039e8:	eb 2d                	jmp    80103a17 <mycpu+0x5f>
    if (cpus[i].apicid == apicid){
801039ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ed:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801039f3:	05 80 6a 19 80       	add    $0x80196a80,%eax
801039f8:	0f b6 00             	movzbl (%eax),%eax
801039fb:	0f b6 c0             	movzbl %al,%eax
801039fe:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103a01:	75 10                	jne    80103a13 <mycpu+0x5b>
      return &cpus[i];
80103a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a06:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103a0c:	05 80 6a 19 80       	add    $0x80196a80,%eax
80103a11:	eb 1b                	jmp    80103a2e <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
80103a13:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a17:	a1 40 6d 19 80       	mov    0x80196d40,%eax
80103a1c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103a1f:	7c c9                	jl     801039ea <mycpu+0x32>
    }
  }
  panic("unknown apicid\n");
80103a21:	83 ec 0c             	sub    $0xc,%esp
80103a24:	68 de a4 10 80       	push   $0x8010a4de
80103a29:	e8 7b cb ff ff       	call   801005a9 <panic>
}
80103a2e:	c9                   	leave
80103a2f:	c3                   	ret

80103a30 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103a36:	e8 82 10 00 00       	call   80104abd <pushcli>
  c = mycpu();
80103a3b:	e8 78 ff ff ff       	call   801039b8 <mycpu>
80103a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a46:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103a4f:	e8 b6 10 00 00       	call   80104b0a <popcli>
  return p;
80103a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103a57:	c9                   	leave
80103a58:	c3                   	ret

80103a59 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a59:	55                   	push   %ebp
80103a5a:	89 e5                	mov    %esp,%ebp
80103a5c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103a5f:	83 ec 0c             	sub    $0xc,%esp
80103a62:	68 00 42 19 80       	push   $0x80194200
80103a67:	e8 e6 0e 00 00       	call   80104952 <acquire>
80103a6c:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a6f:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103a76:	eb 0e                	jmp    80103a86 <allocproc+0x2d>
    if(p->state == UNUSED){
80103a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a7b:	8b 40 0c             	mov    0xc(%eax),%eax
80103a7e:	85 c0                	test   %eax,%eax
80103a80:	74 27                	je     80103aa9 <allocproc+0x50>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a82:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80103a86:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80103a8d:	72 e9                	jb     80103a78 <allocproc+0x1f>
      goto found;
    }

  release(&ptable.lock);
80103a8f:	83 ec 0c             	sub    $0xc,%esp
80103a92:	68 00 42 19 80       	push   $0x80194200
80103a97:	e8 24 0f 00 00       	call   801049c0 <release>
80103a9c:	83 c4 10             	add    $0x10,%esp
  return 0;
80103a9f:	b8 00 00 00 00       	mov    $0x0,%eax
80103aa4:	e9 b2 00 00 00       	jmp    80103b5b <allocproc+0x102>
      goto found;
80103aa9:	90                   	nop

found:
  p->state = EMBRYO;
80103aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aad:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80103ab4:	a1 00 f0 10 80       	mov    0x8010f000,%eax
80103ab9:	8d 50 01             	lea    0x1(%eax),%edx
80103abc:	89 15 00 f0 10 80    	mov    %edx,0x8010f000
80103ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ac5:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80103ac8:	83 ec 0c             	sub    $0xc,%esp
80103acb:	68 00 42 19 80       	push   $0x80194200
80103ad0:	e8 eb 0e 00 00       	call   801049c0 <release>
80103ad5:	83 c4 10             	add    $0x10,%esp


  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103ad8:	e8 cb ec ff ff       	call   801027a8 <kalloc>
80103add:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ae0:	89 42 08             	mov    %eax,0x8(%edx)
80103ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae6:	8b 40 08             	mov    0x8(%eax),%eax
80103ae9:	85 c0                	test   %eax,%eax
80103aeb:	75 11                	jne    80103afe <allocproc+0xa5>
    p->state = UNUSED;
80103aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80103af7:	b8 00 00 00 00       	mov    $0x0,%eax
80103afc:	eb 5d                	jmp    80103b5b <allocproc+0x102>
  }
  sp = p->kstack + KSTACKSIZE;
80103afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b01:	8b 40 08             	mov    0x8(%eax),%eax
80103b04:	05 00 10 00 00       	add    $0x1000,%eax
80103b09:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b0c:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80103b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b13:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103b16:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80103b19:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80103b1d:	ba be 5f 10 80       	mov    $0x80105fbe,%edx
80103b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b25:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80103b27:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80103b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103b31:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80103b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b37:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b3a:	83 ec 04             	sub    $0x4,%esp
80103b3d:	6a 14                	push   $0x14
80103b3f:	6a 00                	push   $0x0
80103b41:	50                   	push   %eax
80103b42:	e8 81 10 00 00       	call   80104bc8 <memset>
80103b47:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b4d:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b50:	ba 93 42 10 80       	mov    $0x80104293,%edx
80103b55:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80103b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103b5b:	c9                   	leave
80103b5c:	c3                   	ret

80103b5d <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103b5d:	55                   	push   %ebp
80103b5e:	89 e5                	mov    %esp,%ebp
80103b60:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103b63:	e8 f1 fe ff ff       	call   80103a59 <allocproc>
80103b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80103b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b6e:	a3 34 62 19 80       	mov    %eax,0x80196234
  if((p->pgdir = setupkvm()) == 0){
80103b73:	e8 9c 39 00 00       	call   80107514 <setupkvm>
80103b78:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b7b:	89 42 04             	mov    %eax,0x4(%edx)
80103b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b81:	8b 40 04             	mov    0x4(%eax),%eax
80103b84:	85 c0                	test   %eax,%eax
80103b86:	75 0d                	jne    80103b95 <userinit+0x38>
    panic("userinit: out of memory?");
80103b88:	83 ec 0c             	sub    $0xc,%esp
80103b8b:	68 ee a4 10 80       	push   $0x8010a4ee
80103b90:	e8 14 ca ff ff       	call   801005a9 <panic>
  }
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b95:	ba 2c 00 00 00       	mov    $0x2c,%edx
80103b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b9d:	8b 40 04             	mov    0x4(%eax),%eax
80103ba0:	83 ec 04             	sub    $0x4,%esp
80103ba3:	52                   	push   %edx
80103ba4:	68 ec f4 10 80       	push   $0x8010f4ec
80103ba9:	50                   	push   %eax
80103baa:	e8 22 3c 00 00       	call   801077d1 <inituvm>
80103baf:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80103bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb5:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80103bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbe:	8b 40 18             	mov    0x18(%eax),%eax
80103bc1:	83 ec 04             	sub    $0x4,%esp
80103bc4:	6a 4c                	push   $0x4c
80103bc6:	6a 00                	push   $0x0
80103bc8:	50                   	push   %eax
80103bc9:	e8 fa 0f 00 00       	call   80104bc8 <memset>
80103bce:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd4:	8b 40 18             	mov    0x18(%eax),%eax
80103bd7:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be0:	8b 40 18             	mov    0x18(%eax),%eax
80103be3:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bec:	8b 50 18             	mov    0x18(%eax),%edx
80103bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf2:	8b 40 18             	mov    0x18(%eax),%eax
80103bf5:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103bf9:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c00:	8b 50 18             	mov    0x18(%eax),%edx
80103c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c06:	8b 40 18             	mov    0x18(%eax),%eax
80103c09:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103c0d:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c14:	8b 40 18             	mov    0x18(%eax),%eax
80103c17:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c21:	8b 40 18             	mov    0x18(%eax),%eax
80103c24:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2e:	8b 40 18             	mov    0x18(%eax),%eax
80103c31:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c3b:	83 c0 6c             	add    $0x6c,%eax
80103c3e:	83 ec 04             	sub    $0x4,%esp
80103c41:	6a 10                	push   $0x10
80103c43:	68 07 a5 10 80       	push   $0x8010a507
80103c48:	50                   	push   %eax
80103c49:	e8 7d 11 00 00       	call   80104dcb <safestrcpy>
80103c4e:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80103c51:	83 ec 0c             	sub    $0xc,%esp
80103c54:	68 10 a5 10 80       	push   $0x8010a510
80103c59:	e8 c7 e8 ff ff       	call   80102525 <namei>
80103c5e:	83 c4 10             	add    $0x10,%esp
80103c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c64:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103c67:	83 ec 0c             	sub    $0xc,%esp
80103c6a:	68 00 42 19 80       	push   $0x80194200
80103c6f:	e8 de 0c 00 00       	call   80104952 <acquire>
80103c74:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
80103c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c7a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103c81:	83 ec 0c             	sub    $0xc,%esp
80103c84:	68 00 42 19 80       	push   $0x80194200
80103c89:	e8 32 0d 00 00       	call   801049c0 <release>
80103c8e:	83 c4 10             	add    $0x10,%esp
}
80103c91:	90                   	nop
80103c92:	c9                   	leave
80103c93:	c3                   	ret

80103c94 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103c94:	55                   	push   %ebp
80103c95:	89 e5                	mov    %esp,%ebp
80103c97:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
80103c9a:	e8 91 fd ff ff       	call   80103a30 <myproc>
80103c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80103ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ca5:	8b 00                	mov    (%eax),%eax
80103ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80103caa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103cae:	7e 2e                	jle    80103cde <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cb0:	8b 55 08             	mov    0x8(%ebp),%edx
80103cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb6:	01 c2                	add    %eax,%edx
80103cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cbb:	8b 40 04             	mov    0x4(%eax),%eax
80103cbe:	83 ec 04             	sub    $0x4,%esp
80103cc1:	52                   	push   %edx
80103cc2:	ff 75 f4             	push   -0xc(%ebp)
80103cc5:	50                   	push   %eax
80103cc6:	e8 43 3c 00 00       	call   8010790e <allocuvm>
80103ccb:	83 c4 10             	add    $0x10,%esp
80103cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cd5:	75 3b                	jne    80103d12 <growproc+0x7e>
      return -1;
80103cd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cdc:	eb 4f                	jmp    80103d2d <growproc+0x99>
  } else if(n < 0){
80103cde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103ce2:	79 2e                	jns    80103d12 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ce4:	8b 55 08             	mov    0x8(%ebp),%edx
80103ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cea:	01 c2                	add    %eax,%edx
80103cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cef:	8b 40 04             	mov    0x4(%eax),%eax
80103cf2:	83 ec 04             	sub    $0x4,%esp
80103cf5:	52                   	push   %edx
80103cf6:	ff 75 f4             	push   -0xc(%ebp)
80103cf9:	50                   	push   %eax
80103cfa:	e8 14 3d 00 00       	call   80107a13 <deallocuvm>
80103cff:	83 c4 10             	add    $0x10,%esp
80103d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d09:	75 07                	jne    80103d12 <growproc+0x7e>
      return -1;
80103d0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d10:	eb 1b                	jmp    80103d2d <growproc+0x99>
  }
  curproc->sz = sz;
80103d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d18:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80103d1a:	83 ec 0c             	sub    $0xc,%esp
80103d1d:	ff 75 f0             	push   -0x10(%ebp)
80103d20:	e8 0d 39 00 00       	call   80107632 <switchuvm>
80103d25:	83 c4 10             	add    $0x10,%esp
  return 0;
80103d28:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103d2d:	c9                   	leave
80103d2e:	c3                   	ret

80103d2f <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103d2f:	55                   	push   %ebp
80103d30:	89 e5                	mov    %esp,%ebp
80103d32:	57                   	push   %edi
80103d33:	56                   	push   %esi
80103d34:	53                   	push   %ebx
80103d35:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103d38:	e8 f3 fc ff ff       	call   80103a30 <myproc>
80103d3d:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80103d40:	e8 14 fd ff ff       	call   80103a59 <allocproc>
80103d45:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103d48:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80103d4c:	75 0a                	jne    80103d58 <fork+0x29>
    return -1;
80103d4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d53:	e9 48 01 00 00       	jmp    80103ea0 <fork+0x171>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d5b:	8b 10                	mov    (%eax),%edx
80103d5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d60:	8b 40 04             	mov    0x4(%eax),%eax
80103d63:	83 ec 08             	sub    $0x8,%esp
80103d66:	52                   	push   %edx
80103d67:	50                   	push   %eax
80103d68:	e8 44 3e 00 00       	call   80107bb1 <copyuvm>
80103d6d:	83 c4 10             	add    $0x10,%esp
80103d70:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103d73:	89 42 04             	mov    %eax,0x4(%edx)
80103d76:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d79:	8b 40 04             	mov    0x4(%eax),%eax
80103d7c:	85 c0                	test   %eax,%eax
80103d7e:	75 30                	jne    80103db0 <fork+0x81>
    kfree(np->kstack);
80103d80:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d83:	8b 40 08             	mov    0x8(%eax),%eax
80103d86:	83 ec 0c             	sub    $0xc,%esp
80103d89:	50                   	push   %eax
80103d8a:	e8 7f e9 ff ff       	call   8010270e <kfree>
80103d8f:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80103d92:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d95:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80103d9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d9f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80103da6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dab:	e9 f0 00 00 00       	jmp    80103ea0 <fork+0x171>
  }
  np->sz = curproc->sz;
80103db0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103db3:	8b 10                	mov    (%eax),%edx
80103db5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103db8:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80103dba:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103dbd:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103dc0:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80103dc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103dc6:	8b 48 18             	mov    0x18(%eax),%ecx
80103dc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103dcc:	8b 40 18             	mov    0x18(%eax),%eax
80103dcf:	89 c2                	mov    %eax,%edx
80103dd1:	89 cb                	mov    %ecx,%ebx
80103dd3:	b8 13 00 00 00       	mov    $0x13,%eax
80103dd8:	89 d7                	mov    %edx,%edi
80103dda:	89 de                	mov    %ebx,%esi
80103ddc:	89 c1                	mov    %eax,%ecx
80103dde:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103de0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103de3:	8b 40 18             	mov    0x18(%eax),%eax
80103de6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80103ded:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103df4:	eb 3b                	jmp    80103e31 <fork+0x102>
    if(curproc->ofile[i])
80103df6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103df9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dfc:	83 c2 08             	add    $0x8,%edx
80103dff:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e03:	85 c0                	test   %eax,%eax
80103e05:	74 26                	je     80103e2d <fork+0xfe>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e0d:	83 c2 08             	add    $0x8,%edx
80103e10:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e14:	83 ec 0c             	sub    $0xc,%esp
80103e17:	50                   	push   %eax
80103e18:	e8 37 d2 ff ff       	call   80101054 <filedup>
80103e1d:	83 c4 10             	add    $0x10,%esp
80103e20:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103e23:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e26:	83 c1 08             	add    $0x8,%ecx
80103e29:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80103e2d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103e31:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80103e35:	7e bf                	jle    80103df6 <fork+0xc7>
  np->cwd = idup(curproc->cwd);
80103e37:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e3a:	8b 40 68             	mov    0x68(%eax),%eax
80103e3d:	83 ec 0c             	sub    $0xc,%esp
80103e40:	50                   	push   %eax
80103e41:	e8 72 db ff ff       	call   801019b8 <idup>
80103e46:	83 c4 10             	add    $0x10,%esp
80103e49:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103e4c:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e52:	8d 50 6c             	lea    0x6c(%eax),%edx
80103e55:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e58:	83 c0 6c             	add    $0x6c,%eax
80103e5b:	83 ec 04             	sub    $0x4,%esp
80103e5e:	6a 10                	push   $0x10
80103e60:	52                   	push   %edx
80103e61:	50                   	push   %eax
80103e62:	e8 64 0f 00 00       	call   80104dcb <safestrcpy>
80103e67:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80103e6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e6d:	8b 40 10             	mov    0x10(%eax),%eax
80103e70:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80103e73:	83 ec 0c             	sub    $0xc,%esp
80103e76:	68 00 42 19 80       	push   $0x80194200
80103e7b:	e8 d2 0a 00 00       	call   80104952 <acquire>
80103e80:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80103e83:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e86:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103e8d:	83 ec 0c             	sub    $0xc,%esp
80103e90:	68 00 42 19 80       	push   $0x80194200
80103e95:	e8 26 0b 00 00       	call   801049c0 <release>
80103e9a:	83 c4 10             	add    $0x10,%esp

  return pid;
80103e9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80103ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ea3:	5b                   	pop    %ebx
80103ea4:	5e                   	pop    %esi
80103ea5:	5f                   	pop    %edi
80103ea6:	5d                   	pop    %ebp
80103ea7:	c3                   	ret

80103ea8 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103ea8:	55                   	push   %ebp
80103ea9:	89 e5                	mov    %esp,%ebp
80103eab:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80103eae:	e8 7d fb ff ff       	call   80103a30 <myproc>
80103eb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103eb6:	a1 34 62 19 80       	mov    0x80196234,%eax
80103ebb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103ebe:	75 0d                	jne    80103ecd <exit+0x25>
    panic("init exiting");
80103ec0:	83 ec 0c             	sub    $0xc,%esp
80103ec3:	68 12 a5 10 80       	push   $0x8010a512
80103ec8:	e8 dc c6 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103ecd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80103ed4:	eb 3f                	jmp    80103f15 <exit+0x6d>
    if(curproc->ofile[fd]){
80103ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ed9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103edc:	83 c2 08             	add    $0x8,%edx
80103edf:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103ee3:	85 c0                	test   %eax,%eax
80103ee5:	74 2a                	je     80103f11 <exit+0x69>
      fileclose(curproc->ofile[fd]);
80103ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103eea:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103eed:	83 c2 08             	add    $0x8,%edx
80103ef0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103ef4:	83 ec 0c             	sub    $0xc,%esp
80103ef7:	50                   	push   %eax
80103ef8:	e8 a8 d1 ff ff       	call   801010a5 <fileclose>
80103efd:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80103f00:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f03:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103f06:	83 c2 08             	add    $0x8,%edx
80103f09:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80103f10:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103f11:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80103f15:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80103f19:	7e bb                	jle    80103ed6 <exit+0x2e>
    }
  }

  begin_op();
80103f1b:	e8 1e f1 ff ff       	call   8010303e <begin_op>
  iput(curproc->cwd);
80103f20:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f23:	8b 40 68             	mov    0x68(%eax),%eax
80103f26:	83 ec 0c             	sub    $0xc,%esp
80103f29:	50                   	push   %eax
80103f2a:	e8 24 dc ff ff       	call   80101b53 <iput>
80103f2f:	83 c4 10             	add    $0x10,%esp
  end_op();
80103f32:	e8 93 f1 ff ff       	call   801030ca <end_op>
  curproc->cwd = 0;
80103f37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f3a:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103f41:	83 ec 0c             	sub    $0xc,%esp
80103f44:	68 00 42 19 80       	push   $0x80194200
80103f49:	e8 04 0a 00 00       	call   80104952 <acquire>
80103f4e:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f54:	8b 40 14             	mov    0x14(%eax),%eax
80103f57:	83 ec 0c             	sub    $0xc,%esp
80103f5a:	50                   	push   %eax
80103f5b:	e8 20 04 00 00       	call   80104380 <wakeup1>
80103f60:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f63:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103f6a:	eb 37                	jmp    80103fa3 <exit+0xfb>
    if(p->parent == curproc){
80103f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f6f:	8b 40 14             	mov    0x14(%eax),%eax
80103f72:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103f75:	75 28                	jne    80103f9f <exit+0xf7>
      p->parent = initproc;
80103f77:	8b 15 34 62 19 80    	mov    0x80196234,%edx
80103f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f80:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80103f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f86:	8b 40 0c             	mov    0xc(%eax),%eax
80103f89:	83 f8 05             	cmp    $0x5,%eax
80103f8c:	75 11                	jne    80103f9f <exit+0xf7>
        wakeup1(initproc);
80103f8e:	a1 34 62 19 80       	mov    0x80196234,%eax
80103f93:	83 ec 0c             	sub    $0xc,%esp
80103f96:	50                   	push   %eax
80103f97:	e8 e4 03 00 00       	call   80104380 <wakeup1>
80103f9c:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9f:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80103fa3:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80103faa:	72 c0                	jb     80103f6c <exit+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103faf:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80103fb6:	e8 e5 01 00 00       	call   801041a0 <sched>
  panic("zombie exit");
80103fbb:	83 ec 0c             	sub    $0xc,%esp
80103fbe:	68 1f a5 10 80       	push   $0x8010a51f
80103fc3:	e8 e1 c5 ff ff       	call   801005a9 <panic>

80103fc8 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103fc8:	55                   	push   %ebp
80103fc9:	89 e5                	mov    %esp,%ebp
80103fcb:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103fce:	e8 5d fa ff ff       	call   80103a30 <myproc>
80103fd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80103fd6:	83 ec 0c             	sub    $0xc,%esp
80103fd9:	68 00 42 19 80       	push   $0x80194200
80103fde:	e8 6f 09 00 00       	call   80104952 <acquire>
80103fe3:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103fe6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fed:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103ff4:	e9 a1 00 00 00       	jmp    8010409a <wait+0xd2>
      if(p->parent != curproc)
80103ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ffc:	8b 40 14             	mov    0x14(%eax),%eax
80103fff:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104002:	0f 85 8d 00 00 00    	jne    80104095 <wait+0xcd>
        continue;
      havekids = 1;
80104008:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
8010400f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104012:	8b 40 0c             	mov    0xc(%eax),%eax
80104015:	83 f8 05             	cmp    $0x5,%eax
80104018:	75 7c                	jne    80104096 <wait+0xce>
        // Found one.
        pid = p->pid;
8010401a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010401d:	8b 40 10             	mov    0x10(%eax),%eax
80104020:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104023:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104026:	8b 40 08             	mov    0x8(%eax),%eax
80104029:	83 ec 0c             	sub    $0xc,%esp
8010402c:	50                   	push   %eax
8010402d:	e8 dc e6 ff ff       	call   8010270e <kfree>
80104032:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104035:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104038:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
8010403f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104042:	8b 40 04             	mov    0x4(%eax),%eax
80104045:	83 ec 0c             	sub    $0xc,%esp
80104048:	50                   	push   %eax
80104049:	e8 89 3a 00 00       	call   80107ad7 <freevm>
8010404e:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104051:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104054:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010405b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010405e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104065:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104068:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010406c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406f:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104079:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104080:	83 ec 0c             	sub    $0xc,%esp
80104083:	68 00 42 19 80       	push   $0x80194200
80104088:	e8 33 09 00 00       	call   801049c0 <release>
8010408d:	83 c4 10             	add    $0x10,%esp
        return pid;
80104090:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104093:	eb 51                	jmp    801040e6 <wait+0x11e>
        continue;
80104095:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104096:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
8010409a:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
801040a1:	0f 82 52 ff ff ff    	jb     80103ff9 <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801040a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801040ab:	74 0a                	je     801040b7 <wait+0xef>
801040ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040b0:	8b 40 24             	mov    0x24(%eax),%eax
801040b3:	85 c0                	test   %eax,%eax
801040b5:	74 17                	je     801040ce <wait+0x106>
      release(&ptable.lock);
801040b7:	83 ec 0c             	sub    $0xc,%esp
801040ba:	68 00 42 19 80       	push   $0x80194200
801040bf:	e8 fc 08 00 00       	call   801049c0 <release>
801040c4:	83 c4 10             	add    $0x10,%esp
      return -1;
801040c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040cc:	eb 18                	jmp    801040e6 <wait+0x11e>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040ce:	83 ec 08             	sub    $0x8,%esp
801040d1:	68 00 42 19 80       	push   $0x80194200
801040d6:	ff 75 ec             	push   -0x14(%ebp)
801040d9:	e8 fb 01 00 00       	call   801042d9 <sleep>
801040de:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040e1:	e9 00 ff ff ff       	jmp    80103fe6 <wait+0x1e>
  }
}
801040e6:	c9                   	leave
801040e7:	c3                   	ret

801040e8 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801040e8:	55                   	push   %ebp
801040e9:	89 e5                	mov    %esp,%ebp
801040eb:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801040ee:	e8 c5 f8 ff ff       	call   801039b8 <mycpu>
801040f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
801040f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040f9:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104100:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104103:	e8 70 f8 ff ff       	call   80103978 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104108:	83 ec 0c             	sub    $0xc,%esp
8010410b:	68 00 42 19 80       	push   $0x80194200
80104110:	e8 3d 08 00 00       	call   80104952 <acquire>
80104115:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104118:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
8010411f:	eb 61                	jmp    80104182 <scheduler+0x9a>
      if(p->state != RUNNABLE)
80104121:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104124:	8b 40 0c             	mov    0xc(%eax),%eax
80104127:	83 f8 03             	cmp    $0x3,%eax
8010412a:	75 51                	jne    8010417d <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
8010412c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010412f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104132:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	ff 75 f4             	push   -0xc(%ebp)
8010413e:	e8 ef 34 00 00       	call   80107632 <switchuvm>
80104143:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104146:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104149:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104153:	8b 40 1c             	mov    0x1c(%eax),%eax
80104156:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104159:	83 c2 04             	add    $0x4,%edx
8010415c:	83 ec 08             	sub    $0x8,%esp
8010415f:	50                   	push   %eax
80104160:	52                   	push   %edx
80104161:	e8 d7 0c 00 00       	call   80104e3d <swtch>
80104166:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104169:	e8 ab 34 00 00       	call   80107619 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
8010416e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104171:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104178:	00 00 00 
8010417b:	eb 01                	jmp    8010417e <scheduler+0x96>
        continue;
8010417d:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010417e:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104182:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80104189:	72 96                	jb     80104121 <scheduler+0x39>
    }
    release(&ptable.lock);
8010418b:	83 ec 0c             	sub    $0xc,%esp
8010418e:	68 00 42 19 80       	push   $0x80194200
80104193:	e8 28 08 00 00       	call   801049c0 <release>
80104198:	83 c4 10             	add    $0x10,%esp
    sti();
8010419b:	e9 63 ff ff ff       	jmp    80104103 <scheduler+0x1b>

801041a0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
801041a6:	e8 85 f8 ff ff       	call   80103a30 <myproc>
801041ab:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
801041ae:	83 ec 0c             	sub    $0xc,%esp
801041b1:	68 00 42 19 80       	push   $0x80194200
801041b6:	e8 d2 08 00 00       	call   80104a8d <holding>
801041bb:	83 c4 10             	add    $0x10,%esp
801041be:	85 c0                	test   %eax,%eax
801041c0:	75 0d                	jne    801041cf <sched+0x2f>
    panic("sched ptable.lock");
801041c2:	83 ec 0c             	sub    $0xc,%esp
801041c5:	68 2b a5 10 80       	push   $0x8010a52b
801041ca:	e8 da c3 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli != 1)
801041cf:	e8 e4 f7 ff ff       	call   801039b8 <mycpu>
801041d4:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801041da:	83 f8 01             	cmp    $0x1,%eax
801041dd:	74 0d                	je     801041ec <sched+0x4c>
    panic("sched locks");
801041df:	83 ec 0c             	sub    $0xc,%esp
801041e2:	68 3d a5 10 80       	push   $0x8010a53d
801041e7:	e8 bd c3 ff ff       	call   801005a9 <panic>
  if(p->state == RUNNING)
801041ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ef:	8b 40 0c             	mov    0xc(%eax),%eax
801041f2:	83 f8 04             	cmp    $0x4,%eax
801041f5:	75 0d                	jne    80104204 <sched+0x64>
    panic("sched running");
801041f7:	83 ec 0c             	sub    $0xc,%esp
801041fa:	68 49 a5 10 80       	push   $0x8010a549
801041ff:	e8 a5 c3 ff ff       	call   801005a9 <panic>
  if(readeflags()&FL_IF)
80104204:	e8 5f f7 ff ff       	call   80103968 <readeflags>
80104209:	25 00 02 00 00       	and    $0x200,%eax
8010420e:	85 c0                	test   %eax,%eax
80104210:	74 0d                	je     8010421f <sched+0x7f>
    panic("sched interruptible");
80104212:	83 ec 0c             	sub    $0xc,%esp
80104215:	68 57 a5 10 80       	push   $0x8010a557
8010421a:	e8 8a c3 ff ff       	call   801005a9 <panic>
  intena = mycpu()->intena;
8010421f:	e8 94 f7 ff ff       	call   801039b8 <mycpu>
80104224:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010422a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
8010422d:	e8 86 f7 ff ff       	call   801039b8 <mycpu>
80104232:	8b 40 04             	mov    0x4(%eax),%eax
80104235:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104238:	83 c2 1c             	add    $0x1c,%edx
8010423b:	83 ec 08             	sub    $0x8,%esp
8010423e:	50                   	push   %eax
8010423f:	52                   	push   %edx
80104240:	e8 f8 0b 00 00       	call   80104e3d <swtch>
80104245:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104248:	e8 6b f7 ff ff       	call   801039b8 <mycpu>
8010424d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104250:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104256:	90                   	nop
80104257:	c9                   	leave
80104258:	c3                   	ret

80104259 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104259:	55                   	push   %ebp
8010425a:	89 e5                	mov    %esp,%ebp
8010425c:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010425f:	83 ec 0c             	sub    $0xc,%esp
80104262:	68 00 42 19 80       	push   $0x80194200
80104267:	e8 e6 06 00 00       	call   80104952 <acquire>
8010426c:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
8010426f:	e8 bc f7 ff ff       	call   80103a30 <myproc>
80104274:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010427b:	e8 20 ff ff ff       	call   801041a0 <sched>
  release(&ptable.lock);
80104280:	83 ec 0c             	sub    $0xc,%esp
80104283:	68 00 42 19 80       	push   $0x80194200
80104288:	e8 33 07 00 00       	call   801049c0 <release>
8010428d:	83 c4 10             	add    $0x10,%esp
}
80104290:	90                   	nop
80104291:	c9                   	leave
80104292:	c3                   	ret

80104293 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104293:	55                   	push   %ebp
80104294:	89 e5                	mov    %esp,%ebp
80104296:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104299:	83 ec 0c             	sub    $0xc,%esp
8010429c:	68 00 42 19 80       	push   $0x80194200
801042a1:	e8 1a 07 00 00       	call   801049c0 <release>
801042a6:	83 c4 10             	add    $0x10,%esp

  if (first) {
801042a9:	a1 04 f0 10 80       	mov    0x8010f004,%eax
801042ae:	85 c0                	test   %eax,%eax
801042b0:	74 24                	je     801042d6 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801042b2:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
801042b9:	00 00 00 
    iinit(ROOTDEV);
801042bc:	83 ec 0c             	sub    $0xc,%esp
801042bf:	6a 01                	push   $0x1
801042c1:	e8 bb d3 ff ff       	call   80101681 <iinit>
801042c6:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
801042c9:	83 ec 0c             	sub    $0xc,%esp
801042cc:	6a 01                	push   $0x1
801042ce:	e8 4c eb ff ff       	call   80102e1f <initlog>
801042d3:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801042d6:	90                   	nop
801042d7:	c9                   	leave
801042d8:	c3                   	ret

801042d9 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801042d9:	55                   	push   %ebp
801042da:	89 e5                	mov    %esp,%ebp
801042dc:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
801042df:	e8 4c f7 ff ff       	call   80103a30 <myproc>
801042e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
801042e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042eb:	75 0d                	jne    801042fa <sleep+0x21>
    panic("sleep");
801042ed:	83 ec 0c             	sub    $0xc,%esp
801042f0:	68 6b a5 10 80       	push   $0x8010a56b
801042f5:	e8 af c2 ff ff       	call   801005a9 <panic>

  if(lk == 0)
801042fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801042fe:	75 0d                	jne    8010430d <sleep+0x34>
    panic("sleep without lk");
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	68 71 a5 10 80       	push   $0x8010a571
80104308:	e8 9c c2 ff ff       	call   801005a9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010430d:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
80104314:	74 1e                	je     80104334 <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104316:	83 ec 0c             	sub    $0xc,%esp
80104319:	68 00 42 19 80       	push   $0x80194200
8010431e:	e8 2f 06 00 00       	call   80104952 <acquire>
80104323:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104326:	83 ec 0c             	sub    $0xc,%esp
80104329:	ff 75 0c             	push   0xc(%ebp)
8010432c:	e8 8f 06 00 00       	call   801049c0 <release>
80104331:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80104334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104337:	8b 55 08             	mov    0x8(%ebp),%edx
8010433a:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
8010433d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104340:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104347:	e8 54 fe ff ff       	call   801041a0 <sched>

  // Tidy up.
  p->chan = 0;
8010434c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434f:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104356:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
8010435d:	74 1e                	je     8010437d <sleep+0xa4>
    release(&ptable.lock);
8010435f:	83 ec 0c             	sub    $0xc,%esp
80104362:	68 00 42 19 80       	push   $0x80194200
80104367:	e8 54 06 00 00       	call   801049c0 <release>
8010436c:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
8010436f:	83 ec 0c             	sub    $0xc,%esp
80104372:	ff 75 0c             	push   0xc(%ebp)
80104375:	e8 d8 05 00 00       	call   80104952 <acquire>
8010437a:	83 c4 10             	add    $0x10,%esp
  }
}
8010437d:	90                   	nop
8010437e:	c9                   	leave
8010437f:	c3                   	ret

80104380 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104386:	c7 45 fc 34 42 19 80 	movl   $0x80194234,-0x4(%ebp)
8010438d:	eb 24                	jmp    801043b3 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
8010438f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104392:	8b 40 0c             	mov    0xc(%eax),%eax
80104395:	83 f8 02             	cmp    $0x2,%eax
80104398:	75 15                	jne    801043af <wakeup1+0x2f>
8010439a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010439d:	8b 40 20             	mov    0x20(%eax),%eax
801043a0:	39 45 08             	cmp    %eax,0x8(%ebp)
801043a3:	75 0a                	jne    801043af <wakeup1+0x2f>
      p->state = RUNNABLE;
801043a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801043a8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043af:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
801043b3:	81 7d fc 34 62 19 80 	cmpl   $0x80196234,-0x4(%ebp)
801043ba:	72 d3                	jb     8010438f <wakeup1+0xf>
}
801043bc:	90                   	nop
801043bd:	90                   	nop
801043be:	c9                   	leave
801043bf:	c3                   	ret

801043c0 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
801043c6:	83 ec 0c             	sub    $0xc,%esp
801043c9:	68 00 42 19 80       	push   $0x80194200
801043ce:	e8 7f 05 00 00       	call   80104952 <acquire>
801043d3:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
801043d6:	83 ec 0c             	sub    $0xc,%esp
801043d9:	ff 75 08             	push   0x8(%ebp)
801043dc:	e8 9f ff ff ff       	call   80104380 <wakeup1>
801043e1:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801043e4:	83 ec 0c             	sub    $0xc,%esp
801043e7:	68 00 42 19 80       	push   $0x80194200
801043ec:	e8 cf 05 00 00       	call   801049c0 <release>
801043f1:	83 c4 10             	add    $0x10,%esp
}
801043f4:	90                   	nop
801043f5:	c9                   	leave
801043f6:	c3                   	ret

801043f7 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043f7:	55                   	push   %ebp
801043f8:	89 e5                	mov    %esp,%ebp
801043fa:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801043fd:	83 ec 0c             	sub    $0xc,%esp
80104400:	68 00 42 19 80       	push   $0x80194200
80104405:	e8 48 05 00 00       	call   80104952 <acquire>
8010440a:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010440d:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104414:	eb 45                	jmp    8010445b <kill+0x64>
    if(p->pid == pid){
80104416:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104419:	8b 40 10             	mov    0x10(%eax),%eax
8010441c:	39 45 08             	cmp    %eax,0x8(%ebp)
8010441f:	75 36                	jne    80104457 <kill+0x60>
      p->killed = 1;
80104421:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104424:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010442b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010442e:	8b 40 0c             	mov    0xc(%eax),%eax
80104431:	83 f8 02             	cmp    $0x2,%eax
80104434:	75 0a                	jne    80104440 <kill+0x49>
        p->state = RUNNABLE;
80104436:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104439:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104440:	83 ec 0c             	sub    $0xc,%esp
80104443:	68 00 42 19 80       	push   $0x80194200
80104448:	e8 73 05 00 00       	call   801049c0 <release>
8010444d:	83 c4 10             	add    $0x10,%esp
      return 0;
80104450:	b8 00 00 00 00       	mov    $0x0,%eax
80104455:	eb 22                	jmp    80104479 <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104457:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
8010445b:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80104462:	72 b2                	jb     80104416 <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104464:	83 ec 0c             	sub    $0xc,%esp
80104467:	68 00 42 19 80       	push   $0x80194200
8010446c:	e8 4f 05 00 00       	call   801049c0 <release>
80104471:	83 c4 10             	add    $0x10,%esp
  return -1;
80104474:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104479:	c9                   	leave
8010447a:	c3                   	ret

8010447b <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010447b:	55                   	push   %ebp
8010447c:	89 e5                	mov    %esp,%ebp
8010447e:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104481:	c7 45 f0 34 42 19 80 	movl   $0x80194234,-0x10(%ebp)
80104488:	e9 d7 00 00 00       	jmp    80104564 <procdump+0xe9>
    if(p->state == UNUSED)
8010448d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104490:	8b 40 0c             	mov    0xc(%eax),%eax
80104493:	85 c0                	test   %eax,%eax
80104495:	0f 84 c4 00 00 00    	je     8010455f <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010449b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010449e:	8b 40 0c             	mov    0xc(%eax),%eax
801044a1:	83 f8 05             	cmp    $0x5,%eax
801044a4:	77 23                	ja     801044c9 <procdump+0x4e>
801044a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044a9:	8b 40 0c             	mov    0xc(%eax),%eax
801044ac:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
801044b3:	85 c0                	test   %eax,%eax
801044b5:	74 12                	je     801044c9 <procdump+0x4e>
      state = states[p->state];
801044b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044ba:	8b 40 0c             	mov    0xc(%eax),%eax
801044bd:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
801044c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801044c7:	eb 07                	jmp    801044d0 <procdump+0x55>
    else
      state = "???";
801044c9:	c7 45 ec 82 a5 10 80 	movl   $0x8010a582,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
801044d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044d3:	8d 50 6c             	lea    0x6c(%eax),%edx
801044d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044d9:	8b 40 10             	mov    0x10(%eax),%eax
801044dc:	52                   	push   %edx
801044dd:	ff 75 ec             	push   -0x14(%ebp)
801044e0:	50                   	push   %eax
801044e1:	68 86 a5 10 80       	push   $0x8010a586
801044e6:	e8 09 bf ff ff       	call   801003f4 <cprintf>
801044eb:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
801044ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044f1:	8b 40 0c             	mov    0xc(%eax),%eax
801044f4:	83 f8 02             	cmp    $0x2,%eax
801044f7:	75 54                	jne    8010454d <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044fc:	8b 40 1c             	mov    0x1c(%eax),%eax
801044ff:	8b 40 0c             	mov    0xc(%eax),%eax
80104502:	83 c0 08             	add    $0x8,%eax
80104505:	89 c2                	mov    %eax,%edx
80104507:	83 ec 08             	sub    $0x8,%esp
8010450a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010450d:	50                   	push   %eax
8010450e:	52                   	push   %edx
8010450f:	e8 fe 04 00 00       	call   80104a12 <getcallerpcs>
80104514:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104517:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010451e:	eb 1c                	jmp    8010453c <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104520:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104523:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104527:	83 ec 08             	sub    $0x8,%esp
8010452a:	50                   	push   %eax
8010452b:	68 8f a5 10 80       	push   $0x8010a58f
80104530:	e8 bf be ff ff       	call   801003f4 <cprintf>
80104535:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104538:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010453c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104540:	7f 0b                	jg     8010454d <procdump+0xd2>
80104542:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104545:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104549:	85 c0                	test   %eax,%eax
8010454b:	75 d3                	jne    80104520 <procdump+0xa5>
    }
    cprintf("\n");
8010454d:	83 ec 0c             	sub    $0xc,%esp
80104550:	68 93 a5 10 80       	push   $0x8010a593
80104555:	e8 9a be ff ff       	call   801003f4 <cprintf>
8010455a:	83 c4 10             	add    $0x10,%esp
8010455d:	eb 01                	jmp    80104560 <procdump+0xe5>
      continue;
8010455f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104560:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
80104564:	81 7d f0 34 62 19 80 	cmpl   $0x80196234,-0x10(%ebp)
8010456b:	0f 82 1c ff ff ff    	jb     8010448d <procdump+0x12>
  }
}
80104571:	90                   	nop
80104572:	90                   	nop
80104573:	c9                   	leave
80104574:	c3                   	ret

80104575 <exit2>:

void
exit2(int status)
{
80104575:	55                   	push   %ebp
80104576:	89 e5                	mov    %esp,%ebp
80104578:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
8010457b:	e8 b0 f4 ff ff       	call   80103a30 <myproc>
80104580:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80104583:	a1 34 62 19 80       	mov    0x80196234,%eax
80104588:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010458b:	75 0d                	jne    8010459a <exit2+0x25>
    panic("init exiting");
8010458d:	83 ec 0c             	sub    $0xc,%esp
80104590:	68 12 a5 10 80       	push   $0x8010a512
80104595:	e8 0f c0 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010459a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801045a1:	eb 3f                	jmp    801045e2 <exit2+0x6d>
    if(curproc->ofile[fd]){
801045a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045a9:	83 c2 08             	add    $0x8,%edx
801045ac:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045b0:	85 c0                	test   %eax,%eax
801045b2:	74 2a                	je     801045de <exit2+0x69>
      fileclose(curproc->ofile[fd]);
801045b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045ba:	83 c2 08             	add    $0x8,%edx
801045bd:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045c1:	83 ec 0c             	sub    $0xc,%esp
801045c4:	50                   	push   %eax
801045c5:	e8 db ca ff ff       	call   801010a5 <fileclose>
801045ca:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
801045cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045d3:	83 c2 08             	add    $0x8,%edx
801045d6:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801045dd:	00 
  for(fd = 0; fd < NOFILE; fd++){
801045de:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801045e2:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801045e6:	7e bb                	jle    801045a3 <exit2+0x2e>
    }
  }

  begin_op();
801045e8:	e8 51 ea ff ff       	call   8010303e <begin_op>
  iput(curproc->cwd);
801045ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045f0:	8b 40 68             	mov    0x68(%eax),%eax
801045f3:	83 ec 0c             	sub    $0xc,%esp
801045f6:	50                   	push   %eax
801045f7:	e8 57 d5 ff ff       	call   80101b53 <iput>
801045fc:	83 c4 10             	add    $0x10,%esp
  end_op();
801045ff:	e8 c6 ea ff ff       	call   801030ca <end_op>
  curproc->cwd = 0;
80104604:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104607:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
8010460e:	83 ec 0c             	sub    $0xc,%esp
80104611:	68 00 42 19 80       	push   $0x80194200
80104616:	e8 37 03 00 00       	call   80104952 <acquire>
8010461b:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
8010461e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104621:	8b 40 14             	mov    0x14(%eax),%eax
80104624:	83 ec 0c             	sub    $0xc,%esp
80104627:	50                   	push   %eax
80104628:	e8 53 fd ff ff       	call   80104380 <wakeup1>
8010462d:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104630:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104637:	eb 37                	jmp    80104670 <exit2+0xfb>
    if(p->parent == curproc){
80104639:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463c:	8b 40 14             	mov    0x14(%eax),%eax
8010463f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104642:	75 28                	jne    8010466c <exit2+0xf7>
      p->parent = initproc;
80104644:	8b 15 34 62 19 80    	mov    0x80196234,%edx
8010464a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010464d:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104650:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104653:	8b 40 0c             	mov    0xc(%eax),%eax
80104656:	83 f8 05             	cmp    $0x5,%eax
80104659:	75 11                	jne    8010466c <exit2+0xf7>
        wakeup1(initproc);
8010465b:	a1 34 62 19 80       	mov    0x80196234,%eax
80104660:	83 ec 0c             	sub    $0xc,%esp
80104663:	50                   	push   %eax
80104664:	e8 17 fd ff ff       	call   80104380 <wakeup1>
80104669:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010466c:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104670:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
80104677:	72 c0                	jb     80104639 <exit2+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->xstate = status;
80104679:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010467c:	8b 55 08             	mov    0x8(%ebp),%edx
8010467f:	89 50 7c             	mov    %edx,0x7c(%eax)
  curproc->state = ZOMBIE;
80104682:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104685:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010468c:	e8 0f fb ff ff       	call   801041a0 <sched>
  panic("zombie exit");
80104691:	83 ec 0c             	sub    $0xc,%esp
80104694:	68 1f a5 10 80       	push   $0x8010a51f
80104699:	e8 0b bf ff ff       	call   801005a9 <panic>

8010469e <wait2>:
}

int
wait2(int *status)
{
8010469e:	55                   	push   %ebp
8010469f:	89 e5                	mov    %esp,%ebp
801046a1:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
801046a4:	e8 87 f3 ff ff       	call   80103a30 <myproc>
801046a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
801046ac:	83 ec 0c             	sub    $0xc,%esp
801046af:	68 00 42 19 80       	push   $0x80194200
801046b4:	e8 99 02 00 00       	call   80104952 <acquire>
801046b9:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801046bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046c3:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801046ca:	e9 b6 00 00 00       	jmp    80104785 <wait2+0xe7>
      if(p->parent != curproc)
801046cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d2:	8b 40 14             	mov    0x14(%eax),%eax
801046d5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801046d8:	0f 85 a2 00 00 00    	jne    80104780 <wait2+0xe2>
        continue;
      havekids = 1;
801046de:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801046e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e8:	8b 40 0c             	mov    0xc(%eax),%eax
801046eb:	83 f8 05             	cmp    $0x5,%eax
801046ee:	0f 85 8d 00 00 00    	jne    80104781 <wait2+0xe3>
        // Found one.
        pid = p->pid;
801046f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f7:	8b 40 10             	mov    0x10(%eax),%eax
801046fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
801046fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104700:	8b 40 08             	mov    0x8(%eax),%eax
80104703:	83 ec 0c             	sub    $0xc,%esp
80104706:	50                   	push   %eax
80104707:	e8 02 e0 ff ff       	call   8010270e <kfree>
8010470c:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
8010470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104712:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104719:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010471c:	8b 40 04             	mov    0x4(%eax),%eax
8010471f:	83 ec 0c             	sub    $0xc,%esp
80104722:	50                   	push   %eax
80104723:	e8 af 33 00 00       	call   80107ad7 <freevm>
80104728:	83 c4 10             	add    $0x10,%esp

        if(status != 0)
8010472b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010472f:	74 0b                	je     8010473c <wait2+0x9e>
          *status = p->xstate;
80104731:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104734:	8b 50 7c             	mov    0x7c(%eax),%edx
80104737:	8b 45 08             	mov    0x8(%ebp),%eax
8010473a:	89 10                	mov    %edx,(%eax)

        p->pid = 0;
8010473c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010473f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104746:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104749:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104750:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104753:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010475a:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104761:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104764:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
8010476b:	83 ec 0c             	sub    $0xc,%esp
8010476e:	68 00 42 19 80       	push   $0x80194200
80104773:	e8 48 02 00 00       	call   801049c0 <release>
80104778:	83 c4 10             	add    $0x10,%esp
        return pid;
8010477b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010477e:	eb 51                	jmp    801047d1 <wait2+0x133>
        continue;
80104780:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104781:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104785:	81 7d f4 34 62 19 80 	cmpl   $0x80196234,-0xc(%ebp)
8010478c:	0f 82 3d ff ff ff    	jb     801046cf <wait2+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104792:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104796:	74 0a                	je     801047a2 <wait2+0x104>
80104798:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010479b:	8b 40 24             	mov    0x24(%eax),%eax
8010479e:	85 c0                	test   %eax,%eax
801047a0:	74 17                	je     801047b9 <wait2+0x11b>
      release(&ptable.lock);
801047a2:	83 ec 0c             	sub    $0xc,%esp
801047a5:	68 00 42 19 80       	push   $0x80194200
801047aa:	e8 11 02 00 00       	call   801049c0 <release>
801047af:	83 c4 10             	add    $0x10,%esp
      return -1;
801047b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047b7:	eb 18                	jmp    801047d1 <wait2+0x133>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801047b9:	83 ec 08             	sub    $0x8,%esp
801047bc:	68 00 42 19 80       	push   $0x80194200
801047c1:	ff 75 ec             	push   -0x14(%ebp)
801047c4:	e8 10 fb ff ff       	call   801042d9 <sleep>
801047c9:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801047cc:	e9 eb fe ff ff       	jmp    801046bc <wait2+0x1e>
  }
}
801047d1:	c9                   	leave
801047d2:	c3                   	ret

801047d3 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801047d3:	55                   	push   %ebp
801047d4:	89 e5                	mov    %esp,%ebp
801047d6:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
801047d9:	8b 45 08             	mov    0x8(%ebp),%eax
801047dc:	83 c0 04             	add    $0x4,%eax
801047df:	83 ec 08             	sub    $0x8,%esp
801047e2:	68 bf a5 10 80       	push   $0x8010a5bf
801047e7:	50                   	push   %eax
801047e8:	e8 43 01 00 00       	call   80104930 <initlock>
801047ed:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
801047f0:	8b 45 08             	mov    0x8(%ebp),%eax
801047f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801047f6:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
801047f9:	8b 45 08             	mov    0x8(%ebp),%eax
801047fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104802:	8b 45 08             	mov    0x8(%ebp),%eax
80104805:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
8010480c:	90                   	nop
8010480d:	c9                   	leave
8010480e:	c3                   	ret

8010480f <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
8010480f:	55                   	push   %ebp
80104810:	89 e5                	mov    %esp,%ebp
80104812:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104815:	8b 45 08             	mov    0x8(%ebp),%eax
80104818:	83 c0 04             	add    $0x4,%eax
8010481b:	83 ec 0c             	sub    $0xc,%esp
8010481e:	50                   	push   %eax
8010481f:	e8 2e 01 00 00       	call   80104952 <acquire>
80104824:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104827:	eb 15                	jmp    8010483e <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80104829:	8b 45 08             	mov    0x8(%ebp),%eax
8010482c:	83 c0 04             	add    $0x4,%eax
8010482f:	83 ec 08             	sub    $0x8,%esp
80104832:	50                   	push   %eax
80104833:	ff 75 08             	push   0x8(%ebp)
80104836:	e8 9e fa ff ff       	call   801042d9 <sleep>
8010483b:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
8010483e:	8b 45 08             	mov    0x8(%ebp),%eax
80104841:	8b 00                	mov    (%eax),%eax
80104843:	85 c0                	test   %eax,%eax
80104845:	75 e2                	jne    80104829 <acquiresleep+0x1a>
  }
  lk->locked = 1;
80104847:	8b 45 08             	mov    0x8(%ebp),%eax
8010484a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104850:	e8 db f1 ff ff       	call   80103a30 <myproc>
80104855:	8b 50 10             	mov    0x10(%eax),%edx
80104858:	8b 45 08             	mov    0x8(%ebp),%eax
8010485b:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
8010485e:	8b 45 08             	mov    0x8(%ebp),%eax
80104861:	83 c0 04             	add    $0x4,%eax
80104864:	83 ec 0c             	sub    $0xc,%esp
80104867:	50                   	push   %eax
80104868:	e8 53 01 00 00       	call   801049c0 <release>
8010486d:	83 c4 10             	add    $0x10,%esp
}
80104870:	90                   	nop
80104871:	c9                   	leave
80104872:	c3                   	ret

80104873 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104873:	55                   	push   %ebp
80104874:	89 e5                	mov    %esp,%ebp
80104876:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104879:	8b 45 08             	mov    0x8(%ebp),%eax
8010487c:	83 c0 04             	add    $0x4,%eax
8010487f:	83 ec 0c             	sub    $0xc,%esp
80104882:	50                   	push   %eax
80104883:	e8 ca 00 00 00       	call   80104952 <acquire>
80104888:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
8010488b:	8b 45 08             	mov    0x8(%ebp),%eax
8010488e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104894:	8b 45 08             	mov    0x8(%ebp),%eax
80104897:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
8010489e:	83 ec 0c             	sub    $0xc,%esp
801048a1:	ff 75 08             	push   0x8(%ebp)
801048a4:	e8 17 fb ff ff       	call   801043c0 <wakeup>
801048a9:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
801048ac:	8b 45 08             	mov    0x8(%ebp),%eax
801048af:	83 c0 04             	add    $0x4,%eax
801048b2:	83 ec 0c             	sub    $0xc,%esp
801048b5:	50                   	push   %eax
801048b6:	e8 05 01 00 00       	call   801049c0 <release>
801048bb:	83 c4 10             	add    $0x10,%esp
}
801048be:	90                   	nop
801048bf:	c9                   	leave
801048c0:	c3                   	ret

801048c1 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801048c1:	55                   	push   %ebp
801048c2:	89 e5                	mov    %esp,%ebp
801048c4:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
801048c7:	8b 45 08             	mov    0x8(%ebp),%eax
801048ca:	83 c0 04             	add    $0x4,%eax
801048cd:	83 ec 0c             	sub    $0xc,%esp
801048d0:	50                   	push   %eax
801048d1:	e8 7c 00 00 00       	call   80104952 <acquire>
801048d6:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
801048d9:	8b 45 08             	mov    0x8(%ebp),%eax
801048dc:	8b 00                	mov    (%eax),%eax
801048de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
801048e1:	8b 45 08             	mov    0x8(%ebp),%eax
801048e4:	83 c0 04             	add    $0x4,%eax
801048e7:	83 ec 0c             	sub    $0xc,%esp
801048ea:	50                   	push   %eax
801048eb:	e8 d0 00 00 00       	call   801049c0 <release>
801048f0:	83 c4 10             	add    $0x10,%esp
  return r;
801048f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801048f6:	c9                   	leave
801048f7:	c3                   	ret

801048f8 <readeflags>:
{
801048f8:	55                   	push   %ebp
801048f9:	89 e5                	mov    %esp,%ebp
801048fb:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048fe:	9c                   	pushf
801048ff:	58                   	pop    %eax
80104900:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104903:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104906:	c9                   	leave
80104907:	c3                   	ret

80104908 <cli>:
{
80104908:	55                   	push   %ebp
80104909:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010490b:	fa                   	cli
}
8010490c:	90                   	nop
8010490d:	5d                   	pop    %ebp
8010490e:	c3                   	ret

8010490f <sti>:
{
8010490f:	55                   	push   %ebp
80104910:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104912:	fb                   	sti
}
80104913:	90                   	nop
80104914:	5d                   	pop    %ebp
80104915:	c3                   	ret

80104916 <xchg>:
{
80104916:	55                   	push   %ebp
80104917:	89 e5                	mov    %esp,%ebp
80104919:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
8010491c:	8b 55 08             	mov    0x8(%ebp),%edx
8010491f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104922:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104925:	f0 87 02             	lock xchg %eax,(%edx)
80104928:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
8010492b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010492e:	c9                   	leave
8010492f:	c3                   	ret

80104930 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104933:	8b 45 08             	mov    0x8(%ebp),%eax
80104936:	8b 55 0c             	mov    0xc(%ebp),%edx
80104939:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010493c:	8b 45 08             	mov    0x8(%ebp),%eax
8010493f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104945:	8b 45 08             	mov    0x8(%ebp),%eax
80104948:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010494f:	90                   	nop
80104950:	5d                   	pop    %ebp
80104951:	c3                   	ret

80104952 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104952:	55                   	push   %ebp
80104953:	89 e5                	mov    %esp,%ebp
80104955:	53                   	push   %ebx
80104956:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104959:	e8 5f 01 00 00       	call   80104abd <pushcli>
  if(holding(lk)){
8010495e:	8b 45 08             	mov    0x8(%ebp),%eax
80104961:	83 ec 0c             	sub    $0xc,%esp
80104964:	50                   	push   %eax
80104965:	e8 23 01 00 00       	call   80104a8d <holding>
8010496a:	83 c4 10             	add    $0x10,%esp
8010496d:	85 c0                	test   %eax,%eax
8010496f:	74 0d                	je     8010497e <acquire+0x2c>
    panic("acquire");
80104971:	83 ec 0c             	sub    $0xc,%esp
80104974:	68 ca a5 10 80       	push   $0x8010a5ca
80104979:	e8 2b bc ff ff       	call   801005a9 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
8010497e:	90                   	nop
8010497f:	8b 45 08             	mov    0x8(%ebp),%eax
80104982:	83 ec 08             	sub    $0x8,%esp
80104985:	6a 01                	push   $0x1
80104987:	50                   	push   %eax
80104988:	e8 89 ff ff ff       	call   80104916 <xchg>
8010498d:	83 c4 10             	add    $0x10,%esp
80104990:	85 c0                	test   %eax,%eax
80104992:	75 eb                	jne    8010497f <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104994:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104999:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010499c:	e8 17 f0 ff ff       	call   801039b8 <mycpu>
801049a1:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801049a4:	8b 45 08             	mov    0x8(%ebp),%eax
801049a7:	83 c0 0c             	add    $0xc,%eax
801049aa:	83 ec 08             	sub    $0x8,%esp
801049ad:	50                   	push   %eax
801049ae:	8d 45 08             	lea    0x8(%ebp),%eax
801049b1:	50                   	push   %eax
801049b2:	e8 5b 00 00 00       	call   80104a12 <getcallerpcs>
801049b7:	83 c4 10             	add    $0x10,%esp
}
801049ba:	90                   	nop
801049bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049be:	c9                   	leave
801049bf:	c3                   	ret

801049c0 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801049c6:	83 ec 0c             	sub    $0xc,%esp
801049c9:	ff 75 08             	push   0x8(%ebp)
801049cc:	e8 bc 00 00 00       	call   80104a8d <holding>
801049d1:	83 c4 10             	add    $0x10,%esp
801049d4:	85 c0                	test   %eax,%eax
801049d6:	75 0d                	jne    801049e5 <release+0x25>
    panic("release");
801049d8:	83 ec 0c             	sub    $0xc,%esp
801049db:	68 d2 a5 10 80       	push   $0x8010a5d2
801049e0:	e8 c4 bb ff ff       	call   801005a9 <panic>

  lk->pcs[0] = 0;
801049e5:	8b 45 08             	mov    0x8(%ebp),%eax
801049e8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801049ef:	8b 45 08             	mov    0x8(%ebp),%eax
801049f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801049f9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801049fe:	8b 45 08             	mov    0x8(%ebp),%eax
80104a01:	8b 55 08             	mov    0x8(%ebp),%edx
80104a04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104a0a:	e8 fb 00 00 00       	call   80104b0a <popcli>
}
80104a0f:	90                   	nop
80104a10:	c9                   	leave
80104a11:	c3                   	ret

80104a12 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a12:	55                   	push   %ebp
80104a13:	89 e5                	mov    %esp,%ebp
80104a15:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a18:	8b 45 08             	mov    0x8(%ebp),%eax
80104a1b:	83 e8 08             	sub    $0x8,%eax
80104a1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104a21:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104a28:	eb 38                	jmp    80104a62 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a2a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104a2e:	74 53                	je     80104a83 <getcallerpcs+0x71>
80104a30:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104a37:	76 4a                	jbe    80104a83 <getcallerpcs+0x71>
80104a39:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104a3d:	74 44                	je     80104a83 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104a42:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104a49:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a4c:	01 c2                	add    %eax,%edx
80104a4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a51:	8b 40 04             	mov    0x4(%eax),%eax
80104a54:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104a56:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a59:	8b 00                	mov    (%eax),%eax
80104a5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104a5e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104a62:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104a66:	7e c2                	jle    80104a2a <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80104a68:	eb 19                	jmp    80104a83 <getcallerpcs+0x71>
    pcs[i] = 0;
80104a6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104a6d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104a74:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a77:	01 d0                	add    %edx,%eax
80104a79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104a7f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104a83:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104a87:	7e e1                	jle    80104a6a <getcallerpcs+0x58>
}
80104a89:	90                   	nop
80104a8a:	90                   	nop
80104a8b:	c9                   	leave
80104a8c:	c3                   	ret

80104a8d <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104a8d:	55                   	push   %ebp
80104a8e:	89 e5                	mov    %esp,%ebp
80104a90:	53                   	push   %ebx
80104a91:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104a94:	8b 45 08             	mov    0x8(%ebp),%eax
80104a97:	8b 00                	mov    (%eax),%eax
80104a99:	85 c0                	test   %eax,%eax
80104a9b:	74 16                	je     80104ab3 <holding+0x26>
80104a9d:	8b 45 08             	mov    0x8(%ebp),%eax
80104aa0:	8b 58 08             	mov    0x8(%eax),%ebx
80104aa3:	e8 10 ef ff ff       	call   801039b8 <mycpu>
80104aa8:	39 c3                	cmp    %eax,%ebx
80104aaa:	75 07                	jne    80104ab3 <holding+0x26>
80104aac:	b8 01 00 00 00       	mov    $0x1,%eax
80104ab1:	eb 05                	jmp    80104ab8 <holding+0x2b>
80104ab3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ab8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104abb:	c9                   	leave
80104abc:	c3                   	ret

80104abd <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104abd:	55                   	push   %ebp
80104abe:	89 e5                	mov    %esp,%ebp
80104ac0:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104ac3:	e8 30 fe ff ff       	call   801048f8 <readeflags>
80104ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104acb:	e8 38 fe ff ff       	call   80104908 <cli>
  if(mycpu()->ncli == 0)
80104ad0:	e8 e3 ee ff ff       	call   801039b8 <mycpu>
80104ad5:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104adb:	85 c0                	test   %eax,%eax
80104add:	75 14                	jne    80104af3 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104adf:	e8 d4 ee ff ff       	call   801039b8 <mycpu>
80104ae4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ae7:	81 e2 00 02 00 00    	and    $0x200,%edx
80104aed:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104af3:	e8 c0 ee ff ff       	call   801039b8 <mycpu>
80104af8:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104afe:	83 c2 01             	add    $0x1,%edx
80104b01:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104b07:	90                   	nop
80104b08:	c9                   	leave
80104b09:	c3                   	ret

80104b0a <popcli>:

void
popcli(void)
{
80104b0a:	55                   	push   %ebp
80104b0b:	89 e5                	mov    %esp,%ebp
80104b0d:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104b10:	e8 e3 fd ff ff       	call   801048f8 <readeflags>
80104b15:	25 00 02 00 00       	and    $0x200,%eax
80104b1a:	85 c0                	test   %eax,%eax
80104b1c:	74 0d                	je     80104b2b <popcli+0x21>
    panic("popcli - interruptible");
80104b1e:	83 ec 0c             	sub    $0xc,%esp
80104b21:	68 da a5 10 80       	push   $0x8010a5da
80104b26:	e8 7e ba ff ff       	call   801005a9 <panic>
  if(--mycpu()->ncli < 0)
80104b2b:	e8 88 ee ff ff       	call   801039b8 <mycpu>
80104b30:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b36:	83 ea 01             	sub    $0x1,%edx
80104b39:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104b3f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b45:	85 c0                	test   %eax,%eax
80104b47:	79 0d                	jns    80104b56 <popcli+0x4c>
    panic("popcli");
80104b49:	83 ec 0c             	sub    $0xc,%esp
80104b4c:	68 f1 a5 10 80       	push   $0x8010a5f1
80104b51:	e8 53 ba ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b56:	e8 5d ee ff ff       	call   801039b8 <mycpu>
80104b5b:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b61:	85 c0                	test   %eax,%eax
80104b63:	75 14                	jne    80104b79 <popcli+0x6f>
80104b65:	e8 4e ee ff ff       	call   801039b8 <mycpu>
80104b6a:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b70:	85 c0                	test   %eax,%eax
80104b72:	74 05                	je     80104b79 <popcli+0x6f>
    sti();
80104b74:	e8 96 fd ff ff       	call   8010490f <sti>
}
80104b79:	90                   	nop
80104b7a:	c9                   	leave
80104b7b:	c3                   	ret

80104b7c <stosb>:
{
80104b7c:	55                   	push   %ebp
80104b7d:	89 e5                	mov    %esp,%ebp
80104b7f:	57                   	push   %edi
80104b80:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104b81:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b84:	8b 55 10             	mov    0x10(%ebp),%edx
80104b87:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b8a:	89 cb                	mov    %ecx,%ebx
80104b8c:	89 df                	mov    %ebx,%edi
80104b8e:	89 d1                	mov    %edx,%ecx
80104b90:	fc                   	cld
80104b91:	f3 aa                	rep stos %al,%es:(%edi)
80104b93:	89 ca                	mov    %ecx,%edx
80104b95:	89 fb                	mov    %edi,%ebx
80104b97:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104b9a:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104b9d:	90                   	nop
80104b9e:	5b                   	pop    %ebx
80104b9f:	5f                   	pop    %edi
80104ba0:	5d                   	pop    %ebp
80104ba1:	c3                   	ret

80104ba2 <stosl>:
{
80104ba2:	55                   	push   %ebp
80104ba3:	89 e5                	mov    %esp,%ebp
80104ba5:	57                   	push   %edi
80104ba6:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104ba7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104baa:	8b 55 10             	mov    0x10(%ebp),%edx
80104bad:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bb0:	89 cb                	mov    %ecx,%ebx
80104bb2:	89 df                	mov    %ebx,%edi
80104bb4:	89 d1                	mov    %edx,%ecx
80104bb6:	fc                   	cld
80104bb7:	f3 ab                	rep stos %eax,%es:(%edi)
80104bb9:	89 ca                	mov    %ecx,%edx
80104bbb:	89 fb                	mov    %edi,%ebx
80104bbd:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104bc0:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104bc3:	90                   	nop
80104bc4:	5b                   	pop    %ebx
80104bc5:	5f                   	pop    %edi
80104bc6:	5d                   	pop    %ebp
80104bc7:	c3                   	ret

80104bc8 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104bc8:	55                   	push   %ebp
80104bc9:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80104bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80104bce:	83 e0 03             	and    $0x3,%eax
80104bd1:	85 c0                	test   %eax,%eax
80104bd3:	75 43                	jne    80104c18 <memset+0x50>
80104bd5:	8b 45 10             	mov    0x10(%ebp),%eax
80104bd8:	83 e0 03             	and    $0x3,%eax
80104bdb:	85 c0                	test   %eax,%eax
80104bdd:	75 39                	jne    80104c18 <memset+0x50>
    c &= 0xFF;
80104bdf:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104be6:	8b 45 10             	mov    0x10(%ebp),%eax
80104be9:	c1 e8 02             	shr    $0x2,%eax
80104bec:	89 c1                	mov    %eax,%ecx
80104bee:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bf1:	c1 e0 18             	shl    $0x18,%eax
80104bf4:	89 c2                	mov    %eax,%edx
80104bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bf9:	c1 e0 10             	shl    $0x10,%eax
80104bfc:	09 c2                	or     %eax,%edx
80104bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c01:	c1 e0 08             	shl    $0x8,%eax
80104c04:	09 d0                	or     %edx,%eax
80104c06:	0b 45 0c             	or     0xc(%ebp),%eax
80104c09:	51                   	push   %ecx
80104c0a:	50                   	push   %eax
80104c0b:	ff 75 08             	push   0x8(%ebp)
80104c0e:	e8 8f ff ff ff       	call   80104ba2 <stosl>
80104c13:	83 c4 0c             	add    $0xc,%esp
80104c16:	eb 12                	jmp    80104c2a <memset+0x62>
  } else
    stosb(dst, c, n);
80104c18:	8b 45 10             	mov    0x10(%ebp),%eax
80104c1b:	50                   	push   %eax
80104c1c:	ff 75 0c             	push   0xc(%ebp)
80104c1f:	ff 75 08             	push   0x8(%ebp)
80104c22:	e8 55 ff ff ff       	call   80104b7c <stosb>
80104c27:	83 c4 0c             	add    $0xc,%esp
  return dst;
80104c2a:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104c2d:	c9                   	leave
80104c2e:	c3                   	ret

80104c2f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c2f:	55                   	push   %ebp
80104c30:	89 e5                	mov    %esp,%ebp
80104c32:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80104c35:	8b 45 08             	mov    0x8(%ebp),%eax
80104c38:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104c41:	eb 2e                	jmp    80104c71 <memcmp+0x42>
    if(*s1 != *s2)
80104c43:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c46:	0f b6 10             	movzbl (%eax),%edx
80104c49:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c4c:	0f b6 00             	movzbl (%eax),%eax
80104c4f:	38 c2                	cmp    %al,%dl
80104c51:	74 16                	je     80104c69 <memcmp+0x3a>
      return *s1 - *s2;
80104c53:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c56:	0f b6 00             	movzbl (%eax),%eax
80104c59:	0f b6 d0             	movzbl %al,%edx
80104c5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c5f:	0f b6 00             	movzbl (%eax),%eax
80104c62:	0f b6 c0             	movzbl %al,%eax
80104c65:	29 c2                	sub    %eax,%edx
80104c67:	eb 1a                	jmp    80104c83 <memcmp+0x54>
    s1++, s2++;
80104c69:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104c6d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
80104c71:	8b 45 10             	mov    0x10(%ebp),%eax
80104c74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c77:	89 55 10             	mov    %edx,0x10(%ebp)
80104c7a:	85 c0                	test   %eax,%eax
80104c7c:	75 c5                	jne    80104c43 <memcmp+0x14>
  }

  return 0;
80104c7e:	ba 00 00 00 00       	mov    $0x0,%edx
}
80104c83:	89 d0                	mov    %edx,%eax
80104c85:	c9                   	leave
80104c86:	c3                   	ret

80104c87 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c87:	55                   	push   %ebp
80104c88:	89 e5                	mov    %esp,%ebp
80104c8a:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c90:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104c93:	8b 45 08             	mov    0x8(%ebp),%eax
80104c96:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c9c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104c9f:	73 54                	jae    80104cf5 <memmove+0x6e>
80104ca1:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104ca4:	8b 45 10             	mov    0x10(%ebp),%eax
80104ca7:	01 d0                	add    %edx,%eax
80104ca9:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80104cac:	73 47                	jae    80104cf5 <memmove+0x6e>
    s += n;
80104cae:	8b 45 10             	mov    0x10(%ebp),%eax
80104cb1:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104cb4:	8b 45 10             	mov    0x10(%ebp),%eax
80104cb7:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104cba:	eb 13                	jmp    80104ccf <memmove+0x48>
      *--d = *--s;
80104cbc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104cc0:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104cc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cc7:	0f b6 10             	movzbl (%eax),%edx
80104cca:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ccd:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104ccf:	8b 45 10             	mov    0x10(%ebp),%eax
80104cd2:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cd5:	89 55 10             	mov    %edx,0x10(%ebp)
80104cd8:	85 c0                	test   %eax,%eax
80104cda:	75 e0                	jne    80104cbc <memmove+0x35>
  if(s < d && s + n > d){
80104cdc:	eb 24                	jmp    80104d02 <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
80104cde:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104ce1:	8d 42 01             	lea    0x1(%edx),%eax
80104ce4:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104ce7:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104cea:	8d 48 01             	lea    0x1(%eax),%ecx
80104ced:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104cf0:	0f b6 12             	movzbl (%edx),%edx
80104cf3:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104cf5:	8b 45 10             	mov    0x10(%ebp),%eax
80104cf8:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cfb:	89 55 10             	mov    %edx,0x10(%ebp)
80104cfe:	85 c0                	test   %eax,%eax
80104d00:	75 dc                	jne    80104cde <memmove+0x57>

  return dst;
80104d02:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104d05:	c9                   	leave
80104d06:	c3                   	ret

80104d07 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104d07:	55                   	push   %ebp
80104d08:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80104d0a:	ff 75 10             	push   0x10(%ebp)
80104d0d:	ff 75 0c             	push   0xc(%ebp)
80104d10:	ff 75 08             	push   0x8(%ebp)
80104d13:	e8 6f ff ff ff       	call   80104c87 <memmove>
80104d18:	83 c4 0c             	add    $0xc,%esp
}
80104d1b:	c9                   	leave
80104d1c:	c3                   	ret

80104d1d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104d1d:	55                   	push   %ebp
80104d1e:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104d20:	eb 0c                	jmp    80104d2e <strncmp+0x11>
    n--, p++, q++;
80104d22:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104d26:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104d2a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80104d2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d32:	74 1a                	je     80104d4e <strncmp+0x31>
80104d34:	8b 45 08             	mov    0x8(%ebp),%eax
80104d37:	0f b6 00             	movzbl (%eax),%eax
80104d3a:	84 c0                	test   %al,%al
80104d3c:	74 10                	je     80104d4e <strncmp+0x31>
80104d3e:	8b 45 08             	mov    0x8(%ebp),%eax
80104d41:	0f b6 10             	movzbl (%eax),%edx
80104d44:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d47:	0f b6 00             	movzbl (%eax),%eax
80104d4a:	38 c2                	cmp    %al,%dl
80104d4c:	74 d4                	je     80104d22 <strncmp+0x5>
  if(n == 0)
80104d4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d52:	75 07                	jne    80104d5b <strncmp+0x3e>
    return 0;
80104d54:	ba 00 00 00 00       	mov    $0x0,%edx
80104d59:	eb 14                	jmp    80104d6f <strncmp+0x52>
  return (uchar)*p - (uchar)*q;
80104d5b:	8b 45 08             	mov    0x8(%ebp),%eax
80104d5e:	0f b6 00             	movzbl (%eax),%eax
80104d61:	0f b6 d0             	movzbl %al,%edx
80104d64:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d67:	0f b6 00             	movzbl (%eax),%eax
80104d6a:	0f b6 c0             	movzbl %al,%eax
80104d6d:	29 c2                	sub    %eax,%edx
}
80104d6f:	89 d0                	mov    %edx,%eax
80104d71:	5d                   	pop    %ebp
80104d72:	c3                   	ret

80104d73 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104d73:	55                   	push   %ebp
80104d74:	89 e5                	mov    %esp,%ebp
80104d76:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80104d79:	8b 45 08             	mov    0x8(%ebp),%eax
80104d7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80104d7f:	90                   	nop
80104d80:	8b 45 10             	mov    0x10(%ebp),%eax
80104d83:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d86:	89 55 10             	mov    %edx,0x10(%ebp)
80104d89:	85 c0                	test   %eax,%eax
80104d8b:	7e 2c                	jle    80104db9 <strncpy+0x46>
80104d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d90:	8d 42 01             	lea    0x1(%edx),%eax
80104d93:	89 45 0c             	mov    %eax,0xc(%ebp)
80104d96:	8b 45 08             	mov    0x8(%ebp),%eax
80104d99:	8d 48 01             	lea    0x1(%eax),%ecx
80104d9c:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104d9f:	0f b6 12             	movzbl (%edx),%edx
80104da2:	88 10                	mov    %dl,(%eax)
80104da4:	0f b6 00             	movzbl (%eax),%eax
80104da7:	84 c0                	test   %al,%al
80104da9:	75 d5                	jne    80104d80 <strncpy+0xd>
    ;
  while(n-- > 0)
80104dab:	eb 0c                	jmp    80104db9 <strncpy+0x46>
    *s++ = 0;
80104dad:	8b 45 08             	mov    0x8(%ebp),%eax
80104db0:	8d 50 01             	lea    0x1(%eax),%edx
80104db3:	89 55 08             	mov    %edx,0x8(%ebp)
80104db6:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80104db9:	8b 45 10             	mov    0x10(%ebp),%eax
80104dbc:	8d 50 ff             	lea    -0x1(%eax),%edx
80104dbf:	89 55 10             	mov    %edx,0x10(%ebp)
80104dc2:	85 c0                	test   %eax,%eax
80104dc4:	7f e7                	jg     80104dad <strncpy+0x3a>
  return os;
80104dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104dc9:	c9                   	leave
80104dca:	c3                   	ret

80104dcb <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104dcb:	55                   	push   %ebp
80104dcc:	89 e5                	mov    %esp,%ebp
80104dce:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80104dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80104dd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104ddb:	7f 05                	jg     80104de2 <safestrcpy+0x17>
    return os;
80104ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104de0:	eb 32                	jmp    80104e14 <safestrcpy+0x49>
  while(--n > 0 && (*s++ = *t++) != 0)
80104de2:	90                   	nop
80104de3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104de7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104deb:	7e 1e                	jle    80104e0b <safestrcpy+0x40>
80104ded:	8b 55 0c             	mov    0xc(%ebp),%edx
80104df0:	8d 42 01             	lea    0x1(%edx),%eax
80104df3:	89 45 0c             	mov    %eax,0xc(%ebp)
80104df6:	8b 45 08             	mov    0x8(%ebp),%eax
80104df9:	8d 48 01             	lea    0x1(%eax),%ecx
80104dfc:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104dff:	0f b6 12             	movzbl (%edx),%edx
80104e02:	88 10                	mov    %dl,(%eax)
80104e04:	0f b6 00             	movzbl (%eax),%eax
80104e07:	84 c0                	test   %al,%al
80104e09:	75 d8                	jne    80104de3 <safestrcpy+0x18>
    ;
  *s = 0;
80104e0b:	8b 45 08             	mov    0x8(%ebp),%eax
80104e0e:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80104e11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104e14:	c9                   	leave
80104e15:	c3                   	ret

80104e16 <strlen>:

int
strlen(const char *s)
{
80104e16:	55                   	push   %ebp
80104e17:	89 e5                	mov    %esp,%ebp
80104e19:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80104e1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104e23:	eb 04                	jmp    80104e29 <strlen+0x13>
80104e25:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104e29:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80104e2f:	01 d0                	add    %edx,%eax
80104e31:	0f b6 00             	movzbl (%eax),%eax
80104e34:	84 c0                	test   %al,%al
80104e36:	75 ed                	jne    80104e25 <strlen+0xf>
    ;
  return n;
80104e38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104e3b:	c9                   	leave
80104e3c:	c3                   	ret

80104e3d <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e3d:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e41:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104e45:	55                   	push   %ebp
  pushl %ebx
80104e46:	53                   	push   %ebx
  pushl %esi
80104e47:	56                   	push   %esi
  pushl %edi
80104e48:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104e49:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e4b:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104e4d:	5f                   	pop    %edi
  popl %esi
80104e4e:	5e                   	pop    %esi
  popl %ebx
80104e4f:	5b                   	pop    %ebx
  popl %ebp
80104e50:	5d                   	pop    %ebp
  ret
80104e51:	c3                   	ret

80104e52 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e52:	55                   	push   %ebp
80104e53:	89 e5                	mov    %esp,%ebp
80104e55:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104e58:	e8 d3 eb ff ff       	call   80103a30 <myproc>
80104e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e63:	8b 00                	mov    (%eax),%eax
80104e65:	39 45 08             	cmp    %eax,0x8(%ebp)
80104e68:	73 0f                	jae    80104e79 <fetchint+0x27>
80104e6a:	8b 45 08             	mov    0x8(%ebp),%eax
80104e6d:	8d 50 04             	lea    0x4(%eax),%edx
80104e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e73:	8b 00                	mov    (%eax),%eax
80104e75:	39 d0                	cmp    %edx,%eax
80104e77:	73 07                	jae    80104e80 <fetchint+0x2e>
    return -1;
80104e79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e7e:	eb 0f                	jmp    80104e8f <fetchint+0x3d>
  *ip = *(int*)(addr);
80104e80:	8b 45 08             	mov    0x8(%ebp),%eax
80104e83:	8b 10                	mov    (%eax),%edx
80104e85:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e88:	89 10                	mov    %edx,(%eax)
  return 0;
80104e8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e8f:	c9                   	leave
80104e90:	c3                   	ret

80104e91 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104e91:	55                   	push   %ebp
80104e92:	89 e5                	mov    %esp,%ebp
80104e94:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80104e97:	e8 94 eb ff ff       	call   80103a30 <myproc>
80104e9c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80104e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ea2:	8b 00                	mov    (%eax),%eax
80104ea4:	39 45 08             	cmp    %eax,0x8(%ebp)
80104ea7:	72 07                	jb     80104eb0 <fetchstr+0x1f>
    return -1;
80104ea9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eae:	eb 41                	jmp    80104ef1 <fetchstr+0x60>
  *pp = (char*)addr;
80104eb0:	8b 55 08             	mov    0x8(%ebp),%edx
80104eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eb6:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80104eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ebb:	8b 00                	mov    (%eax),%eax
80104ebd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80104ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ec3:	8b 00                	mov    (%eax),%eax
80104ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104ec8:	eb 1a                	jmp    80104ee4 <fetchstr+0x53>
    if(*s == 0)
80104eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ecd:	0f b6 00             	movzbl (%eax),%eax
80104ed0:	84 c0                	test   %al,%al
80104ed2:	75 0c                	jne    80104ee0 <fetchstr+0x4f>
      return s - *pp;
80104ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ed7:	8b 10                	mov    (%eax),%edx
80104ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104edc:	29 d0                	sub    %edx,%eax
80104ede:	eb 11                	jmp    80104ef1 <fetchstr+0x60>
  for(s = *pp; s < ep; s++){
80104ee0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104eea:	72 de                	jb     80104eca <fetchstr+0x39>
  }
  return -1;
80104eec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ef1:	c9                   	leave
80104ef2:	c3                   	ret

80104ef3 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ef3:	55                   	push   %ebp
80104ef4:	89 e5                	mov    %esp,%ebp
80104ef6:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ef9:	e8 32 eb ff ff       	call   80103a30 <myproc>
80104efe:	8b 40 18             	mov    0x18(%eax),%eax
80104f01:	8b 40 44             	mov    0x44(%eax),%eax
80104f04:	8b 55 08             	mov    0x8(%ebp),%edx
80104f07:	c1 e2 02             	shl    $0x2,%edx
80104f0a:	01 d0                	add    %edx,%eax
80104f0c:	83 c0 04             	add    $0x4,%eax
80104f0f:	83 ec 08             	sub    $0x8,%esp
80104f12:	ff 75 0c             	push   0xc(%ebp)
80104f15:	50                   	push   %eax
80104f16:	e8 37 ff ff ff       	call   80104e52 <fetchint>
80104f1b:	83 c4 10             	add    $0x10,%esp
}
80104f1e:	c9                   	leave
80104f1f:	c3                   	ret

80104f20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80104f26:	e8 05 eb ff ff       	call   80103a30 <myproc>
80104f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80104f2e:	83 ec 08             	sub    $0x8,%esp
80104f31:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f34:	50                   	push   %eax
80104f35:	ff 75 08             	push   0x8(%ebp)
80104f38:	e8 b6 ff ff ff       	call   80104ef3 <argint>
80104f3d:	83 c4 10             	add    $0x10,%esp
80104f40:	85 c0                	test   %eax,%eax
80104f42:	79 07                	jns    80104f4b <argptr+0x2b>
    return -1;
80104f44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f49:	eb 3b                	jmp    80104f86 <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f4f:	78 1f                	js     80104f70 <argptr+0x50>
80104f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f54:	8b 00                	mov    (%eax),%eax
80104f56:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f59:	39 c2                	cmp    %eax,%edx
80104f5b:	73 13                	jae    80104f70 <argptr+0x50>
80104f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f60:	89 c2                	mov    %eax,%edx
80104f62:	8b 45 10             	mov    0x10(%ebp),%eax
80104f65:	01 c2                	add    %eax,%edx
80104f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f6a:	8b 00                	mov    (%eax),%eax
80104f6c:	39 d0                	cmp    %edx,%eax
80104f6e:	73 07                	jae    80104f77 <argptr+0x57>
    return -1;
80104f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f75:	eb 0f                	jmp    80104f86 <argptr+0x66>
  *pp = (char*)i;
80104f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f7a:	89 c2                	mov    %eax,%edx
80104f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f7f:	89 10                	mov    %edx,(%eax)
  return 0;
80104f81:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f86:	c9                   	leave
80104f87:	c3                   	ret

80104f88 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f88:	55                   	push   %ebp
80104f89:	89 e5                	mov    %esp,%ebp
80104f8b:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f8e:	83 ec 08             	sub    $0x8,%esp
80104f91:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f94:	50                   	push   %eax
80104f95:	ff 75 08             	push   0x8(%ebp)
80104f98:	e8 56 ff ff ff       	call   80104ef3 <argint>
80104f9d:	83 c4 10             	add    $0x10,%esp
80104fa0:	85 c0                	test   %eax,%eax
80104fa2:	79 07                	jns    80104fab <argstr+0x23>
    return -1;
80104fa4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fa9:	eb 12                	jmp    80104fbd <argstr+0x35>
  return fetchstr(addr, pp);
80104fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fae:	83 ec 08             	sub    $0x8,%esp
80104fb1:	ff 75 0c             	push   0xc(%ebp)
80104fb4:	50                   	push   %eax
80104fb5:	e8 d7 fe ff ff       	call   80104e91 <fetchstr>
80104fba:	83 c4 10             	add    $0x10,%esp
}
80104fbd:	c9                   	leave
80104fbe:	c3                   	ret

80104fbf <syscall>:
[SYS_exit2]   sys_exit2,
};

void
syscall(void)
{
80104fbf:	55                   	push   %ebp
80104fc0:	89 e5                	mov    %esp,%ebp
80104fc2:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80104fc5:	e8 66 ea ff ff       	call   80103a30 <myproc>
80104fca:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80104fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd0:	8b 40 18             	mov    0x18(%eax),%eax
80104fd3:	8b 40 1c             	mov    0x1c(%eax),%eax
80104fd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104fd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104fdd:	7e 2f                	jle    8010500e <syscall+0x4f>
80104fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fe2:	83 f8 17             	cmp    $0x17,%eax
80104fe5:	77 27                	ja     8010500e <syscall+0x4f>
80104fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fea:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80104ff1:	85 c0                	test   %eax,%eax
80104ff3:	74 19                	je     8010500e <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80104ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ff8:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
80104fff:	ff d0                	call   *%eax
80105001:	89 c2                	mov    %eax,%edx
80105003:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105006:	8b 40 18             	mov    0x18(%eax),%eax
80105009:	89 50 1c             	mov    %edx,0x1c(%eax)
8010500c:	eb 2c                	jmp    8010503a <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
8010500e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105011:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
80105014:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105017:	8b 40 10             	mov    0x10(%eax),%eax
8010501a:	ff 75 f0             	push   -0x10(%ebp)
8010501d:	52                   	push   %edx
8010501e:	50                   	push   %eax
8010501f:	68 f8 a5 10 80       	push   $0x8010a5f8
80105024:	e8 cb b3 ff ff       	call   801003f4 <cprintf>
80105029:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
8010502c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010502f:	8b 40 18             	mov    0x18(%eax),%eax
80105032:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105039:	90                   	nop
8010503a:	90                   	nop
8010503b:	c9                   	leave
8010503c:	c3                   	ret

8010503d <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010503d:	55                   	push   %ebp
8010503e:	89 e5                	mov    %esp,%ebp
80105040:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105043:	83 ec 08             	sub    $0x8,%esp
80105046:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105049:	50                   	push   %eax
8010504a:	ff 75 08             	push   0x8(%ebp)
8010504d:	e8 a1 fe ff ff       	call   80104ef3 <argint>
80105052:	83 c4 10             	add    $0x10,%esp
80105055:	85 c0                	test   %eax,%eax
80105057:	79 07                	jns    80105060 <argfd+0x23>
    return -1;
80105059:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505e:	eb 4f                	jmp    801050af <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105060:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105063:	85 c0                	test   %eax,%eax
80105065:	78 20                	js     80105087 <argfd+0x4a>
80105067:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010506a:	83 f8 0f             	cmp    $0xf,%eax
8010506d:	7f 18                	jg     80105087 <argfd+0x4a>
8010506f:	e8 bc e9 ff ff       	call   80103a30 <myproc>
80105074:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105077:	83 c2 08             	add    $0x8,%edx
8010507a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010507e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105081:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105085:	75 07                	jne    8010508e <argfd+0x51>
    return -1;
80105087:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010508c:	eb 21                	jmp    801050af <argfd+0x72>
  if(pfd)
8010508e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105092:	74 08                	je     8010509c <argfd+0x5f>
    *pfd = fd;
80105094:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105097:	8b 45 0c             	mov    0xc(%ebp),%eax
8010509a:	89 10                	mov    %edx,(%eax)
  if(pf)
8010509c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050a0:	74 08                	je     801050aa <argfd+0x6d>
    *pf = f;
801050a2:	8b 45 10             	mov    0x10(%ebp),%eax
801050a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050a8:	89 10                	mov    %edx,(%eax)
  return 0;
801050aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050af:	c9                   	leave
801050b0:	c3                   	ret

801050b1 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801050b1:	55                   	push   %ebp
801050b2:	89 e5                	mov    %esp,%ebp
801050b4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801050b7:	e8 74 e9 ff ff       	call   80103a30 <myproc>
801050bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
801050bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801050c6:	eb 2a                	jmp    801050f2 <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
801050c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050ce:	83 c2 08             	add    $0x8,%edx
801050d1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801050d5:	85 c0                	test   %eax,%eax
801050d7:	75 15                	jne    801050ee <fdalloc+0x3d>
      curproc->ofile[fd] = f;
801050d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050df:	8d 4a 08             	lea    0x8(%edx),%ecx
801050e2:	8b 55 08             	mov    0x8(%ebp),%edx
801050e5:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801050e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ec:	eb 0f                	jmp    801050fd <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
801050ee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801050f2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050f6:	7e d0                	jle    801050c8 <fdalloc+0x17>
    }
  }
  return -1;
801050f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050fd:	c9                   	leave
801050fe:	c3                   	ret

801050ff <sys_dup>:

int
sys_dup(void)
{
801050ff:	55                   	push   %ebp
80105100:	89 e5                	mov    %esp,%ebp
80105102:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105105:	83 ec 04             	sub    $0x4,%esp
80105108:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010510b:	50                   	push   %eax
8010510c:	6a 00                	push   $0x0
8010510e:	6a 00                	push   $0x0
80105110:	e8 28 ff ff ff       	call   8010503d <argfd>
80105115:	83 c4 10             	add    $0x10,%esp
80105118:	85 c0                	test   %eax,%eax
8010511a:	79 07                	jns    80105123 <sys_dup+0x24>
    return -1;
8010511c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105121:	eb 31                	jmp    80105154 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105123:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105126:	83 ec 0c             	sub    $0xc,%esp
80105129:	50                   	push   %eax
8010512a:	e8 82 ff ff ff       	call   801050b1 <fdalloc>
8010512f:	83 c4 10             	add    $0x10,%esp
80105132:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105139:	79 07                	jns    80105142 <sys_dup+0x43>
    return -1;
8010513b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105140:	eb 12                	jmp    80105154 <sys_dup+0x55>
  filedup(f);
80105142:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105145:	83 ec 0c             	sub    $0xc,%esp
80105148:	50                   	push   %eax
80105149:	e8 06 bf ff ff       	call   80101054 <filedup>
8010514e:	83 c4 10             	add    $0x10,%esp
  return fd;
80105151:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105154:	c9                   	leave
80105155:	c3                   	ret

80105156 <sys_read>:

int
sys_read(void)
{
80105156:	55                   	push   %ebp
80105157:	89 e5                	mov    %esp,%ebp
80105159:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010515c:	83 ec 04             	sub    $0x4,%esp
8010515f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105162:	50                   	push   %eax
80105163:	6a 00                	push   $0x0
80105165:	6a 00                	push   $0x0
80105167:	e8 d1 fe ff ff       	call   8010503d <argfd>
8010516c:	83 c4 10             	add    $0x10,%esp
8010516f:	85 c0                	test   %eax,%eax
80105171:	78 2e                	js     801051a1 <sys_read+0x4b>
80105173:	83 ec 08             	sub    $0x8,%esp
80105176:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105179:	50                   	push   %eax
8010517a:	6a 02                	push   $0x2
8010517c:	e8 72 fd ff ff       	call   80104ef3 <argint>
80105181:	83 c4 10             	add    $0x10,%esp
80105184:	85 c0                	test   %eax,%eax
80105186:	78 19                	js     801051a1 <sys_read+0x4b>
80105188:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010518b:	83 ec 04             	sub    $0x4,%esp
8010518e:	50                   	push   %eax
8010518f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105192:	50                   	push   %eax
80105193:	6a 01                	push   $0x1
80105195:	e8 86 fd ff ff       	call   80104f20 <argptr>
8010519a:	83 c4 10             	add    $0x10,%esp
8010519d:	85 c0                	test   %eax,%eax
8010519f:	79 07                	jns    801051a8 <sys_read+0x52>
    return -1;
801051a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a6:	eb 17                	jmp    801051bf <sys_read+0x69>
  return fileread(f, p, n);
801051a8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801051ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051b1:	83 ec 04             	sub    $0x4,%esp
801051b4:	51                   	push   %ecx
801051b5:	52                   	push   %edx
801051b6:	50                   	push   %eax
801051b7:	e8 28 c0 ff ff       	call   801011e4 <fileread>
801051bc:	83 c4 10             	add    $0x10,%esp
}
801051bf:	c9                   	leave
801051c0:	c3                   	ret

801051c1 <sys_write>:

int
sys_write(void)
{
801051c1:	55                   	push   %ebp
801051c2:	89 e5                	mov    %esp,%ebp
801051c4:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051c7:	83 ec 04             	sub    $0x4,%esp
801051ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051cd:	50                   	push   %eax
801051ce:	6a 00                	push   $0x0
801051d0:	6a 00                	push   $0x0
801051d2:	e8 66 fe ff ff       	call   8010503d <argfd>
801051d7:	83 c4 10             	add    $0x10,%esp
801051da:	85 c0                	test   %eax,%eax
801051dc:	78 2e                	js     8010520c <sys_write+0x4b>
801051de:	83 ec 08             	sub    $0x8,%esp
801051e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051e4:	50                   	push   %eax
801051e5:	6a 02                	push   $0x2
801051e7:	e8 07 fd ff ff       	call   80104ef3 <argint>
801051ec:	83 c4 10             	add    $0x10,%esp
801051ef:	85 c0                	test   %eax,%eax
801051f1:	78 19                	js     8010520c <sys_write+0x4b>
801051f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051f6:	83 ec 04             	sub    $0x4,%esp
801051f9:	50                   	push   %eax
801051fa:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051fd:	50                   	push   %eax
801051fe:	6a 01                	push   $0x1
80105200:	e8 1b fd ff ff       	call   80104f20 <argptr>
80105205:	83 c4 10             	add    $0x10,%esp
80105208:	85 c0                	test   %eax,%eax
8010520a:	79 07                	jns    80105213 <sys_write+0x52>
    return -1;
8010520c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105211:	eb 17                	jmp    8010522a <sys_write+0x69>
  return filewrite(f, p, n);
80105213:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105216:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010521c:	83 ec 04             	sub    $0x4,%esp
8010521f:	51                   	push   %ecx
80105220:	52                   	push   %edx
80105221:	50                   	push   %eax
80105222:	e8 75 c0 ff ff       	call   8010129c <filewrite>
80105227:	83 c4 10             	add    $0x10,%esp
}
8010522a:	c9                   	leave
8010522b:	c3                   	ret

8010522c <sys_close>:

int
sys_close(void)
{
8010522c:	55                   	push   %ebp
8010522d:	89 e5                	mov    %esp,%ebp
8010522f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105232:	83 ec 04             	sub    $0x4,%esp
80105235:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105238:	50                   	push   %eax
80105239:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010523c:	50                   	push   %eax
8010523d:	6a 00                	push   $0x0
8010523f:	e8 f9 fd ff ff       	call   8010503d <argfd>
80105244:	83 c4 10             	add    $0x10,%esp
80105247:	85 c0                	test   %eax,%eax
80105249:	79 07                	jns    80105252 <sys_close+0x26>
    return -1;
8010524b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105250:	eb 27                	jmp    80105279 <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
80105252:	e8 d9 e7 ff ff       	call   80103a30 <myproc>
80105257:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010525a:	83 c2 08             	add    $0x8,%edx
8010525d:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105264:	00 
  fileclose(f);
80105265:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105268:	83 ec 0c             	sub    $0xc,%esp
8010526b:	50                   	push   %eax
8010526c:	e8 34 be ff ff       	call   801010a5 <fileclose>
80105271:	83 c4 10             	add    $0x10,%esp
  return 0;
80105274:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105279:	c9                   	leave
8010527a:	c3                   	ret

8010527b <sys_fstat>:

int
sys_fstat(void)
{
8010527b:	55                   	push   %ebp
8010527c:	89 e5                	mov    %esp,%ebp
8010527e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105281:	83 ec 04             	sub    $0x4,%esp
80105284:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105287:	50                   	push   %eax
80105288:	6a 00                	push   $0x0
8010528a:	6a 00                	push   $0x0
8010528c:	e8 ac fd ff ff       	call   8010503d <argfd>
80105291:	83 c4 10             	add    $0x10,%esp
80105294:	85 c0                	test   %eax,%eax
80105296:	78 17                	js     801052af <sys_fstat+0x34>
80105298:	83 ec 04             	sub    $0x4,%esp
8010529b:	6a 14                	push   $0x14
8010529d:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052a0:	50                   	push   %eax
801052a1:	6a 01                	push   $0x1
801052a3:	e8 78 fc ff ff       	call   80104f20 <argptr>
801052a8:	83 c4 10             	add    $0x10,%esp
801052ab:	85 c0                	test   %eax,%eax
801052ad:	79 07                	jns    801052b6 <sys_fstat+0x3b>
    return -1;
801052af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b4:	eb 13                	jmp    801052c9 <sys_fstat+0x4e>
  return filestat(f, st);
801052b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801052b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052bc:	83 ec 08             	sub    $0x8,%esp
801052bf:	52                   	push   %edx
801052c0:	50                   	push   %eax
801052c1:	e8 c7 be ff ff       	call   8010118d <filestat>
801052c6:	83 c4 10             	add    $0x10,%esp
}
801052c9:	c9                   	leave
801052ca:	c3                   	ret

801052cb <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801052cb:	55                   	push   %ebp
801052cc:	89 e5                	mov    %esp,%ebp
801052ce:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052d1:	83 ec 08             	sub    $0x8,%esp
801052d4:	8d 45 d8             	lea    -0x28(%ebp),%eax
801052d7:	50                   	push   %eax
801052d8:	6a 00                	push   $0x0
801052da:	e8 a9 fc ff ff       	call   80104f88 <argstr>
801052df:	83 c4 10             	add    $0x10,%esp
801052e2:	85 c0                	test   %eax,%eax
801052e4:	78 15                	js     801052fb <sys_link+0x30>
801052e6:	83 ec 08             	sub    $0x8,%esp
801052e9:	8d 45 dc             	lea    -0x24(%ebp),%eax
801052ec:	50                   	push   %eax
801052ed:	6a 01                	push   $0x1
801052ef:	e8 94 fc ff ff       	call   80104f88 <argstr>
801052f4:	83 c4 10             	add    $0x10,%esp
801052f7:	85 c0                	test   %eax,%eax
801052f9:	79 0a                	jns    80105305 <sys_link+0x3a>
    return -1;
801052fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105300:	e9 68 01 00 00       	jmp    8010546d <sys_link+0x1a2>

  begin_op();
80105305:	e8 34 dd ff ff       	call   8010303e <begin_op>
  if((ip = namei(old)) == 0){
8010530a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010530d:	83 ec 0c             	sub    $0xc,%esp
80105310:	50                   	push   %eax
80105311:	e8 0f d2 ff ff       	call   80102525 <namei>
80105316:	83 c4 10             	add    $0x10,%esp
80105319:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010531c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105320:	75 0f                	jne    80105331 <sys_link+0x66>
    end_op();
80105322:	e8 a3 dd ff ff       	call   801030ca <end_op>
    return -1;
80105327:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532c:	e9 3c 01 00 00       	jmp    8010546d <sys_link+0x1a2>
  }

  ilock(ip);
80105331:	83 ec 0c             	sub    $0xc,%esp
80105334:	ff 75 f4             	push   -0xc(%ebp)
80105337:	e8 b6 c6 ff ff       	call   801019f2 <ilock>
8010533c:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010533f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105342:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105346:	66 83 f8 01          	cmp    $0x1,%ax
8010534a:	75 1d                	jne    80105369 <sys_link+0x9e>
    iunlockput(ip);
8010534c:	83 ec 0c             	sub    $0xc,%esp
8010534f:	ff 75 f4             	push   -0xc(%ebp)
80105352:	e8 cc c8 ff ff       	call   80101c23 <iunlockput>
80105357:	83 c4 10             	add    $0x10,%esp
    end_op();
8010535a:	e8 6b dd ff ff       	call   801030ca <end_op>
    return -1;
8010535f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105364:	e9 04 01 00 00       	jmp    8010546d <sys_link+0x1a2>
  }

  ip->nlink++;
80105369:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010536c:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105370:	83 c0 01             	add    $0x1,%eax
80105373:	89 c2                	mov    %eax,%edx
80105375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105378:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
8010537c:	83 ec 0c             	sub    $0xc,%esp
8010537f:	ff 75 f4             	push   -0xc(%ebp)
80105382:	e8 8e c4 ff ff       	call   80101815 <iupdate>
80105387:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
8010538a:	83 ec 0c             	sub    $0xc,%esp
8010538d:	ff 75 f4             	push   -0xc(%ebp)
80105390:	e8 70 c7 ff ff       	call   80101b05 <iunlock>
80105395:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105398:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010539b:	83 ec 08             	sub    $0x8,%esp
8010539e:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801053a1:	52                   	push   %edx
801053a2:	50                   	push   %eax
801053a3:	e8 99 d1 ff ff       	call   80102541 <nameiparent>
801053a8:	83 c4 10             	add    $0x10,%esp
801053ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
801053ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801053b2:	74 71                	je     80105425 <sys_link+0x15a>
    goto bad;
  ilock(dp);
801053b4:	83 ec 0c             	sub    $0xc,%esp
801053b7:	ff 75 f0             	push   -0x10(%ebp)
801053ba:	e8 33 c6 ff ff       	call   801019f2 <ilock>
801053bf:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053c5:	8b 10                	mov    (%eax),%edx
801053c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ca:	8b 00                	mov    (%eax),%eax
801053cc:	39 c2                	cmp    %eax,%edx
801053ce:	75 1d                	jne    801053ed <sys_link+0x122>
801053d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d3:	8b 40 04             	mov    0x4(%eax),%eax
801053d6:	83 ec 04             	sub    $0x4,%esp
801053d9:	50                   	push   %eax
801053da:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801053dd:	50                   	push   %eax
801053de:	ff 75 f0             	push   -0x10(%ebp)
801053e1:	e8 a8 ce ff ff       	call   8010228e <dirlink>
801053e6:	83 c4 10             	add    $0x10,%esp
801053e9:	85 c0                	test   %eax,%eax
801053eb:	79 10                	jns    801053fd <sys_link+0x132>
    iunlockput(dp);
801053ed:	83 ec 0c             	sub    $0xc,%esp
801053f0:	ff 75 f0             	push   -0x10(%ebp)
801053f3:	e8 2b c8 ff ff       	call   80101c23 <iunlockput>
801053f8:	83 c4 10             	add    $0x10,%esp
    goto bad;
801053fb:	eb 29                	jmp    80105426 <sys_link+0x15b>
  }
  iunlockput(dp);
801053fd:	83 ec 0c             	sub    $0xc,%esp
80105400:	ff 75 f0             	push   -0x10(%ebp)
80105403:	e8 1b c8 ff ff       	call   80101c23 <iunlockput>
80105408:	83 c4 10             	add    $0x10,%esp
  iput(ip);
8010540b:	83 ec 0c             	sub    $0xc,%esp
8010540e:	ff 75 f4             	push   -0xc(%ebp)
80105411:	e8 3d c7 ff ff       	call   80101b53 <iput>
80105416:	83 c4 10             	add    $0x10,%esp

  end_op();
80105419:	e8 ac dc ff ff       	call   801030ca <end_op>

  return 0;
8010541e:	b8 00 00 00 00       	mov    $0x0,%eax
80105423:	eb 48                	jmp    8010546d <sys_link+0x1a2>
    goto bad;
80105425:	90                   	nop

bad:
  ilock(ip);
80105426:	83 ec 0c             	sub    $0xc,%esp
80105429:	ff 75 f4             	push   -0xc(%ebp)
8010542c:	e8 c1 c5 ff ff       	call   801019f2 <ilock>
80105431:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105434:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105437:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010543b:	83 e8 01             	sub    $0x1,%eax
8010543e:	89 c2                	mov    %eax,%edx
80105440:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105443:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105447:	83 ec 0c             	sub    $0xc,%esp
8010544a:	ff 75 f4             	push   -0xc(%ebp)
8010544d:	e8 c3 c3 ff ff       	call   80101815 <iupdate>
80105452:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105455:	83 ec 0c             	sub    $0xc,%esp
80105458:	ff 75 f4             	push   -0xc(%ebp)
8010545b:	e8 c3 c7 ff ff       	call   80101c23 <iunlockput>
80105460:	83 c4 10             	add    $0x10,%esp
  end_op();
80105463:	e8 62 dc ff ff       	call   801030ca <end_op>
  return -1;
80105468:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010546d:	c9                   	leave
8010546e:	c3                   	ret

8010546f <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010546f:	55                   	push   %ebp
80105470:	89 e5                	mov    %esp,%ebp
80105472:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105475:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
8010547c:	eb 40                	jmp    801054be <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010547e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105481:	6a 10                	push   $0x10
80105483:	50                   	push   %eax
80105484:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105487:	50                   	push   %eax
80105488:	ff 75 08             	push   0x8(%ebp)
8010548b:	e8 4e ca ff ff       	call   80101ede <readi>
80105490:	83 c4 10             	add    $0x10,%esp
80105493:	83 f8 10             	cmp    $0x10,%eax
80105496:	74 0d                	je     801054a5 <isdirempty+0x36>
      panic("isdirempty: readi");
80105498:	83 ec 0c             	sub    $0xc,%esp
8010549b:	68 14 a6 10 80       	push   $0x8010a614
801054a0:	e8 04 b1 ff ff       	call   801005a9 <panic>
    if(de.inum != 0)
801054a5:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801054a9:	66 85 c0             	test   %ax,%ax
801054ac:	74 07                	je     801054b5 <isdirempty+0x46>
      return 0;
801054ae:	b8 00 00 00 00       	mov    $0x0,%eax
801054b3:	eb 1b                	jmp    801054d0 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054b8:	83 c0 10             	add    $0x10,%eax
801054bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801054be:	8b 45 08             	mov    0x8(%ebp),%eax
801054c1:	8b 40 58             	mov    0x58(%eax),%eax
801054c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054c7:	39 c2                	cmp    %eax,%edx
801054c9:	72 b3                	jb     8010547e <isdirempty+0xf>
  }
  return 1;
801054cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
801054d0:	c9                   	leave
801054d1:	c3                   	ret

801054d2 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801054d2:	55                   	push   %ebp
801054d3:	89 e5                	mov    %esp,%ebp
801054d5:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801054d8:	83 ec 08             	sub    $0x8,%esp
801054db:	8d 45 cc             	lea    -0x34(%ebp),%eax
801054de:	50                   	push   %eax
801054df:	6a 00                	push   $0x0
801054e1:	e8 a2 fa ff ff       	call   80104f88 <argstr>
801054e6:	83 c4 10             	add    $0x10,%esp
801054e9:	85 c0                	test   %eax,%eax
801054eb:	79 0a                	jns    801054f7 <sys_unlink+0x25>
    return -1;
801054ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054f2:	e9 bf 01 00 00       	jmp    801056b6 <sys_unlink+0x1e4>

  begin_op();
801054f7:	e8 42 db ff ff       	call   8010303e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801054fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
801054ff:	83 ec 08             	sub    $0x8,%esp
80105502:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105505:	52                   	push   %edx
80105506:	50                   	push   %eax
80105507:	e8 35 d0 ff ff       	call   80102541 <nameiparent>
8010550c:	83 c4 10             	add    $0x10,%esp
8010550f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105512:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105516:	75 0f                	jne    80105527 <sys_unlink+0x55>
    end_op();
80105518:	e8 ad db ff ff       	call   801030ca <end_op>
    return -1;
8010551d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105522:	e9 8f 01 00 00       	jmp    801056b6 <sys_unlink+0x1e4>
  }

  ilock(dp);
80105527:	83 ec 0c             	sub    $0xc,%esp
8010552a:	ff 75 f4             	push   -0xc(%ebp)
8010552d:	e8 c0 c4 ff ff       	call   801019f2 <ilock>
80105532:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105535:	83 ec 08             	sub    $0x8,%esp
80105538:	68 26 a6 10 80       	push   $0x8010a626
8010553d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105540:	50                   	push   %eax
80105541:	e8 73 cc ff ff       	call   801021b9 <namecmp>
80105546:	83 c4 10             	add    $0x10,%esp
80105549:	85 c0                	test   %eax,%eax
8010554b:	0f 84 49 01 00 00    	je     8010569a <sys_unlink+0x1c8>
80105551:	83 ec 08             	sub    $0x8,%esp
80105554:	68 28 a6 10 80       	push   $0x8010a628
80105559:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010555c:	50                   	push   %eax
8010555d:	e8 57 cc ff ff       	call   801021b9 <namecmp>
80105562:	83 c4 10             	add    $0x10,%esp
80105565:	85 c0                	test   %eax,%eax
80105567:	0f 84 2d 01 00 00    	je     8010569a <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010556d:	83 ec 04             	sub    $0x4,%esp
80105570:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105573:	50                   	push   %eax
80105574:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105577:	50                   	push   %eax
80105578:	ff 75 f4             	push   -0xc(%ebp)
8010557b:	e8 54 cc ff ff       	call   801021d4 <dirlookup>
80105580:	83 c4 10             	add    $0x10,%esp
80105583:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105586:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010558a:	0f 84 0d 01 00 00    	je     8010569d <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
80105590:	83 ec 0c             	sub    $0xc,%esp
80105593:	ff 75 f0             	push   -0x10(%ebp)
80105596:	e8 57 c4 ff ff       	call   801019f2 <ilock>
8010559b:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
8010559e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055a1:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801055a5:	66 85 c0             	test   %ax,%ax
801055a8:	7f 0d                	jg     801055b7 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801055aa:	83 ec 0c             	sub    $0xc,%esp
801055ad:	68 2b a6 10 80       	push   $0x8010a62b
801055b2:	e8 f2 af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801055b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055ba:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801055be:	66 83 f8 01          	cmp    $0x1,%ax
801055c2:	75 25                	jne    801055e9 <sys_unlink+0x117>
801055c4:	83 ec 0c             	sub    $0xc,%esp
801055c7:	ff 75 f0             	push   -0x10(%ebp)
801055ca:	e8 a0 fe ff ff       	call   8010546f <isdirempty>
801055cf:	83 c4 10             	add    $0x10,%esp
801055d2:	85 c0                	test   %eax,%eax
801055d4:	75 13                	jne    801055e9 <sys_unlink+0x117>
    iunlockput(ip);
801055d6:	83 ec 0c             	sub    $0xc,%esp
801055d9:	ff 75 f0             	push   -0x10(%ebp)
801055dc:	e8 42 c6 ff ff       	call   80101c23 <iunlockput>
801055e1:	83 c4 10             	add    $0x10,%esp
    goto bad;
801055e4:	e9 b5 00 00 00       	jmp    8010569e <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
801055e9:	83 ec 04             	sub    $0x4,%esp
801055ec:	6a 10                	push   $0x10
801055ee:	6a 00                	push   $0x0
801055f0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801055f3:	50                   	push   %eax
801055f4:	e8 cf f5 ff ff       	call   80104bc8 <memset>
801055f9:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
801055ff:	6a 10                	push   $0x10
80105601:	50                   	push   %eax
80105602:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105605:	50                   	push   %eax
80105606:	ff 75 f4             	push   -0xc(%ebp)
80105609:	e8 25 ca ff ff       	call   80102033 <writei>
8010560e:	83 c4 10             	add    $0x10,%esp
80105611:	83 f8 10             	cmp    $0x10,%eax
80105614:	74 0d                	je     80105623 <sys_unlink+0x151>
    panic("unlink: writei");
80105616:	83 ec 0c             	sub    $0xc,%esp
80105619:	68 3d a6 10 80       	push   $0x8010a63d
8010561e:	e8 86 af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR){
80105623:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105626:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010562a:	66 83 f8 01          	cmp    $0x1,%ax
8010562e:	75 21                	jne    80105651 <sys_unlink+0x17f>
    dp->nlink--;
80105630:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105633:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105637:	83 e8 01             	sub    $0x1,%eax
8010563a:	89 c2                	mov    %eax,%edx
8010563c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010563f:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105643:	83 ec 0c             	sub    $0xc,%esp
80105646:	ff 75 f4             	push   -0xc(%ebp)
80105649:	e8 c7 c1 ff ff       	call   80101815 <iupdate>
8010564e:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105651:	83 ec 0c             	sub    $0xc,%esp
80105654:	ff 75 f4             	push   -0xc(%ebp)
80105657:	e8 c7 c5 ff ff       	call   80101c23 <iunlockput>
8010565c:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010565f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105662:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105666:	83 e8 01             	sub    $0x1,%eax
80105669:	89 c2                	mov    %eax,%edx
8010566b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010566e:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105672:	83 ec 0c             	sub    $0xc,%esp
80105675:	ff 75 f0             	push   -0x10(%ebp)
80105678:	e8 98 c1 ff ff       	call   80101815 <iupdate>
8010567d:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	ff 75 f0             	push   -0x10(%ebp)
80105686:	e8 98 c5 ff ff       	call   80101c23 <iunlockput>
8010568b:	83 c4 10             	add    $0x10,%esp

  end_op();
8010568e:	e8 37 da ff ff       	call   801030ca <end_op>

  return 0;
80105693:	b8 00 00 00 00       	mov    $0x0,%eax
80105698:	eb 1c                	jmp    801056b6 <sys_unlink+0x1e4>
    goto bad;
8010569a:	90                   	nop
8010569b:	eb 01                	jmp    8010569e <sys_unlink+0x1cc>
    goto bad;
8010569d:	90                   	nop

bad:
  iunlockput(dp);
8010569e:	83 ec 0c             	sub    $0xc,%esp
801056a1:	ff 75 f4             	push   -0xc(%ebp)
801056a4:	e8 7a c5 ff ff       	call   80101c23 <iunlockput>
801056a9:	83 c4 10             	add    $0x10,%esp
  end_op();
801056ac:	e8 19 da ff ff       	call   801030ca <end_op>
  return -1;
801056b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056b6:	c9                   	leave
801056b7:	c3                   	ret

801056b8 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801056b8:	55                   	push   %ebp
801056b9:	89 e5                	mov    %esp,%ebp
801056bb:	83 ec 38             	sub    $0x38,%esp
801056be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801056c1:	8b 55 10             	mov    0x10(%ebp),%edx
801056c4:	8b 45 14             	mov    0x14(%ebp),%eax
801056c7:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801056cb:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801056cf:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056d3:	83 ec 08             	sub    $0x8,%esp
801056d6:	8d 45 de             	lea    -0x22(%ebp),%eax
801056d9:	50                   	push   %eax
801056da:	ff 75 08             	push   0x8(%ebp)
801056dd:	e8 5f ce ff ff       	call   80102541 <nameiparent>
801056e2:	83 c4 10             	add    $0x10,%esp
801056e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056ec:	75 0a                	jne    801056f8 <create+0x40>
    return 0;
801056ee:	b8 00 00 00 00       	mov    $0x0,%eax
801056f3:	e9 90 01 00 00       	jmp    80105888 <create+0x1d0>
  ilock(dp);
801056f8:	83 ec 0c             	sub    $0xc,%esp
801056fb:	ff 75 f4             	push   -0xc(%ebp)
801056fe:	e8 ef c2 ff ff       	call   801019f2 <ilock>
80105703:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105706:	83 ec 04             	sub    $0x4,%esp
80105709:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010570c:	50                   	push   %eax
8010570d:	8d 45 de             	lea    -0x22(%ebp),%eax
80105710:	50                   	push   %eax
80105711:	ff 75 f4             	push   -0xc(%ebp)
80105714:	e8 bb ca ff ff       	call   801021d4 <dirlookup>
80105719:	83 c4 10             	add    $0x10,%esp
8010571c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010571f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105723:	74 50                	je     80105775 <create+0xbd>
    iunlockput(dp);
80105725:	83 ec 0c             	sub    $0xc,%esp
80105728:	ff 75 f4             	push   -0xc(%ebp)
8010572b:	e8 f3 c4 ff ff       	call   80101c23 <iunlockput>
80105730:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105733:	83 ec 0c             	sub    $0xc,%esp
80105736:	ff 75 f0             	push   -0x10(%ebp)
80105739:	e8 b4 c2 ff ff       	call   801019f2 <ilock>
8010573e:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105741:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105746:	75 15                	jne    8010575d <create+0xa5>
80105748:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010574b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010574f:	66 83 f8 02          	cmp    $0x2,%ax
80105753:	75 08                	jne    8010575d <create+0xa5>
      return ip;
80105755:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105758:	e9 2b 01 00 00       	jmp    80105888 <create+0x1d0>
    iunlockput(ip);
8010575d:	83 ec 0c             	sub    $0xc,%esp
80105760:	ff 75 f0             	push   -0x10(%ebp)
80105763:	e8 bb c4 ff ff       	call   80101c23 <iunlockput>
80105768:	83 c4 10             	add    $0x10,%esp
    return 0;
8010576b:	b8 00 00 00 00       	mov    $0x0,%eax
80105770:	e9 13 01 00 00       	jmp    80105888 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105775:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010577c:	8b 00                	mov    (%eax),%eax
8010577e:	83 ec 08             	sub    $0x8,%esp
80105781:	52                   	push   %edx
80105782:	50                   	push   %eax
80105783:	e8 b7 bf ff ff       	call   8010173f <ialloc>
80105788:	83 c4 10             	add    $0x10,%esp
8010578b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010578e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105792:	75 0d                	jne    801057a1 <create+0xe9>
    panic("create: ialloc");
80105794:	83 ec 0c             	sub    $0xc,%esp
80105797:	68 4c a6 10 80       	push   $0x8010a64c
8010579c:	e8 08 ae ff ff       	call   801005a9 <panic>

  ilock(ip);
801057a1:	83 ec 0c             	sub    $0xc,%esp
801057a4:	ff 75 f0             	push   -0x10(%ebp)
801057a7:	e8 46 c2 ff ff       	call   801019f2 <ilock>
801057ac:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801057af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b2:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801057b6:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
801057ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057bd:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801057c1:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
801057c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057c8:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
801057ce:	83 ec 0c             	sub    $0xc,%esp
801057d1:	ff 75 f0             	push   -0x10(%ebp)
801057d4:	e8 3c c0 ff ff       	call   80101815 <iupdate>
801057d9:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801057dc:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801057e1:	75 6a                	jne    8010584d <create+0x195>
    dp->nlink++;  // for ".."
801057e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e6:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801057ea:	83 c0 01             	add    $0x1,%eax
801057ed:	89 c2                	mov    %eax,%edx
801057ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f2:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801057f6:	83 ec 0c             	sub    $0xc,%esp
801057f9:	ff 75 f4             	push   -0xc(%ebp)
801057fc:	e8 14 c0 ff ff       	call   80101815 <iupdate>
80105801:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105804:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105807:	8b 40 04             	mov    0x4(%eax),%eax
8010580a:	83 ec 04             	sub    $0x4,%esp
8010580d:	50                   	push   %eax
8010580e:	68 26 a6 10 80       	push   $0x8010a626
80105813:	ff 75 f0             	push   -0x10(%ebp)
80105816:	e8 73 ca ff ff       	call   8010228e <dirlink>
8010581b:	83 c4 10             	add    $0x10,%esp
8010581e:	85 c0                	test   %eax,%eax
80105820:	78 1e                	js     80105840 <create+0x188>
80105822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105825:	8b 40 04             	mov    0x4(%eax),%eax
80105828:	83 ec 04             	sub    $0x4,%esp
8010582b:	50                   	push   %eax
8010582c:	68 28 a6 10 80       	push   $0x8010a628
80105831:	ff 75 f0             	push   -0x10(%ebp)
80105834:	e8 55 ca ff ff       	call   8010228e <dirlink>
80105839:	83 c4 10             	add    $0x10,%esp
8010583c:	85 c0                	test   %eax,%eax
8010583e:	79 0d                	jns    8010584d <create+0x195>
      panic("create dots");
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	68 5b a6 10 80       	push   $0x8010a65b
80105848:	e8 5c ad ff ff       	call   801005a9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010584d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105850:	8b 40 04             	mov    0x4(%eax),%eax
80105853:	83 ec 04             	sub    $0x4,%esp
80105856:	50                   	push   %eax
80105857:	8d 45 de             	lea    -0x22(%ebp),%eax
8010585a:	50                   	push   %eax
8010585b:	ff 75 f4             	push   -0xc(%ebp)
8010585e:	e8 2b ca ff ff       	call   8010228e <dirlink>
80105863:	83 c4 10             	add    $0x10,%esp
80105866:	85 c0                	test   %eax,%eax
80105868:	79 0d                	jns    80105877 <create+0x1bf>
    panic("create: dirlink");
8010586a:	83 ec 0c             	sub    $0xc,%esp
8010586d:	68 67 a6 10 80       	push   $0x8010a667
80105872:	e8 32 ad ff ff       	call   801005a9 <panic>

  iunlockput(dp);
80105877:	83 ec 0c             	sub    $0xc,%esp
8010587a:	ff 75 f4             	push   -0xc(%ebp)
8010587d:	e8 a1 c3 ff ff       	call   80101c23 <iunlockput>
80105882:	83 c4 10             	add    $0x10,%esp

  return ip;
80105885:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105888:	c9                   	leave
80105889:	c3                   	ret

8010588a <sys_open>:

int
sys_open(void)
{
8010588a:	55                   	push   %ebp
8010588b:	89 e5                	mov    %esp,%ebp
8010588d:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105890:	83 ec 08             	sub    $0x8,%esp
80105893:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105896:	50                   	push   %eax
80105897:	6a 00                	push   $0x0
80105899:	e8 ea f6 ff ff       	call   80104f88 <argstr>
8010589e:	83 c4 10             	add    $0x10,%esp
801058a1:	85 c0                	test   %eax,%eax
801058a3:	78 15                	js     801058ba <sys_open+0x30>
801058a5:	83 ec 08             	sub    $0x8,%esp
801058a8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058ab:	50                   	push   %eax
801058ac:	6a 01                	push   $0x1
801058ae:	e8 40 f6 ff ff       	call   80104ef3 <argint>
801058b3:	83 c4 10             	add    $0x10,%esp
801058b6:	85 c0                	test   %eax,%eax
801058b8:	79 0a                	jns    801058c4 <sys_open+0x3a>
    return -1;
801058ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058bf:	e9 61 01 00 00       	jmp    80105a25 <sys_open+0x19b>

  begin_op();
801058c4:	e8 75 d7 ff ff       	call   8010303e <begin_op>

  if(omode & O_CREATE){
801058c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801058cc:	25 00 02 00 00       	and    $0x200,%eax
801058d1:	85 c0                	test   %eax,%eax
801058d3:	74 2a                	je     801058ff <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801058d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801058d8:	6a 00                	push   $0x0
801058da:	6a 00                	push   $0x0
801058dc:	6a 02                	push   $0x2
801058de:	50                   	push   %eax
801058df:	e8 d4 fd ff ff       	call   801056b8 <create>
801058e4:	83 c4 10             	add    $0x10,%esp
801058e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801058ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058ee:	75 75                	jne    80105965 <sys_open+0xdb>
      end_op();
801058f0:	e8 d5 d7 ff ff       	call   801030ca <end_op>
      return -1;
801058f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058fa:	e9 26 01 00 00       	jmp    80105a25 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801058ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105902:	83 ec 0c             	sub    $0xc,%esp
80105905:	50                   	push   %eax
80105906:	e8 1a cc ff ff       	call   80102525 <namei>
8010590b:	83 c4 10             	add    $0x10,%esp
8010590e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105911:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105915:	75 0f                	jne    80105926 <sys_open+0x9c>
      end_op();
80105917:	e8 ae d7 ff ff       	call   801030ca <end_op>
      return -1;
8010591c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105921:	e9 ff 00 00 00       	jmp    80105a25 <sys_open+0x19b>
    }
    ilock(ip);
80105926:	83 ec 0c             	sub    $0xc,%esp
80105929:	ff 75 f4             	push   -0xc(%ebp)
8010592c:	e8 c1 c0 ff ff       	call   801019f2 <ilock>
80105931:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105937:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010593b:	66 83 f8 01          	cmp    $0x1,%ax
8010593f:	75 24                	jne    80105965 <sys_open+0xdb>
80105941:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105944:	85 c0                	test   %eax,%eax
80105946:	74 1d                	je     80105965 <sys_open+0xdb>
      iunlockput(ip);
80105948:	83 ec 0c             	sub    $0xc,%esp
8010594b:	ff 75 f4             	push   -0xc(%ebp)
8010594e:	e8 d0 c2 ff ff       	call   80101c23 <iunlockput>
80105953:	83 c4 10             	add    $0x10,%esp
      end_op();
80105956:	e8 6f d7 ff ff       	call   801030ca <end_op>
      return -1;
8010595b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105960:	e9 c0 00 00 00       	jmp    80105a25 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105965:	e8 7d b6 ff ff       	call   80100fe7 <filealloc>
8010596a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010596d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105971:	74 17                	je     8010598a <sys_open+0x100>
80105973:	83 ec 0c             	sub    $0xc,%esp
80105976:	ff 75 f0             	push   -0x10(%ebp)
80105979:	e8 33 f7 ff ff       	call   801050b1 <fdalloc>
8010597e:	83 c4 10             	add    $0x10,%esp
80105981:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105984:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105988:	79 2e                	jns    801059b8 <sys_open+0x12e>
    if(f)
8010598a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010598e:	74 0e                	je     8010599e <sys_open+0x114>
      fileclose(f);
80105990:	83 ec 0c             	sub    $0xc,%esp
80105993:	ff 75 f0             	push   -0x10(%ebp)
80105996:	e8 0a b7 ff ff       	call   801010a5 <fileclose>
8010599b:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010599e:	83 ec 0c             	sub    $0xc,%esp
801059a1:	ff 75 f4             	push   -0xc(%ebp)
801059a4:	e8 7a c2 ff ff       	call   80101c23 <iunlockput>
801059a9:	83 c4 10             	add    $0x10,%esp
    end_op();
801059ac:	e8 19 d7 ff ff       	call   801030ca <end_op>
    return -1;
801059b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059b6:	eb 6d                	jmp    80105a25 <sys_open+0x19b>
  }
  iunlock(ip);
801059b8:	83 ec 0c             	sub    $0xc,%esp
801059bb:	ff 75 f4             	push   -0xc(%ebp)
801059be:	e8 42 c1 ff ff       	call   80101b05 <iunlock>
801059c3:	83 c4 10             	add    $0x10,%esp
  end_op();
801059c6:	e8 ff d6 ff ff       	call   801030ca <end_op>

  f->type = FD_INODE;
801059cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059ce:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801059d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059da:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801059dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059e0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801059e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801059ea:	83 e0 01             	and    $0x1,%eax
801059ed:	85 c0                	test   %eax,%eax
801059ef:	0f 94 c0             	sete   %al
801059f2:	89 c2                	mov    %eax,%edx
801059f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059f7:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801059fd:	83 e0 01             	and    $0x1,%eax
80105a00:	85 c0                	test   %eax,%eax
80105a02:	75 0a                	jne    80105a0e <sys_open+0x184>
80105a04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a07:	83 e0 02             	and    $0x2,%eax
80105a0a:	85 c0                	test   %eax,%eax
80105a0c:	74 07                	je     80105a15 <sys_open+0x18b>
80105a0e:	b8 01 00 00 00       	mov    $0x1,%eax
80105a13:	eb 05                	jmp    80105a1a <sys_open+0x190>
80105a15:	b8 00 00 00 00       	mov    $0x0,%eax
80105a1a:	89 c2                	mov    %eax,%edx
80105a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a1f:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105a25:	c9                   	leave
80105a26:	c3                   	ret

80105a27 <sys_mkdir>:

int
sys_mkdir(void)
{
80105a27:	55                   	push   %ebp
80105a28:	89 e5                	mov    %esp,%ebp
80105a2a:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a2d:	e8 0c d6 ff ff       	call   8010303e <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a32:	83 ec 08             	sub    $0x8,%esp
80105a35:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a38:	50                   	push   %eax
80105a39:	6a 00                	push   $0x0
80105a3b:	e8 48 f5 ff ff       	call   80104f88 <argstr>
80105a40:	83 c4 10             	add    $0x10,%esp
80105a43:	85 c0                	test   %eax,%eax
80105a45:	78 1b                	js     80105a62 <sys_mkdir+0x3b>
80105a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a4a:	6a 00                	push   $0x0
80105a4c:	6a 00                	push   $0x0
80105a4e:	6a 01                	push   $0x1
80105a50:	50                   	push   %eax
80105a51:	e8 62 fc ff ff       	call   801056b8 <create>
80105a56:	83 c4 10             	add    $0x10,%esp
80105a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a60:	75 0c                	jne    80105a6e <sys_mkdir+0x47>
    end_op();
80105a62:	e8 63 d6 ff ff       	call   801030ca <end_op>
    return -1;
80105a67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a6c:	eb 18                	jmp    80105a86 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80105a6e:	83 ec 0c             	sub    $0xc,%esp
80105a71:	ff 75 f4             	push   -0xc(%ebp)
80105a74:	e8 aa c1 ff ff       	call   80101c23 <iunlockput>
80105a79:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a7c:	e8 49 d6 ff ff       	call   801030ca <end_op>
  return 0;
80105a81:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a86:	c9                   	leave
80105a87:	c3                   	ret

80105a88 <sys_mknod>:

int
sys_mknod(void)
{
80105a88:	55                   	push   %ebp
80105a89:	89 e5                	mov    %esp,%ebp
80105a8b:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a8e:	e8 ab d5 ff ff       	call   8010303e <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a93:	83 ec 08             	sub    $0x8,%esp
80105a96:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a99:	50                   	push   %eax
80105a9a:	6a 00                	push   $0x0
80105a9c:	e8 e7 f4 ff ff       	call   80104f88 <argstr>
80105aa1:	83 c4 10             	add    $0x10,%esp
80105aa4:	85 c0                	test   %eax,%eax
80105aa6:	78 4f                	js     80105af7 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
80105aa8:	83 ec 08             	sub    $0x8,%esp
80105aab:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105aae:	50                   	push   %eax
80105aaf:	6a 01                	push   $0x1
80105ab1:	e8 3d f4 ff ff       	call   80104ef3 <argint>
80105ab6:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	78 3a                	js     80105af7 <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
80105abd:	83 ec 08             	sub    $0x8,%esp
80105ac0:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105ac3:	50                   	push   %eax
80105ac4:	6a 02                	push   $0x2
80105ac6:	e8 28 f4 ff ff       	call   80104ef3 <argint>
80105acb:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80105ace:	85 c0                	test   %eax,%eax
80105ad0:	78 25                	js     80105af7 <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ad5:	0f bf c8             	movswl %ax,%ecx
80105ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105adb:	0f bf d0             	movswl %ax,%edx
80105ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ae1:	51                   	push   %ecx
80105ae2:	52                   	push   %edx
80105ae3:	6a 03                	push   $0x3
80105ae5:	50                   	push   %eax
80105ae6:	e8 cd fb ff ff       	call   801056b8 <create>
80105aeb:	83 c4 10             	add    $0x10,%esp
80105aee:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80105af1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105af5:	75 0c                	jne    80105b03 <sys_mknod+0x7b>
    end_op();
80105af7:	e8 ce d5 ff ff       	call   801030ca <end_op>
    return -1;
80105afc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b01:	eb 18                	jmp    80105b1b <sys_mknod+0x93>
  }
  iunlockput(ip);
80105b03:	83 ec 0c             	sub    $0xc,%esp
80105b06:	ff 75 f4             	push   -0xc(%ebp)
80105b09:	e8 15 c1 ff ff       	call   80101c23 <iunlockput>
80105b0e:	83 c4 10             	add    $0x10,%esp
  end_op();
80105b11:	e8 b4 d5 ff ff       	call   801030ca <end_op>
  return 0;
80105b16:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b1b:	c9                   	leave
80105b1c:	c3                   	ret

80105b1d <sys_chdir>:

int
sys_chdir(void)
{
80105b1d:	55                   	push   %ebp
80105b1e:	89 e5                	mov    %esp,%ebp
80105b20:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b23:	e8 08 df ff ff       	call   80103a30 <myproc>
80105b28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105b2b:	e8 0e d5 ff ff       	call   8010303e <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b30:	83 ec 08             	sub    $0x8,%esp
80105b33:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b36:	50                   	push   %eax
80105b37:	6a 00                	push   $0x0
80105b39:	e8 4a f4 ff ff       	call   80104f88 <argstr>
80105b3e:	83 c4 10             	add    $0x10,%esp
80105b41:	85 c0                	test   %eax,%eax
80105b43:	78 18                	js     80105b5d <sys_chdir+0x40>
80105b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b48:	83 ec 0c             	sub    $0xc,%esp
80105b4b:	50                   	push   %eax
80105b4c:	e8 d4 c9 ff ff       	call   80102525 <namei>
80105b51:	83 c4 10             	add    $0x10,%esp
80105b54:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b5b:	75 0c                	jne    80105b69 <sys_chdir+0x4c>
    end_op();
80105b5d:	e8 68 d5 ff ff       	call   801030ca <end_op>
    return -1;
80105b62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b67:	eb 68                	jmp    80105bd1 <sys_chdir+0xb4>
  }
  ilock(ip);
80105b69:	83 ec 0c             	sub    $0xc,%esp
80105b6c:	ff 75 f0             	push   -0x10(%ebp)
80105b6f:	e8 7e be ff ff       	call   801019f2 <ilock>
80105b74:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b7a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105b7e:	66 83 f8 01          	cmp    $0x1,%ax
80105b82:	74 1a                	je     80105b9e <sys_chdir+0x81>
    iunlockput(ip);
80105b84:	83 ec 0c             	sub    $0xc,%esp
80105b87:	ff 75 f0             	push   -0x10(%ebp)
80105b8a:	e8 94 c0 ff ff       	call   80101c23 <iunlockput>
80105b8f:	83 c4 10             	add    $0x10,%esp
    end_op();
80105b92:	e8 33 d5 ff ff       	call   801030ca <end_op>
    return -1;
80105b97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9c:	eb 33                	jmp    80105bd1 <sys_chdir+0xb4>
  }
  iunlock(ip);
80105b9e:	83 ec 0c             	sub    $0xc,%esp
80105ba1:	ff 75 f0             	push   -0x10(%ebp)
80105ba4:	e8 5c bf ff ff       	call   80101b05 <iunlock>
80105ba9:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80105bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105baf:	8b 40 68             	mov    0x68(%eax),%eax
80105bb2:	83 ec 0c             	sub    $0xc,%esp
80105bb5:	50                   	push   %eax
80105bb6:	e8 98 bf ff ff       	call   80101b53 <iput>
80105bbb:	83 c4 10             	add    $0x10,%esp
  end_op();
80105bbe:	e8 07 d5 ff ff       	call   801030ca <end_op>
  curproc->cwd = ip;
80105bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc6:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105bc9:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105bcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bd1:	c9                   	leave
80105bd2:	c3                   	ret

80105bd3 <sys_exec>:

int
sys_exec(void)
{
80105bd3:	55                   	push   %ebp
80105bd4:	89 e5                	mov    %esp,%ebp
80105bd6:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105bdc:	83 ec 08             	sub    $0x8,%esp
80105bdf:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105be2:	50                   	push   %eax
80105be3:	6a 00                	push   $0x0
80105be5:	e8 9e f3 ff ff       	call   80104f88 <argstr>
80105bea:	83 c4 10             	add    $0x10,%esp
80105bed:	85 c0                	test   %eax,%eax
80105bef:	78 18                	js     80105c09 <sys_exec+0x36>
80105bf1:	83 ec 08             	sub    $0x8,%esp
80105bf4:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105bfa:	50                   	push   %eax
80105bfb:	6a 01                	push   $0x1
80105bfd:	e8 f1 f2 ff ff       	call   80104ef3 <argint>
80105c02:	83 c4 10             	add    $0x10,%esp
80105c05:	85 c0                	test   %eax,%eax
80105c07:	79 0a                	jns    80105c13 <sys_exec+0x40>
    return -1;
80105c09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c0e:	e9 c6 00 00 00       	jmp    80105cd9 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80105c13:	83 ec 04             	sub    $0x4,%esp
80105c16:	68 80 00 00 00       	push   $0x80
80105c1b:	6a 00                	push   $0x0
80105c1d:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105c23:	50                   	push   %eax
80105c24:	e8 9f ef ff ff       	call   80104bc8 <memset>
80105c29:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105c2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c36:	83 f8 1f             	cmp    $0x1f,%eax
80105c39:	76 0a                	jbe    80105c45 <sys_exec+0x72>
      return -1;
80105c3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c40:	e9 94 00 00 00       	jmp    80105cd9 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c48:	c1 e0 02             	shl    $0x2,%eax
80105c4b:	89 c2                	mov    %eax,%edx
80105c4d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105c53:	01 c2                	add    %eax,%edx
80105c55:	83 ec 08             	sub    $0x8,%esp
80105c58:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c5e:	50                   	push   %eax
80105c5f:	52                   	push   %edx
80105c60:	e8 ed f1 ff ff       	call   80104e52 <fetchint>
80105c65:	83 c4 10             	add    $0x10,%esp
80105c68:	85 c0                	test   %eax,%eax
80105c6a:	79 07                	jns    80105c73 <sys_exec+0xa0>
      return -1;
80105c6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c71:	eb 66                	jmp    80105cd9 <sys_exec+0x106>
    if(uarg == 0){
80105c73:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	75 27                	jne    80105ca4 <sys_exec+0xd1>
      argv[i] = 0;
80105c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c80:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105c87:	00 00 00 00 
      break;
80105c8b:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c8f:	83 ec 08             	sub    $0x8,%esp
80105c92:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105c98:	52                   	push   %edx
80105c99:	50                   	push   %eax
80105c9a:	e8 eb ae ff ff       	call   80100b8a <exec>
80105c9f:	83 c4 10             	add    $0x10,%esp
80105ca2:	eb 35                	jmp    80105cd9 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80105ca4:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105caa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cad:	c1 e2 02             	shl    $0x2,%edx
80105cb0:	01 c2                	add    %eax,%edx
80105cb2:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105cb8:	83 ec 08             	sub    $0x8,%esp
80105cbb:	52                   	push   %edx
80105cbc:	50                   	push   %eax
80105cbd:	e8 cf f1 ff ff       	call   80104e91 <fetchstr>
80105cc2:	83 c4 10             	add    $0x10,%esp
80105cc5:	85 c0                	test   %eax,%eax
80105cc7:	79 07                	jns    80105cd0 <sys_exec+0xfd>
      return -1;
80105cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cce:	eb 09                	jmp    80105cd9 <sys_exec+0x106>
  for(i=0;; i++){
80105cd0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80105cd4:	e9 5a ff ff ff       	jmp    80105c33 <sys_exec+0x60>
}
80105cd9:	c9                   	leave
80105cda:	c3                   	ret

80105cdb <sys_pipe>:

int
sys_pipe(void)
{
80105cdb:	55                   	push   %ebp
80105cdc:	89 e5                	mov    %esp,%ebp
80105cde:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ce1:	83 ec 04             	sub    $0x4,%esp
80105ce4:	6a 08                	push   $0x8
80105ce6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ce9:	50                   	push   %eax
80105cea:	6a 00                	push   $0x0
80105cec:	e8 2f f2 ff ff       	call   80104f20 <argptr>
80105cf1:	83 c4 10             	add    $0x10,%esp
80105cf4:	85 c0                	test   %eax,%eax
80105cf6:	79 0a                	jns    80105d02 <sys_pipe+0x27>
    return -1;
80105cf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cfd:	e9 ae 00 00 00       	jmp    80105db0 <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
80105d02:	83 ec 08             	sub    $0x8,%esp
80105d05:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d08:	50                   	push   %eax
80105d09:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d0c:	50                   	push   %eax
80105d0d:	e8 5b d8 ff ff       	call   8010356d <pipealloc>
80105d12:	83 c4 10             	add    $0x10,%esp
80105d15:	85 c0                	test   %eax,%eax
80105d17:	79 0a                	jns    80105d23 <sys_pipe+0x48>
    return -1;
80105d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d1e:	e9 8d 00 00 00       	jmp    80105db0 <sys_pipe+0xd5>
  fd0 = -1;
80105d23:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d2d:	83 ec 0c             	sub    $0xc,%esp
80105d30:	50                   	push   %eax
80105d31:	e8 7b f3 ff ff       	call   801050b1 <fdalloc>
80105d36:	83 c4 10             	add    $0x10,%esp
80105d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d40:	78 18                	js     80105d5a <sys_pipe+0x7f>
80105d42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d45:	83 ec 0c             	sub    $0xc,%esp
80105d48:	50                   	push   %eax
80105d49:	e8 63 f3 ff ff       	call   801050b1 <fdalloc>
80105d4e:	83 c4 10             	add    $0x10,%esp
80105d51:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d58:	79 3e                	jns    80105d98 <sys_pipe+0xbd>
    if(fd0 >= 0)
80105d5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d5e:	78 13                	js     80105d73 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105d60:	e8 cb dc ff ff       	call   80103a30 <myproc>
80105d65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d68:	83 c2 08             	add    $0x8,%edx
80105d6b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105d72:	00 
    fileclose(rf);
80105d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d76:	83 ec 0c             	sub    $0xc,%esp
80105d79:	50                   	push   %eax
80105d7a:	e8 26 b3 ff ff       	call   801010a5 <fileclose>
80105d7f:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105d82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d85:	83 ec 0c             	sub    $0xc,%esp
80105d88:	50                   	push   %eax
80105d89:	e8 17 b3 ff ff       	call   801010a5 <fileclose>
80105d8e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d96:	eb 18                	jmp    80105db0 <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80105d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d9e:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105da0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105da3:	8d 50 04             	lea    0x4(%eax),%edx
80105da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da9:	89 02                	mov    %eax,(%edx)
  return 0;
80105dab:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105db0:	c9                   	leave
80105db1:	c3                   	ret

80105db2 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105db2:	55                   	push   %ebp
80105db3:	89 e5                	mov    %esp,%ebp
80105db5:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105db8:	e8 72 df ff ff       	call   80103d2f <fork>
}
80105dbd:	c9                   	leave
80105dbe:	c3                   	ret

80105dbf <sys_exit>:

int
sys_exit(void)
{
80105dbf:	55                   	push   %ebp
80105dc0:	89 e5                	mov    %esp,%ebp
80105dc2:	83 ec 08             	sub    $0x8,%esp
  exit();
80105dc5:	e8 de e0 ff ff       	call   80103ea8 <exit>
  return 0;  // not reached
80105dca:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105dcf:	c9                   	leave
80105dd0:	c3                   	ret

80105dd1 <sys_wait>:

int
sys_wait(void)
{
80105dd1:	55                   	push   %ebp
80105dd2:	89 e5                	mov    %esp,%ebp
80105dd4:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105dd7:	e8 ec e1 ff ff       	call   80103fc8 <wait>
}
80105ddc:	c9                   	leave
80105ddd:	c3                   	ret

80105dde <sys_kill>:

int
sys_kill(void)
{
80105dde:	55                   	push   %ebp
80105ddf:	89 e5                	mov    %esp,%ebp
80105de1:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105de4:	83 ec 08             	sub    $0x8,%esp
80105de7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dea:	50                   	push   %eax
80105deb:	6a 00                	push   $0x0
80105ded:	e8 01 f1 ff ff       	call   80104ef3 <argint>
80105df2:	83 c4 10             	add    $0x10,%esp
80105df5:	85 c0                	test   %eax,%eax
80105df7:	79 07                	jns    80105e00 <sys_kill+0x22>
    return -1;
80105df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dfe:	eb 0f                	jmp    80105e0f <sys_kill+0x31>
  return kill(pid);
80105e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e03:	83 ec 0c             	sub    $0xc,%esp
80105e06:	50                   	push   %eax
80105e07:	e8 eb e5 ff ff       	call   801043f7 <kill>
80105e0c:	83 c4 10             	add    $0x10,%esp
}
80105e0f:	c9                   	leave
80105e10:	c3                   	ret

80105e11 <sys_getpid>:

int
sys_getpid(void)
{
80105e11:	55                   	push   %ebp
80105e12:	89 e5                	mov    %esp,%ebp
80105e14:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105e17:	e8 14 dc ff ff       	call   80103a30 <myproc>
80105e1c:	8b 40 10             	mov    0x10(%eax),%eax
}
80105e1f:	c9                   	leave
80105e20:	c3                   	ret

80105e21 <sys_sbrk>:

int
sys_sbrk(void)
{
80105e21:	55                   	push   %ebp
80105e22:	89 e5                	mov    %esp,%ebp
80105e24:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105e27:	83 ec 08             	sub    $0x8,%esp
80105e2a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e2d:	50                   	push   %eax
80105e2e:	6a 00                	push   $0x0
80105e30:	e8 be f0 ff ff       	call   80104ef3 <argint>
80105e35:	83 c4 10             	add    $0x10,%esp
80105e38:	85 c0                	test   %eax,%eax
80105e3a:	79 07                	jns    80105e43 <sys_sbrk+0x22>
    return -1;
80105e3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e41:	eb 27                	jmp    80105e6a <sys_sbrk+0x49>
  addr = myproc()->sz;
80105e43:	e8 e8 db ff ff       	call   80103a30 <myproc>
80105e48:	8b 00                	mov    (%eax),%eax
80105e4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80105e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	50                   	push   %eax
80105e54:	e8 3b de ff ff       	call   80103c94 <growproc>
80105e59:	83 c4 10             	add    $0x10,%esp
80105e5c:	85 c0                	test   %eax,%eax
80105e5e:	79 07                	jns    80105e67 <sys_sbrk+0x46>
    return -1;
80105e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e65:	eb 03                	jmp    80105e6a <sys_sbrk+0x49>
  return addr;
80105e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105e6a:	c9                   	leave
80105e6b:	c3                   	ret

80105e6c <sys_sleep>:

int
sys_sleep(void)
{
80105e6c:	55                   	push   %ebp
80105e6d:	89 e5                	mov    %esp,%ebp
80105e6f:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e72:	83 ec 08             	sub    $0x8,%esp
80105e75:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e78:	50                   	push   %eax
80105e79:	6a 00                	push   $0x0
80105e7b:	e8 73 f0 ff ff       	call   80104ef3 <argint>
80105e80:	83 c4 10             	add    $0x10,%esp
80105e83:	85 c0                	test   %eax,%eax
80105e85:	79 07                	jns    80105e8e <sys_sleep+0x22>
    return -1;
80105e87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e8c:	eb 76                	jmp    80105f04 <sys_sleep+0x98>
  acquire(&tickslock);
80105e8e:	83 ec 0c             	sub    $0xc,%esp
80105e91:	68 40 6a 19 80       	push   $0x80196a40
80105e96:	e8 b7 ea ff ff       	call   80104952 <acquire>
80105e9b:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105e9e:	a1 74 6a 19 80       	mov    0x80196a74,%eax
80105ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80105ea6:	eb 38                	jmp    80105ee0 <sys_sleep+0x74>
    if(myproc()->killed){
80105ea8:	e8 83 db ff ff       	call   80103a30 <myproc>
80105ead:	8b 40 24             	mov    0x24(%eax),%eax
80105eb0:	85 c0                	test   %eax,%eax
80105eb2:	74 17                	je     80105ecb <sys_sleep+0x5f>
      release(&tickslock);
80105eb4:	83 ec 0c             	sub    $0xc,%esp
80105eb7:	68 40 6a 19 80       	push   $0x80196a40
80105ebc:	e8 ff ea ff ff       	call   801049c0 <release>
80105ec1:	83 c4 10             	add    $0x10,%esp
      return -1;
80105ec4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ec9:	eb 39                	jmp    80105f04 <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80105ecb:	83 ec 08             	sub    $0x8,%esp
80105ece:	68 40 6a 19 80       	push   $0x80196a40
80105ed3:	68 74 6a 19 80       	push   $0x80196a74
80105ed8:	e8 fc e3 ff ff       	call   801042d9 <sleep>
80105edd:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80105ee0:	a1 74 6a 19 80       	mov    0x80196a74,%eax
80105ee5:	2b 45 f4             	sub    -0xc(%ebp),%eax
80105ee8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105eeb:	39 d0                	cmp    %edx,%eax
80105eed:	72 b9                	jb     80105ea8 <sys_sleep+0x3c>
  }
  release(&tickslock);
80105eef:	83 ec 0c             	sub    $0xc,%esp
80105ef2:	68 40 6a 19 80       	push   $0x80196a40
80105ef7:	e8 c4 ea ff ff       	call   801049c0 <release>
80105efc:	83 c4 10             	add    $0x10,%esp
  return 0;
80105eff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f04:	c9                   	leave
80105f05:	c3                   	ret

80105f06 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105f06:	55                   	push   %ebp
80105f07:	89 e5                	mov    %esp,%ebp
80105f09:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80105f0c:	83 ec 0c             	sub    $0xc,%esp
80105f0f:	68 40 6a 19 80       	push   $0x80196a40
80105f14:	e8 39 ea ff ff       	call   80104952 <acquire>
80105f19:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80105f1c:	a1 74 6a 19 80       	mov    0x80196a74,%eax
80105f21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80105f24:	83 ec 0c             	sub    $0xc,%esp
80105f27:	68 40 6a 19 80       	push   $0x80196a40
80105f2c:	e8 8f ea ff ff       	call   801049c0 <release>
80105f31:	83 c4 10             	add    $0x10,%esp
  return xticks;
80105f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f37:	c9                   	leave
80105f38:	c3                   	ret

80105f39 <sys_exit2>:

int
sys_exit2(void)
{
80105f39:	55                   	push   %ebp
80105f3a:	89 e5                	mov    %esp,%ebp
80105f3c:	83 ec 18             	sub    $0x18,%esp
  int status;
  if(argint(0, &status) < 0)
80105f3f:	83 ec 08             	sub    $0x8,%esp
80105f42:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f45:	50                   	push   %eax
80105f46:	6a 00                	push   $0x0
80105f48:	e8 a6 ef ff ff       	call   80104ef3 <argint>
80105f4d:	83 c4 10             	add    $0x10,%esp
80105f50:	85 c0                	test   %eax,%eax
80105f52:	79 07                	jns    80105f5b <sys_exit2+0x22>
    return -1;
80105f54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f59:	eb 14                	jmp    80105f6f <sys_exit2+0x36>
  exit2(status);
80105f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f5e:	83 ec 0c             	sub    $0xc,%esp
80105f61:	50                   	push   %eax
80105f62:	e8 0e e6 ff ff       	call   80104575 <exit2>
80105f67:	83 c4 10             	add    $0x10,%esp
  return 0;
80105f6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f6f:	c9                   	leave
80105f70:	c3                   	ret

80105f71 <sys_wait2>:

int
sys_wait2(void)
{
80105f71:	55                   	push   %ebp
80105f72:	89 e5                	mov    %esp,%ebp
80105f74:	83 ec 18             	sub    $0x18,%esp
  int *status;
  if(argptr(0, (char**)&status, sizeof(*status)) < 0)
80105f77:	83 ec 04             	sub    $0x4,%esp
80105f7a:	6a 04                	push   $0x4
80105f7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f7f:	50                   	push   %eax
80105f80:	6a 00                	push   $0x0
80105f82:	e8 99 ef ff ff       	call   80104f20 <argptr>
80105f87:	83 c4 10             	add    $0x10,%esp
80105f8a:	85 c0                	test   %eax,%eax
80105f8c:	79 07                	jns    80105f95 <sys_wait2+0x24>
    return -1;
80105f8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f93:	eb 0f                	jmp    80105fa4 <sys_wait2+0x33>
  return wait2(status);
80105f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f98:	83 ec 0c             	sub    $0xc,%esp
80105f9b:	50                   	push   %eax
80105f9c:	e8 fd e6 ff ff       	call   8010469e <wait2>
80105fa1:	83 c4 10             	add    $0x10,%esp
}
80105fa4:	c9                   	leave
80105fa5:	c3                   	ret

80105fa6 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105fa6:	1e                   	push   %ds
  pushl %es
80105fa7:	06                   	push   %es
  pushl %fs
80105fa8:	0f a0                	push   %fs
  pushl %gs
80105faa:	0f a8                	push   %gs
  pushal
80105fac:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105fad:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105fb1:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105fb3:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105fb5:	54                   	push   %esp
  call trap
80105fb6:	e8 d7 01 00 00       	call   80106192 <trap>
  addl $4, %esp
80105fbb:	83 c4 04             	add    $0x4,%esp

80105fbe <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105fbe:	61                   	popa
  popl %gs
80105fbf:	0f a9                	pop    %gs
  popl %fs
80105fc1:	0f a1                	pop    %fs
  popl %es
80105fc3:	07                   	pop    %es
  popl %ds
80105fc4:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105fc5:	83 c4 08             	add    $0x8,%esp
  iret
80105fc8:	cf                   	iret

80105fc9 <lidt>:
{
80105fc9:	55                   	push   %ebp
80105fca:	89 e5                	mov    %esp,%ebp
80105fcc:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80105fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fd2:	83 e8 01             	sub    $0x1,%eax
80105fd5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105fd9:	8b 45 08             	mov    0x8(%ebp),%eax
80105fdc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80105fe3:	c1 e8 10             	shr    $0x10,%eax
80105fe6:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105fea:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fed:	0f 01 18             	lidtl  (%eax)
}
80105ff0:	90                   	nop
80105ff1:	c9                   	leave
80105ff2:	c3                   	ret

80105ff3 <rcr2>:

static inline uint
rcr2(void)
{
80105ff3:	55                   	push   %ebp
80105ff4:	89 e5                	mov    %esp,%ebp
80105ff6:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ff9:	0f 20 d0             	mov    %cr2,%eax
80105ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80105fff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106002:	c9                   	leave
80106003:	c3                   	ret

80106004 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106004:	55                   	push   %ebp
80106005:	89 e5                	mov    %esp,%ebp
80106007:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
8010600a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106011:	e9 c3 00 00 00       	jmp    801060d9 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106016:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106019:	8b 04 85 80 f0 10 80 	mov    -0x7fef0f80(,%eax,4),%eax
80106020:	89 c2                	mov    %eax,%edx
80106022:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106025:	66 89 14 c5 40 62 19 	mov    %dx,-0x7fe69dc0(,%eax,8)
8010602c:	80 
8010602d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106030:	66 c7 04 c5 42 62 19 	movw   $0x8,-0x7fe69dbe(,%eax,8)
80106037:	80 08 00 
8010603a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010603d:	0f b6 14 c5 44 62 19 	movzbl -0x7fe69dbc(,%eax,8),%edx
80106044:	80 
80106045:	83 e2 e0             	and    $0xffffffe0,%edx
80106048:	88 14 c5 44 62 19 80 	mov    %dl,-0x7fe69dbc(,%eax,8)
8010604f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106052:	0f b6 14 c5 44 62 19 	movzbl -0x7fe69dbc(,%eax,8),%edx
80106059:	80 
8010605a:	83 e2 1f             	and    $0x1f,%edx
8010605d:	88 14 c5 44 62 19 80 	mov    %dl,-0x7fe69dbc(,%eax,8)
80106064:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106067:	0f b6 14 c5 45 62 19 	movzbl -0x7fe69dbb(,%eax,8),%edx
8010606e:	80 
8010606f:	83 e2 f0             	and    $0xfffffff0,%edx
80106072:	83 ca 0e             	or     $0xe,%edx
80106075:	88 14 c5 45 62 19 80 	mov    %dl,-0x7fe69dbb(,%eax,8)
8010607c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607f:	0f b6 14 c5 45 62 19 	movzbl -0x7fe69dbb(,%eax,8),%edx
80106086:	80 
80106087:	83 e2 ef             	and    $0xffffffef,%edx
8010608a:	88 14 c5 45 62 19 80 	mov    %dl,-0x7fe69dbb(,%eax,8)
80106091:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106094:	0f b6 14 c5 45 62 19 	movzbl -0x7fe69dbb(,%eax,8),%edx
8010609b:	80 
8010609c:	83 e2 9f             	and    $0xffffff9f,%edx
8010609f:	88 14 c5 45 62 19 80 	mov    %dl,-0x7fe69dbb(,%eax,8)
801060a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a9:	0f b6 14 c5 45 62 19 	movzbl -0x7fe69dbb(,%eax,8),%edx
801060b0:	80 
801060b1:	83 ca 80             	or     $0xffffff80,%edx
801060b4:	88 14 c5 45 62 19 80 	mov    %dl,-0x7fe69dbb(,%eax,8)
801060bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060be:	8b 04 85 80 f0 10 80 	mov    -0x7fef0f80(,%eax,4),%eax
801060c5:	c1 e8 10             	shr    $0x10,%eax
801060c8:	89 c2                	mov    %eax,%edx
801060ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060cd:	66 89 14 c5 46 62 19 	mov    %dx,-0x7fe69dba(,%eax,8)
801060d4:	80 
  for(i = 0; i < 256; i++)
801060d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801060d9:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801060e0:	0f 8e 30 ff ff ff    	jle    80106016 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060e6:	a1 80 f1 10 80       	mov    0x8010f180,%eax
801060eb:	66 a3 40 64 19 80    	mov    %ax,0x80196440
801060f1:	66 c7 05 42 64 19 80 	movw   $0x8,0x80196442
801060f8:	08 00 
801060fa:	0f b6 05 44 64 19 80 	movzbl 0x80196444,%eax
80106101:	83 e0 e0             	and    $0xffffffe0,%eax
80106104:	a2 44 64 19 80       	mov    %al,0x80196444
80106109:	0f b6 05 44 64 19 80 	movzbl 0x80196444,%eax
80106110:	83 e0 1f             	and    $0x1f,%eax
80106113:	a2 44 64 19 80       	mov    %al,0x80196444
80106118:	0f b6 05 45 64 19 80 	movzbl 0x80196445,%eax
8010611f:	83 c8 0f             	or     $0xf,%eax
80106122:	a2 45 64 19 80       	mov    %al,0x80196445
80106127:	0f b6 05 45 64 19 80 	movzbl 0x80196445,%eax
8010612e:	83 e0 ef             	and    $0xffffffef,%eax
80106131:	a2 45 64 19 80       	mov    %al,0x80196445
80106136:	0f b6 05 45 64 19 80 	movzbl 0x80196445,%eax
8010613d:	83 c8 60             	or     $0x60,%eax
80106140:	a2 45 64 19 80       	mov    %al,0x80196445
80106145:	0f b6 05 45 64 19 80 	movzbl 0x80196445,%eax
8010614c:	83 c8 80             	or     $0xffffff80,%eax
8010614f:	a2 45 64 19 80       	mov    %al,0x80196445
80106154:	a1 80 f1 10 80       	mov    0x8010f180,%eax
80106159:	c1 e8 10             	shr    $0x10,%eax
8010615c:	66 a3 46 64 19 80    	mov    %ax,0x80196446

  initlock(&tickslock, "time");
80106162:	83 ec 08             	sub    $0x8,%esp
80106165:	68 78 a6 10 80       	push   $0x8010a678
8010616a:	68 40 6a 19 80       	push   $0x80196a40
8010616f:	e8 bc e7 ff ff       	call   80104930 <initlock>
80106174:	83 c4 10             	add    $0x10,%esp
}
80106177:	90                   	nop
80106178:	c9                   	leave
80106179:	c3                   	ret

8010617a <idtinit>:

void
idtinit(void)
{
8010617a:	55                   	push   %ebp
8010617b:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
8010617d:	68 00 08 00 00       	push   $0x800
80106182:	68 40 62 19 80       	push   $0x80196240
80106187:	e8 3d fe ff ff       	call   80105fc9 <lidt>
8010618c:	83 c4 08             	add    $0x8,%esp
}
8010618f:	90                   	nop
80106190:	c9                   	leave
80106191:	c3                   	ret

80106192 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106192:	55                   	push   %ebp
80106193:	89 e5                	mov    %esp,%ebp
80106195:	57                   	push   %edi
80106196:	56                   	push   %esi
80106197:	53                   	push   %ebx
80106198:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010619b:	8b 45 08             	mov    0x8(%ebp),%eax
8010619e:	8b 40 30             	mov    0x30(%eax),%eax
801061a1:	83 f8 40             	cmp    $0x40,%eax
801061a4:	75 3b                	jne    801061e1 <trap+0x4f>
    if(myproc()->killed)
801061a6:	e8 85 d8 ff ff       	call   80103a30 <myproc>
801061ab:	8b 40 24             	mov    0x24(%eax),%eax
801061ae:	85 c0                	test   %eax,%eax
801061b0:	74 05                	je     801061b7 <trap+0x25>
      exit();
801061b2:	e8 f1 dc ff ff       	call   80103ea8 <exit>
    myproc()->tf = tf;
801061b7:	e8 74 d8 ff ff       	call   80103a30 <myproc>
801061bc:	8b 55 08             	mov    0x8(%ebp),%edx
801061bf:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801061c2:	e8 f8 ed ff ff       	call   80104fbf <syscall>
    if(myproc()->killed)
801061c7:	e8 64 d8 ff ff       	call   80103a30 <myproc>
801061cc:	8b 40 24             	mov    0x24(%eax),%eax
801061cf:	85 c0                	test   %eax,%eax
801061d1:	0f 84 15 02 00 00    	je     801063ec <trap+0x25a>
      exit();
801061d7:	e8 cc dc ff ff       	call   80103ea8 <exit>
    return;
801061dc:	e9 0b 02 00 00       	jmp    801063ec <trap+0x25a>
  }

  switch(tf->trapno){
801061e1:	8b 45 08             	mov    0x8(%ebp),%eax
801061e4:	8b 40 30             	mov    0x30(%eax),%eax
801061e7:	83 e8 20             	sub    $0x20,%eax
801061ea:	83 f8 1f             	cmp    $0x1f,%eax
801061ed:	0f 87 c4 00 00 00    	ja     801062b7 <trap+0x125>
801061f3:	8b 04 85 20 a7 10 80 	mov    -0x7fef58e0(,%eax,4),%eax
801061fa:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801061fc:	e8 9c d7 ff ff       	call   8010399d <cpuid>
80106201:	85 c0                	test   %eax,%eax
80106203:	75 3d                	jne    80106242 <trap+0xb0>
      acquire(&tickslock);
80106205:	83 ec 0c             	sub    $0xc,%esp
80106208:	68 40 6a 19 80       	push   $0x80196a40
8010620d:	e8 40 e7 ff ff       	call   80104952 <acquire>
80106212:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106215:	a1 74 6a 19 80       	mov    0x80196a74,%eax
8010621a:	83 c0 01             	add    $0x1,%eax
8010621d:	a3 74 6a 19 80       	mov    %eax,0x80196a74
      wakeup(&ticks);
80106222:	83 ec 0c             	sub    $0xc,%esp
80106225:	68 74 6a 19 80       	push   $0x80196a74
8010622a:	e8 91 e1 ff ff       	call   801043c0 <wakeup>
8010622f:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106232:	83 ec 0c             	sub    $0xc,%esp
80106235:	68 40 6a 19 80       	push   $0x80196a40
8010623a:	e8 81 e7 ff ff       	call   801049c0 <release>
8010623f:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106242:	e8 d7 c8 ff ff       	call   80102b1e <lapiceoi>
    break;
80106247:	e9 20 01 00 00       	jmp    8010636c <trap+0x1da>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010624c:	e8 db 3e 00 00       	call   8010a12c <ideintr>
    lapiceoi();
80106251:	e8 c8 c8 ff ff       	call   80102b1e <lapiceoi>
    break;
80106256:	e9 11 01 00 00       	jmp    8010636c <trap+0x1da>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010625b:	e8 09 c7 ff ff       	call   80102969 <kbdintr>
    lapiceoi();
80106260:	e8 b9 c8 ff ff       	call   80102b1e <lapiceoi>
    break;
80106265:	e9 02 01 00 00       	jmp    8010636c <trap+0x1da>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010626a:	e8 51 03 00 00       	call   801065c0 <uartintr>
    lapiceoi();
8010626f:	e8 aa c8 ff ff       	call   80102b1e <lapiceoi>
    break;
80106274:	e9 f3 00 00 00       	jmp    8010636c <trap+0x1da>
  case T_IRQ0 + 0xB:
    i8254_intr();
80106279:	e8 77 2b 00 00       	call   80108df5 <i8254_intr>
    lapiceoi();
8010627e:	e8 9b c8 ff ff       	call   80102b1e <lapiceoi>
    break;
80106283:	e9 e4 00 00 00       	jmp    8010636c <trap+0x1da>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106288:	8b 45 08             	mov    0x8(%ebp),%eax
8010628b:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
8010628e:	8b 45 08             	mov    0x8(%ebp),%eax
80106291:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106295:	0f b7 d8             	movzwl %ax,%ebx
80106298:	e8 00 d7 ff ff       	call   8010399d <cpuid>
8010629d:	56                   	push   %esi
8010629e:	53                   	push   %ebx
8010629f:	50                   	push   %eax
801062a0:	68 80 a6 10 80       	push   $0x8010a680
801062a5:	e8 4a a1 ff ff       	call   801003f4 <cprintf>
801062aa:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801062ad:	e8 6c c8 ff ff       	call   80102b1e <lapiceoi>
    break;
801062b2:	e9 b5 00 00 00       	jmp    8010636c <trap+0x1da>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801062b7:	e8 74 d7 ff ff       	call   80103a30 <myproc>
801062bc:	85 c0                	test   %eax,%eax
801062be:	74 11                	je     801062d1 <trap+0x13f>
801062c0:	8b 45 08             	mov    0x8(%ebp),%eax
801062c3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801062c7:	0f b7 c0             	movzwl %ax,%eax
801062ca:	83 e0 03             	and    $0x3,%eax
801062cd:	85 c0                	test   %eax,%eax
801062cf:	75 39                	jne    8010630a <trap+0x178>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801062d1:	e8 1d fd ff ff       	call   80105ff3 <rcr2>
801062d6:	89 c3                	mov    %eax,%ebx
801062d8:	8b 45 08             	mov    0x8(%ebp),%eax
801062db:	8b 70 38             	mov    0x38(%eax),%esi
801062de:	e8 ba d6 ff ff       	call   8010399d <cpuid>
801062e3:	8b 55 08             	mov    0x8(%ebp),%edx
801062e6:	8b 52 30             	mov    0x30(%edx),%edx
801062e9:	83 ec 0c             	sub    $0xc,%esp
801062ec:	53                   	push   %ebx
801062ed:	56                   	push   %esi
801062ee:	50                   	push   %eax
801062ef:	52                   	push   %edx
801062f0:	68 a4 a6 10 80       	push   $0x8010a6a4
801062f5:	e8 fa a0 ff ff       	call   801003f4 <cprintf>
801062fa:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801062fd:	83 ec 0c             	sub    $0xc,%esp
80106300:	68 d6 a6 10 80       	push   $0x8010a6d6
80106305:	e8 9f a2 ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010630a:	e8 e4 fc ff ff       	call   80105ff3 <rcr2>
8010630f:	89 c6                	mov    %eax,%esi
80106311:	8b 45 08             	mov    0x8(%ebp),%eax
80106314:	8b 40 38             	mov    0x38(%eax),%eax
80106317:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010631a:	e8 7e d6 ff ff       	call   8010399d <cpuid>
8010631f:	89 c3                	mov    %eax,%ebx
80106321:	8b 45 08             	mov    0x8(%ebp),%eax
80106324:	8b 48 34             	mov    0x34(%eax),%ecx
80106327:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010632a:	8b 45 08             	mov    0x8(%ebp),%eax
8010632d:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106330:	e8 fb d6 ff ff       	call   80103a30 <myproc>
80106335:	8d 50 6c             	lea    0x6c(%eax),%edx
80106338:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010633b:	e8 f0 d6 ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106340:	8b 40 10             	mov    0x10(%eax),%eax
80106343:	56                   	push   %esi
80106344:	ff 75 e4             	push   -0x1c(%ebp)
80106347:	53                   	push   %ebx
80106348:	ff 75 e0             	push   -0x20(%ebp)
8010634b:	57                   	push   %edi
8010634c:	ff 75 dc             	push   -0x24(%ebp)
8010634f:	50                   	push   %eax
80106350:	68 dc a6 10 80       	push   $0x8010a6dc
80106355:	e8 9a a0 ff ff       	call   801003f4 <cprintf>
8010635a:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010635d:	e8 ce d6 ff ff       	call   80103a30 <myproc>
80106362:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106369:	eb 01                	jmp    8010636c <trap+0x1da>
    break;
8010636b:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010636c:	e8 bf d6 ff ff       	call   80103a30 <myproc>
80106371:	85 c0                	test   %eax,%eax
80106373:	74 23                	je     80106398 <trap+0x206>
80106375:	e8 b6 d6 ff ff       	call   80103a30 <myproc>
8010637a:	8b 40 24             	mov    0x24(%eax),%eax
8010637d:	85 c0                	test   %eax,%eax
8010637f:	74 17                	je     80106398 <trap+0x206>
80106381:	8b 45 08             	mov    0x8(%ebp),%eax
80106384:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106388:	0f b7 c0             	movzwl %ax,%eax
8010638b:	83 e0 03             	and    $0x3,%eax
8010638e:	83 f8 03             	cmp    $0x3,%eax
80106391:	75 05                	jne    80106398 <trap+0x206>
    exit();
80106393:	e8 10 db ff ff       	call   80103ea8 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106398:	e8 93 d6 ff ff       	call   80103a30 <myproc>
8010639d:	85 c0                	test   %eax,%eax
8010639f:	74 1d                	je     801063be <trap+0x22c>
801063a1:	e8 8a d6 ff ff       	call   80103a30 <myproc>
801063a6:	8b 40 0c             	mov    0xc(%eax),%eax
801063a9:	83 f8 04             	cmp    $0x4,%eax
801063ac:	75 10                	jne    801063be <trap+0x22c>
     tf->trapno == T_IRQ0+IRQ_TIMER)
801063ae:	8b 45 08             	mov    0x8(%ebp),%eax
801063b1:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
801063b4:	83 f8 20             	cmp    $0x20,%eax
801063b7:	75 05                	jne    801063be <trap+0x22c>
    yield();
801063b9:	e8 9b de ff ff       	call   80104259 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063be:	e8 6d d6 ff ff       	call   80103a30 <myproc>
801063c3:	85 c0                	test   %eax,%eax
801063c5:	74 26                	je     801063ed <trap+0x25b>
801063c7:	e8 64 d6 ff ff       	call   80103a30 <myproc>
801063cc:	8b 40 24             	mov    0x24(%eax),%eax
801063cf:	85 c0                	test   %eax,%eax
801063d1:	74 1a                	je     801063ed <trap+0x25b>
801063d3:	8b 45 08             	mov    0x8(%ebp),%eax
801063d6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801063da:	0f b7 c0             	movzwl %ax,%eax
801063dd:	83 e0 03             	and    $0x3,%eax
801063e0:	83 f8 03             	cmp    $0x3,%eax
801063e3:	75 08                	jne    801063ed <trap+0x25b>
    exit();
801063e5:	e8 be da ff ff       	call   80103ea8 <exit>
801063ea:	eb 01                	jmp    801063ed <trap+0x25b>
    return;
801063ec:	90                   	nop
}
801063ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063f0:	5b                   	pop    %ebx
801063f1:	5e                   	pop    %esi
801063f2:	5f                   	pop    %edi
801063f3:	5d                   	pop    %ebp
801063f4:	c3                   	ret

801063f5 <inb>:
{
801063f5:	55                   	push   %ebp
801063f6:	89 e5                	mov    %esp,%ebp
801063f8:	83 ec 14             	sub    $0x14,%esp
801063fb:	8b 45 08             	mov    0x8(%ebp),%eax
801063fe:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106402:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106406:	89 c2                	mov    %eax,%edx
80106408:	ec                   	in     (%dx),%al
80106409:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010640c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106410:	c9                   	leave
80106411:	c3                   	ret

80106412 <outb>:
{
80106412:	55                   	push   %ebp
80106413:	89 e5                	mov    %esp,%ebp
80106415:	83 ec 08             	sub    $0x8,%esp
80106418:	8b 55 08             	mov    0x8(%ebp),%edx
8010641b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010641e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106422:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106425:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106429:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010642d:	ee                   	out    %al,(%dx)
}
8010642e:	90                   	nop
8010642f:	c9                   	leave
80106430:	c3                   	ret

80106431 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106431:	55                   	push   %ebp
80106432:	89 e5                	mov    %esp,%ebp
80106434:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106437:	6a 00                	push   $0x0
80106439:	68 fa 03 00 00       	push   $0x3fa
8010643e:	e8 cf ff ff ff       	call   80106412 <outb>
80106443:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106446:	68 80 00 00 00       	push   $0x80
8010644b:	68 fb 03 00 00       	push   $0x3fb
80106450:	e8 bd ff ff ff       	call   80106412 <outb>
80106455:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106458:	6a 0c                	push   $0xc
8010645a:	68 f8 03 00 00       	push   $0x3f8
8010645f:	e8 ae ff ff ff       	call   80106412 <outb>
80106464:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106467:	6a 00                	push   $0x0
80106469:	68 f9 03 00 00       	push   $0x3f9
8010646e:	e8 9f ff ff ff       	call   80106412 <outb>
80106473:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106476:	6a 03                	push   $0x3
80106478:	68 fb 03 00 00       	push   $0x3fb
8010647d:	e8 90 ff ff ff       	call   80106412 <outb>
80106482:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106485:	6a 00                	push   $0x0
80106487:	68 fc 03 00 00       	push   $0x3fc
8010648c:	e8 81 ff ff ff       	call   80106412 <outb>
80106491:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106494:	6a 01                	push   $0x1
80106496:	68 f9 03 00 00       	push   $0x3f9
8010649b:	e8 72 ff ff ff       	call   80106412 <outb>
801064a0:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801064a3:	68 fd 03 00 00       	push   $0x3fd
801064a8:	e8 48 ff ff ff       	call   801063f5 <inb>
801064ad:	83 c4 04             	add    $0x4,%esp
801064b0:	3c ff                	cmp    $0xff,%al
801064b2:	74 61                	je     80106515 <uartinit+0xe4>
    return;
  uart = 1;
801064b4:	c7 05 78 6a 19 80 01 	movl   $0x1,0x80196a78
801064bb:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801064be:	68 fa 03 00 00       	push   $0x3fa
801064c3:	e8 2d ff ff ff       	call   801063f5 <inb>
801064c8:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801064cb:	68 f8 03 00 00       	push   $0x3f8
801064d0:	e8 20 ff ff ff       	call   801063f5 <inb>
801064d5:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
801064d8:	83 ec 08             	sub    $0x8,%esp
801064db:	6a 00                	push   $0x0
801064dd:	6a 04                	push   $0x4
801064df:	e8 52 c1 ff ff       	call   80102636 <ioapicenable>
801064e4:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801064e7:	c7 45 f4 a0 a7 10 80 	movl   $0x8010a7a0,-0xc(%ebp)
801064ee:	eb 19                	jmp    80106509 <uartinit+0xd8>
    uartputc(*p);
801064f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064f3:	0f b6 00             	movzbl (%eax),%eax
801064f6:	0f be c0             	movsbl %al,%eax
801064f9:	83 ec 0c             	sub    $0xc,%esp
801064fc:	50                   	push   %eax
801064fd:	e8 16 00 00 00       	call   80106518 <uartputc>
80106502:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106505:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010650c:	0f b6 00             	movzbl (%eax),%eax
8010650f:	84 c0                	test   %al,%al
80106511:	75 dd                	jne    801064f0 <uartinit+0xbf>
80106513:	eb 01                	jmp    80106516 <uartinit+0xe5>
    return;
80106515:	90                   	nop
}
80106516:	c9                   	leave
80106517:	c3                   	ret

80106518 <uartputc>:

void
uartputc(int c)
{
80106518:	55                   	push   %ebp
80106519:	89 e5                	mov    %esp,%ebp
8010651b:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010651e:	a1 78 6a 19 80       	mov    0x80196a78,%eax
80106523:	85 c0                	test   %eax,%eax
80106525:	74 53                	je     8010657a <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106527:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010652e:	eb 11                	jmp    80106541 <uartputc+0x29>
    microdelay(10);
80106530:	83 ec 0c             	sub    $0xc,%esp
80106533:	6a 0a                	push   $0xa
80106535:	e8 ff c5 ff ff       	call   80102b39 <microdelay>
8010653a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010653d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106541:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106545:	7f 1a                	jg     80106561 <uartputc+0x49>
80106547:	83 ec 0c             	sub    $0xc,%esp
8010654a:	68 fd 03 00 00       	push   $0x3fd
8010654f:	e8 a1 fe ff ff       	call   801063f5 <inb>
80106554:	83 c4 10             	add    $0x10,%esp
80106557:	0f b6 c0             	movzbl %al,%eax
8010655a:	83 e0 20             	and    $0x20,%eax
8010655d:	85 c0                	test   %eax,%eax
8010655f:	74 cf                	je     80106530 <uartputc+0x18>
  outb(COM1+0, c);
80106561:	8b 45 08             	mov    0x8(%ebp),%eax
80106564:	0f b6 c0             	movzbl %al,%eax
80106567:	83 ec 08             	sub    $0x8,%esp
8010656a:	50                   	push   %eax
8010656b:	68 f8 03 00 00       	push   $0x3f8
80106570:	e8 9d fe ff ff       	call   80106412 <outb>
80106575:	83 c4 10             	add    $0x10,%esp
80106578:	eb 01                	jmp    8010657b <uartputc+0x63>
    return;
8010657a:	90                   	nop
}
8010657b:	c9                   	leave
8010657c:	c3                   	ret

8010657d <uartgetc>:

static int
uartgetc(void)
{
8010657d:	55                   	push   %ebp
8010657e:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106580:	a1 78 6a 19 80       	mov    0x80196a78,%eax
80106585:	85 c0                	test   %eax,%eax
80106587:	75 07                	jne    80106590 <uartgetc+0x13>
    return -1;
80106589:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010658e:	eb 2e                	jmp    801065be <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106590:	68 fd 03 00 00       	push   $0x3fd
80106595:	e8 5b fe ff ff       	call   801063f5 <inb>
8010659a:	83 c4 04             	add    $0x4,%esp
8010659d:	0f b6 c0             	movzbl %al,%eax
801065a0:	83 e0 01             	and    $0x1,%eax
801065a3:	85 c0                	test   %eax,%eax
801065a5:	75 07                	jne    801065ae <uartgetc+0x31>
    return -1;
801065a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ac:	eb 10                	jmp    801065be <uartgetc+0x41>
  return inb(COM1+0);
801065ae:	68 f8 03 00 00       	push   $0x3f8
801065b3:	e8 3d fe ff ff       	call   801063f5 <inb>
801065b8:	83 c4 04             	add    $0x4,%esp
801065bb:	0f b6 c0             	movzbl %al,%eax
}
801065be:	c9                   	leave
801065bf:	c3                   	ret

801065c0 <uartintr>:

void
uartintr(void)
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801065c6:	83 ec 0c             	sub    $0xc,%esp
801065c9:	68 7d 65 10 80       	push   $0x8010657d
801065ce:	e8 03 a2 ff ff       	call   801007d6 <consoleintr>
801065d3:	83 c4 10             	add    $0x10,%esp
}
801065d6:	90                   	nop
801065d7:	c9                   	leave
801065d8:	c3                   	ret

801065d9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $0
801065db:	6a 00                	push   $0x0
  jmp alltraps
801065dd:	e9 c4 f9 ff ff       	jmp    80105fa6 <alltraps>

801065e2 <vector1>:
.globl vector1
vector1:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $1
801065e4:	6a 01                	push   $0x1
  jmp alltraps
801065e6:	e9 bb f9 ff ff       	jmp    80105fa6 <alltraps>

801065eb <vector2>:
.globl vector2
vector2:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $2
801065ed:	6a 02                	push   $0x2
  jmp alltraps
801065ef:	e9 b2 f9 ff ff       	jmp    80105fa6 <alltraps>

801065f4 <vector3>:
.globl vector3
vector3:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $3
801065f6:	6a 03                	push   $0x3
  jmp alltraps
801065f8:	e9 a9 f9 ff ff       	jmp    80105fa6 <alltraps>

801065fd <vector4>:
.globl vector4
vector4:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $4
801065ff:	6a 04                	push   $0x4
  jmp alltraps
80106601:	e9 a0 f9 ff ff       	jmp    80105fa6 <alltraps>

80106606 <vector5>:
.globl vector5
vector5:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $5
80106608:	6a 05                	push   $0x5
  jmp alltraps
8010660a:	e9 97 f9 ff ff       	jmp    80105fa6 <alltraps>

8010660f <vector6>:
.globl vector6
vector6:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $6
80106611:	6a 06                	push   $0x6
  jmp alltraps
80106613:	e9 8e f9 ff ff       	jmp    80105fa6 <alltraps>

80106618 <vector7>:
.globl vector7
vector7:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $7
8010661a:	6a 07                	push   $0x7
  jmp alltraps
8010661c:	e9 85 f9 ff ff       	jmp    80105fa6 <alltraps>

80106621 <vector8>:
.globl vector8
vector8:
  pushl $8
80106621:	6a 08                	push   $0x8
  jmp alltraps
80106623:	e9 7e f9 ff ff       	jmp    80105fa6 <alltraps>

80106628 <vector9>:
.globl vector9
vector9:
  pushl $0
80106628:	6a 00                	push   $0x0
  pushl $9
8010662a:	6a 09                	push   $0x9
  jmp alltraps
8010662c:	e9 75 f9 ff ff       	jmp    80105fa6 <alltraps>

80106631 <vector10>:
.globl vector10
vector10:
  pushl $10
80106631:	6a 0a                	push   $0xa
  jmp alltraps
80106633:	e9 6e f9 ff ff       	jmp    80105fa6 <alltraps>

80106638 <vector11>:
.globl vector11
vector11:
  pushl $11
80106638:	6a 0b                	push   $0xb
  jmp alltraps
8010663a:	e9 67 f9 ff ff       	jmp    80105fa6 <alltraps>

8010663f <vector12>:
.globl vector12
vector12:
  pushl $12
8010663f:	6a 0c                	push   $0xc
  jmp alltraps
80106641:	e9 60 f9 ff ff       	jmp    80105fa6 <alltraps>

80106646 <vector13>:
.globl vector13
vector13:
  pushl $13
80106646:	6a 0d                	push   $0xd
  jmp alltraps
80106648:	e9 59 f9 ff ff       	jmp    80105fa6 <alltraps>

8010664d <vector14>:
.globl vector14
vector14:
  pushl $14
8010664d:	6a 0e                	push   $0xe
  jmp alltraps
8010664f:	e9 52 f9 ff ff       	jmp    80105fa6 <alltraps>

80106654 <vector15>:
.globl vector15
vector15:
  pushl $0
80106654:	6a 00                	push   $0x0
  pushl $15
80106656:	6a 0f                	push   $0xf
  jmp alltraps
80106658:	e9 49 f9 ff ff       	jmp    80105fa6 <alltraps>

8010665d <vector16>:
.globl vector16
vector16:
  pushl $0
8010665d:	6a 00                	push   $0x0
  pushl $16
8010665f:	6a 10                	push   $0x10
  jmp alltraps
80106661:	e9 40 f9 ff ff       	jmp    80105fa6 <alltraps>

80106666 <vector17>:
.globl vector17
vector17:
  pushl $17
80106666:	6a 11                	push   $0x11
  jmp alltraps
80106668:	e9 39 f9 ff ff       	jmp    80105fa6 <alltraps>

8010666d <vector18>:
.globl vector18
vector18:
  pushl $0
8010666d:	6a 00                	push   $0x0
  pushl $18
8010666f:	6a 12                	push   $0x12
  jmp alltraps
80106671:	e9 30 f9 ff ff       	jmp    80105fa6 <alltraps>

80106676 <vector19>:
.globl vector19
vector19:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $19
80106678:	6a 13                	push   $0x13
  jmp alltraps
8010667a:	e9 27 f9 ff ff       	jmp    80105fa6 <alltraps>

8010667f <vector20>:
.globl vector20
vector20:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $20
80106681:	6a 14                	push   $0x14
  jmp alltraps
80106683:	e9 1e f9 ff ff       	jmp    80105fa6 <alltraps>

80106688 <vector21>:
.globl vector21
vector21:
  pushl $0
80106688:	6a 00                	push   $0x0
  pushl $21
8010668a:	6a 15                	push   $0x15
  jmp alltraps
8010668c:	e9 15 f9 ff ff       	jmp    80105fa6 <alltraps>

80106691 <vector22>:
.globl vector22
vector22:
  pushl $0
80106691:	6a 00                	push   $0x0
  pushl $22
80106693:	6a 16                	push   $0x16
  jmp alltraps
80106695:	e9 0c f9 ff ff       	jmp    80105fa6 <alltraps>

8010669a <vector23>:
.globl vector23
vector23:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $23
8010669c:	6a 17                	push   $0x17
  jmp alltraps
8010669e:	e9 03 f9 ff ff       	jmp    80105fa6 <alltraps>

801066a3 <vector24>:
.globl vector24
vector24:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $24
801066a5:	6a 18                	push   $0x18
  jmp alltraps
801066a7:	e9 fa f8 ff ff       	jmp    80105fa6 <alltraps>

801066ac <vector25>:
.globl vector25
vector25:
  pushl $0
801066ac:	6a 00                	push   $0x0
  pushl $25
801066ae:	6a 19                	push   $0x19
  jmp alltraps
801066b0:	e9 f1 f8 ff ff       	jmp    80105fa6 <alltraps>

801066b5 <vector26>:
.globl vector26
vector26:
  pushl $0
801066b5:	6a 00                	push   $0x0
  pushl $26
801066b7:	6a 1a                	push   $0x1a
  jmp alltraps
801066b9:	e9 e8 f8 ff ff       	jmp    80105fa6 <alltraps>

801066be <vector27>:
.globl vector27
vector27:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $27
801066c0:	6a 1b                	push   $0x1b
  jmp alltraps
801066c2:	e9 df f8 ff ff       	jmp    80105fa6 <alltraps>

801066c7 <vector28>:
.globl vector28
vector28:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $28
801066c9:	6a 1c                	push   $0x1c
  jmp alltraps
801066cb:	e9 d6 f8 ff ff       	jmp    80105fa6 <alltraps>

801066d0 <vector29>:
.globl vector29
vector29:
  pushl $0
801066d0:	6a 00                	push   $0x0
  pushl $29
801066d2:	6a 1d                	push   $0x1d
  jmp alltraps
801066d4:	e9 cd f8 ff ff       	jmp    80105fa6 <alltraps>

801066d9 <vector30>:
.globl vector30
vector30:
  pushl $0
801066d9:	6a 00                	push   $0x0
  pushl $30
801066db:	6a 1e                	push   $0x1e
  jmp alltraps
801066dd:	e9 c4 f8 ff ff       	jmp    80105fa6 <alltraps>

801066e2 <vector31>:
.globl vector31
vector31:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $31
801066e4:	6a 1f                	push   $0x1f
  jmp alltraps
801066e6:	e9 bb f8 ff ff       	jmp    80105fa6 <alltraps>

801066eb <vector32>:
.globl vector32
vector32:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $32
801066ed:	6a 20                	push   $0x20
  jmp alltraps
801066ef:	e9 b2 f8 ff ff       	jmp    80105fa6 <alltraps>

801066f4 <vector33>:
.globl vector33
vector33:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $33
801066f6:	6a 21                	push   $0x21
  jmp alltraps
801066f8:	e9 a9 f8 ff ff       	jmp    80105fa6 <alltraps>

801066fd <vector34>:
.globl vector34
vector34:
  pushl $0
801066fd:	6a 00                	push   $0x0
  pushl $34
801066ff:	6a 22                	push   $0x22
  jmp alltraps
80106701:	e9 a0 f8 ff ff       	jmp    80105fa6 <alltraps>

80106706 <vector35>:
.globl vector35
vector35:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $35
80106708:	6a 23                	push   $0x23
  jmp alltraps
8010670a:	e9 97 f8 ff ff       	jmp    80105fa6 <alltraps>

8010670f <vector36>:
.globl vector36
vector36:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $36
80106711:	6a 24                	push   $0x24
  jmp alltraps
80106713:	e9 8e f8 ff ff       	jmp    80105fa6 <alltraps>

80106718 <vector37>:
.globl vector37
vector37:
  pushl $0
80106718:	6a 00                	push   $0x0
  pushl $37
8010671a:	6a 25                	push   $0x25
  jmp alltraps
8010671c:	e9 85 f8 ff ff       	jmp    80105fa6 <alltraps>

80106721 <vector38>:
.globl vector38
vector38:
  pushl $0
80106721:	6a 00                	push   $0x0
  pushl $38
80106723:	6a 26                	push   $0x26
  jmp alltraps
80106725:	e9 7c f8 ff ff       	jmp    80105fa6 <alltraps>

8010672a <vector39>:
.globl vector39
vector39:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $39
8010672c:	6a 27                	push   $0x27
  jmp alltraps
8010672e:	e9 73 f8 ff ff       	jmp    80105fa6 <alltraps>

80106733 <vector40>:
.globl vector40
vector40:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $40
80106735:	6a 28                	push   $0x28
  jmp alltraps
80106737:	e9 6a f8 ff ff       	jmp    80105fa6 <alltraps>

8010673c <vector41>:
.globl vector41
vector41:
  pushl $0
8010673c:	6a 00                	push   $0x0
  pushl $41
8010673e:	6a 29                	push   $0x29
  jmp alltraps
80106740:	e9 61 f8 ff ff       	jmp    80105fa6 <alltraps>

80106745 <vector42>:
.globl vector42
vector42:
  pushl $0
80106745:	6a 00                	push   $0x0
  pushl $42
80106747:	6a 2a                	push   $0x2a
  jmp alltraps
80106749:	e9 58 f8 ff ff       	jmp    80105fa6 <alltraps>

8010674e <vector43>:
.globl vector43
vector43:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $43
80106750:	6a 2b                	push   $0x2b
  jmp alltraps
80106752:	e9 4f f8 ff ff       	jmp    80105fa6 <alltraps>

80106757 <vector44>:
.globl vector44
vector44:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $44
80106759:	6a 2c                	push   $0x2c
  jmp alltraps
8010675b:	e9 46 f8 ff ff       	jmp    80105fa6 <alltraps>

80106760 <vector45>:
.globl vector45
vector45:
  pushl $0
80106760:	6a 00                	push   $0x0
  pushl $45
80106762:	6a 2d                	push   $0x2d
  jmp alltraps
80106764:	e9 3d f8 ff ff       	jmp    80105fa6 <alltraps>

80106769 <vector46>:
.globl vector46
vector46:
  pushl $0
80106769:	6a 00                	push   $0x0
  pushl $46
8010676b:	6a 2e                	push   $0x2e
  jmp alltraps
8010676d:	e9 34 f8 ff ff       	jmp    80105fa6 <alltraps>

80106772 <vector47>:
.globl vector47
vector47:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $47
80106774:	6a 2f                	push   $0x2f
  jmp alltraps
80106776:	e9 2b f8 ff ff       	jmp    80105fa6 <alltraps>

8010677b <vector48>:
.globl vector48
vector48:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $48
8010677d:	6a 30                	push   $0x30
  jmp alltraps
8010677f:	e9 22 f8 ff ff       	jmp    80105fa6 <alltraps>

80106784 <vector49>:
.globl vector49
vector49:
  pushl $0
80106784:	6a 00                	push   $0x0
  pushl $49
80106786:	6a 31                	push   $0x31
  jmp alltraps
80106788:	e9 19 f8 ff ff       	jmp    80105fa6 <alltraps>

8010678d <vector50>:
.globl vector50
vector50:
  pushl $0
8010678d:	6a 00                	push   $0x0
  pushl $50
8010678f:	6a 32                	push   $0x32
  jmp alltraps
80106791:	e9 10 f8 ff ff       	jmp    80105fa6 <alltraps>

80106796 <vector51>:
.globl vector51
vector51:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $51
80106798:	6a 33                	push   $0x33
  jmp alltraps
8010679a:	e9 07 f8 ff ff       	jmp    80105fa6 <alltraps>

8010679f <vector52>:
.globl vector52
vector52:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $52
801067a1:	6a 34                	push   $0x34
  jmp alltraps
801067a3:	e9 fe f7 ff ff       	jmp    80105fa6 <alltraps>

801067a8 <vector53>:
.globl vector53
vector53:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $53
801067aa:	6a 35                	push   $0x35
  jmp alltraps
801067ac:	e9 f5 f7 ff ff       	jmp    80105fa6 <alltraps>

801067b1 <vector54>:
.globl vector54
vector54:
  pushl $0
801067b1:	6a 00                	push   $0x0
  pushl $54
801067b3:	6a 36                	push   $0x36
  jmp alltraps
801067b5:	e9 ec f7 ff ff       	jmp    80105fa6 <alltraps>

801067ba <vector55>:
.globl vector55
vector55:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $55
801067bc:	6a 37                	push   $0x37
  jmp alltraps
801067be:	e9 e3 f7 ff ff       	jmp    80105fa6 <alltraps>

801067c3 <vector56>:
.globl vector56
vector56:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $56
801067c5:	6a 38                	push   $0x38
  jmp alltraps
801067c7:	e9 da f7 ff ff       	jmp    80105fa6 <alltraps>

801067cc <vector57>:
.globl vector57
vector57:
  pushl $0
801067cc:	6a 00                	push   $0x0
  pushl $57
801067ce:	6a 39                	push   $0x39
  jmp alltraps
801067d0:	e9 d1 f7 ff ff       	jmp    80105fa6 <alltraps>

801067d5 <vector58>:
.globl vector58
vector58:
  pushl $0
801067d5:	6a 00                	push   $0x0
  pushl $58
801067d7:	6a 3a                	push   $0x3a
  jmp alltraps
801067d9:	e9 c8 f7 ff ff       	jmp    80105fa6 <alltraps>

801067de <vector59>:
.globl vector59
vector59:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $59
801067e0:	6a 3b                	push   $0x3b
  jmp alltraps
801067e2:	e9 bf f7 ff ff       	jmp    80105fa6 <alltraps>

801067e7 <vector60>:
.globl vector60
vector60:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $60
801067e9:	6a 3c                	push   $0x3c
  jmp alltraps
801067eb:	e9 b6 f7 ff ff       	jmp    80105fa6 <alltraps>

801067f0 <vector61>:
.globl vector61
vector61:
  pushl $0
801067f0:	6a 00                	push   $0x0
  pushl $61
801067f2:	6a 3d                	push   $0x3d
  jmp alltraps
801067f4:	e9 ad f7 ff ff       	jmp    80105fa6 <alltraps>

801067f9 <vector62>:
.globl vector62
vector62:
  pushl $0
801067f9:	6a 00                	push   $0x0
  pushl $62
801067fb:	6a 3e                	push   $0x3e
  jmp alltraps
801067fd:	e9 a4 f7 ff ff       	jmp    80105fa6 <alltraps>

80106802 <vector63>:
.globl vector63
vector63:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $63
80106804:	6a 3f                	push   $0x3f
  jmp alltraps
80106806:	e9 9b f7 ff ff       	jmp    80105fa6 <alltraps>

8010680b <vector64>:
.globl vector64
vector64:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $64
8010680d:	6a 40                	push   $0x40
  jmp alltraps
8010680f:	e9 92 f7 ff ff       	jmp    80105fa6 <alltraps>

80106814 <vector65>:
.globl vector65
vector65:
  pushl $0
80106814:	6a 00                	push   $0x0
  pushl $65
80106816:	6a 41                	push   $0x41
  jmp alltraps
80106818:	e9 89 f7 ff ff       	jmp    80105fa6 <alltraps>

8010681d <vector66>:
.globl vector66
vector66:
  pushl $0
8010681d:	6a 00                	push   $0x0
  pushl $66
8010681f:	6a 42                	push   $0x42
  jmp alltraps
80106821:	e9 80 f7 ff ff       	jmp    80105fa6 <alltraps>

80106826 <vector67>:
.globl vector67
vector67:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $67
80106828:	6a 43                	push   $0x43
  jmp alltraps
8010682a:	e9 77 f7 ff ff       	jmp    80105fa6 <alltraps>

8010682f <vector68>:
.globl vector68
vector68:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $68
80106831:	6a 44                	push   $0x44
  jmp alltraps
80106833:	e9 6e f7 ff ff       	jmp    80105fa6 <alltraps>

80106838 <vector69>:
.globl vector69
vector69:
  pushl $0
80106838:	6a 00                	push   $0x0
  pushl $69
8010683a:	6a 45                	push   $0x45
  jmp alltraps
8010683c:	e9 65 f7 ff ff       	jmp    80105fa6 <alltraps>

80106841 <vector70>:
.globl vector70
vector70:
  pushl $0
80106841:	6a 00                	push   $0x0
  pushl $70
80106843:	6a 46                	push   $0x46
  jmp alltraps
80106845:	e9 5c f7 ff ff       	jmp    80105fa6 <alltraps>

8010684a <vector71>:
.globl vector71
vector71:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $71
8010684c:	6a 47                	push   $0x47
  jmp alltraps
8010684e:	e9 53 f7 ff ff       	jmp    80105fa6 <alltraps>

80106853 <vector72>:
.globl vector72
vector72:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $72
80106855:	6a 48                	push   $0x48
  jmp alltraps
80106857:	e9 4a f7 ff ff       	jmp    80105fa6 <alltraps>

8010685c <vector73>:
.globl vector73
vector73:
  pushl $0
8010685c:	6a 00                	push   $0x0
  pushl $73
8010685e:	6a 49                	push   $0x49
  jmp alltraps
80106860:	e9 41 f7 ff ff       	jmp    80105fa6 <alltraps>

80106865 <vector74>:
.globl vector74
vector74:
  pushl $0
80106865:	6a 00                	push   $0x0
  pushl $74
80106867:	6a 4a                	push   $0x4a
  jmp alltraps
80106869:	e9 38 f7 ff ff       	jmp    80105fa6 <alltraps>

8010686e <vector75>:
.globl vector75
vector75:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $75
80106870:	6a 4b                	push   $0x4b
  jmp alltraps
80106872:	e9 2f f7 ff ff       	jmp    80105fa6 <alltraps>

80106877 <vector76>:
.globl vector76
vector76:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $76
80106879:	6a 4c                	push   $0x4c
  jmp alltraps
8010687b:	e9 26 f7 ff ff       	jmp    80105fa6 <alltraps>

80106880 <vector77>:
.globl vector77
vector77:
  pushl $0
80106880:	6a 00                	push   $0x0
  pushl $77
80106882:	6a 4d                	push   $0x4d
  jmp alltraps
80106884:	e9 1d f7 ff ff       	jmp    80105fa6 <alltraps>

80106889 <vector78>:
.globl vector78
vector78:
  pushl $0
80106889:	6a 00                	push   $0x0
  pushl $78
8010688b:	6a 4e                	push   $0x4e
  jmp alltraps
8010688d:	e9 14 f7 ff ff       	jmp    80105fa6 <alltraps>

80106892 <vector79>:
.globl vector79
vector79:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $79
80106894:	6a 4f                	push   $0x4f
  jmp alltraps
80106896:	e9 0b f7 ff ff       	jmp    80105fa6 <alltraps>

8010689b <vector80>:
.globl vector80
vector80:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $80
8010689d:	6a 50                	push   $0x50
  jmp alltraps
8010689f:	e9 02 f7 ff ff       	jmp    80105fa6 <alltraps>

801068a4 <vector81>:
.globl vector81
vector81:
  pushl $0
801068a4:	6a 00                	push   $0x0
  pushl $81
801068a6:	6a 51                	push   $0x51
  jmp alltraps
801068a8:	e9 f9 f6 ff ff       	jmp    80105fa6 <alltraps>

801068ad <vector82>:
.globl vector82
vector82:
  pushl $0
801068ad:	6a 00                	push   $0x0
  pushl $82
801068af:	6a 52                	push   $0x52
  jmp alltraps
801068b1:	e9 f0 f6 ff ff       	jmp    80105fa6 <alltraps>

801068b6 <vector83>:
.globl vector83
vector83:
  pushl $0
801068b6:	6a 00                	push   $0x0
  pushl $83
801068b8:	6a 53                	push   $0x53
  jmp alltraps
801068ba:	e9 e7 f6 ff ff       	jmp    80105fa6 <alltraps>

801068bf <vector84>:
.globl vector84
vector84:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $84
801068c1:	6a 54                	push   $0x54
  jmp alltraps
801068c3:	e9 de f6 ff ff       	jmp    80105fa6 <alltraps>

801068c8 <vector85>:
.globl vector85
vector85:
  pushl $0
801068c8:	6a 00                	push   $0x0
  pushl $85
801068ca:	6a 55                	push   $0x55
  jmp alltraps
801068cc:	e9 d5 f6 ff ff       	jmp    80105fa6 <alltraps>

801068d1 <vector86>:
.globl vector86
vector86:
  pushl $0
801068d1:	6a 00                	push   $0x0
  pushl $86
801068d3:	6a 56                	push   $0x56
  jmp alltraps
801068d5:	e9 cc f6 ff ff       	jmp    80105fa6 <alltraps>

801068da <vector87>:
.globl vector87
vector87:
  pushl $0
801068da:	6a 00                	push   $0x0
  pushl $87
801068dc:	6a 57                	push   $0x57
  jmp alltraps
801068de:	e9 c3 f6 ff ff       	jmp    80105fa6 <alltraps>

801068e3 <vector88>:
.globl vector88
vector88:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $88
801068e5:	6a 58                	push   $0x58
  jmp alltraps
801068e7:	e9 ba f6 ff ff       	jmp    80105fa6 <alltraps>

801068ec <vector89>:
.globl vector89
vector89:
  pushl $0
801068ec:	6a 00                	push   $0x0
  pushl $89
801068ee:	6a 59                	push   $0x59
  jmp alltraps
801068f0:	e9 b1 f6 ff ff       	jmp    80105fa6 <alltraps>

801068f5 <vector90>:
.globl vector90
vector90:
  pushl $0
801068f5:	6a 00                	push   $0x0
  pushl $90
801068f7:	6a 5a                	push   $0x5a
  jmp alltraps
801068f9:	e9 a8 f6 ff ff       	jmp    80105fa6 <alltraps>

801068fe <vector91>:
.globl vector91
vector91:
  pushl $0
801068fe:	6a 00                	push   $0x0
  pushl $91
80106900:	6a 5b                	push   $0x5b
  jmp alltraps
80106902:	e9 9f f6 ff ff       	jmp    80105fa6 <alltraps>

80106907 <vector92>:
.globl vector92
vector92:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $92
80106909:	6a 5c                	push   $0x5c
  jmp alltraps
8010690b:	e9 96 f6 ff ff       	jmp    80105fa6 <alltraps>

80106910 <vector93>:
.globl vector93
vector93:
  pushl $0
80106910:	6a 00                	push   $0x0
  pushl $93
80106912:	6a 5d                	push   $0x5d
  jmp alltraps
80106914:	e9 8d f6 ff ff       	jmp    80105fa6 <alltraps>

80106919 <vector94>:
.globl vector94
vector94:
  pushl $0
80106919:	6a 00                	push   $0x0
  pushl $94
8010691b:	6a 5e                	push   $0x5e
  jmp alltraps
8010691d:	e9 84 f6 ff ff       	jmp    80105fa6 <alltraps>

80106922 <vector95>:
.globl vector95
vector95:
  pushl $0
80106922:	6a 00                	push   $0x0
  pushl $95
80106924:	6a 5f                	push   $0x5f
  jmp alltraps
80106926:	e9 7b f6 ff ff       	jmp    80105fa6 <alltraps>

8010692b <vector96>:
.globl vector96
vector96:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $96
8010692d:	6a 60                	push   $0x60
  jmp alltraps
8010692f:	e9 72 f6 ff ff       	jmp    80105fa6 <alltraps>

80106934 <vector97>:
.globl vector97
vector97:
  pushl $0
80106934:	6a 00                	push   $0x0
  pushl $97
80106936:	6a 61                	push   $0x61
  jmp alltraps
80106938:	e9 69 f6 ff ff       	jmp    80105fa6 <alltraps>

8010693d <vector98>:
.globl vector98
vector98:
  pushl $0
8010693d:	6a 00                	push   $0x0
  pushl $98
8010693f:	6a 62                	push   $0x62
  jmp alltraps
80106941:	e9 60 f6 ff ff       	jmp    80105fa6 <alltraps>

80106946 <vector99>:
.globl vector99
vector99:
  pushl $0
80106946:	6a 00                	push   $0x0
  pushl $99
80106948:	6a 63                	push   $0x63
  jmp alltraps
8010694a:	e9 57 f6 ff ff       	jmp    80105fa6 <alltraps>

8010694f <vector100>:
.globl vector100
vector100:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $100
80106951:	6a 64                	push   $0x64
  jmp alltraps
80106953:	e9 4e f6 ff ff       	jmp    80105fa6 <alltraps>

80106958 <vector101>:
.globl vector101
vector101:
  pushl $0
80106958:	6a 00                	push   $0x0
  pushl $101
8010695a:	6a 65                	push   $0x65
  jmp alltraps
8010695c:	e9 45 f6 ff ff       	jmp    80105fa6 <alltraps>

80106961 <vector102>:
.globl vector102
vector102:
  pushl $0
80106961:	6a 00                	push   $0x0
  pushl $102
80106963:	6a 66                	push   $0x66
  jmp alltraps
80106965:	e9 3c f6 ff ff       	jmp    80105fa6 <alltraps>

8010696a <vector103>:
.globl vector103
vector103:
  pushl $0
8010696a:	6a 00                	push   $0x0
  pushl $103
8010696c:	6a 67                	push   $0x67
  jmp alltraps
8010696e:	e9 33 f6 ff ff       	jmp    80105fa6 <alltraps>

80106973 <vector104>:
.globl vector104
vector104:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $104
80106975:	6a 68                	push   $0x68
  jmp alltraps
80106977:	e9 2a f6 ff ff       	jmp    80105fa6 <alltraps>

8010697c <vector105>:
.globl vector105
vector105:
  pushl $0
8010697c:	6a 00                	push   $0x0
  pushl $105
8010697e:	6a 69                	push   $0x69
  jmp alltraps
80106980:	e9 21 f6 ff ff       	jmp    80105fa6 <alltraps>

80106985 <vector106>:
.globl vector106
vector106:
  pushl $0
80106985:	6a 00                	push   $0x0
  pushl $106
80106987:	6a 6a                	push   $0x6a
  jmp alltraps
80106989:	e9 18 f6 ff ff       	jmp    80105fa6 <alltraps>

8010698e <vector107>:
.globl vector107
vector107:
  pushl $0
8010698e:	6a 00                	push   $0x0
  pushl $107
80106990:	6a 6b                	push   $0x6b
  jmp alltraps
80106992:	e9 0f f6 ff ff       	jmp    80105fa6 <alltraps>

80106997 <vector108>:
.globl vector108
vector108:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $108
80106999:	6a 6c                	push   $0x6c
  jmp alltraps
8010699b:	e9 06 f6 ff ff       	jmp    80105fa6 <alltraps>

801069a0 <vector109>:
.globl vector109
vector109:
  pushl $0
801069a0:	6a 00                	push   $0x0
  pushl $109
801069a2:	6a 6d                	push   $0x6d
  jmp alltraps
801069a4:	e9 fd f5 ff ff       	jmp    80105fa6 <alltraps>

801069a9 <vector110>:
.globl vector110
vector110:
  pushl $0
801069a9:	6a 00                	push   $0x0
  pushl $110
801069ab:	6a 6e                	push   $0x6e
  jmp alltraps
801069ad:	e9 f4 f5 ff ff       	jmp    80105fa6 <alltraps>

801069b2 <vector111>:
.globl vector111
vector111:
  pushl $0
801069b2:	6a 00                	push   $0x0
  pushl $111
801069b4:	6a 6f                	push   $0x6f
  jmp alltraps
801069b6:	e9 eb f5 ff ff       	jmp    80105fa6 <alltraps>

801069bb <vector112>:
.globl vector112
vector112:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $112
801069bd:	6a 70                	push   $0x70
  jmp alltraps
801069bf:	e9 e2 f5 ff ff       	jmp    80105fa6 <alltraps>

801069c4 <vector113>:
.globl vector113
vector113:
  pushl $0
801069c4:	6a 00                	push   $0x0
  pushl $113
801069c6:	6a 71                	push   $0x71
  jmp alltraps
801069c8:	e9 d9 f5 ff ff       	jmp    80105fa6 <alltraps>

801069cd <vector114>:
.globl vector114
vector114:
  pushl $0
801069cd:	6a 00                	push   $0x0
  pushl $114
801069cf:	6a 72                	push   $0x72
  jmp alltraps
801069d1:	e9 d0 f5 ff ff       	jmp    80105fa6 <alltraps>

801069d6 <vector115>:
.globl vector115
vector115:
  pushl $0
801069d6:	6a 00                	push   $0x0
  pushl $115
801069d8:	6a 73                	push   $0x73
  jmp alltraps
801069da:	e9 c7 f5 ff ff       	jmp    80105fa6 <alltraps>

801069df <vector116>:
.globl vector116
vector116:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $116
801069e1:	6a 74                	push   $0x74
  jmp alltraps
801069e3:	e9 be f5 ff ff       	jmp    80105fa6 <alltraps>

801069e8 <vector117>:
.globl vector117
vector117:
  pushl $0
801069e8:	6a 00                	push   $0x0
  pushl $117
801069ea:	6a 75                	push   $0x75
  jmp alltraps
801069ec:	e9 b5 f5 ff ff       	jmp    80105fa6 <alltraps>

801069f1 <vector118>:
.globl vector118
vector118:
  pushl $0
801069f1:	6a 00                	push   $0x0
  pushl $118
801069f3:	6a 76                	push   $0x76
  jmp alltraps
801069f5:	e9 ac f5 ff ff       	jmp    80105fa6 <alltraps>

801069fa <vector119>:
.globl vector119
vector119:
  pushl $0
801069fa:	6a 00                	push   $0x0
  pushl $119
801069fc:	6a 77                	push   $0x77
  jmp alltraps
801069fe:	e9 a3 f5 ff ff       	jmp    80105fa6 <alltraps>

80106a03 <vector120>:
.globl vector120
vector120:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $120
80106a05:	6a 78                	push   $0x78
  jmp alltraps
80106a07:	e9 9a f5 ff ff       	jmp    80105fa6 <alltraps>

80106a0c <vector121>:
.globl vector121
vector121:
  pushl $0
80106a0c:	6a 00                	push   $0x0
  pushl $121
80106a0e:	6a 79                	push   $0x79
  jmp alltraps
80106a10:	e9 91 f5 ff ff       	jmp    80105fa6 <alltraps>

80106a15 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a15:	6a 00                	push   $0x0
  pushl $122
80106a17:	6a 7a                	push   $0x7a
  jmp alltraps
80106a19:	e9 88 f5 ff ff       	jmp    80105fa6 <alltraps>

80106a1e <vector123>:
.globl vector123
vector123:
  pushl $0
80106a1e:	6a 00                	push   $0x0
  pushl $123
80106a20:	6a 7b                	push   $0x7b
  jmp alltraps
80106a22:	e9 7f f5 ff ff       	jmp    80105fa6 <alltraps>

80106a27 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $124
80106a29:	6a 7c                	push   $0x7c
  jmp alltraps
80106a2b:	e9 76 f5 ff ff       	jmp    80105fa6 <alltraps>

80106a30 <vector125>:
.globl vector125
vector125:
  pushl $0
80106a30:	6a 00                	push   $0x0
  pushl $125
80106a32:	6a 7d                	push   $0x7d
  jmp alltraps
80106a34:	e9 6d f5 ff ff       	jmp    80105fa6 <alltraps>

80106a39 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a39:	6a 00                	push   $0x0
  pushl $126
80106a3b:	6a 7e                	push   $0x7e
  jmp alltraps
80106a3d:	e9 64 f5 ff ff       	jmp    80105fa6 <alltraps>

80106a42 <vector127>:
.globl vector127
vector127:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $127
80106a44:	6a 7f                	push   $0x7f
  jmp alltraps
80106a46:	e9 5b f5 ff ff       	jmp    80105fa6 <alltraps>

80106a4b <vector128>:
.globl vector128
vector128:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $128
80106a4d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a52:	e9 4f f5 ff ff       	jmp    80105fa6 <alltraps>

80106a57 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $129
80106a59:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a5e:	e9 43 f5 ff ff       	jmp    80105fa6 <alltraps>

80106a63 <vector130>:
.globl vector130
vector130:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $130
80106a65:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a6a:	e9 37 f5 ff ff       	jmp    80105fa6 <alltraps>

80106a6f <vector131>:
.globl vector131
vector131:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $131
80106a71:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a76:	e9 2b f5 ff ff       	jmp    80105fa6 <alltraps>

80106a7b <vector132>:
.globl vector132
vector132:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $132
80106a7d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a82:	e9 1f f5 ff ff       	jmp    80105fa6 <alltraps>

80106a87 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $133
80106a89:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a8e:	e9 13 f5 ff ff       	jmp    80105fa6 <alltraps>

80106a93 <vector134>:
.globl vector134
vector134:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $134
80106a95:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a9a:	e9 07 f5 ff ff       	jmp    80105fa6 <alltraps>

80106a9f <vector135>:
.globl vector135
vector135:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $135
80106aa1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106aa6:	e9 fb f4 ff ff       	jmp    80105fa6 <alltraps>

80106aab <vector136>:
.globl vector136
vector136:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $136
80106aad:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ab2:	e9 ef f4 ff ff       	jmp    80105fa6 <alltraps>

80106ab7 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $137
80106ab9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106abe:	e9 e3 f4 ff ff       	jmp    80105fa6 <alltraps>

80106ac3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $138
80106ac5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106aca:	e9 d7 f4 ff ff       	jmp    80105fa6 <alltraps>

80106acf <vector139>:
.globl vector139
vector139:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $139
80106ad1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ad6:	e9 cb f4 ff ff       	jmp    80105fa6 <alltraps>

80106adb <vector140>:
.globl vector140
vector140:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $140
80106add:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106ae2:	e9 bf f4 ff ff       	jmp    80105fa6 <alltraps>

80106ae7 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $141
80106ae9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106aee:	e9 b3 f4 ff ff       	jmp    80105fa6 <alltraps>

80106af3 <vector142>:
.globl vector142
vector142:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $142
80106af5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106afa:	e9 a7 f4 ff ff       	jmp    80105fa6 <alltraps>

80106aff <vector143>:
.globl vector143
vector143:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $143
80106b01:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b06:	e9 9b f4 ff ff       	jmp    80105fa6 <alltraps>

80106b0b <vector144>:
.globl vector144
vector144:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $144
80106b0d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b12:	e9 8f f4 ff ff       	jmp    80105fa6 <alltraps>

80106b17 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $145
80106b19:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b1e:	e9 83 f4 ff ff       	jmp    80105fa6 <alltraps>

80106b23 <vector146>:
.globl vector146
vector146:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $146
80106b25:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b2a:	e9 77 f4 ff ff       	jmp    80105fa6 <alltraps>

80106b2f <vector147>:
.globl vector147
vector147:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $147
80106b31:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b36:	e9 6b f4 ff ff       	jmp    80105fa6 <alltraps>

80106b3b <vector148>:
.globl vector148
vector148:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $148
80106b3d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b42:	e9 5f f4 ff ff       	jmp    80105fa6 <alltraps>

80106b47 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $149
80106b49:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b4e:	e9 53 f4 ff ff       	jmp    80105fa6 <alltraps>

80106b53 <vector150>:
.globl vector150
vector150:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $150
80106b55:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b5a:	e9 47 f4 ff ff       	jmp    80105fa6 <alltraps>

80106b5f <vector151>:
.globl vector151
vector151:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $151
80106b61:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b66:	e9 3b f4 ff ff       	jmp    80105fa6 <alltraps>

80106b6b <vector152>:
.globl vector152
vector152:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $152
80106b6d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b72:	e9 2f f4 ff ff       	jmp    80105fa6 <alltraps>

80106b77 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $153
80106b79:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b7e:	e9 23 f4 ff ff       	jmp    80105fa6 <alltraps>

80106b83 <vector154>:
.globl vector154
vector154:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $154
80106b85:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b8a:	e9 17 f4 ff ff       	jmp    80105fa6 <alltraps>

80106b8f <vector155>:
.globl vector155
vector155:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $155
80106b91:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b96:	e9 0b f4 ff ff       	jmp    80105fa6 <alltraps>

80106b9b <vector156>:
.globl vector156
vector156:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $156
80106b9d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106ba2:	e9 ff f3 ff ff       	jmp    80105fa6 <alltraps>

80106ba7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $157
80106ba9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bae:	e9 f3 f3 ff ff       	jmp    80105fa6 <alltraps>

80106bb3 <vector158>:
.globl vector158
vector158:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $158
80106bb5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bba:	e9 e7 f3 ff ff       	jmp    80105fa6 <alltraps>

80106bbf <vector159>:
.globl vector159
vector159:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $159
80106bc1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106bc6:	e9 db f3 ff ff       	jmp    80105fa6 <alltraps>

80106bcb <vector160>:
.globl vector160
vector160:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $160
80106bcd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106bd2:	e9 cf f3 ff ff       	jmp    80105fa6 <alltraps>

80106bd7 <vector161>:
.globl vector161
vector161:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $161
80106bd9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106bde:	e9 c3 f3 ff ff       	jmp    80105fa6 <alltraps>

80106be3 <vector162>:
.globl vector162
vector162:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $162
80106be5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106bea:	e9 b7 f3 ff ff       	jmp    80105fa6 <alltraps>

80106bef <vector163>:
.globl vector163
vector163:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $163
80106bf1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106bf6:	e9 ab f3 ff ff       	jmp    80105fa6 <alltraps>

80106bfb <vector164>:
.globl vector164
vector164:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $164
80106bfd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c02:	e9 9f f3 ff ff       	jmp    80105fa6 <alltraps>

80106c07 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $165
80106c09:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c0e:	e9 93 f3 ff ff       	jmp    80105fa6 <alltraps>

80106c13 <vector166>:
.globl vector166
vector166:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $166
80106c15:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c1a:	e9 87 f3 ff ff       	jmp    80105fa6 <alltraps>

80106c1f <vector167>:
.globl vector167
vector167:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $167
80106c21:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c26:	e9 7b f3 ff ff       	jmp    80105fa6 <alltraps>

80106c2b <vector168>:
.globl vector168
vector168:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $168
80106c2d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c32:	e9 6f f3 ff ff       	jmp    80105fa6 <alltraps>

80106c37 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $169
80106c39:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c3e:	e9 63 f3 ff ff       	jmp    80105fa6 <alltraps>

80106c43 <vector170>:
.globl vector170
vector170:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $170
80106c45:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c4a:	e9 57 f3 ff ff       	jmp    80105fa6 <alltraps>

80106c4f <vector171>:
.globl vector171
vector171:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $171
80106c51:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c56:	e9 4b f3 ff ff       	jmp    80105fa6 <alltraps>

80106c5b <vector172>:
.globl vector172
vector172:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $172
80106c5d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c62:	e9 3f f3 ff ff       	jmp    80105fa6 <alltraps>

80106c67 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $173
80106c69:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c6e:	e9 33 f3 ff ff       	jmp    80105fa6 <alltraps>

80106c73 <vector174>:
.globl vector174
vector174:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $174
80106c75:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c7a:	e9 27 f3 ff ff       	jmp    80105fa6 <alltraps>

80106c7f <vector175>:
.globl vector175
vector175:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $175
80106c81:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c86:	e9 1b f3 ff ff       	jmp    80105fa6 <alltraps>

80106c8b <vector176>:
.globl vector176
vector176:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $176
80106c8d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c92:	e9 0f f3 ff ff       	jmp    80105fa6 <alltraps>

80106c97 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $177
80106c99:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c9e:	e9 03 f3 ff ff       	jmp    80105fa6 <alltraps>

80106ca3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $178
80106ca5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106caa:	e9 f7 f2 ff ff       	jmp    80105fa6 <alltraps>

80106caf <vector179>:
.globl vector179
vector179:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $179
80106cb1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106cb6:	e9 eb f2 ff ff       	jmp    80105fa6 <alltraps>

80106cbb <vector180>:
.globl vector180
vector180:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $180
80106cbd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cc2:	e9 df f2 ff ff       	jmp    80105fa6 <alltraps>

80106cc7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $181
80106cc9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cce:	e9 d3 f2 ff ff       	jmp    80105fa6 <alltraps>

80106cd3 <vector182>:
.globl vector182
vector182:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $182
80106cd5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106cda:	e9 c7 f2 ff ff       	jmp    80105fa6 <alltraps>

80106cdf <vector183>:
.globl vector183
vector183:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $183
80106ce1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ce6:	e9 bb f2 ff ff       	jmp    80105fa6 <alltraps>

80106ceb <vector184>:
.globl vector184
vector184:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $184
80106ced:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106cf2:	e9 af f2 ff ff       	jmp    80105fa6 <alltraps>

80106cf7 <vector185>:
.globl vector185
vector185:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $185
80106cf9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106cfe:	e9 a3 f2 ff ff       	jmp    80105fa6 <alltraps>

80106d03 <vector186>:
.globl vector186
vector186:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $186
80106d05:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d0a:	e9 97 f2 ff ff       	jmp    80105fa6 <alltraps>

80106d0f <vector187>:
.globl vector187
vector187:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $187
80106d11:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d16:	e9 8b f2 ff ff       	jmp    80105fa6 <alltraps>

80106d1b <vector188>:
.globl vector188
vector188:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $188
80106d1d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d22:	e9 7f f2 ff ff       	jmp    80105fa6 <alltraps>

80106d27 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $189
80106d29:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d2e:	e9 73 f2 ff ff       	jmp    80105fa6 <alltraps>

80106d33 <vector190>:
.globl vector190
vector190:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $190
80106d35:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d3a:	e9 67 f2 ff ff       	jmp    80105fa6 <alltraps>

80106d3f <vector191>:
.globl vector191
vector191:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $191
80106d41:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d46:	e9 5b f2 ff ff       	jmp    80105fa6 <alltraps>

80106d4b <vector192>:
.globl vector192
vector192:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $192
80106d4d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d52:	e9 4f f2 ff ff       	jmp    80105fa6 <alltraps>

80106d57 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $193
80106d59:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d5e:	e9 43 f2 ff ff       	jmp    80105fa6 <alltraps>

80106d63 <vector194>:
.globl vector194
vector194:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $194
80106d65:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d6a:	e9 37 f2 ff ff       	jmp    80105fa6 <alltraps>

80106d6f <vector195>:
.globl vector195
vector195:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $195
80106d71:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d76:	e9 2b f2 ff ff       	jmp    80105fa6 <alltraps>

80106d7b <vector196>:
.globl vector196
vector196:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $196
80106d7d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d82:	e9 1f f2 ff ff       	jmp    80105fa6 <alltraps>

80106d87 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $197
80106d89:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d8e:	e9 13 f2 ff ff       	jmp    80105fa6 <alltraps>

80106d93 <vector198>:
.globl vector198
vector198:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $198
80106d95:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d9a:	e9 07 f2 ff ff       	jmp    80105fa6 <alltraps>

80106d9f <vector199>:
.globl vector199
vector199:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $199
80106da1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106da6:	e9 fb f1 ff ff       	jmp    80105fa6 <alltraps>

80106dab <vector200>:
.globl vector200
vector200:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $200
80106dad:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106db2:	e9 ef f1 ff ff       	jmp    80105fa6 <alltraps>

80106db7 <vector201>:
.globl vector201
vector201:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $201
80106db9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106dbe:	e9 e3 f1 ff ff       	jmp    80105fa6 <alltraps>

80106dc3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $202
80106dc5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106dca:	e9 d7 f1 ff ff       	jmp    80105fa6 <alltraps>

80106dcf <vector203>:
.globl vector203
vector203:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $203
80106dd1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106dd6:	e9 cb f1 ff ff       	jmp    80105fa6 <alltraps>

80106ddb <vector204>:
.globl vector204
vector204:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $204
80106ddd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106de2:	e9 bf f1 ff ff       	jmp    80105fa6 <alltraps>

80106de7 <vector205>:
.globl vector205
vector205:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $205
80106de9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106dee:	e9 b3 f1 ff ff       	jmp    80105fa6 <alltraps>

80106df3 <vector206>:
.globl vector206
vector206:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $206
80106df5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106dfa:	e9 a7 f1 ff ff       	jmp    80105fa6 <alltraps>

80106dff <vector207>:
.globl vector207
vector207:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $207
80106e01:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e06:	e9 9b f1 ff ff       	jmp    80105fa6 <alltraps>

80106e0b <vector208>:
.globl vector208
vector208:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $208
80106e0d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e12:	e9 8f f1 ff ff       	jmp    80105fa6 <alltraps>

80106e17 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $209
80106e19:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e1e:	e9 83 f1 ff ff       	jmp    80105fa6 <alltraps>

80106e23 <vector210>:
.globl vector210
vector210:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $210
80106e25:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e2a:	e9 77 f1 ff ff       	jmp    80105fa6 <alltraps>

80106e2f <vector211>:
.globl vector211
vector211:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $211
80106e31:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e36:	e9 6b f1 ff ff       	jmp    80105fa6 <alltraps>

80106e3b <vector212>:
.globl vector212
vector212:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $212
80106e3d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e42:	e9 5f f1 ff ff       	jmp    80105fa6 <alltraps>

80106e47 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $213
80106e49:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e4e:	e9 53 f1 ff ff       	jmp    80105fa6 <alltraps>

80106e53 <vector214>:
.globl vector214
vector214:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $214
80106e55:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e5a:	e9 47 f1 ff ff       	jmp    80105fa6 <alltraps>

80106e5f <vector215>:
.globl vector215
vector215:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $215
80106e61:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e66:	e9 3b f1 ff ff       	jmp    80105fa6 <alltraps>

80106e6b <vector216>:
.globl vector216
vector216:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $216
80106e6d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e72:	e9 2f f1 ff ff       	jmp    80105fa6 <alltraps>

80106e77 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $217
80106e79:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e7e:	e9 23 f1 ff ff       	jmp    80105fa6 <alltraps>

80106e83 <vector218>:
.globl vector218
vector218:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $218
80106e85:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e8a:	e9 17 f1 ff ff       	jmp    80105fa6 <alltraps>

80106e8f <vector219>:
.globl vector219
vector219:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $219
80106e91:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e96:	e9 0b f1 ff ff       	jmp    80105fa6 <alltraps>

80106e9b <vector220>:
.globl vector220
vector220:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $220
80106e9d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ea2:	e9 ff f0 ff ff       	jmp    80105fa6 <alltraps>

80106ea7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $221
80106ea9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106eae:	e9 f3 f0 ff ff       	jmp    80105fa6 <alltraps>

80106eb3 <vector222>:
.globl vector222
vector222:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $222
80106eb5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106eba:	e9 e7 f0 ff ff       	jmp    80105fa6 <alltraps>

80106ebf <vector223>:
.globl vector223
vector223:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $223
80106ec1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ec6:	e9 db f0 ff ff       	jmp    80105fa6 <alltraps>

80106ecb <vector224>:
.globl vector224
vector224:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $224
80106ecd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ed2:	e9 cf f0 ff ff       	jmp    80105fa6 <alltraps>

80106ed7 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $225
80106ed9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106ede:	e9 c3 f0 ff ff       	jmp    80105fa6 <alltraps>

80106ee3 <vector226>:
.globl vector226
vector226:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $226
80106ee5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106eea:	e9 b7 f0 ff ff       	jmp    80105fa6 <alltraps>

80106eef <vector227>:
.globl vector227
vector227:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $227
80106ef1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ef6:	e9 ab f0 ff ff       	jmp    80105fa6 <alltraps>

80106efb <vector228>:
.globl vector228
vector228:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $228
80106efd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f02:	e9 9f f0 ff ff       	jmp    80105fa6 <alltraps>

80106f07 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $229
80106f09:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f0e:	e9 93 f0 ff ff       	jmp    80105fa6 <alltraps>

80106f13 <vector230>:
.globl vector230
vector230:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $230
80106f15:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f1a:	e9 87 f0 ff ff       	jmp    80105fa6 <alltraps>

80106f1f <vector231>:
.globl vector231
vector231:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $231
80106f21:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f26:	e9 7b f0 ff ff       	jmp    80105fa6 <alltraps>

80106f2b <vector232>:
.globl vector232
vector232:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $232
80106f2d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f32:	e9 6f f0 ff ff       	jmp    80105fa6 <alltraps>

80106f37 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $233
80106f39:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f3e:	e9 63 f0 ff ff       	jmp    80105fa6 <alltraps>

80106f43 <vector234>:
.globl vector234
vector234:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $234
80106f45:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f4a:	e9 57 f0 ff ff       	jmp    80105fa6 <alltraps>

80106f4f <vector235>:
.globl vector235
vector235:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $235
80106f51:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f56:	e9 4b f0 ff ff       	jmp    80105fa6 <alltraps>

80106f5b <vector236>:
.globl vector236
vector236:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $236
80106f5d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f62:	e9 3f f0 ff ff       	jmp    80105fa6 <alltraps>

80106f67 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $237
80106f69:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f6e:	e9 33 f0 ff ff       	jmp    80105fa6 <alltraps>

80106f73 <vector238>:
.globl vector238
vector238:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $238
80106f75:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f7a:	e9 27 f0 ff ff       	jmp    80105fa6 <alltraps>

80106f7f <vector239>:
.globl vector239
vector239:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $239
80106f81:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f86:	e9 1b f0 ff ff       	jmp    80105fa6 <alltraps>

80106f8b <vector240>:
.globl vector240
vector240:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $240
80106f8d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f92:	e9 0f f0 ff ff       	jmp    80105fa6 <alltraps>

80106f97 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $241
80106f99:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f9e:	e9 03 f0 ff ff       	jmp    80105fa6 <alltraps>

80106fa3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $242
80106fa5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106faa:	e9 f7 ef ff ff       	jmp    80105fa6 <alltraps>

80106faf <vector243>:
.globl vector243
vector243:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $243
80106fb1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fb6:	e9 eb ef ff ff       	jmp    80105fa6 <alltraps>

80106fbb <vector244>:
.globl vector244
vector244:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $244
80106fbd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106fc2:	e9 df ef ff ff       	jmp    80105fa6 <alltraps>

80106fc7 <vector245>:
.globl vector245
vector245:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $245
80106fc9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106fce:	e9 d3 ef ff ff       	jmp    80105fa6 <alltraps>

80106fd3 <vector246>:
.globl vector246
vector246:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $246
80106fd5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106fda:	e9 c7 ef ff ff       	jmp    80105fa6 <alltraps>

80106fdf <vector247>:
.globl vector247
vector247:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $247
80106fe1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106fe6:	e9 bb ef ff ff       	jmp    80105fa6 <alltraps>

80106feb <vector248>:
.globl vector248
vector248:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $248
80106fed:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106ff2:	e9 af ef ff ff       	jmp    80105fa6 <alltraps>

80106ff7 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $249
80106ff9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106ffe:	e9 a3 ef ff ff       	jmp    80105fa6 <alltraps>

80107003 <vector250>:
.globl vector250
vector250:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $250
80107005:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010700a:	e9 97 ef ff ff       	jmp    80105fa6 <alltraps>

8010700f <vector251>:
.globl vector251
vector251:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $251
80107011:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107016:	e9 8b ef ff ff       	jmp    80105fa6 <alltraps>

8010701b <vector252>:
.globl vector252
vector252:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $252
8010701d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107022:	e9 7f ef ff ff       	jmp    80105fa6 <alltraps>

80107027 <vector253>:
.globl vector253
vector253:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $253
80107029:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010702e:	e9 73 ef ff ff       	jmp    80105fa6 <alltraps>

80107033 <vector254>:
.globl vector254
vector254:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $254
80107035:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010703a:	e9 67 ef ff ff       	jmp    80105fa6 <alltraps>

8010703f <vector255>:
.globl vector255
vector255:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $255
80107041:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107046:	e9 5b ef ff ff       	jmp    80105fa6 <alltraps>

8010704b <lgdt>:
{
8010704b:	55                   	push   %ebp
8010704c:	89 e5                	mov    %esp,%ebp
8010704e:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107051:	8b 45 0c             	mov    0xc(%ebp),%eax
80107054:	83 e8 01             	sub    $0x1,%eax
80107057:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010705b:	8b 45 08             	mov    0x8(%ebp),%eax
8010705e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107062:	8b 45 08             	mov    0x8(%ebp),%eax
80107065:	c1 e8 10             	shr    $0x10,%eax
80107068:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010706c:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010706f:	0f 01 10             	lgdtl  (%eax)
}
80107072:	90                   	nop
80107073:	c9                   	leave
80107074:	c3                   	ret

80107075 <ltr>:
{
80107075:	55                   	push   %ebp
80107076:	89 e5                	mov    %esp,%ebp
80107078:	83 ec 04             	sub    $0x4,%esp
8010707b:	8b 45 08             	mov    0x8(%ebp),%eax
8010707e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107082:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107086:	0f 00 d8             	ltr    %eax
}
80107089:	90                   	nop
8010708a:	c9                   	leave
8010708b:	c3                   	ret

8010708c <lcr3>:

static inline void
lcr3(uint val)
{
8010708c:	55                   	push   %ebp
8010708d:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010708f:	8b 45 08             	mov    0x8(%ebp),%eax
80107092:	0f 22 d8             	mov    %eax,%cr3
}
80107095:	90                   	nop
80107096:	5d                   	pop    %ebp
80107097:	c3                   	ret

80107098 <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107098:	55                   	push   %ebp
80107099:	89 e5                	mov    %esp,%ebp
8010709b:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
8010709e:	e8 fa c8 ff ff       	call   8010399d <cpuid>
801070a3:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801070a9:	05 80 6a 19 80       	add    $0x80196a80,%eax
801070ae:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070b4:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801070ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070bd:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801070c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070c6:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801070ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070cd:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801070d1:	83 e2 f0             	and    $0xfffffff0,%edx
801070d4:	83 ca 0a             	or     $0xa,%edx
801070d7:	88 50 7d             	mov    %dl,0x7d(%eax)
801070da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070dd:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801070e1:	83 ca 10             	or     $0x10,%edx
801070e4:	88 50 7d             	mov    %dl,0x7d(%eax)
801070e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070ea:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801070ee:	83 e2 9f             	and    $0xffffff9f,%edx
801070f1:	88 50 7d             	mov    %dl,0x7d(%eax)
801070f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070f7:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801070fb:	83 ca 80             	or     $0xffffff80,%edx
801070fe:	88 50 7d             	mov    %dl,0x7d(%eax)
80107101:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107104:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107108:	83 ca 0f             	or     $0xf,%edx
8010710b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010710e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107111:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107115:	83 e2 ef             	and    $0xffffffef,%edx
80107118:	88 50 7e             	mov    %dl,0x7e(%eax)
8010711b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010711e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107122:	83 e2 df             	and    $0xffffffdf,%edx
80107125:	88 50 7e             	mov    %dl,0x7e(%eax)
80107128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010712b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010712f:	83 ca 40             	or     $0x40,%edx
80107132:	88 50 7e             	mov    %dl,0x7e(%eax)
80107135:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107138:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010713c:	83 ca 80             	or     $0xffffff80,%edx
8010713f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107145:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107149:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010714c:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107153:	ff ff 
80107155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107158:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010715f:	00 00 
80107161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107164:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010716b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010716e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107175:	83 e2 f0             	and    $0xfffffff0,%edx
80107178:	83 ca 02             	or     $0x2,%edx
8010717b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107184:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010718b:	83 ca 10             	or     $0x10,%edx
8010718e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107197:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010719e:	83 e2 9f             	and    $0xffffff9f,%edx
801071a1:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801071a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071aa:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801071b1:	83 ca 80             	or     $0xffffff80,%edx
801071b4:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801071ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071bd:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801071c4:	83 ca 0f             	or     $0xf,%edx
801071c7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801071cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071d0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801071d7:	83 e2 ef             	and    $0xffffffef,%edx
801071da:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801071e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071e3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801071ea:	83 e2 df             	and    $0xffffffdf,%edx
801071ed:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801071f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071f6:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801071fd:	83 ca 40             	or     $0x40,%edx
80107200:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107206:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107209:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107210:	83 ca 80             	or     $0xffffff80,%edx
80107213:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010721c:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107223:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107226:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
8010722d:	ff ff 
8010722f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107232:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107239:	00 00 
8010723b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010723e:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107245:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107248:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010724f:	83 e2 f0             	and    $0xfffffff0,%edx
80107252:	83 ca 0a             	or     $0xa,%edx
80107255:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010725b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010725e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107265:	83 ca 10             	or     $0x10,%edx
80107268:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010726e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107271:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107278:	83 ca 60             	or     $0x60,%edx
8010727b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107284:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010728b:	83 ca 80             	or     $0xffffff80,%edx
8010728e:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107294:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107297:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010729e:	83 ca 0f             	or     $0xf,%edx
801072a1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072aa:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801072b1:	83 e2 ef             	and    $0xffffffef,%edx
801072b4:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072bd:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801072c4:	83 e2 df             	and    $0xffffffdf,%edx
801072c7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d0:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801072d7:	83 ca 40             	or     $0x40,%edx
801072da:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e3:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801072ea:	83 ca 80             	or     $0xffffff80,%edx
801072ed:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801072f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072f6:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107300:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107307:	ff ff 
80107309:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010730c:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107313:	00 00 
80107315:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107318:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010731f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107322:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107329:	83 e2 f0             	and    $0xfffffff0,%edx
8010732c:	83 ca 02             	or     $0x2,%edx
8010732f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107338:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010733f:	83 ca 10             	or     $0x10,%edx
80107342:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107348:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010734b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107352:	83 ca 60             	or     $0x60,%edx
80107355:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010735b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010735e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107365:	83 ca 80             	or     $0xffffff80,%edx
80107368:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010736e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107371:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107378:	83 ca 0f             	or     $0xf,%edx
8010737b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107384:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010738b:	83 e2 ef             	and    $0xffffffef,%edx
8010738e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107397:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010739e:	83 e2 df             	and    $0xffffffdf,%edx
801073a1:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073aa:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073b1:	83 ca 40             	or     $0x40,%edx
801073b4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073bd:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073c4:	83 ca 80             	or     $0xffffff80,%edx
801073c7:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d0:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801073d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073da:	83 c0 70             	add    $0x70,%eax
801073dd:	83 ec 08             	sub    $0x8,%esp
801073e0:	6a 30                	push   $0x30
801073e2:	50                   	push   %eax
801073e3:	e8 63 fc ff ff       	call   8010704b <lgdt>
801073e8:	83 c4 10             	add    $0x10,%esp
}
801073eb:	90                   	nop
801073ec:	c9                   	leave
801073ed:	c3                   	ret

801073ee <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801073ee:	55                   	push   %ebp
801073ef:	89 e5                	mov    %esp,%ebp
801073f1:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801073f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801073f7:	c1 e8 16             	shr    $0x16,%eax
801073fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107401:	8b 45 08             	mov    0x8(%ebp),%eax
80107404:	01 d0                	add    %edx,%eax
80107406:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107409:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010740c:	8b 00                	mov    (%eax),%eax
8010740e:	83 e0 01             	and    $0x1,%eax
80107411:	85 c0                	test   %eax,%eax
80107413:	74 14                	je     80107429 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107415:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107418:	8b 00                	mov    (%eax),%eax
8010741a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010741f:	05 00 00 00 80       	add    $0x80000000,%eax
80107424:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107427:	eb 42                	jmp    8010746b <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107429:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010742d:	74 0e                	je     8010743d <walkpgdir+0x4f>
8010742f:	e8 74 b3 ff ff       	call   801027a8 <kalloc>
80107434:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107437:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010743b:	75 07                	jne    80107444 <walkpgdir+0x56>
      return 0;
8010743d:	b8 00 00 00 00       	mov    $0x0,%eax
80107442:	eb 3e                	jmp    80107482 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107444:	83 ec 04             	sub    $0x4,%esp
80107447:	68 00 10 00 00       	push   $0x1000
8010744c:	6a 00                	push   $0x0
8010744e:	ff 75 f4             	push   -0xc(%ebp)
80107451:	e8 72 d7 ff ff       	call   80104bc8 <memset>
80107456:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107459:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010745c:	05 00 00 00 80       	add    $0x80000000,%eax
80107461:	83 c8 07             	or     $0x7,%eax
80107464:	89 c2                	mov    %eax,%edx
80107466:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107469:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010746b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010746e:	c1 e8 0c             	shr    $0xc,%eax
80107471:	25 ff 03 00 00       	and    $0x3ff,%eax
80107476:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010747d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107480:	01 d0                	add    %edx,%eax
}
80107482:	c9                   	leave
80107483:	c3                   	ret

80107484 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107484:	55                   	push   %ebp
80107485:	89 e5                	mov    %esp,%ebp
80107487:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010748a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010748d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107492:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107495:	8b 55 0c             	mov    0xc(%ebp),%edx
80107498:	8b 45 10             	mov    0x10(%ebp),%eax
8010749b:	01 d0                	add    %edx,%eax
8010749d:	83 e8 01             	sub    $0x1,%eax
801074a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801074a8:	83 ec 04             	sub    $0x4,%esp
801074ab:	6a 01                	push   $0x1
801074ad:	ff 75 f4             	push   -0xc(%ebp)
801074b0:	ff 75 08             	push   0x8(%ebp)
801074b3:	e8 36 ff ff ff       	call   801073ee <walkpgdir>
801074b8:	83 c4 10             	add    $0x10,%esp
801074bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
801074be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801074c2:	75 07                	jne    801074cb <mappages+0x47>
      return -1;
801074c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074c9:	eb 47                	jmp    80107512 <mappages+0x8e>
    if(*pte & PTE_P)
801074cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801074ce:	8b 00                	mov    (%eax),%eax
801074d0:	83 e0 01             	and    $0x1,%eax
801074d3:	85 c0                	test   %eax,%eax
801074d5:	74 0d                	je     801074e4 <mappages+0x60>
      panic("remap");
801074d7:	83 ec 0c             	sub    $0xc,%esp
801074da:	68 a8 a7 10 80       	push   $0x8010a7a8
801074df:	e8 c5 90 ff ff       	call   801005a9 <panic>
    *pte = pa | perm | PTE_P;
801074e4:	8b 45 18             	mov    0x18(%ebp),%eax
801074e7:	0b 45 14             	or     0x14(%ebp),%eax
801074ea:	83 c8 01             	or     $0x1,%eax
801074ed:	89 c2                	mov    %eax,%edx
801074ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801074f2:	89 10                	mov    %edx,(%eax)
    if(a == last)
801074f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801074fa:	74 10                	je     8010750c <mappages+0x88>
      break;
    a += PGSIZE;
801074fc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107503:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010750a:	eb 9c                	jmp    801074a8 <mappages+0x24>
      break;
8010750c:	90                   	nop
  }
  return 0;
8010750d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107512:	c9                   	leave
80107513:	c3                   	ret

80107514 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107514:	55                   	push   %ebp
80107515:	89 e5                	mov    %esp,%ebp
80107517:	53                   	push   %ebx
80107518:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
8010751b:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
80107522:	a1 50 6d 19 80       	mov    0x80196d50,%eax
80107527:	ba 00 00 00 fe       	mov    $0xfe000000,%edx
8010752c:	29 c2                	sub    %eax,%edx
8010752e:	89 d0                	mov    %edx,%eax
80107530:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107533:	a1 48 6d 19 80       	mov    0x80196d48,%eax
80107538:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010753b:	8b 15 48 6d 19 80    	mov    0x80196d48,%edx
80107541:	a1 50 6d 19 80       	mov    0x80196d50,%eax
80107546:	01 d0                	add    %edx,%eax
80107548:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010754b:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
80107552:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107555:	83 c0 30             	add    $0x30,%eax
80107558:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010755b:	89 10                	mov    %edx,(%eax)
8010755d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107560:	89 50 04             	mov    %edx,0x4(%eax)
80107563:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107566:	89 50 08             	mov    %edx,0x8(%eax)
80107569:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010756c:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
8010756f:	e8 34 b2 ff ff       	call   801027a8 <kalloc>
80107574:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107577:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010757b:	75 07                	jne    80107584 <setupkvm+0x70>
    return 0;
8010757d:	b8 00 00 00 00       	mov    $0x0,%eax
80107582:	eb 78                	jmp    801075fc <setupkvm+0xe8>
  }
  memset(pgdir, 0, PGSIZE);
80107584:	83 ec 04             	sub    $0x4,%esp
80107587:	68 00 10 00 00       	push   $0x1000
8010758c:	6a 00                	push   $0x0
8010758e:	ff 75 f0             	push   -0x10(%ebp)
80107591:	e8 32 d6 ff ff       	call   80104bc8 <memset>
80107596:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107599:	c7 45 f4 80 f4 10 80 	movl   $0x8010f480,-0xc(%ebp)
801075a0:	eb 4e                	jmp    801075f0 <setupkvm+0xdc>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075a5:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
801075a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ab:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b1:	8b 58 08             	mov    0x8(%eax),%ebx
801075b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b7:	8b 40 04             	mov    0x4(%eax),%eax
801075ba:	29 c3                	sub    %eax,%ebx
801075bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075bf:	8b 00                	mov    (%eax),%eax
801075c1:	83 ec 0c             	sub    $0xc,%esp
801075c4:	51                   	push   %ecx
801075c5:	52                   	push   %edx
801075c6:	53                   	push   %ebx
801075c7:	50                   	push   %eax
801075c8:	ff 75 f0             	push   -0x10(%ebp)
801075cb:	e8 b4 fe ff ff       	call   80107484 <mappages>
801075d0:	83 c4 20             	add    $0x20,%esp
801075d3:	85 c0                	test   %eax,%eax
801075d5:	79 15                	jns    801075ec <setupkvm+0xd8>
      freevm(pgdir);
801075d7:	83 ec 0c             	sub    $0xc,%esp
801075da:	ff 75 f0             	push   -0x10(%ebp)
801075dd:	e8 f5 04 00 00       	call   80107ad7 <freevm>
801075e2:	83 c4 10             	add    $0x10,%esp
      return 0;
801075e5:	b8 00 00 00 00       	mov    $0x0,%eax
801075ea:	eb 10                	jmp    801075fc <setupkvm+0xe8>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075ec:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801075f0:	81 7d f4 e0 f4 10 80 	cmpl   $0x8010f4e0,-0xc(%ebp)
801075f7:	72 a9                	jb     801075a2 <setupkvm+0x8e>
    }
  return pgdir;
801075f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801075fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801075ff:	c9                   	leave
80107600:	c3                   	ret

80107601 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107601:	55                   	push   %ebp
80107602:	89 e5                	mov    %esp,%ebp
80107604:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107607:	e8 08 ff ff ff       	call   80107514 <setupkvm>
8010760c:	a3 7c 6a 19 80       	mov    %eax,0x80196a7c
  switchkvm();
80107611:	e8 03 00 00 00       	call   80107619 <switchkvm>
}
80107616:	90                   	nop
80107617:	c9                   	leave
80107618:	c3                   	ret

80107619 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107619:	55                   	push   %ebp
8010761a:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010761c:	a1 7c 6a 19 80       	mov    0x80196a7c,%eax
80107621:	05 00 00 00 80       	add    $0x80000000,%eax
80107626:	50                   	push   %eax
80107627:	e8 60 fa ff ff       	call   8010708c <lcr3>
8010762c:	83 c4 04             	add    $0x4,%esp
}
8010762f:	90                   	nop
80107630:	c9                   	leave
80107631:	c3                   	ret

80107632 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107632:	55                   	push   %ebp
80107633:	89 e5                	mov    %esp,%ebp
80107635:	56                   	push   %esi
80107636:	53                   	push   %ebx
80107637:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
8010763a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010763e:	75 0d                	jne    8010764d <switchuvm+0x1b>
    panic("switchuvm: no process");
80107640:	83 ec 0c             	sub    $0xc,%esp
80107643:	68 ae a7 10 80       	push   $0x8010a7ae
80107648:	e8 5c 8f ff ff       	call   801005a9 <panic>
  if(p->kstack == 0)
8010764d:	8b 45 08             	mov    0x8(%ebp),%eax
80107650:	8b 40 08             	mov    0x8(%eax),%eax
80107653:	85 c0                	test   %eax,%eax
80107655:	75 0d                	jne    80107664 <switchuvm+0x32>
    panic("switchuvm: no kstack");
80107657:	83 ec 0c             	sub    $0xc,%esp
8010765a:	68 c4 a7 10 80       	push   $0x8010a7c4
8010765f:	e8 45 8f ff ff       	call   801005a9 <panic>
  if(p->pgdir == 0)
80107664:	8b 45 08             	mov    0x8(%ebp),%eax
80107667:	8b 40 04             	mov    0x4(%eax),%eax
8010766a:	85 c0                	test   %eax,%eax
8010766c:	75 0d                	jne    8010767b <switchuvm+0x49>
    panic("switchuvm: no pgdir");
8010766e:	83 ec 0c             	sub    $0xc,%esp
80107671:	68 d9 a7 10 80       	push   $0x8010a7d9
80107676:	e8 2e 8f ff ff       	call   801005a9 <panic>

  pushcli();
8010767b:	e8 3d d4 ff ff       	call   80104abd <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107680:	e8 33 c3 ff ff       	call   801039b8 <mycpu>
80107685:	89 c3                	mov    %eax,%ebx
80107687:	e8 2c c3 ff ff       	call   801039b8 <mycpu>
8010768c:	83 c0 08             	add    $0x8,%eax
8010768f:	89 c6                	mov    %eax,%esi
80107691:	e8 22 c3 ff ff       	call   801039b8 <mycpu>
80107696:	83 c0 08             	add    $0x8,%eax
80107699:	c1 e8 10             	shr    $0x10,%eax
8010769c:	88 45 f7             	mov    %al,-0x9(%ebp)
8010769f:	e8 14 c3 ff ff       	call   801039b8 <mycpu>
801076a4:	83 c0 08             	add    $0x8,%eax
801076a7:	c1 e8 18             	shr    $0x18,%eax
801076aa:	89 c2                	mov    %eax,%edx
801076ac:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801076b3:	67 00 
801076b5:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
801076bc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
801076c0:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
801076c6:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801076cd:	83 e0 f0             	and    $0xfffffff0,%eax
801076d0:	83 c8 09             	or     $0x9,%eax
801076d3:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801076d9:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801076e0:	83 c8 10             	or     $0x10,%eax
801076e3:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801076e9:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801076f0:	83 e0 9f             	and    $0xffffff9f,%eax
801076f3:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801076f9:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80107700:	83 c8 80             	or     $0xffffff80,%eax
80107703:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
80107709:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107710:	83 e0 f0             	and    $0xfffffff0,%eax
80107713:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107719:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107720:	83 e0 ef             	and    $0xffffffef,%eax
80107723:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107729:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107730:	83 e0 df             	and    $0xffffffdf,%eax
80107733:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107739:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107740:	83 c8 40             	or     $0x40,%eax
80107743:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107749:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107750:	83 e0 7f             	and    $0x7f,%eax
80107753:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
80107759:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010775f:	e8 54 c2 ff ff       	call   801039b8 <mycpu>
80107764:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010776b:	83 e2 ef             	and    $0xffffffef,%edx
8010776e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107774:	e8 3f c2 ff ff       	call   801039b8 <mycpu>
80107779:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010777f:	8b 45 08             	mov    0x8(%ebp),%eax
80107782:	8b 40 08             	mov    0x8(%eax),%eax
80107785:	89 c3                	mov    %eax,%ebx
80107787:	e8 2c c2 ff ff       	call   801039b8 <mycpu>
8010778c:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
80107792:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107795:	e8 1e c2 ff ff       	call   801039b8 <mycpu>
8010779a:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
801077a0:	83 ec 0c             	sub    $0xc,%esp
801077a3:	6a 28                	push   $0x28
801077a5:	e8 cb f8 ff ff       	call   80107075 <ltr>
801077aa:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
801077ad:	8b 45 08             	mov    0x8(%ebp),%eax
801077b0:	8b 40 04             	mov    0x4(%eax),%eax
801077b3:	05 00 00 00 80       	add    $0x80000000,%eax
801077b8:	83 ec 0c             	sub    $0xc,%esp
801077bb:	50                   	push   %eax
801077bc:	e8 cb f8 ff ff       	call   8010708c <lcr3>
801077c1:	83 c4 10             	add    $0x10,%esp
  popcli();
801077c4:	e8 41 d3 ff ff       	call   80104b0a <popcli>
}
801077c9:	90                   	nop
801077ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077cd:	5b                   	pop    %ebx
801077ce:	5e                   	pop    %esi
801077cf:	5d                   	pop    %ebp
801077d0:	c3                   	ret

801077d1 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801077d1:	55                   	push   %ebp
801077d2:	89 e5                	mov    %esp,%ebp
801077d4:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
801077d7:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801077de:	76 0d                	jbe    801077ed <inituvm+0x1c>
    panic("inituvm: more than a page");
801077e0:	83 ec 0c             	sub    $0xc,%esp
801077e3:	68 ed a7 10 80       	push   $0x8010a7ed
801077e8:	e8 bc 8d ff ff       	call   801005a9 <panic>
  mem = kalloc();
801077ed:	e8 b6 af ff ff       	call   801027a8 <kalloc>
801077f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801077f5:	83 ec 04             	sub    $0x4,%esp
801077f8:	68 00 10 00 00       	push   $0x1000
801077fd:	6a 00                	push   $0x0
801077ff:	ff 75 f4             	push   -0xc(%ebp)
80107802:	e8 c1 d3 ff ff       	call   80104bc8 <memset>
80107807:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010780a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780d:	05 00 00 00 80       	add    $0x80000000,%eax
80107812:	83 ec 0c             	sub    $0xc,%esp
80107815:	6a 06                	push   $0x6
80107817:	50                   	push   %eax
80107818:	68 00 10 00 00       	push   $0x1000
8010781d:	6a 00                	push   $0x0
8010781f:	ff 75 08             	push   0x8(%ebp)
80107822:	e8 5d fc ff ff       	call   80107484 <mappages>
80107827:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010782a:	83 ec 04             	sub    $0x4,%esp
8010782d:	ff 75 10             	push   0x10(%ebp)
80107830:	ff 75 0c             	push   0xc(%ebp)
80107833:	ff 75 f4             	push   -0xc(%ebp)
80107836:	e8 4c d4 ff ff       	call   80104c87 <memmove>
8010783b:	83 c4 10             	add    $0x10,%esp
}
8010783e:	90                   	nop
8010783f:	c9                   	leave
80107840:	c3                   	ret

80107841 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107841:	55                   	push   %ebp
80107842:	89 e5                	mov    %esp,%ebp
80107844:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107847:	8b 45 0c             	mov    0xc(%ebp),%eax
8010784a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010784f:	85 c0                	test   %eax,%eax
80107851:	74 0d                	je     80107860 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107853:	83 ec 0c             	sub    $0xc,%esp
80107856:	68 08 a8 10 80       	push   $0x8010a808
8010785b:	e8 49 8d ff ff       	call   801005a9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107860:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107867:	e9 8f 00 00 00       	jmp    801078fb <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010786c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010786f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107872:	01 d0                	add    %edx,%eax
80107874:	83 ec 04             	sub    $0x4,%esp
80107877:	6a 00                	push   $0x0
80107879:	50                   	push   %eax
8010787a:	ff 75 08             	push   0x8(%ebp)
8010787d:	e8 6c fb ff ff       	call   801073ee <walkpgdir>
80107882:	83 c4 10             	add    $0x10,%esp
80107885:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107888:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010788c:	75 0d                	jne    8010789b <loaduvm+0x5a>
      panic("loaduvm: address should exist");
8010788e:	83 ec 0c             	sub    $0xc,%esp
80107891:	68 2b a8 10 80       	push   $0x8010a82b
80107896:	e8 0e 8d ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
8010789b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010789e:	8b 00                	mov    (%eax),%eax
801078a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801078a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801078a8:	8b 45 18             	mov    0x18(%ebp),%eax
801078ab:	2b 45 f4             	sub    -0xc(%ebp),%eax
801078ae:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801078b3:	77 0b                	ja     801078c0 <loaduvm+0x7f>
      n = sz - i;
801078b5:	8b 45 18             	mov    0x18(%ebp),%eax
801078b8:	2b 45 f4             	sub    -0xc(%ebp),%eax
801078bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801078be:	eb 07                	jmp    801078c7 <loaduvm+0x86>
    else
      n = PGSIZE;
801078c0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801078c7:	8b 55 14             	mov    0x14(%ebp),%edx
801078ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078cd:	01 d0                	add    %edx,%eax
801078cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
801078d2:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801078d8:	ff 75 f0             	push   -0x10(%ebp)
801078db:	50                   	push   %eax
801078dc:	52                   	push   %edx
801078dd:	ff 75 10             	push   0x10(%ebp)
801078e0:	e8 f9 a5 ff ff       	call   80101ede <readi>
801078e5:	83 c4 10             	add    $0x10,%esp
801078e8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801078eb:	74 07                	je     801078f4 <loaduvm+0xb3>
      return -1;
801078ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078f2:	eb 18                	jmp    8010790c <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
801078f4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801078fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078fe:	3b 45 18             	cmp    0x18(%ebp),%eax
80107901:	0f 82 65 ff ff ff    	jb     8010786c <loaduvm+0x2b>
  }
  return 0;
80107907:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010790c:	c9                   	leave
8010790d:	c3                   	ret

8010790e <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010790e:	55                   	push   %ebp
8010790f:	89 e5                	mov    %esp,%ebp
80107911:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107914:	8b 45 10             	mov    0x10(%ebp),%eax
80107917:	85 c0                	test   %eax,%eax
80107919:	79 0a                	jns    80107925 <allocuvm+0x17>
    return 0;
8010791b:	b8 00 00 00 00       	mov    $0x0,%eax
80107920:	e9 ec 00 00 00       	jmp    80107a11 <allocuvm+0x103>
  if(newsz < oldsz)
80107925:	8b 45 10             	mov    0x10(%ebp),%eax
80107928:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010792b:	73 08                	jae    80107935 <allocuvm+0x27>
    return oldsz;
8010792d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107930:	e9 dc 00 00 00       	jmp    80107a11 <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
80107935:	8b 45 0c             	mov    0xc(%ebp),%eax
80107938:	05 ff 0f 00 00       	add    $0xfff,%eax
8010793d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107942:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107945:	e9 b8 00 00 00       	jmp    80107a02 <allocuvm+0xf4>
    mem = kalloc();
8010794a:	e8 59 ae ff ff       	call   801027a8 <kalloc>
8010794f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107952:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107956:	75 2e                	jne    80107986 <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
80107958:	83 ec 0c             	sub    $0xc,%esp
8010795b:	68 49 a8 10 80       	push   $0x8010a849
80107960:	e8 8f 8a ff ff       	call   801003f4 <cprintf>
80107965:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107968:	83 ec 04             	sub    $0x4,%esp
8010796b:	ff 75 0c             	push   0xc(%ebp)
8010796e:	ff 75 10             	push   0x10(%ebp)
80107971:	ff 75 08             	push   0x8(%ebp)
80107974:	e8 9a 00 00 00       	call   80107a13 <deallocuvm>
80107979:	83 c4 10             	add    $0x10,%esp
      return 0;
8010797c:	b8 00 00 00 00       	mov    $0x0,%eax
80107981:	e9 8b 00 00 00       	jmp    80107a11 <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80107986:	83 ec 04             	sub    $0x4,%esp
80107989:	68 00 10 00 00       	push   $0x1000
8010798e:	6a 00                	push   $0x0
80107990:	ff 75 f0             	push   -0x10(%ebp)
80107993:	e8 30 d2 ff ff       	call   80104bc8 <memset>
80107998:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010799b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010799e:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801079a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a7:	83 ec 0c             	sub    $0xc,%esp
801079aa:	6a 06                	push   $0x6
801079ac:	52                   	push   %edx
801079ad:	68 00 10 00 00       	push   $0x1000
801079b2:	50                   	push   %eax
801079b3:	ff 75 08             	push   0x8(%ebp)
801079b6:	e8 c9 fa ff ff       	call   80107484 <mappages>
801079bb:	83 c4 20             	add    $0x20,%esp
801079be:	85 c0                	test   %eax,%eax
801079c0:	79 39                	jns    801079fb <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
801079c2:	83 ec 0c             	sub    $0xc,%esp
801079c5:	68 61 a8 10 80       	push   $0x8010a861
801079ca:	e8 25 8a ff ff       	call   801003f4 <cprintf>
801079cf:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801079d2:	83 ec 04             	sub    $0x4,%esp
801079d5:	ff 75 0c             	push   0xc(%ebp)
801079d8:	ff 75 10             	push   0x10(%ebp)
801079db:	ff 75 08             	push   0x8(%ebp)
801079de:	e8 30 00 00 00       	call   80107a13 <deallocuvm>
801079e3:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
801079e6:	83 ec 0c             	sub    $0xc,%esp
801079e9:	ff 75 f0             	push   -0x10(%ebp)
801079ec:	e8 1d ad ff ff       	call   8010270e <kfree>
801079f1:	83 c4 10             	add    $0x10,%esp
      return 0;
801079f4:	b8 00 00 00 00       	mov    $0x0,%eax
801079f9:	eb 16                	jmp    80107a11 <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
801079fb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a05:	3b 45 10             	cmp    0x10(%ebp),%eax
80107a08:	0f 82 3c ff ff ff    	jb     8010794a <allocuvm+0x3c>
    }
  }
  return newsz;
80107a0e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107a11:	c9                   	leave
80107a12:	c3                   	ret

80107a13 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107a13:	55                   	push   %ebp
80107a14:	89 e5                	mov    %esp,%ebp
80107a16:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107a19:	8b 45 10             	mov    0x10(%ebp),%eax
80107a1c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107a1f:	72 08                	jb     80107a29 <deallocuvm+0x16>
    return oldsz;
80107a21:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a24:	e9 ac 00 00 00       	jmp    80107ad5 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107a29:	8b 45 10             	mov    0x10(%ebp),%eax
80107a2c:	05 ff 0f 00 00       	add    $0xfff,%eax
80107a31:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107a39:	e9 88 00 00 00       	jmp    80107ac6 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a41:	83 ec 04             	sub    $0x4,%esp
80107a44:	6a 00                	push   $0x0
80107a46:	50                   	push   %eax
80107a47:	ff 75 08             	push   0x8(%ebp)
80107a4a:	e8 9f f9 ff ff       	call   801073ee <walkpgdir>
80107a4f:	83 c4 10             	add    $0x10,%esp
80107a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107a55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a59:	75 16                	jne    80107a71 <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a5e:	c1 e8 16             	shr    $0x16,%eax
80107a61:	83 c0 01             	add    $0x1,%eax
80107a64:	c1 e0 16             	shl    $0x16,%eax
80107a67:	2d 00 10 00 00       	sub    $0x1000,%eax
80107a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a6f:	eb 4e                	jmp    80107abf <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80107a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a74:	8b 00                	mov    (%eax),%eax
80107a76:	83 e0 01             	and    $0x1,%eax
80107a79:	85 c0                	test   %eax,%eax
80107a7b:	74 42                	je     80107abf <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a80:	8b 00                	mov    (%eax),%eax
80107a82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a87:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107a8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107a8e:	75 0d                	jne    80107a9d <deallocuvm+0x8a>
        panic("kfree");
80107a90:	83 ec 0c             	sub    $0xc,%esp
80107a93:	68 7d a8 10 80       	push   $0x8010a87d
80107a98:	e8 0c 8b ff ff       	call   801005a9 <panic>
      char *v = P2V(pa);
80107a9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107aa0:	05 00 00 00 80       	add    $0x80000000,%eax
80107aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107aa8:	83 ec 0c             	sub    $0xc,%esp
80107aab:	ff 75 e8             	push   -0x18(%ebp)
80107aae:	e8 5b ac ff ff       	call   8010270e <kfree>
80107ab3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ab9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107abf:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac9:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107acc:	0f 82 6c ff ff ff    	jb     80107a3e <deallocuvm+0x2b>
    }
  }
  return newsz;
80107ad2:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107ad5:	c9                   	leave
80107ad6:	c3                   	ret

80107ad7 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107ad7:	55                   	push   %ebp
80107ad8:	89 e5                	mov    %esp,%ebp
80107ada:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107add:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107ae1:	75 0d                	jne    80107af0 <freevm+0x19>
    panic("freevm: no pgdir");
80107ae3:	83 ec 0c             	sub    $0xc,%esp
80107ae6:	68 83 a8 10 80       	push   $0x8010a883
80107aeb:	e8 b9 8a ff ff       	call   801005a9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107af0:	83 ec 04             	sub    $0x4,%esp
80107af3:	6a 00                	push   $0x0
80107af5:	68 00 00 00 80       	push   $0x80000000
80107afa:	ff 75 08             	push   0x8(%ebp)
80107afd:	e8 11 ff ff ff       	call   80107a13 <deallocuvm>
80107b02:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107b05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107b0c:	eb 48                	jmp    80107b56 <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80107b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b11:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b18:	8b 45 08             	mov    0x8(%ebp),%eax
80107b1b:	01 d0                	add    %edx,%eax
80107b1d:	8b 00                	mov    (%eax),%eax
80107b1f:	83 e0 01             	and    $0x1,%eax
80107b22:	85 c0                	test   %eax,%eax
80107b24:	74 2c                	je     80107b52 <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b30:	8b 45 08             	mov    0x8(%ebp),%eax
80107b33:	01 d0                	add    %edx,%eax
80107b35:	8b 00                	mov    (%eax),%eax
80107b37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b3c:	05 00 00 00 80       	add    $0x80000000,%eax
80107b41:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107b44:	83 ec 0c             	sub    $0xc,%esp
80107b47:	ff 75 f0             	push   -0x10(%ebp)
80107b4a:	e8 bf ab ff ff       	call   8010270e <kfree>
80107b4f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107b52:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107b56:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107b5d:	76 af                	jbe    80107b0e <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107b5f:	83 ec 0c             	sub    $0xc,%esp
80107b62:	ff 75 08             	push   0x8(%ebp)
80107b65:	e8 a4 ab ff ff       	call   8010270e <kfree>
80107b6a:	83 c4 10             	add    $0x10,%esp
}
80107b6d:	90                   	nop
80107b6e:	c9                   	leave
80107b6f:	c3                   	ret

80107b70 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107b70:	55                   	push   %ebp
80107b71:	89 e5                	mov    %esp,%ebp
80107b73:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b76:	83 ec 04             	sub    $0x4,%esp
80107b79:	6a 00                	push   $0x0
80107b7b:	ff 75 0c             	push   0xc(%ebp)
80107b7e:	ff 75 08             	push   0x8(%ebp)
80107b81:	e8 68 f8 ff ff       	call   801073ee <walkpgdir>
80107b86:	83 c4 10             	add    $0x10,%esp
80107b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107b8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107b90:	75 0d                	jne    80107b9f <clearpteu+0x2f>
    panic("clearpteu");
80107b92:	83 ec 0c             	sub    $0xc,%esp
80107b95:	68 94 a8 10 80       	push   $0x8010a894
80107b9a:	e8 0a 8a ff ff       	call   801005a9 <panic>
  *pte &= ~PTE_U;
80107b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba2:	8b 00                	mov    (%eax),%eax
80107ba4:	83 e0 fb             	and    $0xfffffffb,%eax
80107ba7:	89 c2                	mov    %eax,%edx
80107ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bac:	89 10                	mov    %edx,(%eax)
}
80107bae:	90                   	nop
80107baf:	c9                   	leave
80107bb0:	c3                   	ret

80107bb1 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107bb1:	55                   	push   %ebp
80107bb2:	89 e5                	mov    %esp,%ebp
80107bb4:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107bb7:	e8 58 f9 ff ff       	call   80107514 <setupkvm>
80107bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107bbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107bc3:	75 0a                	jne    80107bcf <copyuvm+0x1e>
    return 0;
80107bc5:	b8 00 00 00 00       	mov    $0x0,%eax
80107bca:	e9 eb 00 00 00       	jmp    80107cba <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
80107bcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107bd6:	e9 b7 00 00 00       	jmp    80107c92 <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bde:	83 ec 04             	sub    $0x4,%esp
80107be1:	6a 00                	push   $0x0
80107be3:	50                   	push   %eax
80107be4:	ff 75 08             	push   0x8(%ebp)
80107be7:	e8 02 f8 ff ff       	call   801073ee <walkpgdir>
80107bec:	83 c4 10             	add    $0x10,%esp
80107bef:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107bf2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107bf6:	75 0d                	jne    80107c05 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
80107bf8:	83 ec 0c             	sub    $0xc,%esp
80107bfb:	68 9e a8 10 80       	push   $0x8010a89e
80107c00:	e8 a4 89 ff ff       	call   801005a9 <panic>
    if(!(*pte & PTE_P))
80107c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c08:	8b 00                	mov    (%eax),%eax
80107c0a:	83 e0 01             	and    $0x1,%eax
80107c0d:	85 c0                	test   %eax,%eax
80107c0f:	75 0d                	jne    80107c1e <copyuvm+0x6d>
      panic("copyuvm: page not present");
80107c11:	83 ec 0c             	sub    $0xc,%esp
80107c14:	68 b8 a8 10 80       	push   $0x8010a8b8
80107c19:	e8 8b 89 ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c21:	8b 00                	mov    (%eax),%eax
80107c23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c28:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c2e:	8b 00                	mov    (%eax),%eax
80107c30:	25 ff 0f 00 00       	and    $0xfff,%eax
80107c35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107c38:	e8 6b ab ff ff       	call   801027a8 <kalloc>
80107c3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107c40:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107c44:	74 5d                	je     80107ca3 <copyuvm+0xf2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107c46:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c49:	05 00 00 00 80       	add    $0x80000000,%eax
80107c4e:	83 ec 04             	sub    $0x4,%esp
80107c51:	68 00 10 00 00       	push   $0x1000
80107c56:	50                   	push   %eax
80107c57:	ff 75 e0             	push   -0x20(%ebp)
80107c5a:	e8 28 d0 ff ff       	call   80104c87 <memmove>
80107c5f:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107c62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107c65:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c68:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c71:	83 ec 0c             	sub    $0xc,%esp
80107c74:	52                   	push   %edx
80107c75:	51                   	push   %ecx
80107c76:	68 00 10 00 00       	push   $0x1000
80107c7b:	50                   	push   %eax
80107c7c:	ff 75 f0             	push   -0x10(%ebp)
80107c7f:	e8 00 f8 ff ff       	call   80107484 <mappages>
80107c84:	83 c4 20             	add    $0x20,%esp
80107c87:	85 c0                	test   %eax,%eax
80107c89:	78 1b                	js     80107ca6 <copyuvm+0xf5>
  for(i = 0; i < sz; i += PGSIZE){
80107c8b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c95:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107c98:	0f 82 3d ff ff ff    	jb     80107bdb <copyuvm+0x2a>
      goto bad;
  }
  return d;
80107c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ca1:	eb 17                	jmp    80107cba <copyuvm+0x109>
      goto bad;
80107ca3:	90                   	nop
80107ca4:	eb 01                	jmp    80107ca7 <copyuvm+0xf6>
      goto bad;
80107ca6:	90                   	nop

bad:
  freevm(d);
80107ca7:	83 ec 0c             	sub    $0xc,%esp
80107caa:	ff 75 f0             	push   -0x10(%ebp)
80107cad:	e8 25 fe ff ff       	call   80107ad7 <freevm>
80107cb2:	83 c4 10             	add    $0x10,%esp
  return 0;
80107cb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107cba:	c9                   	leave
80107cbb:	c3                   	ret

80107cbc <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107cbc:	55                   	push   %ebp
80107cbd:	89 e5                	mov    %esp,%ebp
80107cbf:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107cc2:	83 ec 04             	sub    $0x4,%esp
80107cc5:	6a 00                	push   $0x0
80107cc7:	ff 75 0c             	push   0xc(%ebp)
80107cca:	ff 75 08             	push   0x8(%ebp)
80107ccd:	e8 1c f7 ff ff       	call   801073ee <walkpgdir>
80107cd2:	83 c4 10             	add    $0x10,%esp
80107cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdb:	8b 00                	mov    (%eax),%eax
80107cdd:	83 e0 01             	and    $0x1,%eax
80107ce0:	85 c0                	test   %eax,%eax
80107ce2:	75 07                	jne    80107ceb <uva2ka+0x2f>
    return 0;
80107ce4:	b8 00 00 00 00       	mov    $0x0,%eax
80107ce9:	eb 22                	jmp    80107d0d <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80107ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cee:	8b 00                	mov    (%eax),%eax
80107cf0:	83 e0 04             	and    $0x4,%eax
80107cf3:	85 c0                	test   %eax,%eax
80107cf5:	75 07                	jne    80107cfe <uva2ka+0x42>
    return 0;
80107cf7:	b8 00 00 00 00       	mov    $0x0,%eax
80107cfc:	eb 0f                	jmp    80107d0d <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80107cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d01:	8b 00                	mov    (%eax),%eax
80107d03:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d08:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107d0d:	c9                   	leave
80107d0e:	c3                   	ret

80107d0f <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107d0f:	55                   	push   %ebp
80107d10:	89 e5                	mov    %esp,%ebp
80107d12:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107d15:	8b 45 10             	mov    0x10(%ebp),%eax
80107d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80107d1b:	eb 7f                	jmp    80107d9c <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80107d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d25:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d2b:	83 ec 08             	sub    $0x8,%esp
80107d2e:	50                   	push   %eax
80107d2f:	ff 75 08             	push   0x8(%ebp)
80107d32:	e8 85 ff ff ff       	call   80107cbc <uva2ka>
80107d37:	83 c4 10             	add    $0x10,%esp
80107d3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80107d3d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107d41:	75 07                	jne    80107d4a <copyout+0x3b>
      return -1;
80107d43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d48:	eb 61                	jmp    80107dab <copyout+0x9c>
    n = PGSIZE - (va - va0);
80107d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d4d:	2b 45 0c             	sub    0xc(%ebp),%eax
80107d50:	05 00 10 00 00       	add    $0x1000,%eax
80107d55:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80107d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d5b:	39 45 14             	cmp    %eax,0x14(%ebp)
80107d5e:	73 06                	jae    80107d66 <copyout+0x57>
      n = len;
80107d60:	8b 45 14             	mov    0x14(%ebp),%eax
80107d63:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80107d66:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d69:	2b 45 ec             	sub    -0x14(%ebp),%eax
80107d6c:	89 c2                	mov    %eax,%edx
80107d6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d71:	01 d0                	add    %edx,%eax
80107d73:	83 ec 04             	sub    $0x4,%esp
80107d76:	ff 75 f0             	push   -0x10(%ebp)
80107d79:	ff 75 f4             	push   -0xc(%ebp)
80107d7c:	50                   	push   %eax
80107d7d:	e8 05 cf ff ff       	call   80104c87 <memmove>
80107d82:	83 c4 10             	add    $0x10,%esp
    len -= n;
80107d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d88:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80107d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d8e:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80107d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d94:	05 00 10 00 00       	add    $0x1000,%eax
80107d99:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80107d9c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107da0:	0f 85 77 ff ff ff    	jne    80107d1d <copyout+0xe>
  }
  return 0;
80107da6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107dab:	c9                   	leave
80107dac:	c3                   	ret

80107dad <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
80107dad:	55                   	push   %ebp
80107dae:	89 e5                	mov    %esp,%ebp
80107db0:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80107db3:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
80107dba:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107dbd:	8b 40 08             	mov    0x8(%eax),%eax
80107dc0:	05 00 00 00 80       	add    $0x80000000,%eax
80107dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
80107dc8:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
80107dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd2:	8b 40 24             	mov    0x24(%eax),%eax
80107dd5:	a3 00 41 19 80       	mov    %eax,0x80194100
  ncpu = 0;
80107dda:	c7 05 40 6d 19 80 00 	movl   $0x0,0x80196d40
80107de1:	00 00 00 

  while(i<madt->len){
80107de4:	e9 bd 00 00 00       	jmp    80107ea6 <mpinit_uefi+0xf9>
    uchar *entry_type = ((uchar *)madt)+i;
80107de9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107def:	01 d0                	add    %edx,%eax
80107df1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
80107df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107df7:	0f b6 00             	movzbl (%eax),%eax
80107dfa:	0f b6 c0             	movzbl %al,%eax
80107dfd:	83 f8 05             	cmp    $0x5,%eax
80107e00:	0f 87 a0 00 00 00    	ja     80107ea6 <mpinit_uefi+0xf9>
80107e06:	8b 04 85 d4 a8 10 80 	mov    -0x7fef572c(,%eax,4),%eax
80107e0d:	ff e0                	jmp    *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
80107e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e12:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
80107e15:	a1 40 6d 19 80       	mov    0x80196d40,%eax
80107e1a:	83 f8 03             	cmp    $0x3,%eax
80107e1d:	7f 28                	jg     80107e47 <mpinit_uefi+0x9a>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
80107e1f:	8b 15 40 6d 19 80    	mov    0x80196d40,%edx
80107e25:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e28:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80107e2c:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80107e32:	81 c2 80 6a 19 80    	add    $0x80196a80,%edx
80107e38:	88 02                	mov    %al,(%edx)
          ncpu++;
80107e3a:	a1 40 6d 19 80       	mov    0x80196d40,%eax
80107e3f:	83 c0 01             	add    $0x1,%eax
80107e42:	a3 40 6d 19 80       	mov    %eax,0x80196d40
        }
        i += lapic_entry->record_len;
80107e47:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e4a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107e4e:	0f b6 c0             	movzbl %al,%eax
80107e51:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107e54:	eb 50                	jmp    80107ea6 <mpinit_uefi+0xf9>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
80107e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
80107e5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e5f:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80107e63:	a2 44 6d 19 80       	mov    %al,0x80196d44
        i += ioapic->record_len;
80107e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e6b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107e6f:	0f b6 c0             	movzbl %al,%eax
80107e72:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107e75:	eb 2f                	jmp    80107ea6 <mpinit_uefi+0xf9>

      case 2:
        iso = (struct uefi_iso *)entry_type;
80107e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
80107e7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e80:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107e84:	0f b6 c0             	movzbl %al,%eax
80107e87:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107e8a:	eb 1a                	jmp    80107ea6 <mpinit_uefi+0xf9>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80107e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
80107e92:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e95:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107e99:	0f b6 c0             	movzbl %al,%eax
80107e9c:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107e9f:	eb 05                	jmp    80107ea6 <mpinit_uefi+0xf9>

      case 5:
        i = i + 0xC;
80107ea1:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
80107ea5:	90                   	nop
  while(i<madt->len){
80107ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea9:	8b 40 04             	mov    0x4(%eax),%eax
80107eac:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80107eaf:	0f 82 34 ff ff ff    	jb     80107de9 <mpinit_uefi+0x3c>
    }
  }

}
80107eb5:	90                   	nop
80107eb6:	90                   	nop
80107eb7:	c9                   	leave
80107eb8:	c3                   	ret

80107eb9 <inb>:
{
80107eb9:	55                   	push   %ebp
80107eba:	89 e5                	mov    %esp,%ebp
80107ebc:	83 ec 14             	sub    $0x14,%esp
80107ebf:	8b 45 08             	mov    0x8(%ebp),%eax
80107ec2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107ec6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107eca:	89 c2                	mov    %eax,%edx
80107ecc:	ec                   	in     (%dx),%al
80107ecd:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107ed0:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107ed4:	c9                   	leave
80107ed5:	c3                   	ret

80107ed6 <outb>:
{
80107ed6:	55                   	push   %ebp
80107ed7:	89 e5                	mov    %esp,%ebp
80107ed9:	83 ec 08             	sub    $0x8,%esp
80107edc:	8b 55 08             	mov    0x8(%ebp),%edx
80107edf:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ee2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107ee6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107ee9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107eed:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107ef1:	ee                   	out    %al,(%dx)
}
80107ef2:	90                   	nop
80107ef3:	c9                   	leave
80107ef4:	c3                   	ret

80107ef5 <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
80107ef5:	55                   	push   %ebp
80107ef6:	89 e5                	mov    %esp,%ebp
80107ef8:	83 ec 28             	sub    $0x28,%esp
80107efb:	8b 45 08             	mov    0x8(%ebp),%eax
80107efe:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
80107f01:	6a 00                	push   $0x0
80107f03:	68 fa 03 00 00       	push   $0x3fa
80107f08:	e8 c9 ff ff ff       	call   80107ed6 <outb>
80107f0d:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107f10:	68 80 00 00 00       	push   $0x80
80107f15:	68 fb 03 00 00       	push   $0x3fb
80107f1a:	e8 b7 ff ff ff       	call   80107ed6 <outb>
80107f1f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107f22:	6a 0c                	push   $0xc
80107f24:	68 f8 03 00 00       	push   $0x3f8
80107f29:	e8 a8 ff ff ff       	call   80107ed6 <outb>
80107f2e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107f31:	6a 00                	push   $0x0
80107f33:	68 f9 03 00 00       	push   $0x3f9
80107f38:	e8 99 ff ff ff       	call   80107ed6 <outb>
80107f3d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107f40:	6a 03                	push   $0x3
80107f42:	68 fb 03 00 00       	push   $0x3fb
80107f47:	e8 8a ff ff ff       	call   80107ed6 <outb>
80107f4c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107f4f:	6a 00                	push   $0x0
80107f51:	68 fc 03 00 00       	push   $0x3fc
80107f56:	e8 7b ff ff ff       	call   80107ed6 <outb>
80107f5b:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
80107f5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f65:	eb 11                	jmp    80107f78 <uart_debug+0x83>
80107f67:	83 ec 0c             	sub    $0xc,%esp
80107f6a:	6a 0a                	push   $0xa
80107f6c:	e8 c8 ab ff ff       	call   80102b39 <microdelay>
80107f71:	83 c4 10             	add    $0x10,%esp
80107f74:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107f78:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107f7c:	7f 1a                	jg     80107f98 <uart_debug+0xa3>
80107f7e:	83 ec 0c             	sub    $0xc,%esp
80107f81:	68 fd 03 00 00       	push   $0x3fd
80107f86:	e8 2e ff ff ff       	call   80107eb9 <inb>
80107f8b:	83 c4 10             	add    $0x10,%esp
80107f8e:	0f b6 c0             	movzbl %al,%eax
80107f91:	83 e0 20             	and    $0x20,%eax
80107f94:	85 c0                	test   %eax,%eax
80107f96:	74 cf                	je     80107f67 <uart_debug+0x72>
  outb(COM1+0, p);
80107f98:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80107f9c:	0f b6 c0             	movzbl %al,%eax
80107f9f:	83 ec 08             	sub    $0x8,%esp
80107fa2:	50                   	push   %eax
80107fa3:	68 f8 03 00 00       	push   $0x3f8
80107fa8:	e8 29 ff ff ff       	call   80107ed6 <outb>
80107fad:	83 c4 10             	add    $0x10,%esp
}
80107fb0:	90                   	nop
80107fb1:	c9                   	leave
80107fb2:	c3                   	ret

80107fb3 <uart_debugs>:

void uart_debugs(char *p){
80107fb3:	55                   	push   %ebp
80107fb4:	89 e5                	mov    %esp,%ebp
80107fb6:	83 ec 08             	sub    $0x8,%esp
  while(*p){
80107fb9:	eb 1b                	jmp    80107fd6 <uart_debugs+0x23>
    uart_debug(*p++);
80107fbb:	8b 45 08             	mov    0x8(%ebp),%eax
80107fbe:	8d 50 01             	lea    0x1(%eax),%edx
80107fc1:	89 55 08             	mov    %edx,0x8(%ebp)
80107fc4:	0f b6 00             	movzbl (%eax),%eax
80107fc7:	0f be c0             	movsbl %al,%eax
80107fca:	83 ec 0c             	sub    $0xc,%esp
80107fcd:	50                   	push   %eax
80107fce:	e8 22 ff ff ff       	call   80107ef5 <uart_debug>
80107fd3:	83 c4 10             	add    $0x10,%esp
  while(*p){
80107fd6:	8b 45 08             	mov    0x8(%ebp),%eax
80107fd9:	0f b6 00             	movzbl (%eax),%eax
80107fdc:	84 c0                	test   %al,%al
80107fde:	75 db                	jne    80107fbb <uart_debugs+0x8>
  }
}
80107fe0:	90                   	nop
80107fe1:	90                   	nop
80107fe2:	c9                   	leave
80107fe3:	c3                   	ret

80107fe4 <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
80107fe4:	55                   	push   %ebp
80107fe5:	89 e5                	mov    %esp,%ebp
80107fe7:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80107fea:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
80107ff1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107ff4:	8b 50 14             	mov    0x14(%eax),%edx
80107ff7:	8b 40 10             	mov    0x10(%eax),%eax
80107ffa:	a3 48 6d 19 80       	mov    %eax,0x80196d48
  gpu.vram_size = boot_param->graphic_config.frame_size;
80107fff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108002:	8b 50 1c             	mov    0x1c(%eax),%edx
80108005:	8b 40 18             	mov    0x18(%eax),%eax
80108008:	a3 50 6d 19 80       	mov    %eax,0x80196d50
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
8010800d:	a1 50 6d 19 80       	mov    0x80196d50,%eax
80108012:	ba 00 00 00 fe       	mov    $0xfe000000,%edx
80108017:	29 c2                	sub    %eax,%edx
80108019:	89 15 4c 6d 19 80    	mov    %edx,0x80196d4c
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
8010801f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108022:	8b 50 24             	mov    0x24(%eax),%edx
80108025:	8b 40 20             	mov    0x20(%eax),%eax
80108028:	a3 54 6d 19 80       	mov    %eax,0x80196d54
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
8010802d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108030:	8b 50 2c             	mov    0x2c(%eax),%edx
80108033:	8b 40 28             	mov    0x28(%eax),%eax
80108036:	a3 58 6d 19 80       	mov    %eax,0x80196d58
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
8010803b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010803e:	8b 50 34             	mov    0x34(%eax),%edx
80108041:	8b 40 30             	mov    0x30(%eax),%eax
80108044:	a3 5c 6d 19 80       	mov    %eax,0x80196d5c
}
80108049:	90                   	nop
8010804a:	c9                   	leave
8010804b:	c3                   	ret

8010804c <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
8010804c:	55                   	push   %ebp
8010804d:	89 e5                	mov    %esp,%ebp
8010804f:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
80108052:	8b 15 5c 6d 19 80    	mov    0x80196d5c,%edx
80108058:	8b 45 0c             	mov    0xc(%ebp),%eax
8010805b:	0f af d0             	imul   %eax,%edx
8010805e:	8b 45 08             	mov    0x8(%ebp),%eax
80108061:	01 d0                	add    %edx,%eax
80108063:	c1 e0 02             	shl    $0x2,%eax
80108066:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
80108069:	8b 15 4c 6d 19 80    	mov    0x80196d4c,%edx
8010806f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108072:	01 d0                	add    %edx,%eax
80108074:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
80108077:	8b 45 10             	mov    0x10(%ebp),%eax
8010807a:	0f b6 10             	movzbl (%eax),%edx
8010807d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108080:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
80108082:	8b 45 10             	mov    0x10(%ebp),%eax
80108085:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80108089:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010808c:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
8010808f:	8b 45 10             	mov    0x10(%ebp),%eax
80108092:	0f b6 50 02          	movzbl 0x2(%eax),%edx
80108096:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108099:	88 50 02             	mov    %dl,0x2(%eax)
}
8010809c:	90                   	nop
8010809d:	c9                   	leave
8010809e:	c3                   	ret

8010809f <graphic_scroll_up>:

void graphic_scroll_up(int height){
8010809f:	55                   	push   %ebp
801080a0:	89 e5                	mov    %esp,%ebp
801080a2:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
801080a5:	8b 15 5c 6d 19 80    	mov    0x80196d5c,%edx
801080ab:	8b 45 08             	mov    0x8(%ebp),%eax
801080ae:	0f af c2             	imul   %edx,%eax
801080b1:	c1 e0 02             	shl    $0x2,%eax
801080b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
801080b7:	8b 15 50 6d 19 80    	mov    0x80196d50,%edx
801080bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c0:	29 c2                	sub    %eax,%edx
801080c2:	8b 0d 4c 6d 19 80    	mov    0x80196d4c,%ecx
801080c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080cb:	01 c8                	add    %ecx,%eax
801080cd:	89 c1                	mov    %eax,%ecx
801080cf:	a1 4c 6d 19 80       	mov    0x80196d4c,%eax
801080d4:	83 ec 04             	sub    $0x4,%esp
801080d7:	52                   	push   %edx
801080d8:	51                   	push   %ecx
801080d9:	50                   	push   %eax
801080da:	e8 a8 cb ff ff       	call   80104c87 <memmove>
801080df:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
801080e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e5:	8b 0d 4c 6d 19 80    	mov    0x80196d4c,%ecx
801080eb:	8b 15 50 6d 19 80    	mov    0x80196d50,%edx
801080f1:	01 d1                	add    %edx,%ecx
801080f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801080f6:	29 d1                	sub    %edx,%ecx
801080f8:	89 ca                	mov    %ecx,%edx
801080fa:	83 ec 04             	sub    $0x4,%esp
801080fd:	50                   	push   %eax
801080fe:	6a 00                	push   $0x0
80108100:	52                   	push   %edx
80108101:	e8 c2 ca ff ff       	call   80104bc8 <memset>
80108106:	83 c4 10             	add    $0x10,%esp
}
80108109:	90                   	nop
8010810a:	c9                   	leave
8010810b:	c3                   	ret

8010810c <font_render>:
#include "font.h"


struct graphic_pixel black_pixel = {0x0,0x0,0x0,0x0};
struct graphic_pixel white_pixel = {0xFF,0xFF,0xFF,0x0};
void font_render(int x,int y,int index){
8010810c:	55                   	push   %ebp
8010810d:	89 e5                	mov    %esp,%ebp
8010810f:	53                   	push   %ebx
80108110:	83 ec 14             	sub    $0x14,%esp
  int bin;
  for(int i=0;i<30;i++){
80108113:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010811a:	e9 b1 00 00 00       	jmp    801081d0 <font_render+0xc4>
    for(int j=14;j>-1;j--){
8010811f:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
80108126:	e9 97 00 00 00       	jmp    801081c2 <font_render+0xb6>
      bin = (font_bin[index-0x20][i])&(1 << j);
8010812b:	8b 45 10             	mov    0x10(%ebp),%eax
8010812e:	83 e8 20             	sub    $0x20,%eax
80108131:	6b d0 1e             	imul   $0x1e,%eax,%edx
80108134:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108137:	01 d0                	add    %edx,%eax
80108139:	0f b7 84 00 00 a9 10 	movzwl -0x7fef5700(%eax,%eax,1),%eax
80108140:	80 
80108141:	0f b7 d0             	movzwl %ax,%edx
80108144:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108147:	bb 01 00 00 00       	mov    $0x1,%ebx
8010814c:	89 c1                	mov    %eax,%ecx
8010814e:	d3 e3                	shl    %cl,%ebx
80108150:	89 d8                	mov    %ebx,%eax
80108152:	21 d0                	and    %edx,%eax
80108154:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(bin == (1 << j)){
80108157:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010815a:	ba 01 00 00 00       	mov    $0x1,%edx
8010815f:	89 c1                	mov    %eax,%ecx
80108161:	d3 e2                	shl    %cl,%edx
80108163:	89 d0                	mov    %edx,%eax
80108165:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80108168:	75 2b                	jne    80108195 <font_render+0x89>
        graphic_draw_pixel(x+(14-j),y+i,&white_pixel);
8010816a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010816d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108170:	01 c2                	add    %eax,%edx
80108172:	b8 0e 00 00 00       	mov    $0xe,%eax
80108177:	2b 45 f0             	sub    -0x10(%ebp),%eax
8010817a:	89 c1                	mov    %eax,%ecx
8010817c:	8b 45 08             	mov    0x8(%ebp),%eax
8010817f:	01 c8                	add    %ecx,%eax
80108181:	83 ec 04             	sub    $0x4,%esp
80108184:	68 e0 f4 10 80       	push   $0x8010f4e0
80108189:	52                   	push   %edx
8010818a:	50                   	push   %eax
8010818b:	e8 bc fe ff ff       	call   8010804c <graphic_draw_pixel>
80108190:	83 c4 10             	add    $0x10,%esp
80108193:	eb 29                	jmp    801081be <font_render+0xb2>
      } else {
        graphic_draw_pixel(x+(14-j),y+i,&black_pixel);
80108195:	8b 55 0c             	mov    0xc(%ebp),%edx
80108198:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819b:	01 c2                	add    %eax,%edx
8010819d:	b8 0e 00 00 00       	mov    $0xe,%eax
801081a2:	2b 45 f0             	sub    -0x10(%ebp),%eax
801081a5:	89 c1                	mov    %eax,%ecx
801081a7:	8b 45 08             	mov    0x8(%ebp),%eax
801081aa:	01 c8                	add    %ecx,%eax
801081ac:	83 ec 04             	sub    $0x4,%esp
801081af:	68 60 6d 19 80       	push   $0x80196d60
801081b4:	52                   	push   %edx
801081b5:	50                   	push   %eax
801081b6:	e8 91 fe ff ff       	call   8010804c <graphic_draw_pixel>
801081bb:	83 c4 10             	add    $0x10,%esp
    for(int j=14;j>-1;j--){
801081be:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
801081c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081c6:	0f 89 5f ff ff ff    	jns    8010812b <font_render+0x1f>
  for(int i=0;i<30;i++){
801081cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801081d0:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
801081d4:	0f 8e 45 ff ff ff    	jle    8010811f <font_render+0x13>
      }
    }
  }
}
801081da:	90                   	nop
801081db:	90                   	nop
801081dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801081df:	c9                   	leave
801081e0:	c3                   	ret

801081e1 <font_render_string>:

void font_render_string(char *string,int row){
801081e1:	55                   	push   %ebp
801081e2:	89 e5                	mov    %esp,%ebp
801081e4:	53                   	push   %ebx
801081e5:	83 ec 14             	sub    $0x14,%esp
  int i = 0;
801081e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while(string[i] && i < 52){
801081ef:	eb 33                	jmp    80108224 <font_render_string+0x43>
    font_render(i*15+2,row*30,string[i]);
801081f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801081f4:	8b 45 08             	mov    0x8(%ebp),%eax
801081f7:	01 d0                	add    %edx,%eax
801081f9:	0f b6 00             	movzbl (%eax),%eax
801081fc:	0f be d8             	movsbl %al,%ebx
801081ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80108202:	6b c8 1e             	imul   $0x1e,%eax,%ecx
80108205:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108208:	89 d0                	mov    %edx,%eax
8010820a:	c1 e0 04             	shl    $0x4,%eax
8010820d:	29 d0                	sub    %edx,%eax
8010820f:	83 c0 02             	add    $0x2,%eax
80108212:	83 ec 04             	sub    $0x4,%esp
80108215:	53                   	push   %ebx
80108216:	51                   	push   %ecx
80108217:	50                   	push   %eax
80108218:	e8 ef fe ff ff       	call   8010810c <font_render>
8010821d:	83 c4 10             	add    $0x10,%esp
    i++;
80108220:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(string[i] && i < 52){
80108224:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108227:	8b 45 08             	mov    0x8(%ebp),%eax
8010822a:	01 d0                	add    %edx,%eax
8010822c:	0f b6 00             	movzbl (%eax),%eax
8010822f:	84 c0                	test   %al,%al
80108231:	74 06                	je     80108239 <font_render_string+0x58>
80108233:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
80108237:	7e b8                	jle    801081f1 <font_render_string+0x10>
  }
}
80108239:	90                   	nop
8010823a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010823d:	c9                   	leave
8010823e:	c3                   	ret

8010823f <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
8010823f:	55                   	push   %ebp
80108240:	89 e5                	mov    %esp,%ebp
80108242:	53                   	push   %ebx
80108243:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
80108246:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010824d:	eb 6b                	jmp    801082ba <pci_init+0x7b>
    for(int j=0;j<32;j++){
8010824f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108256:	eb 58                	jmp    801082b0 <pci_init+0x71>
      for(int k=0;k<8;k++){
80108258:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010825f:	eb 45                	jmp    801082a6 <pci_init+0x67>
      pci_access_config(i,j,k,0,&data);
80108261:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80108264:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108267:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826a:	83 ec 0c             	sub    $0xc,%esp
8010826d:	8d 5d e8             	lea    -0x18(%ebp),%ebx
80108270:	53                   	push   %ebx
80108271:	6a 00                	push   $0x0
80108273:	51                   	push   %ecx
80108274:	52                   	push   %edx
80108275:	50                   	push   %eax
80108276:	e8 b0 00 00 00       	call   8010832b <pci_access_config>
8010827b:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
8010827e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108281:	0f b7 c0             	movzwl %ax,%eax
80108284:	3d ff ff 00 00       	cmp    $0xffff,%eax
80108289:	74 17                	je     801082a2 <pci_init+0x63>
        pci_init_device(i,j,k);
8010828b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010828e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108291:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108294:	83 ec 04             	sub    $0x4,%esp
80108297:	51                   	push   %ecx
80108298:	52                   	push   %edx
80108299:	50                   	push   %eax
8010829a:	e8 37 01 00 00       	call   801083d6 <pci_init_device>
8010829f:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
801082a2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801082a6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
801082aa:	7e b5                	jle    80108261 <pci_init+0x22>
    for(int j=0;j<32;j++){
801082ac:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801082b0:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
801082b4:	7e a2                	jle    80108258 <pci_init+0x19>
  for(int i=0;i<256;i++){
801082b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801082ba:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801082c1:	7e 8c                	jle    8010824f <pci_init+0x10>
      }
      }
    }
  }
}
801082c3:	90                   	nop
801082c4:	90                   	nop
801082c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801082c8:	c9                   	leave
801082c9:	c3                   	ret

801082ca <pci_write_config>:

void pci_write_config(uint config){
801082ca:	55                   	push   %ebp
801082cb:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
801082cd:	8b 45 08             	mov    0x8(%ebp),%eax
801082d0:	ba f8 0c 00 00       	mov    $0xcf8,%edx
801082d5:	89 c0                	mov    %eax,%eax
801082d7:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
801082d8:	90                   	nop
801082d9:	5d                   	pop    %ebp
801082da:	c3                   	ret

801082db <pci_write_data>:

void pci_write_data(uint config){
801082db:	55                   	push   %ebp
801082dc:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
801082de:	8b 45 08             	mov    0x8(%ebp),%eax
801082e1:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801082e6:	89 c0                	mov    %eax,%eax
801082e8:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
801082e9:	90                   	nop
801082ea:	5d                   	pop    %ebp
801082eb:	c3                   	ret

801082ec <pci_read_config>:
uint pci_read_config(){
801082ec:	55                   	push   %ebp
801082ed:	89 e5                	mov    %esp,%ebp
801082ef:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
801082f2:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801082f7:	ed                   	in     (%dx),%eax
801082f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
801082fb:	83 ec 0c             	sub    $0xc,%esp
801082fe:	68 c8 00 00 00       	push   $0xc8
80108303:	e8 31 a8 ff ff       	call   80102b39 <microdelay>
80108308:	83 c4 10             	add    $0x10,%esp
  return data;
8010830b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010830e:	c9                   	leave
8010830f:	c3                   	ret

80108310 <pci_test>:


void pci_test(){
80108310:	55                   	push   %ebp
80108311:	89 e5                	mov    %esp,%ebp
80108313:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
80108316:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
8010831d:	ff 75 fc             	push   -0x4(%ebp)
80108320:	e8 a5 ff ff ff       	call   801082ca <pci_write_config>
80108325:	83 c4 04             	add    $0x4,%esp
}
80108328:	90                   	nop
80108329:	c9                   	leave
8010832a:	c3                   	ret

8010832b <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
8010832b:	55                   	push   %ebp
8010832c:	89 e5                	mov    %esp,%ebp
8010832e:	83 ec 18             	sub    $0x18,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108331:	8b 45 08             	mov    0x8(%ebp),%eax
80108334:	c1 e0 10             	shl    $0x10,%eax
80108337:	25 00 00 ff 00       	and    $0xff0000,%eax
8010833c:	89 c2                	mov    %eax,%edx
8010833e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108341:	c1 e0 0b             	shl    $0xb,%eax
80108344:	0f b7 c0             	movzwl %ax,%eax
80108347:	09 c2                	or     %eax,%edx
80108349:	8b 45 10             	mov    0x10(%ebp),%eax
8010834c:	c1 e0 08             	shl    $0x8,%eax
8010834f:	25 00 07 00 00       	and    $0x700,%eax
80108354:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108356:	8b 45 14             	mov    0x14(%ebp),%eax
80108359:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010835e:	09 d0                	or     %edx,%eax
80108360:	0d 00 00 00 80       	or     $0x80000000,%eax
80108365:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
80108368:	ff 75 f4             	push   -0xc(%ebp)
8010836b:	e8 5a ff ff ff       	call   801082ca <pci_write_config>
80108370:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
80108373:	e8 74 ff ff ff       	call   801082ec <pci_read_config>
80108378:	8b 55 18             	mov    0x18(%ebp),%edx
8010837b:	89 02                	mov    %eax,(%edx)
}
8010837d:	90                   	nop
8010837e:	c9                   	leave
8010837f:	c3                   	ret

80108380 <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
80108380:	55                   	push   %ebp
80108381:	89 e5                	mov    %esp,%ebp
80108383:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108386:	8b 45 08             	mov    0x8(%ebp),%eax
80108389:	c1 e0 10             	shl    $0x10,%eax
8010838c:	25 00 00 ff 00       	and    $0xff0000,%eax
80108391:	89 c2                	mov    %eax,%edx
80108393:	8b 45 0c             	mov    0xc(%ebp),%eax
80108396:	c1 e0 0b             	shl    $0xb,%eax
80108399:	0f b7 c0             	movzwl %ax,%eax
8010839c:	09 c2                	or     %eax,%edx
8010839e:	8b 45 10             	mov    0x10(%ebp),%eax
801083a1:	c1 e0 08             	shl    $0x8,%eax
801083a4:	25 00 07 00 00       	and    $0x700,%eax
801083a9:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
801083ab:	8b 45 14             	mov    0x14(%ebp),%eax
801083ae:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801083b3:	09 d0                	or     %edx,%eax
801083b5:	0d 00 00 00 80       	or     $0x80000000,%eax
801083ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
801083bd:	ff 75 fc             	push   -0x4(%ebp)
801083c0:	e8 05 ff ff ff       	call   801082ca <pci_write_config>
801083c5:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
801083c8:	ff 75 18             	push   0x18(%ebp)
801083cb:	e8 0b ff ff ff       	call   801082db <pci_write_data>
801083d0:	83 c4 04             	add    $0x4,%esp
}
801083d3:	90                   	nop
801083d4:	c9                   	leave
801083d5:	c3                   	ret

801083d6 <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
801083d6:	55                   	push   %ebp
801083d7:	89 e5                	mov    %esp,%ebp
801083d9:	53                   	push   %ebx
801083da:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
801083dd:	8b 45 08             	mov    0x8(%ebp),%eax
801083e0:	a2 64 6d 19 80       	mov    %al,0x80196d64
  dev.device_num = device_num;
801083e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801083e8:	a2 65 6d 19 80       	mov    %al,0x80196d65
  dev.function_num = function_num;
801083ed:	8b 45 10             	mov    0x10(%ebp),%eax
801083f0:	a2 66 6d 19 80       	mov    %al,0x80196d66
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
801083f5:	ff 75 10             	push   0x10(%ebp)
801083f8:	ff 75 0c             	push   0xc(%ebp)
801083fb:	ff 75 08             	push   0x8(%ebp)
801083fe:	68 44 bf 10 80       	push   $0x8010bf44
80108403:	e8 ec 7f ff ff       	call   801003f4 <cprintf>
80108408:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
8010840b:	83 ec 0c             	sub    $0xc,%esp
8010840e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108411:	50                   	push   %eax
80108412:	6a 00                	push   $0x0
80108414:	ff 75 10             	push   0x10(%ebp)
80108417:	ff 75 0c             	push   0xc(%ebp)
8010841a:	ff 75 08             	push   0x8(%ebp)
8010841d:	e8 09 ff ff ff       	call   8010832b <pci_access_config>
80108422:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
80108425:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108428:	c1 e8 10             	shr    $0x10,%eax
8010842b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
8010842e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108431:	25 ff ff 00 00       	and    $0xffff,%eax
80108436:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
80108439:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010843c:	a3 68 6d 19 80       	mov    %eax,0x80196d68
  dev.vendor_id = vendor_id;
80108441:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108444:	a3 6c 6d 19 80       	mov    %eax,0x80196d6c
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
80108449:	83 ec 04             	sub    $0x4,%esp
8010844c:	ff 75 f0             	push   -0x10(%ebp)
8010844f:	ff 75 f4             	push   -0xc(%ebp)
80108452:	68 78 bf 10 80       	push   $0x8010bf78
80108457:	e8 98 7f ff ff       	call   801003f4 <cprintf>
8010845c:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
8010845f:	83 ec 0c             	sub    $0xc,%esp
80108462:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108465:	50                   	push   %eax
80108466:	6a 08                	push   $0x8
80108468:	ff 75 10             	push   0x10(%ebp)
8010846b:	ff 75 0c             	push   0xc(%ebp)
8010846e:	ff 75 08             	push   0x8(%ebp)
80108471:	e8 b5 fe ff ff       	call   8010832b <pci_access_config>
80108476:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108479:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010847c:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
8010847f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108482:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108485:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108488:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010848b:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
8010848e:	0f b6 c0             	movzbl %al,%eax
80108491:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80108494:	c1 eb 18             	shr    $0x18,%ebx
80108497:	83 ec 0c             	sub    $0xc,%esp
8010849a:	51                   	push   %ecx
8010849b:	52                   	push   %edx
8010849c:	50                   	push   %eax
8010849d:	53                   	push   %ebx
8010849e:	68 9c bf 10 80       	push   $0x8010bf9c
801084a3:	e8 4c 7f ff ff       	call   801003f4 <cprintf>
801084a8:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
801084ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084ae:	c1 e8 18             	shr    $0x18,%eax
801084b1:	a2 70 6d 19 80       	mov    %al,0x80196d70
  dev.sub_class = (data>>16)&0xFF;
801084b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084b9:	c1 e8 10             	shr    $0x10,%eax
801084bc:	a2 71 6d 19 80       	mov    %al,0x80196d71
  dev.interface = (data>>8)&0xFF;
801084c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084c4:	c1 e8 08             	shr    $0x8,%eax
801084c7:	a2 72 6d 19 80       	mov    %al,0x80196d72
  dev.revision_id = data&0xFF;
801084cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084cf:	a2 73 6d 19 80       	mov    %al,0x80196d73
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
801084d4:	83 ec 0c             	sub    $0xc,%esp
801084d7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801084da:	50                   	push   %eax
801084db:	6a 10                	push   $0x10
801084dd:	ff 75 10             	push   0x10(%ebp)
801084e0:	ff 75 0c             	push   0xc(%ebp)
801084e3:	ff 75 08             	push   0x8(%ebp)
801084e6:	e8 40 fe ff ff       	call   8010832b <pci_access_config>
801084eb:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
801084ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084f1:	a3 74 6d 19 80       	mov    %eax,0x80196d74
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
801084f6:	83 ec 0c             	sub    $0xc,%esp
801084f9:	8d 45 ec             	lea    -0x14(%ebp),%eax
801084fc:	50                   	push   %eax
801084fd:	6a 14                	push   $0x14
801084ff:	ff 75 10             	push   0x10(%ebp)
80108502:	ff 75 0c             	push   0xc(%ebp)
80108505:	ff 75 08             	push   0x8(%ebp)
80108508:	e8 1e fe ff ff       	call   8010832b <pci_access_config>
8010850d:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
80108510:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108513:	a3 78 6d 19 80       	mov    %eax,0x80196d78
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
80108518:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
8010851f:	75 5a                	jne    8010857b <pci_init_device+0x1a5>
80108521:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
80108528:	75 51                	jne    8010857b <pci_init_device+0x1a5>
    cprintf("E1000 Ethernet NIC Found\n");
8010852a:	83 ec 0c             	sub    $0xc,%esp
8010852d:	68 e1 bf 10 80       	push   $0x8010bfe1
80108532:	e8 bd 7e ff ff       	call   801003f4 <cprintf>
80108537:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
8010853a:	83 ec 0c             	sub    $0xc,%esp
8010853d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108540:	50                   	push   %eax
80108541:	68 f0 00 00 00       	push   $0xf0
80108546:	ff 75 10             	push   0x10(%ebp)
80108549:	ff 75 0c             	push   0xc(%ebp)
8010854c:	ff 75 08             	push   0x8(%ebp)
8010854f:	e8 d7 fd ff ff       	call   8010832b <pci_access_config>
80108554:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
80108557:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010855a:	83 ec 08             	sub    $0x8,%esp
8010855d:	50                   	push   %eax
8010855e:	68 fb bf 10 80       	push   $0x8010bffb
80108563:	e8 8c 7e ff ff       	call   801003f4 <cprintf>
80108568:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
8010856b:	83 ec 0c             	sub    $0xc,%esp
8010856e:	68 64 6d 19 80       	push   $0x80196d64
80108573:	e8 09 00 00 00       	call   80108581 <i8254_init>
80108578:	83 c4 10             	add    $0x10,%esp
  }
}
8010857b:	90                   	nop
8010857c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010857f:	c9                   	leave
80108580:	c3                   	ret

80108581 <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
80108581:	55                   	push   %ebp
80108582:	89 e5                	mov    %esp,%ebp
80108584:	53                   	push   %ebx
80108585:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
80108588:	8b 45 08             	mov    0x8(%ebp),%eax
8010858b:	0f b6 40 02          	movzbl 0x2(%eax),%eax
8010858f:	0f b6 c8             	movzbl %al,%ecx
80108592:	8b 45 08             	mov    0x8(%ebp),%eax
80108595:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108599:	0f b6 d0             	movzbl %al,%edx
8010859c:	8b 45 08             	mov    0x8(%ebp),%eax
8010859f:	0f b6 00             	movzbl (%eax),%eax
801085a2:	0f b6 c0             	movzbl %al,%eax
801085a5:	83 ec 0c             	sub    $0xc,%esp
801085a8:	8d 5d ec             	lea    -0x14(%ebp),%ebx
801085ab:	53                   	push   %ebx
801085ac:	6a 04                	push   $0x4
801085ae:	51                   	push   %ecx
801085af:	52                   	push   %edx
801085b0:	50                   	push   %eax
801085b1:	e8 75 fd ff ff       	call   8010832b <pci_access_config>
801085b6:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
801085b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085bc:	83 c8 04             	or     $0x4,%eax
801085bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
801085c2:	8b 5d ec             	mov    -0x14(%ebp),%ebx
801085c5:	8b 45 08             	mov    0x8(%ebp),%eax
801085c8:	0f b6 40 02          	movzbl 0x2(%eax),%eax
801085cc:	0f b6 c8             	movzbl %al,%ecx
801085cf:	8b 45 08             	mov    0x8(%ebp),%eax
801085d2:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801085d6:	0f b6 d0             	movzbl %al,%edx
801085d9:	8b 45 08             	mov    0x8(%ebp),%eax
801085dc:	0f b6 00             	movzbl (%eax),%eax
801085df:	0f b6 c0             	movzbl %al,%eax
801085e2:	83 ec 0c             	sub    $0xc,%esp
801085e5:	53                   	push   %ebx
801085e6:	6a 04                	push   $0x4
801085e8:	51                   	push   %ecx
801085e9:	52                   	push   %edx
801085ea:	50                   	push   %eax
801085eb:	e8 90 fd ff ff       	call   80108380 <pci_write_config_register>
801085f0:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
801085f3:	8b 45 08             	mov    0x8(%ebp),%eax
801085f6:	8b 40 10             	mov    0x10(%eax),%eax
801085f9:	05 00 00 00 40       	add    $0x40000000,%eax
801085fe:	a3 7c 6d 19 80       	mov    %eax,0x80196d7c
  uint *ctrl = (uint *)base_addr;
80108603:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
8010860b:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108610:	05 d8 00 00 00       	add    $0xd8,%eax
80108615:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
80108618:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010861b:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
80108621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108624:	8b 00                	mov    (%eax),%eax
80108626:	0d 00 00 00 04       	or     $0x4000000,%eax
8010862b:	89 c2                	mov    %eax,%edx
8010862d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108630:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
80108632:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108635:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
8010863b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010863e:	8b 00                	mov    (%eax),%eax
80108640:	83 c8 40             	or     $0x40,%eax
80108643:	89 c2                	mov    %eax,%edx
80108645:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108648:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
8010864a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010864d:	8b 10                	mov    (%eax),%edx
8010864f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108652:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
80108654:	83 ec 0c             	sub    $0xc,%esp
80108657:	68 10 c0 10 80       	push   $0x8010c010
8010865c:	e8 93 7d ff ff       	call   801003f4 <cprintf>
80108661:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
80108664:	e8 3f a1 ff ff       	call   801027a8 <kalloc>
80108669:	a3 88 6d 19 80       	mov    %eax,0x80196d88
  *intr_addr = 0;
8010866e:	a1 88 6d 19 80       	mov    0x80196d88,%eax
80108673:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
80108679:	a1 88 6d 19 80       	mov    0x80196d88,%eax
8010867e:	83 ec 08             	sub    $0x8,%esp
80108681:	50                   	push   %eax
80108682:	68 32 c0 10 80       	push   $0x8010c032
80108687:	e8 68 7d ff ff       	call   801003f4 <cprintf>
8010868c:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
8010868f:	e8 50 00 00 00       	call   801086e4 <i8254_init_recv>
  i8254_init_send();
80108694:	e8 69 03 00 00       	call   80108a02 <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
80108699:	0f b6 05 e7 f4 10 80 	movzbl 0x8010f4e7,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
801086a0:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
801086a3:	0f b6 05 e6 f4 10 80 	movzbl 0x8010f4e6,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
801086aa:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
801086ad:	0f b6 05 e5 f4 10 80 	movzbl 0x8010f4e5,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
801086b4:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
801086b7:	0f b6 05 e4 f4 10 80 	movzbl 0x8010f4e4,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
801086be:	0f b6 c0             	movzbl %al,%eax
801086c1:	83 ec 0c             	sub    $0xc,%esp
801086c4:	53                   	push   %ebx
801086c5:	51                   	push   %ecx
801086c6:	52                   	push   %edx
801086c7:	50                   	push   %eax
801086c8:	68 40 c0 10 80       	push   $0x8010c040
801086cd:	e8 22 7d ff ff       	call   801003f4 <cprintf>
801086d2:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
801086d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
801086de:	90                   	nop
801086df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801086e2:	c9                   	leave
801086e3:	c3                   	ret

801086e4 <i8254_init_recv>:

void i8254_init_recv(){
801086e4:	55                   	push   %ebp
801086e5:	89 e5                	mov    %esp,%ebp
801086e7:	57                   	push   %edi
801086e8:	56                   	push   %esi
801086e9:	53                   	push   %ebx
801086ea:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
801086ed:	83 ec 0c             	sub    $0xc,%esp
801086f0:	6a 00                	push   $0x0
801086f2:	e8 e8 04 00 00       	call   80108bdf <i8254_read_eeprom>
801086f7:	83 c4 10             	add    $0x10,%esp
801086fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
801086fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108700:	a2 80 6d 19 80       	mov    %al,0x80196d80
  mac_addr[1] = data_l>>8;
80108705:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108708:	c1 e8 08             	shr    $0x8,%eax
8010870b:	a2 81 6d 19 80       	mov    %al,0x80196d81
  uint data_m = i8254_read_eeprom(0x1);
80108710:	83 ec 0c             	sub    $0xc,%esp
80108713:	6a 01                	push   $0x1
80108715:	e8 c5 04 00 00       	call   80108bdf <i8254_read_eeprom>
8010871a:	83 c4 10             	add    $0x10,%esp
8010871d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
80108720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108723:	a2 82 6d 19 80       	mov    %al,0x80196d82
  mac_addr[3] = data_m>>8;
80108728:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010872b:	c1 e8 08             	shr    $0x8,%eax
8010872e:	a2 83 6d 19 80       	mov    %al,0x80196d83
  uint data_h = i8254_read_eeprom(0x2);
80108733:	83 ec 0c             	sub    $0xc,%esp
80108736:	6a 02                	push   $0x2
80108738:	e8 a2 04 00 00       	call   80108bdf <i8254_read_eeprom>
8010873d:	83 c4 10             	add    $0x10,%esp
80108740:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
80108743:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108746:	a2 84 6d 19 80       	mov    %al,0x80196d84
  mac_addr[5] = data_h>>8;
8010874b:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010874e:	c1 e8 08             	shr    $0x8,%eax
80108751:	a2 85 6d 19 80       	mov    %al,0x80196d85
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
80108756:	0f b6 05 85 6d 19 80 	movzbl 0x80196d85,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
8010875d:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
80108760:	0f b6 05 84 6d 19 80 	movzbl 0x80196d84,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108767:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
8010876a:	0f b6 05 83 6d 19 80 	movzbl 0x80196d83,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108771:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
80108774:	0f b6 05 82 6d 19 80 	movzbl 0x80196d82,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
8010877b:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
8010877e:	0f b6 05 81 6d 19 80 	movzbl 0x80196d81,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108785:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
80108788:	0f b6 05 80 6d 19 80 	movzbl 0x80196d80,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
8010878f:	0f b6 c0             	movzbl %al,%eax
80108792:	83 ec 04             	sub    $0x4,%esp
80108795:	57                   	push   %edi
80108796:	56                   	push   %esi
80108797:	53                   	push   %ebx
80108798:	51                   	push   %ecx
80108799:	52                   	push   %edx
8010879a:	50                   	push   %eax
8010879b:	68 58 c0 10 80       	push   $0x8010c058
801087a0:	e8 4f 7c ff ff       	call   801003f4 <cprintf>
801087a5:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
801087a8:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801087ad:	05 00 54 00 00       	add    $0x5400,%eax
801087b2:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
801087b5:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801087ba:	05 04 54 00 00       	add    $0x5404,%eax
801087bf:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
801087c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801087c5:	c1 e0 10             	shl    $0x10,%eax
801087c8:	0b 45 d8             	or     -0x28(%ebp),%eax
801087cb:	89 c2                	mov    %eax,%edx
801087cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
801087d0:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
801087d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
801087d5:	0d 00 00 00 80       	or     $0x80000000,%eax
801087da:	89 c2                	mov    %eax,%edx
801087dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
801087df:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
801087e1:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801087e6:	05 00 52 00 00       	add    $0x5200,%eax
801087eb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
801087ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801087f5:	eb 19                	jmp    80108810 <i8254_init_recv+0x12c>
    mta[i] = 0;
801087f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801087fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108801:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108804:	01 d0                	add    %edx,%eax
80108806:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
8010880c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80108810:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
80108814:	7e e1                	jle    801087f7 <i8254_init_recv+0x113>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
80108816:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
8010881b:	05 d0 00 00 00       	add    $0xd0,%eax
80108820:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108823:	8b 45 c0             	mov    -0x40(%ebp),%eax
80108826:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
8010882c:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108831:	05 c8 00 00 00       	add    $0xc8,%eax
80108836:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
80108839:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010883c:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
80108842:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108847:	05 28 28 00 00       	add    $0x2828,%eax
8010884c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
8010884f:	8b 45 b8             	mov    -0x48(%ebp),%eax
80108852:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
80108858:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
8010885d:	05 00 01 00 00       	add    $0x100,%eax
80108862:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
80108865:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108868:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
8010886e:	e8 35 9f ff ff       	call   801027a8 <kalloc>
80108873:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108876:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
8010887b:	05 00 28 00 00       	add    $0x2800,%eax
80108880:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
80108883:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108888:	05 04 28 00 00       	add    $0x2804,%eax
8010888d:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
80108890:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108895:	05 08 28 00 00       	add    $0x2808,%eax
8010889a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
8010889d:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801088a2:	05 10 28 00 00       	add    $0x2810,%eax
801088a7:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
801088aa:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
801088af:	05 18 28 00 00       	add    $0x2818,%eax
801088b4:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
801088b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
801088ba:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801088c0:	8b 45 ac             	mov    -0x54(%ebp),%eax
801088c3:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
801088c5:	8b 45 a8             	mov    -0x58(%ebp),%eax
801088c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
801088ce:	8b 45 a4             	mov    -0x5c(%ebp),%eax
801088d1:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
801088d7:	8b 45 a0             	mov    -0x60(%ebp),%eax
801088da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
801088e0:	8b 45 9c             	mov    -0x64(%ebp),%eax
801088e3:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
801088e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
801088ec:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
801088ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801088f6:	eb 73                	jmp    8010896b <i8254_init_recv+0x287>
    recv_desc[i].padding = 0;
801088f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801088fb:	c1 e0 04             	shl    $0x4,%eax
801088fe:	89 c2                	mov    %eax,%edx
80108900:	8b 45 98             	mov    -0x68(%ebp),%eax
80108903:	01 d0                	add    %edx,%eax
80108905:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
8010890c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010890f:	c1 e0 04             	shl    $0x4,%eax
80108912:	89 c2                	mov    %eax,%edx
80108914:	8b 45 98             	mov    -0x68(%ebp),%eax
80108917:	01 d0                	add    %edx,%eax
80108919:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
8010891f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108922:	c1 e0 04             	shl    $0x4,%eax
80108925:	89 c2                	mov    %eax,%edx
80108927:	8b 45 98             	mov    -0x68(%ebp),%eax
8010892a:	01 d0                	add    %edx,%eax
8010892c:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
80108932:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108935:	c1 e0 04             	shl    $0x4,%eax
80108938:	89 c2                	mov    %eax,%edx
8010893a:	8b 45 98             	mov    -0x68(%ebp),%eax
8010893d:	01 d0                	add    %edx,%eax
8010893f:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
80108943:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108946:	c1 e0 04             	shl    $0x4,%eax
80108949:	89 c2                	mov    %eax,%edx
8010894b:	8b 45 98             	mov    -0x68(%ebp),%eax
8010894e:	01 d0                	add    %edx,%eax
80108950:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
80108954:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108957:	c1 e0 04             	shl    $0x4,%eax
8010895a:	89 c2                	mov    %eax,%edx
8010895c:	8b 45 98             	mov    -0x68(%ebp),%eax
8010895f:	01 d0                	add    %edx,%eax
80108961:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108967:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
8010896b:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
80108972:	7e 84                	jle    801088f8 <i8254_init_recv+0x214>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108974:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
8010897b:	eb 57                	jmp    801089d4 <i8254_init_recv+0x2f0>
    uint buf_addr = (uint)kalloc();
8010897d:	e8 26 9e ff ff       	call   801027a8 <kalloc>
80108982:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
80108985:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
80108989:	75 12                	jne    8010899d <i8254_init_recv+0x2b9>
      cprintf("failed to allocate buffer area\n");
8010898b:	83 ec 0c             	sub    $0xc,%esp
8010898e:	68 78 c0 10 80       	push   $0x8010c078
80108993:	e8 5c 7a ff ff       	call   801003f4 <cprintf>
80108998:	83 c4 10             	add    $0x10,%esp
      break;
8010899b:	eb 3d                	jmp    801089da <i8254_init_recv+0x2f6>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
8010899d:	8b 45 dc             	mov    -0x24(%ebp),%eax
801089a0:	c1 e0 04             	shl    $0x4,%eax
801089a3:	89 c2                	mov    %eax,%edx
801089a5:	8b 45 98             	mov    -0x68(%ebp),%eax
801089a8:	01 d0                	add    %edx,%eax
801089aa:	8b 55 94             	mov    -0x6c(%ebp),%edx
801089ad:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801089b3:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
801089b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
801089b8:	83 c0 01             	add    $0x1,%eax
801089bb:	c1 e0 04             	shl    $0x4,%eax
801089be:	89 c2                	mov    %eax,%edx
801089c0:	8b 45 98             	mov    -0x68(%ebp),%eax
801089c3:	01 d0                	add    %edx,%eax
801089c5:	8b 55 94             	mov    -0x6c(%ebp),%edx
801089c8:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
801089ce:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
801089d0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
801089d4:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
801089d8:	7e a3                	jle    8010897d <i8254_init_recv+0x299>
  }

  *rctl |= I8254_RCTL_EN;
801089da:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801089dd:	8b 00                	mov    (%eax),%eax
801089df:	83 c8 02             	or     $0x2,%eax
801089e2:	89 c2                	mov    %eax,%edx
801089e4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801089e7:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
801089e9:	83 ec 0c             	sub    $0xc,%esp
801089ec:	68 98 c0 10 80       	push   $0x8010c098
801089f1:	e8 fe 79 ff ff       	call   801003f4 <cprintf>
801089f6:	83 c4 10             	add    $0x10,%esp
}
801089f9:	90                   	nop
801089fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801089fd:	5b                   	pop    %ebx
801089fe:	5e                   	pop    %esi
801089ff:	5f                   	pop    %edi
80108a00:	5d                   	pop    %ebp
80108a01:	c3                   	ret

80108a02 <i8254_init_send>:

void i8254_init_send(){
80108a02:	55                   	push   %ebp
80108a03:	89 e5                	mov    %esp,%ebp
80108a05:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
80108a08:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a0d:	05 28 38 00 00       	add    $0x3828,%eax
80108a12:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
80108a15:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a18:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
80108a1e:	e8 85 9d ff ff       	call   801027a8 <kalloc>
80108a23:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108a26:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a2b:	05 00 38 00 00       	add    $0x3800,%eax
80108a30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
80108a33:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a38:	05 04 38 00 00       	add    $0x3804,%eax
80108a3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
80108a40:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a45:	05 08 38 00 00       	add    $0x3808,%eax
80108a4a:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
80108a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a50:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108a56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108a59:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
80108a5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
80108a64:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108a67:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
80108a6d:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a72:	05 10 38 00 00       	add    $0x3810,%eax
80108a77:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108a7a:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108a7f:	05 18 38 00 00       	add    $0x3818,%eax
80108a84:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
80108a87:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108a8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
80108a90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108a93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
80108a99:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a9c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108a9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108aa6:	e9 82 00 00 00       	jmp    80108b2d <i8254_init_send+0x12b>
    send_desc[i].padding = 0;
80108aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aae:	c1 e0 04             	shl    $0x4,%eax
80108ab1:	89 c2                	mov    %eax,%edx
80108ab3:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108ab6:	01 d0                	add    %edx,%eax
80108ab8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
80108abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ac2:	c1 e0 04             	shl    $0x4,%eax
80108ac5:	89 c2                	mov    %eax,%edx
80108ac7:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108aca:	01 d0                	add    %edx,%eax
80108acc:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
80108ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad5:	c1 e0 04             	shl    $0x4,%eax
80108ad8:	89 c2                	mov    %eax,%edx
80108ada:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108add:	01 d0                	add    %edx,%eax
80108adf:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
80108ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ae6:	c1 e0 04             	shl    $0x4,%eax
80108ae9:	89 c2                	mov    %eax,%edx
80108aeb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108aee:	01 d0                	add    %edx,%eax
80108af0:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
80108af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108af7:	c1 e0 04             	shl    $0x4,%eax
80108afa:	89 c2                	mov    %eax,%edx
80108afc:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108aff:	01 d0                	add    %edx,%eax
80108b01:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
80108b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b08:	c1 e0 04             	shl    $0x4,%eax
80108b0b:	89 c2                	mov    %eax,%edx
80108b0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b10:	01 d0                	add    %edx,%eax
80108b12:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
80108b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b19:	c1 e0 04             	shl    $0x4,%eax
80108b1c:	89 c2                	mov    %eax,%edx
80108b1e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b21:	01 d0                	add    %edx,%eax
80108b23:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108b29:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108b2d:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108b34:	0f 8e 71 ff ff ff    	jle    80108aab <i8254_init_send+0xa9>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108b3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108b41:	eb 57                	jmp    80108b9a <i8254_init_send+0x198>
    uint buf_addr = (uint)kalloc();
80108b43:	e8 60 9c ff ff       	call   801027a8 <kalloc>
80108b48:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
80108b4b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80108b4f:	75 12                	jne    80108b63 <i8254_init_send+0x161>
      cprintf("failed to allocate buffer area\n");
80108b51:	83 ec 0c             	sub    $0xc,%esp
80108b54:	68 78 c0 10 80       	push   $0x8010c078
80108b59:	e8 96 78 ff ff       	call   801003f4 <cprintf>
80108b5e:	83 c4 10             	add    $0x10,%esp
      break;
80108b61:	eb 3d                	jmp    80108ba0 <i8254_init_send+0x19e>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
80108b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b66:	c1 e0 04             	shl    $0x4,%eax
80108b69:	89 c2                	mov    %eax,%edx
80108b6b:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b6e:	01 d0                	add    %edx,%eax
80108b70:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108b73:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108b79:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b7e:	83 c0 01             	add    $0x1,%eax
80108b81:	c1 e0 04             	shl    $0x4,%eax
80108b84:	89 c2                	mov    %eax,%edx
80108b86:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b89:	01 d0                	add    %edx,%eax
80108b8b:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108b8e:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108b94:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108b96:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108b9a:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80108b9e:	7e a3                	jle    80108b43 <i8254_init_send+0x141>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
80108ba0:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108ba5:	05 00 04 00 00       	add    $0x400,%eax
80108baa:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
80108bad:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108bb0:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
80108bb6:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108bbb:	05 10 04 00 00       	add    $0x410,%eax
80108bc0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
80108bc3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108bc6:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
80108bcc:	83 ec 0c             	sub    $0xc,%esp
80108bcf:	68 b8 c0 10 80       	push   $0x8010c0b8
80108bd4:	e8 1b 78 ff ff       	call   801003f4 <cprintf>
80108bd9:	83 c4 10             	add    $0x10,%esp

}
80108bdc:	90                   	nop
80108bdd:	c9                   	leave
80108bde:	c3                   	ret

80108bdf <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
80108bdf:	55                   	push   %ebp
80108be0:	89 e5                	mov    %esp,%ebp
80108be2:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
80108be5:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108bea:	83 c0 14             	add    $0x14,%eax
80108bed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
80108bf0:	8b 45 08             	mov    0x8(%ebp),%eax
80108bf3:	c1 e0 08             	shl    $0x8,%eax
80108bf6:	0f b7 c0             	movzwl %ax,%eax
80108bf9:	83 c8 01             	or     $0x1,%eax
80108bfc:	89 c2                	mov    %eax,%edx
80108bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c01:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
80108c03:	83 ec 0c             	sub    $0xc,%esp
80108c06:	68 d8 c0 10 80       	push   $0x8010c0d8
80108c0b:	e8 e4 77 ff ff       	call   801003f4 <cprintf>
80108c10:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
80108c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c16:	8b 00                	mov    (%eax),%eax
80108c18:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
80108c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c1e:	83 e0 10             	and    $0x10,%eax
80108c21:	85 c0                	test   %eax,%eax
80108c23:	75 02                	jne    80108c27 <i8254_read_eeprom+0x48>
  while(1){
80108c25:	eb dc                	jmp    80108c03 <i8254_read_eeprom+0x24>
      break;
80108c27:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
80108c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c2b:	8b 00                	mov    (%eax),%eax
80108c2d:	c1 e8 10             	shr    $0x10,%eax
}
80108c30:	c9                   	leave
80108c31:	c3                   	ret

80108c32 <i8254_recv>:
void i8254_recv(){
80108c32:	55                   	push   %ebp
80108c33:	89 e5                	mov    %esp,%ebp
80108c35:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
80108c38:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108c3d:	05 10 28 00 00       	add    $0x2810,%eax
80108c42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108c45:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108c4a:	05 18 28 00 00       	add    $0x2818,%eax
80108c4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108c52:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108c57:	05 00 28 00 00       	add    $0x2800,%eax
80108c5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
80108c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c62:	8b 00                	mov    (%eax),%eax
80108c64:	05 00 00 00 80       	add    $0x80000000,%eax
80108c69:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80108c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c6f:	8b 10                	mov    (%eax),%edx
80108c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c74:	8b 00                	mov    (%eax),%eax
80108c76:	29 c2                	sub    %eax,%edx
80108c78:	89 d0                	mov    %edx,%eax
80108c7a:	25 ff 00 00 00       	and    $0xff,%eax
80108c7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
80108c82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108c86:	7e 37                	jle    80108cbf <i8254_recv+0x8d>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
80108c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c8b:	8b 00                	mov    (%eax),%eax
80108c8d:	c1 e0 04             	shl    $0x4,%eax
80108c90:	89 c2                	mov    %eax,%edx
80108c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c95:	01 d0                	add    %edx,%eax
80108c97:	8b 00                	mov    (%eax),%eax
80108c99:	05 00 00 00 80       	add    $0x80000000,%eax
80108c9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
80108ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ca4:	8b 00                	mov    (%eax),%eax
80108ca6:	83 c0 01             	add    $0x1,%eax
80108ca9:	0f b6 d0             	movzbl %al,%edx
80108cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108caf:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
80108cb1:	83 ec 0c             	sub    $0xc,%esp
80108cb4:	ff 75 e0             	push   -0x20(%ebp)
80108cb7:	e8 13 09 00 00       	call   801095cf <eth_proc>
80108cbc:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
80108cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cc2:	8b 10                	mov    (%eax),%edx
80108cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc7:	8b 00                	mov    (%eax),%eax
80108cc9:	39 c2                	cmp    %eax,%edx
80108ccb:	75 9f                	jne    80108c6c <i8254_recv+0x3a>
      (*rdt)--;
80108ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cd0:	8b 00                	mov    (%eax),%eax
80108cd2:	8d 50 ff             	lea    -0x1(%eax),%edx
80108cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cd8:	89 10                	mov    %edx,(%eax)
  while(1){
80108cda:	eb 90                	jmp    80108c6c <i8254_recv+0x3a>

80108cdc <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
80108cdc:	55                   	push   %ebp
80108cdd:	89 e5                	mov    %esp,%ebp
80108cdf:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
80108ce2:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108ce7:	05 10 38 00 00       	add    $0x3810,%eax
80108cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108cef:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108cf4:	05 18 38 00 00       	add    $0x3818,%eax
80108cf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108cfc:	a1 7c 6d 19 80       	mov    0x80196d7c,%eax
80108d01:	05 00 38 00 00       	add    $0x3800,%eax
80108d06:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
80108d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d0c:	8b 00                	mov    (%eax),%eax
80108d0e:	05 00 00 00 80       	add    $0x80000000,%eax
80108d13:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
80108d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d19:	8b 10                	mov    (%eax),%edx
80108d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d1e:	8b 00                	mov    (%eax),%eax
80108d20:	29 c2                	sub    %eax,%edx
80108d22:	0f b6 c2             	movzbl %dl,%eax
80108d25:	ba 00 01 00 00       	mov    $0x100,%edx
80108d2a:	29 c2                	sub    %eax,%edx
80108d2c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
80108d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d32:	8b 00                	mov    (%eax),%eax
80108d34:	25 ff 00 00 00       	and    $0xff,%eax
80108d39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
80108d3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108d40:	0f 8e a8 00 00 00    	jle    80108dee <i8254_send+0x112>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
80108d46:	8b 45 08             	mov    0x8(%ebp),%eax
80108d49:	8b 55 e0             	mov    -0x20(%ebp),%edx
80108d4c:	89 d1                	mov    %edx,%ecx
80108d4e:	c1 e1 04             	shl    $0x4,%ecx
80108d51:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108d54:	01 ca                	add    %ecx,%edx
80108d56:	8b 12                	mov    (%edx),%edx
80108d58:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108d5e:	83 ec 04             	sub    $0x4,%esp
80108d61:	ff 75 0c             	push   0xc(%ebp)
80108d64:	50                   	push   %eax
80108d65:	52                   	push   %edx
80108d66:	e8 1c bf ff ff       	call   80104c87 <memmove>
80108d6b:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
80108d6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d71:	c1 e0 04             	shl    $0x4,%eax
80108d74:	89 c2                	mov    %eax,%edx
80108d76:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d79:	01 d0                	add    %edx,%eax
80108d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
80108d7e:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
80108d82:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d85:	c1 e0 04             	shl    $0x4,%eax
80108d88:	89 c2                	mov    %eax,%edx
80108d8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d8d:	01 d0                	add    %edx,%eax
80108d8f:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
80108d93:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d96:	c1 e0 04             	shl    $0x4,%eax
80108d99:	89 c2                	mov    %eax,%edx
80108d9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d9e:	01 d0                	add    %edx,%eax
80108da0:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
80108da4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108da7:	c1 e0 04             	shl    $0x4,%eax
80108daa:	89 c2                	mov    %eax,%edx
80108dac:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108daf:	01 d0                	add    %edx,%eax
80108db1:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
80108db5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108db8:	c1 e0 04             	shl    $0x4,%eax
80108dbb:	89 c2                	mov    %eax,%edx
80108dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108dc0:	01 d0                	add    %edx,%eax
80108dc2:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
80108dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108dcb:	c1 e0 04             	shl    $0x4,%eax
80108dce:	89 c2                	mov    %eax,%edx
80108dd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108dd3:	01 d0                	add    %edx,%eax
80108dd5:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
80108dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ddc:	8b 00                	mov    (%eax),%eax
80108dde:	83 c0 01             	add    $0x1,%eax
80108de1:	0f b6 d0             	movzbl %al,%edx
80108de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108de7:	89 10                	mov    %edx,(%eax)
    return len;
80108de9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108dec:	eb 05                	jmp    80108df3 <i8254_send+0x117>
  }else{
    return -1;
80108dee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80108df3:	c9                   	leave
80108df4:	c3                   	ret

80108df5 <i8254_intr>:

void i8254_intr(){
80108df5:	55                   	push   %ebp
80108df6:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
80108df8:	a1 88 6d 19 80       	mov    0x80196d88,%eax
80108dfd:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
80108e03:	90                   	nop
80108e04:	5d                   	pop    %ebp
80108e05:	c3                   	ret

80108e06 <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
80108e06:	55                   	push   %ebp
80108e07:	89 e5                	mov    %esp,%ebp
80108e09:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
80108e0c:	8b 45 08             	mov    0x8(%ebp),%eax
80108e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
80108e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e15:	0f b7 00             	movzwl (%eax),%eax
80108e18:	66 3d 00 01          	cmp    $0x100,%ax
80108e1c:	74 0a                	je     80108e28 <arp_proc+0x22>
80108e1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e23:	e9 4f 01 00 00       	jmp    80108f77 <arp_proc+0x171>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
80108e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e2b:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80108e2f:	66 83 f8 08          	cmp    $0x8,%ax
80108e33:	74 0a                	je     80108e3f <arp_proc+0x39>
80108e35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e3a:	e9 38 01 00 00       	jmp    80108f77 <arp_proc+0x171>
  if(arp_p->hrd_len != 6) return -1;
80108e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e42:	0f b6 40 04          	movzbl 0x4(%eax),%eax
80108e46:	3c 06                	cmp    $0x6,%al
80108e48:	74 0a                	je     80108e54 <arp_proc+0x4e>
80108e4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e4f:	e9 23 01 00 00       	jmp    80108f77 <arp_proc+0x171>
  if(arp_p->pro_len != 4) return -1;
80108e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e57:	0f b6 40 05          	movzbl 0x5(%eax),%eax
80108e5b:	3c 04                	cmp    $0x4,%al
80108e5d:	74 0a                	je     80108e69 <arp_proc+0x63>
80108e5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e64:	e9 0e 01 00 00       	jmp    80108f77 <arp_proc+0x171>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
80108e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e6c:	83 c0 18             	add    $0x18,%eax
80108e6f:	83 ec 04             	sub    $0x4,%esp
80108e72:	6a 04                	push   $0x4
80108e74:	50                   	push   %eax
80108e75:	68 e4 f4 10 80       	push   $0x8010f4e4
80108e7a:	e8 b0 bd ff ff       	call   80104c2f <memcmp>
80108e7f:	83 c4 10             	add    $0x10,%esp
80108e82:	85 c0                	test   %eax,%eax
80108e84:	74 27                	je     80108ead <arp_proc+0xa7>
80108e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e89:	83 c0 0e             	add    $0xe,%eax
80108e8c:	83 ec 04             	sub    $0x4,%esp
80108e8f:	6a 04                	push   $0x4
80108e91:	50                   	push   %eax
80108e92:	68 e4 f4 10 80       	push   $0x8010f4e4
80108e97:	e8 93 bd ff ff       	call   80104c2f <memcmp>
80108e9c:	83 c4 10             	add    $0x10,%esp
80108e9f:	85 c0                	test   %eax,%eax
80108ea1:	74 0a                	je     80108ead <arp_proc+0xa7>
80108ea3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108ea8:	e9 ca 00 00 00       	jmp    80108f77 <arp_proc+0x171>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eb0:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108eb4:	66 3d 00 01          	cmp    $0x100,%ax
80108eb8:	75 69                	jne    80108f23 <arp_proc+0x11d>
80108eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ebd:	83 c0 18             	add    $0x18,%eax
80108ec0:	83 ec 04             	sub    $0x4,%esp
80108ec3:	6a 04                	push   $0x4
80108ec5:	50                   	push   %eax
80108ec6:	68 e4 f4 10 80       	push   $0x8010f4e4
80108ecb:	e8 5f bd ff ff       	call   80104c2f <memcmp>
80108ed0:	83 c4 10             	add    $0x10,%esp
80108ed3:	85 c0                	test   %eax,%eax
80108ed5:	75 4c                	jne    80108f23 <arp_proc+0x11d>
    uint send = (uint)kalloc();
80108ed7:	e8 cc 98 ff ff       	call   801027a8 <kalloc>
80108edc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
80108edf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
80108ee6:	83 ec 04             	sub    $0x4,%esp
80108ee9:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108eec:	50                   	push   %eax
80108eed:	ff 75 f0             	push   -0x10(%ebp)
80108ef0:	ff 75 f4             	push   -0xc(%ebp)
80108ef3:	e8 1f 04 00 00       	call   80109317 <arp_reply_pkt_create>
80108ef8:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
80108efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108efe:	83 ec 08             	sub    $0x8,%esp
80108f01:	50                   	push   %eax
80108f02:	ff 75 f0             	push   -0x10(%ebp)
80108f05:	e8 d2 fd ff ff       	call   80108cdc <i8254_send>
80108f0a:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
80108f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f10:	83 ec 0c             	sub    $0xc,%esp
80108f13:	50                   	push   %eax
80108f14:	e8 f5 97 ff ff       	call   8010270e <kfree>
80108f19:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
80108f1c:	b8 02 00 00 00       	mov    $0x2,%eax
80108f21:	eb 54                	jmp    80108f77 <arp_proc+0x171>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f26:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108f2a:	66 3d 00 02          	cmp    $0x200,%ax
80108f2e:	75 42                	jne    80108f72 <arp_proc+0x16c>
80108f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f33:	83 c0 18             	add    $0x18,%eax
80108f36:	83 ec 04             	sub    $0x4,%esp
80108f39:	6a 04                	push   $0x4
80108f3b:	50                   	push   %eax
80108f3c:	68 e4 f4 10 80       	push   $0x8010f4e4
80108f41:	e8 e9 bc ff ff       	call   80104c2f <memcmp>
80108f46:	83 c4 10             	add    $0x10,%esp
80108f49:	85 c0                	test   %eax,%eax
80108f4b:	75 25                	jne    80108f72 <arp_proc+0x16c>
    cprintf("ARP TABLE UPDATED\n");
80108f4d:	83 ec 0c             	sub    $0xc,%esp
80108f50:	68 dc c0 10 80       	push   $0x8010c0dc
80108f55:	e8 9a 74 ff ff       	call   801003f4 <cprintf>
80108f5a:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
80108f5d:	83 ec 0c             	sub    $0xc,%esp
80108f60:	ff 75 f4             	push   -0xc(%ebp)
80108f63:	e8 af 01 00 00       	call   80109117 <arp_table_update>
80108f68:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
80108f6b:	b8 01 00 00 00       	mov    $0x1,%eax
80108f70:	eb 05                	jmp    80108f77 <arp_proc+0x171>
  }else{
    return -1;
80108f72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80108f77:	c9                   	leave
80108f78:	c3                   	ret

80108f79 <arp_scan>:

void arp_scan(){
80108f79:	55                   	push   %ebp
80108f7a:	89 e5                	mov    %esp,%ebp
80108f7c:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
80108f7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108f86:	eb 6f                	jmp    80108ff7 <arp_scan+0x7e>
    uint send = (uint)kalloc();
80108f88:	e8 1b 98 ff ff       	call   801027a8 <kalloc>
80108f8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
80108f90:	83 ec 04             	sub    $0x4,%esp
80108f93:	ff 75 f4             	push   -0xc(%ebp)
80108f96:	8d 45 e8             	lea    -0x18(%ebp),%eax
80108f99:	50                   	push   %eax
80108f9a:	ff 75 ec             	push   -0x14(%ebp)
80108f9d:	e8 62 00 00 00       	call   80109004 <arp_broadcast>
80108fa2:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
80108fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108fa8:	83 ec 08             	sub    $0x8,%esp
80108fab:	50                   	push   %eax
80108fac:	ff 75 ec             	push   -0x14(%ebp)
80108faf:	e8 28 fd ff ff       	call   80108cdc <i8254_send>
80108fb4:	83 c4 10             	add    $0x10,%esp
80108fb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80108fba:	eb 22                	jmp    80108fde <arp_scan+0x65>
      microdelay(1);
80108fbc:	83 ec 0c             	sub    $0xc,%esp
80108fbf:	6a 01                	push   $0x1
80108fc1:	e8 73 9b ff ff       	call   80102b39 <microdelay>
80108fc6:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
80108fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108fcc:	83 ec 08             	sub    $0x8,%esp
80108fcf:	50                   	push   %eax
80108fd0:	ff 75 ec             	push   -0x14(%ebp)
80108fd3:	e8 04 fd ff ff       	call   80108cdc <i8254_send>
80108fd8:	83 c4 10             	add    $0x10,%esp
80108fdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
80108fde:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
80108fe2:	74 d8                	je     80108fbc <arp_scan+0x43>
    }
    kfree((char *)send);
80108fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108fe7:	83 ec 0c             	sub    $0xc,%esp
80108fea:	50                   	push   %eax
80108feb:	e8 1e 97 ff ff       	call   8010270e <kfree>
80108ff0:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
80108ff3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108ff7:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108ffe:	7e 88                	jle    80108f88 <arp_scan+0xf>
  }
}
80109000:	90                   	nop
80109001:	90                   	nop
80109002:	c9                   	leave
80109003:	c3                   	ret

80109004 <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
80109004:	55                   	push   %ebp
80109005:	89 e5                	mov    %esp,%ebp
80109007:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
8010900a:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
8010900e:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
80109012:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
80109016:	8b 45 10             	mov    0x10(%ebp),%eax
80109019:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
8010901c:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
80109023:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
80109029:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80109030:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
80109036:	8b 45 0c             	mov    0xc(%ebp),%eax
80109039:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
8010903f:	8b 45 08             	mov    0x8(%ebp),%eax
80109042:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
80109045:	8b 45 08             	mov    0x8(%ebp),%eax
80109048:	83 c0 0e             	add    $0xe,%eax
8010904b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
8010904e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109051:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
80109055:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109058:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
8010905c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010905f:	83 ec 04             	sub    $0x4,%esp
80109062:	6a 06                	push   $0x6
80109064:	8d 55 e6             	lea    -0x1a(%ebp),%edx
80109067:	52                   	push   %edx
80109068:	50                   	push   %eax
80109069:	e8 19 bc ff ff       	call   80104c87 <memmove>
8010906e:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
80109071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109074:	83 c0 06             	add    $0x6,%eax
80109077:	83 ec 04             	sub    $0x4,%esp
8010907a:	6a 06                	push   $0x6
8010907c:	68 80 6d 19 80       	push   $0x80196d80
80109081:	50                   	push   %eax
80109082:	e8 00 bc ff ff       	call   80104c87 <memmove>
80109087:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
8010908a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010908d:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109092:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109095:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
8010909b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010909e:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
801090a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090a5:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
801090a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090ac:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
801090b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090b5:	8d 50 12             	lea    0x12(%eax),%edx
801090b8:	83 ec 04             	sub    $0x4,%esp
801090bb:	6a 06                	push   $0x6
801090bd:	8d 45 e0             	lea    -0x20(%ebp),%eax
801090c0:	50                   	push   %eax
801090c1:	52                   	push   %edx
801090c2:	e8 c0 bb ff ff       	call   80104c87 <memmove>
801090c7:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
801090ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090cd:	8d 50 18             	lea    0x18(%eax),%edx
801090d0:	83 ec 04             	sub    $0x4,%esp
801090d3:	6a 04                	push   $0x4
801090d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801090d8:	50                   	push   %eax
801090d9:	52                   	push   %edx
801090da:	e8 a8 bb ff ff       	call   80104c87 <memmove>
801090df:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
801090e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090e5:	83 c0 08             	add    $0x8,%eax
801090e8:	83 ec 04             	sub    $0x4,%esp
801090eb:	6a 06                	push   $0x6
801090ed:	68 80 6d 19 80       	push   $0x80196d80
801090f2:	50                   	push   %eax
801090f3:	e8 8f bb ff ff       	call   80104c87 <memmove>
801090f8:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
801090fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090fe:	83 c0 0e             	add    $0xe,%eax
80109101:	83 ec 04             	sub    $0x4,%esp
80109104:	6a 04                	push   $0x4
80109106:	68 e4 f4 10 80       	push   $0x8010f4e4
8010910b:	50                   	push   %eax
8010910c:	e8 76 bb ff ff       	call   80104c87 <memmove>
80109111:	83 c4 10             	add    $0x10,%esp
}
80109114:	90                   	nop
80109115:	c9                   	leave
80109116:	c3                   	ret

80109117 <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
80109117:	55                   	push   %ebp
80109118:	89 e5                	mov    %esp,%ebp
8010911a:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
8010911d:	8b 45 08             	mov    0x8(%ebp),%eax
80109120:	83 c0 0e             	add    $0xe,%eax
80109123:	83 ec 0c             	sub    $0xc,%esp
80109126:	50                   	push   %eax
80109127:	e8 bc 00 00 00       	call   801091e8 <arp_table_search>
8010912c:	83 c4 10             	add    $0x10,%esp
8010912f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
80109132:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109136:	78 2d                	js     80109165 <arp_table_update+0x4e>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
80109138:	8b 45 08             	mov    0x8(%ebp),%eax
8010913b:	8d 48 08             	lea    0x8(%eax),%ecx
8010913e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109141:	89 d0                	mov    %edx,%eax
80109143:	c1 e0 02             	shl    $0x2,%eax
80109146:	01 d0                	add    %edx,%eax
80109148:	01 c0                	add    %eax,%eax
8010914a:	01 d0                	add    %edx,%eax
8010914c:	05 a0 6d 19 80       	add    $0x80196da0,%eax
80109151:	83 c0 04             	add    $0x4,%eax
80109154:	83 ec 04             	sub    $0x4,%esp
80109157:	6a 06                	push   $0x6
80109159:	51                   	push   %ecx
8010915a:	50                   	push   %eax
8010915b:	e8 27 bb ff ff       	call   80104c87 <memmove>
80109160:	83 c4 10             	add    $0x10,%esp
80109163:	eb 70                	jmp    801091d5 <arp_table_update+0xbe>
  }else{
    index += 1;
80109165:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
80109169:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
8010916c:	8b 45 08             	mov    0x8(%ebp),%eax
8010916f:	8d 48 08             	lea    0x8(%eax),%ecx
80109172:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109175:	89 d0                	mov    %edx,%eax
80109177:	c1 e0 02             	shl    $0x2,%eax
8010917a:	01 d0                	add    %edx,%eax
8010917c:	01 c0                	add    %eax,%eax
8010917e:	01 d0                	add    %edx,%eax
80109180:	05 a0 6d 19 80       	add    $0x80196da0,%eax
80109185:	83 c0 04             	add    $0x4,%eax
80109188:	83 ec 04             	sub    $0x4,%esp
8010918b:	6a 06                	push   $0x6
8010918d:	51                   	push   %ecx
8010918e:	50                   	push   %eax
8010918f:	e8 f3 ba ff ff       	call   80104c87 <memmove>
80109194:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
80109197:	8b 45 08             	mov    0x8(%ebp),%eax
8010919a:	8d 48 0e             	lea    0xe(%eax),%ecx
8010919d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801091a0:	89 d0                	mov    %edx,%eax
801091a2:	c1 e0 02             	shl    $0x2,%eax
801091a5:	01 d0                	add    %edx,%eax
801091a7:	01 c0                	add    %eax,%eax
801091a9:	01 d0                	add    %edx,%eax
801091ab:	05 a0 6d 19 80       	add    $0x80196da0,%eax
801091b0:	83 ec 04             	sub    $0x4,%esp
801091b3:	6a 04                	push   $0x4
801091b5:	51                   	push   %ecx
801091b6:	50                   	push   %eax
801091b7:	e8 cb ba ff ff       	call   80104c87 <memmove>
801091bc:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
801091bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801091c2:	89 d0                	mov    %edx,%eax
801091c4:	c1 e0 02             	shl    $0x2,%eax
801091c7:	01 d0                	add    %edx,%eax
801091c9:	01 c0                	add    %eax,%eax
801091cb:	01 d0                	add    %edx,%eax
801091cd:	05 aa 6d 19 80       	add    $0x80196daa,%eax
801091d2:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
801091d5:	83 ec 0c             	sub    $0xc,%esp
801091d8:	68 a0 6d 19 80       	push   $0x80196da0
801091dd:	e8 83 00 00 00       	call   80109265 <print_arp_table>
801091e2:	83 c4 10             	add    $0x10,%esp
}
801091e5:	90                   	nop
801091e6:	c9                   	leave
801091e7:	c3                   	ret

801091e8 <arp_table_search>:

int arp_table_search(uchar *ip){
801091e8:	55                   	push   %ebp
801091e9:	89 e5                	mov    %esp,%ebp
801091eb:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
801091ee:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
801091f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801091fc:	eb 59                	jmp    80109257 <arp_table_search+0x6f>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
801091fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
80109201:	89 d0                	mov    %edx,%eax
80109203:	c1 e0 02             	shl    $0x2,%eax
80109206:	01 d0                	add    %edx,%eax
80109208:	01 c0                	add    %eax,%eax
8010920a:	01 d0                	add    %edx,%eax
8010920c:	05 a0 6d 19 80       	add    $0x80196da0,%eax
80109211:	83 ec 04             	sub    $0x4,%esp
80109214:	6a 04                	push   $0x4
80109216:	ff 75 08             	push   0x8(%ebp)
80109219:	50                   	push   %eax
8010921a:	e8 10 ba ff ff       	call   80104c2f <memcmp>
8010921f:	83 c4 10             	add    $0x10,%esp
80109222:	85 c0                	test   %eax,%eax
80109224:	75 05                	jne    8010922b <arp_table_search+0x43>
      return i;
80109226:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109229:	eb 38                	jmp    80109263 <arp_table_search+0x7b>
    }
    if(arp_table[i].use == 0 && empty == 1){
8010922b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010922e:	89 d0                	mov    %edx,%eax
80109230:	c1 e0 02             	shl    $0x2,%eax
80109233:	01 d0                	add    %edx,%eax
80109235:	01 c0                	add    %eax,%eax
80109237:	01 d0                	add    %edx,%eax
80109239:	05 aa 6d 19 80       	add    $0x80196daa,%eax
8010923e:	0f b6 00             	movzbl (%eax),%eax
80109241:	84 c0                	test   %al,%al
80109243:	75 0e                	jne    80109253 <arp_table_search+0x6b>
80109245:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80109249:	75 08                	jne    80109253 <arp_table_search+0x6b>
      empty = -i;
8010924b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010924e:	f7 d8                	neg    %eax
80109250:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
80109253:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80109257:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
8010925b:	7e a1                	jle    801091fe <arp_table_search+0x16>
    }
  }
  return empty-1;
8010925d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109260:	83 e8 01             	sub    $0x1,%eax
}
80109263:	c9                   	leave
80109264:	c3                   	ret

80109265 <print_arp_table>:

void print_arp_table(){
80109265:	55                   	push   %ebp
80109266:	89 e5                	mov    %esp,%ebp
80109268:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
8010926b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109272:	e9 92 00 00 00       	jmp    80109309 <print_arp_table+0xa4>
    if(arp_table[i].use != 0){
80109277:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010927a:	89 d0                	mov    %edx,%eax
8010927c:	c1 e0 02             	shl    $0x2,%eax
8010927f:	01 d0                	add    %edx,%eax
80109281:	01 c0                	add    %eax,%eax
80109283:	01 d0                	add    %edx,%eax
80109285:	05 aa 6d 19 80       	add    $0x80196daa,%eax
8010928a:	0f b6 00             	movzbl (%eax),%eax
8010928d:	84 c0                	test   %al,%al
8010928f:	74 74                	je     80109305 <print_arp_table+0xa0>
      cprintf("Entry Num: %d ",i);
80109291:	83 ec 08             	sub    $0x8,%esp
80109294:	ff 75 f4             	push   -0xc(%ebp)
80109297:	68 ef c0 10 80       	push   $0x8010c0ef
8010929c:	e8 53 71 ff ff       	call   801003f4 <cprintf>
801092a1:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
801092a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801092a7:	89 d0                	mov    %edx,%eax
801092a9:	c1 e0 02             	shl    $0x2,%eax
801092ac:	01 d0                	add    %edx,%eax
801092ae:	01 c0                	add    %eax,%eax
801092b0:	01 d0                	add    %edx,%eax
801092b2:	05 a0 6d 19 80       	add    $0x80196da0,%eax
801092b7:	83 ec 0c             	sub    $0xc,%esp
801092ba:	50                   	push   %eax
801092bb:	e8 54 02 00 00       	call   80109514 <print_ipv4>
801092c0:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
801092c3:	83 ec 0c             	sub    $0xc,%esp
801092c6:	68 fe c0 10 80       	push   $0x8010c0fe
801092cb:	e8 24 71 ff ff       	call   801003f4 <cprintf>
801092d0:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
801092d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801092d6:	89 d0                	mov    %edx,%eax
801092d8:	c1 e0 02             	shl    $0x2,%eax
801092db:	01 d0                	add    %edx,%eax
801092dd:	01 c0                	add    %eax,%eax
801092df:	01 d0                	add    %edx,%eax
801092e1:	05 a0 6d 19 80       	add    $0x80196da0,%eax
801092e6:	83 c0 04             	add    $0x4,%eax
801092e9:	83 ec 0c             	sub    $0xc,%esp
801092ec:	50                   	push   %eax
801092ed:	e8 70 02 00 00       	call   80109562 <print_mac>
801092f2:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
801092f5:	83 ec 0c             	sub    $0xc,%esp
801092f8:	68 00 c1 10 80       	push   $0x8010c100
801092fd:	e8 f2 70 ff ff       	call   801003f4 <cprintf>
80109302:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
80109305:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109309:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
8010930d:	0f 8e 64 ff ff ff    	jle    80109277 <print_arp_table+0x12>
    }
  }
}
80109313:	90                   	nop
80109314:	90                   	nop
80109315:	c9                   	leave
80109316:	c3                   	ret

80109317 <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
80109317:	55                   	push   %ebp
80109318:	89 e5                	mov    %esp,%ebp
8010931a:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
8010931d:	8b 45 10             	mov    0x10(%ebp),%eax
80109320:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
80109326:	8b 45 0c             	mov    0xc(%ebp),%eax
80109329:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
8010932c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010932f:	83 c0 0e             	add    $0xe,%eax
80109332:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
80109335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109338:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
8010933c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010933f:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
80109343:	8b 45 08             	mov    0x8(%ebp),%eax
80109346:	8d 50 08             	lea    0x8(%eax),%edx
80109349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010934c:	83 ec 04             	sub    $0x4,%esp
8010934f:	6a 06                	push   $0x6
80109351:	52                   	push   %edx
80109352:	50                   	push   %eax
80109353:	e8 2f b9 ff ff       	call   80104c87 <memmove>
80109358:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
8010935b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010935e:	83 c0 06             	add    $0x6,%eax
80109361:	83 ec 04             	sub    $0x4,%esp
80109364:	6a 06                	push   $0x6
80109366:	68 80 6d 19 80       	push   $0x80196d80
8010936b:	50                   	push   %eax
8010936c:	e8 16 b9 ff ff       	call   80104c87 <memmove>
80109371:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109374:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109377:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
8010937c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010937f:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109385:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109388:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
8010938c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010938f:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
80109393:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109396:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
8010939c:	8b 45 08             	mov    0x8(%ebp),%eax
8010939f:	8d 50 08             	lea    0x8(%eax),%edx
801093a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093a5:	83 c0 12             	add    $0x12,%eax
801093a8:	83 ec 04             	sub    $0x4,%esp
801093ab:	6a 06                	push   $0x6
801093ad:	52                   	push   %edx
801093ae:	50                   	push   %eax
801093af:	e8 d3 b8 ff ff       	call   80104c87 <memmove>
801093b4:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
801093b7:	8b 45 08             	mov    0x8(%ebp),%eax
801093ba:	8d 50 0e             	lea    0xe(%eax),%edx
801093bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093c0:	83 c0 18             	add    $0x18,%eax
801093c3:	83 ec 04             	sub    $0x4,%esp
801093c6:	6a 04                	push   $0x4
801093c8:	52                   	push   %edx
801093c9:	50                   	push   %eax
801093ca:	e8 b8 b8 ff ff       	call   80104c87 <memmove>
801093cf:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
801093d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093d5:	83 c0 08             	add    $0x8,%eax
801093d8:	83 ec 04             	sub    $0x4,%esp
801093db:	6a 06                	push   $0x6
801093dd:	68 80 6d 19 80       	push   $0x80196d80
801093e2:	50                   	push   %eax
801093e3:	e8 9f b8 ff ff       	call   80104c87 <memmove>
801093e8:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
801093eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093ee:	83 c0 0e             	add    $0xe,%eax
801093f1:	83 ec 04             	sub    $0x4,%esp
801093f4:	6a 04                	push   $0x4
801093f6:	68 e4 f4 10 80       	push   $0x8010f4e4
801093fb:	50                   	push   %eax
801093fc:	e8 86 b8 ff ff       	call   80104c87 <memmove>
80109401:	83 c4 10             	add    $0x10,%esp
}
80109404:	90                   	nop
80109405:	c9                   	leave
80109406:	c3                   	ret

80109407 <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
80109407:	55                   	push   %ebp
80109408:	89 e5                	mov    %esp,%ebp
8010940a:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
8010940d:	83 ec 0c             	sub    $0xc,%esp
80109410:	68 02 c1 10 80       	push   $0x8010c102
80109415:	e8 da 6f ff ff       	call   801003f4 <cprintf>
8010941a:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
8010941d:	8b 45 08             	mov    0x8(%ebp),%eax
80109420:	83 c0 0e             	add    $0xe,%eax
80109423:	83 ec 0c             	sub    $0xc,%esp
80109426:	50                   	push   %eax
80109427:	e8 e8 00 00 00       	call   80109514 <print_ipv4>
8010942c:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010942f:	83 ec 0c             	sub    $0xc,%esp
80109432:	68 00 c1 10 80       	push   $0x8010c100
80109437:	e8 b8 6f ff ff       	call   801003f4 <cprintf>
8010943c:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
8010943f:	8b 45 08             	mov    0x8(%ebp),%eax
80109442:	83 c0 08             	add    $0x8,%eax
80109445:	83 ec 0c             	sub    $0xc,%esp
80109448:	50                   	push   %eax
80109449:	e8 14 01 00 00       	call   80109562 <print_mac>
8010944e:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109451:	83 ec 0c             	sub    $0xc,%esp
80109454:	68 00 c1 10 80       	push   $0x8010c100
80109459:	e8 96 6f ff ff       	call   801003f4 <cprintf>
8010945e:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
80109461:	83 ec 0c             	sub    $0xc,%esp
80109464:	68 19 c1 10 80       	push   $0x8010c119
80109469:	e8 86 6f ff ff       	call   801003f4 <cprintf>
8010946e:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
80109471:	8b 45 08             	mov    0x8(%ebp),%eax
80109474:	83 c0 18             	add    $0x18,%eax
80109477:	83 ec 0c             	sub    $0xc,%esp
8010947a:	50                   	push   %eax
8010947b:	e8 94 00 00 00       	call   80109514 <print_ipv4>
80109480:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109483:	83 ec 0c             	sub    $0xc,%esp
80109486:	68 00 c1 10 80       	push   $0x8010c100
8010948b:	e8 64 6f ff ff       	call   801003f4 <cprintf>
80109490:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
80109493:	8b 45 08             	mov    0x8(%ebp),%eax
80109496:	83 c0 12             	add    $0x12,%eax
80109499:	83 ec 0c             	sub    $0xc,%esp
8010949c:	50                   	push   %eax
8010949d:	e8 c0 00 00 00       	call   80109562 <print_mac>
801094a2:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801094a5:	83 ec 0c             	sub    $0xc,%esp
801094a8:	68 00 c1 10 80       	push   $0x8010c100
801094ad:	e8 42 6f ff ff       	call   801003f4 <cprintf>
801094b2:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
801094b5:	83 ec 0c             	sub    $0xc,%esp
801094b8:	68 30 c1 10 80       	push   $0x8010c130
801094bd:	e8 32 6f ff ff       	call   801003f4 <cprintf>
801094c2:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
801094c5:	8b 45 08             	mov    0x8(%ebp),%eax
801094c8:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801094cc:	66 3d 00 01          	cmp    $0x100,%ax
801094d0:	75 12                	jne    801094e4 <print_arp_info+0xdd>
801094d2:	83 ec 0c             	sub    $0xc,%esp
801094d5:	68 3c c1 10 80       	push   $0x8010c13c
801094da:	e8 15 6f ff ff       	call   801003f4 <cprintf>
801094df:	83 c4 10             	add    $0x10,%esp
801094e2:	eb 1d                	jmp    80109501 <print_arp_info+0xfa>
  else if(arp_p->op == ARP_OPS_REPLY) {
801094e4:	8b 45 08             	mov    0x8(%ebp),%eax
801094e7:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801094eb:	66 3d 00 02          	cmp    $0x200,%ax
801094ef:	75 10                	jne    80109501 <print_arp_info+0xfa>
    cprintf("Reply\n");
801094f1:	83 ec 0c             	sub    $0xc,%esp
801094f4:	68 45 c1 10 80       	push   $0x8010c145
801094f9:	e8 f6 6e ff ff       	call   801003f4 <cprintf>
801094fe:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
80109501:	83 ec 0c             	sub    $0xc,%esp
80109504:	68 00 c1 10 80       	push   $0x8010c100
80109509:	e8 e6 6e ff ff       	call   801003f4 <cprintf>
8010950e:	83 c4 10             	add    $0x10,%esp
}
80109511:	90                   	nop
80109512:	c9                   	leave
80109513:	c3                   	ret

80109514 <print_ipv4>:

void print_ipv4(uchar *ip){
80109514:	55                   	push   %ebp
80109515:	89 e5                	mov    %esp,%ebp
80109517:	53                   	push   %ebx
80109518:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
8010951b:	8b 45 08             	mov    0x8(%ebp),%eax
8010951e:	83 c0 03             	add    $0x3,%eax
80109521:	0f b6 00             	movzbl (%eax),%eax
80109524:	0f b6 d8             	movzbl %al,%ebx
80109527:	8b 45 08             	mov    0x8(%ebp),%eax
8010952a:	83 c0 02             	add    $0x2,%eax
8010952d:	0f b6 00             	movzbl (%eax),%eax
80109530:	0f b6 c8             	movzbl %al,%ecx
80109533:	8b 45 08             	mov    0x8(%ebp),%eax
80109536:	83 c0 01             	add    $0x1,%eax
80109539:	0f b6 00             	movzbl (%eax),%eax
8010953c:	0f b6 d0             	movzbl %al,%edx
8010953f:	8b 45 08             	mov    0x8(%ebp),%eax
80109542:	0f b6 00             	movzbl (%eax),%eax
80109545:	0f b6 c0             	movzbl %al,%eax
80109548:	83 ec 0c             	sub    $0xc,%esp
8010954b:	53                   	push   %ebx
8010954c:	51                   	push   %ecx
8010954d:	52                   	push   %edx
8010954e:	50                   	push   %eax
8010954f:	68 4c c1 10 80       	push   $0x8010c14c
80109554:	e8 9b 6e ff ff       	call   801003f4 <cprintf>
80109559:	83 c4 20             	add    $0x20,%esp
}
8010955c:	90                   	nop
8010955d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109560:	c9                   	leave
80109561:	c3                   	ret

80109562 <print_mac>:

void print_mac(uchar *mac){
80109562:	55                   	push   %ebp
80109563:	89 e5                	mov    %esp,%ebp
80109565:	57                   	push   %edi
80109566:	56                   	push   %esi
80109567:	53                   	push   %ebx
80109568:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
8010956b:	8b 45 08             	mov    0x8(%ebp),%eax
8010956e:	83 c0 05             	add    $0x5,%eax
80109571:	0f b6 00             	movzbl (%eax),%eax
80109574:	0f b6 f8             	movzbl %al,%edi
80109577:	8b 45 08             	mov    0x8(%ebp),%eax
8010957a:	83 c0 04             	add    $0x4,%eax
8010957d:	0f b6 00             	movzbl (%eax),%eax
80109580:	0f b6 f0             	movzbl %al,%esi
80109583:	8b 45 08             	mov    0x8(%ebp),%eax
80109586:	83 c0 03             	add    $0x3,%eax
80109589:	0f b6 00             	movzbl (%eax),%eax
8010958c:	0f b6 d8             	movzbl %al,%ebx
8010958f:	8b 45 08             	mov    0x8(%ebp),%eax
80109592:	83 c0 02             	add    $0x2,%eax
80109595:	0f b6 00             	movzbl (%eax),%eax
80109598:	0f b6 c8             	movzbl %al,%ecx
8010959b:	8b 45 08             	mov    0x8(%ebp),%eax
8010959e:	83 c0 01             	add    $0x1,%eax
801095a1:	0f b6 00             	movzbl (%eax),%eax
801095a4:	0f b6 d0             	movzbl %al,%edx
801095a7:	8b 45 08             	mov    0x8(%ebp),%eax
801095aa:	0f b6 00             	movzbl (%eax),%eax
801095ad:	0f b6 c0             	movzbl %al,%eax
801095b0:	83 ec 04             	sub    $0x4,%esp
801095b3:	57                   	push   %edi
801095b4:	56                   	push   %esi
801095b5:	53                   	push   %ebx
801095b6:	51                   	push   %ecx
801095b7:	52                   	push   %edx
801095b8:	50                   	push   %eax
801095b9:	68 64 c1 10 80       	push   $0x8010c164
801095be:	e8 31 6e ff ff       	call   801003f4 <cprintf>
801095c3:	83 c4 20             	add    $0x20,%esp
}
801095c6:	90                   	nop
801095c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801095ca:	5b                   	pop    %ebx
801095cb:	5e                   	pop    %esi
801095cc:	5f                   	pop    %edi
801095cd:	5d                   	pop    %ebp
801095ce:	c3                   	ret

801095cf <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
801095cf:	55                   	push   %ebp
801095d0:	89 e5                	mov    %esp,%ebp
801095d2:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
801095d5:	8b 45 08             	mov    0x8(%ebp),%eax
801095d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
801095db:	8b 45 08             	mov    0x8(%ebp),%eax
801095de:	83 c0 0e             	add    $0xe,%eax
801095e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
801095e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095e7:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801095eb:	3c 08                	cmp    $0x8,%al
801095ed:	75 1b                	jne    8010960a <eth_proc+0x3b>
801095ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f2:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
801095f6:	3c 06                	cmp    $0x6,%al
801095f8:	75 10                	jne    8010960a <eth_proc+0x3b>
    arp_proc(pkt_addr);
801095fa:	83 ec 0c             	sub    $0xc,%esp
801095fd:	ff 75 f0             	push   -0x10(%ebp)
80109600:	e8 01 f8 ff ff       	call   80108e06 <arp_proc>
80109605:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
80109608:	eb 24                	jmp    8010962e <eth_proc+0x5f>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
8010960a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010960d:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80109611:	3c 08                	cmp    $0x8,%al
80109613:	75 19                	jne    8010962e <eth_proc+0x5f>
80109615:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109618:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
8010961c:	84 c0                	test   %al,%al
8010961e:	75 0e                	jne    8010962e <eth_proc+0x5f>
    ipv4_proc(buffer_addr);
80109620:	83 ec 0c             	sub    $0xc,%esp
80109623:	ff 75 08             	push   0x8(%ebp)
80109626:	e8 8d 00 00 00       	call   801096b8 <ipv4_proc>
8010962b:	83 c4 10             	add    $0x10,%esp
}
8010962e:	90                   	nop
8010962f:	c9                   	leave
80109630:	c3                   	ret

80109631 <N2H_ushort>:

ushort N2H_ushort(ushort value){
80109631:	55                   	push   %ebp
80109632:	89 e5                	mov    %esp,%ebp
80109634:	83 ec 04             	sub    $0x4,%esp
80109637:	8b 45 08             	mov    0x8(%ebp),%eax
8010963a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
8010963e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109642:	66 c1 c0 08          	rol    $0x8,%ax
}
80109646:	c9                   	leave
80109647:	c3                   	ret

80109648 <H2N_ushort>:

ushort H2N_ushort(ushort value){
80109648:	55                   	push   %ebp
80109649:	89 e5                	mov    %esp,%ebp
8010964b:	83 ec 04             	sub    $0x4,%esp
8010964e:	8b 45 08             	mov    0x8(%ebp),%eax
80109651:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
80109655:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109659:	66 c1 c0 08          	rol    $0x8,%ax
}
8010965d:	c9                   	leave
8010965e:	c3                   	ret

8010965f <H2N_uint>:

uint H2N_uint(uint value){
8010965f:	55                   	push   %ebp
80109660:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
80109662:	8b 45 08             	mov    0x8(%ebp),%eax
80109665:	c1 e0 18             	shl    $0x18,%eax
80109668:	25 00 00 00 0f       	and    $0xf000000,%eax
8010966d:	89 c2                	mov    %eax,%edx
8010966f:	8b 45 08             	mov    0x8(%ebp),%eax
80109672:	c1 e0 08             	shl    $0x8,%eax
80109675:	25 00 f0 00 00       	and    $0xf000,%eax
8010967a:	09 c2                	or     %eax,%edx
8010967c:	8b 45 08             	mov    0x8(%ebp),%eax
8010967f:	c1 e8 08             	shr    $0x8,%eax
80109682:	83 e0 0f             	and    $0xf,%eax
80109685:	01 d0                	add    %edx,%eax
}
80109687:	5d                   	pop    %ebp
80109688:	c3                   	ret

80109689 <N2H_uint>:

uint N2H_uint(uint value){
80109689:	55                   	push   %ebp
8010968a:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
8010968c:	8b 45 08             	mov    0x8(%ebp),%eax
8010968f:	c1 e0 18             	shl    $0x18,%eax
80109692:	89 c2                	mov    %eax,%edx
80109694:	8b 45 08             	mov    0x8(%ebp),%eax
80109697:	c1 e0 08             	shl    $0x8,%eax
8010969a:	25 00 00 ff 00       	and    $0xff0000,%eax
8010969f:	01 c2                	add    %eax,%edx
801096a1:	8b 45 08             	mov    0x8(%ebp),%eax
801096a4:	c1 e8 08             	shr    $0x8,%eax
801096a7:	25 00 ff 00 00       	and    $0xff00,%eax
801096ac:	01 c2                	add    %eax,%edx
801096ae:	8b 45 08             	mov    0x8(%ebp),%eax
801096b1:	c1 e8 18             	shr    $0x18,%eax
801096b4:	01 d0                	add    %edx,%eax
}
801096b6:	5d                   	pop    %ebp
801096b7:	c3                   	ret

801096b8 <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
801096b8:	55                   	push   %ebp
801096b9:	89 e5                	mov    %esp,%ebp
801096bb:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
801096be:	8b 45 08             	mov    0x8(%ebp),%eax
801096c1:	83 c0 0e             	add    $0xe,%eax
801096c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
801096c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096ca:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801096ce:	0f b7 d0             	movzwl %ax,%edx
801096d1:	a1 e8 f4 10 80       	mov    0x8010f4e8,%eax
801096d6:	39 c2                	cmp    %eax,%edx
801096d8:	74 60                	je     8010973a <ipv4_proc+0x82>
801096da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096dd:	83 c0 0c             	add    $0xc,%eax
801096e0:	83 ec 04             	sub    $0x4,%esp
801096e3:	6a 04                	push   $0x4
801096e5:	50                   	push   %eax
801096e6:	68 e4 f4 10 80       	push   $0x8010f4e4
801096eb:	e8 3f b5 ff ff       	call   80104c2f <memcmp>
801096f0:	83 c4 10             	add    $0x10,%esp
801096f3:	85 c0                	test   %eax,%eax
801096f5:	74 43                	je     8010973a <ipv4_proc+0x82>
    ip_id = ipv4_p->id;
801096f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096fa:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801096fe:	0f b7 c0             	movzwl %ax,%eax
80109701:	a3 e8 f4 10 80       	mov    %eax,0x8010f4e8
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
80109706:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109709:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010970d:	3c 01                	cmp    $0x1,%al
8010970f:	75 10                	jne    80109721 <ipv4_proc+0x69>
        icmp_proc(buffer_addr);
80109711:	83 ec 0c             	sub    $0xc,%esp
80109714:	ff 75 08             	push   0x8(%ebp)
80109717:	e8 a3 00 00 00       	call   801097bf <icmp_proc>
8010971c:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
8010971f:	eb 19                	jmp    8010973a <ipv4_proc+0x82>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
80109721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109724:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80109728:	3c 06                	cmp    $0x6,%al
8010972a:	75 0e                	jne    8010973a <ipv4_proc+0x82>
        tcp_proc(buffer_addr);
8010972c:	83 ec 0c             	sub    $0xc,%esp
8010972f:	ff 75 08             	push   0x8(%ebp)
80109732:	e8 b3 03 00 00       	call   80109aea <tcp_proc>
80109737:	83 c4 10             	add    $0x10,%esp
}
8010973a:	90                   	nop
8010973b:	c9                   	leave
8010973c:	c3                   	ret

8010973d <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
8010973d:	55                   	push   %ebp
8010973e:	89 e5                	mov    %esp,%ebp
80109740:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
80109743:	8b 45 08             	mov    0x8(%ebp),%eax
80109746:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
80109749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010974c:	0f b6 00             	movzbl (%eax),%eax
8010974f:	83 e0 0f             	and    $0xf,%eax
80109752:	01 c0                	add    %eax,%eax
80109754:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
80109757:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
8010975e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109765:	eb 48                	jmp    801097af <ipv4_chksum+0x72>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109767:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010976a:	01 c0                	add    %eax,%eax
8010976c:	89 c2                	mov    %eax,%edx
8010976e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109771:	01 d0                	add    %edx,%eax
80109773:	0f b6 00             	movzbl (%eax),%eax
80109776:	0f b6 c0             	movzbl %al,%eax
80109779:	c1 e0 08             	shl    $0x8,%eax
8010977c:	89 c2                	mov    %eax,%edx
8010977e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109781:	01 c0                	add    %eax,%eax
80109783:	8d 48 01             	lea    0x1(%eax),%ecx
80109786:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109789:	01 c8                	add    %ecx,%eax
8010978b:	0f b6 00             	movzbl (%eax),%eax
8010978e:	0f b6 c0             	movzbl %al,%eax
80109791:	01 d0                	add    %edx,%eax
80109793:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109796:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
8010979d:	76 0c                	jbe    801097ab <ipv4_chksum+0x6e>
      chk_sum = (chk_sum&0xFFFF)+1;
8010979f:	8b 45 fc             	mov    -0x4(%ebp),%eax
801097a2:	0f b7 c0             	movzwl %ax,%eax
801097a5:	83 c0 01             	add    $0x1,%eax
801097a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
801097ab:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801097af:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
801097b3:	39 45 f8             	cmp    %eax,-0x8(%ebp)
801097b6:	7c af                	jl     80109767 <ipv4_chksum+0x2a>
    }
  }
  return ~(chk_sum);
801097b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801097bb:	f7 d0                	not    %eax
}
801097bd:	c9                   	leave
801097be:	c3                   	ret

801097bf <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
801097bf:	55                   	push   %ebp
801097c0:	89 e5                	mov    %esp,%ebp
801097c2:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
801097c5:	8b 45 08             	mov    0x8(%ebp),%eax
801097c8:	83 c0 0e             	add    $0xe,%eax
801097cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
801097ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097d1:	0f b6 00             	movzbl (%eax),%eax
801097d4:	0f b6 c0             	movzbl %al,%eax
801097d7:	83 e0 0f             	and    $0xf,%eax
801097da:	c1 e0 02             	shl    $0x2,%eax
801097dd:	89 c2                	mov    %eax,%edx
801097df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097e2:	01 d0                	add    %edx,%eax
801097e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
801097e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097ea:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801097ee:	84 c0                	test   %al,%al
801097f0:	75 4f                	jne    80109841 <icmp_proc+0x82>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
801097f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097f5:	0f b6 00             	movzbl (%eax),%eax
801097f8:	3c 08                	cmp    $0x8,%al
801097fa:	75 45                	jne    80109841 <icmp_proc+0x82>
      uint send_addr = (uint)kalloc();
801097fc:	e8 a7 8f ff ff       	call   801027a8 <kalloc>
80109801:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
80109804:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
8010980b:	83 ec 04             	sub    $0x4,%esp
8010980e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80109811:	50                   	push   %eax
80109812:	ff 75 ec             	push   -0x14(%ebp)
80109815:	ff 75 08             	push   0x8(%ebp)
80109818:	e8 78 00 00 00       	call   80109895 <icmp_reply_pkt_create>
8010981d:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
80109820:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109823:	83 ec 08             	sub    $0x8,%esp
80109826:	50                   	push   %eax
80109827:	ff 75 ec             	push   -0x14(%ebp)
8010982a:	e8 ad f4 ff ff       	call   80108cdc <i8254_send>
8010982f:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
80109832:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109835:	83 ec 0c             	sub    $0xc,%esp
80109838:	50                   	push   %eax
80109839:	e8 d0 8e ff ff       	call   8010270e <kfree>
8010983e:	83 c4 10             	add    $0x10,%esp
    }
  }
}
80109841:	90                   	nop
80109842:	c9                   	leave
80109843:	c3                   	ret

80109844 <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
80109844:	55                   	push   %ebp
80109845:	89 e5                	mov    %esp,%ebp
80109847:	53                   	push   %ebx
80109848:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
8010984b:	8b 45 08             	mov    0x8(%ebp),%eax
8010984e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109852:	0f b7 c0             	movzwl %ax,%eax
80109855:	83 ec 0c             	sub    $0xc,%esp
80109858:	50                   	push   %eax
80109859:	e8 d3 fd ff ff       	call   80109631 <N2H_ushort>
8010985e:	83 c4 10             	add    $0x10,%esp
80109861:	0f b7 d8             	movzwl %ax,%ebx
80109864:	8b 45 08             	mov    0x8(%ebp),%eax
80109867:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010986b:	0f b7 c0             	movzwl %ax,%eax
8010986e:	83 ec 0c             	sub    $0xc,%esp
80109871:	50                   	push   %eax
80109872:	e8 ba fd ff ff       	call   80109631 <N2H_ushort>
80109877:	83 c4 10             	add    $0x10,%esp
8010987a:	0f b7 c0             	movzwl %ax,%eax
8010987d:	83 ec 04             	sub    $0x4,%esp
80109880:	53                   	push   %ebx
80109881:	50                   	push   %eax
80109882:	68 83 c1 10 80       	push   $0x8010c183
80109887:	e8 68 6b ff ff       	call   801003f4 <cprintf>
8010988c:	83 c4 10             	add    $0x10,%esp
}
8010988f:	90                   	nop
80109890:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109893:	c9                   	leave
80109894:	c3                   	ret

80109895 <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
80109895:	55                   	push   %ebp
80109896:	89 e5                	mov    %esp,%ebp
80109898:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
8010989b:	8b 45 08             	mov    0x8(%ebp),%eax
8010989e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
801098a1:	8b 45 08             	mov    0x8(%ebp),%eax
801098a4:	83 c0 0e             	add    $0xe,%eax
801098a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
801098aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098ad:	0f b6 00             	movzbl (%eax),%eax
801098b0:	0f b6 c0             	movzbl %al,%eax
801098b3:	83 e0 0f             	and    $0xf,%eax
801098b6:	c1 e0 02             	shl    $0x2,%eax
801098b9:	89 c2                	mov    %eax,%edx
801098bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098be:	01 d0                	add    %edx,%eax
801098c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
801098c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801098c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
801098c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801098cc:	83 c0 0e             	add    $0xe,%eax
801098cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
801098d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801098d5:	83 c0 14             	add    $0x14,%eax
801098d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
801098db:	8b 45 10             	mov    0x10(%ebp),%eax
801098de:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
801098e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098e7:	8d 50 06             	lea    0x6(%eax),%edx
801098ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
801098ed:	83 ec 04             	sub    $0x4,%esp
801098f0:	6a 06                	push   $0x6
801098f2:	52                   	push   %edx
801098f3:	50                   	push   %eax
801098f4:	e8 8e b3 ff ff       	call   80104c87 <memmove>
801098f9:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
801098fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801098ff:	83 c0 06             	add    $0x6,%eax
80109902:	83 ec 04             	sub    $0x4,%esp
80109905:	6a 06                	push   $0x6
80109907:	68 80 6d 19 80       	push   $0x80196d80
8010990c:	50                   	push   %eax
8010990d:	e8 75 b3 ff ff       	call   80104c87 <memmove>
80109912:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109915:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109918:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
8010991c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010991f:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109926:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109929:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010992c:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
80109930:	83 ec 0c             	sub    $0xc,%esp
80109933:	6a 54                	push   $0x54
80109935:	e8 0e fd ff ff       	call   80109648 <H2N_ushort>
8010993a:	83 c4 10             	add    $0x10,%esp
8010993d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109940:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109944:	0f b7 15 60 70 19 80 	movzwl 0x80197060,%edx
8010994b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010994e:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109952:	0f b7 05 60 70 19 80 	movzwl 0x80197060,%eax
80109959:	83 c0 01             	add    $0x1,%eax
8010995c:	66 a3 60 70 19 80    	mov    %ax,0x80197060
  ipv4_send->fragment = H2N_ushort(0x4000);
80109962:	83 ec 0c             	sub    $0xc,%esp
80109965:	68 00 40 00 00       	push   $0x4000
8010996a:	e8 d9 fc ff ff       	call   80109648 <H2N_ushort>
8010996f:	83 c4 10             	add    $0x10,%esp
80109972:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109975:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010997c:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
80109980:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109983:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010998a:	83 c0 0c             	add    $0xc,%eax
8010998d:	83 ec 04             	sub    $0x4,%esp
80109990:	6a 04                	push   $0x4
80109992:	68 e4 f4 10 80       	push   $0x8010f4e4
80109997:	50                   	push   %eax
80109998:	e8 ea b2 ff ff       	call   80104c87 <memmove>
8010999d:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
801099a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099a3:	8d 50 0c             	lea    0xc(%eax),%edx
801099a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099a9:	83 c0 10             	add    $0x10,%eax
801099ac:	83 ec 04             	sub    $0x4,%esp
801099af:	6a 04                	push   $0x4
801099b1:	52                   	push   %edx
801099b2:	50                   	push   %eax
801099b3:	e8 cf b2 ff ff       	call   80104c87 <memmove>
801099b8:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
801099bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099be:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
801099c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099c7:	83 ec 0c             	sub    $0xc,%esp
801099ca:	50                   	push   %eax
801099cb:	e8 6d fd ff ff       	call   8010973d <ipv4_chksum>
801099d0:	83 c4 10             	add    $0x10,%esp
801099d3:	0f b7 c0             	movzwl %ax,%eax
801099d6:	83 ec 0c             	sub    $0xc,%esp
801099d9:	50                   	push   %eax
801099da:	e8 69 fc ff ff       	call   80109648 <H2N_ushort>
801099df:	83 c4 10             	add    $0x10,%esp
801099e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801099e5:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
801099e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801099ec:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
801099ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
801099f2:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
801099f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801099f9:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801099fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a00:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
80109a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a07:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80109a0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a0e:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
80109a12:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a15:	8d 50 08             	lea    0x8(%eax),%edx
80109a18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a1b:	83 c0 08             	add    $0x8,%eax
80109a1e:	83 ec 04             	sub    $0x4,%esp
80109a21:	6a 08                	push   $0x8
80109a23:	52                   	push   %edx
80109a24:	50                   	push   %eax
80109a25:	e8 5d b2 ff ff       	call   80104c87 <memmove>
80109a2a:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
80109a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a30:	8d 50 10             	lea    0x10(%eax),%edx
80109a33:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a36:	83 c0 10             	add    $0x10,%eax
80109a39:	83 ec 04             	sub    $0x4,%esp
80109a3c:	6a 30                	push   $0x30
80109a3e:	52                   	push   %edx
80109a3f:	50                   	push   %eax
80109a40:	e8 42 b2 ff ff       	call   80104c87 <memmove>
80109a45:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
80109a48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a4b:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
80109a51:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109a54:	83 ec 0c             	sub    $0xc,%esp
80109a57:	50                   	push   %eax
80109a58:	e8 1c 00 00 00       	call   80109a79 <icmp_chksum>
80109a5d:	83 c4 10             	add    $0x10,%esp
80109a60:	0f b7 c0             	movzwl %ax,%eax
80109a63:	83 ec 0c             	sub    $0xc,%esp
80109a66:	50                   	push   %eax
80109a67:	e8 dc fb ff ff       	call   80109648 <H2N_ushort>
80109a6c:	83 c4 10             	add    $0x10,%esp
80109a6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109a72:	66 89 42 02          	mov    %ax,0x2(%edx)
}
80109a76:	90                   	nop
80109a77:	c9                   	leave
80109a78:	c3                   	ret

80109a79 <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
80109a79:	55                   	push   %ebp
80109a7a:	89 e5                	mov    %esp,%ebp
80109a7c:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
80109a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80109a82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
80109a85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109a8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109a93:	eb 48                	jmp    80109add <icmp_chksum+0x64>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109a95:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109a98:	01 c0                	add    %eax,%eax
80109a9a:	89 c2                	mov    %eax,%edx
80109a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a9f:	01 d0                	add    %edx,%eax
80109aa1:	0f b6 00             	movzbl (%eax),%eax
80109aa4:	0f b6 c0             	movzbl %al,%eax
80109aa7:	c1 e0 08             	shl    $0x8,%eax
80109aaa:	89 c2                	mov    %eax,%edx
80109aac:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109aaf:	01 c0                	add    %eax,%eax
80109ab1:	8d 48 01             	lea    0x1(%eax),%ecx
80109ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ab7:	01 c8                	add    %ecx,%eax
80109ab9:	0f b6 00             	movzbl (%eax),%eax
80109abc:	0f b6 c0             	movzbl %al,%eax
80109abf:	01 d0                	add    %edx,%eax
80109ac1:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109ac4:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109acb:	76 0c                	jbe    80109ad9 <icmp_chksum+0x60>
      chk_sum = (chk_sum&0xFFFF)+1;
80109acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109ad0:	0f b7 c0             	movzwl %ax,%eax
80109ad3:	83 c0 01             	add    $0x1,%eax
80109ad6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109ad9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109add:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
80109ae1:	7e b2                	jle    80109a95 <icmp_chksum+0x1c>
    }
  }
  return ~(chk_sum);
80109ae3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109ae6:	f7 d0                	not    %eax
}
80109ae8:	c9                   	leave
80109ae9:	c3                   	ret

80109aea <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
80109aea:	55                   	push   %ebp
80109aeb:	89 e5                	mov    %esp,%ebp
80109aed:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
80109af0:	8b 45 08             	mov    0x8(%ebp),%eax
80109af3:	83 c0 0e             	add    $0xe,%eax
80109af6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109afc:	0f b6 00             	movzbl (%eax),%eax
80109aff:	0f b6 c0             	movzbl %al,%eax
80109b02:	83 e0 0f             	and    $0xf,%eax
80109b05:	c1 e0 02             	shl    $0x2,%eax
80109b08:	89 c2                	mov    %eax,%edx
80109b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b0d:	01 d0                	add    %edx,%eax
80109b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
80109b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b15:	83 c0 14             	add    $0x14,%eax
80109b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
80109b1b:	e8 88 8c ff ff       	call   801027a8 <kalloc>
80109b20:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
80109b23:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
80109b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b2d:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109b31:	0f b6 c0             	movzbl %al,%eax
80109b34:	83 e0 02             	and    $0x2,%eax
80109b37:	85 c0                	test   %eax,%eax
80109b39:	74 3d                	je     80109b78 <tcp_proc+0x8e>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
80109b3b:	83 ec 0c             	sub    $0xc,%esp
80109b3e:	6a 00                	push   $0x0
80109b40:	6a 12                	push   $0x12
80109b42:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109b45:	50                   	push   %eax
80109b46:	ff 75 e8             	push   -0x18(%ebp)
80109b49:	ff 75 08             	push   0x8(%ebp)
80109b4c:	e8 a2 01 00 00       	call   80109cf3 <tcp_pkt_create>
80109b51:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
80109b54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109b57:	83 ec 08             	sub    $0x8,%esp
80109b5a:	50                   	push   %eax
80109b5b:	ff 75 e8             	push   -0x18(%ebp)
80109b5e:	e8 79 f1 ff ff       	call   80108cdc <i8254_send>
80109b63:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109b66:	a1 64 70 19 80       	mov    0x80197064,%eax
80109b6b:	83 c0 01             	add    $0x1,%eax
80109b6e:	a3 64 70 19 80       	mov    %eax,0x80197064
80109b73:	e9 69 01 00 00       	jmp    80109ce1 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
80109b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109b7b:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109b7f:	3c 18                	cmp    $0x18,%al
80109b81:	0f 85 10 01 00 00    	jne    80109c97 <tcp_proc+0x1ad>
    if(memcmp(payload,"GET",3)){
80109b87:	83 ec 04             	sub    $0x4,%esp
80109b8a:	6a 03                	push   $0x3
80109b8c:	68 9e c1 10 80       	push   $0x8010c19e
80109b91:	ff 75 ec             	push   -0x14(%ebp)
80109b94:	e8 96 b0 ff ff       	call   80104c2f <memcmp>
80109b99:	83 c4 10             	add    $0x10,%esp
80109b9c:	85 c0                	test   %eax,%eax
80109b9e:	74 74                	je     80109c14 <tcp_proc+0x12a>
      cprintf("ACK PSH\n");
80109ba0:	83 ec 0c             	sub    $0xc,%esp
80109ba3:	68 a2 c1 10 80       	push   $0x8010c1a2
80109ba8:	e8 47 68 ff ff       	call   801003f4 <cprintf>
80109bad:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109bb0:	83 ec 0c             	sub    $0xc,%esp
80109bb3:	6a 00                	push   $0x0
80109bb5:	6a 10                	push   $0x10
80109bb7:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109bba:	50                   	push   %eax
80109bbb:	ff 75 e8             	push   -0x18(%ebp)
80109bbe:	ff 75 08             	push   0x8(%ebp)
80109bc1:	e8 2d 01 00 00       	call   80109cf3 <tcp_pkt_create>
80109bc6:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109bc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109bcc:	83 ec 08             	sub    $0x8,%esp
80109bcf:	50                   	push   %eax
80109bd0:	ff 75 e8             	push   -0x18(%ebp)
80109bd3:	e8 04 f1 ff ff       	call   80108cdc <i8254_send>
80109bd8:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109bdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109bde:	83 c0 36             	add    $0x36,%eax
80109be1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109be4:	8d 45 d8             	lea    -0x28(%ebp),%eax
80109be7:	50                   	push   %eax
80109be8:	ff 75 e0             	push   -0x20(%ebp)
80109beb:	6a 00                	push   $0x0
80109bed:	6a 00                	push   $0x0
80109bef:	e8 5a 04 00 00       	call   8010a04e <http_proc>
80109bf4:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109bf7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109bfa:	83 ec 0c             	sub    $0xc,%esp
80109bfd:	50                   	push   %eax
80109bfe:	6a 18                	push   $0x18
80109c00:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c03:	50                   	push   %eax
80109c04:	ff 75 e8             	push   -0x18(%ebp)
80109c07:	ff 75 08             	push   0x8(%ebp)
80109c0a:	e8 e4 00 00 00       	call   80109cf3 <tcp_pkt_create>
80109c0f:	83 c4 20             	add    $0x20,%esp
80109c12:	eb 62                	jmp    80109c76 <tcp_proc+0x18c>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109c14:	83 ec 0c             	sub    $0xc,%esp
80109c17:	6a 00                	push   $0x0
80109c19:	6a 10                	push   $0x10
80109c1b:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c1e:	50                   	push   %eax
80109c1f:	ff 75 e8             	push   -0x18(%ebp)
80109c22:	ff 75 08             	push   0x8(%ebp)
80109c25:	e8 c9 00 00 00       	call   80109cf3 <tcp_pkt_create>
80109c2a:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
80109c2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109c30:	83 ec 08             	sub    $0x8,%esp
80109c33:	50                   	push   %eax
80109c34:	ff 75 e8             	push   -0x18(%ebp)
80109c37:	e8 a0 f0 ff ff       	call   80108cdc <i8254_send>
80109c3c:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c42:	83 c0 36             	add    $0x36,%eax
80109c45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109c48:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109c4b:	50                   	push   %eax
80109c4c:	ff 75 e4             	push   -0x1c(%ebp)
80109c4f:	6a 00                	push   $0x0
80109c51:	6a 00                	push   $0x0
80109c53:	e8 f6 03 00 00       	call   8010a04e <http_proc>
80109c58:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109c5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109c5e:	83 ec 0c             	sub    $0xc,%esp
80109c61:	50                   	push   %eax
80109c62:	6a 18                	push   $0x18
80109c64:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c67:	50                   	push   %eax
80109c68:	ff 75 e8             	push   -0x18(%ebp)
80109c6b:	ff 75 08             	push   0x8(%ebp)
80109c6e:	e8 80 00 00 00       	call   80109cf3 <tcp_pkt_create>
80109c73:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
80109c76:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109c79:	83 ec 08             	sub    $0x8,%esp
80109c7c:	50                   	push   %eax
80109c7d:	ff 75 e8             	push   -0x18(%ebp)
80109c80:	e8 57 f0 ff ff       	call   80108cdc <i8254_send>
80109c85:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109c88:	a1 64 70 19 80       	mov    0x80197064,%eax
80109c8d:	83 c0 01             	add    $0x1,%eax
80109c90:	a3 64 70 19 80       	mov    %eax,0x80197064
80109c95:	eb 4a                	jmp    80109ce1 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
80109c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c9a:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109c9e:	3c 10                	cmp    $0x10,%al
80109ca0:	75 3f                	jne    80109ce1 <tcp_proc+0x1f7>
    if(fin_flag == 1){
80109ca2:	a1 68 70 19 80       	mov    0x80197068,%eax
80109ca7:	83 f8 01             	cmp    $0x1,%eax
80109caa:	75 35                	jne    80109ce1 <tcp_proc+0x1f7>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
80109cac:	83 ec 0c             	sub    $0xc,%esp
80109caf:	6a 00                	push   $0x0
80109cb1:	6a 01                	push   $0x1
80109cb3:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109cb6:	50                   	push   %eax
80109cb7:	ff 75 e8             	push   -0x18(%ebp)
80109cba:	ff 75 08             	push   0x8(%ebp)
80109cbd:	e8 31 00 00 00       	call   80109cf3 <tcp_pkt_create>
80109cc2:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109cc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109cc8:	83 ec 08             	sub    $0x8,%esp
80109ccb:	50                   	push   %eax
80109ccc:	ff 75 e8             	push   -0x18(%ebp)
80109ccf:	e8 08 f0 ff ff       	call   80108cdc <i8254_send>
80109cd4:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
80109cd7:	c7 05 68 70 19 80 00 	movl   $0x0,0x80197068
80109cde:	00 00 00 
    }
  }
  kfree((char *)send_addr);
80109ce1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ce4:	83 ec 0c             	sub    $0xc,%esp
80109ce7:	50                   	push   %eax
80109ce8:	e8 21 8a ff ff       	call   8010270e <kfree>
80109ced:	83 c4 10             	add    $0x10,%esp
}
80109cf0:	90                   	nop
80109cf1:	c9                   	leave
80109cf2:	c3                   	ret

80109cf3 <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
80109cf3:	55                   	push   %ebp
80109cf4:	89 e5                	mov    %esp,%ebp
80109cf6:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109cf9:	8b 45 08             	mov    0x8(%ebp),%eax
80109cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109cff:	8b 45 08             	mov    0x8(%ebp),%eax
80109d02:	83 c0 0e             	add    $0xe,%eax
80109d05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
80109d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d0b:	0f b6 00             	movzbl (%eax),%eax
80109d0e:	0f b6 c0             	movzbl %al,%eax
80109d11:	83 e0 0f             	and    $0xf,%eax
80109d14:	c1 e0 02             	shl    $0x2,%eax
80109d17:	89 c2                	mov    %eax,%edx
80109d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d1c:	01 d0                	add    %edx,%eax
80109d1e:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109d21:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d24:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
80109d27:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d2a:	83 c0 0e             	add    $0xe,%eax
80109d2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
80109d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d33:	83 c0 14             	add    $0x14,%eax
80109d36:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
80109d39:	8b 45 18             	mov    0x18(%ebp),%eax
80109d3c:	8d 50 36             	lea    0x36(%eax),%edx
80109d3f:	8b 45 10             	mov    0x10(%ebp),%eax
80109d42:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d47:	8d 50 06             	lea    0x6(%eax),%edx
80109d4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d4d:	83 ec 04             	sub    $0x4,%esp
80109d50:	6a 06                	push   $0x6
80109d52:	52                   	push   %edx
80109d53:	50                   	push   %eax
80109d54:	e8 2e af ff ff       	call   80104c87 <memmove>
80109d59:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109d5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d5f:	83 c0 06             	add    $0x6,%eax
80109d62:	83 ec 04             	sub    $0x4,%esp
80109d65:	6a 06                	push   $0x6
80109d67:	68 80 6d 19 80       	push   $0x80196d80
80109d6c:	50                   	push   %eax
80109d6d:	e8 15 af ff ff       	call   80104c87 <memmove>
80109d72:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109d75:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d78:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d7f:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d86:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109d89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109d8c:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
80109d90:	8b 45 18             	mov    0x18(%ebp),%eax
80109d93:	83 c0 28             	add    $0x28,%eax
80109d96:	0f b7 c0             	movzwl %ax,%eax
80109d99:	83 ec 0c             	sub    $0xc,%esp
80109d9c:	50                   	push   %eax
80109d9d:	e8 a6 f8 ff ff       	call   80109648 <H2N_ushort>
80109da2:	83 c4 10             	add    $0x10,%esp
80109da5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109da8:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109dac:	0f b7 15 60 70 19 80 	movzwl 0x80197060,%edx
80109db3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109db6:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109dba:	0f b7 05 60 70 19 80 	movzwl 0x80197060,%eax
80109dc1:	83 c0 01             	add    $0x1,%eax
80109dc4:	66 a3 60 70 19 80    	mov    %ax,0x80197060
  ipv4_send->fragment = H2N_ushort(0x0000);
80109dca:	83 ec 0c             	sub    $0xc,%esp
80109dcd:	6a 00                	push   $0x0
80109dcf:	e8 74 f8 ff ff       	call   80109648 <H2N_ushort>
80109dd4:	83 c4 10             	add    $0x10,%esp
80109dd7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109dda:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109dde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109de1:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
80109de5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109de8:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109dec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109def:	83 c0 0c             	add    $0xc,%eax
80109df2:	83 ec 04             	sub    $0x4,%esp
80109df5:	6a 04                	push   $0x4
80109df7:	68 e4 f4 10 80       	push   $0x8010f4e4
80109dfc:	50                   	push   %eax
80109dfd:	e8 85 ae ff ff       	call   80104c87 <memmove>
80109e02:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e08:	8d 50 0c             	lea    0xc(%eax),%edx
80109e0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e0e:	83 c0 10             	add    $0x10,%eax
80109e11:	83 ec 04             	sub    $0x4,%esp
80109e14:	6a 04                	push   $0x4
80109e16:	52                   	push   %edx
80109e17:	50                   	push   %eax
80109e18:	e8 6a ae ff ff       	call   80104c87 <memmove>
80109e1d:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e23:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109e29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e2c:	83 ec 0c             	sub    $0xc,%esp
80109e2f:	50                   	push   %eax
80109e30:	e8 08 f9 ff ff       	call   8010973d <ipv4_chksum>
80109e35:	83 c4 10             	add    $0x10,%esp
80109e38:	0f b7 c0             	movzwl %ax,%eax
80109e3b:	83 ec 0c             	sub    $0xc,%esp
80109e3e:	50                   	push   %eax
80109e3f:	e8 04 f8 ff ff       	call   80109648 <H2N_ushort>
80109e44:	83 c4 10             	add    $0x10,%esp
80109e47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e4a:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
80109e4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109e51:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80109e55:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e58:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
80109e5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109e5e:	0f b7 10             	movzwl (%eax),%edx
80109e61:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e64:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
80109e68:	a1 64 70 19 80       	mov    0x80197064,%eax
80109e6d:	83 ec 0c             	sub    $0xc,%esp
80109e70:	50                   	push   %eax
80109e71:	e8 e9 f7 ff ff       	call   8010965f <H2N_uint>
80109e76:	83 c4 10             	add    $0x10,%esp
80109e79:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109e7c:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
80109e7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109e82:	8b 40 04             	mov    0x4(%eax),%eax
80109e85:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
80109e8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e8e:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
80109e91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e94:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
80109e98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109e9b:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
80109e9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ea2:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
80109ea6:	8b 45 14             	mov    0x14(%ebp),%eax
80109ea9:	89 c2                	mov    %eax,%edx
80109eab:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109eae:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
80109eb1:	83 ec 0c             	sub    $0xc,%esp
80109eb4:	68 90 38 00 00       	push   $0x3890
80109eb9:	e8 8a f7 ff ff       	call   80109648 <H2N_ushort>
80109ebe:	83 c4 10             	add    $0x10,%esp
80109ec1:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109ec4:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
80109ec8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ecb:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
80109ed1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ed4:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
80109eda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109edd:	83 ec 0c             	sub    $0xc,%esp
80109ee0:	50                   	push   %eax
80109ee1:	e8 1f 00 00 00       	call   80109f05 <tcp_chksum>
80109ee6:	83 c4 10             	add    $0x10,%esp
80109ee9:	83 c0 08             	add    $0x8,%eax
80109eec:	0f b7 c0             	movzwl %ax,%eax
80109eef:	83 ec 0c             	sub    $0xc,%esp
80109ef2:	50                   	push   %eax
80109ef3:	e8 50 f7 ff ff       	call   80109648 <H2N_ushort>
80109ef8:	83 c4 10             	add    $0x10,%esp
80109efb:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109efe:	66 89 42 10          	mov    %ax,0x10(%edx)


}
80109f02:	90                   	nop
80109f03:	c9                   	leave
80109f04:	c3                   	ret

80109f05 <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
80109f05:	55                   	push   %ebp
80109f06:	89 e5                	mov    %esp,%ebp
80109f08:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
80109f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80109f0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
80109f11:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f14:	83 c0 14             	add    $0x14,%eax
80109f17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
80109f1a:	83 ec 04             	sub    $0x4,%esp
80109f1d:	6a 04                	push   $0x4
80109f1f:	68 e4 f4 10 80       	push   $0x8010f4e4
80109f24:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109f27:	50                   	push   %eax
80109f28:	e8 5a ad ff ff       	call   80104c87 <memmove>
80109f2d:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
80109f30:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f33:	83 c0 0c             	add    $0xc,%eax
80109f36:	83 ec 04             	sub    $0x4,%esp
80109f39:	6a 04                	push   $0x4
80109f3b:	50                   	push   %eax
80109f3c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109f3f:	83 c0 04             	add    $0x4,%eax
80109f42:	50                   	push   %eax
80109f43:	e8 3f ad ff ff       	call   80104c87 <memmove>
80109f48:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
80109f4b:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
80109f4f:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
80109f53:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f56:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80109f5a:	0f b7 c0             	movzwl %ax,%eax
80109f5d:	83 ec 0c             	sub    $0xc,%esp
80109f60:	50                   	push   %eax
80109f61:	e8 cb f6 ff ff       	call   80109631 <N2H_ushort>
80109f66:	83 c4 10             	add    $0x10,%esp
80109f69:	83 e8 14             	sub    $0x14,%eax
80109f6c:	0f b7 c0             	movzwl %ax,%eax
80109f6f:	83 ec 0c             	sub    $0xc,%esp
80109f72:	50                   	push   %eax
80109f73:	e8 d0 f6 ff ff       	call   80109648 <H2N_ushort>
80109f78:	83 c4 10             	add    $0x10,%esp
80109f7b:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
80109f7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
80109f86:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109f89:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
80109f8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80109f93:	eb 33                	jmp    80109fc8 <tcp_chksum+0xc3>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f98:	01 c0                	add    %eax,%eax
80109f9a:	89 c2                	mov    %eax,%edx
80109f9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f9f:	01 d0                	add    %edx,%eax
80109fa1:	0f b6 00             	movzbl (%eax),%eax
80109fa4:	0f b6 c0             	movzbl %al,%eax
80109fa7:	c1 e0 08             	shl    $0x8,%eax
80109faa:	89 c2                	mov    %eax,%edx
80109fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109faf:	01 c0                	add    %eax,%eax
80109fb1:	8d 48 01             	lea    0x1(%eax),%ecx
80109fb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109fb7:	01 c8                	add    %ecx,%eax
80109fb9:	0f b6 00             	movzbl (%eax),%eax
80109fbc:	0f b6 c0             	movzbl %al,%eax
80109fbf:	01 d0                	add    %edx,%eax
80109fc1:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
80109fc4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80109fc8:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80109fcc:	7e c7                	jle    80109f95 <tcp_chksum+0x90>
  }

  bin = (uchar *)(tcp_p);
80109fce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109fd1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
80109fd4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80109fdb:	eb 33                	jmp    8010a010 <tcp_chksum+0x10b>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109fe0:	01 c0                	add    %eax,%eax
80109fe2:	89 c2                	mov    %eax,%edx
80109fe4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109fe7:	01 d0                	add    %edx,%eax
80109fe9:	0f b6 00             	movzbl (%eax),%eax
80109fec:	0f b6 c0             	movzbl %al,%eax
80109fef:	c1 e0 08             	shl    $0x8,%eax
80109ff2:	89 c2                	mov    %eax,%edx
80109ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ff7:	01 c0                	add    %eax,%eax
80109ff9:	8d 48 01             	lea    0x1(%eax),%ecx
80109ffc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109fff:	01 c8                	add    %ecx,%eax
8010a001:	0f b6 00             	movzbl (%eax),%eax
8010a004:	0f b6 c0             	movzbl %al,%eax
8010a007:	01 d0                	add    %edx,%eax
8010a009:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a00c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a010:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
8010a014:	0f b7 c0             	movzwl %ax,%eax
8010a017:	83 ec 0c             	sub    $0xc,%esp
8010a01a:	50                   	push   %eax
8010a01b:	e8 11 f6 ff ff       	call   80109631 <N2H_ushort>
8010a020:	83 c4 10             	add    $0x10,%esp
8010a023:	66 d1 e8             	shr    $1,%ax
8010a026:	0f b7 c0             	movzwl %ax,%eax
8010a029:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010a02c:	7c af                	jl     80109fdd <tcp_chksum+0xd8>
  }
  chk_sum += (chk_sum>>8*2);
8010a02e:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a031:	c1 e8 10             	shr    $0x10,%eax
8010a034:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
8010a037:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a03a:	f7 d0                	not    %eax
}
8010a03c:	c9                   	leave
8010a03d:	c3                   	ret

8010a03e <tcp_fin>:

void tcp_fin(){
8010a03e:	55                   	push   %ebp
8010a03f:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
8010a041:	c7 05 68 70 19 80 01 	movl   $0x1,0x80197068
8010a048:	00 00 00 
}
8010a04b:	90                   	nop
8010a04c:	5d                   	pop    %ebp
8010a04d:	c3                   	ret

8010a04e <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
8010a04e:	55                   	push   %ebp
8010a04f:	89 e5                	mov    %esp,%ebp
8010a051:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
8010a054:	8b 45 10             	mov    0x10(%ebp),%eax
8010a057:	83 ec 04             	sub    $0x4,%esp
8010a05a:	6a 00                	push   $0x0
8010a05c:	68 ab c1 10 80       	push   $0x8010c1ab
8010a061:	50                   	push   %eax
8010a062:	e8 65 00 00 00       	call   8010a0cc <http_strcpy>
8010a067:	83 c4 10             	add    $0x10,%esp
8010a06a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
8010a06d:	8b 45 10             	mov    0x10(%ebp),%eax
8010a070:	83 ec 04             	sub    $0x4,%esp
8010a073:	ff 75 f4             	push   -0xc(%ebp)
8010a076:	68 be c1 10 80       	push   $0x8010c1be
8010a07b:	50                   	push   %eax
8010a07c:	e8 4b 00 00 00       	call   8010a0cc <http_strcpy>
8010a081:	83 c4 10             	add    $0x10,%esp
8010a084:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
8010a087:	8b 45 10             	mov    0x10(%ebp),%eax
8010a08a:	83 ec 04             	sub    $0x4,%esp
8010a08d:	ff 75 f4             	push   -0xc(%ebp)
8010a090:	68 d9 c1 10 80       	push   $0x8010c1d9
8010a095:	50                   	push   %eax
8010a096:	e8 31 00 00 00       	call   8010a0cc <http_strcpy>
8010a09b:	83 c4 10             	add    $0x10,%esp
8010a09e:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
8010a0a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a0a4:	83 e0 01             	and    $0x1,%eax
8010a0a7:	85 c0                	test   %eax,%eax
8010a0a9:	74 11                	je     8010a0bc <http_proc+0x6e>
    char *payload = (char *)send;
8010a0ab:	8b 45 10             	mov    0x10(%ebp),%eax
8010a0ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
8010a0b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a0b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a0b7:	01 d0                	add    %edx,%eax
8010a0b9:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
8010a0bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a0bf:	8b 45 14             	mov    0x14(%ebp),%eax
8010a0c2:	89 10                	mov    %edx,(%eax)
  tcp_fin();
8010a0c4:	e8 75 ff ff ff       	call   8010a03e <tcp_fin>
}
8010a0c9:	90                   	nop
8010a0ca:	c9                   	leave
8010a0cb:	c3                   	ret

8010a0cc <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
8010a0cc:	55                   	push   %ebp
8010a0cd:	89 e5                	mov    %esp,%ebp
8010a0cf:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
8010a0d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
8010a0d9:	eb 20                	jmp    8010a0fb <http_strcpy+0x2f>
    dst[start_index+i] = src[i];
8010a0db:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a0de:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a0e1:	01 d0                	add    %edx,%eax
8010a0e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a0e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a0e9:	01 ca                	add    %ecx,%edx
8010a0eb:	89 d1                	mov    %edx,%ecx
8010a0ed:	8b 55 08             	mov    0x8(%ebp),%edx
8010a0f0:	01 ca                	add    %ecx,%edx
8010a0f2:	0f b6 00             	movzbl (%eax),%eax
8010a0f5:	88 02                	mov    %al,(%edx)
    i++;
8010a0f7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
8010a0fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a0fe:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a101:	01 d0                	add    %edx,%eax
8010a103:	0f b6 00             	movzbl (%eax),%eax
8010a106:	84 c0                	test   %al,%al
8010a108:	75 d1                	jne    8010a0db <http_strcpy+0xf>
  }
  return i;
8010a10a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a10d:	c9                   	leave
8010a10e:	c3                   	ret

8010a10f <ideinit>:
static int disksize;
static uchar *memdisk;

void
ideinit(void)
{
8010a10f:	55                   	push   %ebp
8010a110:	89 e5                	mov    %esp,%ebp
  memdisk = _binary_fs_img_start;
8010a112:	c7 05 70 70 19 80 a2 	movl   $0x8010f5a2,0x80197070
8010a119:	f5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
8010a11c:	b8 00 d0 07 00       	mov    $0x7d000,%eax
8010a121:	c1 e8 09             	shr    $0x9,%eax
8010a124:	a3 6c 70 19 80       	mov    %eax,0x8019706c
}
8010a129:	90                   	nop
8010a12a:	5d                   	pop    %ebp
8010a12b:	c3                   	ret

8010a12c <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010a12c:	55                   	push   %ebp
8010a12d:	89 e5                	mov    %esp,%ebp
  // no-op
}
8010a12f:	90                   	nop
8010a130:	5d                   	pop    %ebp
8010a131:	c3                   	ret

8010a132 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010a132:	55                   	push   %ebp
8010a133:	89 e5                	mov    %esp,%ebp
8010a135:	83 ec 18             	sub    $0x18,%esp
  uchar *p;

  if(!holdingsleep(&b->lock))
8010a138:	8b 45 08             	mov    0x8(%ebp),%eax
8010a13b:	83 c0 0c             	add    $0xc,%eax
8010a13e:	83 ec 0c             	sub    $0xc,%esp
8010a141:	50                   	push   %eax
8010a142:	e8 7a a7 ff ff       	call   801048c1 <holdingsleep>
8010a147:	83 c4 10             	add    $0x10,%esp
8010a14a:	85 c0                	test   %eax,%eax
8010a14c:	75 0d                	jne    8010a15b <iderw+0x29>
    panic("iderw: buf not locked");
8010a14e:	83 ec 0c             	sub    $0xc,%esp
8010a151:	68 ea c1 10 80       	push   $0x8010c1ea
8010a156:	e8 4e 64 ff ff       	call   801005a9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010a15b:	8b 45 08             	mov    0x8(%ebp),%eax
8010a15e:	8b 00                	mov    (%eax),%eax
8010a160:	83 e0 06             	and    $0x6,%eax
8010a163:	83 f8 02             	cmp    $0x2,%eax
8010a166:	75 0d                	jne    8010a175 <iderw+0x43>
    panic("iderw: nothing to do");
8010a168:	83 ec 0c             	sub    $0xc,%esp
8010a16b:	68 00 c2 10 80       	push   $0x8010c200
8010a170:	e8 34 64 ff ff       	call   801005a9 <panic>
  if(b->dev != 1)
8010a175:	8b 45 08             	mov    0x8(%ebp),%eax
8010a178:	8b 40 04             	mov    0x4(%eax),%eax
8010a17b:	83 f8 01             	cmp    $0x1,%eax
8010a17e:	74 0d                	je     8010a18d <iderw+0x5b>
    panic("iderw: request not for disk 1");
8010a180:	83 ec 0c             	sub    $0xc,%esp
8010a183:	68 15 c2 10 80       	push   $0x8010c215
8010a188:	e8 1c 64 ff ff       	call   801005a9 <panic>
  if(b->blockno >= disksize)
8010a18d:	8b 45 08             	mov    0x8(%ebp),%eax
8010a190:	8b 40 08             	mov    0x8(%eax),%eax
8010a193:	8b 15 6c 70 19 80    	mov    0x8019706c,%edx
8010a199:	39 d0                	cmp    %edx,%eax
8010a19b:	72 0d                	jb     8010a1aa <iderw+0x78>
    panic("iderw: block out of range");
8010a19d:	83 ec 0c             	sub    $0xc,%esp
8010a1a0:	68 33 c2 10 80       	push   $0x8010c233
8010a1a5:	e8 ff 63 ff ff       	call   801005a9 <panic>

  p = memdisk + b->blockno*BSIZE;
8010a1aa:	8b 15 70 70 19 80    	mov    0x80197070,%edx
8010a1b0:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1b3:	8b 40 08             	mov    0x8(%eax),%eax
8010a1b6:	c1 e0 09             	shl    $0x9,%eax
8010a1b9:	01 d0                	add    %edx,%eax
8010a1bb:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(b->flags & B_DIRTY){
8010a1be:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1c1:	8b 00                	mov    (%eax),%eax
8010a1c3:	83 e0 04             	and    $0x4,%eax
8010a1c6:	85 c0                	test   %eax,%eax
8010a1c8:	74 2b                	je     8010a1f5 <iderw+0xc3>
    b->flags &= ~B_DIRTY;
8010a1ca:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1cd:	8b 00                	mov    (%eax),%eax
8010a1cf:	83 e0 fb             	and    $0xfffffffb,%eax
8010a1d2:	89 c2                	mov    %eax,%edx
8010a1d4:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1d7:	89 10                	mov    %edx,(%eax)
    memmove(p, b->data, BSIZE);
8010a1d9:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1dc:	83 c0 5c             	add    $0x5c,%eax
8010a1df:	83 ec 04             	sub    $0x4,%esp
8010a1e2:	68 00 02 00 00       	push   $0x200
8010a1e7:	50                   	push   %eax
8010a1e8:	ff 75 f4             	push   -0xc(%ebp)
8010a1eb:	e8 97 aa ff ff       	call   80104c87 <memmove>
8010a1f0:	83 c4 10             	add    $0x10,%esp
8010a1f3:	eb 1a                	jmp    8010a20f <iderw+0xdd>
  } else
    memmove(b->data, p, BSIZE);
8010a1f5:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1f8:	83 c0 5c             	add    $0x5c,%eax
8010a1fb:	83 ec 04             	sub    $0x4,%esp
8010a1fe:	68 00 02 00 00       	push   $0x200
8010a203:	ff 75 f4             	push   -0xc(%ebp)
8010a206:	50                   	push   %eax
8010a207:	e8 7b aa ff ff       	call   80104c87 <memmove>
8010a20c:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
8010a20f:	8b 45 08             	mov    0x8(%ebp),%eax
8010a212:	8b 00                	mov    (%eax),%eax
8010a214:	83 c8 02             	or     $0x2,%eax
8010a217:	89 c2                	mov    %eax,%edx
8010a219:	8b 45 08             	mov    0x8(%ebp),%eax
8010a21c:	89 10                	mov    %edx,(%eax)
}
8010a21e:	90                   	nop
8010a21f:	c9                   	leave
8010a220:	c3                   	ret
