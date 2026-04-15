# Generic make targets for building amforth in a unified way.
# Requirements:
# 1) toolchain was installed (see make toolchain in {rv|arm}/dev/Makefile)
# 2) {arm|rv}/dev/Makefile was included (to set CROSS, TC_DIR,...)
# 3) MCU_LD must be set to the name of the MCU linker script
#	e.g. MCU_LD = stellaris.ld
#
# Included through {arm|rv}/dev/Makefile

AMFORTH ?= $(shell git rev-parse --show-toplevel)

BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
COMMIT := $(shell git rev-parse --short HEAD)
MODIFIED := $(shell git diff --quiet HEAD || echo "*")
# Set REVISION to current branch name followed by the short ID of the HEAD commit,
# add asterix at the end if there were modified files present.
# example: main@0e24376*
REVISION := $(BRANCH)@$(COMMIT)$(MODIFIED)
ifeq ("$(REVISION)", "")
    REVISION := $(shell svnversion -n)
endif

# These are implicit variables in make, can't use ?=
# see https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html
AS := $(TC_DIR)/bin/$(CROSS)as
LD := $(TC_DIR)/bin/$(CROSS)ld
CC := $(TC_DIR)/bin/$(CROSS)gcc
CXX := $(TC_DIR)/bin/$(CROSS)g++
CPP := $(TC_DIR)/bin/$(CROSS)cpp

# Tools that can be overridden by the environment
PP ?= $(CPP) # to allow overriding the pre-processor (use PP instead of CPP)
OBJCOPY ?= $(TC_DIR)/bin/$(CROSS)objcopy
OBJDUMP ?= $(TC_DIR)/bin/$(CROSS)objdump
READELF ?= $(TC_DIR)/bin/$(CROSS)readelf
RANLIB ?= $(TC_DIR)/bin/$(CROSS)ranlib
NM ?= $(TC_DIR)/bin/$(CROSS)nm
SIZE ?= $(TC_DIR)/bin/$(CROSS)size

# Debugging tools
GDB ?= $(TC_DIR)/bin/$(CROSS)gdb -ex "directory $(AMFORTH)/core/dev" -ex "directory ../../dev"
# For some reason the Python enabled GDB is called -py3 for riscv and -py for arm :/
ifneq (,$(filter arm-%, $(CROSS)))
GDBPY ?= $(TC_DIR)/bin/$(CROSS)gdb-py -ex "directory $(AMFORTH)/core/dev" -ex "directory ../../dev"
else
GDBPY ?= $(TC_DIR)/bin/$(CROSS)gdb-py3 -ex "directory $(AMFORTH)/core/dev" -ex "directory ../../dev"
endif

#? --- Common ---

# Credit to below
# https://github.com/wuxx/CH32V003-makefile-example

# COLORS
BLACK  := $(shell tput -Txterm setaf 0)
RED    := $(shell tput -Txterm setaf 1)
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
VIOLET := $(shell tput -Txterm setaf 5)
AQUA   := $(shell tput -Txterm setaf 6)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

TARGET_MAX_CHAR_NUM=12

## Show help
help:
	@echo ''
	@echo 'USAGE: [TARGET=${YELLOW}<build target>${RESET}] make${RESET} ${GREEN}<make target>${RESET}'
	@echo '<build target> is one of { ${YELLOW}$(TARGETS)${RESET} }; default ${YELLOW}$(TARGET)${RESET}'
	@echo ''
	@echo 'Make targets:'
	@awk '/^#\? / { \
	text = substr($$0, 4); \
	printf "  %s\n", text; \
	} \
	/^[a-zA-Z\-_0-9]+:/ { \
	helpMessage = match(lastLine, /^## (.*)/); \
	if (helpMessage) { \
	helpCommand = substr($$1, 0, index($$1, ":")-1); \
	helpMessage = substr(lastLine, RSTART + 2, RLENGTH); \
	printf "  ${GREEN}%-$(TARGET_MAX_CHAR_NUM)s${RESET}\t%s${RESET}\n", helpCommand, helpMessage; \
	} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@echo ''

## Build all files
all: config build/amforth.bin build/amforth.hex build/amforth.lst build/amforth.sal build/amforth.sym build/amforth.toc build/amforth.txt build/amforth.html
	@echo INFO: Built $(TARGET) $(REVISION) using $(TC_DIR)
	@$(SIZE) build/amforth.elf
	@cd build && ls -l amforth.bin amforth.hex amforth.elf


