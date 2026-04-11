OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(_start)

SECTIONS
{
    /* 커널은 가상 주소 0x80100000에서 실행됨 */
    . = 0x80100000;

    /* 실제 물리 주소 0x100000 (1MB) 위치에 로드됨 */
    .text : AT(0x100000) {
        *(.text .stub .text.* .gnu.linkonce.t.*)
    }

    PROVIDE(etext = .);

    .rodata : {
        *(.rodata .rodata.* .gnu.linkonce.r.*)
    }

    . = ALIGN(0x1000);
    PROVIDE(data = .);

    .data : {
        *(.data)
    }

    . = ALIGN(0x1000);
    PROVIDE(edata = .);

    .bss : {
        *(.bss)
        *(COMMON)
    }

    . = ALIGN(0x1000);
    PROVIDE(end = .);

    /DISCARD/ : {
        *(.eh_frame .note.GNU-stack)
    }
}