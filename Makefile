CROSS=i386-elf-
CC=$(CROSS)gcc
AS=$(CROSS)as
LD=$(CROSS)ld
OBJCOPY=$(CROSS)objcopy
CFLAGS=-nostdlib -fno-builtin -fno-exceptions -m32 -nostartfiles -Wall -Wextra -O2
LDFLAGS=-T link.ld

all: tinyos.iso

boot.o: boot.s
	$(AS) --32 boot.s -o boot.o

kernel.o: kernel.c
	$(CC) $(CFLAGS) -m32 -c kernel.c -o kernel.o

tinyos.bin: boot.o kernel.o
	$(LD) $(LDFLAGS) boot.o kernel.o -o tinyos.elf
	$(OBJCOPY) -O binary tinyos.elf tinyos.bin

tinyos.iso: tinyos.bin grub/grub.cfg
	mkdir -p iso/boot/grub
	cp tinyos.bin iso/boot/kernel.bin
	cp grub/grub.cfg iso/boot/grub/
	grub-mkrescue -o tinyos.iso iso
	rm -rf iso

run: tinyos.iso
	qemu-system-i386 -cdrom tinyos.iso -m 512M

clean:
	rm -f *.o tinyos.elf tinyos.bin tinyos.iso
	rm -rf iso

.PHONY: all run clean