buildinfo:
	@echo "REBUILD $@"
	@cat $(AMFORTH)/core/build-info.tmpl | sed "s/%d/`date -Iseconds`/" | sed "s/%r/${REVISION}/" > words/build-info.s
	@mkdir -p build

# Basic assembly flags and defining TARGET_XXX symbol.
# String value symbols cannot be defined through command line, so TARGET=XXX wouldn't work.
ASFLAGS += -g --warn --fatal-warnings -ahlmn=build/amforth.lst-as --defsym TARGET_$(TARGET)=1
# if you want to run standard tests you need WANT_IGNORECASE flag set
ifdef WANT_IGNORECASE
ASFLAGS +=--defsym WANT_IGNORECASE=1
endif

# Needed for the INCLUDE amforth32.ld to work in linked files (-L must precede the -T !!!)
LDFLAGS += -L $(AMFORTH)/core -T $(MCU_LD) -Map build/amforth.map

# The include order is important: architecture > core > AMFORTH.
# For simple imports, e.g. config.inc or words/xx.s, the more specific directory wins.
# AMFORTH root allows include files to import more general include files with the same name.
ifdef WANT_ITC
INCLUDES := -I $(AMFORTH)/core -I ../.. -I $(AMFORTH)
else
INCLUDES := -I ../.. -I $(AMFORTH)/core -I $(AMFORTH)
endif
build/%.o: %.s buildinfo
	@echo "REBUILD $@"
	$(AS) $(ASFLAGS) $(INCLUDES) -o $@ $<

# Sometimes make decides that amforth.elf is an intermediary file that should be deleted.
.PRECIOUS: build/amforth.elf build/amforth.dep

build/%.elf: build/%.o
	@echo "REBUILD $@"
	$(LD) $(LDFLAGS) $< -o $@ 

build/%.hex: build/%.elf
	@echo "REBUILD $@"
	@$(OBJCOPY) -O ihex $< $@

build/%.bin: build/%.elf
	@echo "REBUILD $@"
	@$(OBJCOPY) -O binary $< $@
	test `wc -c <$@` -lt 100000

build/%.lst: build/%.elf
	@echo "REBUILD $@"
	@$(OBJDUMP) --show-raw-insn --insn-width=4 --section-headers --file-headers --disassemble $< >$@

# list all transitive dependencies of amforth.s (include tree traversal)
# the file paths are adjusted to be relative to $(AMFORTH)
build/%.dep: buildinfo
	@echo "REBUILD $@"
	@$(AS) $(ASFLAGS) $(INCLUDES) -MD $@.wrk -o /dev/null amforth.s
	@sed -e 's|^/dev/null:||; s/ \\//; s/^ //; s/ /\n/g' $@.wrk >$@
	@mv $@ $@.wrk
	@ # AMFORTH env var somehow isn't visible to awk on CI without explicitly including it here
	@AMFORTH=$(AMFORTH) awk -f $(AMFORTH)/core/dev/dep.awk $@.wrk >$@
	@rm $@.wrk

# table of contents: headers and location of all words in files listed by amforth.dep
build/%.toc: DEPS = $(shell cat $<)
build/%.toc: TOC = $(abspath $@)
build/%.toc: build/%.dep
	@echo "REBUILD $@"
	@cd $(AMFORTH) && awk -f core/dev/toc.awk $(DEPS) >$(TOC)
	@echo 'VALUE "environment", ENVIRONMENT /* FFA of last word; standard environment search list */ @ core/macros.inc' >>$@
	@echo 'VALUE "forth-wordlist", FORTH_WORDLIST /* FFA of last word; system default wordlist */ @ core/macros.inc' >>$@
	@echo 'VALUE "arch-wordlist", ARCH_WORDLIST /* FFA of last word; architecture specific words */ @ core/macros.inc' >>$@
	@echo 'CONSTANT "core-wordlist", CORE_WORDLIST /* FFA of last word; core words compiled at build time */ @ core/macros.inc' >>$@

build/%.txt: build/%.toc
	@echo "REBUILD $@"
	@$(AMFORTH)/tools/refcard.py >$@

build/%.html: build/%.toc
	@echo "REBUILD $@"
	@$(AMFORTH)/tools/refcard.py --html >$@
	@mkdir -p $(AMFORTH)/dist/refcards
	@cp $@ $(AMFORTH)/dist/refcards/$(ARCH)-$(TARGET).html

