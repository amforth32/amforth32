# SPDX-License-Identifier: GPL-3.0-only

-include .env

AMFORTH ?= $(shell git rev-parse --show-toplevel)

QEMU_RV32 ?= qemu-system-riscv32 

# Default target to build
TARGET = QEM
TARGETS = QEM
MCU_LD := ./qemu.ld
DIST_TARGET ?= rv-qemu-virt

ASFLAGS += -march=rv32imac_zicsr_zifencei -mabi=ilp32

# Included after various configuration bits are defined (importantly MCU_LD and TARGET)
include $(AMFORTH)/rv/dev/Makefile

.PRECIOUS: amforth.s

#? --- QEM ---
# QEMU := $(QEMU_RV32) -M virt -bios none -kernel build/amforth.elf

# This is quite different from the -kernel option, which will for the RV 'virt' jump to
# 0x8000_0000 no matter what ENTRY() has in the linker file. The cpu-num=0 sets the PC
# to the value indicated by ENTRY(), which is much more suitable our needs.
# The alternative option line gives a hint as to how to set the PC to an absolute address at boot time.
QEMU := $(QEMU_RV32) -M virt -bios none -device loader,file=build/amforth.elf,cpu-num=0
#        -device loader,addr=0x20000000,cpu-num=0

# The above is really slow when the memory regions are far apart, supposedly due to a slow generic ELF loader
# that is zeroing out a lot of empty memory in an inefficient way. The workaround is to load the bin file instead,
# which bypasses the ELF loading semantics. Note that it is important to set the loading address correctly,
# it needs to match the start of the FLASH memory region!
# QEMU := $(QEMU_RV32) -M virt -bios none -device loader,file=build/amforth.bin,addr=0x20010000,cpu-num=0

## Start AmForth under QEMU with operator uart connected to stdio
stdio:
	$(QEMU) -display none -serial stdio

## Start AmForth under QEMU with operator uart connected to a pty
pty:
	$(QEMU) -nographic -serial pty

# Add -S if you want QEMU to not start the quest.
## Like pty but allows GDB to attach to it (-s).
debug:
	$(QEMU) -nographic -serial pty -s

## Connect GDB to amforth running on QEMU (must be running with -s, see debug)
gdb:
	$(GDBPY) build/amforth.elf --quiet \
		-ex 'target remote :1234' \
		-ex "source tui-full.gdb"

## Serve AmForth on :4444 (make nc|socshell for client) - logs to /tmp/serial.log
socket:
	$(QEMU) -display none \
    -chardev socket,id=sock0,host=127.0.0.1,port=4444,server=on,wait=on,logfile=/tmp/serial.log \
    -serial chardev:sock0        

## Serve AmForth on :4444 with debug on :1234 - logs to /tmp/serial.log
socbug:
	$(QEMU) -display none \
    -chardev socket,id=sock0,host=127.0.0.1,port=4444,server=on,wait=on,logfile=/tmp/serial.log \
    -serial chardev:sock0 -s

## rlwrap nc client connecting to :4444
nc:
	rlwrap nc localhost 4444

## socket-shell as client connecting to :4444
socshell:                                                                                                   
	$(AMFORTH)/tools/socket-shell.py --no-error-on-output -i --ignore-error

read-elf:                                                                                                     
	$(TC_DIR)/bin/$(CROSS)readelf -h build/amforth.elf
