
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
8010005a:	bc 80 81 19 80       	mov    $0x80198180,%esp
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
8010006f:	68 00 a3 10 80       	push   $0x8010a300
80100074:	68 00 d0 18 80       	push   $0x8018d000
80100079:	e8 cd 48 00 00       	call   8010494b <initlock>
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
801000bd:	68 07 a3 10 80       	push   $0x8010a307
801000c2:	50                   	push   %eax
801000c3:	e8 26 47 00 00       	call   801047ee <initsleeplock>
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
80100101:	e8 67 48 00 00       	call   8010496d <acquire>
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
80100140:	e8 96 48 00 00       	call   801049db <release>
80100145:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
80100148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014b:	83 c0 0c             	add    $0xc,%eax
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	50                   	push   %eax
80100152:	e8 d3 46 00 00       	call   8010482a <acquiresleep>
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
801001c1:	e8 15 48 00 00       	call   801049db <release>
801001c6:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
801001c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001cc:	83 c0 0c             	add    $0xc,%eax
801001cf:	83 ec 0c             	sub    $0xc,%esp
801001d2:	50                   	push   %eax
801001d3:	e8 52 46 00 00       	call   8010482a <acquiresleep>
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
801001f5:	68 0e a3 10 80       	push   $0x8010a30e
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
8010022d:	e8 c1 9f 00 00       	call   8010a1f3 <iderw>
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
8010024a:	e8 8d 46 00 00       	call   801048dc <holdingsleep>
8010024f:	83 c4 10             	add    $0x10,%esp
80100252:	85 c0                	test   %eax,%eax
80100254:	75 0d                	jne    80100263 <bwrite+0x29>
    panic("bwrite");
80100256:	83 ec 0c             	sub    $0xc,%esp
80100259:	68 1f a3 10 80       	push   $0x8010a31f
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
80100278:	e8 76 9f 00 00       	call   8010a1f3 <iderw>
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
80100293:	e8 44 46 00 00       	call   801048dc <holdingsleep>
80100298:	83 c4 10             	add    $0x10,%esp
8010029b:	85 c0                	test   %eax,%eax
8010029d:	75 0d                	jne    801002ac <brelse+0x29>
    panic("brelse");
8010029f:	83 ec 0c             	sub    $0xc,%esp
801002a2:	68 26 a3 10 80       	push   $0x8010a326
801002a7:	e8 fd 02 00 00       	call   801005a9 <panic>

  releasesleep(&b->lock);
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	83 c0 0c             	add    $0xc,%eax
801002b2:	83 ec 0c             	sub    $0xc,%esp
801002b5:	50                   	push   %eax
801002b6:	e8 d3 45 00 00       	call   8010488e <releasesleep>
801002bb:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 00 d0 18 80       	push   $0x8018d000
801002c6:	e8 a2 46 00 00       	call   8010496d <acquire>
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
80100336:	e8 a0 46 00 00       	call   801049db <release>
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
80100410:	e8 58 45 00 00       	call   8010496d <acquire>
80100415:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100418:	8b 45 08             	mov    0x8(%ebp),%eax
8010041b:	85 c0                	test   %eax,%eax
8010041d:	75 0d                	jne    8010042c <cprintf+0x38>
    panic("null fmt");
8010041f:	83 ec 0c             	sub    $0xc,%esp
80100422:	68 2d a3 10 80       	push   $0x8010a32d
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
80100510:	c7 45 ec 36 a3 10 80 	movl   $0x8010a336,-0x14(%ebp)
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
8010059e:	e8 38 44 00 00       	call   801049db <release>
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
801005c7:	68 3d a3 10 80       	push   $0x8010a33d
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
801005e6:	68 51 a3 10 80       	push   $0x8010a351
801005eb:	e8 04 fe ff ff       	call   801003f4 <cprintf>
801005f0:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005f3:	83 ec 08             	sub    $0x8,%esp
801005f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005f9:	50                   	push   %eax
801005fa:	8d 45 08             	lea    0x8(%ebp),%eax
801005fd:	50                   	push   %eax
801005fe:	e8 2a 44 00 00       	call   80104a2d <getcallerpcs>
80100603:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010060d:	eb 1c                	jmp    8010062b <panic+0x82>
    cprintf(" %p", pcs[i]);
8010060f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100612:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100616:	83 ec 08             	sub    $0x8,%esp
80100619:	50                   	push   %eax
8010061a:	68 53 a3 10 80       	push   $0x8010a353
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
801006a1:	e8 ba 7a 00 00       	call   80108160 <graphic_scroll_up>
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
801006f4:	e8 67 7a 00 00       	call   80108160 <graphic_scroll_up>
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
80100756:	e8 72 7a 00 00       	call   801081cd <font_render>
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
80100793:	e8 41 5e 00 00       	call   801065d9 <uartputc>
80100798:	83 c4 10             	add    $0x10,%esp
8010079b:	83 ec 0c             	sub    $0xc,%esp
8010079e:	6a 20                	push   $0x20
801007a0:	e8 34 5e 00 00       	call   801065d9 <uartputc>
801007a5:	83 c4 10             	add    $0x10,%esp
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	6a 08                	push   $0x8
801007ad:	e8 27 5e 00 00       	call   801065d9 <uartputc>
801007b2:	83 c4 10             	add    $0x10,%esp
801007b5:	eb 0e                	jmp    801007c5 <consputc+0x57>
  } else {
    uartputc(c);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	ff 75 08             	push   0x8(%ebp)
801007bd:	e8 17 5e 00 00       	call   801065d9 <uartputc>
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
801007eb:	e8 7d 41 00 00       	call   8010496d <acquire>
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
8010093f:	e8 8b 3a 00 00       	call   801043cf <wakeup>
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
8010096a:	e8 6c 40 00 00       	call   801049db <release>
8010096f:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
80100972:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100976:	74 05                	je     8010097d <consoleintr+0x1a7>
    procdump();  // now call procdump() wo. cons.lock held
80100978:	e8 10 3b 00 00       	call   8010448d <procdump>
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
801009a2:	e8 c6 3f 00 00       	call   8010496d <acquire>
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
801009c3:	e8 13 40 00 00       	call   801049db <release>
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
801009f0:	e8 f0 38 00 00       	call   801042e5 <sleep>
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
80100a6e:	e8 68 3f 00 00       	call   801049db <release>
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
80100aac:	e8 bc 3e 00 00       	call   8010496d <acquire>
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
80100aee:	e8 e8 3e 00 00       	call   801049db <release>
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
80100b1c:	68 57 a3 10 80       	push   $0x8010a357
80100b21:	68 00 1a 19 80       	push   $0x80191a00
80100b26:	e8 20 3e 00 00       	call   8010494b <initlock>
80100b2b:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b2e:	c7 05 4c 1a 19 80 90 	movl   $0x80100a90,0x80191a4c
80100b35:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b38:	c7 05 48 1a 19 80 80 	movl   $0x80100980,0x80191a48
80100b3f:	09 10 80 
  
  char *p;
  for(p="Starting XV6_UEFI...\n"; *p; p++)
80100b42:	c7 45 f4 5f a3 10 80 	movl   $0x8010a35f,-0xc(%ebp)
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
80100bbf:	68 75 a3 10 80       	push   $0x8010a375
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
80100c1b:	e8 b5 69 00 00       	call   801075d5 <setupkvm>
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
80100cc1:	e8 09 6d 00 00       	call   801079cf <allocuvm>
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
80100d07:	e8 f6 6b 00 00       	call   80107902 <loaduvm>
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
80100d76:	e8 54 6c 00 00       	call   801079cf <allocuvm>
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
80100d9a:	e8 92 6e 00 00       	call   80107c31 <clearpteu>
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
80100dd3:	e8 59 40 00 00       	call   80104e31 <strlen>
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
80100e00:	e8 2c 40 00 00       	call   80104e31 <strlen>
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
80100e26:	e8 a5 6f 00 00       	call   80107dd0 <copyout>
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
80100ec2:	e8 09 6f 00 00       	call   80107dd0 <copyout>
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
80100f10:	e8 d1 3e 00 00       	call   80104de6 <safestrcpy>
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
80100f53:	e8 9b 67 00 00       	call   801076f3 <switchuvm>
80100f58:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f5b:	83 ec 0c             	sub    $0xc,%esp
80100f5e:	ff 75 cc             	push   -0x34(%ebp)
80100f61:	e8 32 6c 00 00       	call   80107b98 <freevm>
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
80100fa1:	e8 f2 6b 00 00       	call   80107b98 <freevm>
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
80100fd2:	68 81 a3 10 80       	push   $0x8010a381
80100fd7:	68 a0 1a 19 80       	push   $0x80191aa0
80100fdc:	e8 6a 39 00 00       	call   8010494b <initlock>
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
80100ff5:	e8 73 39 00 00       	call   8010496d <acquire>
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
80101022:	e8 b4 39 00 00       	call   801049db <release>
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
80101045:	e8 91 39 00 00       	call   801049db <release>
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
80101062:	e8 06 39 00 00       	call   8010496d <acquire>
80101067:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010106a:	8b 45 08             	mov    0x8(%ebp),%eax
8010106d:	8b 40 04             	mov    0x4(%eax),%eax
80101070:	85 c0                	test   %eax,%eax
80101072:	7f 0d                	jg     80101081 <filedup+0x2d>
    panic("filedup");
80101074:	83 ec 0c             	sub    $0xc,%esp
80101077:	68 88 a3 10 80       	push   $0x8010a388
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
80101098:	e8 3e 39 00 00       	call   801049db <release>
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
801010b3:	e8 b5 38 00 00       	call   8010496d <acquire>
801010b8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010bb:	8b 45 08             	mov    0x8(%ebp),%eax
801010be:	8b 40 04             	mov    0x4(%eax),%eax
801010c1:	85 c0                	test   %eax,%eax
801010c3:	7f 0d                	jg     801010d2 <fileclose+0x2d>
    panic("fileclose");
801010c5:	83 ec 0c             	sub    $0xc,%esp
801010c8:	68 90 a3 10 80       	push   $0x8010a390
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
801010f3:	e8 e3 38 00 00       	call   801049db <release>
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
80101141:	e8 95 38 00 00       	call   801049db <release>
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
80101290:	68 9a a3 10 80       	push   $0x8010a39a
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
80101393:	68 a3 a3 10 80       	push   $0x8010a3a3
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
801013c9:	68 b3 a3 10 80       	push   $0x8010a3b3
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
80101401:	e8 9c 38 00 00       	call   80104ca2 <memmove>
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
80101447:	e8 97 37 00 00       	call   80104be3 <memset>
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
801015a5:	68 c0 a3 10 80       	push   $0x8010a3c0
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
80101630:	68 d6 a3 10 80       	push   $0x8010a3d6
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
80101694:	68 e9 a3 10 80       	push   $0x8010a3e9
80101699:	68 60 24 19 80       	push   $0x80192460
8010169e:	e8 a8 32 00 00       	call   8010494b <initlock>
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
801016ca:	68 f0 a3 10 80       	push   $0x8010a3f0
801016cf:	50                   	push   %eax
801016d0:	e8 19 31 00 00       	call   801047ee <initsleeplock>
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
80101729:	68 f8 a3 10 80       	push   $0x8010a3f8
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
801017a2:	e8 3c 34 00 00       	call   80104be3 <memset>
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
80101809:	68 4b a4 10 80       	push   $0x8010a44b
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
801018af:	e8 ee 33 00 00       	call   80104ca2 <memmove>
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
801018e4:	e8 84 30 00 00       	call   8010496d <acquire>
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
80101932:	e8 a4 30 00 00       	call   801049db <release>
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
8010196e:	68 5d a4 10 80       	push   $0x8010a45d
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
801019ab:	e8 2b 30 00 00       	call   801049db <release>
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
801019c6:	e8 a2 2f 00 00       	call   8010496d <acquire>
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
801019e5:	e8 f1 2f 00 00       	call   801049db <release>
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
80101a0b:	68 6d a4 10 80       	push   $0x8010a46d
80101a10:	e8 94 eb ff ff       	call   801005a9 <panic>

  acquiresleep(&ip->lock);
80101a15:	8b 45 08             	mov    0x8(%ebp),%eax
80101a18:	83 c0 0c             	add    $0xc,%eax
80101a1b:	83 ec 0c             	sub    $0xc,%esp
80101a1e:	50                   	push   %eax
80101a1f:	e8 06 2e 00 00       	call   8010482a <acquiresleep>
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
80101ac9:	e8 d4 31 00 00       	call   80104ca2 <memmove>
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
80101af8:	68 73 a4 10 80       	push   $0x8010a473
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
80101b1b:	e8 bc 2d 00 00       	call   801048dc <holdingsleep>
80101b20:	83 c4 10             	add    $0x10,%esp
80101b23:	85 c0                	test   %eax,%eax
80101b25:	74 0a                	je     80101b31 <iunlock+0x2c>
80101b27:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2a:	8b 40 08             	mov    0x8(%eax),%eax
80101b2d:	85 c0                	test   %eax,%eax
80101b2f:	7f 0d                	jg     80101b3e <iunlock+0x39>
    panic("iunlock");
80101b31:	83 ec 0c             	sub    $0xc,%esp
80101b34:	68 82 a4 10 80       	push   $0x8010a482
80101b39:	e8 6b ea ff ff       	call   801005a9 <panic>

  releasesleep(&ip->lock);
80101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b41:	83 c0 0c             	add    $0xc,%eax
80101b44:	83 ec 0c             	sub    $0xc,%esp
80101b47:	50                   	push   %eax
80101b48:	e8 41 2d 00 00       	call   8010488e <releasesleep>
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
80101b63:	e8 c2 2c 00 00       	call   8010482a <acquiresleep>
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
80101b89:	e8 df 2d 00 00       	call   8010496d <acquire>
80101b8e:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101b91:	8b 45 08             	mov    0x8(%ebp),%eax
80101b94:	8b 40 08             	mov    0x8(%eax),%eax
80101b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101b9a:	83 ec 0c             	sub    $0xc,%esp
80101b9d:	68 60 24 19 80       	push   $0x80192460
80101ba2:	e8 34 2e 00 00       	call   801049db <release>
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
80101be9:	e8 a0 2c 00 00       	call   8010488e <releasesleep>
80101bee:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101bf1:	83 ec 0c             	sub    $0xc,%esp
80101bf4:	68 60 24 19 80       	push   $0x80192460
80101bf9:	e8 6f 2d 00 00       	call   8010496d <acquire>
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
80101c18:	e8 be 2d 00 00       	call   801049db <release>
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
80101d5c:	68 8a a4 10 80       	push   $0x8010a48a
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
80101ffa:	e8 a3 2c 00 00       	call   80104ca2 <memmove>
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
8010214a:	e8 53 2b 00 00       	call   80104ca2 <memmove>
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
801021ca:	e8 69 2b 00 00       	call   80104d38 <strncmp>
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
801021ea:	68 9d a4 10 80       	push   $0x8010a49d
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
80102219:	68 af a4 10 80       	push   $0x8010a4af
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
801022ee:	68 be a4 10 80       	push   $0x8010a4be
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
80102329:	e8 60 2a 00 00       	call   80104d8e <strncpy>
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
80102355:	68 cb a4 10 80       	push   $0x8010a4cb
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
801023c7:	e8 d6 28 00 00       	call   80104ca2 <memmove>
801023cc:	83 c4 10             	add    $0x10,%esp
801023cf:	eb 26                	jmp    801023f7 <skipelem+0x91>
  else {
    memmove(name, s, len);
801023d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023d4:	83 ec 04             	sub    $0x4,%esp
801023d7:	50                   	push   %eax
801023d8:	ff 75 f4             	push   -0xc(%ebp)
801023db:	ff 75 0c             	push   0xc(%ebp)
801023de:	e8 bf 28 00 00       	call   80104ca2 <memmove>
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
801025c3:	0f b6 05 44 6e 19 80 	movzbl 0x80196e44,%eax
801025ca:	0f b6 c0             	movzbl %al,%eax
801025cd:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801025d0:	74 10                	je     801025e2 <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025d2:	83 ec 0c             	sub    $0xc,%esp
801025d5:	68 d4 a4 10 80       	push   $0x8010a4d4
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
8010267c:	68 06 a5 10 80       	push   $0x8010a506
80102681:	68 c0 40 19 80       	push   $0x801940c0
80102686:	e8 c0 22 00 00       	call   8010494b <initlock>
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
8010273b:	68 0b a5 10 80       	push   $0x8010a50b
80102740:	e8 64 de ff ff       	call   801005a9 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102745:	83 ec 04             	sub    $0x4,%esp
80102748:	68 00 10 00 00       	push   $0x1000
8010274d:	6a 01                	push   $0x1
8010274f:	ff 75 08             	push   0x8(%ebp)
80102752:	e8 8c 24 00 00       	call   80104be3 <memset>
80102757:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
8010275a:	a1 f4 40 19 80       	mov    0x801940f4,%eax
8010275f:	85 c0                	test   %eax,%eax
80102761:	74 10                	je     80102773 <kfree+0x65>
    acquire(&kmem.lock);
80102763:	83 ec 0c             	sub    $0xc,%esp
80102766:	68 c0 40 19 80       	push   $0x801940c0
8010276b:	e8 fd 21 00 00       	call   8010496d <acquire>
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
8010279d:	e8 39 22 00 00       	call   801049db <release>
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
801027bf:	e8 a9 21 00 00       	call   8010496d <acquire>
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
801027f0:	e8 e6 21 00 00       	call   801049db <release>
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
80102d14:	e8 31 1f 00 00       	call   80104c4a <memcmp>
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
80102e28:	68 11 a5 10 80       	push   $0x8010a511
80102e2d:	68 20 41 19 80       	push   $0x80194120
80102e32:	e8 14 1b 00 00       	call   8010494b <initlock>
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
80102edd:	e8 c0 1d 00 00       	call   80104ca2 <memmove>
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
8010304c:	e8 1c 19 00 00       	call   8010496d <acquire>
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
8010306a:	e8 76 12 00 00       	call   801042e5 <sleep>
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
8010309f:	e8 41 12 00 00       	call   801042e5 <sleep>
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
801030be:	e8 18 19 00 00       	call   801049db <release>
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
801030df:	e8 89 18 00 00       	call   8010496d <acquire>
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
80103100:	68 15 a5 10 80       	push   $0x8010a515
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
8010312e:	e8 9c 12 00 00       	call   801043cf <wakeup>
80103133:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103136:	83 ec 0c             	sub    $0xc,%esp
80103139:	68 20 41 19 80       	push   $0x80194120
8010313e:	e8 98 18 00 00       	call   801049db <release>
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
80103159:	e8 0f 18 00 00       	call   8010496d <acquire>
8010315e:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103161:	c7 05 60 41 19 80 00 	movl   $0x0,0x80194160
80103168:	00 00 00 
    wakeup(&log);
8010316b:	83 ec 0c             	sub    $0xc,%esp
8010316e:	68 20 41 19 80       	push   $0x80194120
80103173:	e8 57 12 00 00       	call   801043cf <wakeup>
80103178:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010317b:	83 ec 0c             	sub    $0xc,%esp
8010317e:	68 20 41 19 80       	push   $0x80194120
80103183:	e8 53 18 00 00       	call   801049db <release>
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
801031ff:	e8 9e 1a 00 00       	call   80104ca2 <memmove>
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
8010329c:	68 24 a5 10 80       	push   $0x8010a524
801032a1:	e8 03 d3 ff ff       	call   801005a9 <panic>
  if (log.outstanding < 1)
801032a6:	a1 5c 41 19 80       	mov    0x8019415c,%eax
801032ab:	85 c0                	test   %eax,%eax
801032ad:	7f 0d                	jg     801032bc <log_write+0x45>
    panic("log_write outside of trans");
801032af:	83 ec 0c             	sub    $0xc,%esp
801032b2:	68 3a a5 10 80       	push   $0x8010a53a
801032b7:	e8 ed d2 ff ff       	call   801005a9 <panic>

  acquire(&log.lock);
801032bc:	83 ec 0c             	sub    $0xc,%esp
801032bf:	68 20 41 19 80       	push   $0x80194120
801032c4:	e8 a4 16 00 00       	call   8010496d <acquire>
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
80103342:	e8 94 16 00 00       	call   801049db <release>
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
80103378:	e8 28 4d 00 00       	call   801080a5 <graphic_init>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator 커널이 사용할 수 있는 물리 메모리의 첫 4MB를 할당할 준비를 합니다.
8010337d:	83 ec 08             	sub    $0x8,%esp
80103380:	68 00 00 40 80       	push   $0x80400000
80103385:	68 00 90 19 80       	push   $0x80199000
8010338a:	e8 e4 f2 ff ff       	call   80102673 <kinit1>
8010338f:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table // 가상 메모리 주소를 물리 메모리 주소로 변환할 **커널 페이지 테이블(지도)**을 만듭니다.
80103392:	e8 2b 43 00 00       	call   801076c2 <kvmalloc>
  mpinit_uefi(); // 다중 코어(멀티프로세서) 환경을 UEFI 방식에 맞게 파악합니다. CPU가 몇 개인지 확인하는 작업이죠.
80103397:	e8 d2 4a 00 00       	call   80107e6e <mpinit_uefi>
  lapicinit();     // interrupt controller 키보드나 마우스 등 외부에서 들어오는 신호(인터럽트)를 CPU가 받을 수 있도록 컨트롤러를 켭니다.
8010339c:	e8 3f f6 ff ff       	call   801029e0 <lapicinit>
  seginit();       // segment descriptors 메모리 보호 구역(세그먼트)을 설정하고, 오류나 시스템 콜이 발생했을 때 어디로 가야 할지(트랩 벡터)를 설정합니다.
801033a1:	e8 b3 3d 00 00       	call   80107159 <seginit>
  picinit();    // disable pic
801033a6:	e8 9b 01 00 00       	call   80103546 <picinit>
  ioapicinit();    // another interrupt controller 키보드나 마우스 등 외부에서 들어오는 신호(인터럽트)를 CPU가 받을 수 있도록 컨트롤러를 켭니다.
801033ab:	e8 de f1 ff ff       	call   8010258e <ioapicinit>
  consoleinit();   // console hardware 화면에 글자를 찍고(콘솔), 시리얼 통신을 할 준비를 합니다.
801033b0:	e8 54 d7 ff ff       	call   80100b09 <consoleinit>
  uartinit();      // serial port 화면에 글자를 찍고(콘솔), 시리얼 통신을 할 준비를 합니다.
801033b5:	e8 38 31 00 00       	call   801064f2 <uartinit>
  pinit();         // process table 프로세스 장부(프로세스 테이블)를 초기화합니다.
801033ba:	e8 c0 05 00 00       	call   8010397f <pinit>
  tvinit();        // trap vectors 메모리 보호 구역(세그먼트)을 설정하고, 오류나 시스템 콜이 발생했을 때 어디로 가야 할지(트랩 벡터)를 설정합니다.
801033bf:	e8 98 2c 00 00       	call   8010605c <tvinit>
  binit();         // buffer cache 하드디스크(IDE)를 읽고 쓸 준비를 하고, 파일 시스템과 버퍼를 세팅합니다.
801033c4:	e8 9d cc ff ff       	call   80100066 <binit>
  fileinit();      // file table 하드디스크(IDE)를 읽고 쓸 준비를 하고, 파일 시스템과 버퍼를 세팅합니다.
801033c9:	e8 fb db ff ff       	call   80100fc9 <fileinit>
  ideinit();       // disk  하드디스크(IDE)를 읽고 쓸 준비를 하고, 파일 시스템과 버퍼를 세팅합니다.
801033ce:	e8 fd 6d 00 00       	call   8010a1d0 <ideinit>
  startothers();   // start other processors 잠들어 있는 나머지 CPU들을 깨웁니다. (자세한 건 아래 2번에서 설명할게요)
801033d3:	e8 8a 00 00 00       	call   80103462 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers() 처음 4MB 이후의 나머지 모든 물리 메모리를 운영체제가 사용할 수 있도록 마저 할당합니다.
801033d8:	83 ec 08             	sub    $0x8,%esp
801033db:	68 00 00 00 a0       	push   $0xa0000000
801033e0:	68 00 00 40 80       	push   $0x80400000
801033e5:	e8 c2 f2 ff ff       	call   801026ac <kinit2>
801033ea:	83 c4 10             	add    $0x10,%esp
  pci_init(); // 추가된 네트워크 및 하드웨어 장치를 스캔합니다 
801033ed:	e8 0e 4f 00 00       	call   80108300 <pci_init>
  arp_scan(); // 추가된 네트워크 및 하드웨어 장치를 스캔합니다.
801033f2:	e8 43 5c 00 00       	call   8010903a <arp_scan>
  //i8254_recv();
  userinit();      // first user process 드디어 대망의 첫 번째 유저 프로그램(보통 init 프로세스)을 메모리에 만듭니다.
801033f7:	e8 64 07 00 00       	call   80103b60 <userinit>

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
80103407:	e8 ce 42 00 00       	call   801076da <switchkvm>
  seginit();
8010340c:	e8 48 3d 00 00       	call   80107159 <seginit>
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
80103433:	68 55 a5 10 80       	push   $0x8010a555
80103438:	e8 b7 cf ff ff       	call   801003f4 <cprintf>
8010343d:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103440:	e8 8d 2d 00 00       	call   801061d2 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103445:	e8 6e 05 00 00       	call   801039b8 <mycpu>
8010344a:	05 a0 00 00 00       	add    $0xa0,%eax
8010344f:	83 ec 08             	sub    $0x8,%esp
80103452:	6a 01                	push   $0x1
80103454:	50                   	push   %eax
80103455:	e8 f3 fe ff ff       	call   8010334d <xchg>
8010345a:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010345d:	e8 8f 0c 00 00       	call   801040f1 <scheduler>

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
80103478:	68 38 f5 10 80       	push   $0x8010f538
8010347d:	ff 75 f0             	push   -0x10(%ebp)
80103480:	e8 1d 18 00 00       	call   80104ca2 <memmove>
80103485:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103488:	c7 45 f4 80 6b 19 80 	movl   $0x80196b80,-0xc(%ebp)
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
8010350a:	a1 40 6e 19 80       	mov    0x80196e40,%eax
8010350f:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103515:	05 80 6b 19 80       	add    $0x80196b80,%eax
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
80103607:	68 69 a5 10 80       	push   $0x8010a569
8010360c:	50                   	push   %eax
8010360d:	e8 39 13 00 00       	call   8010494b <initlock>
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
801036cc:	e8 9c 12 00 00       	call   8010496d <acquire>
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
801036f3:	e8 d7 0c 00 00       	call   801043cf <wakeup>
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
80103716:	e8 b4 0c 00 00       	call   801043cf <wakeup>
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
8010373f:	e8 97 12 00 00       	call   801049db <release>
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
8010375e:	e8 78 12 00 00       	call   801049db <release>
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
80103778:	e8 f0 11 00 00       	call   8010496d <acquire>
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
801037ac:	e8 2a 12 00 00       	call   801049db <release>
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
801037ca:	e8 00 0c 00 00       	call   801043cf <wakeup>
801037cf:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037d2:	8b 45 08             	mov    0x8(%ebp),%eax
801037d5:	8b 55 08             	mov    0x8(%ebp),%edx
801037d8:	81 c2 38 02 00 00    	add    $0x238,%edx
801037de:	83 ec 08             	sub    $0x8,%esp
801037e1:	50                   	push   %eax
801037e2:	52                   	push   %edx
801037e3:	e8 fd 0a 00 00       	call   801042e5 <sleep>
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
8010384d:	e8 7d 0b 00 00       	call   801043cf <wakeup>
80103852:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103855:	8b 45 08             	mov    0x8(%ebp),%eax
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	50                   	push   %eax
8010385c:	e8 7a 11 00 00       	call   801049db <release>
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
80103879:	e8 ef 10 00 00       	call   8010496d <acquire>
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
80103896:	e8 40 11 00 00       	call   801049db <release>
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
801038b9:	e8 27 0a 00 00       	call   801042e5 <sleep>
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
8010394c:	e8 7e 0a 00 00       	call   801043cf <wakeup>
80103951:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103954:	8b 45 08             	mov    0x8(%ebp),%eax
80103957:	83 ec 0c             	sub    $0xc,%esp
8010395a:	50                   	push   %eax
8010395b:	e8 7b 10 00 00       	call   801049db <release>
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
80103988:	68 70 a5 10 80       	push   $0x8010a570
8010398d:	68 00 42 19 80       	push   $0x80194200
80103992:	e8 b4 0f 00 00       	call   8010494b <initlock>
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
801039a8:	2d 80 6b 19 80       	sub    $0x80196b80,%eax
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
801039cf:	68 78 a5 10 80       	push   $0x8010a578
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
801039f3:	05 80 6b 19 80       	add    $0x80196b80,%eax
801039f8:	0f b6 00             	movzbl (%eax),%eax
801039fb:	0f b6 c0             	movzbl %al,%eax
801039fe:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80103a01:	75 10                	jne    80103a13 <mycpu+0x5b>
      return &cpus[i];
80103a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a06:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103a0c:	05 80 6b 19 80       	add    $0x80196b80,%eax
80103a11:	eb 1b                	jmp    80103a2e <mycpu+0x76>
  for (i = 0; i < ncpu; ++i) {
80103a13:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a17:	a1 40 6e 19 80       	mov    0x80196e40,%eax
80103a1c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103a1f:	7c c9                	jl     801039ea <mycpu+0x32>
    }
  }
  panic("unknown apicid\n");
80103a21:	83 ec 0c             	sub    $0xc,%esp
80103a24:	68 9e a5 10 80       	push   $0x8010a59e
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
80103a36:	e8 9d 10 00 00       	call   80104ad8 <pushcli>
  c = mycpu();
80103a3b:	e8 78 ff ff ff       	call   801039b8 <mycpu>
80103a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80103a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a46:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80103a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80103a4f:	e8 d1 10 00 00       	call   80104b25 <popcli>
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
80103a67:	e8 01 0f 00 00       	call   8010496d <acquire>
80103a6c:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a6f:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103a76:	eb 11                	jmp    80103a89 <allocproc+0x30>
    if(p->state == UNUSED){
80103a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a7b:	8b 40 0c             	mov    0xc(%eax),%eax
80103a7e:	85 c0                	test   %eax,%eax
80103a80:	74 2a                	je     80103aac <allocproc+0x53>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a82:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80103a89:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80103a90:	72 e6                	jb     80103a78 <allocproc+0x1f>
      goto found;
    }

  release(&ptable.lock);
80103a92:	83 ec 0c             	sub    $0xc,%esp
80103a95:	68 00 42 19 80       	push   $0x80194200
80103a9a:	e8 3c 0f 00 00       	call   801049db <release>
80103a9f:	83 c4 10             	add    $0x10,%esp
  return 0;
80103aa2:	b8 00 00 00 00       	mov    $0x0,%eax
80103aa7:	e9 b2 00 00 00       	jmp    80103b5e <allocproc+0x105>
      goto found;
80103aac:	90                   	nop

found:
  p->state = EMBRYO;
80103aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ab0:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80103ab7:	a1 00 f0 10 80       	mov    0x8010f000,%eax
80103abc:	8d 50 01             	lea    0x1(%eax),%edx
80103abf:	89 15 00 f0 10 80    	mov    %edx,0x8010f000
80103ac5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ac8:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80103acb:	83 ec 0c             	sub    $0xc,%esp
80103ace:	68 00 42 19 80       	push   $0x80194200
80103ad3:	e8 03 0f 00 00       	call   801049db <release>
80103ad8:	83 c4 10             	add    $0x10,%esp


  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103adb:	e8 c8 ec ff ff       	call   801027a8 <kalloc>
80103ae0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ae3:	89 42 08             	mov    %eax,0x8(%edx)
80103ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae9:	8b 40 08             	mov    0x8(%eax),%eax
80103aec:	85 c0                	test   %eax,%eax
80103aee:	75 11                	jne    80103b01 <allocproc+0xa8>
    p->state = UNUSED;
80103af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80103afa:	b8 00 00 00 00       	mov    $0x0,%eax
80103aff:	eb 5d                	jmp    80103b5e <allocproc+0x105>
  }
  sp = p->kstack + KSTACKSIZE;
80103b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b04:	8b 40 08             	mov    0x8(%eax),%eax
80103b07:	05 00 10 00 00       	add    $0x1000,%eax
80103b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b0f:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80103b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b16:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103b19:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80103b1c:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80103b20:	ba 16 60 10 80       	mov    $0x80106016,%edx
80103b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b28:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80103b2a:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80103b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b31:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103b34:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80103b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b3a:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b3d:	83 ec 04             	sub    $0x4,%esp
80103b40:	6a 14                	push   $0x14
80103b42:	6a 00                	push   $0x0
80103b44:	50                   	push   %eax
80103b45:	e8 99 10 00 00       	call   80104be3 <memset>
80103b4a:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b50:	8b 40 1c             	mov    0x1c(%eax),%eax
80103b53:	ba 9f 42 10 80       	mov    $0x8010429f,%edx
80103b58:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80103b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103b5e:	c9                   	leave
80103b5f:	c3                   	ret

80103b60 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103b66:	e8 ee fe ff ff       	call   80103a59 <allocproc>
80103b6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80103b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b71:	a3 34 63 19 80       	mov    %eax,0x80196334
  if((p->pgdir = setupkvm()) == 0){
80103b76:	e8 5a 3a 00 00       	call   801075d5 <setupkvm>
80103b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b7e:	89 42 04             	mov    %eax,0x4(%edx)
80103b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b84:	8b 40 04             	mov    0x4(%eax),%eax
80103b87:	85 c0                	test   %eax,%eax
80103b89:	75 0d                	jne    80103b98 <userinit+0x38>
    panic("userinit: out of memory?");
80103b8b:	83 ec 0c             	sub    $0xc,%esp
80103b8e:	68 ae a5 10 80       	push   $0x8010a5ae
80103b93:	e8 11 ca ff ff       	call   801005a9 <panic>
  }
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b98:	ba 2c 00 00 00       	mov    $0x2c,%edx
80103b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba0:	8b 40 04             	mov    0x4(%eax),%eax
80103ba3:	83 ec 04             	sub    $0x4,%esp
80103ba6:	52                   	push   %edx
80103ba7:	68 0c f5 10 80       	push   $0x8010f50c
80103bac:	50                   	push   %eax
80103bad:	e8 e0 3c 00 00       	call   80107892 <inituvm>
80103bb2:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80103bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb8:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80103bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bc1:	8b 40 18             	mov    0x18(%eax),%eax
80103bc4:	83 ec 04             	sub    $0x4,%esp
80103bc7:	6a 4c                	push   $0x4c
80103bc9:	6a 00                	push   $0x0
80103bcb:	50                   	push   %eax
80103bcc:	e8 12 10 00 00       	call   80104be3 <memset>
80103bd1:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd7:	8b 40 18             	mov    0x18(%eax),%eax
80103bda:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be3:	8b 40 18             	mov    0x18(%eax),%eax
80103be6:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bef:	8b 50 18             	mov    0x18(%eax),%edx
80103bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bf5:	8b 40 18             	mov    0x18(%eax),%eax
80103bf8:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103bfc:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c03:	8b 50 18             	mov    0x18(%eax),%edx
80103c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c09:	8b 40 18             	mov    0x18(%eax),%eax
80103c0c:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80103c10:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c17:	8b 40 18             	mov    0x18(%eax),%eax
80103c1a:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c24:	8b 40 18             	mov    0x18(%eax),%eax
80103c27:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c31:	8b 40 18             	mov    0x18(%eax),%eax
80103c34:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c3e:	83 c0 6c             	add    $0x6c,%eax
80103c41:	83 ec 04             	sub    $0x4,%esp
80103c44:	6a 10                	push   $0x10
80103c46:	68 c7 a5 10 80       	push   $0x8010a5c7
80103c4b:	50                   	push   %eax
80103c4c:	e8 95 11 00 00       	call   80104de6 <safestrcpy>
80103c51:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80103c54:	83 ec 0c             	sub    $0xc,%esp
80103c57:	68 d0 a5 10 80       	push   $0x8010a5d0
80103c5c:	e8 c4 e8 ff ff       	call   80102525 <namei>
80103c61:	83 c4 10             	add    $0x10,%esp
80103c64:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c67:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103c6a:	83 ec 0c             	sub    $0xc,%esp
80103c6d:	68 00 42 19 80       	push   $0x80194200
80103c72:	e8 f6 0c 00 00       	call   8010496d <acquire>
80103c77:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
80103c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c7d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103c84:	83 ec 0c             	sub    $0xc,%esp
80103c87:	68 00 42 19 80       	push   $0x80194200
80103c8c:	e8 4a 0d 00 00       	call   801049db <release>
80103c91:	83 c4 10             	add    $0x10,%esp
}
80103c94:	90                   	nop
80103c95:	c9                   	leave
80103c96:	c3                   	ret

80103c97 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103c97:	55                   	push   %ebp
80103c98:	89 e5                	mov    %esp,%ebp
80103c9a:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
80103c9d:	e8 8e fd ff ff       	call   80103a30 <myproc>
80103ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
80103ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ca8:	8b 00                	mov    (%eax),%eax
80103caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80103cad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103cb1:	7e 2e                	jle    80103ce1 <growproc+0x4a>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cb3:	8b 55 08             	mov    0x8(%ebp),%edx
80103cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb9:	01 c2                	add    %eax,%edx
80103cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cbe:	8b 40 04             	mov    0x4(%eax),%eax
80103cc1:	83 ec 04             	sub    $0x4,%esp
80103cc4:	52                   	push   %edx
80103cc5:	ff 75 f4             	push   -0xc(%ebp)
80103cc8:	50                   	push   %eax
80103cc9:	e8 01 3d 00 00       	call   801079cf <allocuvm>
80103cce:	83 c4 10             	add    $0x10,%esp
80103cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103cd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103cd8:	75 3b                	jne    80103d15 <growproc+0x7e>
      return -1;
80103cda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cdf:	eb 4f                	jmp    80103d30 <growproc+0x99>
  } else if(n < 0){
80103ce1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103ce5:	79 2e                	jns    80103d15 <growproc+0x7e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ce7:	8b 55 08             	mov    0x8(%ebp),%edx
80103cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ced:	01 c2                	add    %eax,%edx
80103cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cf2:	8b 40 04             	mov    0x4(%eax),%eax
80103cf5:	83 ec 04             	sub    $0x4,%esp
80103cf8:	52                   	push   %edx
80103cf9:	ff 75 f4             	push   -0xc(%ebp)
80103cfc:	50                   	push   %eax
80103cfd:	e8 d2 3d 00 00       	call   80107ad4 <deallocuvm>
80103d02:	83 c4 10             	add    $0x10,%esp
80103d05:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d0c:	75 07                	jne    80103d15 <growproc+0x7e>
      return -1;
80103d0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d13:	eb 1b                	jmp    80103d30 <growproc+0x99>
  }
  curproc->sz = sz;
80103d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d18:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d1b:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80103d1d:	83 ec 0c             	sub    $0xc,%esp
80103d20:	ff 75 f0             	push   -0x10(%ebp)
80103d23:	e8 cb 39 00 00       	call   801076f3 <switchuvm>
80103d28:	83 c4 10             	add    $0x10,%esp
  return 0;
80103d2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103d30:	c9                   	leave
80103d31:	c3                   	ret

80103d32 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103d32:	55                   	push   %ebp
80103d33:	89 e5                	mov    %esp,%ebp
80103d35:	57                   	push   %edi
80103d36:	56                   	push   %esi
80103d37:	53                   	push   %ebx
80103d38:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103d3b:	e8 f0 fc ff ff       	call   80103a30 <myproc>
80103d40:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
80103d43:	e8 11 fd ff ff       	call   80103a59 <allocproc>
80103d48:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103d4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80103d4f:	75 0a                	jne    80103d5b <fork+0x29>
    return -1;
80103d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d56:	e9 48 01 00 00       	jmp    80103ea3 <fork+0x171>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d5e:	8b 10                	mov    (%eax),%edx
80103d60:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d63:	8b 40 04             	mov    0x4(%eax),%eax
80103d66:	83 ec 08             	sub    $0x8,%esp
80103d69:	52                   	push   %edx
80103d6a:	50                   	push   %eax
80103d6b:	e8 02 3f 00 00       	call   80107c72 <copyuvm>
80103d70:	83 c4 10             	add    $0x10,%esp
80103d73:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103d76:	89 42 04             	mov    %eax,0x4(%edx)
80103d79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d7c:	8b 40 04             	mov    0x4(%eax),%eax
80103d7f:	85 c0                	test   %eax,%eax
80103d81:	75 30                	jne    80103db3 <fork+0x81>
    kfree(np->kstack);
80103d83:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d86:	8b 40 08             	mov    0x8(%eax),%eax
80103d89:	83 ec 0c             	sub    $0xc,%esp
80103d8c:	50                   	push   %eax
80103d8d:	e8 7c e9 ff ff       	call   8010270e <kfree>
80103d92:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80103d95:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d98:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80103d9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103da2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80103da9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dae:	e9 f0 00 00 00       	jmp    80103ea3 <fork+0x171>
  }
  np->sz = curproc->sz;
80103db3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103db6:	8b 10                	mov    (%eax),%edx
80103db8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103dbb:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80103dbd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103dc0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103dc3:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80103dc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103dc9:	8b 48 18             	mov    0x18(%eax),%ecx
80103dcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103dcf:	8b 40 18             	mov    0x18(%eax),%eax
80103dd2:	89 c2                	mov    %eax,%edx
80103dd4:	89 cb                	mov    %ecx,%ebx
80103dd6:	b8 13 00 00 00       	mov    $0x13,%eax
80103ddb:	89 d7                	mov    %edx,%edi
80103ddd:	89 de                	mov    %ebx,%esi
80103ddf:	89 c1                	mov    %eax,%ecx
80103de1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103de3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103de6:	8b 40 18             	mov    0x18(%eax),%eax
80103de9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80103df0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103df7:	eb 3b                	jmp    80103e34 <fork+0x102>
    if(curproc->ofile[i])
80103df9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103dfc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dff:	83 c2 08             	add    $0x8,%edx
80103e02:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e06:	85 c0                	test   %eax,%eax
80103e08:	74 26                	je     80103e30 <fork+0xfe>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e10:	83 c2 08             	add    $0x8,%edx
80103e13:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103e17:	83 ec 0c             	sub    $0xc,%esp
80103e1a:	50                   	push   %eax
80103e1b:	e8 34 d2 ff ff       	call   80101054 <filedup>
80103e20:	83 c4 10             	add    $0x10,%esp
80103e23:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103e26:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e29:	83 c1 08             	add    $0x8,%ecx
80103e2c:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80103e30:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103e34:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80103e38:	7e bf                	jle    80103df9 <fork+0xc7>
  np->cwd = idup(curproc->cwd);
80103e3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e3d:	8b 40 68             	mov    0x68(%eax),%eax
80103e40:	83 ec 0c             	sub    $0xc,%esp
80103e43:	50                   	push   %eax
80103e44:	e8 6f db ff ff       	call   801019b8 <idup>
80103e49:	83 c4 10             	add    $0x10,%esp
80103e4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103e4f:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e52:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e55:	8d 50 6c             	lea    0x6c(%eax),%edx
80103e58:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e5b:	83 c0 6c             	add    $0x6c,%eax
80103e5e:	83 ec 04             	sub    $0x4,%esp
80103e61:	6a 10                	push   $0x10
80103e63:	52                   	push   %edx
80103e64:	50                   	push   %eax
80103e65:	e8 7c 0f 00 00       	call   80104de6 <safestrcpy>
80103e6a:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80103e6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e70:	8b 40 10             	mov    0x10(%eax),%eax
80103e73:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
80103e76:	83 ec 0c             	sub    $0xc,%esp
80103e79:	68 00 42 19 80       	push   $0x80194200
80103e7e:	e8 ea 0a 00 00       	call   8010496d <acquire>
80103e83:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80103e86:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e89:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80103e90:	83 ec 0c             	sub    $0xc,%esp
80103e93:	68 00 42 19 80       	push   $0x80194200
80103e98:	e8 3e 0b 00 00       	call   801049db <release>
80103e9d:	83 c4 10             	add    $0x10,%esp

  return pid;
80103ea0:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80103ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ea6:	5b                   	pop    %ebx
80103ea7:	5e                   	pop    %esi
80103ea8:	5f                   	pop    %edi
80103ea9:	5d                   	pop    %ebp
80103eaa:	c3                   	ret

80103eab <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103eab:	55                   	push   %ebp
80103eac:	89 e5                	mov    %esp,%ebp
80103eae:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80103eb1:	e8 7a fb ff ff       	call   80103a30 <myproc>
80103eb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103eb9:	a1 34 63 19 80       	mov    0x80196334,%eax
80103ebe:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103ec1:	75 0d                	jne    80103ed0 <exit+0x25>
    panic("init exiting");
80103ec3:	83 ec 0c             	sub    $0xc,%esp
80103ec6:	68 d2 a5 10 80       	push   $0x8010a5d2
80103ecb:	e8 d9 c6 ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103ed0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80103ed7:	eb 3f                	jmp    80103f18 <exit+0x6d>
    if(curproc->ofile[fd]){
80103ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103edc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103edf:	83 c2 08             	add    $0x8,%edx
80103ee2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103ee6:	85 c0                	test   %eax,%eax
80103ee8:	74 2a                	je     80103f14 <exit+0x69>
      fileclose(curproc->ofile[fd]);
80103eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103eed:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103ef0:	83 c2 08             	add    $0x8,%edx
80103ef3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80103ef7:	83 ec 0c             	sub    $0xc,%esp
80103efa:	50                   	push   %eax
80103efb:	e8 a5 d1 ff ff       	call   801010a5 <fileclose>
80103f00:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80103f03:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f06:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103f09:	83 c2 08             	add    $0x8,%edx
80103f0c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80103f13:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103f14:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80103f18:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80103f1c:	7e bb                	jle    80103ed9 <exit+0x2e>
    }
  }

  begin_op();
80103f1e:	e8 1b f1 ff ff       	call   8010303e <begin_op>
  iput(curproc->cwd);
80103f23:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f26:	8b 40 68             	mov    0x68(%eax),%eax
80103f29:	83 ec 0c             	sub    $0xc,%esp
80103f2c:	50                   	push   %eax
80103f2d:	e8 21 dc ff ff       	call   80101b53 <iput>
80103f32:	83 c4 10             	add    $0x10,%esp
  end_op();
80103f35:	e8 90 f1 ff ff       	call   801030ca <end_op>
  curproc->cwd = 0;
80103f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f3d:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103f44:	83 ec 0c             	sub    $0xc,%esp
80103f47:	68 00 42 19 80       	push   $0x80194200
80103f4c:	e8 1c 0a 00 00       	call   8010496d <acquire>
80103f51:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103f54:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f57:	8b 40 14             	mov    0x14(%eax),%eax
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	50                   	push   %eax
80103f5e:	e8 29 04 00 00       	call   8010438c <wakeup1>
80103f63:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f66:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103f6d:	eb 3a                	jmp    80103fa9 <exit+0xfe>
    if(p->parent == curproc){
80103f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f72:	8b 40 14             	mov    0x14(%eax),%eax
80103f75:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80103f78:	75 28                	jne    80103fa2 <exit+0xf7>
      p->parent = initproc;
80103f7a:	8b 15 34 63 19 80    	mov    0x80196334,%edx
80103f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f83:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80103f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f89:	8b 40 0c             	mov    0xc(%eax),%eax
80103f8c:	83 f8 05             	cmp    $0x5,%eax
80103f8f:	75 11                	jne    80103fa2 <exit+0xf7>
        wakeup1(initproc);
80103f91:	a1 34 63 19 80       	mov    0x80196334,%eax
80103f96:	83 ec 0c             	sub    $0xc,%esp
80103f99:	50                   	push   %eax
80103f9a:	e8 ed 03 00 00       	call   8010438c <wakeup1>
80103f9f:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa2:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80103fa9:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80103fb0:	72 bd                	jb     80103f6f <exit+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fb5:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80103fbc:	e8 eb 01 00 00       	call   801041ac <sched>
  panic("zombie exit");
80103fc1:	83 ec 0c             	sub    $0xc,%esp
80103fc4:	68 df a5 10 80       	push   $0x8010a5df
80103fc9:	e8 db c5 ff ff       	call   801005a9 <panic>

80103fce <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103fce:	55                   	push   %ebp
80103fcf:	89 e5                	mov    %esp,%ebp
80103fd1:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103fd4:	e8 57 fa ff ff       	call   80103a30 <myproc>
80103fd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80103fdc:	83 ec 0c             	sub    $0xc,%esp
80103fdf:	68 00 42 19 80       	push   $0x80194200
80103fe4:	e8 84 09 00 00       	call   8010496d <acquire>
80103fe9:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103fec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ff3:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80103ffa:	e9 a4 00 00 00       	jmp    801040a3 <wait+0xd5>
      if(p->parent != curproc)
80103fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104002:	8b 40 14             	mov    0x14(%eax),%eax
80104005:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104008:	0f 85 8d 00 00 00    	jne    8010409b <wait+0xcd>
        continue;
      havekids = 1;
8010400e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104015:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104018:	8b 40 0c             	mov    0xc(%eax),%eax
8010401b:	83 f8 05             	cmp    $0x5,%eax
8010401e:	75 7c                	jne    8010409c <wait+0xce>
        // Found one.
        pid = p->pid;
80104020:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104023:	8b 40 10             	mov    0x10(%eax),%eax
80104026:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104029:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010402c:	8b 40 08             	mov    0x8(%eax),%eax
8010402f:	83 ec 0c             	sub    $0xc,%esp
80104032:	50                   	push   %eax
80104033:	e8 d6 e6 ff ff       	call   8010270e <kfree>
80104038:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
8010403b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010403e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104045:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104048:	8b 40 04             	mov    0x4(%eax),%eax
8010404b:	83 ec 0c             	sub    $0xc,%esp
8010404e:	50                   	push   %eax
8010404f:	e8 44 3b 00 00       	call   80107b98 <freevm>
80104054:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104057:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010405a:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104064:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010406b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406e:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104075:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
8010407c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010407f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104086:	83 ec 0c             	sub    $0xc,%esp
80104089:	68 00 42 19 80       	push   $0x80194200
8010408e:	e8 48 09 00 00       	call   801049db <release>
80104093:	83 c4 10             	add    $0x10,%esp
        return pid;
80104096:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104099:	eb 54                	jmp    801040ef <wait+0x121>
        continue;
8010409b:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010409c:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801040a3:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
801040aa:	0f 82 4f ff ff ff    	jb     80103fff <wait+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801040b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801040b4:	74 0a                	je     801040c0 <wait+0xf2>
801040b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801040b9:	8b 40 24             	mov    0x24(%eax),%eax
801040bc:	85 c0                	test   %eax,%eax
801040be:	74 17                	je     801040d7 <wait+0x109>
      release(&ptable.lock);
801040c0:	83 ec 0c             	sub    $0xc,%esp
801040c3:	68 00 42 19 80       	push   $0x80194200
801040c8:	e8 0e 09 00 00       	call   801049db <release>
801040cd:	83 c4 10             	add    $0x10,%esp
      return -1;
801040d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040d5:	eb 18                	jmp    801040ef <wait+0x121>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040d7:	83 ec 08             	sub    $0x8,%esp
801040da:	68 00 42 19 80       	push   $0x80194200
801040df:	ff 75 ec             	push   -0x14(%ebp)
801040e2:	e8 fe 01 00 00       	call   801042e5 <sleep>
801040e7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040ea:	e9 fd fe ff ff       	jmp    80103fec <wait+0x1e>
  }
}
801040ef:	c9                   	leave
801040f0:	c3                   	ret

801040f1 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801040f1:	55                   	push   %ebp
801040f2:	89 e5                	mov    %esp,%ebp
801040f4:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801040f7:	e8 bc f8 ff ff       	call   801039b8 <mycpu>
801040fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
801040ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104102:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104109:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
8010410c:	e8 67 f8 ff ff       	call   80103978 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104111:	83 ec 0c             	sub    $0xc,%esp
80104114:	68 00 42 19 80       	push   $0x80194200
80104119:	e8 4f 08 00 00       	call   8010496d <acquire>
8010411e:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104121:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104128:	eb 64                	jmp    8010418e <scheduler+0x9d>
      if(p->state != RUNNABLE)
8010412a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010412d:	8b 40 0c             	mov    0xc(%eax),%eax
80104130:	83 f8 03             	cmp    $0x3,%eax
80104133:	75 51                	jne    80104186 <scheduler+0x95>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104135:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104138:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010413b:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104141:	83 ec 0c             	sub    $0xc,%esp
80104144:	ff 75 f4             	push   -0xc(%ebp)
80104147:	e8 a7 35 00 00       	call   801076f3 <switchuvm>
8010414c:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
8010414f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104152:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010415c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010415f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104162:	83 c2 04             	add    $0x4,%edx
80104165:	83 ec 08             	sub    $0x8,%esp
80104168:	50                   	push   %eax
80104169:	52                   	push   %edx
8010416a:	e8 e9 0c 00 00       	call   80104e58 <swtch>
8010416f:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104172:	e8 63 35 00 00       	call   801076da <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104177:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010417a:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104181:	00 00 00 
80104184:	eb 01                	jmp    80104187 <scheduler+0x96>
        continue;
80104186:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104187:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
8010418e:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80104195:	72 93                	jb     8010412a <scheduler+0x39>
    }
    release(&ptable.lock);
80104197:	83 ec 0c             	sub    $0xc,%esp
8010419a:	68 00 42 19 80       	push   $0x80194200
8010419f:	e8 37 08 00 00       	call   801049db <release>
801041a4:	83 c4 10             	add    $0x10,%esp
    sti();
801041a7:	e9 60 ff ff ff       	jmp    8010410c <scheduler+0x1b>

801041ac <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
801041ac:	55                   	push   %ebp
801041ad:	89 e5                	mov    %esp,%ebp
801041af:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
801041b2:	e8 79 f8 ff ff       	call   80103a30 <myproc>
801041b7:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
801041ba:	83 ec 0c             	sub    $0xc,%esp
801041bd:	68 00 42 19 80       	push   $0x80194200
801041c2:	e8 e1 08 00 00       	call   80104aa8 <holding>
801041c7:	83 c4 10             	add    $0x10,%esp
801041ca:	85 c0                	test   %eax,%eax
801041cc:	75 0d                	jne    801041db <sched+0x2f>
    panic("sched ptable.lock");
801041ce:	83 ec 0c             	sub    $0xc,%esp
801041d1:	68 eb a5 10 80       	push   $0x8010a5eb
801041d6:	e8 ce c3 ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli != 1)
801041db:	e8 d8 f7 ff ff       	call   801039b8 <mycpu>
801041e0:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801041e6:	83 f8 01             	cmp    $0x1,%eax
801041e9:	74 0d                	je     801041f8 <sched+0x4c>
    panic("sched locks");
801041eb:	83 ec 0c             	sub    $0xc,%esp
801041ee:	68 fd a5 10 80       	push   $0x8010a5fd
801041f3:	e8 b1 c3 ff ff       	call   801005a9 <panic>
  if(p->state == RUNNING)
801041f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041fb:	8b 40 0c             	mov    0xc(%eax),%eax
801041fe:	83 f8 04             	cmp    $0x4,%eax
80104201:	75 0d                	jne    80104210 <sched+0x64>
    panic("sched running");
80104203:	83 ec 0c             	sub    $0xc,%esp
80104206:	68 09 a6 10 80       	push   $0x8010a609
8010420b:	e8 99 c3 ff ff       	call   801005a9 <panic>
  if(readeflags()&FL_IF)
80104210:	e8 53 f7 ff ff       	call   80103968 <readeflags>
80104215:	25 00 02 00 00       	and    $0x200,%eax
8010421a:	85 c0                	test   %eax,%eax
8010421c:	74 0d                	je     8010422b <sched+0x7f>
    panic("sched interruptible");
8010421e:	83 ec 0c             	sub    $0xc,%esp
80104221:	68 17 a6 10 80       	push   $0x8010a617
80104226:	e8 7e c3 ff ff       	call   801005a9 <panic>
  intena = mycpu()->intena;
8010422b:	e8 88 f7 ff ff       	call   801039b8 <mycpu>
80104230:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104236:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104239:	e8 7a f7 ff ff       	call   801039b8 <mycpu>
8010423e:	8b 40 04             	mov    0x4(%eax),%eax
80104241:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104244:	83 c2 1c             	add    $0x1c,%edx
80104247:	83 ec 08             	sub    $0x8,%esp
8010424a:	50                   	push   %eax
8010424b:	52                   	push   %edx
8010424c:	e8 07 0c 00 00       	call   80104e58 <swtch>
80104251:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104254:	e8 5f f7 ff ff       	call   801039b8 <mycpu>
80104259:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010425c:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104262:	90                   	nop
80104263:	c9                   	leave
80104264:	c3                   	ret

80104265 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104265:	55                   	push   %ebp
80104266:	89 e5                	mov    %esp,%ebp
80104268:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010426b:	83 ec 0c             	sub    $0xc,%esp
8010426e:	68 00 42 19 80       	push   $0x80194200
80104273:	e8 f5 06 00 00       	call   8010496d <acquire>
80104278:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
8010427b:	e8 b0 f7 ff ff       	call   80103a30 <myproc>
80104280:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104287:	e8 20 ff ff ff       	call   801041ac <sched>
  release(&ptable.lock);
8010428c:	83 ec 0c             	sub    $0xc,%esp
8010428f:	68 00 42 19 80       	push   $0x80194200
80104294:	e8 42 07 00 00       	call   801049db <release>
80104299:	83 c4 10             	add    $0x10,%esp
}
8010429c:	90                   	nop
8010429d:	c9                   	leave
8010429e:	c3                   	ret

8010429f <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010429f:	55                   	push   %ebp
801042a0:	89 e5                	mov    %esp,%ebp
801042a2:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801042a5:	83 ec 0c             	sub    $0xc,%esp
801042a8:	68 00 42 19 80       	push   $0x80194200
801042ad:	e8 29 07 00 00       	call   801049db <release>
801042b2:	83 c4 10             	add    $0x10,%esp

  if (first) {
801042b5:	a1 04 f0 10 80       	mov    0x8010f004,%eax
801042ba:	85 c0                	test   %eax,%eax
801042bc:	74 24                	je     801042e2 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801042be:	c7 05 04 f0 10 80 00 	movl   $0x0,0x8010f004
801042c5:	00 00 00 
    iinit(ROOTDEV);
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	6a 01                	push   $0x1
801042cd:	e8 af d3 ff ff       	call   80101681 <iinit>
801042d2:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
801042d5:	83 ec 0c             	sub    $0xc,%esp
801042d8:	6a 01                	push   $0x1
801042da:	e8 40 eb ff ff       	call   80102e1f <initlog>
801042df:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801042e2:	90                   	nop
801042e3:	c9                   	leave
801042e4:	c3                   	ret

801042e5 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801042e5:	55                   	push   %ebp
801042e6:	89 e5                	mov    %esp,%ebp
801042e8:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
801042eb:	e8 40 f7 ff ff       	call   80103a30 <myproc>
801042f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
801042f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042f7:	75 0d                	jne    80104306 <sleep+0x21>
    panic("sleep");
801042f9:	83 ec 0c             	sub    $0xc,%esp
801042fc:	68 2b a6 10 80       	push   $0x8010a62b
80104301:	e8 a3 c2 ff ff       	call   801005a9 <panic>

  if(lk == 0)
80104306:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010430a:	75 0d                	jne    80104319 <sleep+0x34>
    panic("sleep without lk");
8010430c:	83 ec 0c             	sub    $0xc,%esp
8010430f:	68 31 a6 10 80       	push   $0x8010a631
80104314:	e8 90 c2 ff ff       	call   801005a9 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104319:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
80104320:	74 1e                	je     80104340 <sleep+0x5b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104322:	83 ec 0c             	sub    $0xc,%esp
80104325:	68 00 42 19 80       	push   $0x80194200
8010432a:	e8 3e 06 00 00       	call   8010496d <acquire>
8010432f:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104332:	83 ec 0c             	sub    $0xc,%esp
80104335:	ff 75 0c             	push   0xc(%ebp)
80104338:	e8 9e 06 00 00       	call   801049db <release>
8010433d:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80104340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104343:	8b 55 08             	mov    0x8(%ebp),%edx
80104346:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104353:	e8 54 fe ff ff       	call   801041ac <sched>

  // Tidy up.
  p->chan = 0;
80104358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010435b:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104362:	81 7d 0c 00 42 19 80 	cmpl   $0x80194200,0xc(%ebp)
80104369:	74 1e                	je     80104389 <sleep+0xa4>
    release(&ptable.lock);
8010436b:	83 ec 0c             	sub    $0xc,%esp
8010436e:	68 00 42 19 80       	push   $0x80194200
80104373:	e8 63 06 00 00       	call   801049db <release>
80104378:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
8010437b:	83 ec 0c             	sub    $0xc,%esp
8010437e:	ff 75 0c             	push   0xc(%ebp)
80104381:	e8 e7 05 00 00       	call   8010496d <acquire>
80104386:	83 c4 10             	add    $0x10,%esp
  }
}
80104389:	90                   	nop
8010438a:	c9                   	leave
8010438b:	c3                   	ret

8010438c <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
8010438c:	55                   	push   %ebp
8010438d:	89 e5                	mov    %esp,%ebp
8010438f:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104392:	c7 45 fc 34 42 19 80 	movl   $0x80194234,-0x4(%ebp)
80104399:	eb 27                	jmp    801043c2 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
8010439b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010439e:	8b 40 0c             	mov    0xc(%eax),%eax
801043a1:	83 f8 02             	cmp    $0x2,%eax
801043a4:	75 15                	jne    801043bb <wakeup1+0x2f>
801043a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801043a9:	8b 40 20             	mov    0x20(%eax),%eax
801043ac:	39 45 08             	cmp    %eax,0x8(%ebp)
801043af:	75 0a                	jne    801043bb <wakeup1+0x2f>
      p->state = RUNNABLE;
801043b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801043b4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043bb:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
801043c2:	81 7d fc 34 63 19 80 	cmpl   $0x80196334,-0x4(%ebp)
801043c9:	72 d0                	jb     8010439b <wakeup1+0xf>
}
801043cb:	90                   	nop
801043cc:	90                   	nop
801043cd:	c9                   	leave
801043ce:	c3                   	ret

801043cf <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043cf:	55                   	push   %ebp
801043d0:	89 e5                	mov    %esp,%ebp
801043d2:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
801043d5:	83 ec 0c             	sub    $0xc,%esp
801043d8:	68 00 42 19 80       	push   $0x80194200
801043dd:	e8 8b 05 00 00       	call   8010496d <acquire>
801043e2:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
801043e5:	83 ec 0c             	sub    $0xc,%esp
801043e8:	ff 75 08             	push   0x8(%ebp)
801043eb:	e8 9c ff ff ff       	call   8010438c <wakeup1>
801043f0:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801043f3:	83 ec 0c             	sub    $0xc,%esp
801043f6:	68 00 42 19 80       	push   $0x80194200
801043fb:	e8 db 05 00 00       	call   801049db <release>
80104400:	83 c4 10             	add    $0x10,%esp
}
80104403:	90                   	nop
80104404:	c9                   	leave
80104405:	c3                   	ret

80104406 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104406:	55                   	push   %ebp
80104407:	89 e5                	mov    %esp,%ebp
80104409:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010440c:	83 ec 0c             	sub    $0xc,%esp
8010440f:	68 00 42 19 80       	push   $0x80194200
80104414:	e8 54 05 00 00       	call   8010496d <acquire>
80104419:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010441c:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
80104423:	eb 48                	jmp    8010446d <kill+0x67>
    if(p->pid == pid){
80104425:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104428:	8b 40 10             	mov    0x10(%eax),%eax
8010442b:	39 45 08             	cmp    %eax,0x8(%ebp)
8010442e:	75 36                	jne    80104466 <kill+0x60>
      p->killed = 1;
80104430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104433:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010443a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010443d:	8b 40 0c             	mov    0xc(%eax),%eax
80104440:	83 f8 02             	cmp    $0x2,%eax
80104443:	75 0a                	jne    8010444f <kill+0x49>
        p->state = RUNNABLE;
80104445:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104448:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010444f:	83 ec 0c             	sub    $0xc,%esp
80104452:	68 00 42 19 80       	push   $0x80194200
80104457:	e8 7f 05 00 00       	call   801049db <release>
8010445c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010445f:	b8 00 00 00 00       	mov    $0x0,%eax
80104464:	eb 25                	jmp    8010448b <kill+0x85>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104466:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
8010446d:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
80104474:	72 af                	jb     80104425 <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104476:	83 ec 0c             	sub    $0xc,%esp
80104479:	68 00 42 19 80       	push   $0x80194200
8010447e:	e8 58 05 00 00       	call   801049db <release>
80104483:	83 c4 10             	add    $0x10,%esp
  return -1;
80104486:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010448b:	c9                   	leave
8010448c:	c3                   	ret

8010448d <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010448d:	55                   	push   %ebp
8010448e:	89 e5                	mov    %esp,%ebp
80104490:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104493:	c7 45 f0 34 42 19 80 	movl   $0x80194234,-0x10(%ebp)
8010449a:	e9 da 00 00 00       	jmp    80104579 <procdump+0xec>
    if(p->state == UNUSED)
8010449f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044a2:	8b 40 0c             	mov    0xc(%eax),%eax
801044a5:	85 c0                	test   %eax,%eax
801044a7:	0f 84 c4 00 00 00    	je     80104571 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044b0:	8b 40 0c             	mov    0xc(%eax),%eax
801044b3:	83 f8 05             	cmp    $0x5,%eax
801044b6:	77 23                	ja     801044db <procdump+0x4e>
801044b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044bb:	8b 40 0c             	mov    0xc(%eax),%eax
801044be:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
801044c5:	85 c0                	test   %eax,%eax
801044c7:	74 12                	je     801044db <procdump+0x4e>
      state = states[p->state];
801044c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044cc:	8b 40 0c             	mov    0xc(%eax),%eax
801044cf:	8b 04 85 08 f0 10 80 	mov    -0x7fef0ff8(,%eax,4),%eax
801044d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801044d9:	eb 07                	jmp    801044e2 <procdump+0x55>
    else
      state = "???";
801044db:	c7 45 ec 42 a6 10 80 	movl   $0x8010a642,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
801044e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044e5:	8d 50 6c             	lea    0x6c(%eax),%edx
801044e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044eb:	8b 40 10             	mov    0x10(%eax),%eax
801044ee:	52                   	push   %edx
801044ef:	ff 75 ec             	push   -0x14(%ebp)
801044f2:	50                   	push   %eax
801044f3:	68 46 a6 10 80       	push   $0x8010a646
801044f8:	e8 f7 be ff ff       	call   801003f4 <cprintf>
801044fd:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104500:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104503:	8b 40 0c             	mov    0xc(%eax),%eax
80104506:	83 f8 02             	cmp    $0x2,%eax
80104509:	75 54                	jne    8010455f <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010450b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010450e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104511:	8b 40 0c             	mov    0xc(%eax),%eax
80104514:	83 c0 08             	add    $0x8,%eax
80104517:	89 c2                	mov    %eax,%edx
80104519:	83 ec 08             	sub    $0x8,%esp
8010451c:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010451f:	50                   	push   %eax
80104520:	52                   	push   %edx
80104521:	e8 07 05 00 00       	call   80104a2d <getcallerpcs>
80104526:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104529:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104530:	eb 1c                	jmp    8010454e <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104532:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104535:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104539:	83 ec 08             	sub    $0x8,%esp
8010453c:	50                   	push   %eax
8010453d:	68 4f a6 10 80       	push   $0x8010a64f
80104542:	e8 ad be ff ff       	call   801003f4 <cprintf>
80104547:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010454a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010454e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104552:	7f 0b                	jg     8010455f <procdump+0xd2>
80104554:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104557:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010455b:	85 c0                	test   %eax,%eax
8010455d:	75 d3                	jne    80104532 <procdump+0xa5>
    }
    cprintf("\n");
8010455f:	83 ec 0c             	sub    $0xc,%esp
80104562:	68 53 a6 10 80       	push   $0x8010a653
80104567:	e8 88 be ff ff       	call   801003f4 <cprintf>
8010456c:	83 c4 10             	add    $0x10,%esp
8010456f:	eb 01                	jmp    80104572 <procdump+0xe5>
      continue;
80104571:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104572:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104579:	81 7d f0 34 63 19 80 	cmpl   $0x80196334,-0x10(%ebp)
80104580:	0f 82 19 ff ff ff    	jb     8010449f <procdump+0x12>
  }
}
80104586:	90                   	nop
80104587:	90                   	nop
80104588:	c9                   	leave
80104589:	c3                   	ret

8010458a <exit2>:

void
exit2(int status)
{
8010458a:	55                   	push   %ebp
8010458b:	89 e5                	mov    %esp,%ebp
8010458d:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104590:	e8 9b f4 ff ff       	call   80103a30 <myproc>
80104595:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80104598:	a1 34 63 19 80       	mov    0x80196334,%eax
8010459d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801045a0:	75 0d                	jne    801045af <exit2+0x25>
    panic("init exiting");
801045a2:	83 ec 0c             	sub    $0xc,%esp
801045a5:	68 d2 a5 10 80       	push   $0x8010a5d2
801045aa:	e8 fa bf ff ff       	call   801005a9 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801045af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801045b6:	eb 3f                	jmp    801045f7 <exit2+0x6d>
    if(curproc->ofile[fd]){
801045b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045be:	83 c2 08             	add    $0x8,%edx
801045c1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045c5:	85 c0                	test   %eax,%eax
801045c7:	74 2a                	je     801045f3 <exit2+0x69>
      fileclose(curproc->ofile[fd]);
801045c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045cf:	83 c2 08             	add    $0x8,%edx
801045d2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045d6:	83 ec 0c             	sub    $0xc,%esp
801045d9:	50                   	push   %eax
801045da:	e8 c6 ca ff ff       	call   801010a5 <fileclose>
801045df:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
801045e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045e8:	83 c2 08             	add    $0x8,%edx
801045eb:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801045f2:	00 
  for(fd = 0; fd < NOFILE; fd++){
801045f3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801045f7:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801045fb:	7e bb                	jle    801045b8 <exit2+0x2e>
    }
  }

  begin_op();
801045fd:	e8 3c ea ff ff       	call   8010303e <begin_op>
  iput(curproc->cwd);
80104602:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104605:	8b 40 68             	mov    0x68(%eax),%eax
80104608:	83 ec 0c             	sub    $0xc,%esp
8010460b:	50                   	push   %eax
8010460c:	e8 42 d5 ff ff       	call   80101b53 <iput>
80104611:	83 c4 10             	add    $0x10,%esp
  end_op();
80104614:	e8 b1 ea ff ff       	call   801030ca <end_op>
  curproc->cwd = 0;
80104619:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010461c:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104623:	83 ec 0c             	sub    $0xc,%esp
80104626:	68 00 42 19 80       	push   $0x80194200
8010462b:	e8 3d 03 00 00       	call   8010496d <acquire>
80104630:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104633:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104636:	8b 40 14             	mov    0x14(%eax),%eax
80104639:	83 ec 0c             	sub    $0xc,%esp
8010463c:	50                   	push   %eax
8010463d:	e8 4a fd ff ff       	call   8010438c <wakeup1>
80104642:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104645:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
8010464c:	eb 3a                	jmp    80104688 <exit2+0xfe>
    if(p->parent == curproc){
8010464e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104651:	8b 40 14             	mov    0x14(%eax),%eax
80104654:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104657:	75 28                	jne    80104681 <exit2+0xf7>
      p->parent = initproc;
80104659:	8b 15 34 63 19 80    	mov    0x80196334,%edx
8010465f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104662:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104665:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104668:	8b 40 0c             	mov    0xc(%eax),%eax
8010466b:	83 f8 05             	cmp    $0x5,%eax
8010466e:	75 11                	jne    80104681 <exit2+0xf7>
        wakeup1(initproc);
80104670:	a1 34 63 19 80       	mov    0x80196334,%eax
80104675:	83 ec 0c             	sub    $0xc,%esp
80104678:	50                   	push   %eax
80104679:	e8 0e fd ff ff       	call   8010438c <wakeup1>
8010467e:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104681:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104688:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
8010468f:	72 bd                	jb     8010464e <exit2+0xc4>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->xstate = status;
80104691:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104694:	8b 55 08             	mov    0x8(%ebp),%edx
80104697:	89 50 7c             	mov    %edx,0x7c(%eax)
  curproc->state = ZOMBIE;
8010469a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010469d:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801046a4:	e8 03 fb ff ff       	call   801041ac <sched>
  panic("zombie exit");
801046a9:	83 ec 0c             	sub    $0xc,%esp
801046ac:	68 df a5 10 80       	push   $0x8010a5df
801046b1:	e8 f3 be ff ff       	call   801005a9 <panic>

801046b6 <wait2>:
}

int
wait2(int *status)
{
801046b6:	55                   	push   %ebp
801046b7:	89 e5                	mov    %esp,%ebp
801046b9:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
801046bc:	e8 6f f3 ff ff       	call   80103a30 <myproc>
801046c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
801046c4:	83 ec 0c             	sub    $0xc,%esp
801046c7:	68 00 42 19 80       	push   $0x80194200
801046cc:	e8 9c 02 00 00       	call   8010496d <acquire>
801046d1:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801046d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046db:	c7 45 f4 34 42 19 80 	movl   $0x80194234,-0xc(%ebp)
801046e2:	e9 b9 00 00 00       	jmp    801047a0 <wait2+0xea>
      if(p->parent != curproc)
801046e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ea:	8b 40 14             	mov    0x14(%eax),%eax
801046ed:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801046f0:	0f 85 a2 00 00 00    	jne    80104798 <wait2+0xe2>
        continue;
      havekids = 1;
801046f6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801046fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104700:	8b 40 0c             	mov    0xc(%eax),%eax
80104703:	83 f8 05             	cmp    $0x5,%eax
80104706:	0f 85 8d 00 00 00    	jne    80104799 <wait2+0xe3>
        // Found one.
        pid = p->pid;
8010470c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010470f:	8b 40 10             	mov    0x10(%eax),%eax
80104712:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104718:	8b 40 08             	mov    0x8(%eax),%eax
8010471b:	83 ec 0c             	sub    $0xc,%esp
8010471e:	50                   	push   %eax
8010471f:	e8 ea df ff ff       	call   8010270e <kfree>
80104724:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010472a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104731:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104734:	8b 40 04             	mov    0x4(%eax),%eax
80104737:	83 ec 0c             	sub    $0xc,%esp
8010473a:	50                   	push   %eax
8010473b:	e8 58 34 00 00       	call   80107b98 <freevm>
80104740:	83 c4 10             	add    $0x10,%esp

        if(status != 0)
80104743:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104747:	74 0b                	je     80104754 <wait2+0x9e>
          *status = p->xstate;
80104749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474c:	8b 50 7c             	mov    0x7c(%eax),%edx
8010474f:	8b 45 08             	mov    0x8(%ebp),%eax
80104752:	89 10                	mov    %edx,(%eax)

        p->pid = 0;
80104754:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104757:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010475e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104761:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104768:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010476f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104772:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010477c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104783:	83 ec 0c             	sub    $0xc,%esp
80104786:	68 00 42 19 80       	push   $0x80194200
8010478b:	e8 4b 02 00 00       	call   801049db <release>
80104790:	83 c4 10             	add    $0x10,%esp
        return pid;
80104793:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104796:	eb 54                	jmp    801047ec <wait2+0x136>
        continue;
80104798:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104799:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801047a0:	81 7d f4 34 63 19 80 	cmpl   $0x80196334,-0xc(%ebp)
801047a7:	0f 82 3a ff ff ff    	jb     801046e7 <wait2+0x31>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801047ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801047b1:	74 0a                	je     801047bd <wait2+0x107>
801047b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047b6:	8b 40 24             	mov    0x24(%eax),%eax
801047b9:	85 c0                	test   %eax,%eax
801047bb:	74 17                	je     801047d4 <wait2+0x11e>
      release(&ptable.lock);
801047bd:	83 ec 0c             	sub    $0xc,%esp
801047c0:	68 00 42 19 80       	push   $0x80194200
801047c5:	e8 11 02 00 00       	call   801049db <release>
801047ca:	83 c4 10             	add    $0x10,%esp
      return -1;
801047cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047d2:	eb 18                	jmp    801047ec <wait2+0x136>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801047d4:	83 ec 08             	sub    $0x8,%esp
801047d7:	68 00 42 19 80       	push   $0x80194200
801047dc:	ff 75 ec             	push   -0x14(%ebp)
801047df:	e8 01 fb ff ff       	call   801042e5 <sleep>
801047e4:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801047e7:	e9 e8 fe ff ff       	jmp    801046d4 <wait2+0x1e>
  }
}
801047ec:	c9                   	leave
801047ed:	c3                   	ret

801047ee <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801047ee:	55                   	push   %ebp
801047ef:	89 e5                	mov    %esp,%ebp
801047f1:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
801047f4:	8b 45 08             	mov    0x8(%ebp),%eax
801047f7:	83 c0 04             	add    $0x4,%eax
801047fa:	83 ec 08             	sub    $0x8,%esp
801047fd:	68 7f a6 10 80       	push   $0x8010a67f
80104802:	50                   	push   %eax
80104803:	e8 43 01 00 00       	call   8010494b <initlock>
80104808:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
8010480b:	8b 45 08             	mov    0x8(%ebp),%eax
8010480e:	8b 55 0c             	mov    0xc(%ebp),%edx
80104811:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104814:	8b 45 08             	mov    0x8(%ebp),%eax
80104817:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010481d:	8b 45 08             	mov    0x8(%ebp),%eax
80104820:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104827:	90                   	nop
80104828:	c9                   	leave
80104829:	c3                   	ret

8010482a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
8010482a:	55                   	push   %ebp
8010482b:	89 e5                	mov    %esp,%ebp
8010482d:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104830:	8b 45 08             	mov    0x8(%ebp),%eax
80104833:	83 c0 04             	add    $0x4,%eax
80104836:	83 ec 0c             	sub    $0xc,%esp
80104839:	50                   	push   %eax
8010483a:	e8 2e 01 00 00       	call   8010496d <acquire>
8010483f:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104842:	eb 15                	jmp    80104859 <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80104844:	8b 45 08             	mov    0x8(%ebp),%eax
80104847:	83 c0 04             	add    $0x4,%eax
8010484a:	83 ec 08             	sub    $0x8,%esp
8010484d:	50                   	push   %eax
8010484e:	ff 75 08             	push   0x8(%ebp)
80104851:	e8 8f fa ff ff       	call   801042e5 <sleep>
80104856:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80104859:	8b 45 08             	mov    0x8(%ebp),%eax
8010485c:	8b 00                	mov    (%eax),%eax
8010485e:	85 c0                	test   %eax,%eax
80104860:	75 e2                	jne    80104844 <acquiresleep+0x1a>
  }
  lk->locked = 1;
80104862:	8b 45 08             	mov    0x8(%ebp),%eax
80104865:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
8010486b:	e8 c0 f1 ff ff       	call   80103a30 <myproc>
80104870:	8b 50 10             	mov    0x10(%eax),%edx
80104873:	8b 45 08             	mov    0x8(%ebp),%eax
80104876:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104879:	8b 45 08             	mov    0x8(%ebp),%eax
8010487c:	83 c0 04             	add    $0x4,%eax
8010487f:	83 ec 0c             	sub    $0xc,%esp
80104882:	50                   	push   %eax
80104883:	e8 53 01 00 00       	call   801049db <release>
80104888:	83 c4 10             	add    $0x10,%esp
}
8010488b:	90                   	nop
8010488c:	c9                   	leave
8010488d:	c3                   	ret

8010488e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
8010488e:	55                   	push   %ebp
8010488f:	89 e5                	mov    %esp,%ebp
80104891:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80104894:	8b 45 08             	mov    0x8(%ebp),%eax
80104897:	83 c0 04             	add    $0x4,%eax
8010489a:	83 ec 0c             	sub    $0xc,%esp
8010489d:	50                   	push   %eax
8010489e:	e8 ca 00 00 00       	call   8010496d <acquire>
801048a3:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
801048a6:	8b 45 08             	mov    0x8(%ebp),%eax
801048a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801048af:	8b 45 08             	mov    0x8(%ebp),%eax
801048b2:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
801048b9:	83 ec 0c             	sub    $0xc,%esp
801048bc:	ff 75 08             	push   0x8(%ebp)
801048bf:	e8 0b fb ff ff       	call   801043cf <wakeup>
801048c4:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
801048c7:	8b 45 08             	mov    0x8(%ebp),%eax
801048ca:	83 c0 04             	add    $0x4,%eax
801048cd:	83 ec 0c             	sub    $0xc,%esp
801048d0:	50                   	push   %eax
801048d1:	e8 05 01 00 00       	call   801049db <release>
801048d6:	83 c4 10             	add    $0x10,%esp
}
801048d9:	90                   	nop
801048da:	c9                   	leave
801048db:	c3                   	ret

801048dc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801048dc:	55                   	push   %ebp
801048dd:	89 e5                	mov    %esp,%ebp
801048df:	83 ec 18             	sub    $0x18,%esp
  int r;
  
  acquire(&lk->lk);
801048e2:	8b 45 08             	mov    0x8(%ebp),%eax
801048e5:	83 c0 04             	add    $0x4,%eax
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	50                   	push   %eax
801048ec:	e8 7c 00 00 00       	call   8010496d <acquire>
801048f1:	83 c4 10             	add    $0x10,%esp
  r = lk->locked;
801048f4:	8b 45 08             	mov    0x8(%ebp),%eax
801048f7:	8b 00                	mov    (%eax),%eax
801048f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
801048fc:	8b 45 08             	mov    0x8(%ebp),%eax
801048ff:	83 c0 04             	add    $0x4,%eax
80104902:	83 ec 0c             	sub    $0xc,%esp
80104905:	50                   	push   %eax
80104906:	e8 d0 00 00 00       	call   801049db <release>
8010490b:	83 c4 10             	add    $0x10,%esp
  return r;
8010490e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104911:	c9                   	leave
80104912:	c3                   	ret

80104913 <readeflags>:
{
80104913:	55                   	push   %ebp
80104914:	89 e5                	mov    %esp,%ebp
80104916:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104919:	9c                   	pushf
8010491a:	58                   	pop    %eax
8010491b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010491e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104921:	c9                   	leave
80104922:	c3                   	ret

80104923 <cli>:
{
80104923:	55                   	push   %ebp
80104924:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104926:	fa                   	cli
}
80104927:	90                   	nop
80104928:	5d                   	pop    %ebp
80104929:	c3                   	ret

8010492a <sti>:
{
8010492a:	55                   	push   %ebp
8010492b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010492d:	fb                   	sti
}
8010492e:	90                   	nop
8010492f:	5d                   	pop    %ebp
80104930:	c3                   	ret

80104931 <xchg>:
{
80104931:	55                   	push   %ebp
80104932:	89 e5                	mov    %esp,%ebp
80104934:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80104937:	8b 55 08             	mov    0x8(%ebp),%edx
8010493a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010493d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104940:	f0 87 02             	lock xchg %eax,(%edx)
80104943:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80104946:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104949:	c9                   	leave
8010494a:	c3                   	ret

8010494b <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010494b:	55                   	push   %ebp
8010494c:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010494e:	8b 45 08             	mov    0x8(%ebp),%eax
80104951:	8b 55 0c             	mov    0xc(%ebp),%edx
80104954:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104957:	8b 45 08             	mov    0x8(%ebp),%eax
8010495a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104960:	8b 45 08             	mov    0x8(%ebp),%eax
80104963:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010496a:	90                   	nop
8010496b:	5d                   	pop    %ebp
8010496c:	c3                   	ret

8010496d <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010496d:	55                   	push   %ebp
8010496e:	89 e5                	mov    %esp,%ebp
80104970:	53                   	push   %ebx
80104971:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104974:	e8 5f 01 00 00       	call   80104ad8 <pushcli>
  if(holding(lk)){
80104979:	8b 45 08             	mov    0x8(%ebp),%eax
8010497c:	83 ec 0c             	sub    $0xc,%esp
8010497f:	50                   	push   %eax
80104980:	e8 23 01 00 00       	call   80104aa8 <holding>
80104985:	83 c4 10             	add    $0x10,%esp
80104988:	85 c0                	test   %eax,%eax
8010498a:	74 0d                	je     80104999 <acquire+0x2c>
    panic("acquire");
8010498c:	83 ec 0c             	sub    $0xc,%esp
8010498f:	68 8a a6 10 80       	push   $0x8010a68a
80104994:	e8 10 bc ff ff       	call   801005a9 <panic>
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104999:	90                   	nop
8010499a:	8b 45 08             	mov    0x8(%ebp),%eax
8010499d:	83 ec 08             	sub    $0x8,%esp
801049a0:	6a 01                	push   $0x1
801049a2:	50                   	push   %eax
801049a3:	e8 89 ff ff ff       	call   80104931 <xchg>
801049a8:	83 c4 10             	add    $0x10,%esp
801049ab:	85 c0                	test   %eax,%eax
801049ad:	75 eb                	jne    8010499a <acquire+0x2d>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801049af:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801049b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049b7:	e8 fc ef ff ff       	call   801039b8 <mycpu>
801049bc:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801049bf:	8b 45 08             	mov    0x8(%ebp),%eax
801049c2:	83 c0 0c             	add    $0xc,%eax
801049c5:	83 ec 08             	sub    $0x8,%esp
801049c8:	50                   	push   %eax
801049c9:	8d 45 08             	lea    0x8(%ebp),%eax
801049cc:	50                   	push   %eax
801049cd:	e8 5b 00 00 00       	call   80104a2d <getcallerpcs>
801049d2:	83 c4 10             	add    $0x10,%esp
}
801049d5:	90                   	nop
801049d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049d9:	c9                   	leave
801049da:	c3                   	ret

801049db <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801049db:	55                   	push   %ebp
801049dc:	89 e5                	mov    %esp,%ebp
801049de:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801049e1:	83 ec 0c             	sub    $0xc,%esp
801049e4:	ff 75 08             	push   0x8(%ebp)
801049e7:	e8 bc 00 00 00       	call   80104aa8 <holding>
801049ec:	83 c4 10             	add    $0x10,%esp
801049ef:	85 c0                	test   %eax,%eax
801049f1:	75 0d                	jne    80104a00 <release+0x25>
    panic("release");
801049f3:	83 ec 0c             	sub    $0xc,%esp
801049f6:	68 92 a6 10 80       	push   $0x8010a692
801049fb:	e8 a9 bb ff ff       	call   801005a9 <panic>

  lk->pcs[0] = 0;
80104a00:	8b 45 08             	mov    0x8(%ebp),%eax
80104a03:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104a0a:	8b 45 08             	mov    0x8(%ebp),%eax
80104a0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104a14:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a19:	8b 45 08             	mov    0x8(%ebp),%eax
80104a1c:	8b 55 08             	mov    0x8(%ebp),%edx
80104a1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104a25:	e8 fb 00 00 00       	call   80104b25 <popcli>
}
80104a2a:	90                   	nop
80104a2b:	c9                   	leave
80104a2c:	c3                   	ret

80104a2d <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a2d:	55                   	push   %ebp
80104a2e:	89 e5                	mov    %esp,%ebp
80104a30:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a33:	8b 45 08             	mov    0x8(%ebp),%eax
80104a36:	83 e8 08             	sub    $0x8,%eax
80104a39:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104a3c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104a43:	eb 38                	jmp    80104a7d <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a45:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104a49:	74 53                	je     80104a9e <getcallerpcs+0x71>
80104a4b:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104a52:	76 4a                	jbe    80104a9e <getcallerpcs+0x71>
80104a54:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104a58:	74 44                	je     80104a9e <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104a5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104a64:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a67:	01 c2                	add    %eax,%edx
80104a69:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a6c:	8b 40 04             	mov    0x4(%eax),%eax
80104a6f:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104a71:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a74:	8b 00                	mov    (%eax),%eax
80104a76:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104a79:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104a7d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104a81:	7e c2                	jle    80104a45 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80104a83:	eb 19                	jmp    80104a9e <getcallerpcs+0x71>
    pcs[i] = 0;
80104a85:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104a88:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a92:	01 d0                	add    %edx,%eax
80104a94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104a9a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104a9e:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104aa2:	7e e1                	jle    80104a85 <getcallerpcs+0x58>
}
80104aa4:	90                   	nop
80104aa5:	90                   	nop
80104aa6:	c9                   	leave
80104aa7:	c3                   	ret

80104aa8 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104aa8:	55                   	push   %ebp
80104aa9:	89 e5                	mov    %esp,%ebp
80104aab:	53                   	push   %ebx
80104aac:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80104ab2:	8b 00                	mov    (%eax),%eax
80104ab4:	85 c0                	test   %eax,%eax
80104ab6:	74 16                	je     80104ace <holding+0x26>
80104ab8:	8b 45 08             	mov    0x8(%ebp),%eax
80104abb:	8b 58 08             	mov    0x8(%eax),%ebx
80104abe:	e8 f5 ee ff ff       	call   801039b8 <mycpu>
80104ac3:	39 c3                	cmp    %eax,%ebx
80104ac5:	75 07                	jne    80104ace <holding+0x26>
80104ac7:	b8 01 00 00 00       	mov    $0x1,%eax
80104acc:	eb 05                	jmp    80104ad3 <holding+0x2b>
80104ace:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ad3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad6:	c9                   	leave
80104ad7:	c3                   	ret

80104ad8 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ad8:	55                   	push   %ebp
80104ad9:	89 e5                	mov    %esp,%ebp
80104adb:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104ade:	e8 30 fe ff ff       	call   80104913 <readeflags>
80104ae3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104ae6:	e8 38 fe ff ff       	call   80104923 <cli>
  if(mycpu()->ncli == 0)
80104aeb:	e8 c8 ee ff ff       	call   801039b8 <mycpu>
80104af0:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104af6:	85 c0                	test   %eax,%eax
80104af8:	75 14                	jne    80104b0e <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104afa:	e8 b9 ee ff ff       	call   801039b8 <mycpu>
80104aff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b02:	81 e2 00 02 00 00    	and    $0x200,%edx
80104b08:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b0e:	e8 a5 ee ff ff       	call   801039b8 <mycpu>
80104b13:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b19:	83 c2 01             	add    $0x1,%edx
80104b1c:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104b22:	90                   	nop
80104b23:	c9                   	leave
80104b24:	c3                   	ret

80104b25 <popcli>:

void
popcli(void)
{
80104b25:	55                   	push   %ebp
80104b26:	89 e5                	mov    %esp,%ebp
80104b28:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104b2b:	e8 e3 fd ff ff       	call   80104913 <readeflags>
80104b30:	25 00 02 00 00       	and    $0x200,%eax
80104b35:	85 c0                	test   %eax,%eax
80104b37:	74 0d                	je     80104b46 <popcli+0x21>
    panic("popcli - interruptible");
80104b39:	83 ec 0c             	sub    $0xc,%esp
80104b3c:	68 9a a6 10 80       	push   $0x8010a69a
80104b41:	e8 63 ba ff ff       	call   801005a9 <panic>
  if(--mycpu()->ncli < 0)
80104b46:	e8 6d ee ff ff       	call   801039b8 <mycpu>
80104b4b:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b51:	83 ea 01             	sub    $0x1,%edx
80104b54:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104b5a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b60:	85 c0                	test   %eax,%eax
80104b62:	79 0d                	jns    80104b71 <popcli+0x4c>
    panic("popcli");
80104b64:	83 ec 0c             	sub    $0xc,%esp
80104b67:	68 b1 a6 10 80       	push   $0x8010a6b1
80104b6c:	e8 38 ba ff ff       	call   801005a9 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b71:	e8 42 ee ff ff       	call   801039b8 <mycpu>
80104b76:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b7c:	85 c0                	test   %eax,%eax
80104b7e:	75 14                	jne    80104b94 <popcli+0x6f>
80104b80:	e8 33 ee ff ff       	call   801039b8 <mycpu>
80104b85:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b8b:	85 c0                	test   %eax,%eax
80104b8d:	74 05                	je     80104b94 <popcli+0x6f>
    sti();
80104b8f:	e8 96 fd ff ff       	call   8010492a <sti>
}
80104b94:	90                   	nop
80104b95:	c9                   	leave
80104b96:	c3                   	ret

80104b97 <stosb>:
{
80104b97:	55                   	push   %ebp
80104b98:	89 e5                	mov    %esp,%ebp
80104b9a:	57                   	push   %edi
80104b9b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104b9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b9f:	8b 55 10             	mov    0x10(%ebp),%edx
80104ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ba5:	89 cb                	mov    %ecx,%ebx
80104ba7:	89 df                	mov    %ebx,%edi
80104ba9:	89 d1                	mov    %edx,%ecx
80104bab:	fc                   	cld
80104bac:	f3 aa                	rep stos %al,%es:(%edi)
80104bae:	89 ca                	mov    %ecx,%edx
80104bb0:	89 fb                	mov    %edi,%ebx
80104bb2:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104bb5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104bb8:	90                   	nop
80104bb9:	5b                   	pop    %ebx
80104bba:	5f                   	pop    %edi
80104bbb:	5d                   	pop    %ebp
80104bbc:	c3                   	ret

80104bbd <stosl>:
{
80104bbd:	55                   	push   %ebp
80104bbe:	89 e5                	mov    %esp,%ebp
80104bc0:	57                   	push   %edi
80104bc1:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104bc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bc5:	8b 55 10             	mov    0x10(%ebp),%edx
80104bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bcb:	89 cb                	mov    %ecx,%ebx
80104bcd:	89 df                	mov    %ebx,%edi
80104bcf:	89 d1                	mov    %edx,%ecx
80104bd1:	fc                   	cld
80104bd2:	f3 ab                	rep stos %eax,%es:(%edi)
80104bd4:	89 ca                	mov    %ecx,%edx
80104bd6:	89 fb                	mov    %edi,%ebx
80104bd8:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104bdb:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104bde:	90                   	nop
80104bdf:	5b                   	pop    %ebx
80104be0:	5f                   	pop    %edi
80104be1:	5d                   	pop    %ebp
80104be2:	c3                   	ret

80104be3 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104be3:	55                   	push   %ebp
80104be4:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80104be6:	8b 45 08             	mov    0x8(%ebp),%eax
80104be9:	83 e0 03             	and    $0x3,%eax
80104bec:	85 c0                	test   %eax,%eax
80104bee:	75 43                	jne    80104c33 <memset+0x50>
80104bf0:	8b 45 10             	mov    0x10(%ebp),%eax
80104bf3:	83 e0 03             	and    $0x3,%eax
80104bf6:	85 c0                	test   %eax,%eax
80104bf8:	75 39                	jne    80104c33 <memset+0x50>
    c &= 0xFF;
80104bfa:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104c01:	8b 45 10             	mov    0x10(%ebp),%eax
80104c04:	c1 e8 02             	shr    $0x2,%eax
80104c07:	89 c1                	mov    %eax,%ecx
80104c09:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c0c:	c1 e0 18             	shl    $0x18,%eax
80104c0f:	89 c2                	mov    %eax,%edx
80104c11:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c14:	c1 e0 10             	shl    $0x10,%eax
80104c17:	09 c2                	or     %eax,%edx
80104c19:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c1c:	c1 e0 08             	shl    $0x8,%eax
80104c1f:	09 d0                	or     %edx,%eax
80104c21:	0b 45 0c             	or     0xc(%ebp),%eax
80104c24:	51                   	push   %ecx
80104c25:	50                   	push   %eax
80104c26:	ff 75 08             	push   0x8(%ebp)
80104c29:	e8 8f ff ff ff       	call   80104bbd <stosl>
80104c2e:	83 c4 0c             	add    $0xc,%esp
80104c31:	eb 12                	jmp    80104c45 <memset+0x62>
  } else
    stosb(dst, c, n);
80104c33:	8b 45 10             	mov    0x10(%ebp),%eax
80104c36:	50                   	push   %eax
80104c37:	ff 75 0c             	push   0xc(%ebp)
80104c3a:	ff 75 08             	push   0x8(%ebp)
80104c3d:	e8 55 ff ff ff       	call   80104b97 <stosb>
80104c42:	83 c4 0c             	add    $0xc,%esp
  return dst;
80104c45:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104c48:	c9                   	leave
80104c49:	c3                   	ret

80104c4a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c4a:	55                   	push   %ebp
80104c4b:	89 e5                	mov    %esp,%ebp
80104c4d:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80104c50:	8b 45 08             	mov    0x8(%ebp),%eax
80104c53:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104c56:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c59:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104c5c:	eb 2e                	jmp    80104c8c <memcmp+0x42>
    if(*s1 != *s2)
80104c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c61:	0f b6 10             	movzbl (%eax),%edx
80104c64:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c67:	0f b6 00             	movzbl (%eax),%eax
80104c6a:	38 c2                	cmp    %al,%dl
80104c6c:	74 16                	je     80104c84 <memcmp+0x3a>
      return *s1 - *s2;
80104c6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c71:	0f b6 00             	movzbl (%eax),%eax
80104c74:	0f b6 d0             	movzbl %al,%edx
80104c77:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c7a:	0f b6 00             	movzbl (%eax),%eax
80104c7d:	0f b6 c0             	movzbl %al,%eax
80104c80:	29 c2                	sub    %eax,%edx
80104c82:	eb 1a                	jmp    80104c9e <memcmp+0x54>
    s1++, s2++;
80104c84:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104c88:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
80104c8c:	8b 45 10             	mov    0x10(%ebp),%eax
80104c8f:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c92:	89 55 10             	mov    %edx,0x10(%ebp)
80104c95:	85 c0                	test   %eax,%eax
80104c97:	75 c5                	jne    80104c5e <memcmp+0x14>
  }

  return 0;
80104c99:	ba 00 00 00 00       	mov    $0x0,%edx
}
80104c9e:	89 d0                	mov    %edx,%eax
80104ca0:	c9                   	leave
80104ca1:	c3                   	ret

80104ca2 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ca2:	55                   	push   %ebp
80104ca3:	89 e5                	mov    %esp,%ebp
80104ca5:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104cae:	8b 45 08             	mov    0x8(%ebp),%eax
80104cb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104cb7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104cba:	73 54                	jae    80104d10 <memmove+0x6e>
80104cbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104cbf:	8b 45 10             	mov    0x10(%ebp),%eax
80104cc2:	01 d0                	add    %edx,%eax
80104cc4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80104cc7:	73 47                	jae    80104d10 <memmove+0x6e>
    s += n;
80104cc9:	8b 45 10             	mov    0x10(%ebp),%eax
80104ccc:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104ccf:	8b 45 10             	mov    0x10(%ebp),%eax
80104cd2:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104cd5:	eb 13                	jmp    80104cea <memmove+0x48>
      *--d = *--s;
80104cd7:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104cdb:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104cdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ce2:	0f b6 10             	movzbl (%eax),%edx
80104ce5:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ce8:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104cea:	8b 45 10             	mov    0x10(%ebp),%eax
80104ced:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cf0:	89 55 10             	mov    %edx,0x10(%ebp)
80104cf3:	85 c0                	test   %eax,%eax
80104cf5:	75 e0                	jne    80104cd7 <memmove+0x35>
  if(s < d && s + n > d){
80104cf7:	eb 24                	jmp    80104d1d <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
80104cf9:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104cfc:	8d 42 01             	lea    0x1(%edx),%eax
80104cff:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104d02:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d05:	8d 48 01             	lea    0x1(%eax),%ecx
80104d08:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104d0b:	0f b6 12             	movzbl (%edx),%edx
80104d0e:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104d10:	8b 45 10             	mov    0x10(%ebp),%eax
80104d13:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d16:	89 55 10             	mov    %edx,0x10(%ebp)
80104d19:	85 c0                	test   %eax,%eax
80104d1b:	75 dc                	jne    80104cf9 <memmove+0x57>

  return dst;
80104d1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104d20:	c9                   	leave
80104d21:	c3                   	ret

80104d22 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104d22:	55                   	push   %ebp
80104d23:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80104d25:	ff 75 10             	push   0x10(%ebp)
80104d28:	ff 75 0c             	push   0xc(%ebp)
80104d2b:	ff 75 08             	push   0x8(%ebp)
80104d2e:	e8 6f ff ff ff       	call   80104ca2 <memmove>
80104d33:	83 c4 0c             	add    $0xc,%esp
}
80104d36:	c9                   	leave
80104d37:	c3                   	ret

80104d38 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104d38:	55                   	push   %ebp
80104d39:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104d3b:	eb 0c                	jmp    80104d49 <strncmp+0x11>
    n--, p++, q++;
80104d3d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104d41:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104d45:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80104d49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d4d:	74 1a                	je     80104d69 <strncmp+0x31>
80104d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80104d52:	0f b6 00             	movzbl (%eax),%eax
80104d55:	84 c0                	test   %al,%al
80104d57:	74 10                	je     80104d69 <strncmp+0x31>
80104d59:	8b 45 08             	mov    0x8(%ebp),%eax
80104d5c:	0f b6 10             	movzbl (%eax),%edx
80104d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d62:	0f b6 00             	movzbl (%eax),%eax
80104d65:	38 c2                	cmp    %al,%dl
80104d67:	74 d4                	je     80104d3d <strncmp+0x5>
  if(n == 0)
80104d69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104d6d:	75 07                	jne    80104d76 <strncmp+0x3e>
    return 0;
80104d6f:	ba 00 00 00 00       	mov    $0x0,%edx
80104d74:	eb 14                	jmp    80104d8a <strncmp+0x52>
  return (uchar)*p - (uchar)*q;
80104d76:	8b 45 08             	mov    0x8(%ebp),%eax
80104d79:	0f b6 00             	movzbl (%eax),%eax
80104d7c:	0f b6 d0             	movzbl %al,%edx
80104d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d82:	0f b6 00             	movzbl (%eax),%eax
80104d85:	0f b6 c0             	movzbl %al,%eax
80104d88:	29 c2                	sub    %eax,%edx
}
80104d8a:	89 d0                	mov    %edx,%eax
80104d8c:	5d                   	pop    %ebp
80104d8d:	c3                   	ret

80104d8e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104d8e:	55                   	push   %ebp
80104d8f:	89 e5                	mov    %esp,%ebp
80104d91:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80104d94:	8b 45 08             	mov    0x8(%ebp),%eax
80104d97:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80104d9a:	90                   	nop
80104d9b:	8b 45 10             	mov    0x10(%ebp),%eax
80104d9e:	8d 50 ff             	lea    -0x1(%eax),%edx
80104da1:	89 55 10             	mov    %edx,0x10(%ebp)
80104da4:	85 c0                	test   %eax,%eax
80104da6:	7e 2c                	jle    80104dd4 <strncpy+0x46>
80104da8:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dab:	8d 42 01             	lea    0x1(%edx),%eax
80104dae:	89 45 0c             	mov    %eax,0xc(%ebp)
80104db1:	8b 45 08             	mov    0x8(%ebp),%eax
80104db4:	8d 48 01             	lea    0x1(%eax),%ecx
80104db7:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104dba:	0f b6 12             	movzbl (%edx),%edx
80104dbd:	88 10                	mov    %dl,(%eax)
80104dbf:	0f b6 00             	movzbl (%eax),%eax
80104dc2:	84 c0                	test   %al,%al
80104dc4:	75 d5                	jne    80104d9b <strncpy+0xd>
    ;
  while(n-- > 0)
80104dc6:	eb 0c                	jmp    80104dd4 <strncpy+0x46>
    *s++ = 0;
80104dc8:	8b 45 08             	mov    0x8(%ebp),%eax
80104dcb:	8d 50 01             	lea    0x1(%eax),%edx
80104dce:	89 55 08             	mov    %edx,0x8(%ebp)
80104dd1:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80104dd4:	8b 45 10             	mov    0x10(%ebp),%eax
80104dd7:	8d 50 ff             	lea    -0x1(%eax),%edx
80104dda:	89 55 10             	mov    %edx,0x10(%ebp)
80104ddd:	85 c0                	test   %eax,%eax
80104ddf:	7f e7                	jg     80104dc8 <strncpy+0x3a>
  return os;
80104de1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104de4:	c9                   	leave
80104de5:	c3                   	ret

80104de6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104de6:	55                   	push   %ebp
80104de7:	89 e5                	mov    %esp,%ebp
80104de9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80104dec:	8b 45 08             	mov    0x8(%ebp),%eax
80104def:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80104df2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104df6:	7f 05                	jg     80104dfd <safestrcpy+0x17>
    return os;
80104df8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dfb:	eb 32                	jmp    80104e2f <safestrcpy+0x49>
  while(--n > 0 && (*s++ = *t++) != 0)
80104dfd:	90                   	nop
80104dfe:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104e02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e06:	7e 1e                	jle    80104e26 <safestrcpy+0x40>
80104e08:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e0b:	8d 42 01             	lea    0x1(%edx),%eax
80104e0e:	89 45 0c             	mov    %eax,0xc(%ebp)
80104e11:	8b 45 08             	mov    0x8(%ebp),%eax
80104e14:	8d 48 01             	lea    0x1(%eax),%ecx
80104e17:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104e1a:	0f b6 12             	movzbl (%edx),%edx
80104e1d:	88 10                	mov    %dl,(%eax)
80104e1f:	0f b6 00             	movzbl (%eax),%eax
80104e22:	84 c0                	test   %al,%al
80104e24:	75 d8                	jne    80104dfe <safestrcpy+0x18>
    ;
  *s = 0;
80104e26:	8b 45 08             	mov    0x8(%ebp),%eax
80104e29:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80104e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104e2f:	c9                   	leave
80104e30:	c3                   	ret

80104e31 <strlen>:

int
strlen(const char *s)
{
80104e31:	55                   	push   %ebp
80104e32:	89 e5                	mov    %esp,%ebp
80104e34:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80104e37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104e3e:	eb 04                	jmp    80104e44 <strlen+0x13>
80104e40:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104e44:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e47:	8b 45 08             	mov    0x8(%ebp),%eax
80104e4a:	01 d0                	add    %edx,%eax
80104e4c:	0f b6 00             	movzbl (%eax),%eax
80104e4f:	84 c0                	test   %al,%al
80104e51:	75 ed                	jne    80104e40 <strlen+0xf>
    ;
  return n;
80104e53:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104e56:	c9                   	leave
80104e57:	c3                   	ret

80104e58 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e58:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e5c:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104e60:	55                   	push   %ebp
  pushl %ebx
80104e61:	53                   	push   %ebx
  pushl %esi
80104e62:	56                   	push   %esi
  pushl %edi
80104e63:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104e64:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e66:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104e68:	5f                   	pop    %edi
  popl %esi
80104e69:	5e                   	pop    %esi
  popl %ebx
80104e6a:	5b                   	pop    %ebx
  popl %ebp
80104e6b:	5d                   	pop    %ebp
  ret
80104e6c:	c3                   	ret

80104e6d <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e6d:	55                   	push   %ebp
80104e6e:	89 e5                	mov    %esp,%ebp
80104e70:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104e73:	e8 b8 eb ff ff       	call   80103a30 <myproc>
80104e78:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e7e:	8b 00                	mov    (%eax),%eax
80104e80:	39 45 08             	cmp    %eax,0x8(%ebp)
80104e83:	73 0f                	jae    80104e94 <fetchint+0x27>
80104e85:	8b 45 08             	mov    0x8(%ebp),%eax
80104e88:	8d 50 04             	lea    0x4(%eax),%edx
80104e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e8e:	8b 00                	mov    (%eax),%eax
80104e90:	39 d0                	cmp    %edx,%eax
80104e92:	73 07                	jae    80104e9b <fetchint+0x2e>
    return -1;
80104e94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e99:	eb 0f                	jmp    80104eaa <fetchint+0x3d>
  *ip = *(int*)(addr);
80104e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80104e9e:	8b 10                	mov    (%eax),%edx
80104ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ea3:	89 10                	mov    %edx,(%eax)
  return 0;
80104ea5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104eaa:	c9                   	leave
80104eab:	c3                   	ret

80104eac <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104eac:	55                   	push   %ebp
80104ead:	89 e5                	mov    %esp,%ebp
80104eaf:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80104eb2:	e8 79 eb ff ff       	call   80103a30 <myproc>
80104eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80104eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ebd:	8b 00                	mov    (%eax),%eax
80104ebf:	39 45 08             	cmp    %eax,0x8(%ebp)
80104ec2:	72 07                	jb     80104ecb <fetchstr+0x1f>
    return -1;
80104ec4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ec9:	eb 41                	jmp    80104f0c <fetchstr+0x60>
  *pp = (char*)addr;
80104ecb:	8b 55 08             	mov    0x8(%ebp),%edx
80104ece:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ed1:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80104ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ed6:	8b 00                	mov    (%eax),%eax
80104ed8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80104edb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ede:	8b 00                	mov    (%eax),%eax
80104ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104ee3:	eb 1a                	jmp    80104eff <fetchstr+0x53>
    if(*s == 0)
80104ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee8:	0f b6 00             	movzbl (%eax),%eax
80104eeb:	84 c0                	test   %al,%al
80104eed:	75 0c                	jne    80104efb <fetchstr+0x4f>
      return s - *pp;
80104eef:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ef2:	8b 10                	mov    (%eax),%edx
80104ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ef7:	29 d0                	sub    %edx,%eax
80104ef9:	eb 11                	jmp    80104f0c <fetchstr+0x60>
  for(s = *pp; s < ep; s++){
80104efb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f02:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104f05:	72 de                	jb     80104ee5 <fetchstr+0x39>
  }
  return -1;
80104f07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f0c:	c9                   	leave
80104f0d:	c3                   	ret

80104f0e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f0e:	55                   	push   %ebp
80104f0f:	89 e5                	mov    %esp,%ebp
80104f11:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f14:	e8 17 eb ff ff       	call   80103a30 <myproc>
80104f19:	8b 40 18             	mov    0x18(%eax),%eax
80104f1c:	8b 40 44             	mov    0x44(%eax),%eax
80104f1f:	8b 55 08             	mov    0x8(%ebp),%edx
80104f22:	c1 e2 02             	shl    $0x2,%edx
80104f25:	01 d0                	add    %edx,%eax
80104f27:	83 c0 04             	add    $0x4,%eax
80104f2a:	83 ec 08             	sub    $0x8,%esp
80104f2d:	ff 75 0c             	push   0xc(%ebp)
80104f30:	50                   	push   %eax
80104f31:	e8 37 ff ff ff       	call   80104e6d <fetchint>
80104f36:	83 c4 10             	add    $0x10,%esp
}
80104f39:	c9                   	leave
80104f3a:	c3                   	ret

80104f3b <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f3b:	55                   	push   %ebp
80104f3c:	89 e5                	mov    %esp,%ebp
80104f3e:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80104f41:	e8 ea ea ff ff       	call   80103a30 <myproc>
80104f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80104f49:	83 ec 08             	sub    $0x8,%esp
80104f4c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f4f:	50                   	push   %eax
80104f50:	ff 75 08             	push   0x8(%ebp)
80104f53:	e8 b6 ff ff ff       	call   80104f0e <argint>
80104f58:	83 c4 10             	add    $0x10,%esp
80104f5b:	85 c0                	test   %eax,%eax
80104f5d:	79 07                	jns    80104f66 <argptr+0x2b>
    return -1;
80104f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f64:	eb 3b                	jmp    80104fa1 <argptr+0x66>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f6a:	78 1f                	js     80104f8b <argptr+0x50>
80104f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f6f:	8b 00                	mov    (%eax),%eax
80104f71:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f74:	39 c2                	cmp    %eax,%edx
80104f76:	73 13                	jae    80104f8b <argptr+0x50>
80104f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f7b:	89 c2                	mov    %eax,%edx
80104f7d:	8b 45 10             	mov    0x10(%ebp),%eax
80104f80:	01 c2                	add    %eax,%edx
80104f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f85:	8b 00                	mov    (%eax),%eax
80104f87:	39 d0                	cmp    %edx,%eax
80104f89:	73 07                	jae    80104f92 <argptr+0x57>
    return -1;
80104f8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f90:	eb 0f                	jmp    80104fa1 <argptr+0x66>
  *pp = (char*)i;
80104f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f95:	89 c2                	mov    %eax,%edx
80104f97:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f9a:	89 10                	mov    %edx,(%eax)
  return 0;
80104f9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fa1:	c9                   	leave
80104fa2:	c3                   	ret

80104fa3 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104fa3:	55                   	push   %ebp
80104fa4:	89 e5                	mov    %esp,%ebp
80104fa6:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104fa9:	83 ec 08             	sub    $0x8,%esp
80104fac:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104faf:	50                   	push   %eax
80104fb0:	ff 75 08             	push   0x8(%ebp)
80104fb3:	e8 56 ff ff ff       	call   80104f0e <argint>
80104fb8:	83 c4 10             	add    $0x10,%esp
80104fbb:	85 c0                	test   %eax,%eax
80104fbd:	79 07                	jns    80104fc6 <argstr+0x23>
    return -1;
80104fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fc4:	eb 12                	jmp    80104fd8 <argstr+0x35>
  return fetchstr(addr, pp);
80104fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc9:	83 ec 08             	sub    $0x8,%esp
80104fcc:	ff 75 0c             	push   0xc(%ebp)
80104fcf:	50                   	push   %eax
80104fd0:	e8 d7 fe ff ff       	call   80104eac <fetchstr>
80104fd5:	83 c4 10             	add    $0x10,%esp
}
80104fd8:	c9                   	leave
80104fd9:	c3                   	ret

80104fda <syscall>:
[SYS_uthread_init] sys_uthread_init,
};

void
syscall(void)
{
80104fda:	55                   	push   %ebp
80104fdb:	89 e5                	mov    %esp,%ebp
80104fdd:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80104fe0:	e8 4b ea ff ff       	call   80103a30 <myproc>
80104fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80104fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104feb:	8b 40 18             	mov    0x18(%eax),%eax
80104fee:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ff4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104ff8:	7e 2f                	jle    80105029 <syscall+0x4f>
80104ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ffd:	83 f8 18             	cmp    $0x18,%eax
80105000:	77 27                	ja     80105029 <syscall+0x4f>
80105002:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105005:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
8010500c:	85 c0                	test   %eax,%eax
8010500e:	74 19                	je     80105029 <syscall+0x4f>
    curproc->tf->eax = syscalls[num]();
80105010:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105013:	8b 04 85 20 f0 10 80 	mov    -0x7fef0fe0(,%eax,4),%eax
8010501a:	ff d0                	call   *%eax
8010501c:	89 c2                	mov    %eax,%edx
8010501e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105021:	8b 40 18             	mov    0x18(%eax),%eax
80105024:	89 50 1c             	mov    %edx,0x1c(%eax)
80105027:	eb 2c                	jmp    80105055 <syscall+0x7b>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105029:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010502c:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
8010502f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105032:	8b 40 10             	mov    0x10(%eax),%eax
80105035:	ff 75 f0             	push   -0x10(%ebp)
80105038:	52                   	push   %edx
80105039:	50                   	push   %eax
8010503a:	68 b8 a6 10 80       	push   $0x8010a6b8
8010503f:	e8 b0 b3 ff ff       	call   801003f4 <cprintf>
80105044:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80105047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010504a:	8b 40 18             	mov    0x18(%eax),%eax
8010504d:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105054:	90                   	nop
80105055:	90                   	nop
80105056:	c9                   	leave
80105057:	c3                   	ret

80105058 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105058:	55                   	push   %ebp
80105059:	89 e5                	mov    %esp,%ebp
8010505b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010505e:	83 ec 08             	sub    $0x8,%esp
80105061:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105064:	50                   	push   %eax
80105065:	ff 75 08             	push   0x8(%ebp)
80105068:	e8 a1 fe ff ff       	call   80104f0e <argint>
8010506d:	83 c4 10             	add    $0x10,%esp
80105070:	85 c0                	test   %eax,%eax
80105072:	79 07                	jns    8010507b <argfd+0x23>
    return -1;
80105074:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105079:	eb 4f                	jmp    801050ca <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010507b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010507e:	85 c0                	test   %eax,%eax
80105080:	78 20                	js     801050a2 <argfd+0x4a>
80105082:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105085:	83 f8 0f             	cmp    $0xf,%eax
80105088:	7f 18                	jg     801050a2 <argfd+0x4a>
8010508a:	e8 a1 e9 ff ff       	call   80103a30 <myproc>
8010508f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105092:	83 c2 08             	add    $0x8,%edx
80105095:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105099:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010509c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801050a0:	75 07                	jne    801050a9 <argfd+0x51>
    return -1;
801050a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a7:	eb 21                	jmp    801050ca <argfd+0x72>
  if(pfd)
801050a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801050ad:	74 08                	je     801050b7 <argfd+0x5f>
    *pfd = fd;
801050af:	8b 55 f0             	mov    -0x10(%ebp),%edx
801050b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801050b5:	89 10                	mov    %edx,(%eax)
  if(pf)
801050b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050bb:	74 08                	je     801050c5 <argfd+0x6d>
    *pf = f;
801050bd:	8b 45 10             	mov    0x10(%ebp),%eax
801050c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050c3:	89 10                	mov    %edx,(%eax)
  return 0;
801050c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050ca:	c9                   	leave
801050cb:	c3                   	ret

801050cc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801050cc:	55                   	push   %ebp
801050cd:	89 e5                	mov    %esp,%ebp
801050cf:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801050d2:	e8 59 e9 ff ff       	call   80103a30 <myproc>
801050d7:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
801050da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801050e1:	eb 2a                	jmp    8010510d <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
801050e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050e9:	83 c2 08             	add    $0x8,%edx
801050ec:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801050f0:	85 c0                	test   %eax,%eax
801050f2:	75 15                	jne    80105109 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
801050f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050fa:	8d 4a 08             	lea    0x8(%edx),%ecx
801050fd:	8b 55 08             	mov    0x8(%ebp),%edx
80105100:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105104:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105107:	eb 0f                	jmp    80105118 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
80105109:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010510d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105111:	7e d0                	jle    801050e3 <fdalloc+0x17>
    }
  }
  return -1;
80105113:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105118:	c9                   	leave
80105119:	c3                   	ret

8010511a <sys_dup>:

int
sys_dup(void)
{
8010511a:	55                   	push   %ebp
8010511b:	89 e5                	mov    %esp,%ebp
8010511d:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105120:	83 ec 04             	sub    $0x4,%esp
80105123:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105126:	50                   	push   %eax
80105127:	6a 00                	push   $0x0
80105129:	6a 00                	push   $0x0
8010512b:	e8 28 ff ff ff       	call   80105058 <argfd>
80105130:	83 c4 10             	add    $0x10,%esp
80105133:	85 c0                	test   %eax,%eax
80105135:	79 07                	jns    8010513e <sys_dup+0x24>
    return -1;
80105137:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010513c:	eb 31                	jmp    8010516f <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010513e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105141:	83 ec 0c             	sub    $0xc,%esp
80105144:	50                   	push   %eax
80105145:	e8 82 ff ff ff       	call   801050cc <fdalloc>
8010514a:	83 c4 10             	add    $0x10,%esp
8010514d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105150:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105154:	79 07                	jns    8010515d <sys_dup+0x43>
    return -1;
80105156:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010515b:	eb 12                	jmp    8010516f <sys_dup+0x55>
  filedup(f);
8010515d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105160:	83 ec 0c             	sub    $0xc,%esp
80105163:	50                   	push   %eax
80105164:	e8 eb be ff ff       	call   80101054 <filedup>
80105169:	83 c4 10             	add    $0x10,%esp
  return fd;
8010516c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010516f:	c9                   	leave
80105170:	c3                   	ret

80105171 <sys_read>:

int
sys_read(void)
{
80105171:	55                   	push   %ebp
80105172:	89 e5                	mov    %esp,%ebp
80105174:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105177:	83 ec 04             	sub    $0x4,%esp
8010517a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010517d:	50                   	push   %eax
8010517e:	6a 00                	push   $0x0
80105180:	6a 00                	push   $0x0
80105182:	e8 d1 fe ff ff       	call   80105058 <argfd>
80105187:	83 c4 10             	add    $0x10,%esp
8010518a:	85 c0                	test   %eax,%eax
8010518c:	78 2e                	js     801051bc <sys_read+0x4b>
8010518e:	83 ec 08             	sub    $0x8,%esp
80105191:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105194:	50                   	push   %eax
80105195:	6a 02                	push   $0x2
80105197:	e8 72 fd ff ff       	call   80104f0e <argint>
8010519c:	83 c4 10             	add    $0x10,%esp
8010519f:	85 c0                	test   %eax,%eax
801051a1:	78 19                	js     801051bc <sys_read+0x4b>
801051a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051a6:	83 ec 04             	sub    $0x4,%esp
801051a9:	50                   	push   %eax
801051aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051ad:	50                   	push   %eax
801051ae:	6a 01                	push   $0x1
801051b0:	e8 86 fd ff ff       	call   80104f3b <argptr>
801051b5:	83 c4 10             	add    $0x10,%esp
801051b8:	85 c0                	test   %eax,%eax
801051ba:	79 07                	jns    801051c3 <sys_read+0x52>
    return -1;
801051bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c1:	eb 17                	jmp    801051da <sys_read+0x69>
  return fileread(f, p, n);
801051c3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801051c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051cc:	83 ec 04             	sub    $0x4,%esp
801051cf:	51                   	push   %ecx
801051d0:	52                   	push   %edx
801051d1:	50                   	push   %eax
801051d2:	e8 0d c0 ff ff       	call   801011e4 <fileread>
801051d7:	83 c4 10             	add    $0x10,%esp
}
801051da:	c9                   	leave
801051db:	c3                   	ret

801051dc <sys_write>:

int
sys_write(void)
{
801051dc:	55                   	push   %ebp
801051dd:	89 e5                	mov    %esp,%ebp
801051df:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051e2:	83 ec 04             	sub    $0x4,%esp
801051e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051e8:	50                   	push   %eax
801051e9:	6a 00                	push   $0x0
801051eb:	6a 00                	push   $0x0
801051ed:	e8 66 fe ff ff       	call   80105058 <argfd>
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	85 c0                	test   %eax,%eax
801051f7:	78 2e                	js     80105227 <sys_write+0x4b>
801051f9:	83 ec 08             	sub    $0x8,%esp
801051fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051ff:	50                   	push   %eax
80105200:	6a 02                	push   $0x2
80105202:	e8 07 fd ff ff       	call   80104f0e <argint>
80105207:	83 c4 10             	add    $0x10,%esp
8010520a:	85 c0                	test   %eax,%eax
8010520c:	78 19                	js     80105227 <sys_write+0x4b>
8010520e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105211:	83 ec 04             	sub    $0x4,%esp
80105214:	50                   	push   %eax
80105215:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105218:	50                   	push   %eax
80105219:	6a 01                	push   $0x1
8010521b:	e8 1b fd ff ff       	call   80104f3b <argptr>
80105220:	83 c4 10             	add    $0x10,%esp
80105223:	85 c0                	test   %eax,%eax
80105225:	79 07                	jns    8010522e <sys_write+0x52>
    return -1;
80105227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010522c:	eb 17                	jmp    80105245 <sys_write+0x69>
  return filewrite(f, p, n);
8010522e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105231:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105237:	83 ec 04             	sub    $0x4,%esp
8010523a:	51                   	push   %ecx
8010523b:	52                   	push   %edx
8010523c:	50                   	push   %eax
8010523d:	e8 5a c0 ff ff       	call   8010129c <filewrite>
80105242:	83 c4 10             	add    $0x10,%esp
}
80105245:	c9                   	leave
80105246:	c3                   	ret

80105247 <sys_close>:

int
sys_close(void)
{
80105247:	55                   	push   %ebp
80105248:	89 e5                	mov    %esp,%ebp
8010524a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010524d:	83 ec 04             	sub    $0x4,%esp
80105250:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105253:	50                   	push   %eax
80105254:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105257:	50                   	push   %eax
80105258:	6a 00                	push   $0x0
8010525a:	e8 f9 fd ff ff       	call   80105058 <argfd>
8010525f:	83 c4 10             	add    $0x10,%esp
80105262:	85 c0                	test   %eax,%eax
80105264:	79 07                	jns    8010526d <sys_close+0x26>
    return -1;
80105266:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010526b:	eb 27                	jmp    80105294 <sys_close+0x4d>
  myproc()->ofile[fd] = 0;
8010526d:	e8 be e7 ff ff       	call   80103a30 <myproc>
80105272:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105275:	83 c2 08             	add    $0x8,%edx
80105278:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010527f:	00 
  fileclose(f);
80105280:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105283:	83 ec 0c             	sub    $0xc,%esp
80105286:	50                   	push   %eax
80105287:	e8 19 be ff ff       	call   801010a5 <fileclose>
8010528c:	83 c4 10             	add    $0x10,%esp
  return 0;
8010528f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105294:	c9                   	leave
80105295:	c3                   	ret

80105296 <sys_fstat>:

int
sys_fstat(void)
{
80105296:	55                   	push   %ebp
80105297:	89 e5                	mov    %esp,%ebp
80105299:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010529c:	83 ec 04             	sub    $0x4,%esp
8010529f:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a2:	50                   	push   %eax
801052a3:	6a 00                	push   $0x0
801052a5:	6a 00                	push   $0x0
801052a7:	e8 ac fd ff ff       	call   80105058 <argfd>
801052ac:	83 c4 10             	add    $0x10,%esp
801052af:	85 c0                	test   %eax,%eax
801052b1:	78 17                	js     801052ca <sys_fstat+0x34>
801052b3:	83 ec 04             	sub    $0x4,%esp
801052b6:	6a 14                	push   $0x14
801052b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052bb:	50                   	push   %eax
801052bc:	6a 01                	push   $0x1
801052be:	e8 78 fc ff ff       	call   80104f3b <argptr>
801052c3:	83 c4 10             	add    $0x10,%esp
801052c6:	85 c0                	test   %eax,%eax
801052c8:	79 07                	jns    801052d1 <sys_fstat+0x3b>
    return -1;
801052ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052cf:	eb 13                	jmp    801052e4 <sys_fstat+0x4e>
  return filestat(f, st);
801052d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801052d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052d7:	83 ec 08             	sub    $0x8,%esp
801052da:	52                   	push   %edx
801052db:	50                   	push   %eax
801052dc:	e8 ac be ff ff       	call   8010118d <filestat>
801052e1:	83 c4 10             	add    $0x10,%esp
}
801052e4:	c9                   	leave
801052e5:	c3                   	ret

801052e6 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801052e6:	55                   	push   %ebp
801052e7:	89 e5                	mov    %esp,%ebp
801052e9:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052ec:	83 ec 08             	sub    $0x8,%esp
801052ef:	8d 45 d8             	lea    -0x28(%ebp),%eax
801052f2:	50                   	push   %eax
801052f3:	6a 00                	push   $0x0
801052f5:	e8 a9 fc ff ff       	call   80104fa3 <argstr>
801052fa:	83 c4 10             	add    $0x10,%esp
801052fd:	85 c0                	test   %eax,%eax
801052ff:	78 15                	js     80105316 <sys_link+0x30>
80105301:	83 ec 08             	sub    $0x8,%esp
80105304:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105307:	50                   	push   %eax
80105308:	6a 01                	push   $0x1
8010530a:	e8 94 fc ff ff       	call   80104fa3 <argstr>
8010530f:	83 c4 10             	add    $0x10,%esp
80105312:	85 c0                	test   %eax,%eax
80105314:	79 0a                	jns    80105320 <sys_link+0x3a>
    return -1;
80105316:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531b:	e9 68 01 00 00       	jmp    80105488 <sys_link+0x1a2>

  begin_op();
80105320:	e8 19 dd ff ff       	call   8010303e <begin_op>
  if((ip = namei(old)) == 0){
80105325:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105328:	83 ec 0c             	sub    $0xc,%esp
8010532b:	50                   	push   %eax
8010532c:	e8 f4 d1 ff ff       	call   80102525 <namei>
80105331:	83 c4 10             	add    $0x10,%esp
80105334:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105337:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010533b:	75 0f                	jne    8010534c <sys_link+0x66>
    end_op();
8010533d:	e8 88 dd ff ff       	call   801030ca <end_op>
    return -1;
80105342:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105347:	e9 3c 01 00 00       	jmp    80105488 <sys_link+0x1a2>
  }

  ilock(ip);
8010534c:	83 ec 0c             	sub    $0xc,%esp
8010534f:	ff 75 f4             	push   -0xc(%ebp)
80105352:	e8 9b c6 ff ff       	call   801019f2 <ilock>
80105357:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010535a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010535d:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105361:	66 83 f8 01          	cmp    $0x1,%ax
80105365:	75 1d                	jne    80105384 <sys_link+0x9e>
    iunlockput(ip);
80105367:	83 ec 0c             	sub    $0xc,%esp
8010536a:	ff 75 f4             	push   -0xc(%ebp)
8010536d:	e8 b1 c8 ff ff       	call   80101c23 <iunlockput>
80105372:	83 c4 10             	add    $0x10,%esp
    end_op();
80105375:	e8 50 dd ff ff       	call   801030ca <end_op>
    return -1;
8010537a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010537f:	e9 04 01 00 00       	jmp    80105488 <sys_link+0x1a2>
  }

  ip->nlink++;
80105384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105387:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010538b:	83 c0 01             	add    $0x1,%eax
8010538e:	89 c2                	mov    %eax,%edx
80105390:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105393:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105397:	83 ec 0c             	sub    $0xc,%esp
8010539a:	ff 75 f4             	push   -0xc(%ebp)
8010539d:	e8 73 c4 ff ff       	call   80101815 <iupdate>
801053a2:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801053a5:	83 ec 0c             	sub    $0xc,%esp
801053a8:	ff 75 f4             	push   -0xc(%ebp)
801053ab:	e8 55 c7 ff ff       	call   80101b05 <iunlock>
801053b0:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801053b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801053b6:	83 ec 08             	sub    $0x8,%esp
801053b9:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801053bc:	52                   	push   %edx
801053bd:	50                   	push   %eax
801053be:	e8 7e d1 ff ff       	call   80102541 <nameiparent>
801053c3:	83 c4 10             	add    $0x10,%esp
801053c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801053c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801053cd:	74 71                	je     80105440 <sys_link+0x15a>
    goto bad;
  ilock(dp);
801053cf:	83 ec 0c             	sub    $0xc,%esp
801053d2:	ff 75 f0             	push   -0x10(%ebp)
801053d5:	e8 18 c6 ff ff       	call   801019f2 <ilock>
801053da:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053e0:	8b 10                	mov    (%eax),%edx
801053e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e5:	8b 00                	mov    (%eax),%eax
801053e7:	39 c2                	cmp    %eax,%edx
801053e9:	75 1d                	jne    80105408 <sys_link+0x122>
801053eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ee:	8b 40 04             	mov    0x4(%eax),%eax
801053f1:	83 ec 04             	sub    $0x4,%esp
801053f4:	50                   	push   %eax
801053f5:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801053f8:	50                   	push   %eax
801053f9:	ff 75 f0             	push   -0x10(%ebp)
801053fc:	e8 8d ce ff ff       	call   8010228e <dirlink>
80105401:	83 c4 10             	add    $0x10,%esp
80105404:	85 c0                	test   %eax,%eax
80105406:	79 10                	jns    80105418 <sys_link+0x132>
    iunlockput(dp);
80105408:	83 ec 0c             	sub    $0xc,%esp
8010540b:	ff 75 f0             	push   -0x10(%ebp)
8010540e:	e8 10 c8 ff ff       	call   80101c23 <iunlockput>
80105413:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105416:	eb 29                	jmp    80105441 <sys_link+0x15b>
  }
  iunlockput(dp);
80105418:	83 ec 0c             	sub    $0xc,%esp
8010541b:	ff 75 f0             	push   -0x10(%ebp)
8010541e:	e8 00 c8 ff ff       	call   80101c23 <iunlockput>
80105423:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105426:	83 ec 0c             	sub    $0xc,%esp
80105429:	ff 75 f4             	push   -0xc(%ebp)
8010542c:	e8 22 c7 ff ff       	call   80101b53 <iput>
80105431:	83 c4 10             	add    $0x10,%esp

  end_op();
80105434:	e8 91 dc ff ff       	call   801030ca <end_op>

  return 0;
80105439:	b8 00 00 00 00       	mov    $0x0,%eax
8010543e:	eb 48                	jmp    80105488 <sys_link+0x1a2>
    goto bad;
80105440:	90                   	nop

bad:
  ilock(ip);
80105441:	83 ec 0c             	sub    $0xc,%esp
80105444:	ff 75 f4             	push   -0xc(%ebp)
80105447:	e8 a6 c5 ff ff       	call   801019f2 <ilock>
8010544c:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010544f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105452:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105456:	83 e8 01             	sub    $0x1,%eax
80105459:	89 c2                	mov    %eax,%edx
8010545b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010545e:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105462:	83 ec 0c             	sub    $0xc,%esp
80105465:	ff 75 f4             	push   -0xc(%ebp)
80105468:	e8 a8 c3 ff ff       	call   80101815 <iupdate>
8010546d:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	ff 75 f4             	push   -0xc(%ebp)
80105476:	e8 a8 c7 ff ff       	call   80101c23 <iunlockput>
8010547b:	83 c4 10             	add    $0x10,%esp
  end_op();
8010547e:	e8 47 dc ff ff       	call   801030ca <end_op>
  return -1;
80105483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105488:	c9                   	leave
80105489:	c3                   	ret

8010548a <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010548a:	55                   	push   %ebp
8010548b:	89 e5                	mov    %esp,%ebp
8010548d:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105490:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105497:	eb 40                	jmp    801054d9 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105499:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010549c:	6a 10                	push   $0x10
8010549e:	50                   	push   %eax
8010549f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054a2:	50                   	push   %eax
801054a3:	ff 75 08             	push   0x8(%ebp)
801054a6:	e8 33 ca ff ff       	call   80101ede <readi>
801054ab:	83 c4 10             	add    $0x10,%esp
801054ae:	83 f8 10             	cmp    $0x10,%eax
801054b1:	74 0d                	je     801054c0 <isdirempty+0x36>
      panic("isdirempty: readi");
801054b3:	83 ec 0c             	sub    $0xc,%esp
801054b6:	68 d4 a6 10 80       	push   $0x8010a6d4
801054bb:	e8 e9 b0 ff ff       	call   801005a9 <panic>
    if(de.inum != 0)
801054c0:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801054c4:	66 85 c0             	test   %ax,%ax
801054c7:	74 07                	je     801054d0 <isdirempty+0x46>
      return 0;
801054c9:	b8 00 00 00 00       	mov    $0x0,%eax
801054ce:	eb 1b                	jmp    801054eb <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054d3:	83 c0 10             	add    $0x10,%eax
801054d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801054d9:	8b 45 08             	mov    0x8(%ebp),%eax
801054dc:	8b 40 58             	mov    0x58(%eax),%eax
801054df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054e2:	39 c2                	cmp    %eax,%edx
801054e4:	72 b3                	jb     80105499 <isdirempty+0xf>
  }
  return 1;
801054e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
801054eb:	c9                   	leave
801054ec:	c3                   	ret

801054ed <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801054ed:	55                   	push   %ebp
801054ee:	89 e5                	mov    %esp,%ebp
801054f0:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801054f3:	83 ec 08             	sub    $0x8,%esp
801054f6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801054f9:	50                   	push   %eax
801054fa:	6a 00                	push   $0x0
801054fc:	e8 a2 fa ff ff       	call   80104fa3 <argstr>
80105501:	83 c4 10             	add    $0x10,%esp
80105504:	85 c0                	test   %eax,%eax
80105506:	79 0a                	jns    80105512 <sys_unlink+0x25>
    return -1;
80105508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550d:	e9 bf 01 00 00       	jmp    801056d1 <sys_unlink+0x1e4>

  begin_op();
80105512:	e8 27 db ff ff       	call   8010303e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105517:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010551a:	83 ec 08             	sub    $0x8,%esp
8010551d:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105520:	52                   	push   %edx
80105521:	50                   	push   %eax
80105522:	e8 1a d0 ff ff       	call   80102541 <nameiparent>
80105527:	83 c4 10             	add    $0x10,%esp
8010552a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010552d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105531:	75 0f                	jne    80105542 <sys_unlink+0x55>
    end_op();
80105533:	e8 92 db ff ff       	call   801030ca <end_op>
    return -1;
80105538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010553d:	e9 8f 01 00 00       	jmp    801056d1 <sys_unlink+0x1e4>
  }

  ilock(dp);
80105542:	83 ec 0c             	sub    $0xc,%esp
80105545:	ff 75 f4             	push   -0xc(%ebp)
80105548:	e8 a5 c4 ff ff       	call   801019f2 <ilock>
8010554d:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105550:	83 ec 08             	sub    $0x8,%esp
80105553:	68 e6 a6 10 80       	push   $0x8010a6e6
80105558:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010555b:	50                   	push   %eax
8010555c:	e8 58 cc ff ff       	call   801021b9 <namecmp>
80105561:	83 c4 10             	add    $0x10,%esp
80105564:	85 c0                	test   %eax,%eax
80105566:	0f 84 49 01 00 00    	je     801056b5 <sys_unlink+0x1c8>
8010556c:	83 ec 08             	sub    $0x8,%esp
8010556f:	68 e8 a6 10 80       	push   $0x8010a6e8
80105574:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105577:	50                   	push   %eax
80105578:	e8 3c cc ff ff       	call   801021b9 <namecmp>
8010557d:	83 c4 10             	add    $0x10,%esp
80105580:	85 c0                	test   %eax,%eax
80105582:	0f 84 2d 01 00 00    	je     801056b5 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105588:	83 ec 04             	sub    $0x4,%esp
8010558b:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010558e:	50                   	push   %eax
8010558f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105592:	50                   	push   %eax
80105593:	ff 75 f4             	push   -0xc(%ebp)
80105596:	e8 39 cc ff ff       	call   801021d4 <dirlookup>
8010559b:	83 c4 10             	add    $0x10,%esp
8010559e:	89 45 f0             	mov    %eax,-0x10(%ebp)
801055a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801055a5:	0f 84 0d 01 00 00    	je     801056b8 <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
801055ab:	83 ec 0c             	sub    $0xc,%esp
801055ae:	ff 75 f0             	push   -0x10(%ebp)
801055b1:	e8 3c c4 ff ff       	call   801019f2 <ilock>
801055b6:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
801055b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055bc:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801055c0:	66 85 c0             	test   %ax,%ax
801055c3:	7f 0d                	jg     801055d2 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801055c5:	83 ec 0c             	sub    $0xc,%esp
801055c8:	68 eb a6 10 80       	push   $0x8010a6eb
801055cd:	e8 d7 af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801055d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055d5:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801055d9:	66 83 f8 01          	cmp    $0x1,%ax
801055dd:	75 25                	jne    80105604 <sys_unlink+0x117>
801055df:	83 ec 0c             	sub    $0xc,%esp
801055e2:	ff 75 f0             	push   -0x10(%ebp)
801055e5:	e8 a0 fe ff ff       	call   8010548a <isdirempty>
801055ea:	83 c4 10             	add    $0x10,%esp
801055ed:	85 c0                	test   %eax,%eax
801055ef:	75 13                	jne    80105604 <sys_unlink+0x117>
    iunlockput(ip);
801055f1:	83 ec 0c             	sub    $0xc,%esp
801055f4:	ff 75 f0             	push   -0x10(%ebp)
801055f7:	e8 27 c6 ff ff       	call   80101c23 <iunlockput>
801055fc:	83 c4 10             	add    $0x10,%esp
    goto bad;
801055ff:	e9 b5 00 00 00       	jmp    801056b9 <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
80105604:	83 ec 04             	sub    $0x4,%esp
80105607:	6a 10                	push   $0x10
80105609:	6a 00                	push   $0x0
8010560b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010560e:	50                   	push   %eax
8010560f:	e8 cf f5 ff ff       	call   80104be3 <memset>
80105614:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105617:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010561a:	6a 10                	push   $0x10
8010561c:	50                   	push   %eax
8010561d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105620:	50                   	push   %eax
80105621:	ff 75 f4             	push   -0xc(%ebp)
80105624:	e8 0a ca ff ff       	call   80102033 <writei>
80105629:	83 c4 10             	add    $0x10,%esp
8010562c:	83 f8 10             	cmp    $0x10,%eax
8010562f:	74 0d                	je     8010563e <sys_unlink+0x151>
    panic("unlink: writei");
80105631:	83 ec 0c             	sub    $0xc,%esp
80105634:	68 fd a6 10 80       	push   $0x8010a6fd
80105639:	e8 6b af ff ff       	call   801005a9 <panic>
  if(ip->type == T_DIR){
8010563e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105641:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105645:	66 83 f8 01          	cmp    $0x1,%ax
80105649:	75 21                	jne    8010566c <sys_unlink+0x17f>
    dp->nlink--;
8010564b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010564e:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105652:	83 e8 01             	sub    $0x1,%eax
80105655:	89 c2                	mov    %eax,%edx
80105657:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010565a:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
8010565e:	83 ec 0c             	sub    $0xc,%esp
80105661:	ff 75 f4             	push   -0xc(%ebp)
80105664:	e8 ac c1 ff ff       	call   80101815 <iupdate>
80105669:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
8010566c:	83 ec 0c             	sub    $0xc,%esp
8010566f:	ff 75 f4             	push   -0xc(%ebp)
80105672:	e8 ac c5 ff ff       	call   80101c23 <iunlockput>
80105677:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010567a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010567d:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105681:	83 e8 01             	sub    $0x1,%eax
80105684:	89 c2                	mov    %eax,%edx
80105686:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105689:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
8010568d:	83 ec 0c             	sub    $0xc,%esp
80105690:	ff 75 f0             	push   -0x10(%ebp)
80105693:	e8 7d c1 ff ff       	call   80101815 <iupdate>
80105698:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010569b:	83 ec 0c             	sub    $0xc,%esp
8010569e:	ff 75 f0             	push   -0x10(%ebp)
801056a1:	e8 7d c5 ff ff       	call   80101c23 <iunlockput>
801056a6:	83 c4 10             	add    $0x10,%esp

  end_op();
801056a9:	e8 1c da ff ff       	call   801030ca <end_op>

  return 0;
801056ae:	b8 00 00 00 00       	mov    $0x0,%eax
801056b3:	eb 1c                	jmp    801056d1 <sys_unlink+0x1e4>
    goto bad;
801056b5:	90                   	nop
801056b6:	eb 01                	jmp    801056b9 <sys_unlink+0x1cc>
    goto bad;
801056b8:	90                   	nop

bad:
  iunlockput(dp);
801056b9:	83 ec 0c             	sub    $0xc,%esp
801056bc:	ff 75 f4             	push   -0xc(%ebp)
801056bf:	e8 5f c5 ff ff       	call   80101c23 <iunlockput>
801056c4:	83 c4 10             	add    $0x10,%esp
  end_op();
801056c7:	e8 fe d9 ff ff       	call   801030ca <end_op>
  return -1;
801056cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056d1:	c9                   	leave
801056d2:	c3                   	ret

801056d3 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801056d3:	55                   	push   %ebp
801056d4:	89 e5                	mov    %esp,%ebp
801056d6:	83 ec 38             	sub    $0x38,%esp
801056d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801056dc:	8b 55 10             	mov    0x10(%ebp),%edx
801056df:	8b 45 14             	mov    0x14(%ebp),%eax
801056e2:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801056e6:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801056ea:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056ee:	83 ec 08             	sub    $0x8,%esp
801056f1:	8d 45 de             	lea    -0x22(%ebp),%eax
801056f4:	50                   	push   %eax
801056f5:	ff 75 08             	push   0x8(%ebp)
801056f8:	e8 44 ce ff ff       	call   80102541 <nameiparent>
801056fd:	83 c4 10             	add    $0x10,%esp
80105700:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105707:	75 0a                	jne    80105713 <create+0x40>
    return 0;
80105709:	b8 00 00 00 00       	mov    $0x0,%eax
8010570e:	e9 90 01 00 00       	jmp    801058a3 <create+0x1d0>
  ilock(dp);
80105713:	83 ec 0c             	sub    $0xc,%esp
80105716:	ff 75 f4             	push   -0xc(%ebp)
80105719:	e8 d4 c2 ff ff       	call   801019f2 <ilock>
8010571e:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105721:	83 ec 04             	sub    $0x4,%esp
80105724:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105727:	50                   	push   %eax
80105728:	8d 45 de             	lea    -0x22(%ebp),%eax
8010572b:	50                   	push   %eax
8010572c:	ff 75 f4             	push   -0xc(%ebp)
8010572f:	e8 a0 ca ff ff       	call   801021d4 <dirlookup>
80105734:	83 c4 10             	add    $0x10,%esp
80105737:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010573a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010573e:	74 50                	je     80105790 <create+0xbd>
    iunlockput(dp);
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	ff 75 f4             	push   -0xc(%ebp)
80105746:	e8 d8 c4 ff ff       	call   80101c23 <iunlockput>
8010574b:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
8010574e:	83 ec 0c             	sub    $0xc,%esp
80105751:	ff 75 f0             	push   -0x10(%ebp)
80105754:	e8 99 c2 ff ff       	call   801019f2 <ilock>
80105759:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
8010575c:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105761:	75 15                	jne    80105778 <create+0xa5>
80105763:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105766:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010576a:	66 83 f8 02          	cmp    $0x2,%ax
8010576e:	75 08                	jne    80105778 <create+0xa5>
      return ip;
80105770:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105773:	e9 2b 01 00 00       	jmp    801058a3 <create+0x1d0>
    iunlockput(ip);
80105778:	83 ec 0c             	sub    $0xc,%esp
8010577b:	ff 75 f0             	push   -0x10(%ebp)
8010577e:	e8 a0 c4 ff ff       	call   80101c23 <iunlockput>
80105783:	83 c4 10             	add    $0x10,%esp
    return 0;
80105786:	b8 00 00 00 00       	mov    $0x0,%eax
8010578b:	e9 13 01 00 00       	jmp    801058a3 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105790:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105797:	8b 00                	mov    (%eax),%eax
80105799:	83 ec 08             	sub    $0x8,%esp
8010579c:	52                   	push   %edx
8010579d:	50                   	push   %eax
8010579e:	e8 9c bf ff ff       	call   8010173f <ialloc>
801057a3:	83 c4 10             	add    $0x10,%esp
801057a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801057a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801057ad:	75 0d                	jne    801057bc <create+0xe9>
    panic("create: ialloc");
801057af:	83 ec 0c             	sub    $0xc,%esp
801057b2:	68 0c a7 10 80       	push   $0x8010a70c
801057b7:	e8 ed ad ff ff       	call   801005a9 <panic>

  ilock(ip);
801057bc:	83 ec 0c             	sub    $0xc,%esp
801057bf:	ff 75 f0             	push   -0x10(%ebp)
801057c2:	e8 2b c2 ff ff       	call   801019f2 <ilock>
801057c7:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801057ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057cd:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801057d1:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
801057d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d8:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801057dc:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
801057e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057e3:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
801057e9:	83 ec 0c             	sub    $0xc,%esp
801057ec:	ff 75 f0             	push   -0x10(%ebp)
801057ef:	e8 21 c0 ff ff       	call   80101815 <iupdate>
801057f4:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801057f7:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801057fc:	75 6a                	jne    80105868 <create+0x195>
    dp->nlink++;  // for ".."
801057fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105801:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105805:	83 c0 01             	add    $0x1,%eax
80105808:	89 c2                	mov    %eax,%edx
8010580a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010580d:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105811:	83 ec 0c             	sub    $0xc,%esp
80105814:	ff 75 f4             	push   -0xc(%ebp)
80105817:	e8 f9 bf ff ff       	call   80101815 <iupdate>
8010581c:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010581f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105822:	8b 40 04             	mov    0x4(%eax),%eax
80105825:	83 ec 04             	sub    $0x4,%esp
80105828:	50                   	push   %eax
80105829:	68 e6 a6 10 80       	push   $0x8010a6e6
8010582e:	ff 75 f0             	push   -0x10(%ebp)
80105831:	e8 58 ca ff ff       	call   8010228e <dirlink>
80105836:	83 c4 10             	add    $0x10,%esp
80105839:	85 c0                	test   %eax,%eax
8010583b:	78 1e                	js     8010585b <create+0x188>
8010583d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105840:	8b 40 04             	mov    0x4(%eax),%eax
80105843:	83 ec 04             	sub    $0x4,%esp
80105846:	50                   	push   %eax
80105847:	68 e8 a6 10 80       	push   $0x8010a6e8
8010584c:	ff 75 f0             	push   -0x10(%ebp)
8010584f:	e8 3a ca ff ff       	call   8010228e <dirlink>
80105854:	83 c4 10             	add    $0x10,%esp
80105857:	85 c0                	test   %eax,%eax
80105859:	79 0d                	jns    80105868 <create+0x195>
      panic("create dots");
8010585b:	83 ec 0c             	sub    $0xc,%esp
8010585e:	68 1b a7 10 80       	push   $0x8010a71b
80105863:	e8 41 ad ff ff       	call   801005a9 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105868:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010586b:	8b 40 04             	mov    0x4(%eax),%eax
8010586e:	83 ec 04             	sub    $0x4,%esp
80105871:	50                   	push   %eax
80105872:	8d 45 de             	lea    -0x22(%ebp),%eax
80105875:	50                   	push   %eax
80105876:	ff 75 f4             	push   -0xc(%ebp)
80105879:	e8 10 ca ff ff       	call   8010228e <dirlink>
8010587e:	83 c4 10             	add    $0x10,%esp
80105881:	85 c0                	test   %eax,%eax
80105883:	79 0d                	jns    80105892 <create+0x1bf>
    panic("create: dirlink");
80105885:	83 ec 0c             	sub    $0xc,%esp
80105888:	68 27 a7 10 80       	push   $0x8010a727
8010588d:	e8 17 ad ff ff       	call   801005a9 <panic>

  iunlockput(dp);
80105892:	83 ec 0c             	sub    $0xc,%esp
80105895:	ff 75 f4             	push   -0xc(%ebp)
80105898:	e8 86 c3 ff ff       	call   80101c23 <iunlockput>
8010589d:	83 c4 10             	add    $0x10,%esp

  return ip;
801058a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801058a3:	c9                   	leave
801058a4:	c3                   	ret

801058a5 <sys_open>:

int
sys_open(void)
{
801058a5:	55                   	push   %ebp
801058a6:	89 e5                	mov    %esp,%ebp
801058a8:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058ab:	83 ec 08             	sub    $0x8,%esp
801058ae:	8d 45 e8             	lea    -0x18(%ebp),%eax
801058b1:	50                   	push   %eax
801058b2:	6a 00                	push   $0x0
801058b4:	e8 ea f6 ff ff       	call   80104fa3 <argstr>
801058b9:	83 c4 10             	add    $0x10,%esp
801058bc:	85 c0                	test   %eax,%eax
801058be:	78 15                	js     801058d5 <sys_open+0x30>
801058c0:	83 ec 08             	sub    $0x8,%esp
801058c3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058c6:	50                   	push   %eax
801058c7:	6a 01                	push   $0x1
801058c9:	e8 40 f6 ff ff       	call   80104f0e <argint>
801058ce:	83 c4 10             	add    $0x10,%esp
801058d1:	85 c0                	test   %eax,%eax
801058d3:	79 0a                	jns    801058df <sys_open+0x3a>
    return -1;
801058d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058da:	e9 61 01 00 00       	jmp    80105a40 <sys_open+0x19b>

  begin_op();
801058df:	e8 5a d7 ff ff       	call   8010303e <begin_op>

  if(omode & O_CREATE){
801058e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801058e7:	25 00 02 00 00       	and    $0x200,%eax
801058ec:	85 c0                	test   %eax,%eax
801058ee:	74 2a                	je     8010591a <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801058f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801058f3:	6a 00                	push   $0x0
801058f5:	6a 00                	push   $0x0
801058f7:	6a 02                	push   $0x2
801058f9:	50                   	push   %eax
801058fa:	e8 d4 fd ff ff       	call   801056d3 <create>
801058ff:	83 c4 10             	add    $0x10,%esp
80105902:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105905:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105909:	75 75                	jne    80105980 <sys_open+0xdb>
      end_op();
8010590b:	e8 ba d7 ff ff       	call   801030ca <end_op>
      return -1;
80105910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105915:	e9 26 01 00 00       	jmp    80105a40 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
8010591a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010591d:	83 ec 0c             	sub    $0xc,%esp
80105920:	50                   	push   %eax
80105921:	e8 ff cb ff ff       	call   80102525 <namei>
80105926:	83 c4 10             	add    $0x10,%esp
80105929:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010592c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105930:	75 0f                	jne    80105941 <sys_open+0x9c>
      end_op();
80105932:	e8 93 d7 ff ff       	call   801030ca <end_op>
      return -1;
80105937:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010593c:	e9 ff 00 00 00       	jmp    80105a40 <sys_open+0x19b>
    }
    ilock(ip);
80105941:	83 ec 0c             	sub    $0xc,%esp
80105944:	ff 75 f4             	push   -0xc(%ebp)
80105947:	e8 a6 c0 ff ff       	call   801019f2 <ilock>
8010594c:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
8010594f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105952:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105956:	66 83 f8 01          	cmp    $0x1,%ax
8010595a:	75 24                	jne    80105980 <sys_open+0xdb>
8010595c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010595f:	85 c0                	test   %eax,%eax
80105961:	74 1d                	je     80105980 <sys_open+0xdb>
      iunlockput(ip);
80105963:	83 ec 0c             	sub    $0xc,%esp
80105966:	ff 75 f4             	push   -0xc(%ebp)
80105969:	e8 b5 c2 ff ff       	call   80101c23 <iunlockput>
8010596e:	83 c4 10             	add    $0x10,%esp
      end_op();
80105971:	e8 54 d7 ff ff       	call   801030ca <end_op>
      return -1;
80105976:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010597b:	e9 c0 00 00 00       	jmp    80105a40 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105980:	e8 62 b6 ff ff       	call   80100fe7 <filealloc>
80105985:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105988:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010598c:	74 17                	je     801059a5 <sys_open+0x100>
8010598e:	83 ec 0c             	sub    $0xc,%esp
80105991:	ff 75 f0             	push   -0x10(%ebp)
80105994:	e8 33 f7 ff ff       	call   801050cc <fdalloc>
80105999:	83 c4 10             	add    $0x10,%esp
8010599c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010599f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801059a3:	79 2e                	jns    801059d3 <sys_open+0x12e>
    if(f)
801059a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059a9:	74 0e                	je     801059b9 <sys_open+0x114>
      fileclose(f);
801059ab:	83 ec 0c             	sub    $0xc,%esp
801059ae:	ff 75 f0             	push   -0x10(%ebp)
801059b1:	e8 ef b6 ff ff       	call   801010a5 <fileclose>
801059b6:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801059b9:	83 ec 0c             	sub    $0xc,%esp
801059bc:	ff 75 f4             	push   -0xc(%ebp)
801059bf:	e8 5f c2 ff ff       	call   80101c23 <iunlockput>
801059c4:	83 c4 10             	add    $0x10,%esp
    end_op();
801059c7:	e8 fe d6 ff ff       	call   801030ca <end_op>
    return -1;
801059cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059d1:	eb 6d                	jmp    80105a40 <sys_open+0x19b>
  }
  iunlock(ip);
801059d3:	83 ec 0c             	sub    $0xc,%esp
801059d6:	ff 75 f4             	push   -0xc(%ebp)
801059d9:	e8 27 c1 ff ff       	call   80101b05 <iunlock>
801059de:	83 c4 10             	add    $0x10,%esp
  end_op();
801059e1:	e8 e4 d6 ff ff       	call   801030ca <end_op>

  f->type = FD_INODE;
801059e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059e9:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801059ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059f5:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801059f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059fb:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105a02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a05:	83 e0 01             	and    $0x1,%eax
80105a08:	85 c0                	test   %eax,%eax
80105a0a:	0f 94 c0             	sete   %al
80105a0d:	89 c2                	mov    %eax,%edx
80105a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a12:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a18:	83 e0 01             	and    $0x1,%eax
80105a1b:	85 c0                	test   %eax,%eax
80105a1d:	75 0a                	jne    80105a29 <sys_open+0x184>
80105a1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a22:	83 e0 02             	and    $0x2,%eax
80105a25:	85 c0                	test   %eax,%eax
80105a27:	74 07                	je     80105a30 <sys_open+0x18b>
80105a29:	b8 01 00 00 00       	mov    $0x1,%eax
80105a2e:	eb 05                	jmp    80105a35 <sys_open+0x190>
80105a30:	b8 00 00 00 00       	mov    $0x0,%eax
80105a35:	89 c2                	mov    %eax,%edx
80105a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a3a:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105a40:	c9                   	leave
80105a41:	c3                   	ret

80105a42 <sys_mkdir>:

int
sys_mkdir(void)
{
80105a42:	55                   	push   %ebp
80105a43:	89 e5                	mov    %esp,%ebp
80105a45:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a48:	e8 f1 d5 ff ff       	call   8010303e <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a4d:	83 ec 08             	sub    $0x8,%esp
80105a50:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a53:	50                   	push   %eax
80105a54:	6a 00                	push   $0x0
80105a56:	e8 48 f5 ff ff       	call   80104fa3 <argstr>
80105a5b:	83 c4 10             	add    $0x10,%esp
80105a5e:	85 c0                	test   %eax,%eax
80105a60:	78 1b                	js     80105a7d <sys_mkdir+0x3b>
80105a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a65:	6a 00                	push   $0x0
80105a67:	6a 00                	push   $0x0
80105a69:	6a 01                	push   $0x1
80105a6b:	50                   	push   %eax
80105a6c:	e8 62 fc ff ff       	call   801056d3 <create>
80105a71:	83 c4 10             	add    $0x10,%esp
80105a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a7b:	75 0c                	jne    80105a89 <sys_mkdir+0x47>
    end_op();
80105a7d:	e8 48 d6 ff ff       	call   801030ca <end_op>
    return -1;
80105a82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a87:	eb 18                	jmp    80105aa1 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80105a89:	83 ec 0c             	sub    $0xc,%esp
80105a8c:	ff 75 f4             	push   -0xc(%ebp)
80105a8f:	e8 8f c1 ff ff       	call   80101c23 <iunlockput>
80105a94:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a97:	e8 2e d6 ff ff       	call   801030ca <end_op>
  return 0;
80105a9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105aa1:	c9                   	leave
80105aa2:	c3                   	ret

80105aa3 <sys_mknod>:

int
sys_mknod(void)
{
80105aa3:	55                   	push   %ebp
80105aa4:	89 e5                	mov    %esp,%ebp
80105aa6:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105aa9:	e8 90 d5 ff ff       	call   8010303e <begin_op>
  if((argstr(0, &path)) < 0 ||
80105aae:	83 ec 08             	sub    $0x8,%esp
80105ab1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ab4:	50                   	push   %eax
80105ab5:	6a 00                	push   $0x0
80105ab7:	e8 e7 f4 ff ff       	call   80104fa3 <argstr>
80105abc:	83 c4 10             	add    $0x10,%esp
80105abf:	85 c0                	test   %eax,%eax
80105ac1:	78 4f                	js     80105b12 <sys_mknod+0x6f>
     argint(1, &major) < 0 ||
80105ac3:	83 ec 08             	sub    $0x8,%esp
80105ac6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ac9:	50                   	push   %eax
80105aca:	6a 01                	push   $0x1
80105acc:	e8 3d f4 ff ff       	call   80104f0e <argint>
80105ad1:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80105ad4:	85 c0                	test   %eax,%eax
80105ad6:	78 3a                	js     80105b12 <sys_mknod+0x6f>
     argint(2, &minor) < 0 ||
80105ad8:	83 ec 08             	sub    $0x8,%esp
80105adb:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105ade:	50                   	push   %eax
80105adf:	6a 02                	push   $0x2
80105ae1:	e8 28 f4 ff ff       	call   80104f0e <argint>
80105ae6:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80105ae9:	85 c0                	test   %eax,%eax
80105aeb:	78 25                	js     80105b12 <sys_mknod+0x6f>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105aed:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105af0:	0f bf c8             	movswl %ax,%ecx
80105af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105af6:	0f bf d0             	movswl %ax,%edx
80105af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105afc:	51                   	push   %ecx
80105afd:	52                   	push   %edx
80105afe:	6a 03                	push   $0x3
80105b00:	50                   	push   %eax
80105b01:	e8 cd fb ff ff       	call   801056d3 <create>
80105b06:	83 c4 10             	add    $0x10,%esp
80105b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
80105b0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b10:	75 0c                	jne    80105b1e <sys_mknod+0x7b>
    end_op();
80105b12:	e8 b3 d5 ff ff       	call   801030ca <end_op>
    return -1;
80105b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1c:	eb 18                	jmp    80105b36 <sys_mknod+0x93>
  }
  iunlockput(ip);
80105b1e:	83 ec 0c             	sub    $0xc,%esp
80105b21:	ff 75 f4             	push   -0xc(%ebp)
80105b24:	e8 fa c0 ff ff       	call   80101c23 <iunlockput>
80105b29:	83 c4 10             	add    $0x10,%esp
  end_op();
80105b2c:	e8 99 d5 ff ff       	call   801030ca <end_op>
  return 0;
80105b31:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b36:	c9                   	leave
80105b37:	c3                   	ret

80105b38 <sys_chdir>:

int
sys_chdir(void)
{
80105b38:	55                   	push   %ebp
80105b39:	89 e5                	mov    %esp,%ebp
80105b3b:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b3e:	e8 ed de ff ff       	call   80103a30 <myproc>
80105b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105b46:	e8 f3 d4 ff ff       	call   8010303e <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b4b:	83 ec 08             	sub    $0x8,%esp
80105b4e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b51:	50                   	push   %eax
80105b52:	6a 00                	push   $0x0
80105b54:	e8 4a f4 ff ff       	call   80104fa3 <argstr>
80105b59:	83 c4 10             	add    $0x10,%esp
80105b5c:	85 c0                	test   %eax,%eax
80105b5e:	78 18                	js     80105b78 <sys_chdir+0x40>
80105b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b63:	83 ec 0c             	sub    $0xc,%esp
80105b66:	50                   	push   %eax
80105b67:	e8 b9 c9 ff ff       	call   80102525 <namei>
80105b6c:	83 c4 10             	add    $0x10,%esp
80105b6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b76:	75 0c                	jne    80105b84 <sys_chdir+0x4c>
    end_op();
80105b78:	e8 4d d5 ff ff       	call   801030ca <end_op>
    return -1;
80105b7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b82:	eb 68                	jmp    80105bec <sys_chdir+0xb4>
  }
  ilock(ip);
80105b84:	83 ec 0c             	sub    $0xc,%esp
80105b87:	ff 75 f0             	push   -0x10(%ebp)
80105b8a:	e8 63 be ff ff       	call   801019f2 <ilock>
80105b8f:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b95:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105b99:	66 83 f8 01          	cmp    $0x1,%ax
80105b9d:	74 1a                	je     80105bb9 <sys_chdir+0x81>
    iunlockput(ip);
80105b9f:	83 ec 0c             	sub    $0xc,%esp
80105ba2:	ff 75 f0             	push   -0x10(%ebp)
80105ba5:	e8 79 c0 ff ff       	call   80101c23 <iunlockput>
80105baa:	83 c4 10             	add    $0x10,%esp
    end_op();
80105bad:	e8 18 d5 ff ff       	call   801030ca <end_op>
    return -1;
80105bb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb7:	eb 33                	jmp    80105bec <sys_chdir+0xb4>
  }
  iunlock(ip);
80105bb9:	83 ec 0c             	sub    $0xc,%esp
80105bbc:	ff 75 f0             	push   -0x10(%ebp)
80105bbf:	e8 41 bf ff ff       	call   80101b05 <iunlock>
80105bc4:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
80105bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bca:	8b 40 68             	mov    0x68(%eax),%eax
80105bcd:	83 ec 0c             	sub    $0xc,%esp
80105bd0:	50                   	push   %eax
80105bd1:	e8 7d bf ff ff       	call   80101b53 <iput>
80105bd6:	83 c4 10             	add    $0x10,%esp
  end_op();
80105bd9:	e8 ec d4 ff ff       	call   801030ca <end_op>
  curproc->cwd = ip;
80105bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105be4:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bec:	c9                   	leave
80105bed:	c3                   	ret

80105bee <sys_exec>:

int
sys_exec(void)
{
80105bee:	55                   	push   %ebp
80105bef:	89 e5                	mov    %esp,%ebp
80105bf1:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105bf7:	83 ec 08             	sub    $0x8,%esp
80105bfa:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bfd:	50                   	push   %eax
80105bfe:	6a 00                	push   $0x0
80105c00:	e8 9e f3 ff ff       	call   80104fa3 <argstr>
80105c05:	83 c4 10             	add    $0x10,%esp
80105c08:	85 c0                	test   %eax,%eax
80105c0a:	78 18                	js     80105c24 <sys_exec+0x36>
80105c0c:	83 ec 08             	sub    $0x8,%esp
80105c0f:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105c15:	50                   	push   %eax
80105c16:	6a 01                	push   $0x1
80105c18:	e8 f1 f2 ff ff       	call   80104f0e <argint>
80105c1d:	83 c4 10             	add    $0x10,%esp
80105c20:	85 c0                	test   %eax,%eax
80105c22:	79 0a                	jns    80105c2e <sys_exec+0x40>
    return -1;
80105c24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c29:	e9 c6 00 00 00       	jmp    80105cf4 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80105c2e:	83 ec 04             	sub    $0x4,%esp
80105c31:	68 80 00 00 00       	push   $0x80
80105c36:	6a 00                	push   $0x0
80105c38:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105c3e:	50                   	push   %eax
80105c3f:	e8 9f ef ff ff       	call   80104be3 <memset>
80105c44:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105c47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c51:	83 f8 1f             	cmp    $0x1f,%eax
80105c54:	76 0a                	jbe    80105c60 <sys_exec+0x72>
      return -1;
80105c56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c5b:	e9 94 00 00 00       	jmp    80105cf4 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c63:	c1 e0 02             	shl    $0x2,%eax
80105c66:	89 c2                	mov    %eax,%edx
80105c68:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105c6e:	01 c2                	add    %eax,%edx
80105c70:	83 ec 08             	sub    $0x8,%esp
80105c73:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c79:	50                   	push   %eax
80105c7a:	52                   	push   %edx
80105c7b:	e8 ed f1 ff ff       	call   80104e6d <fetchint>
80105c80:	83 c4 10             	add    $0x10,%esp
80105c83:	85 c0                	test   %eax,%eax
80105c85:	79 07                	jns    80105c8e <sys_exec+0xa0>
      return -1;
80105c87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c8c:	eb 66                	jmp    80105cf4 <sys_exec+0x106>
    if(uarg == 0){
80105c8e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105c94:	85 c0                	test   %eax,%eax
80105c96:	75 27                	jne    80105cbf <sys_exec+0xd1>
      argv[i] = 0;
80105c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c9b:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105ca2:	00 00 00 00 
      break;
80105ca6:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105caa:	83 ec 08             	sub    $0x8,%esp
80105cad:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105cb3:	52                   	push   %edx
80105cb4:	50                   	push   %eax
80105cb5:	e8 d0 ae ff ff       	call   80100b8a <exec>
80105cba:	83 c4 10             	add    $0x10,%esp
80105cbd:	eb 35                	jmp    80105cf4 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
80105cbf:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cc8:	c1 e2 02             	shl    $0x2,%edx
80105ccb:	01 c2                	add    %eax,%edx
80105ccd:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105cd3:	83 ec 08             	sub    $0x8,%esp
80105cd6:	52                   	push   %edx
80105cd7:	50                   	push   %eax
80105cd8:	e8 cf f1 ff ff       	call   80104eac <fetchstr>
80105cdd:	83 c4 10             	add    $0x10,%esp
80105ce0:	85 c0                	test   %eax,%eax
80105ce2:	79 07                	jns    80105ceb <sys_exec+0xfd>
      return -1;
80105ce4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce9:	eb 09                	jmp    80105cf4 <sys_exec+0x106>
  for(i=0;; i++){
80105ceb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80105cef:	e9 5a ff ff ff       	jmp    80105c4e <sys_exec+0x60>
}
80105cf4:	c9                   	leave
80105cf5:	c3                   	ret

80105cf6 <sys_pipe>:

int
sys_pipe(void)
{
80105cf6:	55                   	push   %ebp
80105cf7:	89 e5                	mov    %esp,%ebp
80105cf9:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105cfc:	83 ec 04             	sub    $0x4,%esp
80105cff:	6a 08                	push   $0x8
80105d01:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d04:	50                   	push   %eax
80105d05:	6a 00                	push   $0x0
80105d07:	e8 2f f2 ff ff       	call   80104f3b <argptr>
80105d0c:	83 c4 10             	add    $0x10,%esp
80105d0f:	85 c0                	test   %eax,%eax
80105d11:	79 0a                	jns    80105d1d <sys_pipe+0x27>
    return -1;
80105d13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d18:	e9 ae 00 00 00       	jmp    80105dcb <sys_pipe+0xd5>
  if(pipealloc(&rf, &wf) < 0)
80105d1d:	83 ec 08             	sub    $0x8,%esp
80105d20:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d23:	50                   	push   %eax
80105d24:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d27:	50                   	push   %eax
80105d28:	e8 40 d8 ff ff       	call   8010356d <pipealloc>
80105d2d:	83 c4 10             	add    $0x10,%esp
80105d30:	85 c0                	test   %eax,%eax
80105d32:	79 0a                	jns    80105d3e <sys_pipe+0x48>
    return -1;
80105d34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d39:	e9 8d 00 00 00       	jmp    80105dcb <sys_pipe+0xd5>
  fd0 = -1;
80105d3e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d45:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d48:	83 ec 0c             	sub    $0xc,%esp
80105d4b:	50                   	push   %eax
80105d4c:	e8 7b f3 ff ff       	call   801050cc <fdalloc>
80105d51:	83 c4 10             	add    $0x10,%esp
80105d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d5b:	78 18                	js     80105d75 <sys_pipe+0x7f>
80105d5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d60:	83 ec 0c             	sub    $0xc,%esp
80105d63:	50                   	push   %eax
80105d64:	e8 63 f3 ff ff       	call   801050cc <fdalloc>
80105d69:	83 c4 10             	add    $0x10,%esp
80105d6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d73:	79 3e                	jns    80105db3 <sys_pipe+0xbd>
    if(fd0 >= 0)
80105d75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d79:	78 13                	js     80105d8e <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105d7b:	e8 b0 dc ff ff       	call   80103a30 <myproc>
80105d80:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d83:	83 c2 08             	add    $0x8,%edx
80105d86:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105d8d:	00 
    fileclose(rf);
80105d8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105d91:	83 ec 0c             	sub    $0xc,%esp
80105d94:	50                   	push   %eax
80105d95:	e8 0b b3 ff ff       	call   801010a5 <fileclose>
80105d9a:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105da0:	83 ec 0c             	sub    $0xc,%esp
80105da3:	50                   	push   %eax
80105da4:	e8 fc b2 ff ff       	call   801010a5 <fileclose>
80105da9:	83 c4 10             	add    $0x10,%esp
    return -1;
80105dac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105db1:	eb 18                	jmp    80105dcb <sys_pipe+0xd5>
  }
  fd[0] = fd0;
80105db3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105db6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105db9:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105dbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105dbe:	8d 50 04             	lea    0x4(%eax),%edx
80105dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc4:	89 02                	mov    %eax,(%edx)
  return 0;
80105dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105dcb:	c9                   	leave
80105dcc:	c3                   	ret

80105dcd <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105dcd:	55                   	push   %ebp
80105dce:	89 e5                	mov    %esp,%ebp
80105dd0:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105dd3:	e8 5a df ff ff       	call   80103d32 <fork>
}
80105dd8:	c9                   	leave
80105dd9:	c3                   	ret

80105dda <sys_exit>:

int
sys_exit(void)
{
80105dda:	55                   	push   %ebp
80105ddb:	89 e5                	mov    %esp,%ebp
80105ddd:	83 ec 08             	sub    $0x8,%esp
  exit();
80105de0:	e8 c6 e0 ff ff       	call   80103eab <exit>
  return 0;  // not reached
80105de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105dea:	c9                   	leave
80105deb:	c3                   	ret

80105dec <sys_wait>:

int
sys_wait(void)
{
80105dec:	55                   	push   %ebp
80105ded:	89 e5                	mov    %esp,%ebp
80105def:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105df2:	e8 d7 e1 ff ff       	call   80103fce <wait>
}
80105df7:	c9                   	leave
80105df8:	c3                   	ret

80105df9 <sys_kill>:

int
sys_kill(void)
{
80105df9:	55                   	push   %ebp
80105dfa:	89 e5                	mov    %esp,%ebp
80105dfc:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105dff:	83 ec 08             	sub    $0x8,%esp
80105e02:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e05:	50                   	push   %eax
80105e06:	6a 00                	push   $0x0
80105e08:	e8 01 f1 ff ff       	call   80104f0e <argint>
80105e0d:	83 c4 10             	add    $0x10,%esp
80105e10:	85 c0                	test   %eax,%eax
80105e12:	79 07                	jns    80105e1b <sys_kill+0x22>
    return -1;
80105e14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e19:	eb 0f                	jmp    80105e2a <sys_kill+0x31>
  return kill(pid);
80105e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1e:	83 ec 0c             	sub    $0xc,%esp
80105e21:	50                   	push   %eax
80105e22:	e8 df e5 ff ff       	call   80104406 <kill>
80105e27:	83 c4 10             	add    $0x10,%esp
}
80105e2a:	c9                   	leave
80105e2b:	c3                   	ret

80105e2c <sys_getpid>:

int
sys_getpid(void)
{
80105e2c:	55                   	push   %ebp
80105e2d:	89 e5                	mov    %esp,%ebp
80105e2f:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105e32:	e8 f9 db ff ff       	call   80103a30 <myproc>
80105e37:	8b 40 10             	mov    0x10(%eax),%eax
}
80105e3a:	c9                   	leave
80105e3b:	c3                   	ret

80105e3c <sys_sbrk>:

int
sys_sbrk(void)
{
80105e3c:	55                   	push   %ebp
80105e3d:	89 e5                	mov    %esp,%ebp
80105e3f:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105e42:	83 ec 08             	sub    $0x8,%esp
80105e45:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e48:	50                   	push   %eax
80105e49:	6a 00                	push   $0x0
80105e4b:	e8 be f0 ff ff       	call   80104f0e <argint>
80105e50:	83 c4 10             	add    $0x10,%esp
80105e53:	85 c0                	test   %eax,%eax
80105e55:	79 07                	jns    80105e5e <sys_sbrk+0x22>
    return -1;
80105e57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e5c:	eb 27                	jmp    80105e85 <sys_sbrk+0x49>
  addr = myproc()->sz;
80105e5e:	e8 cd db ff ff       	call   80103a30 <myproc>
80105e63:	8b 00                	mov    (%eax),%eax
80105e65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80105e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e6b:	83 ec 0c             	sub    $0xc,%esp
80105e6e:	50                   	push   %eax
80105e6f:	e8 23 de ff ff       	call   80103c97 <growproc>
80105e74:	83 c4 10             	add    $0x10,%esp
80105e77:	85 c0                	test   %eax,%eax
80105e79:	79 07                	jns    80105e82 <sys_sbrk+0x46>
    return -1;
80105e7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e80:	eb 03                	jmp    80105e85 <sys_sbrk+0x49>
  return addr;
80105e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105e85:	c9                   	leave
80105e86:	c3                   	ret

80105e87 <sys_sleep>:

int
sys_sleep(void)
{
80105e87:	55                   	push   %ebp
80105e88:	89 e5                	mov    %esp,%ebp
80105e8a:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e8d:	83 ec 08             	sub    $0x8,%esp
80105e90:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e93:	50                   	push   %eax
80105e94:	6a 00                	push   $0x0
80105e96:	e8 73 f0 ff ff       	call   80104f0e <argint>
80105e9b:	83 c4 10             	add    $0x10,%esp
80105e9e:	85 c0                	test   %eax,%eax
80105ea0:	79 07                	jns    80105ea9 <sys_sleep+0x22>
    return -1;
80105ea2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ea7:	eb 76                	jmp    80105f1f <sys_sleep+0x98>
  acquire(&tickslock);
80105ea9:	83 ec 0c             	sub    $0xc,%esp
80105eac:	68 40 6b 19 80       	push   $0x80196b40
80105eb1:	e8 b7 ea ff ff       	call   8010496d <acquire>
80105eb6:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105eb9:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80105ebe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80105ec1:	eb 38                	jmp    80105efb <sys_sleep+0x74>
    if(myproc()->killed){
80105ec3:	e8 68 db ff ff       	call   80103a30 <myproc>
80105ec8:	8b 40 24             	mov    0x24(%eax),%eax
80105ecb:	85 c0                	test   %eax,%eax
80105ecd:	74 17                	je     80105ee6 <sys_sleep+0x5f>
      release(&tickslock);
80105ecf:	83 ec 0c             	sub    $0xc,%esp
80105ed2:	68 40 6b 19 80       	push   $0x80196b40
80105ed7:	e8 ff ea ff ff       	call   801049db <release>
80105edc:	83 c4 10             	add    $0x10,%esp
      return -1;
80105edf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee4:	eb 39                	jmp    80105f1f <sys_sleep+0x98>
    }
    sleep(&ticks, &tickslock);
80105ee6:	83 ec 08             	sub    $0x8,%esp
80105ee9:	68 40 6b 19 80       	push   $0x80196b40
80105eee:	68 74 6b 19 80       	push   $0x80196b74
80105ef3:	e8 ed e3 ff ff       	call   801042e5 <sleep>
80105ef8:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80105efb:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80105f00:	2b 45 f4             	sub    -0xc(%ebp),%eax
80105f03:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f06:	39 d0                	cmp    %edx,%eax
80105f08:	72 b9                	jb     80105ec3 <sys_sleep+0x3c>
  }
  release(&tickslock);
80105f0a:	83 ec 0c             	sub    $0xc,%esp
80105f0d:	68 40 6b 19 80       	push   $0x80196b40
80105f12:	e8 c4 ea ff ff       	call   801049db <release>
80105f17:	83 c4 10             	add    $0x10,%esp
  return 0;
80105f1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f1f:	c9                   	leave
80105f20:	c3                   	ret

80105f21 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105f21:	55                   	push   %ebp
80105f22:	89 e5                	mov    %esp,%ebp
80105f24:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80105f27:	83 ec 0c             	sub    $0xc,%esp
80105f2a:	68 40 6b 19 80       	push   $0x80196b40
80105f2f:	e8 39 ea ff ff       	call   8010496d <acquire>
80105f34:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80105f37:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80105f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80105f3f:	83 ec 0c             	sub    $0xc,%esp
80105f42:	68 40 6b 19 80       	push   $0x80196b40
80105f47:	e8 8f ea ff ff       	call   801049db <release>
80105f4c:	83 c4 10             	add    $0x10,%esp
  return xticks;
80105f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f52:	c9                   	leave
80105f53:	c3                   	ret

80105f54 <sys_exit2>:

int
sys_exit2(void)
{
80105f54:	55                   	push   %ebp
80105f55:	89 e5                	mov    %esp,%ebp
80105f57:	83 ec 18             	sub    $0x18,%esp
  int status;
  if(argint(0, &status) < 0)
80105f5a:	83 ec 08             	sub    $0x8,%esp
80105f5d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f60:	50                   	push   %eax
80105f61:	6a 00                	push   $0x0
80105f63:	e8 a6 ef ff ff       	call   80104f0e <argint>
80105f68:	83 c4 10             	add    $0x10,%esp
80105f6b:	85 c0                	test   %eax,%eax
80105f6d:	79 07                	jns    80105f76 <sys_exit2+0x22>
    return -1;
80105f6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f74:	eb 14                	jmp    80105f8a <sys_exit2+0x36>
  exit2(status);
80105f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f79:	83 ec 0c             	sub    $0xc,%esp
80105f7c:	50                   	push   %eax
80105f7d:	e8 08 e6 ff ff       	call   8010458a <exit2>
80105f82:	83 c4 10             	add    $0x10,%esp
  return 0;
80105f85:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f8a:	c9                   	leave
80105f8b:	c3                   	ret

80105f8c <sys_wait2>:

int
sys_wait2(void)
{
80105f8c:	55                   	push   %ebp
80105f8d:	89 e5                	mov    %esp,%ebp
80105f8f:	83 ec 18             	sub    $0x18,%esp
  int *status;
  if(argptr(0, (char**)&status, sizeof(*status)) < 0)
80105f92:	83 ec 04             	sub    $0x4,%esp
80105f95:	6a 04                	push   $0x4
80105f97:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f9a:	50                   	push   %eax
80105f9b:	6a 00                	push   $0x0
80105f9d:	e8 99 ef ff ff       	call   80104f3b <argptr>
80105fa2:	83 c4 10             	add    $0x10,%esp
80105fa5:	85 c0                	test   %eax,%eax
80105fa7:	79 07                	jns    80105fb0 <sys_wait2+0x24>
    return -1;
80105fa9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fae:	eb 0f                	jmp    80105fbf <sys_wait2+0x33>
  return wait2(status);
80105fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fb3:	83 ec 0c             	sub    $0xc,%esp
80105fb6:	50                   	push   %eax
80105fb7:	e8 fa e6 ff ff       	call   801046b6 <wait2>
80105fbc:	83 c4 10             	add    $0x10,%esp
}
80105fbf:	c9                   	leave
80105fc0:	c3                   	ret

80105fc1 <sys_uthread_init>:


int sys_uthread_init(void) {
80105fc1:	55                   	push   %ebp
80105fc2:	89 e5                	mov    %esp,%ebp
80105fc4:	53                   	push   %ebx
80105fc5:	83 ec 14             	sub    $0x14,%esp
  int addr;
  // 첫 번째 인자(유저 스케줄러 함수의 주소)를 가져옴
  if(argint(0, &addr) < 0)
80105fc8:	83 ec 08             	sub    $0x8,%esp
80105fcb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fce:	50                   	push   %eax
80105fcf:	6a 00                	push   $0x0
80105fd1:	e8 38 ef ff ff       	call   80104f0e <argint>
80105fd6:	83 c4 10             	add    $0x10,%esp
80105fd9:	85 c0                	test   %eax,%eax
80105fdb:	79 07                	jns    80105fe4 <sys_uthread_init+0x23>
    return -1;
80105fdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe2:	eb 15                	jmp    80105ff9 <sys_uthread_init+0x38>
  myproc()->scheduler = addr;
80105fe4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80105fe7:	e8 44 da ff ff       	call   80103a30 <myproc>
80105fec:	89 da                	mov    %ebx,%edx
80105fee:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  //cprintf("Kernel received scheduler address: 0x%x\n", addr);
  return 0;
80105ff4:	b8 00 00 00 00       	mov    $0x0,%eax
80105ff9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ffc:	c9                   	leave
80105ffd:	c3                   	ret

80105ffe <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105ffe:	1e                   	push   %ds
  pushl %es
80105fff:	06                   	push   %es
  pushl %fs
80106000:	0f a0                	push   %fs
  pushl %gs
80106002:	0f a8                	push   %gs
  pushal
80106004:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106005:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106009:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010600b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010600d:	54                   	push   %esp
  call trap
8010600e:	e8 d7 01 00 00       	call   801061ea <trap>
  addl $4, %esp
80106013:	83 c4 04             	add    $0x4,%esp

80106016 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106016:	61                   	popa
  popl %gs
80106017:	0f a9                	pop    %gs
  popl %fs
80106019:	0f a1                	pop    %fs
  popl %es
8010601b:	07                   	pop    %es
  popl %ds
8010601c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010601d:	83 c4 08             	add    $0x8,%esp
  iret
80106020:	cf                   	iret

80106021 <lidt>:
{
80106021:	55                   	push   %ebp
80106022:	89 e5                	mov    %esp,%ebp
80106024:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106027:	8b 45 0c             	mov    0xc(%ebp),%eax
8010602a:	83 e8 01             	sub    $0x1,%eax
8010602d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106031:	8b 45 08             	mov    0x8(%ebp),%eax
80106034:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106038:	8b 45 08             	mov    0x8(%ebp),%eax
8010603b:	c1 e8 10             	shr    $0x10,%eax
8010603e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106042:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106045:	0f 01 18             	lidtl  (%eax)
}
80106048:	90                   	nop
80106049:	c9                   	leave
8010604a:	c3                   	ret

8010604b <rcr2>:

static inline uint
rcr2(void)
{
8010604b:	55                   	push   %ebp
8010604c:	89 e5                	mov    %esp,%ebp
8010604e:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106051:	0f 20 d0             	mov    %cr2,%eax
80106054:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106057:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010605a:	c9                   	leave
8010605b:	c3                   	ret

8010605c <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010605c:	55                   	push   %ebp
8010605d:	89 e5                	mov    %esp,%ebp
8010605f:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106062:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106069:	e9 c3 00 00 00       	jmp    80106131 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010606e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106071:	8b 04 85 84 f0 10 80 	mov    -0x7fef0f7c(,%eax,4),%eax
80106078:	89 c2                	mov    %eax,%edx
8010607a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607d:	66 89 14 c5 40 63 19 	mov    %dx,-0x7fe69cc0(,%eax,8)
80106084:	80 
80106085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106088:	66 c7 04 c5 42 63 19 	movw   $0x8,-0x7fe69cbe(,%eax,8)
8010608f:	80 08 00 
80106092:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106095:	0f b6 14 c5 44 63 19 	movzbl -0x7fe69cbc(,%eax,8),%edx
8010609c:	80 
8010609d:	83 e2 e0             	and    $0xffffffe0,%edx
801060a0:	88 14 c5 44 63 19 80 	mov    %dl,-0x7fe69cbc(,%eax,8)
801060a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060aa:	0f b6 14 c5 44 63 19 	movzbl -0x7fe69cbc(,%eax,8),%edx
801060b1:	80 
801060b2:	83 e2 1f             	and    $0x1f,%edx
801060b5:	88 14 c5 44 63 19 80 	mov    %dl,-0x7fe69cbc(,%eax,8)
801060bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060bf:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
801060c6:	80 
801060c7:	83 e2 f0             	and    $0xfffffff0,%edx
801060ca:	83 ca 0e             	or     $0xe,%edx
801060cd:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
801060d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d7:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
801060de:	80 
801060df:	83 e2 ef             	and    $0xffffffef,%edx
801060e2:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
801060e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ec:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
801060f3:	80 
801060f4:	83 e2 9f             	and    $0xffffff9f,%edx
801060f7:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
801060fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106101:	0f b6 14 c5 45 63 19 	movzbl -0x7fe69cbb(,%eax,8),%edx
80106108:	80 
80106109:	83 ca 80             	or     $0xffffff80,%edx
8010610c:	88 14 c5 45 63 19 80 	mov    %dl,-0x7fe69cbb(,%eax,8)
80106113:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106116:	8b 04 85 84 f0 10 80 	mov    -0x7fef0f7c(,%eax,4),%eax
8010611d:	c1 e8 10             	shr    $0x10,%eax
80106120:	89 c2                	mov    %eax,%edx
80106122:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106125:	66 89 14 c5 46 63 19 	mov    %dx,-0x7fe69cba(,%eax,8)
8010612c:	80 
  for(i = 0; i < 256; i++)
8010612d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106131:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106138:	0f 8e 30 ff ff ff    	jle    8010606e <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010613e:	a1 84 f1 10 80       	mov    0x8010f184,%eax
80106143:	66 a3 40 65 19 80    	mov    %ax,0x80196540
80106149:	66 c7 05 42 65 19 80 	movw   $0x8,0x80196542
80106150:	08 00 
80106152:	0f b6 05 44 65 19 80 	movzbl 0x80196544,%eax
80106159:	83 e0 e0             	and    $0xffffffe0,%eax
8010615c:	a2 44 65 19 80       	mov    %al,0x80196544
80106161:	0f b6 05 44 65 19 80 	movzbl 0x80196544,%eax
80106168:	83 e0 1f             	and    $0x1f,%eax
8010616b:	a2 44 65 19 80       	mov    %al,0x80196544
80106170:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
80106177:	83 c8 0f             	or     $0xf,%eax
8010617a:	a2 45 65 19 80       	mov    %al,0x80196545
8010617f:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
80106186:	83 e0 ef             	and    $0xffffffef,%eax
80106189:	a2 45 65 19 80       	mov    %al,0x80196545
8010618e:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
80106195:	83 c8 60             	or     $0x60,%eax
80106198:	a2 45 65 19 80       	mov    %al,0x80196545
8010619d:	0f b6 05 45 65 19 80 	movzbl 0x80196545,%eax
801061a4:	83 c8 80             	or     $0xffffff80,%eax
801061a7:	a2 45 65 19 80       	mov    %al,0x80196545
801061ac:	a1 84 f1 10 80       	mov    0x8010f184,%eax
801061b1:	c1 e8 10             	shr    $0x10,%eax
801061b4:	66 a3 46 65 19 80    	mov    %ax,0x80196546

  initlock(&tickslock, "time");
801061ba:	83 ec 08             	sub    $0x8,%esp
801061bd:	68 38 a7 10 80       	push   $0x8010a738
801061c2:	68 40 6b 19 80       	push   $0x80196b40
801061c7:	e8 7f e7 ff ff       	call   8010494b <initlock>
801061cc:	83 c4 10             	add    $0x10,%esp
}
801061cf:	90                   	nop
801061d0:	c9                   	leave
801061d1:	c3                   	ret

801061d2 <idtinit>:

void
idtinit(void)
{
801061d2:	55                   	push   %ebp
801061d3:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
801061d5:	68 00 08 00 00       	push   $0x800
801061da:	68 40 63 19 80       	push   $0x80196340
801061df:	e8 3d fe ff ff       	call   80106021 <lidt>
801061e4:	83 c4 08             	add    $0x8,%esp
}
801061e7:	90                   	nop
801061e8:	c9                   	leave
801061e9:	c3                   	ret

801061ea <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801061ea:	55                   	push   %ebp
801061eb:	89 e5                	mov    %esp,%ebp
801061ed:	57                   	push   %edi
801061ee:	56                   	push   %esi
801061ef:	53                   	push   %ebx
801061f0:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801061f3:	8b 45 08             	mov    0x8(%ebp),%eax
801061f6:	8b 40 30             	mov    0x30(%eax),%eax
801061f9:	83 f8 40             	cmp    $0x40,%eax
801061fc:	75 3b                	jne    80106239 <trap+0x4f>
    if(myproc()->killed)
801061fe:	e8 2d d8 ff ff       	call   80103a30 <myproc>
80106203:	8b 40 24             	mov    0x24(%eax),%eax
80106206:	85 c0                	test   %eax,%eax
80106208:	74 05                	je     8010620f <trap+0x25>
      exit();
8010620a:	e8 9c dc ff ff       	call   80103eab <exit>
    myproc()->tf = tf;
8010620f:	e8 1c d8 ff ff       	call   80103a30 <myproc>
80106214:	8b 55 08             	mov    0x8(%ebp),%edx
80106217:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010621a:	e8 bb ed ff ff       	call   80104fda <syscall>
    if(myproc()->killed)
8010621f:	e8 0c d8 ff ff       	call   80103a30 <myproc>
80106224:	8b 40 24             	mov    0x24(%eax),%eax
80106227:	85 c0                	test   %eax,%eax
80106229:	0f 84 7e 02 00 00    	je     801064ad <trap+0x2c3>
      exit();
8010622f:	e8 77 dc ff ff       	call   80103eab <exit>
    return;
80106234:	e9 74 02 00 00       	jmp    801064ad <trap+0x2c3>
  }

  switch(tf->trapno){
80106239:	8b 45 08             	mov    0x8(%ebp),%eax
8010623c:	8b 40 30             	mov    0x30(%eax),%eax
8010623f:	83 e8 20             	sub    $0x20,%eax
80106242:	83 f8 1f             	cmp    $0x1f,%eax
80106245:	0f 87 2a 01 00 00    	ja     80106375 <trap+0x18b>
8010624b:	8b 04 85 e0 a7 10 80 	mov    -0x7fef5820(,%eax,4),%eax
80106252:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106254:	e8 44 d7 ff ff       	call   8010399d <cpuid>
80106259:	85 c0                	test   %eax,%eax
8010625b:	75 3d                	jne    8010629a <trap+0xb0>
      acquire(&tickslock);
8010625d:	83 ec 0c             	sub    $0xc,%esp
80106260:	68 40 6b 19 80       	push   $0x80196b40
80106265:	e8 03 e7 ff ff       	call   8010496d <acquire>
8010626a:	83 c4 10             	add    $0x10,%esp
      ticks++;
8010626d:	a1 74 6b 19 80       	mov    0x80196b74,%eax
80106272:	83 c0 01             	add    $0x1,%eax
80106275:	a3 74 6b 19 80       	mov    %eax,0x80196b74
      wakeup(&ticks);
8010627a:	83 ec 0c             	sub    $0xc,%esp
8010627d:	68 74 6b 19 80       	push   $0x80196b74
80106282:	e8 48 e1 ff ff       	call   801043cf <wakeup>
80106287:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
8010628a:	83 ec 0c             	sub    $0xc,%esp
8010628d:	68 40 6b 19 80       	push   $0x80196b40
80106292:	e8 44 e7 ff ff       	call   801049db <release>
80106297:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
8010629a:	e8 7f c8 ff ff       	call   80102b1e <lapiceoi>

// [새로 추가한 코드]
    // 현재 프로세스가 존재하고, 인터럽트가 유저 모드에서 발생했으며, 스케줄러가 등록된 경우
    if(myproc() != 0 && (tf->cs & 3) == 3 && myproc()->scheduler != 0) {
8010629f:	e8 8c d7 ff ff       	call   80103a30 <myproc>
801062a4:	85 c0                	test   %eax,%eax
801062a6:	0f 84 80 01 00 00    	je     8010642c <trap+0x242>
801062ac:	8b 45 08             	mov    0x8(%ebp),%eax
801062af:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801062b3:	0f b7 c0             	movzwl %ax,%eax
801062b6:	83 e0 03             	and    $0x3,%eax
801062b9:	83 f8 03             	cmp    $0x3,%eax
801062bc:	0f 85 6a 01 00 00    	jne    8010642c <trap+0x242>
801062c2:	e8 69 d7 ff ff       	call   80103a30 <myproc>
801062c7:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801062cd:	85 c0                	test   %eax,%eax
801062cf:	0f 84 57 01 00 00    	je     8010642c <trap+0x242>
      //cprintf("Timer interrupt: switching to user scheduler!\n"); // 트랩 시도 확인

      // 1. 유저 스택 포인터를 4바이트 내림
      tf->esp -= 4;
801062d5:	8b 45 08             	mov    0x8(%ebp),%eax
801062d8:	8b 40 44             	mov    0x44(%eax),%eax
801062db:	8d 50 fc             	lea    -0x4(%eax),%edx
801062de:	8b 45 08             	mov    0x8(%ebp),%eax
801062e1:	89 50 44             	mov    %edx,0x44(%eax)
      // 2. 원래 돌아가야 할 주소(기존 EIP)를 유저 스택에 Push
      *((uint*)(tf->esp)) = tf->eip;
801062e4:	8b 45 08             	mov    0x8(%ebp),%eax
801062e7:	8b 40 44             	mov    0x44(%eax),%eax
801062ea:	89 c2                	mov    %eax,%edx
801062ec:	8b 45 08             	mov    0x8(%ebp),%eax
801062ef:	8b 40 38             	mov    0x38(%eax),%eax
801062f2:	89 02                	mov    %eax,(%edx)
      // 3. 프로그램 카운터를 유저 스케줄러 함수의 주소로 덮어씌움
      tf->eip = myproc()->scheduler;
801062f4:	e8 37 d7 ff ff       	call   80103a30 <myproc>
801062f9:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801062ff:	8b 45 08             	mov    0x8(%ebp),%eax
80106302:	89 50 38             	mov    %edx,0x38(%eax)
    }
    break;
80106305:	e9 22 01 00 00       	jmp    8010642c <trap+0x242>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
8010630a:	e8 de 3e 00 00       	call   8010a1ed <ideintr>
    lapiceoi();
8010630f:	e8 0a c8 ff ff       	call   80102b1e <lapiceoi>
    break;
80106314:	e9 14 01 00 00       	jmp    8010642d <trap+0x243>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106319:	e8 4b c6 ff ff       	call   80102969 <kbdintr>
    lapiceoi();
8010631e:	e8 fb c7 ff ff       	call   80102b1e <lapiceoi>
    break;
80106323:	e9 05 01 00 00       	jmp    8010642d <trap+0x243>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106328:	e8 54 03 00 00       	call   80106681 <uartintr>
    lapiceoi();
8010632d:	e8 ec c7 ff ff       	call   80102b1e <lapiceoi>
    break;
80106332:	e9 f6 00 00 00       	jmp    8010642d <trap+0x243>
  case T_IRQ0 + 0xB:
    i8254_intr();
80106337:	e8 7a 2b 00 00       	call   80108eb6 <i8254_intr>
    lapiceoi();
8010633c:	e8 dd c7 ff ff       	call   80102b1e <lapiceoi>
    break;
80106341:	e9 e7 00 00 00       	jmp    8010642d <trap+0x243>
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106346:	8b 45 08             	mov    0x8(%ebp),%eax
80106349:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
8010634c:	8b 45 08             	mov    0x8(%ebp),%eax
8010634f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106353:	0f b7 d8             	movzwl %ax,%ebx
80106356:	e8 42 d6 ff ff       	call   8010399d <cpuid>
8010635b:	56                   	push   %esi
8010635c:	53                   	push   %ebx
8010635d:	50                   	push   %eax
8010635e:	68 40 a7 10 80       	push   $0x8010a740
80106363:	e8 8c a0 ff ff       	call   801003f4 <cprintf>
80106368:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010636b:	e8 ae c7 ff ff       	call   80102b1e <lapiceoi>
    break;
80106370:	e9 b8 00 00 00       	jmp    8010642d <trap+0x243>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106375:	e8 b6 d6 ff ff       	call   80103a30 <myproc>
8010637a:	85 c0                	test   %eax,%eax
8010637c:	74 11                	je     8010638f <trap+0x1a5>
8010637e:	8b 45 08             	mov    0x8(%ebp),%eax
80106381:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106385:	0f b7 c0             	movzwl %ax,%eax
80106388:	83 e0 03             	and    $0x3,%eax
8010638b:	85 c0                	test   %eax,%eax
8010638d:	75 39                	jne    801063c8 <trap+0x1de>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010638f:	e8 b7 fc ff ff       	call   8010604b <rcr2>
80106394:	89 c3                	mov    %eax,%ebx
80106396:	8b 45 08             	mov    0x8(%ebp),%eax
80106399:	8b 70 38             	mov    0x38(%eax),%esi
8010639c:	e8 fc d5 ff ff       	call   8010399d <cpuid>
801063a1:	8b 55 08             	mov    0x8(%ebp),%edx
801063a4:	8b 52 30             	mov    0x30(%edx),%edx
801063a7:	83 ec 0c             	sub    $0xc,%esp
801063aa:	53                   	push   %ebx
801063ab:	56                   	push   %esi
801063ac:	50                   	push   %eax
801063ad:	52                   	push   %edx
801063ae:	68 64 a7 10 80       	push   $0x8010a764
801063b3:	e8 3c a0 ff ff       	call   801003f4 <cprintf>
801063b8:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801063bb:	83 ec 0c             	sub    $0xc,%esp
801063be:	68 96 a7 10 80       	push   $0x8010a796
801063c3:	e8 e1 a1 ff ff       	call   801005a9 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063c8:	e8 7e fc ff ff       	call   8010604b <rcr2>
801063cd:	89 c6                	mov    %eax,%esi
801063cf:	8b 45 08             	mov    0x8(%ebp),%eax
801063d2:	8b 40 38             	mov    0x38(%eax),%eax
801063d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801063d8:	e8 c0 d5 ff ff       	call   8010399d <cpuid>
801063dd:	89 c3                	mov    %eax,%ebx
801063df:	8b 45 08             	mov    0x8(%ebp),%eax
801063e2:	8b 48 34             	mov    0x34(%eax),%ecx
801063e5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801063e8:	8b 45 08             	mov    0x8(%ebp),%eax
801063eb:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801063ee:	e8 3d d6 ff ff       	call   80103a30 <myproc>
801063f3:	8d 50 6c             	lea    0x6c(%eax),%edx
801063f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
801063f9:	e8 32 d6 ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063fe:	8b 40 10             	mov    0x10(%eax),%eax
80106401:	56                   	push   %esi
80106402:	ff 75 e4             	push   -0x1c(%ebp)
80106405:	53                   	push   %ebx
80106406:	ff 75 e0             	push   -0x20(%ebp)
80106409:	57                   	push   %edi
8010640a:	ff 75 dc             	push   -0x24(%ebp)
8010640d:	50                   	push   %eax
8010640e:	68 9c a7 10 80       	push   $0x8010a79c
80106413:	e8 dc 9f ff ff       	call   801003f4 <cprintf>
80106418:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010641b:	e8 10 d6 ff ff       	call   80103a30 <myproc>
80106420:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106427:	eb 04                	jmp    8010642d <trap+0x243>
    break;
80106429:	90                   	nop
8010642a:	eb 01                	jmp    8010642d <trap+0x243>
    break;
8010642c:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010642d:	e8 fe d5 ff ff       	call   80103a30 <myproc>
80106432:	85 c0                	test   %eax,%eax
80106434:	74 23                	je     80106459 <trap+0x26f>
80106436:	e8 f5 d5 ff ff       	call   80103a30 <myproc>
8010643b:	8b 40 24             	mov    0x24(%eax),%eax
8010643e:	85 c0                	test   %eax,%eax
80106440:	74 17                	je     80106459 <trap+0x26f>
80106442:	8b 45 08             	mov    0x8(%ebp),%eax
80106445:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106449:	0f b7 c0             	movzwl %ax,%eax
8010644c:	83 e0 03             	and    $0x3,%eax
8010644f:	83 f8 03             	cmp    $0x3,%eax
80106452:	75 05                	jne    80106459 <trap+0x26f>
    exit();
80106454:	e8 52 da ff ff       	call   80103eab <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106459:	e8 d2 d5 ff ff       	call   80103a30 <myproc>
8010645e:	85 c0                	test   %eax,%eax
80106460:	74 1d                	je     8010647f <trap+0x295>
80106462:	e8 c9 d5 ff ff       	call   80103a30 <myproc>
80106467:	8b 40 0c             	mov    0xc(%eax),%eax
8010646a:	83 f8 04             	cmp    $0x4,%eax
8010646d:	75 10                	jne    8010647f <trap+0x295>
     tf->trapno == T_IRQ0+IRQ_TIMER)
8010646f:	8b 45 08             	mov    0x8(%ebp),%eax
80106472:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106475:	83 f8 20             	cmp    $0x20,%eax
80106478:	75 05                	jne    8010647f <trap+0x295>
    yield();
8010647a:	e8 e6 dd ff ff       	call   80104265 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010647f:	e8 ac d5 ff ff       	call   80103a30 <myproc>
80106484:	85 c0                	test   %eax,%eax
80106486:	74 26                	je     801064ae <trap+0x2c4>
80106488:	e8 a3 d5 ff ff       	call   80103a30 <myproc>
8010648d:	8b 40 24             	mov    0x24(%eax),%eax
80106490:	85 c0                	test   %eax,%eax
80106492:	74 1a                	je     801064ae <trap+0x2c4>
80106494:	8b 45 08             	mov    0x8(%ebp),%eax
80106497:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010649b:	0f b7 c0             	movzwl %ax,%eax
8010649e:	83 e0 03             	and    $0x3,%eax
801064a1:	83 f8 03             	cmp    $0x3,%eax
801064a4:	75 08                	jne    801064ae <trap+0x2c4>
    exit();
801064a6:	e8 00 da ff ff       	call   80103eab <exit>
801064ab:	eb 01                	jmp    801064ae <trap+0x2c4>
    return;
801064ad:	90                   	nop
}
801064ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064b1:	5b                   	pop    %ebx
801064b2:	5e                   	pop    %esi
801064b3:	5f                   	pop    %edi
801064b4:	5d                   	pop    %ebp
801064b5:	c3                   	ret

801064b6 <inb>:
{
801064b6:	55                   	push   %ebp
801064b7:	89 e5                	mov    %esp,%ebp
801064b9:	83 ec 14             	sub    $0x14,%esp
801064bc:	8b 45 08             	mov    0x8(%ebp),%eax
801064bf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064c3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801064c7:	89 c2                	mov    %eax,%edx
801064c9:	ec                   	in     (%dx),%al
801064ca:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801064cd:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801064d1:	c9                   	leave
801064d2:	c3                   	ret

801064d3 <outb>:
{
801064d3:	55                   	push   %ebp
801064d4:	89 e5                	mov    %esp,%ebp
801064d6:	83 ec 08             	sub    $0x8,%esp
801064d9:	8b 55 08             	mov    0x8(%ebp),%edx
801064dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801064df:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801064e3:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064e6:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801064ea:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801064ee:	ee                   	out    %al,(%dx)
}
801064ef:	90                   	nop
801064f0:	c9                   	leave
801064f1:	c3                   	ret

801064f2 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801064f2:	55                   	push   %ebp
801064f3:	89 e5                	mov    %esp,%ebp
801064f5:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801064f8:	6a 00                	push   $0x0
801064fa:	68 fa 03 00 00       	push   $0x3fa
801064ff:	e8 cf ff ff ff       	call   801064d3 <outb>
80106504:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106507:	68 80 00 00 00       	push   $0x80
8010650c:	68 fb 03 00 00       	push   $0x3fb
80106511:	e8 bd ff ff ff       	call   801064d3 <outb>
80106516:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106519:	6a 0c                	push   $0xc
8010651b:	68 f8 03 00 00       	push   $0x3f8
80106520:	e8 ae ff ff ff       	call   801064d3 <outb>
80106525:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106528:	6a 00                	push   $0x0
8010652a:	68 f9 03 00 00       	push   $0x3f9
8010652f:	e8 9f ff ff ff       	call   801064d3 <outb>
80106534:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106537:	6a 03                	push   $0x3
80106539:	68 fb 03 00 00       	push   $0x3fb
8010653e:	e8 90 ff ff ff       	call   801064d3 <outb>
80106543:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106546:	6a 00                	push   $0x0
80106548:	68 fc 03 00 00       	push   $0x3fc
8010654d:	e8 81 ff ff ff       	call   801064d3 <outb>
80106552:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106555:	6a 01                	push   $0x1
80106557:	68 f9 03 00 00       	push   $0x3f9
8010655c:	e8 72 ff ff ff       	call   801064d3 <outb>
80106561:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106564:	68 fd 03 00 00       	push   $0x3fd
80106569:	e8 48 ff ff ff       	call   801064b6 <inb>
8010656e:	83 c4 04             	add    $0x4,%esp
80106571:	3c ff                	cmp    $0xff,%al
80106573:	74 61                	je     801065d6 <uartinit+0xe4>
    return;
  uart = 1;
80106575:	c7 05 78 6b 19 80 01 	movl   $0x1,0x80196b78
8010657c:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010657f:	68 fa 03 00 00       	push   $0x3fa
80106584:	e8 2d ff ff ff       	call   801064b6 <inb>
80106589:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
8010658c:	68 f8 03 00 00       	push   $0x3f8
80106591:	e8 20 ff ff ff       	call   801064b6 <inb>
80106596:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
80106599:	83 ec 08             	sub    $0x8,%esp
8010659c:	6a 00                	push   $0x0
8010659e:	6a 04                	push   $0x4
801065a0:	e8 91 c0 ff ff       	call   80102636 <ioapicenable>
801065a5:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801065a8:	c7 45 f4 60 a8 10 80 	movl   $0x8010a860,-0xc(%ebp)
801065af:	eb 19                	jmp    801065ca <uartinit+0xd8>
    uartputc(*p);
801065b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065b4:	0f b6 00             	movzbl (%eax),%eax
801065b7:	0f be c0             	movsbl %al,%eax
801065ba:	83 ec 0c             	sub    $0xc,%esp
801065bd:	50                   	push   %eax
801065be:	e8 16 00 00 00       	call   801065d9 <uartputc>
801065c3:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801065c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801065ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065cd:	0f b6 00             	movzbl (%eax),%eax
801065d0:	84 c0                	test   %al,%al
801065d2:	75 dd                	jne    801065b1 <uartinit+0xbf>
801065d4:	eb 01                	jmp    801065d7 <uartinit+0xe5>
    return;
801065d6:	90                   	nop
}
801065d7:	c9                   	leave
801065d8:	c3                   	ret

801065d9 <uartputc>:

void
uartputc(int c)
{
801065d9:	55                   	push   %ebp
801065da:	89 e5                	mov    %esp,%ebp
801065dc:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801065df:	a1 78 6b 19 80       	mov    0x80196b78,%eax
801065e4:	85 c0                	test   %eax,%eax
801065e6:	74 53                	je     8010663b <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801065ef:	eb 11                	jmp    80106602 <uartputc+0x29>
    microdelay(10);
801065f1:	83 ec 0c             	sub    $0xc,%esp
801065f4:	6a 0a                	push   $0xa
801065f6:	e8 3e c5 ff ff       	call   80102b39 <microdelay>
801065fb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106602:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106606:	7f 1a                	jg     80106622 <uartputc+0x49>
80106608:	83 ec 0c             	sub    $0xc,%esp
8010660b:	68 fd 03 00 00       	push   $0x3fd
80106610:	e8 a1 fe ff ff       	call   801064b6 <inb>
80106615:	83 c4 10             	add    $0x10,%esp
80106618:	0f b6 c0             	movzbl %al,%eax
8010661b:	83 e0 20             	and    $0x20,%eax
8010661e:	85 c0                	test   %eax,%eax
80106620:	74 cf                	je     801065f1 <uartputc+0x18>
  outb(COM1+0, c);
80106622:	8b 45 08             	mov    0x8(%ebp),%eax
80106625:	0f b6 c0             	movzbl %al,%eax
80106628:	83 ec 08             	sub    $0x8,%esp
8010662b:	50                   	push   %eax
8010662c:	68 f8 03 00 00       	push   $0x3f8
80106631:	e8 9d fe ff ff       	call   801064d3 <outb>
80106636:	83 c4 10             	add    $0x10,%esp
80106639:	eb 01                	jmp    8010663c <uartputc+0x63>
    return;
8010663b:	90                   	nop
}
8010663c:	c9                   	leave
8010663d:	c3                   	ret

8010663e <uartgetc>:

static int
uartgetc(void)
{
8010663e:	55                   	push   %ebp
8010663f:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106641:	a1 78 6b 19 80       	mov    0x80196b78,%eax
80106646:	85 c0                	test   %eax,%eax
80106648:	75 07                	jne    80106651 <uartgetc+0x13>
    return -1;
8010664a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010664f:	eb 2e                	jmp    8010667f <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106651:	68 fd 03 00 00       	push   $0x3fd
80106656:	e8 5b fe ff ff       	call   801064b6 <inb>
8010665b:	83 c4 04             	add    $0x4,%esp
8010665e:	0f b6 c0             	movzbl %al,%eax
80106661:	83 e0 01             	and    $0x1,%eax
80106664:	85 c0                	test   %eax,%eax
80106666:	75 07                	jne    8010666f <uartgetc+0x31>
    return -1;
80106668:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010666d:	eb 10                	jmp    8010667f <uartgetc+0x41>
  return inb(COM1+0);
8010666f:	68 f8 03 00 00       	push   $0x3f8
80106674:	e8 3d fe ff ff       	call   801064b6 <inb>
80106679:	83 c4 04             	add    $0x4,%esp
8010667c:	0f b6 c0             	movzbl %al,%eax
}
8010667f:	c9                   	leave
80106680:	c3                   	ret

80106681 <uartintr>:

void
uartintr(void)
{
80106681:	55                   	push   %ebp
80106682:	89 e5                	mov    %esp,%ebp
80106684:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106687:	83 ec 0c             	sub    $0xc,%esp
8010668a:	68 3e 66 10 80       	push   $0x8010663e
8010668f:	e8 42 a1 ff ff       	call   801007d6 <consoleintr>
80106694:	83 c4 10             	add    $0x10,%esp
}
80106697:	90                   	nop
80106698:	c9                   	leave
80106699:	c3                   	ret

8010669a <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $0
8010669c:	6a 00                	push   $0x0
  jmp alltraps
8010669e:	e9 5b f9 ff ff       	jmp    80105ffe <alltraps>

801066a3 <vector1>:
.globl vector1
vector1:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $1
801066a5:	6a 01                	push   $0x1
  jmp alltraps
801066a7:	e9 52 f9 ff ff       	jmp    80105ffe <alltraps>

801066ac <vector2>:
.globl vector2
vector2:
  pushl $0
801066ac:	6a 00                	push   $0x0
  pushl $2
801066ae:	6a 02                	push   $0x2
  jmp alltraps
801066b0:	e9 49 f9 ff ff       	jmp    80105ffe <alltraps>

801066b5 <vector3>:
.globl vector3
vector3:
  pushl $0
801066b5:	6a 00                	push   $0x0
  pushl $3
801066b7:	6a 03                	push   $0x3
  jmp alltraps
801066b9:	e9 40 f9 ff ff       	jmp    80105ffe <alltraps>

801066be <vector4>:
.globl vector4
vector4:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $4
801066c0:	6a 04                	push   $0x4
  jmp alltraps
801066c2:	e9 37 f9 ff ff       	jmp    80105ffe <alltraps>

801066c7 <vector5>:
.globl vector5
vector5:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $5
801066c9:	6a 05                	push   $0x5
  jmp alltraps
801066cb:	e9 2e f9 ff ff       	jmp    80105ffe <alltraps>

801066d0 <vector6>:
.globl vector6
vector6:
  pushl $0
801066d0:	6a 00                	push   $0x0
  pushl $6
801066d2:	6a 06                	push   $0x6
  jmp alltraps
801066d4:	e9 25 f9 ff ff       	jmp    80105ffe <alltraps>

801066d9 <vector7>:
.globl vector7
vector7:
  pushl $0
801066d9:	6a 00                	push   $0x0
  pushl $7
801066db:	6a 07                	push   $0x7
  jmp alltraps
801066dd:	e9 1c f9 ff ff       	jmp    80105ffe <alltraps>

801066e2 <vector8>:
.globl vector8
vector8:
  pushl $8
801066e2:	6a 08                	push   $0x8
  jmp alltraps
801066e4:	e9 15 f9 ff ff       	jmp    80105ffe <alltraps>

801066e9 <vector9>:
.globl vector9
vector9:
  pushl $0
801066e9:	6a 00                	push   $0x0
  pushl $9
801066eb:	6a 09                	push   $0x9
  jmp alltraps
801066ed:	e9 0c f9 ff ff       	jmp    80105ffe <alltraps>

801066f2 <vector10>:
.globl vector10
vector10:
  pushl $10
801066f2:	6a 0a                	push   $0xa
  jmp alltraps
801066f4:	e9 05 f9 ff ff       	jmp    80105ffe <alltraps>

801066f9 <vector11>:
.globl vector11
vector11:
  pushl $11
801066f9:	6a 0b                	push   $0xb
  jmp alltraps
801066fb:	e9 fe f8 ff ff       	jmp    80105ffe <alltraps>

80106700 <vector12>:
.globl vector12
vector12:
  pushl $12
80106700:	6a 0c                	push   $0xc
  jmp alltraps
80106702:	e9 f7 f8 ff ff       	jmp    80105ffe <alltraps>

80106707 <vector13>:
.globl vector13
vector13:
  pushl $13
80106707:	6a 0d                	push   $0xd
  jmp alltraps
80106709:	e9 f0 f8 ff ff       	jmp    80105ffe <alltraps>

8010670e <vector14>:
.globl vector14
vector14:
  pushl $14
8010670e:	6a 0e                	push   $0xe
  jmp alltraps
80106710:	e9 e9 f8 ff ff       	jmp    80105ffe <alltraps>

80106715 <vector15>:
.globl vector15
vector15:
  pushl $0
80106715:	6a 00                	push   $0x0
  pushl $15
80106717:	6a 0f                	push   $0xf
  jmp alltraps
80106719:	e9 e0 f8 ff ff       	jmp    80105ffe <alltraps>

8010671e <vector16>:
.globl vector16
vector16:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $16
80106720:	6a 10                	push   $0x10
  jmp alltraps
80106722:	e9 d7 f8 ff ff       	jmp    80105ffe <alltraps>

80106727 <vector17>:
.globl vector17
vector17:
  pushl $17
80106727:	6a 11                	push   $0x11
  jmp alltraps
80106729:	e9 d0 f8 ff ff       	jmp    80105ffe <alltraps>

8010672e <vector18>:
.globl vector18
vector18:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $18
80106730:	6a 12                	push   $0x12
  jmp alltraps
80106732:	e9 c7 f8 ff ff       	jmp    80105ffe <alltraps>

80106737 <vector19>:
.globl vector19
vector19:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $19
80106739:	6a 13                	push   $0x13
  jmp alltraps
8010673b:	e9 be f8 ff ff       	jmp    80105ffe <alltraps>

80106740 <vector20>:
.globl vector20
vector20:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $20
80106742:	6a 14                	push   $0x14
  jmp alltraps
80106744:	e9 b5 f8 ff ff       	jmp    80105ffe <alltraps>

80106749 <vector21>:
.globl vector21
vector21:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $21
8010674b:	6a 15                	push   $0x15
  jmp alltraps
8010674d:	e9 ac f8 ff ff       	jmp    80105ffe <alltraps>

80106752 <vector22>:
.globl vector22
vector22:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $22
80106754:	6a 16                	push   $0x16
  jmp alltraps
80106756:	e9 a3 f8 ff ff       	jmp    80105ffe <alltraps>

8010675b <vector23>:
.globl vector23
vector23:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $23
8010675d:	6a 17                	push   $0x17
  jmp alltraps
8010675f:	e9 9a f8 ff ff       	jmp    80105ffe <alltraps>

80106764 <vector24>:
.globl vector24
vector24:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $24
80106766:	6a 18                	push   $0x18
  jmp alltraps
80106768:	e9 91 f8 ff ff       	jmp    80105ffe <alltraps>

8010676d <vector25>:
.globl vector25
vector25:
  pushl $0
8010676d:	6a 00                	push   $0x0
  pushl $25
8010676f:	6a 19                	push   $0x19
  jmp alltraps
80106771:	e9 88 f8 ff ff       	jmp    80105ffe <alltraps>

80106776 <vector26>:
.globl vector26
vector26:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $26
80106778:	6a 1a                	push   $0x1a
  jmp alltraps
8010677a:	e9 7f f8 ff ff       	jmp    80105ffe <alltraps>

8010677f <vector27>:
.globl vector27
vector27:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $27
80106781:	6a 1b                	push   $0x1b
  jmp alltraps
80106783:	e9 76 f8 ff ff       	jmp    80105ffe <alltraps>

80106788 <vector28>:
.globl vector28
vector28:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $28
8010678a:	6a 1c                	push   $0x1c
  jmp alltraps
8010678c:	e9 6d f8 ff ff       	jmp    80105ffe <alltraps>

80106791 <vector29>:
.globl vector29
vector29:
  pushl $0
80106791:	6a 00                	push   $0x0
  pushl $29
80106793:	6a 1d                	push   $0x1d
  jmp alltraps
80106795:	e9 64 f8 ff ff       	jmp    80105ffe <alltraps>

8010679a <vector30>:
.globl vector30
vector30:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $30
8010679c:	6a 1e                	push   $0x1e
  jmp alltraps
8010679e:	e9 5b f8 ff ff       	jmp    80105ffe <alltraps>

801067a3 <vector31>:
.globl vector31
vector31:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $31
801067a5:	6a 1f                	push   $0x1f
  jmp alltraps
801067a7:	e9 52 f8 ff ff       	jmp    80105ffe <alltraps>

801067ac <vector32>:
.globl vector32
vector32:
  pushl $0
801067ac:	6a 00                	push   $0x0
  pushl $32
801067ae:	6a 20                	push   $0x20
  jmp alltraps
801067b0:	e9 49 f8 ff ff       	jmp    80105ffe <alltraps>

801067b5 <vector33>:
.globl vector33
vector33:
  pushl $0
801067b5:	6a 00                	push   $0x0
  pushl $33
801067b7:	6a 21                	push   $0x21
  jmp alltraps
801067b9:	e9 40 f8 ff ff       	jmp    80105ffe <alltraps>

801067be <vector34>:
.globl vector34
vector34:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $34
801067c0:	6a 22                	push   $0x22
  jmp alltraps
801067c2:	e9 37 f8 ff ff       	jmp    80105ffe <alltraps>

801067c7 <vector35>:
.globl vector35
vector35:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $35
801067c9:	6a 23                	push   $0x23
  jmp alltraps
801067cb:	e9 2e f8 ff ff       	jmp    80105ffe <alltraps>

801067d0 <vector36>:
.globl vector36
vector36:
  pushl $0
801067d0:	6a 00                	push   $0x0
  pushl $36
801067d2:	6a 24                	push   $0x24
  jmp alltraps
801067d4:	e9 25 f8 ff ff       	jmp    80105ffe <alltraps>

801067d9 <vector37>:
.globl vector37
vector37:
  pushl $0
801067d9:	6a 00                	push   $0x0
  pushl $37
801067db:	6a 25                	push   $0x25
  jmp alltraps
801067dd:	e9 1c f8 ff ff       	jmp    80105ffe <alltraps>

801067e2 <vector38>:
.globl vector38
vector38:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $38
801067e4:	6a 26                	push   $0x26
  jmp alltraps
801067e6:	e9 13 f8 ff ff       	jmp    80105ffe <alltraps>

801067eb <vector39>:
.globl vector39
vector39:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $39
801067ed:	6a 27                	push   $0x27
  jmp alltraps
801067ef:	e9 0a f8 ff ff       	jmp    80105ffe <alltraps>

801067f4 <vector40>:
.globl vector40
vector40:
  pushl $0
801067f4:	6a 00                	push   $0x0
  pushl $40
801067f6:	6a 28                	push   $0x28
  jmp alltraps
801067f8:	e9 01 f8 ff ff       	jmp    80105ffe <alltraps>

801067fd <vector41>:
.globl vector41
vector41:
  pushl $0
801067fd:	6a 00                	push   $0x0
  pushl $41
801067ff:	6a 29                	push   $0x29
  jmp alltraps
80106801:	e9 f8 f7 ff ff       	jmp    80105ffe <alltraps>

80106806 <vector42>:
.globl vector42
vector42:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $42
80106808:	6a 2a                	push   $0x2a
  jmp alltraps
8010680a:	e9 ef f7 ff ff       	jmp    80105ffe <alltraps>

8010680f <vector43>:
.globl vector43
vector43:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $43
80106811:	6a 2b                	push   $0x2b
  jmp alltraps
80106813:	e9 e6 f7 ff ff       	jmp    80105ffe <alltraps>

80106818 <vector44>:
.globl vector44
vector44:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $44
8010681a:	6a 2c                	push   $0x2c
  jmp alltraps
8010681c:	e9 dd f7 ff ff       	jmp    80105ffe <alltraps>

80106821 <vector45>:
.globl vector45
vector45:
  pushl $0
80106821:	6a 00                	push   $0x0
  pushl $45
80106823:	6a 2d                	push   $0x2d
  jmp alltraps
80106825:	e9 d4 f7 ff ff       	jmp    80105ffe <alltraps>

8010682a <vector46>:
.globl vector46
vector46:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $46
8010682c:	6a 2e                	push   $0x2e
  jmp alltraps
8010682e:	e9 cb f7 ff ff       	jmp    80105ffe <alltraps>

80106833 <vector47>:
.globl vector47
vector47:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $47
80106835:	6a 2f                	push   $0x2f
  jmp alltraps
80106837:	e9 c2 f7 ff ff       	jmp    80105ffe <alltraps>

8010683c <vector48>:
.globl vector48
vector48:
  pushl $0
8010683c:	6a 00                	push   $0x0
  pushl $48
8010683e:	6a 30                	push   $0x30
  jmp alltraps
80106840:	e9 b9 f7 ff ff       	jmp    80105ffe <alltraps>

80106845 <vector49>:
.globl vector49
vector49:
  pushl $0
80106845:	6a 00                	push   $0x0
  pushl $49
80106847:	6a 31                	push   $0x31
  jmp alltraps
80106849:	e9 b0 f7 ff ff       	jmp    80105ffe <alltraps>

8010684e <vector50>:
.globl vector50
vector50:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $50
80106850:	6a 32                	push   $0x32
  jmp alltraps
80106852:	e9 a7 f7 ff ff       	jmp    80105ffe <alltraps>

80106857 <vector51>:
.globl vector51
vector51:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $51
80106859:	6a 33                	push   $0x33
  jmp alltraps
8010685b:	e9 9e f7 ff ff       	jmp    80105ffe <alltraps>

80106860 <vector52>:
.globl vector52
vector52:
  pushl $0
80106860:	6a 00                	push   $0x0
  pushl $52
80106862:	6a 34                	push   $0x34
  jmp alltraps
80106864:	e9 95 f7 ff ff       	jmp    80105ffe <alltraps>

80106869 <vector53>:
.globl vector53
vector53:
  pushl $0
80106869:	6a 00                	push   $0x0
  pushl $53
8010686b:	6a 35                	push   $0x35
  jmp alltraps
8010686d:	e9 8c f7 ff ff       	jmp    80105ffe <alltraps>

80106872 <vector54>:
.globl vector54
vector54:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $54
80106874:	6a 36                	push   $0x36
  jmp alltraps
80106876:	e9 83 f7 ff ff       	jmp    80105ffe <alltraps>

8010687b <vector55>:
.globl vector55
vector55:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $55
8010687d:	6a 37                	push   $0x37
  jmp alltraps
8010687f:	e9 7a f7 ff ff       	jmp    80105ffe <alltraps>

80106884 <vector56>:
.globl vector56
vector56:
  pushl $0
80106884:	6a 00                	push   $0x0
  pushl $56
80106886:	6a 38                	push   $0x38
  jmp alltraps
80106888:	e9 71 f7 ff ff       	jmp    80105ffe <alltraps>

8010688d <vector57>:
.globl vector57
vector57:
  pushl $0
8010688d:	6a 00                	push   $0x0
  pushl $57
8010688f:	6a 39                	push   $0x39
  jmp alltraps
80106891:	e9 68 f7 ff ff       	jmp    80105ffe <alltraps>

80106896 <vector58>:
.globl vector58
vector58:
  pushl $0
80106896:	6a 00                	push   $0x0
  pushl $58
80106898:	6a 3a                	push   $0x3a
  jmp alltraps
8010689a:	e9 5f f7 ff ff       	jmp    80105ffe <alltraps>

8010689f <vector59>:
.globl vector59
vector59:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $59
801068a1:	6a 3b                	push   $0x3b
  jmp alltraps
801068a3:	e9 56 f7 ff ff       	jmp    80105ffe <alltraps>

801068a8 <vector60>:
.globl vector60
vector60:
  pushl $0
801068a8:	6a 00                	push   $0x0
  pushl $60
801068aa:	6a 3c                	push   $0x3c
  jmp alltraps
801068ac:	e9 4d f7 ff ff       	jmp    80105ffe <alltraps>

801068b1 <vector61>:
.globl vector61
vector61:
  pushl $0
801068b1:	6a 00                	push   $0x0
  pushl $61
801068b3:	6a 3d                	push   $0x3d
  jmp alltraps
801068b5:	e9 44 f7 ff ff       	jmp    80105ffe <alltraps>

801068ba <vector62>:
.globl vector62
vector62:
  pushl $0
801068ba:	6a 00                	push   $0x0
  pushl $62
801068bc:	6a 3e                	push   $0x3e
  jmp alltraps
801068be:	e9 3b f7 ff ff       	jmp    80105ffe <alltraps>

801068c3 <vector63>:
.globl vector63
vector63:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $63
801068c5:	6a 3f                	push   $0x3f
  jmp alltraps
801068c7:	e9 32 f7 ff ff       	jmp    80105ffe <alltraps>

801068cc <vector64>:
.globl vector64
vector64:
  pushl $0
801068cc:	6a 00                	push   $0x0
  pushl $64
801068ce:	6a 40                	push   $0x40
  jmp alltraps
801068d0:	e9 29 f7 ff ff       	jmp    80105ffe <alltraps>

801068d5 <vector65>:
.globl vector65
vector65:
  pushl $0
801068d5:	6a 00                	push   $0x0
  pushl $65
801068d7:	6a 41                	push   $0x41
  jmp alltraps
801068d9:	e9 20 f7 ff ff       	jmp    80105ffe <alltraps>

801068de <vector66>:
.globl vector66
vector66:
  pushl $0
801068de:	6a 00                	push   $0x0
  pushl $66
801068e0:	6a 42                	push   $0x42
  jmp alltraps
801068e2:	e9 17 f7 ff ff       	jmp    80105ffe <alltraps>

801068e7 <vector67>:
.globl vector67
vector67:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $67
801068e9:	6a 43                	push   $0x43
  jmp alltraps
801068eb:	e9 0e f7 ff ff       	jmp    80105ffe <alltraps>

801068f0 <vector68>:
.globl vector68
vector68:
  pushl $0
801068f0:	6a 00                	push   $0x0
  pushl $68
801068f2:	6a 44                	push   $0x44
  jmp alltraps
801068f4:	e9 05 f7 ff ff       	jmp    80105ffe <alltraps>

801068f9 <vector69>:
.globl vector69
vector69:
  pushl $0
801068f9:	6a 00                	push   $0x0
  pushl $69
801068fb:	6a 45                	push   $0x45
  jmp alltraps
801068fd:	e9 fc f6 ff ff       	jmp    80105ffe <alltraps>

80106902 <vector70>:
.globl vector70
vector70:
  pushl $0
80106902:	6a 00                	push   $0x0
  pushl $70
80106904:	6a 46                	push   $0x46
  jmp alltraps
80106906:	e9 f3 f6 ff ff       	jmp    80105ffe <alltraps>

8010690b <vector71>:
.globl vector71
vector71:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $71
8010690d:	6a 47                	push   $0x47
  jmp alltraps
8010690f:	e9 ea f6 ff ff       	jmp    80105ffe <alltraps>

80106914 <vector72>:
.globl vector72
vector72:
  pushl $0
80106914:	6a 00                	push   $0x0
  pushl $72
80106916:	6a 48                	push   $0x48
  jmp alltraps
80106918:	e9 e1 f6 ff ff       	jmp    80105ffe <alltraps>

8010691d <vector73>:
.globl vector73
vector73:
  pushl $0
8010691d:	6a 00                	push   $0x0
  pushl $73
8010691f:	6a 49                	push   $0x49
  jmp alltraps
80106921:	e9 d8 f6 ff ff       	jmp    80105ffe <alltraps>

80106926 <vector74>:
.globl vector74
vector74:
  pushl $0
80106926:	6a 00                	push   $0x0
  pushl $74
80106928:	6a 4a                	push   $0x4a
  jmp alltraps
8010692a:	e9 cf f6 ff ff       	jmp    80105ffe <alltraps>

8010692f <vector75>:
.globl vector75
vector75:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $75
80106931:	6a 4b                	push   $0x4b
  jmp alltraps
80106933:	e9 c6 f6 ff ff       	jmp    80105ffe <alltraps>

80106938 <vector76>:
.globl vector76
vector76:
  pushl $0
80106938:	6a 00                	push   $0x0
  pushl $76
8010693a:	6a 4c                	push   $0x4c
  jmp alltraps
8010693c:	e9 bd f6 ff ff       	jmp    80105ffe <alltraps>

80106941 <vector77>:
.globl vector77
vector77:
  pushl $0
80106941:	6a 00                	push   $0x0
  pushl $77
80106943:	6a 4d                	push   $0x4d
  jmp alltraps
80106945:	e9 b4 f6 ff ff       	jmp    80105ffe <alltraps>

8010694a <vector78>:
.globl vector78
vector78:
  pushl $0
8010694a:	6a 00                	push   $0x0
  pushl $78
8010694c:	6a 4e                	push   $0x4e
  jmp alltraps
8010694e:	e9 ab f6 ff ff       	jmp    80105ffe <alltraps>

80106953 <vector79>:
.globl vector79
vector79:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $79
80106955:	6a 4f                	push   $0x4f
  jmp alltraps
80106957:	e9 a2 f6 ff ff       	jmp    80105ffe <alltraps>

8010695c <vector80>:
.globl vector80
vector80:
  pushl $0
8010695c:	6a 00                	push   $0x0
  pushl $80
8010695e:	6a 50                	push   $0x50
  jmp alltraps
80106960:	e9 99 f6 ff ff       	jmp    80105ffe <alltraps>

80106965 <vector81>:
.globl vector81
vector81:
  pushl $0
80106965:	6a 00                	push   $0x0
  pushl $81
80106967:	6a 51                	push   $0x51
  jmp alltraps
80106969:	e9 90 f6 ff ff       	jmp    80105ffe <alltraps>

8010696e <vector82>:
.globl vector82
vector82:
  pushl $0
8010696e:	6a 00                	push   $0x0
  pushl $82
80106970:	6a 52                	push   $0x52
  jmp alltraps
80106972:	e9 87 f6 ff ff       	jmp    80105ffe <alltraps>

80106977 <vector83>:
.globl vector83
vector83:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $83
80106979:	6a 53                	push   $0x53
  jmp alltraps
8010697b:	e9 7e f6 ff ff       	jmp    80105ffe <alltraps>

80106980 <vector84>:
.globl vector84
vector84:
  pushl $0
80106980:	6a 00                	push   $0x0
  pushl $84
80106982:	6a 54                	push   $0x54
  jmp alltraps
80106984:	e9 75 f6 ff ff       	jmp    80105ffe <alltraps>

80106989 <vector85>:
.globl vector85
vector85:
  pushl $0
80106989:	6a 00                	push   $0x0
  pushl $85
8010698b:	6a 55                	push   $0x55
  jmp alltraps
8010698d:	e9 6c f6 ff ff       	jmp    80105ffe <alltraps>

80106992 <vector86>:
.globl vector86
vector86:
  pushl $0
80106992:	6a 00                	push   $0x0
  pushl $86
80106994:	6a 56                	push   $0x56
  jmp alltraps
80106996:	e9 63 f6 ff ff       	jmp    80105ffe <alltraps>

8010699b <vector87>:
.globl vector87
vector87:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $87
8010699d:	6a 57                	push   $0x57
  jmp alltraps
8010699f:	e9 5a f6 ff ff       	jmp    80105ffe <alltraps>

801069a4 <vector88>:
.globl vector88
vector88:
  pushl $0
801069a4:	6a 00                	push   $0x0
  pushl $88
801069a6:	6a 58                	push   $0x58
  jmp alltraps
801069a8:	e9 51 f6 ff ff       	jmp    80105ffe <alltraps>

801069ad <vector89>:
.globl vector89
vector89:
  pushl $0
801069ad:	6a 00                	push   $0x0
  pushl $89
801069af:	6a 59                	push   $0x59
  jmp alltraps
801069b1:	e9 48 f6 ff ff       	jmp    80105ffe <alltraps>

801069b6 <vector90>:
.globl vector90
vector90:
  pushl $0
801069b6:	6a 00                	push   $0x0
  pushl $90
801069b8:	6a 5a                	push   $0x5a
  jmp alltraps
801069ba:	e9 3f f6 ff ff       	jmp    80105ffe <alltraps>

801069bf <vector91>:
.globl vector91
vector91:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $91
801069c1:	6a 5b                	push   $0x5b
  jmp alltraps
801069c3:	e9 36 f6 ff ff       	jmp    80105ffe <alltraps>

801069c8 <vector92>:
.globl vector92
vector92:
  pushl $0
801069c8:	6a 00                	push   $0x0
  pushl $92
801069ca:	6a 5c                	push   $0x5c
  jmp alltraps
801069cc:	e9 2d f6 ff ff       	jmp    80105ffe <alltraps>

801069d1 <vector93>:
.globl vector93
vector93:
  pushl $0
801069d1:	6a 00                	push   $0x0
  pushl $93
801069d3:	6a 5d                	push   $0x5d
  jmp alltraps
801069d5:	e9 24 f6 ff ff       	jmp    80105ffe <alltraps>

801069da <vector94>:
.globl vector94
vector94:
  pushl $0
801069da:	6a 00                	push   $0x0
  pushl $94
801069dc:	6a 5e                	push   $0x5e
  jmp alltraps
801069de:	e9 1b f6 ff ff       	jmp    80105ffe <alltraps>

801069e3 <vector95>:
.globl vector95
vector95:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $95
801069e5:	6a 5f                	push   $0x5f
  jmp alltraps
801069e7:	e9 12 f6 ff ff       	jmp    80105ffe <alltraps>

801069ec <vector96>:
.globl vector96
vector96:
  pushl $0
801069ec:	6a 00                	push   $0x0
  pushl $96
801069ee:	6a 60                	push   $0x60
  jmp alltraps
801069f0:	e9 09 f6 ff ff       	jmp    80105ffe <alltraps>

801069f5 <vector97>:
.globl vector97
vector97:
  pushl $0
801069f5:	6a 00                	push   $0x0
  pushl $97
801069f7:	6a 61                	push   $0x61
  jmp alltraps
801069f9:	e9 00 f6 ff ff       	jmp    80105ffe <alltraps>

801069fe <vector98>:
.globl vector98
vector98:
  pushl $0
801069fe:	6a 00                	push   $0x0
  pushl $98
80106a00:	6a 62                	push   $0x62
  jmp alltraps
80106a02:	e9 f7 f5 ff ff       	jmp    80105ffe <alltraps>

80106a07 <vector99>:
.globl vector99
vector99:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $99
80106a09:	6a 63                	push   $0x63
  jmp alltraps
80106a0b:	e9 ee f5 ff ff       	jmp    80105ffe <alltraps>

80106a10 <vector100>:
.globl vector100
vector100:
  pushl $0
80106a10:	6a 00                	push   $0x0
  pushl $100
80106a12:	6a 64                	push   $0x64
  jmp alltraps
80106a14:	e9 e5 f5 ff ff       	jmp    80105ffe <alltraps>

80106a19 <vector101>:
.globl vector101
vector101:
  pushl $0
80106a19:	6a 00                	push   $0x0
  pushl $101
80106a1b:	6a 65                	push   $0x65
  jmp alltraps
80106a1d:	e9 dc f5 ff ff       	jmp    80105ffe <alltraps>

80106a22 <vector102>:
.globl vector102
vector102:
  pushl $0
80106a22:	6a 00                	push   $0x0
  pushl $102
80106a24:	6a 66                	push   $0x66
  jmp alltraps
80106a26:	e9 d3 f5 ff ff       	jmp    80105ffe <alltraps>

80106a2b <vector103>:
.globl vector103
vector103:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $103
80106a2d:	6a 67                	push   $0x67
  jmp alltraps
80106a2f:	e9 ca f5 ff ff       	jmp    80105ffe <alltraps>

80106a34 <vector104>:
.globl vector104
vector104:
  pushl $0
80106a34:	6a 00                	push   $0x0
  pushl $104
80106a36:	6a 68                	push   $0x68
  jmp alltraps
80106a38:	e9 c1 f5 ff ff       	jmp    80105ffe <alltraps>

80106a3d <vector105>:
.globl vector105
vector105:
  pushl $0
80106a3d:	6a 00                	push   $0x0
  pushl $105
80106a3f:	6a 69                	push   $0x69
  jmp alltraps
80106a41:	e9 b8 f5 ff ff       	jmp    80105ffe <alltraps>

80106a46 <vector106>:
.globl vector106
vector106:
  pushl $0
80106a46:	6a 00                	push   $0x0
  pushl $106
80106a48:	6a 6a                	push   $0x6a
  jmp alltraps
80106a4a:	e9 af f5 ff ff       	jmp    80105ffe <alltraps>

80106a4f <vector107>:
.globl vector107
vector107:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $107
80106a51:	6a 6b                	push   $0x6b
  jmp alltraps
80106a53:	e9 a6 f5 ff ff       	jmp    80105ffe <alltraps>

80106a58 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a58:	6a 00                	push   $0x0
  pushl $108
80106a5a:	6a 6c                	push   $0x6c
  jmp alltraps
80106a5c:	e9 9d f5 ff ff       	jmp    80105ffe <alltraps>

80106a61 <vector109>:
.globl vector109
vector109:
  pushl $0
80106a61:	6a 00                	push   $0x0
  pushl $109
80106a63:	6a 6d                	push   $0x6d
  jmp alltraps
80106a65:	e9 94 f5 ff ff       	jmp    80105ffe <alltraps>

80106a6a <vector110>:
.globl vector110
vector110:
  pushl $0
80106a6a:	6a 00                	push   $0x0
  pushl $110
80106a6c:	6a 6e                	push   $0x6e
  jmp alltraps
80106a6e:	e9 8b f5 ff ff       	jmp    80105ffe <alltraps>

80106a73 <vector111>:
.globl vector111
vector111:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $111
80106a75:	6a 6f                	push   $0x6f
  jmp alltraps
80106a77:	e9 82 f5 ff ff       	jmp    80105ffe <alltraps>

80106a7c <vector112>:
.globl vector112
vector112:
  pushl $0
80106a7c:	6a 00                	push   $0x0
  pushl $112
80106a7e:	6a 70                	push   $0x70
  jmp alltraps
80106a80:	e9 79 f5 ff ff       	jmp    80105ffe <alltraps>

80106a85 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a85:	6a 00                	push   $0x0
  pushl $113
80106a87:	6a 71                	push   $0x71
  jmp alltraps
80106a89:	e9 70 f5 ff ff       	jmp    80105ffe <alltraps>

80106a8e <vector114>:
.globl vector114
vector114:
  pushl $0
80106a8e:	6a 00                	push   $0x0
  pushl $114
80106a90:	6a 72                	push   $0x72
  jmp alltraps
80106a92:	e9 67 f5 ff ff       	jmp    80105ffe <alltraps>

80106a97 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $115
80106a99:	6a 73                	push   $0x73
  jmp alltraps
80106a9b:	e9 5e f5 ff ff       	jmp    80105ffe <alltraps>

80106aa0 <vector116>:
.globl vector116
vector116:
  pushl $0
80106aa0:	6a 00                	push   $0x0
  pushl $116
80106aa2:	6a 74                	push   $0x74
  jmp alltraps
80106aa4:	e9 55 f5 ff ff       	jmp    80105ffe <alltraps>

80106aa9 <vector117>:
.globl vector117
vector117:
  pushl $0
80106aa9:	6a 00                	push   $0x0
  pushl $117
80106aab:	6a 75                	push   $0x75
  jmp alltraps
80106aad:	e9 4c f5 ff ff       	jmp    80105ffe <alltraps>

80106ab2 <vector118>:
.globl vector118
vector118:
  pushl $0
80106ab2:	6a 00                	push   $0x0
  pushl $118
80106ab4:	6a 76                	push   $0x76
  jmp alltraps
80106ab6:	e9 43 f5 ff ff       	jmp    80105ffe <alltraps>

80106abb <vector119>:
.globl vector119
vector119:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $119
80106abd:	6a 77                	push   $0x77
  jmp alltraps
80106abf:	e9 3a f5 ff ff       	jmp    80105ffe <alltraps>

80106ac4 <vector120>:
.globl vector120
vector120:
  pushl $0
80106ac4:	6a 00                	push   $0x0
  pushl $120
80106ac6:	6a 78                	push   $0x78
  jmp alltraps
80106ac8:	e9 31 f5 ff ff       	jmp    80105ffe <alltraps>

80106acd <vector121>:
.globl vector121
vector121:
  pushl $0
80106acd:	6a 00                	push   $0x0
  pushl $121
80106acf:	6a 79                	push   $0x79
  jmp alltraps
80106ad1:	e9 28 f5 ff ff       	jmp    80105ffe <alltraps>

80106ad6 <vector122>:
.globl vector122
vector122:
  pushl $0
80106ad6:	6a 00                	push   $0x0
  pushl $122
80106ad8:	6a 7a                	push   $0x7a
  jmp alltraps
80106ada:	e9 1f f5 ff ff       	jmp    80105ffe <alltraps>

80106adf <vector123>:
.globl vector123
vector123:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $123
80106ae1:	6a 7b                	push   $0x7b
  jmp alltraps
80106ae3:	e9 16 f5 ff ff       	jmp    80105ffe <alltraps>

80106ae8 <vector124>:
.globl vector124
vector124:
  pushl $0
80106ae8:	6a 00                	push   $0x0
  pushl $124
80106aea:	6a 7c                	push   $0x7c
  jmp alltraps
80106aec:	e9 0d f5 ff ff       	jmp    80105ffe <alltraps>

80106af1 <vector125>:
.globl vector125
vector125:
  pushl $0
80106af1:	6a 00                	push   $0x0
  pushl $125
80106af3:	6a 7d                	push   $0x7d
  jmp alltraps
80106af5:	e9 04 f5 ff ff       	jmp    80105ffe <alltraps>

80106afa <vector126>:
.globl vector126
vector126:
  pushl $0
80106afa:	6a 00                	push   $0x0
  pushl $126
80106afc:	6a 7e                	push   $0x7e
  jmp alltraps
80106afe:	e9 fb f4 ff ff       	jmp    80105ffe <alltraps>

80106b03 <vector127>:
.globl vector127
vector127:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $127
80106b05:	6a 7f                	push   $0x7f
  jmp alltraps
80106b07:	e9 f2 f4 ff ff       	jmp    80105ffe <alltraps>

80106b0c <vector128>:
.globl vector128
vector128:
  pushl $0
80106b0c:	6a 00                	push   $0x0
  pushl $128
80106b0e:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106b13:	e9 e6 f4 ff ff       	jmp    80105ffe <alltraps>

80106b18 <vector129>:
.globl vector129
vector129:
  pushl $0
80106b18:	6a 00                	push   $0x0
  pushl $129
80106b1a:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106b1f:	e9 da f4 ff ff       	jmp    80105ffe <alltraps>

80106b24 <vector130>:
.globl vector130
vector130:
  pushl $0
80106b24:	6a 00                	push   $0x0
  pushl $130
80106b26:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106b2b:	e9 ce f4 ff ff       	jmp    80105ffe <alltraps>

80106b30 <vector131>:
.globl vector131
vector131:
  pushl $0
80106b30:	6a 00                	push   $0x0
  pushl $131
80106b32:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106b37:	e9 c2 f4 ff ff       	jmp    80105ffe <alltraps>

80106b3c <vector132>:
.globl vector132
vector132:
  pushl $0
80106b3c:	6a 00                	push   $0x0
  pushl $132
80106b3e:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106b43:	e9 b6 f4 ff ff       	jmp    80105ffe <alltraps>

80106b48 <vector133>:
.globl vector133
vector133:
  pushl $0
80106b48:	6a 00                	push   $0x0
  pushl $133
80106b4a:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106b4f:	e9 aa f4 ff ff       	jmp    80105ffe <alltraps>

80106b54 <vector134>:
.globl vector134
vector134:
  pushl $0
80106b54:	6a 00                	push   $0x0
  pushl $134
80106b56:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b5b:	e9 9e f4 ff ff       	jmp    80105ffe <alltraps>

80106b60 <vector135>:
.globl vector135
vector135:
  pushl $0
80106b60:	6a 00                	push   $0x0
  pushl $135
80106b62:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b67:	e9 92 f4 ff ff       	jmp    80105ffe <alltraps>

80106b6c <vector136>:
.globl vector136
vector136:
  pushl $0
80106b6c:	6a 00                	push   $0x0
  pushl $136
80106b6e:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b73:	e9 86 f4 ff ff       	jmp    80105ffe <alltraps>

80106b78 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b78:	6a 00                	push   $0x0
  pushl $137
80106b7a:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b7f:	e9 7a f4 ff ff       	jmp    80105ffe <alltraps>

80106b84 <vector138>:
.globl vector138
vector138:
  pushl $0
80106b84:	6a 00                	push   $0x0
  pushl $138
80106b86:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b8b:	e9 6e f4 ff ff       	jmp    80105ffe <alltraps>

80106b90 <vector139>:
.globl vector139
vector139:
  pushl $0
80106b90:	6a 00                	push   $0x0
  pushl $139
80106b92:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b97:	e9 62 f4 ff ff       	jmp    80105ffe <alltraps>

80106b9c <vector140>:
.globl vector140
vector140:
  pushl $0
80106b9c:	6a 00                	push   $0x0
  pushl $140
80106b9e:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106ba3:	e9 56 f4 ff ff       	jmp    80105ffe <alltraps>

80106ba8 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ba8:	6a 00                	push   $0x0
  pushl $141
80106baa:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106baf:	e9 4a f4 ff ff       	jmp    80105ffe <alltraps>

80106bb4 <vector142>:
.globl vector142
vector142:
  pushl $0
80106bb4:	6a 00                	push   $0x0
  pushl $142
80106bb6:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106bbb:	e9 3e f4 ff ff       	jmp    80105ffe <alltraps>

80106bc0 <vector143>:
.globl vector143
vector143:
  pushl $0
80106bc0:	6a 00                	push   $0x0
  pushl $143
80106bc2:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106bc7:	e9 32 f4 ff ff       	jmp    80105ffe <alltraps>

80106bcc <vector144>:
.globl vector144
vector144:
  pushl $0
80106bcc:	6a 00                	push   $0x0
  pushl $144
80106bce:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106bd3:	e9 26 f4 ff ff       	jmp    80105ffe <alltraps>

80106bd8 <vector145>:
.globl vector145
vector145:
  pushl $0
80106bd8:	6a 00                	push   $0x0
  pushl $145
80106bda:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106bdf:	e9 1a f4 ff ff       	jmp    80105ffe <alltraps>

80106be4 <vector146>:
.globl vector146
vector146:
  pushl $0
80106be4:	6a 00                	push   $0x0
  pushl $146
80106be6:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106beb:	e9 0e f4 ff ff       	jmp    80105ffe <alltraps>

80106bf0 <vector147>:
.globl vector147
vector147:
  pushl $0
80106bf0:	6a 00                	push   $0x0
  pushl $147
80106bf2:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106bf7:	e9 02 f4 ff ff       	jmp    80105ffe <alltraps>

80106bfc <vector148>:
.globl vector148
vector148:
  pushl $0
80106bfc:	6a 00                	push   $0x0
  pushl $148
80106bfe:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106c03:	e9 f6 f3 ff ff       	jmp    80105ffe <alltraps>

80106c08 <vector149>:
.globl vector149
vector149:
  pushl $0
80106c08:	6a 00                	push   $0x0
  pushl $149
80106c0a:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106c0f:	e9 ea f3 ff ff       	jmp    80105ffe <alltraps>

80106c14 <vector150>:
.globl vector150
vector150:
  pushl $0
80106c14:	6a 00                	push   $0x0
  pushl $150
80106c16:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106c1b:	e9 de f3 ff ff       	jmp    80105ffe <alltraps>

80106c20 <vector151>:
.globl vector151
vector151:
  pushl $0
80106c20:	6a 00                	push   $0x0
  pushl $151
80106c22:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106c27:	e9 d2 f3 ff ff       	jmp    80105ffe <alltraps>

80106c2c <vector152>:
.globl vector152
vector152:
  pushl $0
80106c2c:	6a 00                	push   $0x0
  pushl $152
80106c2e:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106c33:	e9 c6 f3 ff ff       	jmp    80105ffe <alltraps>

80106c38 <vector153>:
.globl vector153
vector153:
  pushl $0
80106c38:	6a 00                	push   $0x0
  pushl $153
80106c3a:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106c3f:	e9 ba f3 ff ff       	jmp    80105ffe <alltraps>

80106c44 <vector154>:
.globl vector154
vector154:
  pushl $0
80106c44:	6a 00                	push   $0x0
  pushl $154
80106c46:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106c4b:	e9 ae f3 ff ff       	jmp    80105ffe <alltraps>

80106c50 <vector155>:
.globl vector155
vector155:
  pushl $0
80106c50:	6a 00                	push   $0x0
  pushl $155
80106c52:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c57:	e9 a2 f3 ff ff       	jmp    80105ffe <alltraps>

80106c5c <vector156>:
.globl vector156
vector156:
  pushl $0
80106c5c:	6a 00                	push   $0x0
  pushl $156
80106c5e:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c63:	e9 96 f3 ff ff       	jmp    80105ffe <alltraps>

80106c68 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c68:	6a 00                	push   $0x0
  pushl $157
80106c6a:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c6f:	e9 8a f3 ff ff       	jmp    80105ffe <alltraps>

80106c74 <vector158>:
.globl vector158
vector158:
  pushl $0
80106c74:	6a 00                	push   $0x0
  pushl $158
80106c76:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c7b:	e9 7e f3 ff ff       	jmp    80105ffe <alltraps>

80106c80 <vector159>:
.globl vector159
vector159:
  pushl $0
80106c80:	6a 00                	push   $0x0
  pushl $159
80106c82:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c87:	e9 72 f3 ff ff       	jmp    80105ffe <alltraps>

80106c8c <vector160>:
.globl vector160
vector160:
  pushl $0
80106c8c:	6a 00                	push   $0x0
  pushl $160
80106c8e:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c93:	e9 66 f3 ff ff       	jmp    80105ffe <alltraps>

80106c98 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c98:	6a 00                	push   $0x0
  pushl $161
80106c9a:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c9f:	e9 5a f3 ff ff       	jmp    80105ffe <alltraps>

80106ca4 <vector162>:
.globl vector162
vector162:
  pushl $0
80106ca4:	6a 00                	push   $0x0
  pushl $162
80106ca6:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106cab:	e9 4e f3 ff ff       	jmp    80105ffe <alltraps>

80106cb0 <vector163>:
.globl vector163
vector163:
  pushl $0
80106cb0:	6a 00                	push   $0x0
  pushl $163
80106cb2:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106cb7:	e9 42 f3 ff ff       	jmp    80105ffe <alltraps>

80106cbc <vector164>:
.globl vector164
vector164:
  pushl $0
80106cbc:	6a 00                	push   $0x0
  pushl $164
80106cbe:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106cc3:	e9 36 f3 ff ff       	jmp    80105ffe <alltraps>

80106cc8 <vector165>:
.globl vector165
vector165:
  pushl $0
80106cc8:	6a 00                	push   $0x0
  pushl $165
80106cca:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106ccf:	e9 2a f3 ff ff       	jmp    80105ffe <alltraps>

80106cd4 <vector166>:
.globl vector166
vector166:
  pushl $0
80106cd4:	6a 00                	push   $0x0
  pushl $166
80106cd6:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106cdb:	e9 1e f3 ff ff       	jmp    80105ffe <alltraps>

80106ce0 <vector167>:
.globl vector167
vector167:
  pushl $0
80106ce0:	6a 00                	push   $0x0
  pushl $167
80106ce2:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106ce7:	e9 12 f3 ff ff       	jmp    80105ffe <alltraps>

80106cec <vector168>:
.globl vector168
vector168:
  pushl $0
80106cec:	6a 00                	push   $0x0
  pushl $168
80106cee:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106cf3:	e9 06 f3 ff ff       	jmp    80105ffe <alltraps>

80106cf8 <vector169>:
.globl vector169
vector169:
  pushl $0
80106cf8:	6a 00                	push   $0x0
  pushl $169
80106cfa:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106cff:	e9 fa f2 ff ff       	jmp    80105ffe <alltraps>

80106d04 <vector170>:
.globl vector170
vector170:
  pushl $0
80106d04:	6a 00                	push   $0x0
  pushl $170
80106d06:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106d0b:	e9 ee f2 ff ff       	jmp    80105ffe <alltraps>

80106d10 <vector171>:
.globl vector171
vector171:
  pushl $0
80106d10:	6a 00                	push   $0x0
  pushl $171
80106d12:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106d17:	e9 e2 f2 ff ff       	jmp    80105ffe <alltraps>

80106d1c <vector172>:
.globl vector172
vector172:
  pushl $0
80106d1c:	6a 00                	push   $0x0
  pushl $172
80106d1e:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106d23:	e9 d6 f2 ff ff       	jmp    80105ffe <alltraps>

80106d28 <vector173>:
.globl vector173
vector173:
  pushl $0
80106d28:	6a 00                	push   $0x0
  pushl $173
80106d2a:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106d2f:	e9 ca f2 ff ff       	jmp    80105ffe <alltraps>

80106d34 <vector174>:
.globl vector174
vector174:
  pushl $0
80106d34:	6a 00                	push   $0x0
  pushl $174
80106d36:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106d3b:	e9 be f2 ff ff       	jmp    80105ffe <alltraps>

80106d40 <vector175>:
.globl vector175
vector175:
  pushl $0
80106d40:	6a 00                	push   $0x0
  pushl $175
80106d42:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106d47:	e9 b2 f2 ff ff       	jmp    80105ffe <alltraps>

80106d4c <vector176>:
.globl vector176
vector176:
  pushl $0
80106d4c:	6a 00                	push   $0x0
  pushl $176
80106d4e:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106d53:	e9 a6 f2 ff ff       	jmp    80105ffe <alltraps>

80106d58 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d58:	6a 00                	push   $0x0
  pushl $177
80106d5a:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d5f:	e9 9a f2 ff ff       	jmp    80105ffe <alltraps>

80106d64 <vector178>:
.globl vector178
vector178:
  pushl $0
80106d64:	6a 00                	push   $0x0
  pushl $178
80106d66:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d6b:	e9 8e f2 ff ff       	jmp    80105ffe <alltraps>

80106d70 <vector179>:
.globl vector179
vector179:
  pushl $0
80106d70:	6a 00                	push   $0x0
  pushl $179
80106d72:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d77:	e9 82 f2 ff ff       	jmp    80105ffe <alltraps>

80106d7c <vector180>:
.globl vector180
vector180:
  pushl $0
80106d7c:	6a 00                	push   $0x0
  pushl $180
80106d7e:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d83:	e9 76 f2 ff ff       	jmp    80105ffe <alltraps>

80106d88 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d88:	6a 00                	push   $0x0
  pushl $181
80106d8a:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d8f:	e9 6a f2 ff ff       	jmp    80105ffe <alltraps>

80106d94 <vector182>:
.globl vector182
vector182:
  pushl $0
80106d94:	6a 00                	push   $0x0
  pushl $182
80106d96:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d9b:	e9 5e f2 ff ff       	jmp    80105ffe <alltraps>

80106da0 <vector183>:
.globl vector183
vector183:
  pushl $0
80106da0:	6a 00                	push   $0x0
  pushl $183
80106da2:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106da7:	e9 52 f2 ff ff       	jmp    80105ffe <alltraps>

80106dac <vector184>:
.globl vector184
vector184:
  pushl $0
80106dac:	6a 00                	push   $0x0
  pushl $184
80106dae:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106db3:	e9 46 f2 ff ff       	jmp    80105ffe <alltraps>

80106db8 <vector185>:
.globl vector185
vector185:
  pushl $0
80106db8:	6a 00                	push   $0x0
  pushl $185
80106dba:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106dbf:	e9 3a f2 ff ff       	jmp    80105ffe <alltraps>

80106dc4 <vector186>:
.globl vector186
vector186:
  pushl $0
80106dc4:	6a 00                	push   $0x0
  pushl $186
80106dc6:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106dcb:	e9 2e f2 ff ff       	jmp    80105ffe <alltraps>

80106dd0 <vector187>:
.globl vector187
vector187:
  pushl $0
80106dd0:	6a 00                	push   $0x0
  pushl $187
80106dd2:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106dd7:	e9 22 f2 ff ff       	jmp    80105ffe <alltraps>

80106ddc <vector188>:
.globl vector188
vector188:
  pushl $0
80106ddc:	6a 00                	push   $0x0
  pushl $188
80106dde:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106de3:	e9 16 f2 ff ff       	jmp    80105ffe <alltraps>

80106de8 <vector189>:
.globl vector189
vector189:
  pushl $0
80106de8:	6a 00                	push   $0x0
  pushl $189
80106dea:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106def:	e9 0a f2 ff ff       	jmp    80105ffe <alltraps>

80106df4 <vector190>:
.globl vector190
vector190:
  pushl $0
80106df4:	6a 00                	push   $0x0
  pushl $190
80106df6:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106dfb:	e9 fe f1 ff ff       	jmp    80105ffe <alltraps>

80106e00 <vector191>:
.globl vector191
vector191:
  pushl $0
80106e00:	6a 00                	push   $0x0
  pushl $191
80106e02:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106e07:	e9 f2 f1 ff ff       	jmp    80105ffe <alltraps>

80106e0c <vector192>:
.globl vector192
vector192:
  pushl $0
80106e0c:	6a 00                	push   $0x0
  pushl $192
80106e0e:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106e13:	e9 e6 f1 ff ff       	jmp    80105ffe <alltraps>

80106e18 <vector193>:
.globl vector193
vector193:
  pushl $0
80106e18:	6a 00                	push   $0x0
  pushl $193
80106e1a:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106e1f:	e9 da f1 ff ff       	jmp    80105ffe <alltraps>

80106e24 <vector194>:
.globl vector194
vector194:
  pushl $0
80106e24:	6a 00                	push   $0x0
  pushl $194
80106e26:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106e2b:	e9 ce f1 ff ff       	jmp    80105ffe <alltraps>

80106e30 <vector195>:
.globl vector195
vector195:
  pushl $0
80106e30:	6a 00                	push   $0x0
  pushl $195
80106e32:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106e37:	e9 c2 f1 ff ff       	jmp    80105ffe <alltraps>

80106e3c <vector196>:
.globl vector196
vector196:
  pushl $0
80106e3c:	6a 00                	push   $0x0
  pushl $196
80106e3e:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106e43:	e9 b6 f1 ff ff       	jmp    80105ffe <alltraps>

80106e48 <vector197>:
.globl vector197
vector197:
  pushl $0
80106e48:	6a 00                	push   $0x0
  pushl $197
80106e4a:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106e4f:	e9 aa f1 ff ff       	jmp    80105ffe <alltraps>

80106e54 <vector198>:
.globl vector198
vector198:
  pushl $0
80106e54:	6a 00                	push   $0x0
  pushl $198
80106e56:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e5b:	e9 9e f1 ff ff       	jmp    80105ffe <alltraps>

80106e60 <vector199>:
.globl vector199
vector199:
  pushl $0
80106e60:	6a 00                	push   $0x0
  pushl $199
80106e62:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e67:	e9 92 f1 ff ff       	jmp    80105ffe <alltraps>

80106e6c <vector200>:
.globl vector200
vector200:
  pushl $0
80106e6c:	6a 00                	push   $0x0
  pushl $200
80106e6e:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e73:	e9 86 f1 ff ff       	jmp    80105ffe <alltraps>

80106e78 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e78:	6a 00                	push   $0x0
  pushl $201
80106e7a:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e7f:	e9 7a f1 ff ff       	jmp    80105ffe <alltraps>

80106e84 <vector202>:
.globl vector202
vector202:
  pushl $0
80106e84:	6a 00                	push   $0x0
  pushl $202
80106e86:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e8b:	e9 6e f1 ff ff       	jmp    80105ffe <alltraps>

80106e90 <vector203>:
.globl vector203
vector203:
  pushl $0
80106e90:	6a 00                	push   $0x0
  pushl $203
80106e92:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e97:	e9 62 f1 ff ff       	jmp    80105ffe <alltraps>

80106e9c <vector204>:
.globl vector204
vector204:
  pushl $0
80106e9c:	6a 00                	push   $0x0
  pushl $204
80106e9e:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106ea3:	e9 56 f1 ff ff       	jmp    80105ffe <alltraps>

80106ea8 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ea8:	6a 00                	push   $0x0
  pushl $205
80106eaa:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106eaf:	e9 4a f1 ff ff       	jmp    80105ffe <alltraps>

80106eb4 <vector206>:
.globl vector206
vector206:
  pushl $0
80106eb4:	6a 00                	push   $0x0
  pushl $206
80106eb6:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ebb:	e9 3e f1 ff ff       	jmp    80105ffe <alltraps>

80106ec0 <vector207>:
.globl vector207
vector207:
  pushl $0
80106ec0:	6a 00                	push   $0x0
  pushl $207
80106ec2:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ec7:	e9 32 f1 ff ff       	jmp    80105ffe <alltraps>

80106ecc <vector208>:
.globl vector208
vector208:
  pushl $0
80106ecc:	6a 00                	push   $0x0
  pushl $208
80106ece:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106ed3:	e9 26 f1 ff ff       	jmp    80105ffe <alltraps>

80106ed8 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ed8:	6a 00                	push   $0x0
  pushl $209
80106eda:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106edf:	e9 1a f1 ff ff       	jmp    80105ffe <alltraps>

80106ee4 <vector210>:
.globl vector210
vector210:
  pushl $0
80106ee4:	6a 00                	push   $0x0
  pushl $210
80106ee6:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106eeb:	e9 0e f1 ff ff       	jmp    80105ffe <alltraps>

80106ef0 <vector211>:
.globl vector211
vector211:
  pushl $0
80106ef0:	6a 00                	push   $0x0
  pushl $211
80106ef2:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ef7:	e9 02 f1 ff ff       	jmp    80105ffe <alltraps>

80106efc <vector212>:
.globl vector212
vector212:
  pushl $0
80106efc:	6a 00                	push   $0x0
  pushl $212
80106efe:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106f03:	e9 f6 f0 ff ff       	jmp    80105ffe <alltraps>

80106f08 <vector213>:
.globl vector213
vector213:
  pushl $0
80106f08:	6a 00                	push   $0x0
  pushl $213
80106f0a:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106f0f:	e9 ea f0 ff ff       	jmp    80105ffe <alltraps>

80106f14 <vector214>:
.globl vector214
vector214:
  pushl $0
80106f14:	6a 00                	push   $0x0
  pushl $214
80106f16:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106f1b:	e9 de f0 ff ff       	jmp    80105ffe <alltraps>

80106f20 <vector215>:
.globl vector215
vector215:
  pushl $0
80106f20:	6a 00                	push   $0x0
  pushl $215
80106f22:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106f27:	e9 d2 f0 ff ff       	jmp    80105ffe <alltraps>

80106f2c <vector216>:
.globl vector216
vector216:
  pushl $0
80106f2c:	6a 00                	push   $0x0
  pushl $216
80106f2e:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106f33:	e9 c6 f0 ff ff       	jmp    80105ffe <alltraps>

80106f38 <vector217>:
.globl vector217
vector217:
  pushl $0
80106f38:	6a 00                	push   $0x0
  pushl $217
80106f3a:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106f3f:	e9 ba f0 ff ff       	jmp    80105ffe <alltraps>

80106f44 <vector218>:
.globl vector218
vector218:
  pushl $0
80106f44:	6a 00                	push   $0x0
  pushl $218
80106f46:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106f4b:	e9 ae f0 ff ff       	jmp    80105ffe <alltraps>

80106f50 <vector219>:
.globl vector219
vector219:
  pushl $0
80106f50:	6a 00                	push   $0x0
  pushl $219
80106f52:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f57:	e9 a2 f0 ff ff       	jmp    80105ffe <alltraps>

80106f5c <vector220>:
.globl vector220
vector220:
  pushl $0
80106f5c:	6a 00                	push   $0x0
  pushl $220
80106f5e:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f63:	e9 96 f0 ff ff       	jmp    80105ffe <alltraps>

80106f68 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f68:	6a 00                	push   $0x0
  pushl $221
80106f6a:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f6f:	e9 8a f0 ff ff       	jmp    80105ffe <alltraps>

80106f74 <vector222>:
.globl vector222
vector222:
  pushl $0
80106f74:	6a 00                	push   $0x0
  pushl $222
80106f76:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f7b:	e9 7e f0 ff ff       	jmp    80105ffe <alltraps>

80106f80 <vector223>:
.globl vector223
vector223:
  pushl $0
80106f80:	6a 00                	push   $0x0
  pushl $223
80106f82:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f87:	e9 72 f0 ff ff       	jmp    80105ffe <alltraps>

80106f8c <vector224>:
.globl vector224
vector224:
  pushl $0
80106f8c:	6a 00                	push   $0x0
  pushl $224
80106f8e:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f93:	e9 66 f0 ff ff       	jmp    80105ffe <alltraps>

80106f98 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f98:	6a 00                	push   $0x0
  pushl $225
80106f9a:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f9f:	e9 5a f0 ff ff       	jmp    80105ffe <alltraps>

80106fa4 <vector226>:
.globl vector226
vector226:
  pushl $0
80106fa4:	6a 00                	push   $0x0
  pushl $226
80106fa6:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106fab:	e9 4e f0 ff ff       	jmp    80105ffe <alltraps>

80106fb0 <vector227>:
.globl vector227
vector227:
  pushl $0
80106fb0:	6a 00                	push   $0x0
  pushl $227
80106fb2:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106fb7:	e9 42 f0 ff ff       	jmp    80105ffe <alltraps>

80106fbc <vector228>:
.globl vector228
vector228:
  pushl $0
80106fbc:	6a 00                	push   $0x0
  pushl $228
80106fbe:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106fc3:	e9 36 f0 ff ff       	jmp    80105ffe <alltraps>

80106fc8 <vector229>:
.globl vector229
vector229:
  pushl $0
80106fc8:	6a 00                	push   $0x0
  pushl $229
80106fca:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106fcf:	e9 2a f0 ff ff       	jmp    80105ffe <alltraps>

80106fd4 <vector230>:
.globl vector230
vector230:
  pushl $0
80106fd4:	6a 00                	push   $0x0
  pushl $230
80106fd6:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106fdb:	e9 1e f0 ff ff       	jmp    80105ffe <alltraps>

80106fe0 <vector231>:
.globl vector231
vector231:
  pushl $0
80106fe0:	6a 00                	push   $0x0
  pushl $231
80106fe2:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106fe7:	e9 12 f0 ff ff       	jmp    80105ffe <alltraps>

80106fec <vector232>:
.globl vector232
vector232:
  pushl $0
80106fec:	6a 00                	push   $0x0
  pushl $232
80106fee:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ff3:	e9 06 f0 ff ff       	jmp    80105ffe <alltraps>

80106ff8 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ff8:	6a 00                	push   $0x0
  pushl $233
80106ffa:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106fff:	e9 fa ef ff ff       	jmp    80105ffe <alltraps>

80107004 <vector234>:
.globl vector234
vector234:
  pushl $0
80107004:	6a 00                	push   $0x0
  pushl $234
80107006:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010700b:	e9 ee ef ff ff       	jmp    80105ffe <alltraps>

80107010 <vector235>:
.globl vector235
vector235:
  pushl $0
80107010:	6a 00                	push   $0x0
  pushl $235
80107012:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107017:	e9 e2 ef ff ff       	jmp    80105ffe <alltraps>

8010701c <vector236>:
.globl vector236
vector236:
  pushl $0
8010701c:	6a 00                	push   $0x0
  pushl $236
8010701e:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107023:	e9 d6 ef ff ff       	jmp    80105ffe <alltraps>

80107028 <vector237>:
.globl vector237
vector237:
  pushl $0
80107028:	6a 00                	push   $0x0
  pushl $237
8010702a:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010702f:	e9 ca ef ff ff       	jmp    80105ffe <alltraps>

80107034 <vector238>:
.globl vector238
vector238:
  pushl $0
80107034:	6a 00                	push   $0x0
  pushl $238
80107036:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010703b:	e9 be ef ff ff       	jmp    80105ffe <alltraps>

80107040 <vector239>:
.globl vector239
vector239:
  pushl $0
80107040:	6a 00                	push   $0x0
  pushl $239
80107042:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107047:	e9 b2 ef ff ff       	jmp    80105ffe <alltraps>

8010704c <vector240>:
.globl vector240
vector240:
  pushl $0
8010704c:	6a 00                	push   $0x0
  pushl $240
8010704e:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107053:	e9 a6 ef ff ff       	jmp    80105ffe <alltraps>

80107058 <vector241>:
.globl vector241
vector241:
  pushl $0
80107058:	6a 00                	push   $0x0
  pushl $241
8010705a:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010705f:	e9 9a ef ff ff       	jmp    80105ffe <alltraps>

80107064 <vector242>:
.globl vector242
vector242:
  pushl $0
80107064:	6a 00                	push   $0x0
  pushl $242
80107066:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010706b:	e9 8e ef ff ff       	jmp    80105ffe <alltraps>

80107070 <vector243>:
.globl vector243
vector243:
  pushl $0
80107070:	6a 00                	push   $0x0
  pushl $243
80107072:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107077:	e9 82 ef ff ff       	jmp    80105ffe <alltraps>

8010707c <vector244>:
.globl vector244
vector244:
  pushl $0
8010707c:	6a 00                	push   $0x0
  pushl $244
8010707e:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107083:	e9 76 ef ff ff       	jmp    80105ffe <alltraps>

80107088 <vector245>:
.globl vector245
vector245:
  pushl $0
80107088:	6a 00                	push   $0x0
  pushl $245
8010708a:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010708f:	e9 6a ef ff ff       	jmp    80105ffe <alltraps>

80107094 <vector246>:
.globl vector246
vector246:
  pushl $0
80107094:	6a 00                	push   $0x0
  pushl $246
80107096:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010709b:	e9 5e ef ff ff       	jmp    80105ffe <alltraps>

801070a0 <vector247>:
.globl vector247
vector247:
  pushl $0
801070a0:	6a 00                	push   $0x0
  pushl $247
801070a2:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801070a7:	e9 52 ef ff ff       	jmp    80105ffe <alltraps>

801070ac <vector248>:
.globl vector248
vector248:
  pushl $0
801070ac:	6a 00                	push   $0x0
  pushl $248
801070ae:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801070b3:	e9 46 ef ff ff       	jmp    80105ffe <alltraps>

801070b8 <vector249>:
.globl vector249
vector249:
  pushl $0
801070b8:	6a 00                	push   $0x0
  pushl $249
801070ba:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801070bf:	e9 3a ef ff ff       	jmp    80105ffe <alltraps>

801070c4 <vector250>:
.globl vector250
vector250:
  pushl $0
801070c4:	6a 00                	push   $0x0
  pushl $250
801070c6:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801070cb:	e9 2e ef ff ff       	jmp    80105ffe <alltraps>

801070d0 <vector251>:
.globl vector251
vector251:
  pushl $0
801070d0:	6a 00                	push   $0x0
  pushl $251
801070d2:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801070d7:	e9 22 ef ff ff       	jmp    80105ffe <alltraps>

801070dc <vector252>:
.globl vector252
vector252:
  pushl $0
801070dc:	6a 00                	push   $0x0
  pushl $252
801070de:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801070e3:	e9 16 ef ff ff       	jmp    80105ffe <alltraps>

801070e8 <vector253>:
.globl vector253
vector253:
  pushl $0
801070e8:	6a 00                	push   $0x0
  pushl $253
801070ea:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801070ef:	e9 0a ef ff ff       	jmp    80105ffe <alltraps>

801070f4 <vector254>:
.globl vector254
vector254:
  pushl $0
801070f4:	6a 00                	push   $0x0
  pushl $254
801070f6:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801070fb:	e9 fe ee ff ff       	jmp    80105ffe <alltraps>

80107100 <vector255>:
.globl vector255
vector255:
  pushl $0
80107100:	6a 00                	push   $0x0
  pushl $255
80107102:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107107:	e9 f2 ee ff ff       	jmp    80105ffe <alltraps>

8010710c <lgdt>:
{
8010710c:	55                   	push   %ebp
8010710d:	89 e5                	mov    %esp,%ebp
8010710f:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107112:	8b 45 0c             	mov    0xc(%ebp),%eax
80107115:	83 e8 01             	sub    $0x1,%eax
80107118:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010711c:	8b 45 08             	mov    0x8(%ebp),%eax
8010711f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107123:	8b 45 08             	mov    0x8(%ebp),%eax
80107126:	c1 e8 10             	shr    $0x10,%eax
80107129:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010712d:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107130:	0f 01 10             	lgdtl  (%eax)
}
80107133:	90                   	nop
80107134:	c9                   	leave
80107135:	c3                   	ret

80107136 <ltr>:
{
80107136:	55                   	push   %ebp
80107137:	89 e5                	mov    %esp,%ebp
80107139:	83 ec 04             	sub    $0x4,%esp
8010713c:	8b 45 08             	mov    0x8(%ebp),%eax
8010713f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107143:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107147:	0f 00 d8             	ltr    %eax
}
8010714a:	90                   	nop
8010714b:	c9                   	leave
8010714c:	c3                   	ret

8010714d <lcr3>:

static inline void
lcr3(uint val)
{
8010714d:	55                   	push   %ebp
8010714e:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107150:	8b 45 08             	mov    0x8(%ebp),%eax
80107153:	0f 22 d8             	mov    %eax,%cr3
}
80107156:	90                   	nop
80107157:	5d                   	pop    %ebp
80107158:	c3                   	ret

80107159 <seginit>:
extern struct gpu gpu;
// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107159:	55                   	push   %ebp
8010715a:	89 e5                	mov    %esp,%ebp
8010715c:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
8010715f:	e8 39 c8 ff ff       	call   8010399d <cpuid>
80107164:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010716a:	05 80 6b 19 80       	add    $0x80196b80,%eax
8010716f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107172:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107175:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010717b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010717e:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107184:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107187:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010718b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010718e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107192:	83 e2 f0             	and    $0xfffffff0,%edx
80107195:	83 ca 0a             	or     $0xa,%edx
80107198:	88 50 7d             	mov    %dl,0x7d(%eax)
8010719b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010719e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801071a2:	83 ca 10             	or     $0x10,%edx
801071a5:	88 50 7d             	mov    %dl,0x7d(%eax)
801071a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ab:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801071af:	83 e2 9f             	and    $0xffffff9f,%edx
801071b2:	88 50 7d             	mov    %dl,0x7d(%eax)
801071b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071b8:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801071bc:	83 ca 80             	or     $0xffffff80,%edx
801071bf:	88 50 7d             	mov    %dl,0x7d(%eax)
801071c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071c5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071c9:	83 ca 0f             	or     $0xf,%edx
801071cc:	88 50 7e             	mov    %dl,0x7e(%eax)
801071cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071d2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071d6:	83 e2 ef             	and    $0xffffffef,%edx
801071d9:	88 50 7e             	mov    %dl,0x7e(%eax)
801071dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071df:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071e3:	83 e2 df             	and    $0xffffffdf,%edx
801071e6:	88 50 7e             	mov    %dl,0x7e(%eax)
801071e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ec:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071f0:	83 ca 40             	or     $0x40,%edx
801071f3:	88 50 7e             	mov    %dl,0x7e(%eax)
801071f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071f9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801071fd:	83 ca 80             	or     $0xffffff80,%edx
80107200:	88 50 7e             	mov    %dl,0x7e(%eax)
80107203:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107206:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010720a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010720d:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107214:	ff ff 
80107216:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107219:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107220:	00 00 
80107222:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107225:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010722c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010722f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107236:	83 e2 f0             	and    $0xfffffff0,%edx
80107239:	83 ca 02             	or     $0x2,%edx
8010723c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107242:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107245:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010724c:	83 ca 10             	or     $0x10,%edx
8010724f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107255:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107258:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010725f:	83 e2 9f             	and    $0xffffff9f,%edx
80107262:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107268:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010726b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107272:	83 ca 80             	or     $0xffffff80,%edx
80107275:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010727b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010727e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107285:	83 ca 0f             	or     $0xf,%edx
80107288:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010728e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107291:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107298:	83 e2 ef             	and    $0xffffffef,%edx
8010729b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801072a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072a4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801072ab:	83 e2 df             	and    $0xffffffdf,%edx
801072ae:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801072b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072b7:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801072be:	83 ca 40             	or     $0x40,%edx
801072c1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801072c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ca:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801072d1:	83 ca 80             	or     $0xffffff80,%edx
801072d4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801072da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072dd:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e7:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
801072ee:	ff ff 
801072f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072f3:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
801072fa:	00 00 
801072fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ff:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107309:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107310:	83 e2 f0             	and    $0xfffffff0,%edx
80107313:	83 ca 0a             	or     $0xa,%edx
80107316:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010731c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010731f:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107326:	83 ca 10             	or     $0x10,%edx
80107329:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010732f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107332:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107339:	83 ca 60             	or     $0x60,%edx
8010733c:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107342:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107345:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010734c:	83 ca 80             	or     $0xffffff80,%edx
8010734f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107358:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010735f:	83 ca 0f             	or     $0xf,%edx
80107362:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107368:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010736b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107372:	83 e2 ef             	and    $0xffffffef,%edx
80107375:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010737b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010737e:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107385:	83 e2 df             	and    $0xffffffdf,%edx
80107388:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010738e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107391:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107398:	83 ca 40             	or     $0x40,%edx
8010739b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801073a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073a4:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801073ab:	83 ca 80             	or     $0xffffff80,%edx
801073ae:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801073b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073b7:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801073be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c1:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801073c8:	ff ff 
801073ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073cd:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801073d4:	00 00 
801073d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d9:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801073e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073e3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801073ea:	83 e2 f0             	and    $0xfffffff0,%edx
801073ed:	83 ca 02             	or     $0x2,%edx
801073f0:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801073f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f9:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107400:	83 ca 10             	or     $0x10,%edx
80107403:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107409:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010740c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107413:	83 ca 60             	or     $0x60,%edx
80107416:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010741c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010741f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107426:	83 ca 80             	or     $0xffffff80,%edx
80107429:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010742f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107432:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107439:	83 ca 0f             	or     $0xf,%edx
8010743c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107442:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107445:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010744c:	83 e2 ef             	and    $0xffffffef,%edx
8010744f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107455:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107458:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010745f:	83 e2 df             	and    $0xffffffdf,%edx
80107462:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107468:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010746b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107472:	83 ca 40             	or     $0x40,%edx
80107475:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010747b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010747e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107485:	83 ca 80             	or     $0xffffff80,%edx
80107488:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010748e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107491:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107498:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010749b:	83 c0 70             	add    $0x70,%eax
8010749e:	83 ec 08             	sub    $0x8,%esp
801074a1:	6a 30                	push   $0x30
801074a3:	50                   	push   %eax
801074a4:	e8 63 fc ff ff       	call   8010710c <lgdt>
801074a9:	83 c4 10             	add    $0x10,%esp
}
801074ac:	90                   	nop
801074ad:	c9                   	leave
801074ae:	c3                   	ret

801074af <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801074af:	55                   	push   %ebp
801074b0:	89 e5                	mov    %esp,%ebp
801074b2:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801074b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801074b8:	c1 e8 16             	shr    $0x16,%eax
801074bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801074c2:	8b 45 08             	mov    0x8(%ebp),%eax
801074c5:	01 d0                	add    %edx,%eax
801074c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801074ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074cd:	8b 00                	mov    (%eax),%eax
801074cf:	83 e0 01             	and    $0x1,%eax
801074d2:	85 c0                	test   %eax,%eax
801074d4:	74 14                	je     801074ea <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074d9:	8b 00                	mov    (%eax),%eax
801074db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074e0:	05 00 00 00 80       	add    $0x80000000,%eax
801074e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074e8:	eb 42                	jmp    8010752c <walkpgdir+0x7d>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801074ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801074ee:	74 0e                	je     801074fe <walkpgdir+0x4f>
801074f0:	e8 b3 b2 ff ff       	call   801027a8 <kalloc>
801074f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801074fc:	75 07                	jne    80107505 <walkpgdir+0x56>
      return 0;
801074fe:	b8 00 00 00 00       	mov    $0x0,%eax
80107503:	eb 3e                	jmp    80107543 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107505:	83 ec 04             	sub    $0x4,%esp
80107508:	68 00 10 00 00       	push   $0x1000
8010750d:	6a 00                	push   $0x0
8010750f:	ff 75 f4             	push   -0xc(%ebp)
80107512:	e8 cc d6 ff ff       	call   80104be3 <memset>
80107517:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010751a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010751d:	05 00 00 00 80       	add    $0x80000000,%eax
80107522:	83 c8 07             	or     $0x7,%eax
80107525:	89 c2                	mov    %eax,%edx
80107527:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010752a:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010752c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010752f:	c1 e8 0c             	shr    $0xc,%eax
80107532:	25 ff 03 00 00       	and    $0x3ff,%eax
80107537:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010753e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107541:	01 d0                	add    %edx,%eax
}
80107543:	c9                   	leave
80107544:	c3                   	ret

80107545 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107545:	55                   	push   %ebp
80107546:	89 e5                	mov    %esp,%ebp
80107548:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010754b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010754e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107553:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107556:	8b 55 0c             	mov    0xc(%ebp),%edx
80107559:	8b 45 10             	mov    0x10(%ebp),%eax
8010755c:	01 d0                	add    %edx,%eax
8010755e:	83 e8 01             	sub    $0x1,%eax
80107561:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107566:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107569:	83 ec 04             	sub    $0x4,%esp
8010756c:	6a 01                	push   $0x1
8010756e:	ff 75 f4             	push   -0xc(%ebp)
80107571:	ff 75 08             	push   0x8(%ebp)
80107574:	e8 36 ff ff ff       	call   801074af <walkpgdir>
80107579:	83 c4 10             	add    $0x10,%esp
8010757c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010757f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107583:	75 07                	jne    8010758c <mappages+0x47>
      return -1;
80107585:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010758a:	eb 47                	jmp    801075d3 <mappages+0x8e>
    if(*pte & PTE_P)
8010758c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010758f:	8b 00                	mov    (%eax),%eax
80107591:	83 e0 01             	and    $0x1,%eax
80107594:	85 c0                	test   %eax,%eax
80107596:	74 0d                	je     801075a5 <mappages+0x60>
      panic("remap");
80107598:	83 ec 0c             	sub    $0xc,%esp
8010759b:	68 68 a8 10 80       	push   $0x8010a868
801075a0:	e8 04 90 ff ff       	call   801005a9 <panic>
    *pte = pa | perm | PTE_P;
801075a5:	8b 45 18             	mov    0x18(%ebp),%eax
801075a8:	0b 45 14             	or     0x14(%ebp),%eax
801075ab:	83 c8 01             	or     $0x1,%eax
801075ae:	89 c2                	mov    %eax,%edx
801075b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801075b3:	89 10                	mov    %edx,(%eax)
    if(a == last)
801075b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801075bb:	74 10                	je     801075cd <mappages+0x88>
      break;
    a += PGSIZE;
801075bd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801075c4:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801075cb:	eb 9c                	jmp    80107569 <mappages+0x24>
      break;
801075cd:	90                   	nop
  }
  return 0;
801075ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
801075d3:	c9                   	leave
801075d4:	c3                   	ret

801075d5 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801075d5:	55                   	push   %ebp
801075d6:	89 e5                	mov    %esp,%ebp
801075d8:	53                   	push   %ebx
801075d9:	83 ec 24             	sub    $0x24,%esp
  pde_t *pgdir;
  struct kmap *k;
  k = kmap;
801075dc:	c7 45 f4 a0 f4 10 80 	movl   $0x8010f4a0,-0xc(%ebp)
  struct kmap vram = { (void*)(DEVSPACE - gpu.vram_size),gpu.pvram_addr,gpu.pvram_addr+gpu.vram_size, PTE_W};
801075e3:	a1 50 6e 19 80       	mov    0x80196e50,%eax
801075e8:	ba 00 00 00 fe       	mov    $0xfe000000,%edx
801075ed:	29 c2                	sub    %eax,%edx
801075ef:	89 d0                	mov    %edx,%eax
801075f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801075f4:	a1 48 6e 19 80       	mov    0x80196e48,%eax
801075f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801075fc:	8b 15 48 6e 19 80    	mov    0x80196e48,%edx
80107602:	a1 50 6e 19 80       	mov    0x80196e50,%eax
80107607:	01 d0                	add    %edx,%eax
80107609:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010760c:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
  k[3] = vram;
80107613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107616:	83 c0 30             	add    $0x30,%eax
80107619:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010761c:	89 10                	mov    %edx,(%eax)
8010761e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107621:	89 50 04             	mov    %edx,0x4(%eax)
80107624:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107627:	89 50 08             	mov    %edx,0x8(%eax)
8010762a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010762d:	89 50 0c             	mov    %edx,0xc(%eax)
  if((pgdir = (pde_t*)kalloc()) == 0){
80107630:	e8 73 b1 ff ff       	call   801027a8 <kalloc>
80107635:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107638:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010763c:	75 07                	jne    80107645 <setupkvm+0x70>
    return 0;
8010763e:	b8 00 00 00 00       	mov    $0x0,%eax
80107643:	eb 78                	jmp    801076bd <setupkvm+0xe8>
  }
  memset(pgdir, 0, PGSIZE);
80107645:	83 ec 04             	sub    $0x4,%esp
80107648:	68 00 10 00 00       	push   $0x1000
8010764d:	6a 00                	push   $0x0
8010764f:	ff 75 f0             	push   -0x10(%ebp)
80107652:	e8 8c d5 ff ff       	call   80104be3 <memset>
80107657:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010765a:	c7 45 f4 a0 f4 10 80 	movl   $0x8010f4a0,-0xc(%ebp)
80107661:	eb 4e                	jmp    801076b1 <setupkvm+0xdc>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107663:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107666:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
80107669:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010766c:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010766f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107672:	8b 58 08             	mov    0x8(%eax),%ebx
80107675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107678:	8b 40 04             	mov    0x4(%eax),%eax
8010767b:	29 c3                	sub    %eax,%ebx
8010767d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107680:	8b 00                	mov    (%eax),%eax
80107682:	83 ec 0c             	sub    $0xc,%esp
80107685:	51                   	push   %ecx
80107686:	52                   	push   %edx
80107687:	53                   	push   %ebx
80107688:	50                   	push   %eax
80107689:	ff 75 f0             	push   -0x10(%ebp)
8010768c:	e8 b4 fe ff ff       	call   80107545 <mappages>
80107691:	83 c4 20             	add    $0x20,%esp
80107694:	85 c0                	test   %eax,%eax
80107696:	79 15                	jns    801076ad <setupkvm+0xd8>
      freevm(pgdir);
80107698:	83 ec 0c             	sub    $0xc,%esp
8010769b:	ff 75 f0             	push   -0x10(%ebp)
8010769e:	e8 f5 04 00 00       	call   80107b98 <freevm>
801076a3:	83 c4 10             	add    $0x10,%esp
      return 0;
801076a6:	b8 00 00 00 00       	mov    $0x0,%eax
801076ab:	eb 10                	jmp    801076bd <setupkvm+0xe8>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076ad:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801076b1:	81 7d f4 00 f5 10 80 	cmpl   $0x8010f500,-0xc(%ebp)
801076b8:	72 a9                	jb     80107663 <setupkvm+0x8e>
    }
  return pgdir;
801076ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801076bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801076c0:	c9                   	leave
801076c1:	c3                   	ret

801076c2 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801076c2:	55                   	push   %ebp
801076c3:	89 e5                	mov    %esp,%ebp
801076c5:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801076c8:	e8 08 ff ff ff       	call   801075d5 <setupkvm>
801076cd:	a3 7c 6b 19 80       	mov    %eax,0x80196b7c
  switchkvm();
801076d2:	e8 03 00 00 00       	call   801076da <switchkvm>
}
801076d7:	90                   	nop
801076d8:	c9                   	leave
801076d9:	c3                   	ret

801076da <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801076da:	55                   	push   %ebp
801076db:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801076dd:	a1 7c 6b 19 80       	mov    0x80196b7c,%eax
801076e2:	05 00 00 00 80       	add    $0x80000000,%eax
801076e7:	50                   	push   %eax
801076e8:	e8 60 fa ff ff       	call   8010714d <lcr3>
801076ed:	83 c4 04             	add    $0x4,%esp
}
801076f0:	90                   	nop
801076f1:	c9                   	leave
801076f2:	c3                   	ret

801076f3 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801076f3:	55                   	push   %ebp
801076f4:	89 e5                	mov    %esp,%ebp
801076f6:	56                   	push   %esi
801076f7:	53                   	push   %ebx
801076f8:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
801076fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801076ff:	75 0d                	jne    8010770e <switchuvm+0x1b>
    panic("switchuvm: no process");
80107701:	83 ec 0c             	sub    $0xc,%esp
80107704:	68 6e a8 10 80       	push   $0x8010a86e
80107709:	e8 9b 8e ff ff       	call   801005a9 <panic>
  if(p->kstack == 0)
8010770e:	8b 45 08             	mov    0x8(%ebp),%eax
80107711:	8b 40 08             	mov    0x8(%eax),%eax
80107714:	85 c0                	test   %eax,%eax
80107716:	75 0d                	jne    80107725 <switchuvm+0x32>
    panic("switchuvm: no kstack");
80107718:	83 ec 0c             	sub    $0xc,%esp
8010771b:	68 84 a8 10 80       	push   $0x8010a884
80107720:	e8 84 8e ff ff       	call   801005a9 <panic>
  if(p->pgdir == 0)
80107725:	8b 45 08             	mov    0x8(%ebp),%eax
80107728:	8b 40 04             	mov    0x4(%eax),%eax
8010772b:	85 c0                	test   %eax,%eax
8010772d:	75 0d                	jne    8010773c <switchuvm+0x49>
    panic("switchuvm: no pgdir");
8010772f:	83 ec 0c             	sub    $0xc,%esp
80107732:	68 99 a8 10 80       	push   $0x8010a899
80107737:	e8 6d 8e ff ff       	call   801005a9 <panic>

  pushcli();
8010773c:	e8 97 d3 ff ff       	call   80104ad8 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107741:	e8 72 c2 ff ff       	call   801039b8 <mycpu>
80107746:	89 c3                	mov    %eax,%ebx
80107748:	e8 6b c2 ff ff       	call   801039b8 <mycpu>
8010774d:	83 c0 08             	add    $0x8,%eax
80107750:	89 c6                	mov    %eax,%esi
80107752:	e8 61 c2 ff ff       	call   801039b8 <mycpu>
80107757:	83 c0 08             	add    $0x8,%eax
8010775a:	c1 e8 10             	shr    $0x10,%eax
8010775d:	88 45 f7             	mov    %al,-0x9(%ebp)
80107760:	e8 53 c2 ff ff       	call   801039b8 <mycpu>
80107765:	83 c0 08             	add    $0x8,%eax
80107768:	c1 e8 18             	shr    $0x18,%eax
8010776b:	89 c2                	mov    %eax,%edx
8010776d:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107774:	67 00 
80107776:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
8010777d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
80107781:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
80107787:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
8010778e:	83 e0 f0             	and    $0xfffffff0,%eax
80107791:	83 c8 09             	or     $0x9,%eax
80107794:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010779a:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801077a1:	83 c8 10             	or     $0x10,%eax
801077a4:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801077aa:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801077b1:	83 e0 9f             	and    $0xffffff9f,%eax
801077b4:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801077ba:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801077c1:	83 c8 80             	or     $0xffffff80,%eax
801077c4:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801077ca:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077d1:	83 e0 f0             	and    $0xfffffff0,%eax
801077d4:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077da:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077e1:	83 e0 ef             	and    $0xffffffef,%eax
801077e4:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077ea:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
801077f1:	83 e0 df             	and    $0xffffffdf,%eax
801077f4:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
801077fa:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107801:	83 c8 40             	or     $0x40,%eax
80107804:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010780a:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80107811:	83 e0 7f             	and    $0x7f,%eax
80107814:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010781a:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107820:	e8 93 c1 ff ff       	call   801039b8 <mycpu>
80107825:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010782c:	83 e2 ef             	and    $0xffffffef,%edx
8010782f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107835:	e8 7e c1 ff ff       	call   801039b8 <mycpu>
8010783a:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107840:	8b 45 08             	mov    0x8(%ebp),%eax
80107843:	8b 40 08             	mov    0x8(%eax),%eax
80107846:	89 c3                	mov    %eax,%ebx
80107848:	e8 6b c1 ff ff       	call   801039b8 <mycpu>
8010784d:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
80107853:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107856:	e8 5d c1 ff ff       	call   801039b8 <mycpu>
8010785b:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107861:	83 ec 0c             	sub    $0xc,%esp
80107864:	6a 28                	push   $0x28
80107866:	e8 cb f8 ff ff       	call   80107136 <ltr>
8010786b:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010786e:	8b 45 08             	mov    0x8(%ebp),%eax
80107871:	8b 40 04             	mov    0x4(%eax),%eax
80107874:	05 00 00 00 80       	add    $0x80000000,%eax
80107879:	83 ec 0c             	sub    $0xc,%esp
8010787c:	50                   	push   %eax
8010787d:	e8 cb f8 ff ff       	call   8010714d <lcr3>
80107882:	83 c4 10             	add    $0x10,%esp
  popcli();
80107885:	e8 9b d2 ff ff       	call   80104b25 <popcli>
}
8010788a:	90                   	nop
8010788b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010788e:	5b                   	pop    %ebx
8010788f:	5e                   	pop    %esi
80107890:	5d                   	pop    %ebp
80107891:	c3                   	ret

80107892 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107892:	55                   	push   %ebp
80107893:	89 e5                	mov    %esp,%ebp
80107895:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
80107898:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010789f:	76 0d                	jbe    801078ae <inituvm+0x1c>
    panic("inituvm: more than a page");
801078a1:	83 ec 0c             	sub    $0xc,%esp
801078a4:	68 ad a8 10 80       	push   $0x8010a8ad
801078a9:	e8 fb 8c ff ff       	call   801005a9 <panic>
  mem = kalloc();
801078ae:	e8 f5 ae ff ff       	call   801027a8 <kalloc>
801078b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801078b6:	83 ec 04             	sub    $0x4,%esp
801078b9:	68 00 10 00 00       	push   $0x1000
801078be:	6a 00                	push   $0x0
801078c0:	ff 75 f4             	push   -0xc(%ebp)
801078c3:	e8 1b d3 ff ff       	call   80104be3 <memset>
801078c8:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801078cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ce:	05 00 00 00 80       	add    $0x80000000,%eax
801078d3:	83 ec 0c             	sub    $0xc,%esp
801078d6:	6a 06                	push   $0x6
801078d8:	50                   	push   %eax
801078d9:	68 00 10 00 00       	push   $0x1000
801078de:	6a 00                	push   $0x0
801078e0:	ff 75 08             	push   0x8(%ebp)
801078e3:	e8 5d fc ff ff       	call   80107545 <mappages>
801078e8:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801078eb:	83 ec 04             	sub    $0x4,%esp
801078ee:	ff 75 10             	push   0x10(%ebp)
801078f1:	ff 75 0c             	push   0xc(%ebp)
801078f4:	ff 75 f4             	push   -0xc(%ebp)
801078f7:	e8 a6 d3 ff ff       	call   80104ca2 <memmove>
801078fc:	83 c4 10             	add    $0x10,%esp
}
801078ff:	90                   	nop
80107900:	c9                   	leave
80107901:	c3                   	ret

80107902 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107902:	55                   	push   %ebp
80107903:	89 e5                	mov    %esp,%ebp
80107905:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107908:	8b 45 0c             	mov    0xc(%ebp),%eax
8010790b:	25 ff 0f 00 00       	and    $0xfff,%eax
80107910:	85 c0                	test   %eax,%eax
80107912:	74 0d                	je     80107921 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107914:	83 ec 0c             	sub    $0xc,%esp
80107917:	68 c8 a8 10 80       	push   $0x8010a8c8
8010791c:	e8 88 8c ff ff       	call   801005a9 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107921:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107928:	e9 8f 00 00 00       	jmp    801079bc <loaduvm+0xba>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010792d:	8b 55 0c             	mov    0xc(%ebp),%edx
80107930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107933:	01 d0                	add    %edx,%eax
80107935:	83 ec 04             	sub    $0x4,%esp
80107938:	6a 00                	push   $0x0
8010793a:	50                   	push   %eax
8010793b:	ff 75 08             	push   0x8(%ebp)
8010793e:	e8 6c fb ff ff       	call   801074af <walkpgdir>
80107943:	83 c4 10             	add    $0x10,%esp
80107946:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107949:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010794d:	75 0d                	jne    8010795c <loaduvm+0x5a>
      panic("loaduvm: address should exist");
8010794f:	83 ec 0c             	sub    $0xc,%esp
80107952:	68 eb a8 10 80       	push   $0x8010a8eb
80107957:	e8 4d 8c ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
8010795c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010795f:	8b 00                	mov    (%eax),%eax
80107961:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107966:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107969:	8b 45 18             	mov    0x18(%ebp),%eax
8010796c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010796f:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107974:	77 0b                	ja     80107981 <loaduvm+0x7f>
      n = sz - i;
80107976:	8b 45 18             	mov    0x18(%ebp),%eax
80107979:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010797c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010797f:	eb 07                	jmp    80107988 <loaduvm+0x86>
    else
      n = PGSIZE;
80107981:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107988:	8b 55 14             	mov    0x14(%ebp),%edx
8010798b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010798e:	01 d0                	add    %edx,%eax
80107990:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107993:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107999:	ff 75 f0             	push   -0x10(%ebp)
8010799c:	50                   	push   %eax
8010799d:	52                   	push   %edx
8010799e:	ff 75 10             	push   0x10(%ebp)
801079a1:	e8 38 a5 ff ff       	call   80101ede <readi>
801079a6:	83 c4 10             	add    $0x10,%esp
801079a9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801079ac:	74 07                	je     801079b5 <loaduvm+0xb3>
      return -1;
801079ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079b3:	eb 18                	jmp    801079cd <loaduvm+0xcb>
  for(i = 0; i < sz; i += PGSIZE){
801079b5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801079bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079bf:	3b 45 18             	cmp    0x18(%ebp),%eax
801079c2:	0f 82 65 ff ff ff    	jb     8010792d <loaduvm+0x2b>
  }
  return 0;
801079c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801079cd:	c9                   	leave
801079ce:	c3                   	ret

801079cf <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801079cf:	55                   	push   %ebp
801079d0:	89 e5                	mov    %esp,%ebp
801079d2:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801079d5:	8b 45 10             	mov    0x10(%ebp),%eax
801079d8:	85 c0                	test   %eax,%eax
801079da:	79 0a                	jns    801079e6 <allocuvm+0x17>
    return 0;
801079dc:	b8 00 00 00 00       	mov    $0x0,%eax
801079e1:	e9 ec 00 00 00       	jmp    80107ad2 <allocuvm+0x103>
  if(newsz < oldsz)
801079e6:	8b 45 10             	mov    0x10(%ebp),%eax
801079e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801079ec:	73 08                	jae    801079f6 <allocuvm+0x27>
    return oldsz;
801079ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801079f1:	e9 dc 00 00 00       	jmp    80107ad2 <allocuvm+0x103>

  a = PGROUNDUP(oldsz);
801079f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801079f9:	05 ff 0f 00 00       	add    $0xfff,%eax
801079fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107a06:	e9 b8 00 00 00       	jmp    80107ac3 <allocuvm+0xf4>
    mem = kalloc();
80107a0b:	e8 98 ad ff ff       	call   801027a8 <kalloc>
80107a10:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107a13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a17:	75 2e                	jne    80107a47 <allocuvm+0x78>
      cprintf("allocuvm out of memory\n");
80107a19:	83 ec 0c             	sub    $0xc,%esp
80107a1c:	68 09 a9 10 80       	push   $0x8010a909
80107a21:	e8 ce 89 ff ff       	call   801003f4 <cprintf>
80107a26:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107a29:	83 ec 04             	sub    $0x4,%esp
80107a2c:	ff 75 0c             	push   0xc(%ebp)
80107a2f:	ff 75 10             	push   0x10(%ebp)
80107a32:	ff 75 08             	push   0x8(%ebp)
80107a35:	e8 9a 00 00 00       	call   80107ad4 <deallocuvm>
80107a3a:	83 c4 10             	add    $0x10,%esp
      return 0;
80107a3d:	b8 00 00 00 00       	mov    $0x0,%eax
80107a42:	e9 8b 00 00 00       	jmp    80107ad2 <allocuvm+0x103>
    }
    memset(mem, 0, PGSIZE);
80107a47:	83 ec 04             	sub    $0x4,%esp
80107a4a:	68 00 10 00 00       	push   $0x1000
80107a4f:	6a 00                	push   $0x0
80107a51:	ff 75 f0             	push   -0x10(%ebp)
80107a54:	e8 8a d1 ff ff       	call   80104be3 <memset>
80107a59:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a5f:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a68:	83 ec 0c             	sub    $0xc,%esp
80107a6b:	6a 06                	push   $0x6
80107a6d:	52                   	push   %edx
80107a6e:	68 00 10 00 00       	push   $0x1000
80107a73:	50                   	push   %eax
80107a74:	ff 75 08             	push   0x8(%ebp)
80107a77:	e8 c9 fa ff ff       	call   80107545 <mappages>
80107a7c:	83 c4 20             	add    $0x20,%esp
80107a7f:	85 c0                	test   %eax,%eax
80107a81:	79 39                	jns    80107abc <allocuvm+0xed>
      cprintf("allocuvm out of memory (2)\n");
80107a83:	83 ec 0c             	sub    $0xc,%esp
80107a86:	68 21 a9 10 80       	push   $0x8010a921
80107a8b:	e8 64 89 ff ff       	call   801003f4 <cprintf>
80107a90:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107a93:	83 ec 04             	sub    $0x4,%esp
80107a96:	ff 75 0c             	push   0xc(%ebp)
80107a99:	ff 75 10             	push   0x10(%ebp)
80107a9c:	ff 75 08             	push   0x8(%ebp)
80107a9f:	e8 30 00 00 00       	call   80107ad4 <deallocuvm>
80107aa4:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80107aa7:	83 ec 0c             	sub    $0xc,%esp
80107aaa:	ff 75 f0             	push   -0x10(%ebp)
80107aad:	e8 5c ac ff ff       	call   8010270e <kfree>
80107ab2:	83 c4 10             	add    $0x10,%esp
      return 0;
80107ab5:	b8 00 00 00 00       	mov    $0x0,%eax
80107aba:	eb 16                	jmp    80107ad2 <allocuvm+0x103>
  for(; a < newsz; a += PGSIZE){
80107abc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac6:	3b 45 10             	cmp    0x10(%ebp),%eax
80107ac9:	0f 82 3c ff ff ff    	jb     80107a0b <allocuvm+0x3c>
    }
  }
  return newsz;
80107acf:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107ad2:	c9                   	leave
80107ad3:	c3                   	ret

80107ad4 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107ad4:	55                   	push   %ebp
80107ad5:	89 e5                	mov    %esp,%ebp
80107ad7:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107ada:	8b 45 10             	mov    0x10(%ebp),%eax
80107add:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107ae0:	72 08                	jb     80107aea <deallocuvm+0x16>
    return oldsz;
80107ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ae5:	e9 ac 00 00 00       	jmp    80107b96 <deallocuvm+0xc2>

  a = PGROUNDUP(newsz);
80107aea:	8b 45 10             	mov    0x10(%ebp),%eax
80107aed:	05 ff 0f 00 00       	add    $0xfff,%eax
80107af2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107af7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107afa:	e9 88 00 00 00       	jmp    80107b87 <deallocuvm+0xb3>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b02:	83 ec 04             	sub    $0x4,%esp
80107b05:	6a 00                	push   $0x0
80107b07:	50                   	push   %eax
80107b08:	ff 75 08             	push   0x8(%ebp)
80107b0b:	e8 9f f9 ff ff       	call   801074af <walkpgdir>
80107b10:	83 c4 10             	add    $0x10,%esp
80107b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107b16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107b1a:	75 16                	jne    80107b32 <deallocuvm+0x5e>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1f:	c1 e8 16             	shr    $0x16,%eax
80107b22:	83 c0 01             	add    $0x1,%eax
80107b25:	c1 e0 16             	shl    $0x16,%eax
80107b28:	2d 00 10 00 00       	sub    $0x1000,%eax
80107b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b30:	eb 4e                	jmp    80107b80 <deallocuvm+0xac>
    else if((*pte & PTE_P) != 0){
80107b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b35:	8b 00                	mov    (%eax),%eax
80107b37:	83 e0 01             	and    $0x1,%eax
80107b3a:	85 c0                	test   %eax,%eax
80107b3c:	74 42                	je     80107b80 <deallocuvm+0xac>
      pa = PTE_ADDR(*pte);
80107b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b41:	8b 00                	mov    (%eax),%eax
80107b43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b48:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107b4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107b4f:	75 0d                	jne    80107b5e <deallocuvm+0x8a>
        panic("kfree");
80107b51:	83 ec 0c             	sub    $0xc,%esp
80107b54:	68 3d a9 10 80       	push   $0x8010a93d
80107b59:	e8 4b 8a ff ff       	call   801005a9 <panic>
      char *v = P2V(pa);
80107b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b61:	05 00 00 00 80       	add    $0x80000000,%eax
80107b66:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107b69:	83 ec 0c             	sub    $0xc,%esp
80107b6c:	ff 75 e8             	push   -0x18(%ebp)
80107b6f:	e8 9a ab ff ff       	call   8010270e <kfree>
80107b74:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107b80:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b8a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107b8d:	0f 82 6c ff ff ff    	jb     80107aff <deallocuvm+0x2b>
    }
  }
  return newsz;
80107b93:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107b96:	c9                   	leave
80107b97:	c3                   	ret

80107b98 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107b98:	55                   	push   %ebp
80107b99:	89 e5                	mov    %esp,%ebp
80107b9b:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107b9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107ba2:	75 0d                	jne    80107bb1 <freevm+0x19>
    panic("freevm: no pgdir");
80107ba4:	83 ec 0c             	sub    $0xc,%esp
80107ba7:	68 43 a9 10 80       	push   $0x8010a943
80107bac:	e8 f8 89 ff ff       	call   801005a9 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107bb1:	83 ec 04             	sub    $0x4,%esp
80107bb4:	6a 00                	push   $0x0
80107bb6:	68 00 00 00 80       	push   $0x80000000
80107bbb:	ff 75 08             	push   0x8(%ebp)
80107bbe:	e8 11 ff ff ff       	call   80107ad4 <deallocuvm>
80107bc3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107bc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107bcd:	eb 48                	jmp    80107c17 <freevm+0x7f>
    if(pgdir[i] & PTE_P){
80107bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bd9:	8b 45 08             	mov    0x8(%ebp),%eax
80107bdc:	01 d0                	add    %edx,%eax
80107bde:	8b 00                	mov    (%eax),%eax
80107be0:	83 e0 01             	and    $0x1,%eax
80107be3:	85 c0                	test   %eax,%eax
80107be5:	74 2c                	je     80107c13 <freevm+0x7b>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bf1:	8b 45 08             	mov    0x8(%ebp),%eax
80107bf4:	01 d0                	add    %edx,%eax
80107bf6:	8b 00                	mov    (%eax),%eax
80107bf8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bfd:	05 00 00 00 80       	add    $0x80000000,%eax
80107c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107c05:	83 ec 0c             	sub    $0xc,%esp
80107c08:	ff 75 f0             	push   -0x10(%ebp)
80107c0b:	e8 fe aa ff ff       	call   8010270e <kfree>
80107c10:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107c13:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107c17:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107c1e:	76 af                	jbe    80107bcf <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107c20:	83 ec 0c             	sub    $0xc,%esp
80107c23:	ff 75 08             	push   0x8(%ebp)
80107c26:	e8 e3 aa ff ff       	call   8010270e <kfree>
80107c2b:	83 c4 10             	add    $0x10,%esp
}
80107c2e:	90                   	nop
80107c2f:	c9                   	leave
80107c30:	c3                   	ret

80107c31 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107c31:	55                   	push   %ebp
80107c32:	89 e5                	mov    %esp,%ebp
80107c34:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107c37:	83 ec 04             	sub    $0x4,%esp
80107c3a:	6a 00                	push   $0x0
80107c3c:	ff 75 0c             	push   0xc(%ebp)
80107c3f:	ff 75 08             	push   0x8(%ebp)
80107c42:	e8 68 f8 ff ff       	call   801074af <walkpgdir>
80107c47:	83 c4 10             	add    $0x10,%esp
80107c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107c4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c51:	75 0d                	jne    80107c60 <clearpteu+0x2f>
    panic("clearpteu");
80107c53:	83 ec 0c             	sub    $0xc,%esp
80107c56:	68 54 a9 10 80       	push   $0x8010a954
80107c5b:	e8 49 89 ff ff       	call   801005a9 <panic>
  *pte &= ~PTE_U;
80107c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c63:	8b 00                	mov    (%eax),%eax
80107c65:	83 e0 fb             	and    $0xfffffffb,%eax
80107c68:	89 c2                	mov    %eax,%edx
80107c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6d:	89 10                	mov    %edx,(%eax)
}
80107c6f:	90                   	nop
80107c70:	c9                   	leave
80107c71:	c3                   	ret

80107c72 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107c72:	55                   	push   %ebp
80107c73:	89 e5                	mov    %esp,%ebp
80107c75:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107c78:	e8 58 f9 ff ff       	call   801075d5 <setupkvm>
80107c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c84:	75 0a                	jne    80107c90 <copyuvm+0x1e>
    return 0;
80107c86:	b8 00 00 00 00       	mov    $0x0,%eax
80107c8b:	e9 eb 00 00 00       	jmp    80107d7b <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
80107c90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107c97:	e9 b7 00 00 00       	jmp    80107d53 <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9f:	83 ec 04             	sub    $0x4,%esp
80107ca2:	6a 00                	push   $0x0
80107ca4:	50                   	push   %eax
80107ca5:	ff 75 08             	push   0x8(%ebp)
80107ca8:	e8 02 f8 ff ff       	call   801074af <walkpgdir>
80107cad:	83 c4 10             	add    $0x10,%esp
80107cb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107cb3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107cb7:	75 0d                	jne    80107cc6 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
80107cb9:	83 ec 0c             	sub    $0xc,%esp
80107cbc:	68 5e a9 10 80       	push   $0x8010a95e
80107cc1:	e8 e3 88 ff ff       	call   801005a9 <panic>
    if(!(*pte & PTE_P))
80107cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cc9:	8b 00                	mov    (%eax),%eax
80107ccb:	83 e0 01             	and    $0x1,%eax
80107cce:	85 c0                	test   %eax,%eax
80107cd0:	75 0d                	jne    80107cdf <copyuvm+0x6d>
      panic("copyuvm: page not present");
80107cd2:	83 ec 0c             	sub    $0xc,%esp
80107cd5:	68 78 a9 10 80       	push   $0x8010a978
80107cda:	e8 ca 88 ff ff       	call   801005a9 <panic>
    pa = PTE_ADDR(*pte);
80107cdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ce2:	8b 00                	mov    (%eax),%eax
80107ce4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ce9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cef:	8b 00                	mov    (%eax),%eax
80107cf1:	25 ff 0f 00 00       	and    $0xfff,%eax
80107cf6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107cf9:	e8 aa aa ff ff       	call   801027a8 <kalloc>
80107cfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107d01:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107d05:	74 5d                	je     80107d64 <copyuvm+0xf2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107d07:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107d0a:	05 00 00 00 80       	add    $0x80000000,%eax
80107d0f:	83 ec 04             	sub    $0x4,%esp
80107d12:	68 00 10 00 00       	push   $0x1000
80107d17:	50                   	push   %eax
80107d18:	ff 75 e0             	push   -0x20(%ebp)
80107d1b:	e8 82 cf ff ff       	call   80104ca2 <memmove>
80107d20:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107d23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107d26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107d29:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d32:	83 ec 0c             	sub    $0xc,%esp
80107d35:	52                   	push   %edx
80107d36:	51                   	push   %ecx
80107d37:	68 00 10 00 00       	push   $0x1000
80107d3c:	50                   	push   %eax
80107d3d:	ff 75 f0             	push   -0x10(%ebp)
80107d40:	e8 00 f8 ff ff       	call   80107545 <mappages>
80107d45:	83 c4 20             	add    $0x20,%esp
80107d48:	85 c0                	test   %eax,%eax
80107d4a:	78 1b                	js     80107d67 <copyuvm+0xf5>
  for(i = 0; i < sz; i += PGSIZE){
80107d4c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d56:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107d59:	0f 82 3d ff ff ff    	jb     80107c9c <copyuvm+0x2a>
      goto bad;
  }
  return d;
80107d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d62:	eb 17                	jmp    80107d7b <copyuvm+0x109>
      goto bad;
80107d64:	90                   	nop
80107d65:	eb 01                	jmp    80107d68 <copyuvm+0xf6>
      goto bad;
80107d67:	90                   	nop

bad:
  freevm(d);
80107d68:	83 ec 0c             	sub    $0xc,%esp
80107d6b:	ff 75 f0             	push   -0x10(%ebp)
80107d6e:	e8 25 fe ff ff       	call   80107b98 <freevm>
80107d73:	83 c4 10             	add    $0x10,%esp
  return 0;
80107d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d7b:	c9                   	leave
80107d7c:	c3                   	ret

80107d7d <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107d7d:	55                   	push   %ebp
80107d7e:	89 e5                	mov    %esp,%ebp
80107d80:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107d83:	83 ec 04             	sub    $0x4,%esp
80107d86:	6a 00                	push   $0x0
80107d88:	ff 75 0c             	push   0xc(%ebp)
80107d8b:	ff 75 08             	push   0x8(%ebp)
80107d8e:	e8 1c f7 ff ff       	call   801074af <walkpgdir>
80107d93:	83 c4 10             	add    $0x10,%esp
80107d96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9c:	8b 00                	mov    (%eax),%eax
80107d9e:	83 e0 01             	and    $0x1,%eax
80107da1:	85 c0                	test   %eax,%eax
80107da3:	75 07                	jne    80107dac <uva2ka+0x2f>
    return 0;
80107da5:	b8 00 00 00 00       	mov    $0x0,%eax
80107daa:	eb 22                	jmp    80107dce <uva2ka+0x51>
  if((*pte & PTE_U) == 0)
80107dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107daf:	8b 00                	mov    (%eax),%eax
80107db1:	83 e0 04             	and    $0x4,%eax
80107db4:	85 c0                	test   %eax,%eax
80107db6:	75 07                	jne    80107dbf <uva2ka+0x42>
    return 0;
80107db8:	b8 00 00 00 00       	mov    $0x0,%eax
80107dbd:	eb 0f                	jmp    80107dce <uva2ka+0x51>
  return (char*)P2V(PTE_ADDR(*pte));
80107dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc2:	8b 00                	mov    (%eax),%eax
80107dc4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107dc9:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107dce:	c9                   	leave
80107dcf:	c3                   	ret

80107dd0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107dd0:	55                   	push   %ebp
80107dd1:	89 e5                	mov    %esp,%ebp
80107dd3:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107dd6:	8b 45 10             	mov    0x10(%ebp),%eax
80107dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80107ddc:	eb 7f                	jmp    80107e5d <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80107dde:	8b 45 0c             	mov    0xc(%ebp),%eax
80107de1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107de6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107dec:	83 ec 08             	sub    $0x8,%esp
80107def:	50                   	push   %eax
80107df0:	ff 75 08             	push   0x8(%ebp)
80107df3:	e8 85 ff ff ff       	call   80107d7d <uva2ka>
80107df8:	83 c4 10             	add    $0x10,%esp
80107dfb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80107dfe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107e02:	75 07                	jne    80107e0b <copyout+0x3b>
      return -1;
80107e04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e09:	eb 61                	jmp    80107e6c <copyout+0x9c>
    n = PGSIZE - (va - va0);
80107e0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e0e:	2b 45 0c             	sub    0xc(%ebp),%eax
80107e11:	05 00 10 00 00       	add    $0x1000,%eax
80107e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80107e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e1c:	39 45 14             	cmp    %eax,0x14(%ebp)
80107e1f:	73 06                	jae    80107e27 <copyout+0x57>
      n = len;
80107e21:	8b 45 14             	mov    0x14(%ebp),%eax
80107e24:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80107e27:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e2a:	2b 45 ec             	sub    -0x14(%ebp),%eax
80107e2d:	89 c2                	mov    %eax,%edx
80107e2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e32:	01 d0                	add    %edx,%eax
80107e34:	83 ec 04             	sub    $0x4,%esp
80107e37:	ff 75 f0             	push   -0x10(%ebp)
80107e3a:	ff 75 f4             	push   -0xc(%ebp)
80107e3d:	50                   	push   %eax
80107e3e:	e8 5f ce ff ff       	call   80104ca2 <memmove>
80107e43:	83 c4 10             	add    $0x10,%esp
    len -= n;
80107e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e49:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80107e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e4f:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80107e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e55:	05 00 10 00 00       	add    $0x1000,%eax
80107e5a:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80107e5d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107e61:	0f 85 77 ff ff ff    	jne    80107dde <copyout+0xe>
  }
  return 0;
80107e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e6c:	c9                   	leave
80107e6d:	c3                   	ret

80107e6e <mpinit_uefi>:

struct cpu cpus[NCPU];
int ncpu;
uchar ioapicid;
void mpinit_uefi(void)
{
80107e6e:	55                   	push   %ebp
80107e6f:	89 e5                	mov    %esp,%ebp
80107e71:	83 ec 20             	sub    $0x20,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
80107e74:	c7 45 f8 00 00 05 80 	movl   $0x80050000,-0x8(%ebp)
  struct uefi_madt *madt = (struct uefi_madt*)(P2V_WO(boot_param->madt_addr));
80107e7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80107e7e:	8b 40 08             	mov    0x8(%eax),%eax
80107e81:	05 00 00 00 80       	add    $0x80000000,%eax
80107e86:	89 45 f4             	mov    %eax,-0xc(%ebp)

  uint i=sizeof(struct uefi_madt);
80107e89:	c7 45 fc 2c 00 00 00 	movl   $0x2c,-0x4(%ebp)
  struct uefi_lapic *lapic_entry;
  struct uefi_ioapic *ioapic;
  struct uefi_iso *iso;
  struct uefi_non_maskable_intr *non_mask_intr; 
  
  lapic = (uint *)(madt->lapic_addr);
80107e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e93:	8b 40 24             	mov    0x24(%eax),%eax
80107e96:	a3 00 41 19 80       	mov    %eax,0x80194100
  ncpu = 0;
80107e9b:	c7 05 40 6e 19 80 00 	movl   $0x0,0x80196e40
80107ea2:	00 00 00 

  while(i<madt->len){
80107ea5:	e9 bd 00 00 00       	jmp    80107f67 <mpinit_uefi+0xf9>
    uchar *entry_type = ((uchar *)madt)+i;
80107eaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107eb0:	01 d0                	add    %edx,%eax
80107eb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch(*entry_type){
80107eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107eb8:	0f b6 00             	movzbl (%eax),%eax
80107ebb:	0f b6 c0             	movzbl %al,%eax
80107ebe:	83 f8 05             	cmp    $0x5,%eax
80107ec1:	0f 87 a0 00 00 00    	ja     80107f67 <mpinit_uefi+0xf9>
80107ec7:	8b 04 85 94 a9 10 80 	mov    -0x7fef566c(,%eax,4),%eax
80107ece:	ff e0                	jmp    *%eax
      case 0:
        lapic_entry = (struct uefi_lapic *)entry_type;
80107ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ed3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if(ncpu < NCPU) {
80107ed6:	a1 40 6e 19 80       	mov    0x80196e40,%eax
80107edb:	83 f8 03             	cmp    $0x3,%eax
80107ede:	7f 28                	jg     80107f08 <mpinit_uefi+0x9a>
          cpus[ncpu].apicid = lapic_entry->lapic_id;
80107ee0:	8b 15 40 6e 19 80    	mov    0x80196e40,%edx
80107ee6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ee9:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80107eed:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80107ef3:	81 c2 80 6b 19 80    	add    $0x80196b80,%edx
80107ef9:	88 02                	mov    %al,(%edx)
          ncpu++;
80107efb:	a1 40 6e 19 80       	mov    0x80196e40,%eax
80107f00:	83 c0 01             	add    $0x1,%eax
80107f03:	a3 40 6e 19 80       	mov    %eax,0x80196e40
        }
        i += lapic_entry->record_len;
80107f08:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f0b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107f0f:	0f b6 c0             	movzbl %al,%eax
80107f12:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107f15:	eb 50                	jmp    80107f67 <mpinit_uefi+0xf9>

      case 1:
        ioapic = (struct uefi_ioapic *)entry_type;
80107f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ioapicid = ioapic->ioapic_id;
80107f1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f20:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80107f24:	a2 44 6e 19 80       	mov    %al,0x80196e44
        i += ioapic->record_len;
80107f29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f2c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107f30:	0f b6 c0             	movzbl %al,%eax
80107f33:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107f36:	eb 2f                	jmp    80107f67 <mpinit_uefi+0xf9>

      case 2:
        iso = (struct uefi_iso *)entry_type;
80107f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f3b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        i += iso->record_len;
80107f3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f41:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107f45:	0f b6 c0             	movzbl %al,%eax
80107f48:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107f4b:	eb 1a                	jmp    80107f67 <mpinit_uefi+0xf9>

      case 4:
        non_mask_intr = (struct uefi_non_maskable_intr *)entry_type;
80107f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f50:	89 45 ec             	mov    %eax,-0x14(%ebp)
        i += non_mask_intr->record_len;
80107f53:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f56:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80107f5a:	0f b6 c0             	movzbl %al,%eax
80107f5d:	01 45 fc             	add    %eax,-0x4(%ebp)
        break;
80107f60:	eb 05                	jmp    80107f67 <mpinit_uefi+0xf9>

      case 5:
        i = i + 0xC;
80107f62:	83 45 fc 0c          	addl   $0xc,-0x4(%ebp)
        break;
80107f66:	90                   	nop
  while(i<madt->len){
80107f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6a:	8b 40 04             	mov    0x4(%eax),%eax
80107f6d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
80107f70:	0f 82 34 ff ff ff    	jb     80107eaa <mpinit_uefi+0x3c>
    }
  }

}
80107f76:	90                   	nop
80107f77:	90                   	nop
80107f78:	c9                   	leave
80107f79:	c3                   	ret

80107f7a <inb>:
{
80107f7a:	55                   	push   %ebp
80107f7b:	89 e5                	mov    %esp,%ebp
80107f7d:	83 ec 14             	sub    $0x14,%esp
80107f80:	8b 45 08             	mov    0x8(%ebp),%eax
80107f83:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107f87:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107f8b:	89 c2                	mov    %eax,%edx
80107f8d:	ec                   	in     (%dx),%al
80107f8e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107f91:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107f95:	c9                   	leave
80107f96:	c3                   	ret

80107f97 <outb>:
{
80107f97:	55                   	push   %ebp
80107f98:	89 e5                	mov    %esp,%ebp
80107f9a:	83 ec 08             	sub    $0x8,%esp
80107f9d:	8b 55 08             	mov    0x8(%ebp),%edx
80107fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fa3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107fa7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107faa:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107fae:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107fb2:	ee                   	out    %al,(%dx)
}
80107fb3:	90                   	nop
80107fb4:	c9                   	leave
80107fb5:	c3                   	ret

80107fb6 <uart_debug>:
#include "proc.h"
#include "x86.h"

#define COM1    0x3f8

void uart_debug(char p){
80107fb6:	55                   	push   %ebp
80107fb7:	89 e5                	mov    %esp,%ebp
80107fb9:	83 ec 28             	sub    $0x28,%esp
80107fbc:	8b 45 08             	mov    0x8(%ebp),%eax
80107fbf:	88 45 e4             	mov    %al,-0x1c(%ebp)
    // Turn off the FIFO
  outb(COM1+2, 0);
80107fc2:	6a 00                	push   $0x0
80107fc4:	68 fa 03 00 00       	push   $0x3fa
80107fc9:	e8 c9 ff ff ff       	call   80107f97 <outb>
80107fce:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107fd1:	68 80 00 00 00       	push   $0x80
80107fd6:	68 fb 03 00 00       	push   $0x3fb
80107fdb:	e8 b7 ff ff ff       	call   80107f97 <outb>
80107fe0:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107fe3:	6a 0c                	push   $0xc
80107fe5:	68 f8 03 00 00       	push   $0x3f8
80107fea:	e8 a8 ff ff ff       	call   80107f97 <outb>
80107fef:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107ff2:	6a 00                	push   $0x0
80107ff4:	68 f9 03 00 00       	push   $0x3f9
80107ff9:	e8 99 ff ff ff       	call   80107f97 <outb>
80107ffe:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80108001:	6a 03                	push   $0x3
80108003:	68 fb 03 00 00       	push   $0x3fb
80108008:	e8 8a ff ff ff       	call   80107f97 <outb>
8010800d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80108010:	6a 00                	push   $0x0
80108012:	68 fc 03 00 00       	push   $0x3fc
80108017:	e8 7b ff ff ff       	call   80107f97 <outb>
8010801c:	83 c4 08             	add    $0x8,%esp

  for(int i=0;i<128 && !(inb(COM1+5) & 0x20); i++) microdelay(10);
8010801f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108026:	eb 11                	jmp    80108039 <uart_debug+0x83>
80108028:	83 ec 0c             	sub    $0xc,%esp
8010802b:	6a 0a                	push   $0xa
8010802d:	e8 07 ab ff ff       	call   80102b39 <microdelay>
80108032:	83 c4 10             	add    $0x10,%esp
80108035:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108039:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010803d:	7f 1a                	jg     80108059 <uart_debug+0xa3>
8010803f:	83 ec 0c             	sub    $0xc,%esp
80108042:	68 fd 03 00 00       	push   $0x3fd
80108047:	e8 2e ff ff ff       	call   80107f7a <inb>
8010804c:	83 c4 10             	add    $0x10,%esp
8010804f:	0f b6 c0             	movzbl %al,%eax
80108052:	83 e0 20             	and    $0x20,%eax
80108055:	85 c0                	test   %eax,%eax
80108057:	74 cf                	je     80108028 <uart_debug+0x72>
  outb(COM1+0, p);
80108059:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
8010805d:	0f b6 c0             	movzbl %al,%eax
80108060:	83 ec 08             	sub    $0x8,%esp
80108063:	50                   	push   %eax
80108064:	68 f8 03 00 00       	push   $0x3f8
80108069:	e8 29 ff ff ff       	call   80107f97 <outb>
8010806e:	83 c4 10             	add    $0x10,%esp
}
80108071:	90                   	nop
80108072:	c9                   	leave
80108073:	c3                   	ret

80108074 <uart_debugs>:

void uart_debugs(char *p){
80108074:	55                   	push   %ebp
80108075:	89 e5                	mov    %esp,%ebp
80108077:	83 ec 08             	sub    $0x8,%esp
  while(*p){
8010807a:	eb 1b                	jmp    80108097 <uart_debugs+0x23>
    uart_debug(*p++);
8010807c:	8b 45 08             	mov    0x8(%ebp),%eax
8010807f:	8d 50 01             	lea    0x1(%eax),%edx
80108082:	89 55 08             	mov    %edx,0x8(%ebp)
80108085:	0f b6 00             	movzbl (%eax),%eax
80108088:	0f be c0             	movsbl %al,%eax
8010808b:	83 ec 0c             	sub    $0xc,%esp
8010808e:	50                   	push   %eax
8010808f:	e8 22 ff ff ff       	call   80107fb6 <uart_debug>
80108094:	83 c4 10             	add    $0x10,%esp
  while(*p){
80108097:	8b 45 08             	mov    0x8(%ebp),%eax
8010809a:	0f b6 00             	movzbl (%eax),%eax
8010809d:	84 c0                	test   %al,%al
8010809f:	75 db                	jne    8010807c <uart_debugs+0x8>
  }
}
801080a1:	90                   	nop
801080a2:	90                   	nop
801080a3:	c9                   	leave
801080a4:	c3                   	ret

801080a5 <graphic_init>:
 * i%4 = 2 : red
 * i%4 = 3 : black
 */

struct gpu gpu;
void graphic_init(){
801080a5:	55                   	push   %ebp
801080a6:	89 e5                	mov    %esp,%ebp
801080a8:	83 ec 10             	sub    $0x10,%esp
  struct boot_param *boot_param = (struct boot_param *)P2V_WO(BOOTPARAM);
801080ab:	c7 45 fc 00 00 05 80 	movl   $0x80050000,-0x4(%ebp)
  gpu.pvram_addr = boot_param->graphic_config.frame_base;
801080b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080b5:	8b 50 14             	mov    0x14(%eax),%edx
801080b8:	8b 40 10             	mov    0x10(%eax),%eax
801080bb:	a3 48 6e 19 80       	mov    %eax,0x80196e48
  gpu.vram_size = boot_param->graphic_config.frame_size;
801080c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080c3:	8b 50 1c             	mov    0x1c(%eax),%edx
801080c6:	8b 40 18             	mov    0x18(%eax),%eax
801080c9:	a3 50 6e 19 80       	mov    %eax,0x80196e50
  gpu.vvram_addr = DEVSPACE - gpu.vram_size;
801080ce:	a1 50 6e 19 80       	mov    0x80196e50,%eax
801080d3:	ba 00 00 00 fe       	mov    $0xfe000000,%edx
801080d8:	29 c2                	sub    %eax,%edx
801080da:	89 15 4c 6e 19 80    	mov    %edx,0x80196e4c
  gpu.horizontal_resolution = (uint)(boot_param->graphic_config.horizontal_resolution & 0xFFFFFFFF);
801080e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080e3:	8b 50 24             	mov    0x24(%eax),%edx
801080e6:	8b 40 20             	mov    0x20(%eax),%eax
801080e9:	a3 54 6e 19 80       	mov    %eax,0x80196e54
  gpu.vertical_resolution = (uint)(boot_param->graphic_config.vertical_resolution & 0xFFFFFFFF);
801080ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080f1:	8b 50 2c             	mov    0x2c(%eax),%edx
801080f4:	8b 40 28             	mov    0x28(%eax),%eax
801080f7:	a3 58 6e 19 80       	mov    %eax,0x80196e58
  gpu.pixels_per_line = (uint)(boot_param->graphic_config.pixels_per_line & 0xFFFFFFFF);
801080fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080ff:	8b 50 34             	mov    0x34(%eax),%edx
80108102:	8b 40 30             	mov    0x30(%eax),%eax
80108105:	a3 5c 6e 19 80       	mov    %eax,0x80196e5c
}
8010810a:	90                   	nop
8010810b:	c9                   	leave
8010810c:	c3                   	ret

8010810d <graphic_draw_pixel>:

void graphic_draw_pixel(int x,int y,struct graphic_pixel * buffer){
8010810d:	55                   	push   %ebp
8010810e:	89 e5                	mov    %esp,%ebp
80108110:	83 ec 10             	sub    $0x10,%esp
  int pixel_addr = (sizeof(struct graphic_pixel))*(y*gpu.pixels_per_line + x);
80108113:	8b 15 5c 6e 19 80    	mov    0x80196e5c,%edx
80108119:	8b 45 0c             	mov    0xc(%ebp),%eax
8010811c:	0f af d0             	imul   %eax,%edx
8010811f:	8b 45 08             	mov    0x8(%ebp),%eax
80108122:	01 d0                	add    %edx,%eax
80108124:	c1 e0 02             	shl    $0x2,%eax
80108127:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct graphic_pixel *pixel = (struct graphic_pixel *)(gpu.vvram_addr + pixel_addr);
8010812a:	8b 15 4c 6e 19 80    	mov    0x80196e4c,%edx
80108130:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108133:	01 d0                	add    %edx,%eax
80108135:	89 45 f8             	mov    %eax,-0x8(%ebp)
  pixel->blue = buffer->blue;
80108138:	8b 45 10             	mov    0x10(%ebp),%eax
8010813b:	0f b6 10             	movzbl (%eax),%edx
8010813e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80108141:	88 10                	mov    %dl,(%eax)
  pixel->green = buffer->green;
80108143:	8b 45 10             	mov    0x10(%ebp),%eax
80108146:	0f b6 50 01          	movzbl 0x1(%eax),%edx
8010814a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010814d:	88 50 01             	mov    %dl,0x1(%eax)
  pixel->red = buffer->red;
80108150:	8b 45 10             	mov    0x10(%ebp),%eax
80108153:	0f b6 50 02          	movzbl 0x2(%eax),%edx
80108157:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010815a:	88 50 02             	mov    %dl,0x2(%eax)
}
8010815d:	90                   	nop
8010815e:	c9                   	leave
8010815f:	c3                   	ret

80108160 <graphic_scroll_up>:

void graphic_scroll_up(int height){
80108160:	55                   	push   %ebp
80108161:	89 e5                	mov    %esp,%ebp
80108163:	83 ec 18             	sub    $0x18,%esp
  int addr_diff = (sizeof(struct graphic_pixel))*gpu.pixels_per_line*height;
80108166:	8b 15 5c 6e 19 80    	mov    0x80196e5c,%edx
8010816c:	8b 45 08             	mov    0x8(%ebp),%eax
8010816f:	0f af c2             	imul   %edx,%eax
80108172:	c1 e0 02             	shl    $0x2,%eax
80108175:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove((unsigned int *)gpu.vvram_addr,(unsigned int *)(gpu.vvram_addr + addr_diff),gpu.vram_size - addr_diff);
80108178:	8b 15 50 6e 19 80    	mov    0x80196e50,%edx
8010817e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108181:	29 c2                	sub    %eax,%edx
80108183:	8b 0d 4c 6e 19 80    	mov    0x80196e4c,%ecx
80108189:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818c:	01 c8                	add    %ecx,%eax
8010818e:	89 c1                	mov    %eax,%ecx
80108190:	a1 4c 6e 19 80       	mov    0x80196e4c,%eax
80108195:	83 ec 04             	sub    $0x4,%esp
80108198:	52                   	push   %edx
80108199:	51                   	push   %ecx
8010819a:	50                   	push   %eax
8010819b:	e8 02 cb ff ff       	call   80104ca2 <memmove>
801081a0:	83 c4 10             	add    $0x10,%esp
  memset((unsigned int *)(gpu.vvram_addr + gpu.vram_size - addr_diff),0,addr_diff);
801081a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a6:	8b 0d 4c 6e 19 80    	mov    0x80196e4c,%ecx
801081ac:	8b 15 50 6e 19 80    	mov    0x80196e50,%edx
801081b2:	01 d1                	add    %edx,%ecx
801081b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801081b7:	29 d1                	sub    %edx,%ecx
801081b9:	89 ca                	mov    %ecx,%edx
801081bb:	83 ec 04             	sub    $0x4,%esp
801081be:	50                   	push   %eax
801081bf:	6a 00                	push   $0x0
801081c1:	52                   	push   %edx
801081c2:	e8 1c ca ff ff       	call   80104be3 <memset>
801081c7:	83 c4 10             	add    $0x10,%esp
}
801081ca:	90                   	nop
801081cb:	c9                   	leave
801081cc:	c3                   	ret

801081cd <font_render>:
#include "font.h"


struct graphic_pixel black_pixel = {0x0,0x0,0x0,0x0};
struct graphic_pixel white_pixel = {0xFF,0xFF,0xFF,0x0};
void font_render(int x,int y,int index){
801081cd:	55                   	push   %ebp
801081ce:	89 e5                	mov    %esp,%ebp
801081d0:	53                   	push   %ebx
801081d1:	83 ec 14             	sub    $0x14,%esp
  int bin;
  for(int i=0;i<30;i++){
801081d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801081db:	e9 b1 00 00 00       	jmp    80108291 <font_render+0xc4>
    for(int j=14;j>-1;j--){
801081e0:	c7 45 f0 0e 00 00 00 	movl   $0xe,-0x10(%ebp)
801081e7:	e9 97 00 00 00       	jmp    80108283 <font_render+0xb6>
      bin = (font_bin[index-0x20][i])&(1 << j);
801081ec:	8b 45 10             	mov    0x10(%ebp),%eax
801081ef:	83 e8 20             	sub    $0x20,%eax
801081f2:	6b d0 1e             	imul   $0x1e,%eax,%edx
801081f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f8:	01 d0                	add    %edx,%eax
801081fa:	0f b7 84 00 c0 a9 10 	movzwl -0x7fef5640(%eax,%eax,1),%eax
80108201:	80 
80108202:	0f b7 d0             	movzwl %ax,%edx
80108205:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108208:	bb 01 00 00 00       	mov    $0x1,%ebx
8010820d:	89 c1                	mov    %eax,%ecx
8010820f:	d3 e3                	shl    %cl,%ebx
80108211:	89 d8                	mov    %ebx,%eax
80108213:	21 d0                	and    %edx,%eax
80108215:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(bin == (1 << j)){
80108218:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010821b:	ba 01 00 00 00       	mov    $0x1,%edx
80108220:	89 c1                	mov    %eax,%ecx
80108222:	d3 e2                	shl    %cl,%edx
80108224:	89 d0                	mov    %edx,%eax
80108226:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80108229:	75 2b                	jne    80108256 <font_render+0x89>
        graphic_draw_pixel(x+(14-j),y+i,&white_pixel);
8010822b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010822e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108231:	01 c2                	add    %eax,%edx
80108233:	b8 0e 00 00 00       	mov    $0xe,%eax
80108238:	2b 45 f0             	sub    -0x10(%ebp),%eax
8010823b:	89 c1                	mov    %eax,%ecx
8010823d:	8b 45 08             	mov    0x8(%ebp),%eax
80108240:	01 c8                	add    %ecx,%eax
80108242:	83 ec 04             	sub    $0x4,%esp
80108245:	68 00 f5 10 80       	push   $0x8010f500
8010824a:	52                   	push   %edx
8010824b:	50                   	push   %eax
8010824c:	e8 bc fe ff ff       	call   8010810d <graphic_draw_pixel>
80108251:	83 c4 10             	add    $0x10,%esp
80108254:	eb 29                	jmp    8010827f <font_render+0xb2>
      } else {
        graphic_draw_pixel(x+(14-j),y+i,&black_pixel);
80108256:	8b 55 0c             	mov    0xc(%ebp),%edx
80108259:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825c:	01 c2                	add    %eax,%edx
8010825e:	b8 0e 00 00 00       	mov    $0xe,%eax
80108263:	2b 45 f0             	sub    -0x10(%ebp),%eax
80108266:	89 c1                	mov    %eax,%ecx
80108268:	8b 45 08             	mov    0x8(%ebp),%eax
8010826b:	01 c8                	add    %ecx,%eax
8010826d:	83 ec 04             	sub    $0x4,%esp
80108270:	68 60 6e 19 80       	push   $0x80196e60
80108275:	52                   	push   %edx
80108276:	50                   	push   %eax
80108277:	e8 91 fe ff ff       	call   8010810d <graphic_draw_pixel>
8010827c:	83 c4 10             	add    $0x10,%esp
    for(int j=14;j>-1;j--){
8010827f:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
80108283:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108287:	0f 89 5f ff ff ff    	jns    801081ec <font_render+0x1f>
  for(int i=0;i<30;i++){
8010828d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108291:	83 7d f4 1d          	cmpl   $0x1d,-0xc(%ebp)
80108295:	0f 8e 45 ff ff ff    	jle    801081e0 <font_render+0x13>
      }
    }
  }
}
8010829b:	90                   	nop
8010829c:	90                   	nop
8010829d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801082a0:	c9                   	leave
801082a1:	c3                   	ret

801082a2 <font_render_string>:

void font_render_string(char *string,int row){
801082a2:	55                   	push   %ebp
801082a3:	89 e5                	mov    %esp,%ebp
801082a5:	53                   	push   %ebx
801082a6:	83 ec 14             	sub    $0x14,%esp
  int i = 0;
801082a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while(string[i] && i < 52){
801082b0:	eb 33                	jmp    801082e5 <font_render_string+0x43>
    font_render(i*15+2,row*30,string[i]);
801082b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082b5:	8b 45 08             	mov    0x8(%ebp),%eax
801082b8:	01 d0                	add    %edx,%eax
801082ba:	0f b6 00             	movzbl (%eax),%eax
801082bd:	0f be d8             	movsbl %al,%ebx
801082c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801082c3:	6b c8 1e             	imul   $0x1e,%eax,%ecx
801082c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082c9:	89 d0                	mov    %edx,%eax
801082cb:	c1 e0 04             	shl    $0x4,%eax
801082ce:	29 d0                	sub    %edx,%eax
801082d0:	83 c0 02             	add    $0x2,%eax
801082d3:	83 ec 04             	sub    $0x4,%esp
801082d6:	53                   	push   %ebx
801082d7:	51                   	push   %ecx
801082d8:	50                   	push   %eax
801082d9:	e8 ef fe ff ff       	call   801081cd <font_render>
801082de:	83 c4 10             	add    $0x10,%esp
    i++;
801082e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(string[i] && i < 52){
801082e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082e8:	8b 45 08             	mov    0x8(%ebp),%eax
801082eb:	01 d0                	add    %edx,%eax
801082ed:	0f b6 00             	movzbl (%eax),%eax
801082f0:	84 c0                	test   %al,%al
801082f2:	74 06                	je     801082fa <font_render_string+0x58>
801082f4:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
801082f8:	7e b8                	jle    801082b2 <font_render_string+0x10>
  }
}
801082fa:	90                   	nop
801082fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801082fe:	c9                   	leave
801082ff:	c3                   	ret

80108300 <pci_init>:
#include "pci.h"
#include "defs.h"
#include "types.h"
#include "i8254.h"

void pci_init(){
80108300:	55                   	push   %ebp
80108301:	89 e5                	mov    %esp,%ebp
80108303:	53                   	push   %ebx
80108304:	83 ec 14             	sub    $0x14,%esp
  uint data;
  for(int i=0;i<256;i++){
80108307:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010830e:	eb 6b                	jmp    8010837b <pci_init+0x7b>
    for(int j=0;j<32;j++){
80108310:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108317:	eb 58                	jmp    80108371 <pci_init+0x71>
      for(int k=0;k<8;k++){
80108319:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80108320:	eb 45                	jmp    80108367 <pci_init+0x67>
      pci_access_config(i,j,k,0,&data);
80108322:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80108325:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108328:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010832b:	83 ec 0c             	sub    $0xc,%esp
8010832e:	8d 5d e8             	lea    -0x18(%ebp),%ebx
80108331:	53                   	push   %ebx
80108332:	6a 00                	push   $0x0
80108334:	51                   	push   %ecx
80108335:	52                   	push   %edx
80108336:	50                   	push   %eax
80108337:	e8 b0 00 00 00       	call   801083ec <pci_access_config>
8010833c:	83 c4 20             	add    $0x20,%esp
      if((data&0xFFFF) != 0xFFFF){
8010833f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108342:	0f b7 c0             	movzwl %ax,%eax
80108345:	3d ff ff 00 00       	cmp    $0xffff,%eax
8010834a:	74 17                	je     80108363 <pci_init+0x63>
        pci_init_device(i,j,k);
8010834c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010834f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108355:	83 ec 04             	sub    $0x4,%esp
80108358:	51                   	push   %ecx
80108359:	52                   	push   %edx
8010835a:	50                   	push   %eax
8010835b:	e8 37 01 00 00       	call   80108497 <pci_init_device>
80108360:	83 c4 10             	add    $0x10,%esp
      for(int k=0;k<8;k++){
80108363:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80108367:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
8010836b:	7e b5                	jle    80108322 <pci_init+0x22>
    for(int j=0;j<32;j++){
8010836d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108371:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
80108375:	7e a2                	jle    80108319 <pci_init+0x19>
  for(int i=0;i<256;i++){
80108377:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010837b:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108382:	7e 8c                	jle    80108310 <pci_init+0x10>
      }
      }
    }
  }
}
80108384:	90                   	nop
80108385:	90                   	nop
80108386:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108389:	c9                   	leave
8010838a:	c3                   	ret

8010838b <pci_write_config>:

void pci_write_config(uint config){
8010838b:	55                   	push   %ebp
8010838c:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCF8,%%edx\n\t"
8010838e:	8b 45 08             	mov    0x8(%ebp),%eax
80108391:	ba f8 0c 00 00       	mov    $0xcf8,%edx
80108396:	89 c0                	mov    %eax,%eax
80108398:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
80108399:	90                   	nop
8010839a:	5d                   	pop    %ebp
8010839b:	c3                   	ret

8010839c <pci_write_data>:

void pci_write_data(uint config){
8010839c:	55                   	push   %ebp
8010839d:	89 e5                	mov    %esp,%ebp
  asm("mov $0xCFC,%%edx\n\t"
8010839f:	8b 45 08             	mov    0x8(%ebp),%eax
801083a2:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801083a7:	89 c0                	mov    %eax,%eax
801083a9:	ef                   	out    %eax,(%dx)
      "mov %0,%%eax\n\t"
      "out %%eax,%%dx\n\t"
      : :"r"(config));
}
801083aa:	90                   	nop
801083ab:	5d                   	pop    %ebp
801083ac:	c3                   	ret

801083ad <pci_read_config>:
uint pci_read_config(){
801083ad:	55                   	push   %ebp
801083ae:	89 e5                	mov    %esp,%ebp
801083b0:	83 ec 18             	sub    $0x18,%esp
  uint data;
  asm("mov $0xCFC,%%edx\n\t"
801083b3:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801083b8:	ed                   	in     (%dx),%eax
801083b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      "in %%dx,%%eax\n\t"
      "mov %%eax,%0"
      :"=m"(data):);
  microdelay(200);
801083bc:	83 ec 0c             	sub    $0xc,%esp
801083bf:	68 c8 00 00 00       	push   $0xc8
801083c4:	e8 70 a7 ff ff       	call   80102b39 <microdelay>
801083c9:	83 c4 10             	add    $0x10,%esp
  return data;
801083cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801083cf:	c9                   	leave
801083d0:	c3                   	ret

801083d1 <pci_test>:


void pci_test(){
801083d1:	55                   	push   %ebp
801083d2:	89 e5                	mov    %esp,%ebp
801083d4:	83 ec 10             	sub    $0x10,%esp
  uint data = 0x80001804;
801083d7:	c7 45 fc 04 18 00 80 	movl   $0x80001804,-0x4(%ebp)
  pci_write_config(data);
801083de:	ff 75 fc             	push   -0x4(%ebp)
801083e1:	e8 a5 ff ff ff       	call   8010838b <pci_write_config>
801083e6:	83 c4 04             	add    $0x4,%esp
}
801083e9:	90                   	nop
801083ea:	c9                   	leave
801083eb:	c3                   	ret

801083ec <pci_access_config>:

void pci_access_config(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint *data){
801083ec:	55                   	push   %ebp
801083ed:	89 e5                	mov    %esp,%ebp
801083ef:	83 ec 18             	sub    $0x18,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
801083f2:	8b 45 08             	mov    0x8(%ebp),%eax
801083f5:	c1 e0 10             	shl    $0x10,%eax
801083f8:	25 00 00 ff 00       	and    $0xff0000,%eax
801083fd:	89 c2                	mov    %eax,%edx
801083ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80108402:	c1 e0 0b             	shl    $0xb,%eax
80108405:	0f b7 c0             	movzwl %ax,%eax
80108408:	09 c2                	or     %eax,%edx
8010840a:	8b 45 10             	mov    0x10(%ebp),%eax
8010840d:	c1 e0 08             	shl    $0x8,%eax
80108410:	25 00 07 00 00       	and    $0x700,%eax
80108415:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
80108417:	8b 45 14             	mov    0x14(%ebp),%eax
8010841a:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
8010841f:	09 d0                	or     %edx,%eax
80108421:	0d 00 00 00 80       	or     $0x80000000,%eax
80108426:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pci_write_config(config_addr);
80108429:	ff 75 f4             	push   -0xc(%ebp)
8010842c:	e8 5a ff ff ff       	call   8010838b <pci_write_config>
80108431:	83 c4 04             	add    $0x4,%esp
  *data = pci_read_config();
80108434:	e8 74 ff ff ff       	call   801083ad <pci_read_config>
80108439:	8b 55 18             	mov    0x18(%ebp),%edx
8010843c:	89 02                	mov    %eax,(%edx)
}
8010843e:	90                   	nop
8010843f:	c9                   	leave
80108440:	c3                   	ret

80108441 <pci_write_config_register>:

void pci_write_config_register(uint bus_num,uint device_num,uint function_num,uint reg_addr,uint data){
80108441:	55                   	push   %ebp
80108442:	89 e5                	mov    %esp,%ebp
80108444:	83 ec 10             	sub    $0x10,%esp
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108447:	8b 45 08             	mov    0x8(%ebp),%eax
8010844a:	c1 e0 10             	shl    $0x10,%eax
8010844d:	25 00 00 ff 00       	and    $0xff0000,%eax
80108452:	89 c2                	mov    %eax,%edx
80108454:	8b 45 0c             	mov    0xc(%ebp),%eax
80108457:	c1 e0 0b             	shl    $0xb,%eax
8010845a:	0f b7 c0             	movzwl %ax,%eax
8010845d:	09 c2                	or     %eax,%edx
8010845f:	8b 45 10             	mov    0x10(%ebp),%eax
80108462:	c1 e0 08             	shl    $0x8,%eax
80108465:	25 00 07 00 00       	and    $0x700,%eax
8010846a:	09 c2                	or     %eax,%edx
    (reg_addr & 0xFC) | 0x80000000;
8010846c:	8b 45 14             	mov    0x14(%ebp),%eax
8010846f:	25 fc 00 00 00       	and    $0xfc,%eax
  uint config_addr = ((bus_num & 0xFF)<<16) | ((device_num & 0x1F)<<11) | ((function_num & 0x7)<<8) |
80108474:	09 d0                	or     %edx,%eax
80108476:	0d 00 00 00 80       	or     $0x80000000,%eax
8010847b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  pci_write_config(config_addr);
8010847e:	ff 75 fc             	push   -0x4(%ebp)
80108481:	e8 05 ff ff ff       	call   8010838b <pci_write_config>
80108486:	83 c4 04             	add    $0x4,%esp
  pci_write_data(data);
80108489:	ff 75 18             	push   0x18(%ebp)
8010848c:	e8 0b ff ff ff       	call   8010839c <pci_write_data>
80108491:	83 c4 04             	add    $0x4,%esp
}
80108494:	90                   	nop
80108495:	c9                   	leave
80108496:	c3                   	ret

80108497 <pci_init_device>:

struct pci_dev dev;
void pci_init_device(uint bus_num,uint device_num,uint function_num){
80108497:	55                   	push   %ebp
80108498:	89 e5                	mov    %esp,%ebp
8010849a:	53                   	push   %ebx
8010849b:	83 ec 14             	sub    $0x14,%esp
  uint data;
  dev.bus_num = bus_num;
8010849e:	8b 45 08             	mov    0x8(%ebp),%eax
801084a1:	a2 64 6e 19 80       	mov    %al,0x80196e64
  dev.device_num = device_num;
801084a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801084a9:	a2 65 6e 19 80       	mov    %al,0x80196e65
  dev.function_num = function_num;
801084ae:	8b 45 10             	mov    0x10(%ebp),%eax
801084b1:	a2 66 6e 19 80       	mov    %al,0x80196e66
  cprintf("PCI Device Found Bus:0x%x Device:0x%x Function:%x\n",bus_num,device_num,function_num);
801084b6:	ff 75 10             	push   0x10(%ebp)
801084b9:	ff 75 0c             	push   0xc(%ebp)
801084bc:	ff 75 08             	push   0x8(%ebp)
801084bf:	68 04 c0 10 80       	push   $0x8010c004
801084c4:	e8 2b 7f ff ff       	call   801003f4 <cprintf>
801084c9:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0,&data);
801084cc:	83 ec 0c             	sub    $0xc,%esp
801084cf:	8d 45 ec             	lea    -0x14(%ebp),%eax
801084d2:	50                   	push   %eax
801084d3:	6a 00                	push   $0x0
801084d5:	ff 75 10             	push   0x10(%ebp)
801084d8:	ff 75 0c             	push   0xc(%ebp)
801084db:	ff 75 08             	push   0x8(%ebp)
801084de:	e8 09 ff ff ff       	call   801083ec <pci_access_config>
801084e3:	83 c4 20             	add    $0x20,%esp
  uint device_id = data>>16;
801084e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084e9:	c1 e8 10             	shr    $0x10,%eax
801084ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint vendor_id = data&0xFFFF;
801084ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084f2:	25 ff ff 00 00       	and    $0xffff,%eax
801084f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dev.device_id = device_id;
801084fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084fd:	a3 68 6e 19 80       	mov    %eax,0x80196e68
  dev.vendor_id = vendor_id;
80108502:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108505:	a3 6c 6e 19 80       	mov    %eax,0x80196e6c
  cprintf("  Device ID:0x%x  Vendor ID:0x%x\n",device_id,vendor_id);
8010850a:	83 ec 04             	sub    $0x4,%esp
8010850d:	ff 75 f0             	push   -0x10(%ebp)
80108510:	ff 75 f4             	push   -0xc(%ebp)
80108513:	68 38 c0 10 80       	push   $0x8010c038
80108518:	e8 d7 7e ff ff       	call   801003f4 <cprintf>
8010851d:	83 c4 10             	add    $0x10,%esp
  
  pci_access_config(bus_num,device_num,function_num,0x8,&data);
80108520:	83 ec 0c             	sub    $0xc,%esp
80108523:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108526:	50                   	push   %eax
80108527:	6a 08                	push   $0x8
80108529:	ff 75 10             	push   0x10(%ebp)
8010852c:	ff 75 0c             	push   0xc(%ebp)
8010852f:	ff 75 08             	push   0x8(%ebp)
80108532:	e8 b5 fe ff ff       	call   801083ec <pci_access_config>
80108537:	83 c4 20             	add    $0x20,%esp
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
8010853a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010853d:	0f b6 c8             	movzbl %al,%ecx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108540:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108543:	c1 e8 08             	shr    $0x8,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
80108546:	0f b6 d0             	movzbl %al,%edx
      data>>24,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF);
80108549:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010854c:	c1 e8 10             	shr    $0x10,%eax
  cprintf("  Base Class:0x%x  Sub Class:0x%x  Interface:0x%x  Revision ID:0x%x\n",
8010854f:	0f b6 c0             	movzbl %al,%eax
80108552:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80108555:	c1 eb 18             	shr    $0x18,%ebx
80108558:	83 ec 0c             	sub    $0xc,%esp
8010855b:	51                   	push   %ecx
8010855c:	52                   	push   %edx
8010855d:	50                   	push   %eax
8010855e:	53                   	push   %ebx
8010855f:	68 5c c0 10 80       	push   $0x8010c05c
80108564:	e8 8b 7e ff ff       	call   801003f4 <cprintf>
80108569:	83 c4 20             	add    $0x20,%esp
  dev.base_class = data>>24;
8010856c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010856f:	c1 e8 18             	shr    $0x18,%eax
80108572:	a2 70 6e 19 80       	mov    %al,0x80196e70
  dev.sub_class = (data>>16)&0xFF;
80108577:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010857a:	c1 e8 10             	shr    $0x10,%eax
8010857d:	a2 71 6e 19 80       	mov    %al,0x80196e71
  dev.interface = (data>>8)&0xFF;
80108582:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108585:	c1 e8 08             	shr    $0x8,%eax
80108588:	a2 72 6e 19 80       	mov    %al,0x80196e72
  dev.revision_id = data&0xFF;
8010858d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108590:	a2 73 6e 19 80       	mov    %al,0x80196e73
  
  pci_access_config(bus_num,device_num,function_num,0x10,&data);
80108595:	83 ec 0c             	sub    $0xc,%esp
80108598:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010859b:	50                   	push   %eax
8010859c:	6a 10                	push   $0x10
8010859e:	ff 75 10             	push   0x10(%ebp)
801085a1:	ff 75 0c             	push   0xc(%ebp)
801085a4:	ff 75 08             	push   0x8(%ebp)
801085a7:	e8 40 fe ff ff       	call   801083ec <pci_access_config>
801085ac:	83 c4 20             	add    $0x20,%esp
  dev.bar0 = data;
801085af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085b2:	a3 74 6e 19 80       	mov    %eax,0x80196e74
  pci_access_config(bus_num,device_num,function_num,0x14,&data);
801085b7:	83 ec 0c             	sub    $0xc,%esp
801085ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
801085bd:	50                   	push   %eax
801085be:	6a 14                	push   $0x14
801085c0:	ff 75 10             	push   0x10(%ebp)
801085c3:	ff 75 0c             	push   0xc(%ebp)
801085c6:	ff 75 08             	push   0x8(%ebp)
801085c9:	e8 1e fe ff ff       	call   801083ec <pci_access_config>
801085ce:	83 c4 20             	add    $0x20,%esp
  dev.bar1 = data;
801085d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085d4:	a3 78 6e 19 80       	mov    %eax,0x80196e78
  if(device_id == I8254_DEVICE_ID && vendor_id == I8254_VENDOR_ID){
801085d9:	81 7d f4 0e 10 00 00 	cmpl   $0x100e,-0xc(%ebp)
801085e0:	75 5a                	jne    8010863c <pci_init_device+0x1a5>
801085e2:	81 7d f0 86 80 00 00 	cmpl   $0x8086,-0x10(%ebp)
801085e9:	75 51                	jne    8010863c <pci_init_device+0x1a5>
    cprintf("E1000 Ethernet NIC Found\n");
801085eb:	83 ec 0c             	sub    $0xc,%esp
801085ee:	68 a1 c0 10 80       	push   $0x8010c0a1
801085f3:	e8 fc 7d ff ff       	call   801003f4 <cprintf>
801085f8:	83 c4 10             	add    $0x10,%esp
    pci_access_config(bus_num,device_num,function_num,0xF0,&data);
801085fb:	83 ec 0c             	sub    $0xc,%esp
801085fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108601:	50                   	push   %eax
80108602:	68 f0 00 00 00       	push   $0xf0
80108607:	ff 75 10             	push   0x10(%ebp)
8010860a:	ff 75 0c             	push   0xc(%ebp)
8010860d:	ff 75 08             	push   0x8(%ebp)
80108610:	e8 d7 fd ff ff       	call   801083ec <pci_access_config>
80108615:	83 c4 20             	add    $0x20,%esp
    cprintf("Message Control:%x\n",data);
80108618:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010861b:	83 ec 08             	sub    $0x8,%esp
8010861e:	50                   	push   %eax
8010861f:	68 bb c0 10 80       	push   $0x8010c0bb
80108624:	e8 cb 7d ff ff       	call   801003f4 <cprintf>
80108629:	83 c4 10             	add    $0x10,%esp
    i8254_init(&dev);
8010862c:	83 ec 0c             	sub    $0xc,%esp
8010862f:	68 64 6e 19 80       	push   $0x80196e64
80108634:	e8 09 00 00 00       	call   80108642 <i8254_init>
80108639:	83 c4 10             	add    $0x10,%esp
  }
}
8010863c:	90                   	nop
8010863d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108640:	c9                   	leave
80108641:	c3                   	ret

80108642 <i8254_init>:

uint base_addr;
uchar mac_addr[6] = {0};
uchar my_ip[4] = {10,0,1,10}; 
uint *intr_addr;
void i8254_init(struct pci_dev *dev){
80108642:	55                   	push   %ebp
80108643:	89 e5                	mov    %esp,%ebp
80108645:	53                   	push   %ebx
80108646:	83 ec 14             	sub    $0x14,%esp
  uint cmd_reg;
  //Enable Bus Master
  pci_access_config(dev->bus_num,dev->device_num,dev->function_num,0x04,&cmd_reg);
80108649:	8b 45 08             	mov    0x8(%ebp),%eax
8010864c:	0f b6 40 02          	movzbl 0x2(%eax),%eax
80108650:	0f b6 c8             	movzbl %al,%ecx
80108653:	8b 45 08             	mov    0x8(%ebp),%eax
80108656:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010865a:	0f b6 d0             	movzbl %al,%edx
8010865d:	8b 45 08             	mov    0x8(%ebp),%eax
80108660:	0f b6 00             	movzbl (%eax),%eax
80108663:	0f b6 c0             	movzbl %al,%eax
80108666:	83 ec 0c             	sub    $0xc,%esp
80108669:	8d 5d ec             	lea    -0x14(%ebp),%ebx
8010866c:	53                   	push   %ebx
8010866d:	6a 04                	push   $0x4
8010866f:	51                   	push   %ecx
80108670:	52                   	push   %edx
80108671:	50                   	push   %eax
80108672:	e8 75 fd ff ff       	call   801083ec <pci_access_config>
80108677:	83 c4 20             	add    $0x20,%esp
  cmd_reg = cmd_reg | PCI_CMD_BUS_MASTER;
8010867a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010867d:	83 c8 04             	or     $0x4,%eax
80108680:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pci_write_config_register(dev->bus_num,dev->device_num,dev->function_num,0x04,cmd_reg);
80108683:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80108686:	8b 45 08             	mov    0x8(%ebp),%eax
80108689:	0f b6 40 02          	movzbl 0x2(%eax),%eax
8010868d:	0f b6 c8             	movzbl %al,%ecx
80108690:	8b 45 08             	mov    0x8(%ebp),%eax
80108693:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80108697:	0f b6 d0             	movzbl %al,%edx
8010869a:	8b 45 08             	mov    0x8(%ebp),%eax
8010869d:	0f b6 00             	movzbl (%eax),%eax
801086a0:	0f b6 c0             	movzbl %al,%eax
801086a3:	83 ec 0c             	sub    $0xc,%esp
801086a6:	53                   	push   %ebx
801086a7:	6a 04                	push   $0x4
801086a9:	51                   	push   %ecx
801086aa:	52                   	push   %edx
801086ab:	50                   	push   %eax
801086ac:	e8 90 fd ff ff       	call   80108441 <pci_write_config_register>
801086b1:	83 c4 20             	add    $0x20,%esp
  
  base_addr = PCI_P2V(dev->bar0);
801086b4:	8b 45 08             	mov    0x8(%ebp),%eax
801086b7:	8b 40 10             	mov    0x10(%eax),%eax
801086ba:	05 00 00 00 40       	add    $0x40000000,%eax
801086bf:	a3 7c 6e 19 80       	mov    %eax,0x80196e7c
  uint *ctrl = (uint *)base_addr;
801086c4:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801086c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  //Disable Interrupts
  uint *imc = (uint *)(base_addr+0xD8);
801086cc:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801086d1:	05 d8 00 00 00       	add    $0xd8,%eax
801086d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *imc = 0xFFFFFFFF;
801086d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086dc:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
  
  //Reset NIC
  *ctrl = *ctrl | I8254_CTRL_RST;
801086e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086e5:	8b 00                	mov    (%eax),%eax
801086e7:	0d 00 00 00 04       	or     $0x4000000,%eax
801086ec:	89 c2                	mov    %eax,%edx
801086ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086f1:	89 10                	mov    %edx,(%eax)

  //Enable Interrupts
  *imc = 0xFFFFFFFF;
801086f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086f6:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

  //Enable Link
  *ctrl |= I8254_CTRL_SLU;
801086fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086ff:	8b 00                	mov    (%eax),%eax
80108701:	83 c8 40             	or     $0x40,%eax
80108704:	89 c2                	mov    %eax,%edx
80108706:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108709:	89 10                	mov    %edx,(%eax)
  
  //General Configuration
  *ctrl &= (~I8254_CTRL_PHY_RST | ~I8254_CTRL_VME | ~I8254_CTRL_ILOS);
8010870b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010870e:	8b 10                	mov    (%eax),%edx
80108710:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108713:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 General Configuration Done\n");
80108715:	83 ec 0c             	sub    $0xc,%esp
80108718:	68 d0 c0 10 80       	push   $0x8010c0d0
8010871d:	e8 d2 7c ff ff       	call   801003f4 <cprintf>
80108722:	83 c4 10             	add    $0x10,%esp
  intr_addr = (uint *)kalloc();
80108725:	e8 7e a0 ff ff       	call   801027a8 <kalloc>
8010872a:	a3 88 6e 19 80       	mov    %eax,0x80196e88
  *intr_addr = 0;
8010872f:	a1 88 6e 19 80       	mov    0x80196e88,%eax
80108734:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cprintf("INTR_ADDR:%x\n",intr_addr);
8010873a:	a1 88 6e 19 80       	mov    0x80196e88,%eax
8010873f:	83 ec 08             	sub    $0x8,%esp
80108742:	50                   	push   %eax
80108743:	68 f2 c0 10 80       	push   $0x8010c0f2
80108748:	e8 a7 7c ff ff       	call   801003f4 <cprintf>
8010874d:	83 c4 10             	add    $0x10,%esp
  i8254_init_recv();
80108750:	e8 50 00 00 00       	call   801087a5 <i8254_init_recv>
  i8254_init_send();
80108755:	e8 69 03 00 00       	call   80108ac3 <i8254_init_send>
  cprintf("IP Address %d.%d.%d.%d\n",
      my_ip[0],
      my_ip[1],
      my_ip[2],
      my_ip[3]);
8010875a:	0f b6 05 07 f5 10 80 	movzbl 0x8010f507,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108761:	0f b6 d8             	movzbl %al,%ebx
      my_ip[2],
80108764:	0f b6 05 06 f5 10 80 	movzbl 0x8010f506,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010876b:	0f b6 c8             	movzbl %al,%ecx
      my_ip[1],
8010876e:	0f b6 05 05 f5 10 80 	movzbl 0x8010f505,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
80108775:	0f b6 d0             	movzbl %al,%edx
      my_ip[0],
80108778:	0f b6 05 04 f5 10 80 	movzbl 0x8010f504,%eax
  cprintf("IP Address %d.%d.%d.%d\n",
8010877f:	0f b6 c0             	movzbl %al,%eax
80108782:	83 ec 0c             	sub    $0xc,%esp
80108785:	53                   	push   %ebx
80108786:	51                   	push   %ecx
80108787:	52                   	push   %edx
80108788:	50                   	push   %eax
80108789:	68 00 c1 10 80       	push   $0x8010c100
8010878e:	e8 61 7c ff ff       	call   801003f4 <cprintf>
80108793:	83 c4 20             	add    $0x20,%esp
  *imc = 0x0;
80108796:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108799:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
8010879f:	90                   	nop
801087a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801087a3:	c9                   	leave
801087a4:	c3                   	ret

801087a5 <i8254_init_recv>:

void i8254_init_recv(){
801087a5:	55                   	push   %ebp
801087a6:	89 e5                	mov    %esp,%ebp
801087a8:	57                   	push   %edi
801087a9:	56                   	push   %esi
801087aa:	53                   	push   %ebx
801087ab:	83 ec 6c             	sub    $0x6c,%esp
  
  uint data_l = i8254_read_eeprom(0x0);
801087ae:	83 ec 0c             	sub    $0xc,%esp
801087b1:	6a 00                	push   $0x0
801087b3:	e8 e8 04 00 00       	call   80108ca0 <i8254_read_eeprom>
801087b8:	83 c4 10             	add    $0x10,%esp
801087bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  mac_addr[0] = data_l&0xFF;
801087be:	8b 45 d8             	mov    -0x28(%ebp),%eax
801087c1:	a2 80 6e 19 80       	mov    %al,0x80196e80
  mac_addr[1] = data_l>>8;
801087c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801087c9:	c1 e8 08             	shr    $0x8,%eax
801087cc:	a2 81 6e 19 80       	mov    %al,0x80196e81
  uint data_m = i8254_read_eeprom(0x1);
801087d1:	83 ec 0c             	sub    $0xc,%esp
801087d4:	6a 01                	push   $0x1
801087d6:	e8 c5 04 00 00       	call   80108ca0 <i8254_read_eeprom>
801087db:	83 c4 10             	add    $0x10,%esp
801087de:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  mac_addr[2] = data_m&0xFF;
801087e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801087e4:	a2 82 6e 19 80       	mov    %al,0x80196e82
  mac_addr[3] = data_m>>8;
801087e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801087ec:	c1 e8 08             	shr    $0x8,%eax
801087ef:	a2 83 6e 19 80       	mov    %al,0x80196e83
  uint data_h = i8254_read_eeprom(0x2);
801087f4:	83 ec 0c             	sub    $0xc,%esp
801087f7:	6a 02                	push   $0x2
801087f9:	e8 a2 04 00 00       	call   80108ca0 <i8254_read_eeprom>
801087fe:	83 c4 10             	add    $0x10,%esp
80108801:	89 45 d0             	mov    %eax,-0x30(%ebp)
  mac_addr[4] = data_h&0xFF;
80108804:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108807:	a2 84 6e 19 80       	mov    %al,0x80196e84
  mac_addr[5] = data_h>>8;
8010880c:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010880f:	c1 e8 08             	shr    $0x8,%eax
80108812:	a2 85 6e 19 80       	mov    %al,0x80196e85
      mac_addr[0],
      mac_addr[1],
      mac_addr[2],
      mac_addr[3],
      mac_addr[4],
      mac_addr[5]);
80108817:	0f b6 05 85 6e 19 80 	movzbl 0x80196e85,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
8010881e:	0f b6 f8             	movzbl %al,%edi
      mac_addr[4],
80108821:	0f b6 05 84 6e 19 80 	movzbl 0x80196e84,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108828:	0f b6 f0             	movzbl %al,%esi
      mac_addr[3],
8010882b:	0f b6 05 83 6e 19 80 	movzbl 0x80196e83,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108832:	0f b6 d8             	movzbl %al,%ebx
      mac_addr[2],
80108835:	0f b6 05 82 6e 19 80 	movzbl 0x80196e82,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
8010883c:	0f b6 c8             	movzbl %al,%ecx
      mac_addr[1],
8010883f:	0f b6 05 81 6e 19 80 	movzbl 0x80196e81,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108846:	0f b6 d0             	movzbl %al,%edx
      mac_addr[0],
80108849:	0f b6 05 80 6e 19 80 	movzbl 0x80196e80,%eax
  cprintf("MAC Address %x:%x:%x:%x:%x:%x\n",
80108850:	0f b6 c0             	movzbl %al,%eax
80108853:	83 ec 04             	sub    $0x4,%esp
80108856:	57                   	push   %edi
80108857:	56                   	push   %esi
80108858:	53                   	push   %ebx
80108859:	51                   	push   %ecx
8010885a:	52                   	push   %edx
8010885b:	50                   	push   %eax
8010885c:	68 18 c1 10 80       	push   $0x8010c118
80108861:	e8 8e 7b ff ff       	call   801003f4 <cprintf>
80108866:	83 c4 20             	add    $0x20,%esp

  uint *ral = (uint *)(base_addr + 0x5400);
80108869:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010886e:	05 00 54 00 00       	add    $0x5400,%eax
80108873:	89 45 cc             	mov    %eax,-0x34(%ebp)
  uint *rah = (uint *)(base_addr + 0x5404);
80108876:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010887b:	05 04 54 00 00       	add    $0x5404,%eax
80108880:	89 45 c8             	mov    %eax,-0x38(%ebp)

  *ral = (data_l | (data_m << 16));
80108883:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108886:	c1 e0 10             	shl    $0x10,%eax
80108889:	0b 45 d8             	or     -0x28(%ebp),%eax
8010888c:	89 c2                	mov    %eax,%edx
8010888e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80108891:	89 10                	mov    %edx,(%eax)
  *rah = (data_h | I8254_RAH_AS_DEST | I8254_RAH_AV);
80108893:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108896:	0d 00 00 00 80       	or     $0x80000000,%eax
8010889b:	89 c2                	mov    %eax,%edx
8010889d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801088a0:	89 10                	mov    %edx,(%eax)

  uint *mta = (uint *)(base_addr + 0x5200);
801088a2:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088a7:	05 00 52 00 00       	add    $0x5200,%eax
801088ac:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  for(int i=0;i<128;i++){
801088af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801088b6:	eb 19                	jmp    801088d1 <i8254_init_recv+0x12c>
    mta[i] = 0;
801088b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801088bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801088c2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801088c5:	01 d0                	add    %edx,%eax
801088c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i=0;i<128;i++){
801088cd:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801088d1:	83 7d e4 7f          	cmpl   $0x7f,-0x1c(%ebp)
801088d5:	7e e1                	jle    801088b8 <i8254_init_recv+0x113>
  }

  uint *ims = (uint *)(base_addr + 0xD0);
801088d7:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088dc:	05 d0 00 00 00       	add    $0xd0,%eax
801088e1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  *ims = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
801088e4:	8b 45 c0             	mov    -0x40(%ebp),%eax
801088e7:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)
  uint *ics = (uint *)(base_addr + 0xC8);
801088ed:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
801088f2:	05 c8 00 00 00       	add    $0xc8,%eax
801088f7:	89 45 bc             	mov    %eax,-0x44(%ebp)
  *ics = (I8254_IMS_RXT0 | I8254_IMS_RXDMT0 | I8254_IMS_RXSEQ | I8254_IMS_LSC | I8254_IMS_RXO);
801088fa:	8b 45 bc             	mov    -0x44(%ebp),%eax
801088fd:	c7 00 dc 00 00 00    	movl   $0xdc,(%eax)



  uint *rxdctl = (uint *)(base_addr + 0x2828);
80108903:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108908:	05 28 28 00 00       	add    $0x2828,%eax
8010890d:	89 45 b8             	mov    %eax,-0x48(%ebp)
  *rxdctl = 0;
80108910:	8b 45 b8             	mov    -0x48(%ebp),%eax
80108913:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  uint *rctl = (uint *)(base_addr + 0x100);
80108919:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010891e:	05 00 01 00 00       	add    $0x100,%eax
80108923:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  *rctl = (I8254_RCTL_UPE | I8254_RCTL_MPE | I8254_RCTL_BAM | I8254_RCTL_BSIZE | I8254_RCTL_SECRC);
80108926:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108929:	c7 00 18 80 00 04    	movl   $0x4008018,(%eax)

  uint recv_desc_addr = (uint)kalloc();
8010892f:	e8 74 9e ff ff       	call   801027a8 <kalloc>
80108934:	89 45 b0             	mov    %eax,-0x50(%ebp)
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108937:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
8010893c:	05 00 28 00 00       	add    $0x2800,%eax
80108941:	89 45 ac             	mov    %eax,-0x54(%ebp)
  uint *rdbah = (uint *)(base_addr + 0x2804);
80108944:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108949:	05 04 28 00 00       	add    $0x2804,%eax
8010894e:	89 45 a8             	mov    %eax,-0x58(%ebp)
  uint *rdlen = (uint *)(base_addr + 0x2808);
80108951:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108956:	05 08 28 00 00       	add    $0x2808,%eax
8010895b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  uint *rdh = (uint *)(base_addr + 0x2810);
8010895e:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108963:	05 10 28 00 00       	add    $0x2810,%eax
80108968:	89 45 a0             	mov    %eax,-0x60(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
8010896b:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108970:	05 18 28 00 00       	add    $0x2818,%eax
80108975:	89 45 9c             	mov    %eax,-0x64(%ebp)

  *rdbal = V2P(recv_desc_addr);
80108978:	8b 45 b0             	mov    -0x50(%ebp),%eax
8010897b:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108981:	8b 45 ac             	mov    -0x54(%ebp),%eax
80108984:	89 10                	mov    %edx,(%eax)
  *rdbah = 0;
80108986:	8b 45 a8             	mov    -0x58(%ebp),%eax
80108989:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdlen = sizeof(struct i8254_recv_desc)*I8254_RECV_DESC_NUM;
8010898f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80108992:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  *rdh = 0;
80108998:	8b 45 a0             	mov    -0x60(%ebp),%eax
8010899b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *rdt = I8254_RECV_DESC_NUM;
801089a1:	8b 45 9c             	mov    -0x64(%ebp),%eax
801089a4:	c7 00 00 01 00 00    	movl   $0x100,(%eax)

  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)recv_desc_addr;
801089aa:	8b 45 b0             	mov    -0x50(%ebp),%eax
801089ad:	89 45 98             	mov    %eax,-0x68(%ebp)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
801089b0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801089b7:	eb 73                	jmp    80108a2c <i8254_init_recv+0x287>
    recv_desc[i].padding = 0;
801089b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089bc:	c1 e0 04             	shl    $0x4,%eax
801089bf:	89 c2                	mov    %eax,%edx
801089c1:	8b 45 98             	mov    -0x68(%ebp),%eax
801089c4:	01 d0                	add    %edx,%eax
801089c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    recv_desc[i].len = 0;
801089cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089d0:	c1 e0 04             	shl    $0x4,%eax
801089d3:	89 c2                	mov    %eax,%edx
801089d5:	8b 45 98             	mov    -0x68(%ebp),%eax
801089d8:	01 d0                	add    %edx,%eax
801089da:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    recv_desc[i].chk_sum = 0;
801089e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089e3:	c1 e0 04             	shl    $0x4,%eax
801089e6:	89 c2                	mov    %eax,%edx
801089e8:	8b 45 98             	mov    -0x68(%ebp),%eax
801089eb:	01 d0                	add    %edx,%eax
801089ed:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
    recv_desc[i].status = 0;
801089f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089f6:	c1 e0 04             	shl    $0x4,%eax
801089f9:	89 c2                	mov    %eax,%edx
801089fb:	8b 45 98             	mov    -0x68(%ebp),%eax
801089fe:	01 d0                	add    %edx,%eax
80108a00:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    recv_desc[i].errors = 0;
80108a04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a07:	c1 e0 04             	shl    $0x4,%eax
80108a0a:	89 c2                	mov    %eax,%edx
80108a0c:	8b 45 98             	mov    -0x68(%ebp),%eax
80108a0f:	01 d0                	add    %edx,%eax
80108a11:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    recv_desc[i].special = 0;
80108a15:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a18:	c1 e0 04             	shl    $0x4,%eax
80108a1b:	89 c2                	mov    %eax,%edx
80108a1d:	8b 45 98             	mov    -0x68(%ebp),%eax
80108a20:	01 d0                	add    %edx,%eax
80108a22:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_RECV_DESC_NUM;i++){
80108a28:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80108a2c:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
80108a33:	7e 84                	jle    801089b9 <i8254_init_recv+0x214>
  }

  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108a35:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80108a3c:	eb 57                	jmp    80108a95 <i8254_init_recv+0x2f0>
    uint buf_addr = (uint)kalloc();
80108a3e:	e8 65 9d ff ff       	call   801027a8 <kalloc>
80108a43:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if(buf_addr == 0){
80108a46:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
80108a4a:	75 12                	jne    80108a5e <i8254_init_recv+0x2b9>
      cprintf("failed to allocate buffer area\n");
80108a4c:	83 ec 0c             	sub    $0xc,%esp
80108a4f:	68 38 c1 10 80       	push   $0x8010c138
80108a54:	e8 9b 79 ff ff       	call   801003f4 <cprintf>
80108a59:	83 c4 10             	add    $0x10,%esp
      break;
80108a5c:	eb 3d                	jmp    80108a9b <i8254_init_recv+0x2f6>
    }
    recv_desc[i].buf_addr = V2P(buf_addr);
80108a5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108a61:	c1 e0 04             	shl    $0x4,%eax
80108a64:	89 c2                	mov    %eax,%edx
80108a66:	8b 45 98             	mov    -0x68(%ebp),%eax
80108a69:	01 d0                	add    %edx,%eax
80108a6b:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108a6e:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108a74:	89 10                	mov    %edx,(%eax)
    recv_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108a76:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108a79:	83 c0 01             	add    $0x1,%eax
80108a7c:	c1 e0 04             	shl    $0x4,%eax
80108a7f:	89 c2                	mov    %eax,%edx
80108a81:	8b 45 98             	mov    -0x68(%ebp),%eax
80108a84:	01 d0                	add    %edx,%eax
80108a86:	8b 55 94             	mov    -0x6c(%ebp),%edx
80108a89:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108a8f:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_RECV_DESC_NUM)/2;i++){
80108a91:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80108a95:	83 7d dc 7f          	cmpl   $0x7f,-0x24(%ebp)
80108a99:	7e a3                	jle    80108a3e <i8254_init_recv+0x299>
  }

  *rctl |= I8254_RCTL_EN;
80108a9b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108a9e:	8b 00                	mov    (%eax),%eax
80108aa0:	83 c8 02             	or     $0x2,%eax
80108aa3:	89 c2                	mov    %eax,%edx
80108aa5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80108aa8:	89 10                	mov    %edx,(%eax)
  cprintf("E1000 Recieve Initialize Done\n");
80108aaa:	83 ec 0c             	sub    $0xc,%esp
80108aad:	68 58 c1 10 80       	push   $0x8010c158
80108ab2:	e8 3d 79 ff ff       	call   801003f4 <cprintf>
80108ab7:	83 c4 10             	add    $0x10,%esp
}
80108aba:	90                   	nop
80108abb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108abe:	5b                   	pop    %ebx
80108abf:	5e                   	pop    %esi
80108ac0:	5f                   	pop    %edi
80108ac1:	5d                   	pop    %ebp
80108ac2:	c3                   	ret

80108ac3 <i8254_init_send>:

void i8254_init_send(){
80108ac3:	55                   	push   %ebp
80108ac4:	89 e5                	mov    %esp,%ebp
80108ac6:	83 ec 48             	sub    $0x48,%esp
  uint *txdctl = (uint *)(base_addr + 0x3828);
80108ac9:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108ace:	05 28 38 00 00       	add    $0x3828,%eax
80108ad3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  *txdctl = (I8254_TXDCTL_WTHRESH | I8254_TXDCTL_GRAN_DESC);
80108ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ad9:	c7 00 00 00 01 01    	movl   $0x1010000,(%eax)

  uint tx_desc_addr = (uint)kalloc();
80108adf:	e8 c4 9c ff ff       	call   801027a8 <kalloc>
80108ae4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108ae7:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108aec:	05 00 38 00 00       	add    $0x3800,%eax
80108af1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint *tdbah = (uint *)(base_addr + 0x3804);
80108af4:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108af9:	05 04 38 00 00       	add    $0x3804,%eax
80108afe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint *tdlen = (uint *)(base_addr + 0x3808);
80108b01:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108b06:	05 08 38 00 00       	add    $0x3808,%eax
80108b0b:	89 45 dc             	mov    %eax,-0x24(%ebp)

  *tdbal = V2P(tx_desc_addr);
80108b0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b11:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108b17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108b1a:	89 10                	mov    %edx,(%eax)
  *tdbah = 0;
80108b1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108b1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdlen = sizeof(struct i8254_send_desc)*I8254_SEND_DESC_NUM;
80108b25:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108b28:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  uint *tdh = (uint *)(base_addr + 0x3810);
80108b2e:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108b33:	05 10 38 00 00       	add    $0x3810,%eax
80108b38:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108b3b:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108b40:	05 18 38 00 00       	add    $0x3818,%eax
80108b45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  *tdh = 0;
80108b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108b4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  *tdt = 0;
80108b51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80108b54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  struct i8254_send_desc *send_desc = (struct i8254_send_desc *)tx_desc_addr;
80108b5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b5d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108b60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b67:	e9 82 00 00 00       	jmp    80108bee <i8254_init_send+0x12b>
    send_desc[i].padding = 0;
80108b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b6f:	c1 e0 04             	shl    $0x4,%eax
80108b72:	89 c2                	mov    %eax,%edx
80108b74:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b77:	01 d0                	add    %edx,%eax
80108b79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    send_desc[i].len = 0;
80108b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b83:	c1 e0 04             	shl    $0x4,%eax
80108b86:	89 c2                	mov    %eax,%edx
80108b88:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b8b:	01 d0                	add    %edx,%eax
80108b8d:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
    send_desc[i].cso = 0;
80108b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b96:	c1 e0 04             	shl    $0x4,%eax
80108b99:	89 c2                	mov    %eax,%edx
80108b9b:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108b9e:	01 d0                	add    %edx,%eax
80108ba0:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    send_desc[i].cmd = 0;
80108ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ba7:	c1 e0 04             	shl    $0x4,%eax
80108baa:	89 c2                	mov    %eax,%edx
80108bac:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108baf:	01 d0                	add    %edx,%eax
80108bb1:	c6 40 0b 00          	movb   $0x0,0xb(%eax)
    send_desc[i].sta = 0;
80108bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bb8:	c1 e0 04             	shl    $0x4,%eax
80108bbb:	89 c2                	mov    %eax,%edx
80108bbd:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108bc0:	01 d0                	add    %edx,%eax
80108bc2:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    send_desc[i].css = 0;
80108bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bc9:	c1 e0 04             	shl    $0x4,%eax
80108bcc:	89 c2                	mov    %eax,%edx
80108bce:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108bd1:	01 d0                	add    %edx,%eax
80108bd3:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    send_desc[i].special = 0;
80108bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bda:	c1 e0 04             	shl    $0x4,%eax
80108bdd:	89 c2                	mov    %eax,%edx
80108bdf:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108be2:	01 d0                	add    %edx,%eax
80108be4:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
  for(int i=0;i<I8254_SEND_DESC_NUM;i++){
80108bea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108bee:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80108bf5:	0f 8e 71 ff ff ff    	jle    80108b6c <i8254_init_send+0xa9>
  }

  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108bfb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80108c02:	eb 57                	jmp    80108c5b <i8254_init_send+0x198>
    uint buf_addr = (uint)kalloc();
80108c04:	e8 9f 9b ff ff       	call   801027a8 <kalloc>
80108c09:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(buf_addr == 0){
80108c0c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80108c10:	75 12                	jne    80108c24 <i8254_init_send+0x161>
      cprintf("failed to allocate buffer area\n");
80108c12:	83 ec 0c             	sub    $0xc,%esp
80108c15:	68 38 c1 10 80       	push   $0x8010c138
80108c1a:	e8 d5 77 ff ff       	call   801003f4 <cprintf>
80108c1f:	83 c4 10             	add    $0x10,%esp
      break;
80108c22:	eb 3d                	jmp    80108c61 <i8254_init_send+0x19e>
    }
    send_desc[i].buf_addr = V2P(buf_addr);
80108c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c27:	c1 e0 04             	shl    $0x4,%eax
80108c2a:	89 c2                	mov    %eax,%edx
80108c2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108c2f:	01 d0                	add    %edx,%eax
80108c31:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108c34:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108c3a:	89 10                	mov    %edx,(%eax)
    send_desc[i+1].buf_addr = V2P(buf_addr + 0x800);
80108c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c3f:	83 c0 01             	add    $0x1,%eax
80108c42:	c1 e0 04             	shl    $0x4,%eax
80108c45:	89 c2                	mov    %eax,%edx
80108c47:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108c4a:	01 d0                	add    %edx,%eax
80108c4c:	8b 55 cc             	mov    -0x34(%ebp),%edx
80108c4f:	81 ea 00 f8 ff 7f    	sub    $0x7ffff800,%edx
80108c55:	89 10                	mov    %edx,(%eax)
  for(int i=0;i<(I8254_SEND_DESC_NUM)/2;i++){
80108c57:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80108c5b:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80108c5f:	7e a3                	jle    80108c04 <i8254_init_send+0x141>
  }

  uint *tctl = (uint *)(base_addr + 0x400);
80108c61:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c66:	05 00 04 00 00       	add    $0x400,%eax
80108c6b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  *tctl = (I8254_TCTL_EN | I8254_TCTL_PSP | I8254_TCTL_COLD | I8254_TCTL_CT);
80108c6e:	8b 45 c8             	mov    -0x38(%ebp),%eax
80108c71:	c7 00 fa 00 04 00    	movl   $0x400fa,(%eax)

  uint *tipg = (uint *)(base_addr + 0x410);
80108c77:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108c7c:	05 10 04 00 00       	add    $0x410,%eax
80108c81:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  *tipg = (10 | (10<<10) | (10<<20));
80108c84:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80108c87:	c7 00 0a 28 a0 00    	movl   $0xa0280a,(%eax)
  cprintf("E1000 Transmit Initialize Done\n");
80108c8d:	83 ec 0c             	sub    $0xc,%esp
80108c90:	68 78 c1 10 80       	push   $0x8010c178
80108c95:	e8 5a 77 ff ff       	call   801003f4 <cprintf>
80108c9a:	83 c4 10             	add    $0x10,%esp

}
80108c9d:	90                   	nop
80108c9e:	c9                   	leave
80108c9f:	c3                   	ret

80108ca0 <i8254_read_eeprom>:
uint i8254_read_eeprom(uint addr){
80108ca0:	55                   	push   %ebp
80108ca1:	89 e5                	mov    %esp,%ebp
80108ca3:	83 ec 18             	sub    $0x18,%esp
  uint *eerd = (uint *)(base_addr + 0x14);
80108ca6:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108cab:	83 c0 14             	add    $0x14,%eax
80108cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  *eerd = (((addr & 0xFF) << 8) | 1);
80108cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80108cb4:	c1 e0 08             	shl    $0x8,%eax
80108cb7:	0f b7 c0             	movzwl %ax,%eax
80108cba:	83 c8 01             	or     $0x1,%eax
80108cbd:	89 c2                	mov    %eax,%edx
80108cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc2:	89 10                	mov    %edx,(%eax)
  while(1){
    cprintf("");
80108cc4:	83 ec 0c             	sub    $0xc,%esp
80108cc7:	68 98 c1 10 80       	push   $0x8010c198
80108ccc:	e8 23 77 ff ff       	call   801003f4 <cprintf>
80108cd1:	83 c4 10             	add    $0x10,%esp
    volatile uint data = *eerd;
80108cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd7:	8b 00                	mov    (%eax),%eax
80108cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((data & (1<<4)) != 0){
80108cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cdf:	83 e0 10             	and    $0x10,%eax
80108ce2:	85 c0                	test   %eax,%eax
80108ce4:	75 02                	jne    80108ce8 <i8254_read_eeprom+0x48>
  while(1){
80108ce6:	eb dc                	jmp    80108cc4 <i8254_read_eeprom+0x24>
      break;
80108ce8:	90                   	nop
    }
  }

  return (*eerd >> 16) & 0xFFFF;
80108ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cec:	8b 00                	mov    (%eax),%eax
80108cee:	c1 e8 10             	shr    $0x10,%eax
}
80108cf1:	c9                   	leave
80108cf2:	c3                   	ret

80108cf3 <i8254_recv>:
void i8254_recv(){
80108cf3:	55                   	push   %ebp
80108cf4:	89 e5                	mov    %esp,%ebp
80108cf6:	83 ec 28             	sub    $0x28,%esp
  uint *rdh = (uint *)(base_addr + 0x2810);
80108cf9:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108cfe:	05 10 28 00 00       	add    $0x2810,%eax
80108d03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *rdt = (uint *)(base_addr + 0x2818);
80108d06:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108d0b:	05 18 28 00 00       	add    $0x2818,%eax
80108d10:	89 45 f0             	mov    %eax,-0x10(%ebp)
//  uint *torl = (uint *)(base_addr + 0x40C0);
//  uint *tpr = (uint *)(base_addr + 0x40D0);
//  uint *icr = (uint *)(base_addr + 0xC0);
  uint *rdbal = (uint *)(base_addr + 0x2800);
80108d13:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108d18:	05 00 28 00 00       	add    $0x2800,%eax
80108d1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_recv_desc *recv_desc = (struct i8254_recv_desc *)(P2V(*rdbal));
80108d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d23:	8b 00                	mov    (%eax),%eax
80108d25:	05 00 00 00 80       	add    $0x80000000,%eax
80108d2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  while(1){
    int rx_available = (I8254_RECV_DESC_NUM - *rdt + *rdh)%I8254_RECV_DESC_NUM;
80108d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d30:	8b 10                	mov    (%eax),%edx
80108d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d35:	8b 00                	mov    (%eax),%eax
80108d37:	29 c2                	sub    %eax,%edx
80108d39:	89 d0                	mov    %edx,%eax
80108d3b:	25 ff 00 00 00       	and    $0xff,%eax
80108d40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(rx_available > 0){
80108d43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108d47:	7e 37                	jle    80108d80 <i8254_recv+0x8d>
      uint buffer_addr = P2V_WO(recv_desc[*rdt].buf_addr);
80108d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d4c:	8b 00                	mov    (%eax),%eax
80108d4e:	c1 e0 04             	shl    $0x4,%eax
80108d51:	89 c2                	mov    %eax,%edx
80108d53:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d56:	01 d0                	add    %edx,%eax
80108d58:	8b 00                	mov    (%eax),%eax
80108d5a:	05 00 00 00 80       	add    $0x80000000,%eax
80108d5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
      *rdt = (*rdt + 1)%I8254_RECV_DESC_NUM;
80108d62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d65:	8b 00                	mov    (%eax),%eax
80108d67:	83 c0 01             	add    $0x1,%eax
80108d6a:	0f b6 d0             	movzbl %al,%edx
80108d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d70:	89 10                	mov    %edx,(%eax)
      eth_proc(buffer_addr);
80108d72:	83 ec 0c             	sub    $0xc,%esp
80108d75:	ff 75 e0             	push   -0x20(%ebp)
80108d78:	e8 13 09 00 00       	call   80109690 <eth_proc>
80108d7d:	83 c4 10             	add    $0x10,%esp
    }
    if(*rdt == *rdh) {
80108d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d83:	8b 10                	mov    (%eax),%edx
80108d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d88:	8b 00                	mov    (%eax),%eax
80108d8a:	39 c2                	cmp    %eax,%edx
80108d8c:	75 9f                	jne    80108d2d <i8254_recv+0x3a>
      (*rdt)--;
80108d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d91:	8b 00                	mov    (%eax),%eax
80108d93:	8d 50 ff             	lea    -0x1(%eax),%edx
80108d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d99:	89 10                	mov    %edx,(%eax)
  while(1){
80108d9b:	eb 90                	jmp    80108d2d <i8254_recv+0x3a>

80108d9d <i8254_send>:
    }
  }
}

int i8254_send(const uint pkt_addr,uint len){
80108d9d:	55                   	push   %ebp
80108d9e:	89 e5                	mov    %esp,%ebp
80108da0:	83 ec 28             	sub    $0x28,%esp
  uint *tdh = (uint *)(base_addr + 0x3810);
80108da3:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108da8:	05 10 38 00 00       	add    $0x3810,%eax
80108dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint *tdt = (uint *)(base_addr + 0x3818);
80108db0:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108db5:	05 18 38 00 00       	add    $0x3818,%eax
80108dba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  uint *tdbal = (uint *)(base_addr + 0x3800);
80108dbd:	a1 7c 6e 19 80       	mov    0x80196e7c,%eax
80108dc2:	05 00 38 00 00       	add    $0x3800,%eax
80108dc7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct i8254_send_desc *txdesc = (struct i8254_send_desc *)P2V_WO(*tdbal);
80108dca:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108dcd:	8b 00                	mov    (%eax),%eax
80108dcf:	05 00 00 00 80       	add    $0x80000000,%eax
80108dd4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int tx_available = I8254_SEND_DESC_NUM - ((I8254_SEND_DESC_NUM - *tdh + *tdt) % I8254_SEND_DESC_NUM);
80108dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dda:	8b 10                	mov    (%eax),%edx
80108ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ddf:	8b 00                	mov    (%eax),%eax
80108de1:	29 c2                	sub    %eax,%edx
80108de3:	0f b6 c2             	movzbl %dl,%eax
80108de6:	ba 00 01 00 00       	mov    $0x100,%edx
80108deb:	29 c2                	sub    %eax,%edx
80108ded:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  uint index = *tdt%I8254_SEND_DESC_NUM;
80108df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108df3:	8b 00                	mov    (%eax),%eax
80108df5:	25 ff 00 00 00       	and    $0xff,%eax
80108dfa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(tx_available > 0) {
80108dfd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108e01:	0f 8e a8 00 00 00    	jle    80108eaf <i8254_send+0x112>
    memmove(P2V_WO((void *)txdesc[index].buf_addr),(void *)pkt_addr,len);
80108e07:	8b 45 08             	mov    0x8(%ebp),%eax
80108e0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80108e0d:	89 d1                	mov    %edx,%ecx
80108e0f:	c1 e1 04             	shl    $0x4,%ecx
80108e12:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108e15:	01 ca                	add    %ecx,%edx
80108e17:	8b 12                	mov    (%edx),%edx
80108e19:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108e1f:	83 ec 04             	sub    $0x4,%esp
80108e22:	ff 75 0c             	push   0xc(%ebp)
80108e25:	50                   	push   %eax
80108e26:	52                   	push   %edx
80108e27:	e8 76 be ff ff       	call   80104ca2 <memmove>
80108e2c:	83 c4 10             	add    $0x10,%esp
    txdesc[index].len = len;
80108e2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e32:	c1 e0 04             	shl    $0x4,%eax
80108e35:	89 c2                	mov    %eax,%edx
80108e37:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e3a:	01 d0                	add    %edx,%eax
80108e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
80108e3f:	66 89 50 08          	mov    %dx,0x8(%eax)
    txdesc[index].sta = 0;
80108e43:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e46:	c1 e0 04             	shl    $0x4,%eax
80108e49:	89 c2                	mov    %eax,%edx
80108e4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e4e:	01 d0                	add    %edx,%eax
80108e50:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
    txdesc[index].css = 0;
80108e54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e57:	c1 e0 04             	shl    $0x4,%eax
80108e5a:	89 c2                	mov    %eax,%edx
80108e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e5f:	01 d0                	add    %edx,%eax
80108e61:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
    txdesc[index].cmd = 0xb;
80108e65:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e68:	c1 e0 04             	shl    $0x4,%eax
80108e6b:	89 c2                	mov    %eax,%edx
80108e6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e70:	01 d0                	add    %edx,%eax
80108e72:	c6 40 0b 0b          	movb   $0xb,0xb(%eax)
    txdesc[index].special = 0;
80108e76:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e79:	c1 e0 04             	shl    $0x4,%eax
80108e7c:	89 c2                	mov    %eax,%edx
80108e7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e81:	01 d0                	add    %edx,%eax
80108e83:	66 c7 40 0e 00 00    	movw   $0x0,0xe(%eax)
    txdesc[index].cso = 0;
80108e89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e8c:	c1 e0 04             	shl    $0x4,%eax
80108e8f:	89 c2                	mov    %eax,%edx
80108e91:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e94:	01 d0                	add    %edx,%eax
80108e96:	c6 40 0a 00          	movb   $0x0,0xa(%eax)
    *tdt = (*tdt + 1)%I8254_SEND_DESC_NUM;
80108e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e9d:	8b 00                	mov    (%eax),%eax
80108e9f:	83 c0 01             	add    $0x1,%eax
80108ea2:	0f b6 d0             	movzbl %al,%edx
80108ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ea8:	89 10                	mov    %edx,(%eax)
    return len;
80108eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ead:	eb 05                	jmp    80108eb4 <i8254_send+0x117>
  }else{
    return -1;
80108eaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80108eb4:	c9                   	leave
80108eb5:	c3                   	ret

80108eb6 <i8254_intr>:

void i8254_intr(){
80108eb6:	55                   	push   %ebp
80108eb7:	89 e5                	mov    %esp,%ebp
  *intr_addr = 0xEEEEEE;
80108eb9:	a1 88 6e 19 80       	mov    0x80196e88,%eax
80108ebe:	c7 00 ee ee ee 00    	movl   $0xeeeeee,(%eax)
}
80108ec4:	90                   	nop
80108ec5:	5d                   	pop    %ebp
80108ec6:	c3                   	ret

80108ec7 <arp_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

struct arp_entry arp_table[ARP_TABLE_MAX] = {0};

int arp_proc(uint buffer_addr){
80108ec7:	55                   	push   %ebp
80108ec8:	89 e5                	mov    %esp,%ebp
80108eca:	83 ec 18             	sub    $0x18,%esp
  struct arp_pkt *arp_p = (struct arp_pkt *)(buffer_addr);
80108ecd:	8b 45 08             	mov    0x8(%ebp),%eax
80108ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(arp_p->hrd_type != ARP_HARDWARE_TYPE) return -1;
80108ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ed6:	0f b7 00             	movzwl (%eax),%eax
80108ed9:	66 3d 00 01          	cmp    $0x100,%ax
80108edd:	74 0a                	je     80108ee9 <arp_proc+0x22>
80108edf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108ee4:	e9 4f 01 00 00       	jmp    80109038 <arp_proc+0x171>
  if(arp_p->pro_type != ARP_PROTOCOL_TYPE) return -1;
80108ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eec:	0f b7 40 02          	movzwl 0x2(%eax),%eax
80108ef0:	66 83 f8 08          	cmp    $0x8,%ax
80108ef4:	74 0a                	je     80108f00 <arp_proc+0x39>
80108ef6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108efb:	e9 38 01 00 00       	jmp    80109038 <arp_proc+0x171>
  if(arp_p->hrd_len != 6) return -1;
80108f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f03:	0f b6 40 04          	movzbl 0x4(%eax),%eax
80108f07:	3c 06                	cmp    $0x6,%al
80108f09:	74 0a                	je     80108f15 <arp_proc+0x4e>
80108f0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f10:	e9 23 01 00 00       	jmp    80109038 <arp_proc+0x171>
  if(arp_p->pro_len != 4) return -1;
80108f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f18:	0f b6 40 05          	movzbl 0x5(%eax),%eax
80108f1c:	3c 04                	cmp    $0x4,%al
80108f1e:	74 0a                	je     80108f2a <arp_proc+0x63>
80108f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f25:	e9 0e 01 00 00       	jmp    80109038 <arp_proc+0x171>
  if(memcmp(my_ip,arp_p->dst_ip,4) != 0 && memcmp(my_ip,arp_p->src_ip,4) != 0) return -1;
80108f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f2d:	83 c0 18             	add    $0x18,%eax
80108f30:	83 ec 04             	sub    $0x4,%esp
80108f33:	6a 04                	push   $0x4
80108f35:	50                   	push   %eax
80108f36:	68 04 f5 10 80       	push   $0x8010f504
80108f3b:	e8 0a bd ff ff       	call   80104c4a <memcmp>
80108f40:	83 c4 10             	add    $0x10,%esp
80108f43:	85 c0                	test   %eax,%eax
80108f45:	74 27                	je     80108f6e <arp_proc+0xa7>
80108f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f4a:	83 c0 0e             	add    $0xe,%eax
80108f4d:	83 ec 04             	sub    $0x4,%esp
80108f50:	6a 04                	push   $0x4
80108f52:	50                   	push   %eax
80108f53:	68 04 f5 10 80       	push   $0x8010f504
80108f58:	e8 ed bc ff ff       	call   80104c4a <memcmp>
80108f5d:	83 c4 10             	add    $0x10,%esp
80108f60:	85 c0                	test   %eax,%eax
80108f62:	74 0a                	je     80108f6e <arp_proc+0xa7>
80108f64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f69:	e9 ca 00 00 00       	jmp    80109038 <arp_proc+0x171>
  if(arp_p->op == ARP_OPS_REQUEST && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f71:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108f75:	66 3d 00 01          	cmp    $0x100,%ax
80108f79:	75 69                	jne    80108fe4 <arp_proc+0x11d>
80108f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f7e:	83 c0 18             	add    $0x18,%eax
80108f81:	83 ec 04             	sub    $0x4,%esp
80108f84:	6a 04                	push   $0x4
80108f86:	50                   	push   %eax
80108f87:	68 04 f5 10 80       	push   $0x8010f504
80108f8c:	e8 b9 bc ff ff       	call   80104c4a <memcmp>
80108f91:	83 c4 10             	add    $0x10,%esp
80108f94:	85 c0                	test   %eax,%eax
80108f96:	75 4c                	jne    80108fe4 <arp_proc+0x11d>
    uint send = (uint)kalloc();
80108f98:	e8 0b 98 ff ff       	call   801027a8 <kalloc>
80108f9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint send_size=0;
80108fa0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    arp_reply_pkt_create(arp_p,send,&send_size);
80108fa7:	83 ec 04             	sub    $0x4,%esp
80108faa:	8d 45 ec             	lea    -0x14(%ebp),%eax
80108fad:	50                   	push   %eax
80108fae:	ff 75 f0             	push   -0x10(%ebp)
80108fb1:	ff 75 f4             	push   -0xc(%ebp)
80108fb4:	e8 1f 04 00 00       	call   801093d8 <arp_reply_pkt_create>
80108fb9:	83 c4 10             	add    $0x10,%esp
    i8254_send(send,send_size);
80108fbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108fbf:	83 ec 08             	sub    $0x8,%esp
80108fc2:	50                   	push   %eax
80108fc3:	ff 75 f0             	push   -0x10(%ebp)
80108fc6:	e8 d2 fd ff ff       	call   80108d9d <i8254_send>
80108fcb:	83 c4 10             	add    $0x10,%esp
    kfree((char *)send);
80108fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fd1:	83 ec 0c             	sub    $0xc,%esp
80108fd4:	50                   	push   %eax
80108fd5:	e8 34 97 ff ff       	call   8010270e <kfree>
80108fda:	83 c4 10             	add    $0x10,%esp
    return ARP_CREATED_REPLY;
80108fdd:	b8 02 00 00 00       	mov    $0x2,%eax
80108fe2:	eb 54                	jmp    80109038 <arp_proc+0x171>
  }else if(arp_p->op == ARP_OPS_REPLY && memcmp(my_ip,arp_p->dst_ip,4) == 0){
80108fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fe7:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80108feb:	66 3d 00 02          	cmp    $0x200,%ax
80108fef:	75 42                	jne    80109033 <arp_proc+0x16c>
80108ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ff4:	83 c0 18             	add    $0x18,%eax
80108ff7:	83 ec 04             	sub    $0x4,%esp
80108ffa:	6a 04                	push   $0x4
80108ffc:	50                   	push   %eax
80108ffd:	68 04 f5 10 80       	push   $0x8010f504
80109002:	e8 43 bc ff ff       	call   80104c4a <memcmp>
80109007:	83 c4 10             	add    $0x10,%esp
8010900a:	85 c0                	test   %eax,%eax
8010900c:	75 25                	jne    80109033 <arp_proc+0x16c>
    cprintf("ARP TABLE UPDATED\n");
8010900e:	83 ec 0c             	sub    $0xc,%esp
80109011:	68 9c c1 10 80       	push   $0x8010c19c
80109016:	e8 d9 73 ff ff       	call   801003f4 <cprintf>
8010901b:	83 c4 10             	add    $0x10,%esp
    arp_table_update(arp_p);
8010901e:	83 ec 0c             	sub    $0xc,%esp
80109021:	ff 75 f4             	push   -0xc(%ebp)
80109024:	e8 af 01 00 00       	call   801091d8 <arp_table_update>
80109029:	83 c4 10             	add    $0x10,%esp
    return ARP_UPDATED_TABLE;
8010902c:	b8 01 00 00 00       	mov    $0x1,%eax
80109031:	eb 05                	jmp    80109038 <arp_proc+0x171>
  }else{
    return -1;
80109033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80109038:	c9                   	leave
80109039:	c3                   	ret

8010903a <arp_scan>:

void arp_scan(){
8010903a:	55                   	push   %ebp
8010903b:	89 e5                	mov    %esp,%ebp
8010903d:	83 ec 18             	sub    $0x18,%esp
  uint send_size;
  for(int i=0;i<256;i++){
80109040:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109047:	eb 6f                	jmp    801090b8 <arp_scan+0x7e>
    uint send = (uint)kalloc();
80109049:	e8 5a 97 ff ff       	call   801027a8 <kalloc>
8010904e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    arp_broadcast(send,&send_size,i);
80109051:	83 ec 04             	sub    $0x4,%esp
80109054:	ff 75 f4             	push   -0xc(%ebp)
80109057:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010905a:	50                   	push   %eax
8010905b:	ff 75 ec             	push   -0x14(%ebp)
8010905e:	e8 62 00 00 00       	call   801090c5 <arp_broadcast>
80109063:	83 c4 10             	add    $0x10,%esp
    uint res = i8254_send(send,send_size);
80109066:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109069:	83 ec 08             	sub    $0x8,%esp
8010906c:	50                   	push   %eax
8010906d:	ff 75 ec             	push   -0x14(%ebp)
80109070:	e8 28 fd ff ff       	call   80108d9d <i8254_send>
80109075:	83 c4 10             	add    $0x10,%esp
80109078:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
8010907b:	eb 22                	jmp    8010909f <arp_scan+0x65>
      microdelay(1);
8010907d:	83 ec 0c             	sub    $0xc,%esp
80109080:	6a 01                	push   $0x1
80109082:	e8 b2 9a ff ff       	call   80102b39 <microdelay>
80109087:	83 c4 10             	add    $0x10,%esp
      res = i8254_send(send,send_size);
8010908a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010908d:	83 ec 08             	sub    $0x8,%esp
80109090:	50                   	push   %eax
80109091:	ff 75 ec             	push   -0x14(%ebp)
80109094:	e8 04 fd ff ff       	call   80108d9d <i8254_send>
80109099:	83 c4 10             	add    $0x10,%esp
8010909c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(res == -1){
8010909f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
801090a3:	74 d8                	je     8010907d <arp_scan+0x43>
    }
    kfree((char *)send);
801090a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801090a8:	83 ec 0c             	sub    $0xc,%esp
801090ab:	50                   	push   %eax
801090ac:	e8 5d 96 ff ff       	call   8010270e <kfree>
801090b1:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<256;i++){
801090b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801090b8:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801090bf:	7e 88                	jle    80109049 <arp_scan+0xf>
  }
}
801090c1:	90                   	nop
801090c2:	90                   	nop
801090c3:	c9                   	leave
801090c4:	c3                   	ret

801090c5 <arp_broadcast>:

void arp_broadcast(uint send,uint *send_size,uint ip){
801090c5:	55                   	push   %ebp
801090c6:	89 e5                	mov    %esp,%ebp
801090c8:	83 ec 28             	sub    $0x28,%esp
  uchar dst_ip[4] = {10,0,1,ip};
801090cb:	c6 45 ec 0a          	movb   $0xa,-0x14(%ebp)
801090cf:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
801090d3:	c6 45 ee 01          	movb   $0x1,-0x12(%ebp)
801090d7:	8b 45 10             	mov    0x10(%ebp),%eax
801090da:	88 45 ef             	mov    %al,-0x11(%ebp)
  uchar dst_mac_eth[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
801090dd:	c7 45 e6 ff ff ff ff 	movl   $0xffffffff,-0x1a(%ebp)
801090e4:	66 c7 45 ea ff ff    	movw   $0xffff,-0x16(%ebp)
  uchar dst_mac_arp[6] = {0,0,0,0,0,0};
801090ea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801090f1:	66 c7 45 e4 00 00    	movw   $0x0,-0x1c(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801090f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801090fa:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)

  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
80109100:	8b 45 08             	mov    0x8(%ebp),%eax
80109103:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
80109106:	8b 45 08             	mov    0x8(%ebp),%eax
80109109:	83 c0 0e             	add    $0xe,%eax
8010910c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  reply_eth->type[0] = 0x08;
8010910f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109112:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
80109116:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109119:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,dst_mac_eth,6);
8010911d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109120:	83 ec 04             	sub    $0x4,%esp
80109123:	6a 06                	push   $0x6
80109125:	8d 55 e6             	lea    -0x1a(%ebp),%edx
80109128:	52                   	push   %edx
80109129:	50                   	push   %eax
8010912a:	e8 73 bb ff ff       	call   80104ca2 <memmove>
8010912f:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
80109132:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109135:	83 c0 06             	add    $0x6,%eax
80109138:	83 ec 04             	sub    $0x4,%esp
8010913b:	6a 06                	push   $0x6
8010913d:	68 80 6e 19 80       	push   $0x80196e80
80109142:	50                   	push   %eax
80109143:	e8 5a bb ff ff       	call   80104ca2 <memmove>
80109148:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
8010914b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010914e:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
80109153:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109156:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
8010915c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010915f:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
80109163:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109166:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REQUEST;
8010916a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010916d:	66 c7 40 06 00 01    	movw   $0x100,0x6(%eax)
  memmove(reply_arp->dst_mac,dst_mac_arp,6);
80109173:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109176:	8d 50 12             	lea    0x12(%eax),%edx
80109179:	83 ec 04             	sub    $0x4,%esp
8010917c:	6a 06                	push   $0x6
8010917e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80109181:	50                   	push   %eax
80109182:	52                   	push   %edx
80109183:	e8 1a bb ff ff       	call   80104ca2 <memmove>
80109188:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,dst_ip,4);
8010918b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010918e:	8d 50 18             	lea    0x18(%eax),%edx
80109191:	83 ec 04             	sub    $0x4,%esp
80109194:	6a 04                	push   $0x4
80109196:	8d 45 ec             	lea    -0x14(%ebp),%eax
80109199:	50                   	push   %eax
8010919a:	52                   	push   %edx
8010919b:	e8 02 bb ff ff       	call   80104ca2 <memmove>
801091a0:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
801091a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091a6:	83 c0 08             	add    $0x8,%eax
801091a9:	83 ec 04             	sub    $0x4,%esp
801091ac:	6a 06                	push   $0x6
801091ae:	68 80 6e 19 80       	push   $0x80196e80
801091b3:	50                   	push   %eax
801091b4:	e8 e9 ba ff ff       	call   80104ca2 <memmove>
801091b9:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
801091bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091bf:	83 c0 0e             	add    $0xe,%eax
801091c2:	83 ec 04             	sub    $0x4,%esp
801091c5:	6a 04                	push   $0x4
801091c7:	68 04 f5 10 80       	push   $0x8010f504
801091cc:	50                   	push   %eax
801091cd:	e8 d0 ba ff ff       	call   80104ca2 <memmove>
801091d2:	83 c4 10             	add    $0x10,%esp
}
801091d5:	90                   	nop
801091d6:	c9                   	leave
801091d7:	c3                   	ret

801091d8 <arp_table_update>:

void arp_table_update(struct arp_pkt *recv_arp){
801091d8:	55                   	push   %ebp
801091d9:	89 e5                	mov    %esp,%ebp
801091db:	83 ec 18             	sub    $0x18,%esp
  int index = arp_table_search(recv_arp->src_ip);
801091de:	8b 45 08             	mov    0x8(%ebp),%eax
801091e1:	83 c0 0e             	add    $0xe,%eax
801091e4:	83 ec 0c             	sub    $0xc,%esp
801091e7:	50                   	push   %eax
801091e8:	e8 bc 00 00 00       	call   801092a9 <arp_table_search>
801091ed:	83 c4 10             	add    $0x10,%esp
801091f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(index > -1){
801091f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801091f7:	78 2d                	js     80109226 <arp_table_update+0x4e>
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
801091f9:	8b 45 08             	mov    0x8(%ebp),%eax
801091fc:	8d 48 08             	lea    0x8(%eax),%ecx
801091ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109202:	89 d0                	mov    %edx,%eax
80109204:	c1 e0 02             	shl    $0x2,%eax
80109207:	01 d0                	add    %edx,%eax
80109209:	01 c0                	add    %eax,%eax
8010920b:	01 d0                	add    %edx,%eax
8010920d:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
80109212:	83 c0 04             	add    $0x4,%eax
80109215:	83 ec 04             	sub    $0x4,%esp
80109218:	6a 06                	push   $0x6
8010921a:	51                   	push   %ecx
8010921b:	50                   	push   %eax
8010921c:	e8 81 ba ff ff       	call   80104ca2 <memmove>
80109221:	83 c4 10             	add    $0x10,%esp
80109224:	eb 70                	jmp    80109296 <arp_table_update+0xbe>
  }else{
    index += 1;
80109226:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    index = -index;
8010922a:	f7 5d f4             	negl   -0xc(%ebp)
    memmove(arp_table[index].mac,recv_arp->src_mac,6);
8010922d:	8b 45 08             	mov    0x8(%ebp),%eax
80109230:	8d 48 08             	lea    0x8(%eax),%ecx
80109233:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109236:	89 d0                	mov    %edx,%eax
80109238:	c1 e0 02             	shl    $0x2,%eax
8010923b:	01 d0                	add    %edx,%eax
8010923d:	01 c0                	add    %eax,%eax
8010923f:	01 d0                	add    %edx,%eax
80109241:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
80109246:	83 c0 04             	add    $0x4,%eax
80109249:	83 ec 04             	sub    $0x4,%esp
8010924c:	6a 06                	push   $0x6
8010924e:	51                   	push   %ecx
8010924f:	50                   	push   %eax
80109250:	e8 4d ba ff ff       	call   80104ca2 <memmove>
80109255:	83 c4 10             	add    $0x10,%esp
    memmove(arp_table[index].ip,recv_arp->src_ip,4);
80109258:	8b 45 08             	mov    0x8(%ebp),%eax
8010925b:	8d 48 0e             	lea    0xe(%eax),%ecx
8010925e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109261:	89 d0                	mov    %edx,%eax
80109263:	c1 e0 02             	shl    $0x2,%eax
80109266:	01 d0                	add    %edx,%eax
80109268:	01 c0                	add    %eax,%eax
8010926a:	01 d0                	add    %edx,%eax
8010926c:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
80109271:	83 ec 04             	sub    $0x4,%esp
80109274:	6a 04                	push   $0x4
80109276:	51                   	push   %ecx
80109277:	50                   	push   %eax
80109278:	e8 25 ba ff ff       	call   80104ca2 <memmove>
8010927d:	83 c4 10             	add    $0x10,%esp
    arp_table[index].use = 1;
80109280:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109283:	89 d0                	mov    %edx,%eax
80109285:	c1 e0 02             	shl    $0x2,%eax
80109288:	01 d0                	add    %edx,%eax
8010928a:	01 c0                	add    %eax,%eax
8010928c:	01 d0                	add    %edx,%eax
8010928e:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
80109293:	c6 00 01             	movb   $0x1,(%eax)
  }
  print_arp_table(arp_table);
80109296:	83 ec 0c             	sub    $0xc,%esp
80109299:	68 a0 6e 19 80       	push   $0x80196ea0
8010929e:	e8 83 00 00 00       	call   80109326 <print_arp_table>
801092a3:	83 c4 10             	add    $0x10,%esp
}
801092a6:	90                   	nop
801092a7:	c9                   	leave
801092a8:	c3                   	ret

801092a9 <arp_table_search>:

int arp_table_search(uchar *ip){
801092a9:	55                   	push   %ebp
801092aa:	89 e5                	mov    %esp,%ebp
801092ac:	83 ec 18             	sub    $0x18,%esp
  int empty=1;
801092af:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
801092b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801092bd:	eb 59                	jmp    80109318 <arp_table_search+0x6f>
    if(memcmp(arp_table[i].ip,ip,4) == 0){
801092bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801092c2:	89 d0                	mov    %edx,%eax
801092c4:	c1 e0 02             	shl    $0x2,%eax
801092c7:	01 d0                	add    %edx,%eax
801092c9:	01 c0                	add    %eax,%eax
801092cb:	01 d0                	add    %edx,%eax
801092cd:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
801092d2:	83 ec 04             	sub    $0x4,%esp
801092d5:	6a 04                	push   $0x4
801092d7:	ff 75 08             	push   0x8(%ebp)
801092da:	50                   	push   %eax
801092db:	e8 6a b9 ff ff       	call   80104c4a <memcmp>
801092e0:	83 c4 10             	add    $0x10,%esp
801092e3:	85 c0                	test   %eax,%eax
801092e5:	75 05                	jne    801092ec <arp_table_search+0x43>
      return i;
801092e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092ea:	eb 38                	jmp    80109324 <arp_table_search+0x7b>
    }
    if(arp_table[i].use == 0 && empty == 1){
801092ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
801092ef:	89 d0                	mov    %edx,%eax
801092f1:	c1 e0 02             	shl    $0x2,%eax
801092f4:	01 d0                	add    %edx,%eax
801092f6:	01 c0                	add    %eax,%eax
801092f8:	01 d0                	add    %edx,%eax
801092fa:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
801092ff:	0f b6 00             	movzbl (%eax),%eax
80109302:	84 c0                	test   %al,%al
80109304:	75 0e                	jne    80109314 <arp_table_search+0x6b>
80109306:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010930a:	75 08                	jne    80109314 <arp_table_search+0x6b>
      empty = -i;
8010930c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010930f:	f7 d8                	neg    %eax
80109311:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(int i=0;i<ARP_TABLE_MAX;i++){
80109314:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80109318:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
8010931c:	7e a1                	jle    801092bf <arp_table_search+0x16>
    }
  }
  return empty-1;
8010931e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109321:	83 e8 01             	sub    $0x1,%eax
}
80109324:	c9                   	leave
80109325:	c3                   	ret

80109326 <print_arp_table>:

void print_arp_table(){
80109326:	55                   	push   %ebp
80109327:	89 e5                	mov    %esp,%ebp
80109329:	83 ec 18             	sub    $0x18,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
8010932c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109333:	e9 92 00 00 00       	jmp    801093ca <print_arp_table+0xa4>
    if(arp_table[i].use != 0){
80109338:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010933b:	89 d0                	mov    %edx,%eax
8010933d:	c1 e0 02             	shl    $0x2,%eax
80109340:	01 d0                	add    %edx,%eax
80109342:	01 c0                	add    %eax,%eax
80109344:	01 d0                	add    %edx,%eax
80109346:	05 aa 6e 19 80       	add    $0x80196eaa,%eax
8010934b:	0f b6 00             	movzbl (%eax),%eax
8010934e:	84 c0                	test   %al,%al
80109350:	74 74                	je     801093c6 <print_arp_table+0xa0>
      cprintf("Entry Num: %d ",i);
80109352:	83 ec 08             	sub    $0x8,%esp
80109355:	ff 75 f4             	push   -0xc(%ebp)
80109358:	68 af c1 10 80       	push   $0x8010c1af
8010935d:	e8 92 70 ff ff       	call   801003f4 <cprintf>
80109362:	83 c4 10             	add    $0x10,%esp
      print_ipv4(arp_table[i].ip);
80109365:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109368:	89 d0                	mov    %edx,%eax
8010936a:	c1 e0 02             	shl    $0x2,%eax
8010936d:	01 d0                	add    %edx,%eax
8010936f:	01 c0                	add    %eax,%eax
80109371:	01 d0                	add    %edx,%eax
80109373:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
80109378:	83 ec 0c             	sub    $0xc,%esp
8010937b:	50                   	push   %eax
8010937c:	e8 54 02 00 00       	call   801095d5 <print_ipv4>
80109381:	83 c4 10             	add    $0x10,%esp
      cprintf(" ");
80109384:	83 ec 0c             	sub    $0xc,%esp
80109387:	68 be c1 10 80       	push   $0x8010c1be
8010938c:	e8 63 70 ff ff       	call   801003f4 <cprintf>
80109391:	83 c4 10             	add    $0x10,%esp
      print_mac(arp_table[i].mac);
80109394:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109397:	89 d0                	mov    %edx,%eax
80109399:	c1 e0 02             	shl    $0x2,%eax
8010939c:	01 d0                	add    %edx,%eax
8010939e:	01 c0                	add    %eax,%eax
801093a0:	01 d0                	add    %edx,%eax
801093a2:	05 a0 6e 19 80       	add    $0x80196ea0,%eax
801093a7:	83 c0 04             	add    $0x4,%eax
801093aa:	83 ec 0c             	sub    $0xc,%esp
801093ad:	50                   	push   %eax
801093ae:	e8 70 02 00 00       	call   80109623 <print_mac>
801093b3:	83 c4 10             	add    $0x10,%esp
      cprintf("\n");
801093b6:	83 ec 0c             	sub    $0xc,%esp
801093b9:	68 c0 c1 10 80       	push   $0x8010c1c0
801093be:	e8 31 70 ff ff       	call   801003f4 <cprintf>
801093c3:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i < ARP_TABLE_MAX;i++){
801093c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801093ca:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
801093ce:	0f 8e 64 ff ff ff    	jle    80109338 <print_arp_table+0x12>
    }
  }
}
801093d4:	90                   	nop
801093d5:	90                   	nop
801093d6:	c9                   	leave
801093d7:	c3                   	ret

801093d8 <arp_reply_pkt_create>:


void arp_reply_pkt_create(struct arp_pkt *arp_recv,uint send,uint *send_size){
801093d8:	55                   	push   %ebp
801093d9:	89 e5                	mov    %esp,%ebp
801093db:	83 ec 18             	sub    $0x18,%esp
  *send_size = sizeof(struct eth_pkt) + sizeof(struct arp_pkt);
801093de:	8b 45 10             	mov    0x10(%ebp),%eax
801093e1:	c7 00 2c 00 00 00    	movl   $0x2c,(%eax)
  
  struct eth_pkt *reply_eth = (struct eth_pkt *)send;
801093e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801093ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct arp_pkt *reply_arp = (struct arp_pkt *)(send + sizeof(struct eth_pkt));
801093ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801093f0:	83 c0 0e             	add    $0xe,%eax
801093f3:	89 45 f0             	mov    %eax,-0x10(%ebp)

  reply_eth->type[0] = 0x08;
801093f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093f9:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  reply_eth->type[1] = 0x06;
801093fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109400:	c6 40 0d 06          	movb   $0x6,0xd(%eax)
  memmove(reply_eth->dst_mac,arp_recv->src_mac,6);
80109404:	8b 45 08             	mov    0x8(%ebp),%eax
80109407:	8d 50 08             	lea    0x8(%eax),%edx
8010940a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010940d:	83 ec 04             	sub    $0x4,%esp
80109410:	6a 06                	push   $0x6
80109412:	52                   	push   %edx
80109413:	50                   	push   %eax
80109414:	e8 89 b8 ff ff       	call   80104ca2 <memmove>
80109419:	83 c4 10             	add    $0x10,%esp
  memmove(reply_eth->src_mac,mac_addr,6);
8010941c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010941f:	83 c0 06             	add    $0x6,%eax
80109422:	83 ec 04             	sub    $0x4,%esp
80109425:	6a 06                	push   $0x6
80109427:	68 80 6e 19 80       	push   $0x80196e80
8010942c:	50                   	push   %eax
8010942d:	e8 70 b8 ff ff       	call   80104ca2 <memmove>
80109432:	83 c4 10             	add    $0x10,%esp

  reply_arp->hrd_type = ARP_HARDWARE_TYPE;
80109435:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109438:	66 c7 00 00 01       	movw   $0x100,(%eax)
  reply_arp->pro_type = ARP_PROTOCOL_TYPE;
8010943d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109440:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  reply_arp->hrd_len = 6;
80109446:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109449:	c6 40 04 06          	movb   $0x6,0x4(%eax)
  reply_arp->pro_len = 4;
8010944d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109450:	c6 40 05 04          	movb   $0x4,0x5(%eax)
  reply_arp->op = ARP_OPS_REPLY;
80109454:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109457:	66 c7 40 06 00 02    	movw   $0x200,0x6(%eax)
  memmove(reply_arp->dst_mac,arp_recv->src_mac,6);
8010945d:	8b 45 08             	mov    0x8(%ebp),%eax
80109460:	8d 50 08             	lea    0x8(%eax),%edx
80109463:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109466:	83 c0 12             	add    $0x12,%eax
80109469:	83 ec 04             	sub    $0x4,%esp
8010946c:	6a 06                	push   $0x6
8010946e:	52                   	push   %edx
8010946f:	50                   	push   %eax
80109470:	e8 2d b8 ff ff       	call   80104ca2 <memmove>
80109475:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->dst_ip,arp_recv->src_ip,4);
80109478:	8b 45 08             	mov    0x8(%ebp),%eax
8010947b:	8d 50 0e             	lea    0xe(%eax),%edx
8010947e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109481:	83 c0 18             	add    $0x18,%eax
80109484:	83 ec 04             	sub    $0x4,%esp
80109487:	6a 04                	push   $0x4
80109489:	52                   	push   %edx
8010948a:	50                   	push   %eax
8010948b:	e8 12 b8 ff ff       	call   80104ca2 <memmove>
80109490:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_mac,mac_addr,6);
80109493:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109496:	83 c0 08             	add    $0x8,%eax
80109499:	83 ec 04             	sub    $0x4,%esp
8010949c:	6a 06                	push   $0x6
8010949e:	68 80 6e 19 80       	push   $0x80196e80
801094a3:	50                   	push   %eax
801094a4:	e8 f9 b7 ff ff       	call   80104ca2 <memmove>
801094a9:	83 c4 10             	add    $0x10,%esp
  memmove(reply_arp->src_ip,my_ip,4);
801094ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094af:	83 c0 0e             	add    $0xe,%eax
801094b2:	83 ec 04             	sub    $0x4,%esp
801094b5:	6a 04                	push   $0x4
801094b7:	68 04 f5 10 80       	push   $0x8010f504
801094bc:	50                   	push   %eax
801094bd:	e8 e0 b7 ff ff       	call   80104ca2 <memmove>
801094c2:	83 c4 10             	add    $0x10,%esp
}
801094c5:	90                   	nop
801094c6:	c9                   	leave
801094c7:	c3                   	ret

801094c8 <print_arp_info>:

void print_arp_info(struct arp_pkt* arp_p){
801094c8:	55                   	push   %ebp
801094c9:	89 e5                	mov    %esp,%ebp
801094cb:	83 ec 08             	sub    $0x8,%esp
  cprintf("--------Source-------\n");
801094ce:	83 ec 0c             	sub    $0xc,%esp
801094d1:	68 c2 c1 10 80       	push   $0x8010c1c2
801094d6:	e8 19 6f ff ff       	call   801003f4 <cprintf>
801094db:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->src_ip);
801094de:	8b 45 08             	mov    0x8(%ebp),%eax
801094e1:	83 c0 0e             	add    $0xe,%eax
801094e4:	83 ec 0c             	sub    $0xc,%esp
801094e7:	50                   	push   %eax
801094e8:	e8 e8 00 00 00       	call   801095d5 <print_ipv4>
801094ed:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801094f0:	83 ec 0c             	sub    $0xc,%esp
801094f3:	68 c0 c1 10 80       	push   $0x8010c1c0
801094f8:	e8 f7 6e ff ff       	call   801003f4 <cprintf>
801094fd:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->src_mac);
80109500:	8b 45 08             	mov    0x8(%ebp),%eax
80109503:	83 c0 08             	add    $0x8,%eax
80109506:	83 ec 0c             	sub    $0xc,%esp
80109509:	50                   	push   %eax
8010950a:	e8 14 01 00 00       	call   80109623 <print_mac>
8010950f:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109512:	83 ec 0c             	sub    $0xc,%esp
80109515:	68 c0 c1 10 80       	push   $0x8010c1c0
8010951a:	e8 d5 6e ff ff       	call   801003f4 <cprintf>
8010951f:	83 c4 10             	add    $0x10,%esp
  cprintf("-----Destination-----\n");
80109522:	83 ec 0c             	sub    $0xc,%esp
80109525:	68 d9 c1 10 80       	push   $0x8010c1d9
8010952a:	e8 c5 6e ff ff       	call   801003f4 <cprintf>
8010952f:	83 c4 10             	add    $0x10,%esp
  print_ipv4(arp_p->dst_ip);
80109532:	8b 45 08             	mov    0x8(%ebp),%eax
80109535:	83 c0 18             	add    $0x18,%eax
80109538:	83 ec 0c             	sub    $0xc,%esp
8010953b:	50                   	push   %eax
8010953c:	e8 94 00 00 00       	call   801095d5 <print_ipv4>
80109541:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109544:	83 ec 0c             	sub    $0xc,%esp
80109547:	68 c0 c1 10 80       	push   $0x8010c1c0
8010954c:	e8 a3 6e ff ff       	call   801003f4 <cprintf>
80109551:	83 c4 10             	add    $0x10,%esp
  print_mac(arp_p->dst_mac);
80109554:	8b 45 08             	mov    0x8(%ebp),%eax
80109557:	83 c0 12             	add    $0x12,%eax
8010955a:	83 ec 0c             	sub    $0xc,%esp
8010955d:	50                   	push   %eax
8010955e:	e8 c0 00 00 00       	call   80109623 <print_mac>
80109563:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80109566:	83 ec 0c             	sub    $0xc,%esp
80109569:	68 c0 c1 10 80       	push   $0x8010c1c0
8010956e:	e8 81 6e ff ff       	call   801003f4 <cprintf>
80109573:	83 c4 10             	add    $0x10,%esp
  cprintf("Operation: ");
80109576:	83 ec 0c             	sub    $0xc,%esp
80109579:	68 f0 c1 10 80       	push   $0x8010c1f0
8010957e:	e8 71 6e ff ff       	call   801003f4 <cprintf>
80109583:	83 c4 10             	add    $0x10,%esp
  if(arp_p->op == ARP_OPS_REQUEST) cprintf("Request\n");
80109586:	8b 45 08             	mov    0x8(%ebp),%eax
80109589:	0f b7 40 06          	movzwl 0x6(%eax),%eax
8010958d:	66 3d 00 01          	cmp    $0x100,%ax
80109591:	75 12                	jne    801095a5 <print_arp_info+0xdd>
80109593:	83 ec 0c             	sub    $0xc,%esp
80109596:	68 fc c1 10 80       	push   $0x8010c1fc
8010959b:	e8 54 6e ff ff       	call   801003f4 <cprintf>
801095a0:	83 c4 10             	add    $0x10,%esp
801095a3:	eb 1d                	jmp    801095c2 <print_arp_info+0xfa>
  else if(arp_p->op == ARP_OPS_REPLY) {
801095a5:	8b 45 08             	mov    0x8(%ebp),%eax
801095a8:	0f b7 40 06          	movzwl 0x6(%eax),%eax
801095ac:	66 3d 00 02          	cmp    $0x200,%ax
801095b0:	75 10                	jne    801095c2 <print_arp_info+0xfa>
    cprintf("Reply\n");
801095b2:	83 ec 0c             	sub    $0xc,%esp
801095b5:	68 05 c2 10 80       	push   $0x8010c205
801095ba:	e8 35 6e ff ff       	call   801003f4 <cprintf>
801095bf:	83 c4 10             	add    $0x10,%esp
  }
  cprintf("\n");
801095c2:	83 ec 0c             	sub    $0xc,%esp
801095c5:	68 c0 c1 10 80       	push   $0x8010c1c0
801095ca:	e8 25 6e ff ff       	call   801003f4 <cprintf>
801095cf:	83 c4 10             	add    $0x10,%esp
}
801095d2:	90                   	nop
801095d3:	c9                   	leave
801095d4:	c3                   	ret

801095d5 <print_ipv4>:

void print_ipv4(uchar *ip){
801095d5:	55                   	push   %ebp
801095d6:	89 e5                	mov    %esp,%ebp
801095d8:	53                   	push   %ebx
801095d9:	83 ec 04             	sub    $0x4,%esp
  cprintf("IP address: %d.%d.%d.%d",ip[0],ip[1],ip[2],ip[3]);
801095dc:	8b 45 08             	mov    0x8(%ebp),%eax
801095df:	83 c0 03             	add    $0x3,%eax
801095e2:	0f b6 00             	movzbl (%eax),%eax
801095e5:	0f b6 d8             	movzbl %al,%ebx
801095e8:	8b 45 08             	mov    0x8(%ebp),%eax
801095eb:	83 c0 02             	add    $0x2,%eax
801095ee:	0f b6 00             	movzbl (%eax),%eax
801095f1:	0f b6 c8             	movzbl %al,%ecx
801095f4:	8b 45 08             	mov    0x8(%ebp),%eax
801095f7:	83 c0 01             	add    $0x1,%eax
801095fa:	0f b6 00             	movzbl (%eax),%eax
801095fd:	0f b6 d0             	movzbl %al,%edx
80109600:	8b 45 08             	mov    0x8(%ebp),%eax
80109603:	0f b6 00             	movzbl (%eax),%eax
80109606:	0f b6 c0             	movzbl %al,%eax
80109609:	83 ec 0c             	sub    $0xc,%esp
8010960c:	53                   	push   %ebx
8010960d:	51                   	push   %ecx
8010960e:	52                   	push   %edx
8010960f:	50                   	push   %eax
80109610:	68 0c c2 10 80       	push   $0x8010c20c
80109615:	e8 da 6d ff ff       	call   801003f4 <cprintf>
8010961a:	83 c4 20             	add    $0x20,%esp
}
8010961d:	90                   	nop
8010961e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109621:	c9                   	leave
80109622:	c3                   	ret

80109623 <print_mac>:

void print_mac(uchar *mac){
80109623:	55                   	push   %ebp
80109624:	89 e5                	mov    %esp,%ebp
80109626:	57                   	push   %edi
80109627:	56                   	push   %esi
80109628:	53                   	push   %ebx
80109629:	83 ec 0c             	sub    $0xc,%esp
  cprintf("MAC address: %x:%x:%x:%x:%x:%x",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
8010962c:	8b 45 08             	mov    0x8(%ebp),%eax
8010962f:	83 c0 05             	add    $0x5,%eax
80109632:	0f b6 00             	movzbl (%eax),%eax
80109635:	0f b6 f8             	movzbl %al,%edi
80109638:	8b 45 08             	mov    0x8(%ebp),%eax
8010963b:	83 c0 04             	add    $0x4,%eax
8010963e:	0f b6 00             	movzbl (%eax),%eax
80109641:	0f b6 f0             	movzbl %al,%esi
80109644:	8b 45 08             	mov    0x8(%ebp),%eax
80109647:	83 c0 03             	add    $0x3,%eax
8010964a:	0f b6 00             	movzbl (%eax),%eax
8010964d:	0f b6 d8             	movzbl %al,%ebx
80109650:	8b 45 08             	mov    0x8(%ebp),%eax
80109653:	83 c0 02             	add    $0x2,%eax
80109656:	0f b6 00             	movzbl (%eax),%eax
80109659:	0f b6 c8             	movzbl %al,%ecx
8010965c:	8b 45 08             	mov    0x8(%ebp),%eax
8010965f:	83 c0 01             	add    $0x1,%eax
80109662:	0f b6 00             	movzbl (%eax),%eax
80109665:	0f b6 d0             	movzbl %al,%edx
80109668:	8b 45 08             	mov    0x8(%ebp),%eax
8010966b:	0f b6 00             	movzbl (%eax),%eax
8010966e:	0f b6 c0             	movzbl %al,%eax
80109671:	83 ec 04             	sub    $0x4,%esp
80109674:	57                   	push   %edi
80109675:	56                   	push   %esi
80109676:	53                   	push   %ebx
80109677:	51                   	push   %ecx
80109678:	52                   	push   %edx
80109679:	50                   	push   %eax
8010967a:	68 24 c2 10 80       	push   $0x8010c224
8010967f:	e8 70 6d ff ff       	call   801003f4 <cprintf>
80109684:	83 c4 20             	add    $0x20,%esp
}
80109687:	90                   	nop
80109688:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010968b:	5b                   	pop    %ebx
8010968c:	5e                   	pop    %esi
8010968d:	5f                   	pop    %edi
8010968e:	5d                   	pop    %ebp
8010968f:	c3                   	ret

80109690 <eth_proc>:
#include "arp.h"
#include "types.h"
#include "eth.h"
#include "defs.h"
#include "ipv4.h"
void eth_proc(uint buffer_addr){
80109690:	55                   	push   %ebp
80109691:	89 e5                	mov    %esp,%ebp
80109693:	83 ec 18             	sub    $0x18,%esp
  struct eth_pkt *eth_pkt = (struct eth_pkt *)buffer_addr;
80109696:	8b 45 08             	mov    0x8(%ebp),%eax
80109699:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint pkt_addr = buffer_addr+sizeof(struct eth_pkt);
8010969c:	8b 45 08             	mov    0x8(%ebp),%eax
8010969f:	83 c0 0e             	add    $0xe,%eax
801096a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x06){
801096a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096a8:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801096ac:	3c 08                	cmp    $0x8,%al
801096ae:	75 1b                	jne    801096cb <eth_proc+0x3b>
801096b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096b3:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
801096b7:	3c 06                	cmp    $0x6,%al
801096b9:	75 10                	jne    801096cb <eth_proc+0x3b>
    arp_proc(pkt_addr);
801096bb:	83 ec 0c             	sub    $0xc,%esp
801096be:	ff 75 f0             	push   -0x10(%ebp)
801096c1:	e8 01 f8 ff ff       	call   80108ec7 <arp_proc>
801096c6:	83 c4 10             	add    $0x10,%esp
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
    ipv4_proc(buffer_addr);
  }else{
  }
}
801096c9:	eb 24                	jmp    801096ef <eth_proc+0x5f>
  }else if(eth_pkt->type[0] == 0x08 && eth_pkt->type[1] == 0x00){
801096cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096ce:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801096d2:	3c 08                	cmp    $0x8,%al
801096d4:	75 19                	jne    801096ef <eth_proc+0x5f>
801096d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096d9:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
801096dd:	84 c0                	test   %al,%al
801096df:	75 0e                	jne    801096ef <eth_proc+0x5f>
    ipv4_proc(buffer_addr);
801096e1:	83 ec 0c             	sub    $0xc,%esp
801096e4:	ff 75 08             	push   0x8(%ebp)
801096e7:	e8 8d 00 00 00       	call   80109779 <ipv4_proc>
801096ec:	83 c4 10             	add    $0x10,%esp
}
801096ef:	90                   	nop
801096f0:	c9                   	leave
801096f1:	c3                   	ret

801096f2 <N2H_ushort>:

ushort N2H_ushort(ushort value){
801096f2:	55                   	push   %ebp
801096f3:	89 e5                	mov    %esp,%ebp
801096f5:	83 ec 04             	sub    $0x4,%esp
801096f8:	8b 45 08             	mov    0x8(%ebp),%eax
801096fb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
801096ff:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109703:	66 c1 c0 08          	rol    $0x8,%ax
}
80109707:	c9                   	leave
80109708:	c3                   	ret

80109709 <H2N_ushort>:

ushort H2N_ushort(ushort value){
80109709:	55                   	push   %ebp
8010970a:	89 e5                	mov    %esp,%ebp
8010970c:	83 ec 04             	sub    $0x4,%esp
8010970f:	8b 45 08             	mov    0x8(%ebp),%eax
80109712:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  return (((value)&0xFF)<<8)+(value>>8);
80109716:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010971a:	66 c1 c0 08          	rol    $0x8,%ax
}
8010971e:	c9                   	leave
8010971f:	c3                   	ret

80109720 <H2N_uint>:

uint H2N_uint(uint value){
80109720:	55                   	push   %ebp
80109721:	89 e5                	mov    %esp,%ebp
  return ((value&0xF)<<24)+((value&0xF0)<<8)+((value&0xF00)>>8)+((value&0xF000)>>24);
80109723:	8b 45 08             	mov    0x8(%ebp),%eax
80109726:	c1 e0 18             	shl    $0x18,%eax
80109729:	25 00 00 00 0f       	and    $0xf000000,%eax
8010972e:	89 c2                	mov    %eax,%edx
80109730:	8b 45 08             	mov    0x8(%ebp),%eax
80109733:	c1 e0 08             	shl    $0x8,%eax
80109736:	25 00 f0 00 00       	and    $0xf000,%eax
8010973b:	09 c2                	or     %eax,%edx
8010973d:	8b 45 08             	mov    0x8(%ebp),%eax
80109740:	c1 e8 08             	shr    $0x8,%eax
80109743:	83 e0 0f             	and    $0xf,%eax
80109746:	01 d0                	add    %edx,%eax
}
80109748:	5d                   	pop    %ebp
80109749:	c3                   	ret

8010974a <N2H_uint>:

uint N2H_uint(uint value){
8010974a:	55                   	push   %ebp
8010974b:	89 e5                	mov    %esp,%ebp
  return ((value&0xFF)<<24)+((value&0xFF00)<<8)+((value&0xFF0000)>>8)+((value&0xFF000000)>>24);
8010974d:	8b 45 08             	mov    0x8(%ebp),%eax
80109750:	c1 e0 18             	shl    $0x18,%eax
80109753:	89 c2                	mov    %eax,%edx
80109755:	8b 45 08             	mov    0x8(%ebp),%eax
80109758:	c1 e0 08             	shl    $0x8,%eax
8010975b:	25 00 00 ff 00       	and    $0xff0000,%eax
80109760:	01 c2                	add    %eax,%edx
80109762:	8b 45 08             	mov    0x8(%ebp),%eax
80109765:	c1 e8 08             	shr    $0x8,%eax
80109768:	25 00 ff 00 00       	and    $0xff00,%eax
8010976d:	01 c2                	add    %eax,%edx
8010976f:	8b 45 08             	mov    0x8(%ebp),%eax
80109772:	c1 e8 18             	shr    $0x18,%eax
80109775:	01 d0                	add    %edx,%eax
}
80109777:	5d                   	pop    %ebp
80109778:	c3                   	ret

80109779 <ipv4_proc>:
extern uchar mac_addr[6];
extern uchar my_ip[4];

int ip_id = -1;
ushort send_id = 0;
void ipv4_proc(uint buffer_addr){
80109779:	55                   	push   %ebp
8010977a:	89 e5                	mov    %esp,%ebp
8010977c:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+14);
8010977f:	8b 45 08             	mov    0x8(%ebp),%eax
80109782:	83 c0 0e             	add    $0xe,%eax
80109785:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip_id != ipv4_p->id && memcmp(my_ip,ipv4_p->src_ip,4) != 0){
80109788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010978b:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010978f:	0f b7 d0             	movzwl %ax,%edx
80109792:	a1 08 f5 10 80       	mov    0x8010f508,%eax
80109797:	39 c2                	cmp    %eax,%edx
80109799:	74 60                	je     801097fb <ipv4_proc+0x82>
8010979b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010979e:	83 c0 0c             	add    $0xc,%eax
801097a1:	83 ec 04             	sub    $0x4,%esp
801097a4:	6a 04                	push   $0x4
801097a6:	50                   	push   %eax
801097a7:	68 04 f5 10 80       	push   $0x8010f504
801097ac:	e8 99 b4 ff ff       	call   80104c4a <memcmp>
801097b1:	83 c4 10             	add    $0x10,%esp
801097b4:	85 c0                	test   %eax,%eax
801097b6:	74 43                	je     801097fb <ipv4_proc+0x82>
    ip_id = ipv4_p->id;
801097b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097bb:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801097bf:	0f b7 c0             	movzwl %ax,%eax
801097c2:	a3 08 f5 10 80       	mov    %eax,0x8010f508
      if(ipv4_p->protocol == IPV4_TYPE_ICMP){
801097c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097ca:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801097ce:	3c 01                	cmp    $0x1,%al
801097d0:	75 10                	jne    801097e2 <ipv4_proc+0x69>
        icmp_proc(buffer_addr);
801097d2:	83 ec 0c             	sub    $0xc,%esp
801097d5:	ff 75 08             	push   0x8(%ebp)
801097d8:	e8 a3 00 00 00       	call   80109880 <icmp_proc>
801097dd:	83 c4 10             	add    $0x10,%esp
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
        tcp_proc(buffer_addr);
      }
  }
}
801097e0:	eb 19                	jmp    801097fb <ipv4_proc+0x82>
      }else if(ipv4_p->protocol == IPV4_TYPE_TCP){
801097e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097e5:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801097e9:	3c 06                	cmp    $0x6,%al
801097eb:	75 0e                	jne    801097fb <ipv4_proc+0x82>
        tcp_proc(buffer_addr);
801097ed:	83 ec 0c             	sub    $0xc,%esp
801097f0:	ff 75 08             	push   0x8(%ebp)
801097f3:	e8 b3 03 00 00       	call   80109bab <tcp_proc>
801097f8:	83 c4 10             	add    $0x10,%esp
}
801097fb:	90                   	nop
801097fc:	c9                   	leave
801097fd:	c3                   	ret

801097fe <ipv4_chksum>:

ushort ipv4_chksum(uint ipv4_addr){
801097fe:	55                   	push   %ebp
801097ff:	89 e5                	mov    %esp,%ebp
80109801:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)ipv4_addr;
80109804:	8b 45 08             	mov    0x8(%ebp),%eax
80109807:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uchar len = (bin[0]&0xF)*2;
8010980a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010980d:	0f b6 00             	movzbl (%eax),%eax
80109810:	83 e0 0f             	and    $0xf,%eax
80109813:	01 c0                	add    %eax,%eax
80109815:	88 45 f3             	mov    %al,-0xd(%ebp)
  uint chk_sum = 0;
80109818:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<len;i++){
8010981f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109826:	eb 48                	jmp    80109870 <ipv4_chksum+0x72>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109828:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010982b:	01 c0                	add    %eax,%eax
8010982d:	89 c2                	mov    %eax,%edx
8010982f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109832:	01 d0                	add    %edx,%eax
80109834:	0f b6 00             	movzbl (%eax),%eax
80109837:	0f b6 c0             	movzbl %al,%eax
8010983a:	c1 e0 08             	shl    $0x8,%eax
8010983d:	89 c2                	mov    %eax,%edx
8010983f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109842:	01 c0                	add    %eax,%eax
80109844:	8d 48 01             	lea    0x1(%eax),%ecx
80109847:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010984a:	01 c8                	add    %ecx,%eax
8010984c:	0f b6 00             	movzbl (%eax),%eax
8010984f:	0f b6 c0             	movzbl %al,%eax
80109852:	01 d0                	add    %edx,%eax
80109854:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109857:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
8010985e:	76 0c                	jbe    8010986c <ipv4_chksum+0x6e>
      chk_sum = (chk_sum&0xFFFF)+1;
80109860:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109863:	0f b7 c0             	movzwl %ax,%eax
80109866:	83 c0 01             	add    $0x1,%eax
80109869:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<len;i++){
8010986c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109870:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
80109874:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80109877:	7c af                	jl     80109828 <ipv4_chksum+0x2a>
    }
  }
  return ~(chk_sum);
80109879:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010987c:	f7 d0                	not    %eax
}
8010987e:	c9                   	leave
8010987f:	c3                   	ret

80109880 <icmp_proc>:
#include "eth.h"

extern uchar mac_addr[6];
extern uchar my_ip[4];
extern ushort send_id;
void icmp_proc(uint buffer_addr){
80109880:	55                   	push   %ebp
80109881:	89 e5                	mov    %esp,%ebp
80109883:	83 ec 18             	sub    $0x18,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr+sizeof(struct eth_pkt));
80109886:	8b 45 08             	mov    0x8(%ebp),%eax
80109889:	83 c0 0e             	add    $0xe,%eax
8010988c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct icmp_echo_pkt *icmp_p = (struct icmp_echo_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
8010988f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109892:	0f b6 00             	movzbl (%eax),%eax
80109895:	0f b6 c0             	movzbl %al,%eax
80109898:	83 e0 0f             	and    $0xf,%eax
8010989b:	c1 e0 02             	shl    $0x2,%eax
8010989e:	89 c2                	mov    %eax,%edx
801098a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098a3:	01 d0                	add    %edx,%eax
801098a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(icmp_p->code == 0){
801098a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098ab:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801098af:	84 c0                	test   %al,%al
801098b1:	75 4f                	jne    80109902 <icmp_proc+0x82>
    if(icmp_p->type == ICMP_TYPE_ECHO_REQUEST){
801098b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098b6:	0f b6 00             	movzbl (%eax),%eax
801098b9:	3c 08                	cmp    $0x8,%al
801098bb:	75 45                	jne    80109902 <icmp_proc+0x82>
      uint send_addr = (uint)kalloc();
801098bd:	e8 e6 8e ff ff       	call   801027a8 <kalloc>
801098c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
      uint send_size = 0;
801098c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      icmp_reply_pkt_create(buffer_addr,send_addr,&send_size);
801098cc:	83 ec 04             	sub    $0x4,%esp
801098cf:	8d 45 e8             	lea    -0x18(%ebp),%eax
801098d2:	50                   	push   %eax
801098d3:	ff 75 ec             	push   -0x14(%ebp)
801098d6:	ff 75 08             	push   0x8(%ebp)
801098d9:	e8 78 00 00 00       	call   80109956 <icmp_reply_pkt_create>
801098de:	83 c4 10             	add    $0x10,%esp
      i8254_send(send_addr,send_size);
801098e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801098e4:	83 ec 08             	sub    $0x8,%esp
801098e7:	50                   	push   %eax
801098e8:	ff 75 ec             	push   -0x14(%ebp)
801098eb:	e8 ad f4 ff ff       	call   80108d9d <i8254_send>
801098f0:	83 c4 10             	add    $0x10,%esp
      kfree((char *)send_addr);
801098f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801098f6:	83 ec 0c             	sub    $0xc,%esp
801098f9:	50                   	push   %eax
801098fa:	e8 0f 8e ff ff       	call   8010270e <kfree>
801098ff:	83 c4 10             	add    $0x10,%esp
    }
  }
}
80109902:	90                   	nop
80109903:	c9                   	leave
80109904:	c3                   	ret

80109905 <icmp_proc_req>:

void icmp_proc_req(struct icmp_echo_pkt * icmp_p){
80109905:	55                   	push   %ebp
80109906:	89 e5                	mov    %esp,%ebp
80109908:	53                   	push   %ebx
80109909:	83 ec 04             	sub    $0x4,%esp
  cprintf("ICMP ID:0x%x SEQ NUM:0x%x\n",N2H_ushort(icmp_p->id),N2H_ushort(icmp_p->seq_num));
8010990c:	8b 45 08             	mov    0x8(%ebp),%eax
8010990f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
80109913:	0f b7 c0             	movzwl %ax,%eax
80109916:	83 ec 0c             	sub    $0xc,%esp
80109919:	50                   	push   %eax
8010991a:	e8 d3 fd ff ff       	call   801096f2 <N2H_ushort>
8010991f:	83 c4 10             	add    $0x10,%esp
80109922:	0f b7 d8             	movzwl %ax,%ebx
80109925:	8b 45 08             	mov    0x8(%ebp),%eax
80109928:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010992c:	0f b7 c0             	movzwl %ax,%eax
8010992f:	83 ec 0c             	sub    $0xc,%esp
80109932:	50                   	push   %eax
80109933:	e8 ba fd ff ff       	call   801096f2 <N2H_ushort>
80109938:	83 c4 10             	add    $0x10,%esp
8010993b:	0f b7 c0             	movzwl %ax,%eax
8010993e:	83 ec 04             	sub    $0x4,%esp
80109941:	53                   	push   %ebx
80109942:	50                   	push   %eax
80109943:	68 43 c2 10 80       	push   $0x8010c243
80109948:	e8 a7 6a ff ff       	call   801003f4 <cprintf>
8010994d:	83 c4 10             	add    $0x10,%esp
}
80109950:	90                   	nop
80109951:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109954:	c9                   	leave
80109955:	c3                   	ret

80109956 <icmp_reply_pkt_create>:

void icmp_reply_pkt_create(uint recv_addr,uint send_addr,uint *send_size){
80109956:	55                   	push   %ebp
80109957:	89 e5                	mov    %esp,%ebp
80109959:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
8010995c:	8b 45 08             	mov    0x8(%ebp),%eax
8010995f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109962:	8b 45 08             	mov    0x8(%ebp),%eax
80109965:	83 c0 0e             	add    $0xe,%eax
80109968:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct icmp_echo_pkt *icmp_recv = (struct icmp_echo_pkt *)((uint)ipv4_recv+(ipv4_recv->ver&0xF)*4);
8010996b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010996e:	0f b6 00             	movzbl (%eax),%eax
80109971:	0f b6 c0             	movzbl %al,%eax
80109974:	83 e0 0f             	and    $0xf,%eax
80109977:	c1 e0 02             	shl    $0x2,%eax
8010997a:	89 c2                	mov    %eax,%edx
8010997c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010997f:	01 d0                	add    %edx,%eax
80109981:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109984:	8b 45 0c             	mov    0xc(%ebp),%eax
80109987:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr+sizeof(struct eth_pkt));
8010998a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010998d:	83 c0 0e             	add    $0xe,%eax
80109990:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct icmp_echo_pkt *icmp_send = (struct icmp_echo_pkt *)((uint)ipv4_send+sizeof(struct ipv4_pkt));
80109993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109996:	83 c0 14             	add    $0x14,%eax
80109999:	89 45 e0             	mov    %eax,-0x20(%ebp)
  
  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt);
8010999c:	8b 45 10             	mov    0x10(%ebp),%eax
8010999f:	c7 00 62 00 00 00    	movl   $0x62,(%eax)
  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
801099a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099a8:	8d 50 06             	lea    0x6(%eax),%edx
801099ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099ae:	83 ec 04             	sub    $0x4,%esp
801099b1:	6a 06                	push   $0x6
801099b3:	52                   	push   %edx
801099b4:	50                   	push   %eax
801099b5:	e8 e8 b2 ff ff       	call   80104ca2 <memmove>
801099ba:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
801099bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099c0:	83 c0 06             	add    $0x6,%eax
801099c3:	83 ec 04             	sub    $0x4,%esp
801099c6:	6a 06                	push   $0x6
801099c8:	68 80 6e 19 80       	push   $0x80196e80
801099cd:	50                   	push   %eax
801099ce:	e8 cf b2 ff ff       	call   80104ca2 <memmove>
801099d3:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
801099d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099d9:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
801099dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801099e0:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
801099e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099e7:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
801099ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801099ed:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct icmp_echo_pkt));
801099f1:	83 ec 0c             	sub    $0xc,%esp
801099f4:	6a 54                	push   $0x54
801099f6:	e8 0e fd ff ff       	call   80109709 <H2N_ushort>
801099fb:	83 c4 10             	add    $0x10,%esp
801099fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109a01:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109a05:	0f b7 15 60 71 19 80 	movzwl 0x80197160,%edx
80109a0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a0f:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109a13:	0f b7 05 60 71 19 80 	movzwl 0x80197160,%eax
80109a1a:	83 c0 01             	add    $0x1,%eax
80109a1d:	66 a3 60 71 19 80    	mov    %ax,0x80197160
  ipv4_send->fragment = H2N_ushort(0x4000);
80109a23:	83 ec 0c             	sub    $0xc,%esp
80109a26:	68 00 40 00 00       	push   $0x4000
80109a2b:	e8 d9 fc ff ff       	call   80109709 <H2N_ushort>
80109a30:	83 c4 10             	add    $0x10,%esp
80109a33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109a36:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109a3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a3d:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = 0x1;
80109a41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a44:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a4b:	83 c0 0c             	add    $0xc,%eax
80109a4e:	83 ec 04             	sub    $0x4,%esp
80109a51:	6a 04                	push   $0x4
80109a53:	68 04 f5 10 80       	push   $0x8010f504
80109a58:	50                   	push   %eax
80109a59:	e8 44 b2 ff ff       	call   80104ca2 <memmove>
80109a5e:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a64:	8d 50 0c             	lea    0xc(%eax),%edx
80109a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a6a:	83 c0 10             	add    $0x10,%eax
80109a6d:	83 ec 04             	sub    $0x4,%esp
80109a70:	6a 04                	push   $0x4
80109a72:	52                   	push   %edx
80109a73:	50                   	push   %eax
80109a74:	e8 29 b2 ff ff       	call   80104ca2 <memmove>
80109a79:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109a7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a7f:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109a85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109a88:	83 ec 0c             	sub    $0xc,%esp
80109a8b:	50                   	push   %eax
80109a8c:	e8 6d fd ff ff       	call   801097fe <ipv4_chksum>
80109a91:	83 c4 10             	add    $0x10,%esp
80109a94:	0f b7 c0             	movzwl %ax,%eax
80109a97:	83 ec 0c             	sub    $0xc,%esp
80109a9a:	50                   	push   %eax
80109a9b:	e8 69 fc ff ff       	call   80109709 <H2N_ushort>
80109aa0:	83 c4 10             	add    $0x10,%esp
80109aa3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109aa6:	66 89 42 0a          	mov    %ax,0xa(%edx)

  icmp_send->type = ICMP_TYPE_ECHO_REPLY;
80109aaa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109aad:	c6 00 00             	movb   $0x0,(%eax)
  icmp_send->code = 0;
80109ab0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ab3:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  icmp_send->id = icmp_recv->id;
80109ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109aba:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80109abe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109ac1:	66 89 50 04          	mov    %dx,0x4(%eax)
  icmp_send->seq_num = icmp_recv->seq_num;
80109ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ac8:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80109acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109acf:	66 89 50 06          	mov    %dx,0x6(%eax)
  memmove(icmp_send->time_stamp,icmp_recv->time_stamp,8);
80109ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ad6:	8d 50 08             	lea    0x8(%eax),%edx
80109ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109adc:	83 c0 08             	add    $0x8,%eax
80109adf:	83 ec 04             	sub    $0x4,%esp
80109ae2:	6a 08                	push   $0x8
80109ae4:	52                   	push   %edx
80109ae5:	50                   	push   %eax
80109ae6:	e8 b7 b1 ff ff       	call   80104ca2 <memmove>
80109aeb:	83 c4 10             	add    $0x10,%esp
  memmove(icmp_send->data,icmp_recv->data,48);
80109aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109af1:	8d 50 10             	lea    0x10(%eax),%edx
80109af4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109af7:	83 c0 10             	add    $0x10,%eax
80109afa:	83 ec 04             	sub    $0x4,%esp
80109afd:	6a 30                	push   $0x30
80109aff:	52                   	push   %edx
80109b00:	50                   	push   %eax
80109b01:	e8 9c b1 ff ff       	call   80104ca2 <memmove>
80109b06:	83 c4 10             	add    $0x10,%esp
  icmp_send->chk_sum = 0;
80109b09:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109b0c:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
  icmp_send->chk_sum = H2N_ushort(icmp_chksum((uint)icmp_send));
80109b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109b15:	83 ec 0c             	sub    $0xc,%esp
80109b18:	50                   	push   %eax
80109b19:	e8 1c 00 00 00       	call   80109b3a <icmp_chksum>
80109b1e:	83 c4 10             	add    $0x10,%esp
80109b21:	0f b7 c0             	movzwl %ax,%eax
80109b24:	83 ec 0c             	sub    $0xc,%esp
80109b27:	50                   	push   %eax
80109b28:	e8 dc fb ff ff       	call   80109709 <H2N_ushort>
80109b2d:	83 c4 10             	add    $0x10,%esp
80109b30:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109b33:	66 89 42 02          	mov    %ax,0x2(%edx)
}
80109b37:	90                   	nop
80109b38:	c9                   	leave
80109b39:	c3                   	ret

80109b3a <icmp_chksum>:

ushort icmp_chksum(uint icmp_addr){
80109b3a:	55                   	push   %ebp
80109b3b:	89 e5                	mov    %esp,%ebp
80109b3d:	83 ec 10             	sub    $0x10,%esp
  uchar* bin = (uchar *)icmp_addr;
80109b40:	8b 45 08             	mov    0x8(%ebp),%eax
80109b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  uint chk_sum = 0;
80109b46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109b4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80109b54:	eb 48                	jmp    80109b9e <icmp_chksum+0x64>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
80109b56:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109b59:	01 c0                	add    %eax,%eax
80109b5b:	89 c2                	mov    %eax,%edx
80109b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b60:	01 d0                	add    %edx,%eax
80109b62:	0f b6 00             	movzbl (%eax),%eax
80109b65:	0f b6 c0             	movzbl %al,%eax
80109b68:	c1 e0 08             	shl    $0x8,%eax
80109b6b:	89 c2                	mov    %eax,%edx
80109b6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80109b70:	01 c0                	add    %eax,%eax
80109b72:	8d 48 01             	lea    0x1(%eax),%ecx
80109b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b78:	01 c8                	add    %ecx,%eax
80109b7a:	0f b6 00             	movzbl (%eax),%eax
80109b7d:	0f b6 c0             	movzbl %al,%eax
80109b80:	01 d0                	add    %edx,%eax
80109b82:	01 45 fc             	add    %eax,-0x4(%ebp)
    if(chk_sum > 0xFFFF){
80109b85:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%ebp)
80109b8c:	76 0c                	jbe    80109b9a <icmp_chksum+0x60>
      chk_sum = (chk_sum&0xFFFF)+1;
80109b8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109b91:	0f b7 c0             	movzwl %ax,%eax
80109b94:	83 c0 01             	add    $0x1,%eax
80109b97:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(int i=0;i<32;i++){
80109b9a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80109b9e:	83 7d f8 1f          	cmpl   $0x1f,-0x8(%ebp)
80109ba2:	7e b2                	jle    80109b56 <icmp_chksum+0x1c>
    }
  }
  return ~(chk_sum);
80109ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80109ba7:	f7 d0                	not    %eax
}
80109ba9:	c9                   	leave
80109baa:	c3                   	ret

80109bab <tcp_proc>:
extern ushort send_id;
extern uchar mac_addr[6];
extern uchar my_ip[4];
int fin_flag = 0;

void tcp_proc(uint buffer_addr){
80109bab:	55                   	push   %ebp
80109bac:	89 e5                	mov    %esp,%ebp
80109bae:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(buffer_addr + sizeof(struct eth_pkt));
80109bb1:	8b 45 08             	mov    0x8(%ebp),%eax
80109bb4:	83 c0 0e             	add    $0xe,%eax
80109bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + (ipv4_p->ver&0xF)*4);
80109bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bbd:	0f b6 00             	movzbl (%eax),%eax
80109bc0:	0f b6 c0             	movzbl %al,%eax
80109bc3:	83 e0 0f             	and    $0xf,%eax
80109bc6:	c1 e0 02             	shl    $0x2,%eax
80109bc9:	89 c2                	mov    %eax,%edx
80109bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bce:	01 d0                	add    %edx,%eax
80109bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *payload = (char *)((uint)tcp_p + 20);
80109bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109bd6:	83 c0 14             	add    $0x14,%eax
80109bd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  uint send_addr = (uint)kalloc();
80109bdc:	e8 c7 8b ff ff       	call   801027a8 <kalloc>
80109be1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint send_size = 0;
80109be4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  if(tcp_p->code_bits[1]&TCP_CODEBITS_SYN){
80109beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109bee:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109bf2:	0f b6 c0             	movzbl %al,%eax
80109bf5:	83 e0 02             	and    $0x2,%eax
80109bf8:	85 c0                	test   %eax,%eax
80109bfa:	74 3d                	je     80109c39 <tcp_proc+0x8e>
    tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK | TCP_CODEBITS_SYN,0);
80109bfc:	83 ec 0c             	sub    $0xc,%esp
80109bff:	6a 00                	push   $0x0
80109c01:	6a 12                	push   $0x12
80109c03:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c06:	50                   	push   %eax
80109c07:	ff 75 e8             	push   -0x18(%ebp)
80109c0a:	ff 75 08             	push   0x8(%ebp)
80109c0d:	e8 a2 01 00 00       	call   80109db4 <tcp_pkt_create>
80109c12:	83 c4 20             	add    $0x20,%esp
    i8254_send(send_addr,send_size);
80109c15:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109c18:	83 ec 08             	sub    $0x8,%esp
80109c1b:	50                   	push   %eax
80109c1c:	ff 75 e8             	push   -0x18(%ebp)
80109c1f:	e8 79 f1 ff ff       	call   80108d9d <i8254_send>
80109c24:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109c27:	a1 64 71 19 80       	mov    0x80197164,%eax
80109c2c:	83 c0 01             	add    $0x1,%eax
80109c2f:	a3 64 71 19 80       	mov    %eax,0x80197164
80109c34:	e9 69 01 00 00       	jmp    80109da2 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == (TCP_CODEBITS_PSH | TCP_CODEBITS_ACK)){
80109c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c3c:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109c40:	3c 18                	cmp    $0x18,%al
80109c42:	0f 85 10 01 00 00    	jne    80109d58 <tcp_proc+0x1ad>
    if(memcmp(payload,"GET",3)){
80109c48:	83 ec 04             	sub    $0x4,%esp
80109c4b:	6a 03                	push   $0x3
80109c4d:	68 5e c2 10 80       	push   $0x8010c25e
80109c52:	ff 75 ec             	push   -0x14(%ebp)
80109c55:	e8 f0 af ff ff       	call   80104c4a <memcmp>
80109c5a:	83 c4 10             	add    $0x10,%esp
80109c5d:	85 c0                	test   %eax,%eax
80109c5f:	74 74                	je     80109cd5 <tcp_proc+0x12a>
      cprintf("ACK PSH\n");
80109c61:	83 ec 0c             	sub    $0xc,%esp
80109c64:	68 62 c2 10 80       	push   $0x8010c262
80109c69:	e8 86 67 ff ff       	call   801003f4 <cprintf>
80109c6e:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109c71:	83 ec 0c             	sub    $0xc,%esp
80109c74:	6a 00                	push   $0x0
80109c76:	6a 10                	push   $0x10
80109c78:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109c7b:	50                   	push   %eax
80109c7c:	ff 75 e8             	push   -0x18(%ebp)
80109c7f:	ff 75 08             	push   0x8(%ebp)
80109c82:	e8 2d 01 00 00       	call   80109db4 <tcp_pkt_create>
80109c87:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109c8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109c8d:	83 ec 08             	sub    $0x8,%esp
80109c90:	50                   	push   %eax
80109c91:	ff 75 e8             	push   -0x18(%ebp)
80109c94:	e8 04 f1 ff ff       	call   80108d9d <i8254_send>
80109c99:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109c9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109c9f:	83 c0 36             	add    $0x36,%eax
80109ca2:	89 45 e0             	mov    %eax,-0x20(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109ca5:	8d 45 d8             	lea    -0x28(%ebp),%eax
80109ca8:	50                   	push   %eax
80109ca9:	ff 75 e0             	push   -0x20(%ebp)
80109cac:	6a 00                	push   $0x0
80109cae:	6a 00                	push   $0x0
80109cb0:	e8 5a 04 00 00       	call   8010a10f <http_proc>
80109cb5:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109cb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109cbb:	83 ec 0c             	sub    $0xc,%esp
80109cbe:	50                   	push   %eax
80109cbf:	6a 18                	push   $0x18
80109cc1:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109cc4:	50                   	push   %eax
80109cc5:	ff 75 e8             	push   -0x18(%ebp)
80109cc8:	ff 75 08             	push   0x8(%ebp)
80109ccb:	e8 e4 00 00 00       	call   80109db4 <tcp_pkt_create>
80109cd0:	83 c4 20             	add    $0x20,%esp
80109cd3:	eb 62                	jmp    80109d37 <tcp_proc+0x18c>
    }else{
     tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_ACK,0);
80109cd5:	83 ec 0c             	sub    $0xc,%esp
80109cd8:	6a 00                	push   $0x0
80109cda:	6a 10                	push   $0x10
80109cdc:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109cdf:	50                   	push   %eax
80109ce0:	ff 75 e8             	push   -0x18(%ebp)
80109ce3:	ff 75 08             	push   0x8(%ebp)
80109ce6:	e8 c9 00 00 00       	call   80109db4 <tcp_pkt_create>
80109ceb:	83 c4 20             	add    $0x20,%esp
     i8254_send(send_addr,send_size);
80109cee:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109cf1:	83 ec 08             	sub    $0x8,%esp
80109cf4:	50                   	push   %eax
80109cf5:	ff 75 e8             	push   -0x18(%ebp)
80109cf8:	e8 a0 f0 ff ff       	call   80108d9d <i8254_send>
80109cfd:	83 c4 10             	add    $0x10,%esp
      uint send_payload = (send_addr + sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt));
80109d00:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d03:	83 c0 36             	add    $0x36,%eax
80109d06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      uint payload_size;
      http_proc(0,0,send_payload,&payload_size);
80109d09:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109d0c:	50                   	push   %eax
80109d0d:	ff 75 e4             	push   -0x1c(%ebp)
80109d10:	6a 00                	push   $0x0
80109d12:	6a 00                	push   $0x0
80109d14:	e8 f6 03 00 00       	call   8010a10f <http_proc>
80109d19:	83 c4 10             	add    $0x10,%esp
      tcp_pkt_create(buffer_addr,send_addr,&send_size,(TCP_CODEBITS_ACK|TCP_CODEBITS_PSH),payload_size);
80109d1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80109d1f:	83 ec 0c             	sub    $0xc,%esp
80109d22:	50                   	push   %eax
80109d23:	6a 18                	push   $0x18
80109d25:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109d28:	50                   	push   %eax
80109d29:	ff 75 e8             	push   -0x18(%ebp)
80109d2c:	ff 75 08             	push   0x8(%ebp)
80109d2f:	e8 80 00 00 00       	call   80109db4 <tcp_pkt_create>
80109d34:	83 c4 20             	add    $0x20,%esp
    }
    i8254_send(send_addr,send_size);
80109d37:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109d3a:	83 ec 08             	sub    $0x8,%esp
80109d3d:	50                   	push   %eax
80109d3e:	ff 75 e8             	push   -0x18(%ebp)
80109d41:	e8 57 f0 ff ff       	call   80108d9d <i8254_send>
80109d46:	83 c4 10             	add    $0x10,%esp
    seq_num++;
80109d49:	a1 64 71 19 80       	mov    0x80197164,%eax
80109d4e:	83 c0 01             	add    $0x1,%eax
80109d51:	a3 64 71 19 80       	mov    %eax,0x80197164
80109d56:	eb 4a                	jmp    80109da2 <tcp_proc+0x1f7>
  }else if(tcp_p->code_bits[1] == TCP_CODEBITS_ACK){
80109d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d5b:	0f b6 40 0d          	movzbl 0xd(%eax),%eax
80109d5f:	3c 10                	cmp    $0x10,%al
80109d61:	75 3f                	jne    80109da2 <tcp_proc+0x1f7>
    if(fin_flag == 1){
80109d63:	a1 68 71 19 80       	mov    0x80197168,%eax
80109d68:	83 f8 01             	cmp    $0x1,%eax
80109d6b:	75 35                	jne    80109da2 <tcp_proc+0x1f7>
      tcp_pkt_create(buffer_addr,send_addr,&send_size,TCP_CODEBITS_FIN,0);
80109d6d:	83 ec 0c             	sub    $0xc,%esp
80109d70:	6a 00                	push   $0x0
80109d72:	6a 01                	push   $0x1
80109d74:	8d 45 dc             	lea    -0x24(%ebp),%eax
80109d77:	50                   	push   %eax
80109d78:	ff 75 e8             	push   -0x18(%ebp)
80109d7b:	ff 75 08             	push   0x8(%ebp)
80109d7e:	e8 31 00 00 00       	call   80109db4 <tcp_pkt_create>
80109d83:	83 c4 20             	add    $0x20,%esp
      i8254_send(send_addr,send_size);
80109d86:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109d89:	83 ec 08             	sub    $0x8,%esp
80109d8c:	50                   	push   %eax
80109d8d:	ff 75 e8             	push   -0x18(%ebp)
80109d90:	e8 08 f0 ff ff       	call   80108d9d <i8254_send>
80109d95:	83 c4 10             	add    $0x10,%esp
      fin_flag = 0;
80109d98:	c7 05 68 71 19 80 00 	movl   $0x0,0x80197168
80109d9f:	00 00 00 
    }
  }
  kfree((char *)send_addr);
80109da2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109da5:	83 ec 0c             	sub    $0xc,%esp
80109da8:	50                   	push   %eax
80109da9:	e8 60 89 ff ff       	call   8010270e <kfree>
80109dae:	83 c4 10             	add    $0x10,%esp
}
80109db1:	90                   	nop
80109db2:	c9                   	leave
80109db3:	c3                   	ret

80109db4 <tcp_pkt_create>:

void tcp_pkt_create(uint recv_addr,uint send_addr,uint *send_size,uint pkt_type,uint payload_size){
80109db4:	55                   	push   %ebp
80109db5:	89 e5                	mov    %esp,%ebp
80109db7:	83 ec 28             	sub    $0x28,%esp
  struct eth_pkt *eth_recv = (struct eth_pkt *)(recv_addr);
80109dba:	8b 45 08             	mov    0x8(%ebp),%eax
80109dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct ipv4_pkt *ipv4_recv = (struct ipv4_pkt *)(recv_addr+sizeof(struct eth_pkt));
80109dc0:	8b 45 08             	mov    0x8(%ebp),%eax
80109dc3:	83 c0 0e             	add    $0xe,%eax
80109dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct tcp_pkt *tcp_recv = (struct tcp_pkt *)((uint)ipv4_recv + (ipv4_recv->ver&0xF)*4);
80109dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109dcc:	0f b6 00             	movzbl (%eax),%eax
80109dcf:	0f b6 c0             	movzbl %al,%eax
80109dd2:	83 e0 0f             	and    $0xf,%eax
80109dd5:	c1 e0 02             	shl    $0x2,%eax
80109dd8:	89 c2                	mov    %eax,%edx
80109dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109ddd:	01 d0                	add    %edx,%eax
80109ddf:	89 45 ec             	mov    %eax,-0x14(%ebp)

  struct eth_pkt *eth_send = (struct eth_pkt *)(send_addr);
80109de2:	8b 45 0c             	mov    0xc(%ebp),%eax
80109de5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct ipv4_pkt *ipv4_send = (struct ipv4_pkt *)(send_addr + sizeof(struct eth_pkt));
80109de8:	8b 45 0c             	mov    0xc(%ebp),%eax
80109deb:	83 c0 0e             	add    $0xe,%eax
80109dee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_pkt *tcp_send = (struct tcp_pkt *)((uint)ipv4_send + sizeof(struct ipv4_pkt));
80109df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109df4:	83 c0 14             	add    $0x14,%eax
80109df7:	89 45 e0             	mov    %eax,-0x20(%ebp)

  *send_size = sizeof(struct eth_pkt) + sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size;
80109dfa:	8b 45 18             	mov    0x18(%ebp),%eax
80109dfd:	8d 50 36             	lea    0x36(%eax),%edx
80109e00:	8b 45 10             	mov    0x10(%ebp),%eax
80109e03:	89 10                	mov    %edx,(%eax)

  memmove(eth_send->dst_mac,eth_recv->src_mac,6);
80109e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e08:	8d 50 06             	lea    0x6(%eax),%edx
80109e0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e0e:	83 ec 04             	sub    $0x4,%esp
80109e11:	6a 06                	push   $0x6
80109e13:	52                   	push   %edx
80109e14:	50                   	push   %eax
80109e15:	e8 88 ae ff ff       	call   80104ca2 <memmove>
80109e1a:	83 c4 10             	add    $0x10,%esp
  memmove(eth_send->src_mac,mac_addr,6);
80109e1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e20:	83 c0 06             	add    $0x6,%eax
80109e23:	83 ec 04             	sub    $0x4,%esp
80109e26:	6a 06                	push   $0x6
80109e28:	68 80 6e 19 80       	push   $0x80196e80
80109e2d:	50                   	push   %eax
80109e2e:	e8 6f ae ff ff       	call   80104ca2 <memmove>
80109e33:	83 c4 10             	add    $0x10,%esp
  eth_send->type[0] = 0x08;
80109e36:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e39:	c6 40 0c 08          	movb   $0x8,0xc(%eax)
  eth_send->type[1] = 0x00;
80109e3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109e40:	c6 40 0d 00          	movb   $0x0,0xd(%eax)

  ipv4_send->ver = ((0x4)<<4)+((sizeof(struct ipv4_pkt)/4)&0xF);
80109e44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e47:	c6 00 45             	movb   $0x45,(%eax)
  ipv4_send->srv_type = 0;
80109e4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e4d:	c6 40 01 00          	movb   $0x0,0x1(%eax)
  ipv4_send->total_len = H2N_ushort(sizeof(struct ipv4_pkt) + sizeof(struct tcp_pkt) + payload_size);
80109e51:	8b 45 18             	mov    0x18(%ebp),%eax
80109e54:	83 c0 28             	add    $0x28,%eax
80109e57:	0f b7 c0             	movzwl %ax,%eax
80109e5a:	83 ec 0c             	sub    $0xc,%esp
80109e5d:	50                   	push   %eax
80109e5e:	e8 a6 f8 ff ff       	call   80109709 <H2N_ushort>
80109e63:	83 c4 10             	add    $0x10,%esp
80109e66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e69:	66 89 42 02          	mov    %ax,0x2(%edx)
  ipv4_send->id = send_id;
80109e6d:	0f b7 15 60 71 19 80 	movzwl 0x80197160,%edx
80109e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109e77:	66 89 50 04          	mov    %dx,0x4(%eax)
  send_id++;
80109e7b:	0f b7 05 60 71 19 80 	movzwl 0x80197160,%eax
80109e82:	83 c0 01             	add    $0x1,%eax
80109e85:	66 a3 60 71 19 80    	mov    %ax,0x80197160
  ipv4_send->fragment = H2N_ushort(0x0000);
80109e8b:	83 ec 0c             	sub    $0xc,%esp
80109e8e:	6a 00                	push   $0x0
80109e90:	e8 74 f8 ff ff       	call   80109709 <H2N_ushort>
80109e95:	83 c4 10             	add    $0x10,%esp
80109e98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109e9b:	66 89 42 06          	mov    %ax,0x6(%edx)
  ipv4_send->ttl = 255;
80109e9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ea2:	c6 40 08 ff          	movb   $0xff,0x8(%eax)
  ipv4_send->protocol = IPV4_TYPE_TCP;
80109ea6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ea9:	c6 40 09 06          	movb   $0x6,0x9(%eax)
  memmove(ipv4_send->src_ip,my_ip,4);
80109ead:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109eb0:	83 c0 0c             	add    $0xc,%eax
80109eb3:	83 ec 04             	sub    $0x4,%esp
80109eb6:	6a 04                	push   $0x4
80109eb8:	68 04 f5 10 80       	push   $0x8010f504
80109ebd:	50                   	push   %eax
80109ebe:	e8 df ad ff ff       	call   80104ca2 <memmove>
80109ec3:	83 c4 10             	add    $0x10,%esp
  memmove(ipv4_send->dst_ip,ipv4_recv->src_ip,4);
80109ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109ec9:	8d 50 0c             	lea    0xc(%eax),%edx
80109ecc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ecf:	83 c0 10             	add    $0x10,%eax
80109ed2:	83 ec 04             	sub    $0x4,%esp
80109ed5:	6a 04                	push   $0x4
80109ed7:	52                   	push   %edx
80109ed8:	50                   	push   %eax
80109ed9:	e8 c4 ad ff ff       	call   80104ca2 <memmove>
80109ede:	83 c4 10             	add    $0x10,%esp
  ipv4_send->chk_sum = 0;
80109ee1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109ee4:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  ipv4_send->chk_sum = H2N_ushort(ipv4_chksum((uint)ipv4_send));
80109eea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109eed:	83 ec 0c             	sub    $0xc,%esp
80109ef0:	50                   	push   %eax
80109ef1:	e8 08 f9 ff ff       	call   801097fe <ipv4_chksum>
80109ef6:	83 c4 10             	add    $0x10,%esp
80109ef9:	0f b7 c0             	movzwl %ax,%eax
80109efc:	83 ec 0c             	sub    $0xc,%esp
80109eff:	50                   	push   %eax
80109f00:	e8 04 f8 ff ff       	call   80109709 <H2N_ushort>
80109f05:	83 c4 10             	add    $0x10,%esp
80109f08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109f0b:	66 89 42 0a          	mov    %ax,0xa(%edx)
  

  tcp_send->src_port = tcp_recv->dst_port;
80109f0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f12:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80109f16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f19:	66 89 10             	mov    %dx,(%eax)
  tcp_send->dst_port = tcp_recv->src_port;
80109f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f1f:	0f b7 10             	movzwl (%eax),%edx
80109f22:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f25:	66 89 50 02          	mov    %dx,0x2(%eax)
  tcp_send->seq_num = H2N_uint(seq_num);
80109f29:	a1 64 71 19 80       	mov    0x80197164,%eax
80109f2e:	83 ec 0c             	sub    $0xc,%esp
80109f31:	50                   	push   %eax
80109f32:	e8 e9 f7 ff ff       	call   80109720 <H2N_uint>
80109f37:	83 c4 10             	add    $0x10,%esp
80109f3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109f3d:	89 42 04             	mov    %eax,0x4(%edx)
  tcp_send->ack_num = tcp_recv->seq_num + (1<<(8*3));
80109f40:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f43:	8b 40 04             	mov    0x4(%eax),%eax
80109f46:	8d 90 00 00 00 01    	lea    0x1000000(%eax),%edx
80109f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f4f:	89 50 08             	mov    %edx,0x8(%eax)

  tcp_send->code_bits[0] = 0;
80109f52:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f55:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  tcp_send->code_bits[1] = 0;
80109f59:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f5c:	c6 40 0d 00          	movb   $0x0,0xd(%eax)
  tcp_send->code_bits[0] = 5<<4;
80109f60:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f63:	c6 40 0c 50          	movb   $0x50,0xc(%eax)
  tcp_send->code_bits[1] = pkt_type;
80109f67:	8b 45 14             	mov    0x14(%ebp),%eax
80109f6a:	89 c2                	mov    %eax,%edx
80109f6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f6f:	88 50 0d             	mov    %dl,0xd(%eax)

  tcp_send->window = H2N_ushort(14480);
80109f72:	83 ec 0c             	sub    $0xc,%esp
80109f75:	68 90 38 00 00       	push   $0x3890
80109f7a:	e8 8a f7 ff ff       	call   80109709 <H2N_ushort>
80109f7f:	83 c4 10             	add    $0x10,%esp
80109f82:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109f85:	66 89 42 0e          	mov    %ax,0xe(%edx)
  tcp_send->urgent_ptr = 0;
80109f89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f8c:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  tcp_send->chk_sum = 0;
80109f92:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109f95:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)

  tcp_send->chk_sum = H2N_ushort(tcp_chksum((uint)(ipv4_send))+8);
80109f9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109f9e:	83 ec 0c             	sub    $0xc,%esp
80109fa1:	50                   	push   %eax
80109fa2:	e8 1f 00 00 00       	call   80109fc6 <tcp_chksum>
80109fa7:	83 c4 10             	add    $0x10,%esp
80109faa:	83 c0 08             	add    $0x8,%eax
80109fad:	0f b7 c0             	movzwl %ax,%eax
80109fb0:	83 ec 0c             	sub    $0xc,%esp
80109fb3:	50                   	push   %eax
80109fb4:	e8 50 f7 ff ff       	call   80109709 <H2N_ushort>
80109fb9:	83 c4 10             	add    $0x10,%esp
80109fbc:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109fbf:	66 89 42 10          	mov    %ax,0x10(%edx)


}
80109fc3:	90                   	nop
80109fc4:	c9                   	leave
80109fc5:	c3                   	ret

80109fc6 <tcp_chksum>:

ushort tcp_chksum(uint tcp_addr){
80109fc6:	55                   	push   %ebp
80109fc7:	89 e5                	mov    %esp,%ebp
80109fc9:	83 ec 38             	sub    $0x38,%esp
  struct ipv4_pkt *ipv4_p = (struct ipv4_pkt *)(tcp_addr);
80109fcc:	8b 45 08             	mov    0x8(%ebp),%eax
80109fcf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  struct tcp_pkt *tcp_p = (struct tcp_pkt *)((uint)ipv4_p + sizeof(struct ipv4_pkt));
80109fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109fd5:	83 c0 14             	add    $0x14,%eax
80109fd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct tcp_dummy tcp_dummy;
  
  memmove(tcp_dummy.src_ip,my_ip,4);
80109fdb:	83 ec 04             	sub    $0x4,%esp
80109fde:	6a 04                	push   $0x4
80109fe0:	68 04 f5 10 80       	push   $0x8010f504
80109fe5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80109fe8:	50                   	push   %eax
80109fe9:	e8 b4 ac ff ff       	call   80104ca2 <memmove>
80109fee:	83 c4 10             	add    $0x10,%esp
  memmove(tcp_dummy.dst_ip,ipv4_p->src_ip,4);
80109ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109ff4:	83 c0 0c             	add    $0xc,%eax
80109ff7:	83 ec 04             	sub    $0x4,%esp
80109ffa:	6a 04                	push   $0x4
80109ffc:	50                   	push   %eax
80109ffd:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a000:	83 c0 04             	add    $0x4,%eax
8010a003:	50                   	push   %eax
8010a004:	e8 99 ac ff ff       	call   80104ca2 <memmove>
8010a009:	83 c4 10             	add    $0x10,%esp
  tcp_dummy.padding = 0;
8010a00c:	c6 45 dc 00          	movb   $0x0,-0x24(%ebp)
  tcp_dummy.protocol = IPV4_TYPE_TCP;
8010a010:	c6 45 dd 06          	movb   $0x6,-0x23(%ebp)
  tcp_dummy.tcp_len = H2N_ushort(N2H_ushort(ipv4_p->total_len) - sizeof(struct ipv4_pkt));
8010a014:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a017:	0f b7 40 02          	movzwl 0x2(%eax),%eax
8010a01b:	0f b7 c0             	movzwl %ax,%eax
8010a01e:	83 ec 0c             	sub    $0xc,%esp
8010a021:	50                   	push   %eax
8010a022:	e8 cb f6 ff ff       	call   801096f2 <N2H_ushort>
8010a027:	83 c4 10             	add    $0x10,%esp
8010a02a:	83 e8 14             	sub    $0x14,%eax
8010a02d:	0f b7 c0             	movzwl %ax,%eax
8010a030:	83 ec 0c             	sub    $0xc,%esp
8010a033:	50                   	push   %eax
8010a034:	e8 d0 f6 ff ff       	call   80109709 <H2N_ushort>
8010a039:	83 c4 10             	add    $0x10,%esp
8010a03c:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  uint chk_sum = 0;
8010a040:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  uchar *bin = (uchar *)(&tcp_dummy);
8010a047:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010a04a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<6;i++){
8010a04d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010a054:	eb 33                	jmp    8010a089 <tcp_chksum+0xc3>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a056:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a059:	01 c0                	add    %eax,%eax
8010a05b:	89 c2                	mov    %eax,%edx
8010a05d:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a060:	01 d0                	add    %edx,%eax
8010a062:	0f b6 00             	movzbl (%eax),%eax
8010a065:	0f b6 c0             	movzbl %al,%eax
8010a068:	c1 e0 08             	shl    $0x8,%eax
8010a06b:	89 c2                	mov    %eax,%edx
8010a06d:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a070:	01 c0                	add    %eax,%eax
8010a072:	8d 48 01             	lea    0x1(%eax),%ecx
8010a075:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a078:	01 c8                	add    %ecx,%eax
8010a07a:	0f b6 00             	movzbl (%eax),%eax
8010a07d:	0f b6 c0             	movzbl %al,%eax
8010a080:	01 d0                	add    %edx,%eax
8010a082:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<6;i++){
8010a085:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010a089:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
8010a08d:	7e c7                	jle    8010a056 <tcp_chksum+0x90>
  }

  bin = (uchar *)(tcp_p);
8010a08f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010a092:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a095:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010a09c:	eb 33                	jmp    8010a0d1 <tcp_chksum+0x10b>
    chk_sum += (bin[i*2]<<8)+bin[i*2+1];
8010a09e:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a0a1:	01 c0                	add    %eax,%eax
8010a0a3:	89 c2                	mov    %eax,%edx
8010a0a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a0a8:	01 d0                	add    %edx,%eax
8010a0aa:	0f b6 00             	movzbl (%eax),%eax
8010a0ad:	0f b6 c0             	movzbl %al,%eax
8010a0b0:	c1 e0 08             	shl    $0x8,%eax
8010a0b3:	89 c2                	mov    %eax,%edx
8010a0b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a0b8:	01 c0                	add    %eax,%eax
8010a0ba:	8d 48 01             	lea    0x1(%eax),%ecx
8010a0bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a0c0:	01 c8                	add    %ecx,%eax
8010a0c2:	0f b6 00             	movzbl (%eax),%eax
8010a0c5:	0f b6 c0             	movzbl %al,%eax
8010a0c8:	01 d0                	add    %edx,%eax
8010a0ca:	01 45 f4             	add    %eax,-0xc(%ebp)
  for(int i=0;i<(N2H_ushort(tcp_dummy.tcp_len)/2);i++){
8010a0cd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010a0d1:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
8010a0d5:	0f b7 c0             	movzwl %ax,%eax
8010a0d8:	83 ec 0c             	sub    $0xc,%esp
8010a0db:	50                   	push   %eax
8010a0dc:	e8 11 f6 ff ff       	call   801096f2 <N2H_ushort>
8010a0e1:	83 c4 10             	add    $0x10,%esp
8010a0e4:	66 d1 e8             	shr    $1,%ax
8010a0e7:	0f b7 c0             	movzwl %ax,%eax
8010a0ea:	39 45 ec             	cmp    %eax,-0x14(%ebp)
8010a0ed:	7c af                	jl     8010a09e <tcp_chksum+0xd8>
  }
  chk_sum += (chk_sum>>8*2);
8010a0ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a0f2:	c1 e8 10             	shr    $0x10,%eax
8010a0f5:	01 45 f4             	add    %eax,-0xc(%ebp)
  return ~(chk_sum);
8010a0f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a0fb:	f7 d0                	not    %eax
}
8010a0fd:	c9                   	leave
8010a0fe:	c3                   	ret

8010a0ff <tcp_fin>:

void tcp_fin(){
8010a0ff:	55                   	push   %ebp
8010a100:	89 e5                	mov    %esp,%ebp
  fin_flag =1;
8010a102:	c7 05 68 71 19 80 01 	movl   $0x1,0x80197168
8010a109:	00 00 00 
}
8010a10c:	90                   	nop
8010a10d:	5d                   	pop    %ebp
8010a10e:	c3                   	ret

8010a10f <http_proc>:
#include "defs.h"
#include "types.h"
#include "tcp.h"


void http_proc(uint recv, uint recv_size, uint send, uint *send_size){
8010a10f:	55                   	push   %ebp
8010a110:	89 e5                	mov    %esp,%ebp
8010a112:	83 ec 18             	sub    $0x18,%esp
  int len;
  len = http_strcpy((char *)send,"HTTP/1.0 200 OK \r\n",0);
8010a115:	8b 45 10             	mov    0x10(%ebp),%eax
8010a118:	83 ec 04             	sub    $0x4,%esp
8010a11b:	6a 00                	push   $0x0
8010a11d:	68 6b c2 10 80       	push   $0x8010c26b
8010a122:	50                   	push   %eax
8010a123:	e8 65 00 00 00       	call   8010a18d <http_strcpy>
8010a128:	83 c4 10             	add    $0x10,%esp
8010a12b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"Content-Type: text/html \r\n",len);
8010a12e:	8b 45 10             	mov    0x10(%ebp),%eax
8010a131:	83 ec 04             	sub    $0x4,%esp
8010a134:	ff 75 f4             	push   -0xc(%ebp)
8010a137:	68 7e c2 10 80       	push   $0x8010c27e
8010a13c:	50                   	push   %eax
8010a13d:	e8 4b 00 00 00       	call   8010a18d <http_strcpy>
8010a142:	83 c4 10             	add    $0x10,%esp
8010a145:	01 45 f4             	add    %eax,-0xc(%ebp)
  len += http_strcpy((char *)send,"\r\nHello World!\r\n",len);
8010a148:	8b 45 10             	mov    0x10(%ebp),%eax
8010a14b:	83 ec 04             	sub    $0x4,%esp
8010a14e:	ff 75 f4             	push   -0xc(%ebp)
8010a151:	68 99 c2 10 80       	push   $0x8010c299
8010a156:	50                   	push   %eax
8010a157:	e8 31 00 00 00       	call   8010a18d <http_strcpy>
8010a15c:	83 c4 10             	add    $0x10,%esp
8010a15f:	01 45 f4             	add    %eax,-0xc(%ebp)
  if(len%2 != 0){
8010a162:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a165:	83 e0 01             	and    $0x1,%eax
8010a168:	85 c0                	test   %eax,%eax
8010a16a:	74 11                	je     8010a17d <http_proc+0x6e>
    char *payload = (char *)send;
8010a16c:	8b 45 10             	mov    0x10(%ebp),%eax
8010a16f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    payload[len] = 0;
8010a172:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a175:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a178:	01 d0                	add    %edx,%eax
8010a17a:	c6 00 00             	movb   $0x0,(%eax)
  }
  *send_size = len;
8010a17d:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010a180:	8b 45 14             	mov    0x14(%ebp),%eax
8010a183:	89 10                	mov    %edx,(%eax)
  tcp_fin();
8010a185:	e8 75 ff ff ff       	call   8010a0ff <tcp_fin>
}
8010a18a:	90                   	nop
8010a18b:	c9                   	leave
8010a18c:	c3                   	ret

8010a18d <http_strcpy>:

int http_strcpy(char *dst,const char *src,int start_index){
8010a18d:	55                   	push   %ebp
8010a18e:	89 e5                	mov    %esp,%ebp
8010a190:	83 ec 10             	sub    $0x10,%esp
  int i = 0;
8010a193:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while(src[i]){
8010a19a:	eb 20                	jmp    8010a1bc <http_strcpy+0x2f>
    dst[start_index+i] = src[i];
8010a19c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a19f:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a1a2:	01 d0                	add    %edx,%eax
8010a1a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010a1a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a1aa:	01 ca                	add    %ecx,%edx
8010a1ac:	89 d1                	mov    %edx,%ecx
8010a1ae:	8b 55 08             	mov    0x8(%ebp),%edx
8010a1b1:	01 ca                	add    %ecx,%edx
8010a1b3:	0f b6 00             	movzbl (%eax),%eax
8010a1b6:	88 02                	mov    %al,(%edx)
    i++;
8010a1b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(src[i]){
8010a1bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010a1bf:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a1c2:	01 d0                	add    %edx,%eax
8010a1c4:	0f b6 00             	movzbl (%eax),%eax
8010a1c7:	84 c0                	test   %al,%al
8010a1c9:	75 d1                	jne    8010a19c <http_strcpy+0xf>
  }
  return i;
8010a1cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010a1ce:	c9                   	leave
8010a1cf:	c3                   	ret

8010a1d0 <ideinit>:
static int disksize;
static uchar *memdisk;

void
ideinit(void)
{
8010a1d0:	55                   	push   %ebp
8010a1d1:	89 e5                	mov    %esp,%ebp
  memdisk = _binary_fs_img_start;
8010a1d3:	c7 05 70 71 19 80 c2 	movl   $0x8010f5c2,0x80197170
8010a1da:	f5 10 80 
  disksize = (uint)_binary_fs_img_size/BSIZE;
8010a1dd:	b8 00 d0 07 00       	mov    $0x7d000,%eax
8010a1e2:	c1 e8 09             	shr    $0x9,%eax
8010a1e5:	a3 6c 71 19 80       	mov    %eax,0x8019716c
}
8010a1ea:	90                   	nop
8010a1eb:	5d                   	pop    %ebp
8010a1ec:	c3                   	ret

8010a1ed <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010a1ed:	55                   	push   %ebp
8010a1ee:	89 e5                	mov    %esp,%ebp
  // no-op
}
8010a1f0:	90                   	nop
8010a1f1:	5d                   	pop    %ebp
8010a1f2:	c3                   	ret

8010a1f3 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010a1f3:	55                   	push   %ebp
8010a1f4:	89 e5                	mov    %esp,%ebp
8010a1f6:	83 ec 18             	sub    $0x18,%esp
  uchar *p;

  if(!holdingsleep(&b->lock))
8010a1f9:	8b 45 08             	mov    0x8(%ebp),%eax
8010a1fc:	83 c0 0c             	add    $0xc,%eax
8010a1ff:	83 ec 0c             	sub    $0xc,%esp
8010a202:	50                   	push   %eax
8010a203:	e8 d4 a6 ff ff       	call   801048dc <holdingsleep>
8010a208:	83 c4 10             	add    $0x10,%esp
8010a20b:	85 c0                	test   %eax,%eax
8010a20d:	75 0d                	jne    8010a21c <iderw+0x29>
    panic("iderw: buf not locked");
8010a20f:	83 ec 0c             	sub    $0xc,%esp
8010a212:	68 aa c2 10 80       	push   $0x8010c2aa
8010a217:	e8 8d 63 ff ff       	call   801005a9 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010a21c:	8b 45 08             	mov    0x8(%ebp),%eax
8010a21f:	8b 00                	mov    (%eax),%eax
8010a221:	83 e0 06             	and    $0x6,%eax
8010a224:	83 f8 02             	cmp    $0x2,%eax
8010a227:	75 0d                	jne    8010a236 <iderw+0x43>
    panic("iderw: nothing to do");
8010a229:	83 ec 0c             	sub    $0xc,%esp
8010a22c:	68 c0 c2 10 80       	push   $0x8010c2c0
8010a231:	e8 73 63 ff ff       	call   801005a9 <panic>
  if(b->dev != 1)
8010a236:	8b 45 08             	mov    0x8(%ebp),%eax
8010a239:	8b 40 04             	mov    0x4(%eax),%eax
8010a23c:	83 f8 01             	cmp    $0x1,%eax
8010a23f:	74 0d                	je     8010a24e <iderw+0x5b>
    panic("iderw: request not for disk 1");
8010a241:	83 ec 0c             	sub    $0xc,%esp
8010a244:	68 d5 c2 10 80       	push   $0x8010c2d5
8010a249:	e8 5b 63 ff ff       	call   801005a9 <panic>
  if(b->blockno >= disksize)
8010a24e:	8b 45 08             	mov    0x8(%ebp),%eax
8010a251:	8b 40 08             	mov    0x8(%eax),%eax
8010a254:	8b 15 6c 71 19 80    	mov    0x8019716c,%edx
8010a25a:	39 d0                	cmp    %edx,%eax
8010a25c:	72 0d                	jb     8010a26b <iderw+0x78>
    panic("iderw: block out of range");
8010a25e:	83 ec 0c             	sub    $0xc,%esp
8010a261:	68 f3 c2 10 80       	push   $0x8010c2f3
8010a266:	e8 3e 63 ff ff       	call   801005a9 <panic>

  p = memdisk + b->blockno*BSIZE;
8010a26b:	8b 15 70 71 19 80    	mov    0x80197170,%edx
8010a271:	8b 45 08             	mov    0x8(%ebp),%eax
8010a274:	8b 40 08             	mov    0x8(%eax),%eax
8010a277:	c1 e0 09             	shl    $0x9,%eax
8010a27a:	01 d0                	add    %edx,%eax
8010a27c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(b->flags & B_DIRTY){
8010a27f:	8b 45 08             	mov    0x8(%ebp),%eax
8010a282:	8b 00                	mov    (%eax),%eax
8010a284:	83 e0 04             	and    $0x4,%eax
8010a287:	85 c0                	test   %eax,%eax
8010a289:	74 2b                	je     8010a2b6 <iderw+0xc3>
    b->flags &= ~B_DIRTY;
8010a28b:	8b 45 08             	mov    0x8(%ebp),%eax
8010a28e:	8b 00                	mov    (%eax),%eax
8010a290:	83 e0 fb             	and    $0xfffffffb,%eax
8010a293:	89 c2                	mov    %eax,%edx
8010a295:	8b 45 08             	mov    0x8(%ebp),%eax
8010a298:	89 10                	mov    %edx,(%eax)
    memmove(p, b->data, BSIZE);
8010a29a:	8b 45 08             	mov    0x8(%ebp),%eax
8010a29d:	83 c0 5c             	add    $0x5c,%eax
8010a2a0:	83 ec 04             	sub    $0x4,%esp
8010a2a3:	68 00 02 00 00       	push   $0x200
8010a2a8:	50                   	push   %eax
8010a2a9:	ff 75 f4             	push   -0xc(%ebp)
8010a2ac:	e8 f1 a9 ff ff       	call   80104ca2 <memmove>
8010a2b1:	83 c4 10             	add    $0x10,%esp
8010a2b4:	eb 1a                	jmp    8010a2d0 <iderw+0xdd>
  } else
    memmove(b->data, p, BSIZE);
8010a2b6:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2b9:	83 c0 5c             	add    $0x5c,%eax
8010a2bc:	83 ec 04             	sub    $0x4,%esp
8010a2bf:	68 00 02 00 00       	push   $0x200
8010a2c4:	ff 75 f4             	push   -0xc(%ebp)
8010a2c7:	50                   	push   %eax
8010a2c8:	e8 d5 a9 ff ff       	call   80104ca2 <memmove>
8010a2cd:	83 c4 10             	add    $0x10,%esp
  b->flags |= B_VALID;
8010a2d0:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2d3:	8b 00                	mov    (%eax),%eax
8010a2d5:	83 c8 02             	or     $0x2,%eax
8010a2d8:	89 c2                	mov    %eax,%edx
8010a2da:	8b 45 08             	mov    0x8(%ebp),%eax
8010a2dd:	89 10                	mov    %edx,(%eax)
}
8010a2df:	90                   	nop
8010a2e0:	c9                   	leave
8010a2e1:	c3                   	ret
