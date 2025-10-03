/* Multiboot header and entry point */
.section .multiboot
.long 0x1BADB002
.long 0x00
.long -(0x1BADB002 + 0x00)

.text
.global _start
_start:
    cli
    /* Set up a minimal stack */
    mov $stack_top, %esp

    /* Call C kernel entry */
    call kmain

    /* Halt */
.halt:
    hlt
    jmp .halt

/* simple stack */
.section .bss
    .skip 4096
stack_top:

.size _start, .-_start
