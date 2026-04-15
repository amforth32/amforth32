# RISC-V specific make targets
#
# Include in MCU Makefile like this:
# AMFORTH ?= $(shell git rev-parse --show-toplevel)
# include AMFORTH/rv/dev/Makefile

ARCH ?= rv
CROSS ?= riscv-none-elf-
AMFORTH ?= $(shell git rev-parse --show-toplevel)
HOST_OS ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')
HOST_ARCH ?= $(shell uname -m)
# The archive convention is to use arm64 and x64 (instead of x86_64)
HOST ?= $(HOST_OS)-$(if $(filter $(HOST_ARCH),x86_64),x64,$(HOST_ARCH))

# see https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/
TC_VER ?= 15.2.0-1
TC_DIR ?= $(AMFORTH)/toolchain/$(CROSS)$(TC_VER)

include $(AMFORTH)/core/dev/Makefile

#? --- Setup ---

ARCHIVE = xpack-$(CROSS)gcc-$(TC_VER)-$(HOST).tar.gz
URL = https://github.com/xpack-dev-tools/$(CROSS)gcc-xpack/releases/download/v$(TC_VER)/$(ARCHIVE)
## Install development toolchain in TC_DIR
toolchain:
	mkdir -p $(TC_DIR)
	curl -L $(URL) | tar zx -C $(TC_DIR) --strip-components=1
	# Validate that the binary was installed correctly and works
	$(AS) --version
