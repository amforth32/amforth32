# Default to the QEMU target since the real boards were discontinued
TARGET ?= LM3QEM
TARGETS = LM4, LM3QEM
ifeq ($(strip $(TARGET)), LM4)
MCU_LD ?= lm4f120.ld
else ifeq ($(strip $(TARGET)), LM3QEM)
MCU_LD ?= lm3s6965qem.ld
else
$(error Unknown TARGET '$(TARGET)')
endif

BOARD=$(shell uname -m)
ifeq ("$(BOARD)", "armv7l")
   CROSS=
endif
LANG=C

AMFORTH ?= $(shell git rev-parse --show-toplevel)

# Included after various configuration bits are defined (importantly MCU_LD)
include $(AMFORTH)/arm/dev/Makefile

## Upload bin file to the device
upload:
	lm4flash build/amforth.bin

# QEMU's lm3s6965evb machine is not the LM4F120H5QR (m3 vs m4), but seems to be close enough.
# https://www.qemu.org/docs/master/system/arm/stellaris.html
QEMU=qemu-system-arm -M lm3s6965evb -bios none -kernel build/amforth.elf

## Start AmForth under QEMU with operator uart connected to a pty
stdio:
	$(QEMU) -display none -serial stdio

# Use this when you want more powerful terminal emulator than the very basic stdio.
# The pty device is printed after start, connect to it with a terminal emulator,
# e.g.: tio --map=ODELBS /dev/ttys019	// ODELBS fixes backspace behavior
## Start AmForth under QEMU with operator uart connected to a pty
pty:
	$(QEMU) -nographic -serial pty
#	Following was an attempt to predefine the device filename
#	Unsuccessful so far: Failed to create PTY symlink: Operation not permitted
#	$(QEMU) -chardev pty,path=/dev/stellaris,id=stellaris -serial chardev:stellaris

# Add -S if you want QEMU to not start the quest.
## Like pty but allows GDB to attach to it (-s).
debug:
	$(QEMU) -nographic -serial pty -s

## Connect GDB to running amforth (must be running with -s, see debug)
gdb:
	$(GDBPY) build/amforth.elf --quiet \
		-ex 'target remote :1234' \
		-ex "source tui-full.gdb"
