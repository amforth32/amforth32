# ARM specific make targets
#
# Include in MCU Makefile like this:
# AMFORTH ?= $(shell git rev-parse --show-toplevel)
# include AMFORTH/arm/dev/Makefile

ARCH ?= arm
CROSS ?= arm-none-eabi-
AMFORTH ?= $(shell git rev-parse --show-toplevel)
HOST_OS ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')
HOST_ARCH ?= $(shell uname -m)
# The archive convention is darwin for MacOS but nothing for Linux
HOST ?= $(if $(findstring linux, $(HOST_OS)),,$(HOST_OS)-)$(HOST_ARCH)
# Need to drop the trailing dash from CROSS
TC_TGT ?= $(CROSS:%-=%)

# See https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
TC_VER ?= 15.2.rel1
TC_DIR ?= $(AMFORTH)/toolchain/$(CROSS)$(TC_VER)

include $(AMFORTH)/core/dev/Makefile

#? --- Setup ---

# https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
ARCHIVE = arm-gnu-toolchain-$(TC_VER)-$(HOST)-$(TC_TGT).tar.xz
URL=https://developer.arm.com/-/media/Files/downloads/gnu/$(TC_VER)/binrel/$(ARCHIVE)
## Install development toolchain in TC_DIR
toolchain:
ifneq ($(and $(findstring darwin,$(HOST_OS)), $(findstring arm-linux-gnueabihf,$(TC_TGT))),)
	@echo "WARNING: arm-linux-gnueabihf for MacOS is not available from developer.arm.com"
	@echo "  Use homebrew instead: brew install arm-linux-gnueabihf-binutils"
	@echo "  and make sure to set TC_DIR and CROSS accordingly (see arm/mcu/linux/Makefile)"
	@exit 1
else 
	mkdir -p $(TC_DIR)
	curl -L $(URL) | tar -xJ -C $(TC_DIR) --strip-components=1
	# Verify that the tools are correctly installed
	$(AS) --version
endif