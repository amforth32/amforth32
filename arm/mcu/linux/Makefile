AMFORTH ?= $(shell git rev-parse --show-toplevel)
-include .env

# Override default ARM toolchain for linux target.
# On MacOS assume homebrew installed toolchain.
ifeq ($(shell uname -s),Darwin)
	# On MacOS the tooling doesn't have the -none- bit.
	CROSS ?= arm-linux-gnueabihf-
	TC_DIR ?= $(shell brew --prefix arm-linux-gnueabihf-binutils)
else
	CROSS ?= arm-none-linux-gnueabihf-
endif

TARGET ?= LINUX
TARGETS = LINUX
DIST_TARGET ?= arm-linux
ifeq ($(strip $(TARGET)), LINUX)
MCU_LD ?= linux.ld
else
$(error Unknown TARGET '$(TARGET)')
endif

# Included after various configuration bits are defined (importantly MCU_LD)
include $(AMFORTH)/arm/dev/Makefile

LDFLAGS += -no-pie -static -z max-page-size=4096

# To run amforth in emulated container you can use a container runtime that supports --platform linux/arm/v7
# For MacOS check out https://orbstack.dev/ (Free for personal use)
# See Dockerfile for the details of what goes into the container image, tweak to heart's desire.
## Build docker image with AmForth (see Dockerfile)
image:
	docker build --tag amforth:latest .

# Starts the amforth container with a terminal session.
# Once terminal to the container opens you can start amforth, the binary is on the PATH.
# The whole host amforth directory is mounted in the container at /amforth.
# Apparently cannot run gdb inside the container, because ptrace sys call is not supported in emulation.
DOCKER = docker run --rm --volume $(AMFORTH):/amforth
## Run AmForth in docker container
drun: image
	$(DOCKER) --interactive --tty amforth:latest

# Run standard tests and output the results, requires WANT_IGNORECASE enabled above
# because the standard tests are in all caps and all amforth words are in lowercase.
# Run with: `WANT_IGNORECASE=1 make dtest`
## Run standard tests (in Docker), output failures and summarize the results
dtests: image
	$(DOCKER) amforth:latest /bin/sh -c ' \
		cd amforth/arm/mcu/linux; \
		cpp -w -E --no-line-commands -x assembler-with-cpp \
			-I /amforth /amforth/tests/tests.frt > build/tests.frt; \
		cat build/tests.frt \
		| amforth \
		| tee build/tests.log \
		| awk -f /amforth/tests/results.awk '

# On Linux hosts a convenient way to run the Linux target is using qemu-user-static.
# The distribution should have the package available for installation.
QEMU ?= qemu-arm-static
QEMU_TESTS = $(QEMU) build/amforth.elf

## Starts amforth under qemu-user-static (Linux only)
run:
	$(QEMU) build/amforth.elf

## Like run but allows GDB to attach to it (-g); starts halted, needs to be resumed from GDB.
debug:
	$(QEMU) -g 1234 build/amforth.elf

## Connect GDB to running amforth (must be running with -g, see debug)
gdb:
	$(GDBPY) build/amforth.elf --quiet \
		-ex 'target remote localhost:1234' \
		-ex "source tui-full.gdb"

# Starts amforth under qemu-system.
# WARNING(mk): This seems incomplete and does not work at least on MacOSX;
#   tried many things to get raspios emulation going, but no luck so far :/
# setup some terminal settings. Otherwise all input will be echo'ed
# MACHINE = raspi2b
# IMAGE = 2025-12-04-raspios-trixie-armhf-lite.img
# KERNEL = kernel8.img
# DTB = bcm2709-rpi-2-b.dtb
# QEMU ?=qemu-system-arm
# run: build/amforth
# 	qemu-img resize build/amforth 128k
# 	stty -icanon -echo
#  	$(QEMU) -machine raspi2b -display none -serial mon:stdio  || true
# 	$(QEMU) -machine $(MACHINE) -kernel $(KERNEL) -dtb $(DTB) -sd $(IMAGE) -nographic \
# 		-append "rw earlyprintk loglevel=8 console=ttyAMA1,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1" \
# 		|| true
# 	$(QEMU) -cpu arm1176 -m 256 -M versatilepb
# 		-kernel qemu/kernel-qemu-5.10.63-bullseye \
# 		-dtb mcu/linux-arm/qemu/versatile-pb-bullseye-5.10.63.dtb \
#     	-drive "file=$(IMAGE),if=none,index=0,media=disk,format=raw,id=disk0" \
#     	-device 'virtio-blk-pci,drive=disk0,disable-modern=on,disable-legacy=off' \
# 	    -net 'user,hostfwd=tcp::5022-:22' -net nic \
# 	    -append 'root=/dev/vda2 panic=1' \
#     	-no-reboot \
#     	-nographic || true
# 	stty sane

# NOTES
#
# ## Raspberry Pi OS Lite
# To get necessary image, kernel, dtb files for Raspbery PI emulation:
# * download the 32-bit Raspberry Pi OS Lite from https://www.raspberrypi.com/software/operating-systems/
# * decompress it (xz), mount it, and in the boot partition find:
#   * dtb file corresponding to raspi you want, e.g. for raspi2b bcm2709-rpi-2-b.dtb
#	* the kernel file, e.g. kernel8.img
#
# * https://interrupt.memfault.com/blog/emulating-raspberry-pi-in-qemu
#
# ## Alpine Linux
# * https://wiki.alpinelinux.org/wiki/Install_Alpine_in_QEMU
# * https://github.com/keygenqt/skill-qemu-alpine