SORT_SYMS_BY_ADDRESS := grep -E '^[0-9a-f]{8} .*' | \
	awk '{ printf "0x%s\n",$$0; }' | \
	sort --key=1 --sort=numeric

# symbol and line info
build/%.sal: build/%.elf
	@echo "REBUILD $@"
	@$(NM) --line-numbers $< | $(SORT_SYMS_BY_ADDRESS) >$@

# full symbol dump
build/%.sym: build/%.elf
	@echo "REBUILD $@"
	@$(OBJDUMP) --syms $< | $(SORT_SYMS_BY_ADDRESS) >$@

## Delete the build artifacts
clean:
	rm -f build/* words/build-info.s

.PHONY: buildinfo clean config shell tests

## Make distribution tarball for the target (expects VERSION and DIST_TARGET)
dist: all
	mkdir -p $(AMFORTH)/dist
	cp readme.md $(AMFORTH)/LICENSE.txt $(AMFORTH)/tools/amforth-shell.py build/
	cd build && tar -zcf $(AMFORTH)/dist/amforth32-$(VERSION)-$(DIST_TARGET).tgz *

## Show build configuration
config:
	@echo ""
	@echo "Build Configuration:"
	@echo "  ${GREEN}TARGET${RESET} \t= $(TARGET)"
	@echo "  ${GREEN}REVISION${RESET} \t= $(REVISION)"
	@echo "  ${GREEN}MCU_LD${RESET} \t= $(MCU_LD)"
	@echo "  ${GREEN}CROSS${RESET} \t= $(CROSS)"
	@echo "  ${GREEN}TC_DIR${RESET} \t= $(TC_DIR)"
	@echo "  ${GREEN}Includes${RESET} \t="
	@echo "\t$(INCLUDES)" | sed 's/ -I/\n\t-I/g'
	@echo ""

SPEED ?= 115200
AMSHELL=$(AMFORTH)/tools/amforth-shell.py --port $(MODEM) --speed $(SPEED) $1
export AMFORTH_LIB=.:$(AMFORTH)/tests:$(AMFORTH)/lib:$(AMFORTH)/examples

## Connect via AmShell (needs MODEM)
shell:
	# export EDITOR in your .env file to make the #edit shell directive work.
	$(AMSHELL) --no-error-on-output --sym-file build/amforth.sym -i

# Running full test suite:
# Not finished means we didn't get through the whole test file.
# Requires WANT_IGNORECASE, because the standard tests
# are in all caps and all AmForth words are in lowercase;
# `WANT_IGNORECASE=1 make` should do it.
# Uses timeout command to terminate QEMU, because there is no way
# to do it from the inside, i.e. from AmForth running in it.
# WARNING: some of the tests can run destructive operations,
# don't run against real MCUs without reviewing the tests.
SKIP := $(PP) -w -E --no-line-commands -x assembler-with-cpp
QEMU_TESTS ?= $(QEMU) -display none -serial stdio
## Run standard tests, output failures and summarize the results (QEMU only)
tests: TIMEOUT ?= 10s
tests:
	$(SKIP) -I $(AMFORTH) $(AMFORTH)/tests/tests.frt > build/tests.frt
	cat build/tests.frt \
	| timeout -s TERM $(TIMEOUT) $(QEMU_TESTS) | \
	tee build/tests.log | \
	awk -f $(AMFORTH)/tests/results.awk

## Run test file $(TEST), output failures and summarize the results (QEMU only)
test: TIMEOUT ?= 1s
test: TESTER ?= $(AMFORTH)/tests/tester.frt
test:
	@{ cat $(TESTER); \
	  echo '\ TESTS STARTING' ; \
	  cat $(AMFORTH)/tests/$(TEST); \
	  echo '\ TESTS FINISHED' ; \
	} | timeout -s TERM $(TIMEOUT) $(QEMU_TESTS) | \
	tee build/tests.log | \
	awk -f $(AMFORTH)/tests/results.awk

## Run tests-mcu.frt through amforth-shell on hardware 
tests-mcu:
	# export EDITOR in your .env file to make the #edit shell directive work.
	$(SKIP) -I $(AMFORTH) $(AMFORTH)/tests/tests-mcu.frt > ./build/tests-mcu.frt
	$(AMSHELL) -I $(AMFORTH) --no-error-on-output --sym-file build/amforth.sym  \
    --tee ./build/tests-mcu.log ./build/tests-mcu.frt
	awk -f $(AMFORTH)/tests/results-mcu.awk ./build/tests-mcu.log

## Detailed dump of ELF sections for debugging linker issues
sections: sec-type sec-addr sec-sum

sec-type:
	# SECTION TYPES:
	# Type:
	# 	PROGBITS: Program data (code, initialized constants).
	#	NOBITS: Occupies no space in the file (e.g., .bss, NOLOAD).
	#	SYMTAB / STRTAB: Symbol tables and string tables for debugging.
	# Flags:
	#	W (write): The processor is allowed to write to this memory address (RAM).
	#	A (alloc): This section is "allocated"—it exists in the memory map of the device at runtime.
	#	X (execute): This section contains code that the CPU can run.
	#	M (merge): The linker may merge duplicate data to save space (common in strings).
	#	S (strings): The section contains null-terminated strings.
	# ES - entry size for table sections (fixed sized elements)
	# Lk - index number of a linked section (relocations, symbol tables)
	# Inf - extra info (relo & symtables)
	# Al - section Addr alignment in bytes (must be 2^n)
	$(READELF) --sections build/amforth.elf

sec-addr:
	# SECTION ADDRESSES:
	# Flags: Name | Description [ Linker Script / ELF Equivalent ]
	# 	CONTENTS	The section has actual data stored in the file. [ SHT_PROGBITS ]
	#	ALLOC		Space must be reserved for this section in RAM/Flash at runtime. [ SHF_ALLOC (the A flag) ]
	#	LOAD		This section should be loaded into memory from the file. [ Not NOLOAD ]
	#	READONLY	The section cannot be modified at runtime (usually in Flash). [ Missing SHF_WRITE ]
	# 	CODE		Contains executable CPU instructions.	[ .text ]
	#	DATA		Contains initialized variables or constants.	[ .data, .rodata ]
	#	DEBUGGING	Contains DWARF or stabs info for GDB (not loaded).	[ .debug_info ]
	#	HAS_CONTENTS	Similar to CONTENTS; implies the section isn't empty.	[ Various ]
	$(OBJDUMP) -h build/amforth.elf

sec-sum:
	# SECTION SIZE SUMMARY:
	$(SIZE) build/amforth.elf
	$(SIZE) build/amforth.elf

# Segments are used by linux kernel to allocate memory to the amforth process.
## Dump program headers / segments
segments:
	$(READELF) --segments build/amforth.elf

## Dump symbols sorted by address, optionally filtered by section (e.g. sec=amramlo)
symbols:
	# Value Flags[7] Section Size Symbol
	# Flags[0]: (l,g,,!) local, global, neither, both.
	# Flags[1]: (w,) weak or strong symbol.
	# Flags[2]: (C,) symbol denotes a constructor or an ordinary symbol.
	# Flags[3]: (W,) symbol is warning or normal symbol.
	# Flags[4]: (I,) indirect reference to another symbol or normal symbol.
	# Flags[5]: (d,D,) debugging symbol, dynamic symbol or normal symbol.
	# Flags[6]: (F,f,O,) symbol is the name of function, file, object or normal symbol.
	@$(OBJDUMP) --syms build/amforth.elf $(if $(sec), | grep $(sec),) | \
		grep -E '^[0-9a-f]{8} .*' | \
		awk '{ printf "0x%s\n",$$0; }' | \
		sort --key=1 --sort=numeric

## Dump contents of the debug info sections
debug_info:
	$(READELF) --debug-dump build/amforth.elf

## List word files that were not used in the last build (based on the .dep file)
unused: FILTERS = -v -e '\.inc$$' -e '\.tmpl$$' -e '/amforth\.s$$'
unused:
	# files will also show up as unused when there is both native and ITC version
	@echo $(AMFORTH)/core/*.s $(AMFORTH)/core/words/* ../../words/* ../../*.s words/* | \
	sed -e 's/ /\n/g' | \
	AMFORTH=$(AMFORTH) awk -f $(AMFORTH)/core/dev/dep.awk | \
	egrep $(FILTERS) | sort >build/word-files
	@egrep $(FILTERS) build/amforth.dep | sort | \
	diff -U0 build/word-files - | \
	egrep -v -e '^(@@|\+\+\+|---) '
	@rm build/word-files
