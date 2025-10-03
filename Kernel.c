/* Simple 32-bit kernel that writes to VGA text buffer */
typedef unsigned int   u32;
typedef unsigned short u16;
typedef unsigned char  u8;

void kmain(void) {
    volatile u16* vga = (volatile u16*)0xB8000;
    const char *msg = "Hello from TinyOS! - Press any key to continue...";
    int i = 0;
    /* Clear screen */
    for (i = 0; i < 80*25; ++i) vga[i] = (u16)(' ' | (0x07 << 8));
    /* Print message */
    for (i = 0; msg[i] != '\0'; ++i) {
        vga[i] = (u16)(msg[i] | (0x0F << 8));
    }
    /* Simple infinite loop */
    for (;;) {
        asm volatile ("hlt");
    }
}
