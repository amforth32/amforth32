-include .env
TARGET ?= QEM
TARGETS = QEM
ifneq ($(strip $(TARGET)), QEM)
$(error Unknown TARGET '$(TARGET)')
endif
DIST_TARGET ?= arm-qemu-virt
MCU_LD ?= qemu.ld

LANG=C
AMFORTH ?= $(shell git rev-parse --show-toplevel)

# Included after various configuration bits are defined (importantly MCU_LD)
include $(AMFORTH)/arm/dev/Makefile

QEMU := qemu-system-arm -M virt -cpu cortex-a15 -m 1M -kernel build/amforth.elf
# -nographic is incompatible with -serial stdio as the monitor takes over the serial device
## Start AmForth under QEMU with operator uart connected to stdio
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
