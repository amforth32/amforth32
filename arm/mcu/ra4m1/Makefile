# Put configuration variables specific to your local development environment into .env file in this directory.
# (it will be ignored by git, and won't be committed to the repository)
#
# Following variables should be set there:
# * MODEM - the serial device used to connect to the board, e.g cu.usbmodemB43A45B4700C2
# * BOSSAC - UNO R4 uploader (see more details below)
# * OPENOCD - on-chip debugging server for GDB
#
# If you have Arduino IDE installed with the Uno R4 board you can
# point BOSSAC, OPENOCD at the Arduino installed binaries, e.g.
# ARDUINO_TOOLS = /Users/martin/Library/Arduino15/packages/arduino/tools
# BOSSAC=$(ARDUINO_TOOLS)/bossac/1.9.1-arduino5/bossac
# OPENOCD = $(ARDUINO_TOOLS)/openocd/0.11.0-arduino2/bin/openocd
-include .env

TARGET ?= UNOR4
TARGETS = UNOR4
ifeq ($(strip $(TARGET)), UNOR4)
MCU_LD ?= unor4.ld
DIST_TARGET ?= arm-ra4m1-unor4
else
$(error Unknown TARGET '$(TARGET)')
endif

LANG=C
BOARD = UNOR4
# serial connection speed used by AmForth and the UNO R4 bootloader
SPEED = 115200

AMFORTH ?= $(shell git rev-parse --show-toplevel)

# Included after various configuration bits are defined (importantly MCU_LD and TARGET)
include $(AMFORTH)/arm/dev/Makefile

# Using bossac as the uploader, based on what Arduino IDE uses to program the board.
# https://www.shumatech.com/web/products/bossa
# https://github.com/arduino/BOSSA
BOSSAC ?= bossac
OPENOCD ?= openocd

# N.B.: The UNO R4 BOSSA_LOADER always stores the file at FLASH_IMAGE_START (+offset),
# 		so DO NOT use -o to enforce FLASH_IMAGE_START!
# see https://github.com/arduino/arduino-renesas-bootloader/blob/main/src/bossa.c#L272
# see also ./memmap.ld
#
# The board must be in bootloader mode for bossac to be able to communicate with it.
# The LED soft pulses at 1 sec intervals when in bootloader mode.
# To put the board into bootloader mode manually, press and release the RESET button twice.
# Alternatively the touch1200bps utility can achieve the same as well.
#
# Note: it seems only the Arduino version of bossac works with UNO R4 (https://github.com/arduino/BOSSA)
# The touch1200bps often doesn't work, not sure why (check the -boot option maybe?)
# Double pressing the reset button is reliable.
## Upload bin file to the device  
upload:
	touch1200bps/touch1200bps /dev/$(MODEM)
	$(BOSSAC) --debug --port=$(MODEM) --write build/amforth.bin --reset

## erase whole flash (doesn't seem to actually do that, hmm)
erase:
	$(BOSSAC) -h
	# $(BOSSAC) --debug --port=$(MODEM) --erase



# This builds the touch1200bps binary; requires a reasonably recent version of Golang installed.
# This is used above for the upload target.
# Build touch1200bps utility (requires Golang)
touch1200bps: touch1200bps/*
	cd ./touch1200bps && go build

.PHONY: upload touch1200bps ocd gdb

# You can connect to the OpenOCD telnet port with: nc localhost 50002
# You can also send commands to OpenOCD through GDB's 'monitor' command
## Start OpenOCD
ocd:
	$(OPENOCD) -c "gdb_port 50000" -c "tcl_port 50001" -c "telnet_port 50002" \
		-c "adapter driver cmsis-dap" \
		-c "transport select swd" \
		-f dev/R7FA4M1AB.cfg
		# -c "init; ra4m1.cpu configure -event gdb-detach { resume }"

# If you don't have/want python enabled GDB you can
# * replace $(GDBPY) with $(GDB)
# * replace tui-full.gdb with tui-basic.gdb
## Start gdb and connect to OpenOCD
gdb:
	$(GDBPY) build/amforth.elf --quiet \
		-ex "target extended-remote localhost:50000" \
		-ex "source tui-full.gdb"

# More debugging references
# https://undo.io/resources/guide-to-symbols-debug-info/


GOBUILD = cd ./touch1200bps && go build -o dist/ .
TAR = cd touch1200bps/dist && tar zcf
## Build touch1200bps release artifacts
dist1200bps:
	export GOOS=darwin GOARCH=arm64; $(GOBUILD)
	$(TAR) touch1200bps-osx-arm64.tgz touch1200bps
	export GOOS=darwin GOARCH=amd64; $(GOBUILD)
	$(TAR) touch1200bps-osx-amd64.tgz touch1200bps
	export GOOS=linux GOARCH=arm64; $(GOBUILD)
	$(TAR) touch1200bps-linux-arm64.tgz touch1200bps
	export GOOS=linux GOARCH=amd64; $(GOBUILD)
	$(TAR) touch1200bps-linux-amd64.tgz touch1200bps
	export GOOS=windows GOARCH=amd64; $(GOBUILD)
	$(TAR) touch1200bps-windows-amd64.tgz touch1200bps.exe