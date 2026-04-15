# SPDX-License-Identifier: GPL-3.0-only
# AmForth-RV Makefile

-include .env

AMFORTH ?= $(shell git rev-parse --show-toplevel)

DIST_TARGET ?= rv-ch32-307

QEMU_RV32 ?= qemu-system-riscv32
WLINK ?= $(HOME)/.cargo/bin/wlink
MINICOM ?= minicom
OPENOCD ?= openocd
OPENCFG ?= dev/wch-riscv.cfg

UU=$(AMFORTH)/tools/uu

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
# Guessing variables based on operating system

# Default target to build
TARGET ?= 307
TARGETS = 307 305 203 

CHIPSET=$(TARGET)
MCU_LD := ./$(TARGET).ld
LIB_WCH := ./lib_$(TARGET)
LIB_USER := ./lib_$(TARGET)_user

ASFLAGS ?= -march=rv32imafc -mabi=ilp32f

# Included after various configuration bits are defined (importantly MCU_LD and TARGET)
include $(AMFORTH)/rv/dev/Makefile


.PHONY: info shell speed save uu 

## Upload hex file to the device  
upload:
	$(WLINK) flash build/amforth.hex

## Connect via USB 
uu:
	$(UU) 

## Connect via minicom 
min:
	$(RM) minicom.cap
	$(MINICOM) -D $(MODEM) --color=on -C minicom.cap

#? --- Debugging ---
## Start GDB 
gdb:
	$(GDBPY) build/amforth.elf --quiet \
		--ex 'target extended-remote :3333' \
		--ex "source tui-full.gdb"

# On Apple Silicon you need to download OpenOCD from MRS https://www.mounriver.com/download to get an arm64 version.
## Start OpenOCD
ocd:
	$(OPENOCD) -f $(OPENCFG)
