# AmForth 32-bit

This directory contains the shared basis of all 32-bit versions of AmForth.

AmForth is assembled by combining the words in `core/words/` with ARM/RISC-V architecture specific words (`rv/words/`, `arm/words/`)
and with architecture compatible MCU specific words, e.g.
* core/words/ + rv/words/ + rv/mcu/ch32v307/words/ (CH32 board), or
* core/words/ + arm/words/ + arm/mcu/lm4f120/words/ (Stellaris Launchpad board)

Specific word files are selected by `dict_*.inc` files. The main file that pulls everything together is MCU specific `amforth.s` file, e.g. `arm/mcu/ra4m1/amforth.s`.

The build process is driven by Makefile commands in `core/dev/Makefile`. Use `make help` or just `make` (executed in an MCU directory) to see the list of available commands with brief descriptions. Architecture or MCU specific `Makefiles` add commands that are specific to that level. Comments in the `Makefiles` provide further details.


# Directory layout

The picture below shows the relevant bits of the AmForth directory structure [^2] with `words/` and other directories stripped out.

```
core                = core AmForth files; shared by all architectures and MCUs
├── dev             = development utilities
│   ├── categories  = defines refcard categories and order
│   └── Makefile    = shared build targets (included by MCU Makefile)
├── amforth32.ld    = shared linker file; defines the 32-bit memory layout (SECTIONS)
├── amforth32.s     = shared assembler file; early build-time setup
├── build-config.inc  = assembles final BUILD_CONFIG flags value
├── config.inc      = core configuration parameters (included by MCU config.inc)
├── dict_env.inc    = includes shared environment wordlist words
├── dict_prims.inc  = includes common primary words required by other core/words (see [^1])
├── dict_secs.inc   = includes all secondary core/words; defines most of core functionality
├── macros.inc      = shared macros (e.g. dictionary); included by arch macros.inc
└── user.inc        = shared user area words

arm                 = ARM Cortex-M based MCUs
├── amforth.s       = template main source file to be used to start new boards
├── dev             = development utilities
│   └── Makefile    = ARM targets, e.g. toolchain (included my MCU Makefile)
├── mcu
│   ├── linux              = generic linux/raspberry Pi
│   ├── lm4f120            = TI's LM4F Series MCU & Stellaris® LM4F120 LaunchPad
│   │   ├── amforth.s      = main MCU source file
│   │   ├── config.inc     = MCU configuration, includes core/config.inc
│   │   ├── dict_mcu.inc   = MCU specific words
│   │   ├── stellaris.ld   = MCU linker file defines MEMORY, and INCLUDEs core/amforth32.ld
│   │   ├── Makefile       = MCU targets, e.g. upload, run, debug
│   │   └── readme
│   ├── qemu               = ARM QEMU -M virt target
│   └── ra4m1              = Renesas RA4M1 & Arduino Uno R4 board
├── amforth.s       = template for new ARM MCUs
├── arch_prims.inc  = includes ARM specific words
├── interpreter.s   = inner interpreter for ARM
└── macros.inc      = ARM specific macros; includes core/macros.inc

rv                  = RISC-V based MCUs
├── amforth.s       = template main source file to be used to start new boards
├── dev
│   └── Makefile    = RISC-V targets, e.g. toolchain
├── mcu
│   ├── ch32v307    = WCH CH32V307 board
│   └── qemu        = RISC-V QEMU -M virt target
├── amforth.s       = template for new RISC-V MCUs
├── arch_prims.inc  = includes RISC-V specific words
├── interpreter.s   = inner interpreter for RISC-V
└── macros.inc      = RISC-V specific macros; includes core/macros.inc
```

[^1]: `dict_prims.inc` includes `interpreter.s` so that the interpreter code resides in the middle of the prim words (cpu caching reasons);
    it also includes `arch_prims.inc` so that arm/rv can add more generic architecture prim words

[^2]: initially generated with `tree --prune -I 'words|build|dev|touch1200bps' core arm rv`

## Directory conventions

* `words/`: source files of forth words
* `dev/`: supporting utilities for AmForth development, e.g. gdb extensions, shared Makefile bits, etc.
* `tools/`: runnable tools aimed for various supporting tasks, communication, docs, etc (preferably written in Python)
* `build/`: directory for compilation artifacts, excluded from the repository

## File conventions

Words can be implemented in two ways: native assembler code, or universal ITC code.

Native assembler words, also called code-words are specific to given CPU architecture. This form is used mainly for the primary words, the basic operations that need to be reimplemented for every CPU architecture.

Universal ITC words, also called colon-words, are implemented only once and can be executed on any CPU architecture. This form is used primarily for the secondary words, i.e. words that are implemented using other words. The ITC code is technically also assembler, but it doesn't use assembler instructions.
Instead it mimics the result of compiling a word written in Forth, and thus is basically a data structure from assembler's point of view.

* `*.s, *.S`: assembler source files, either code-words (assembler), or colon-words (ITC assembler)
* `amforth.s`: the main AmForth source file (usually one for each MCU)
* `*.inc`: include files; shouldn't contain code, just directives and constant definitions
* `dict_*.inc`: shared lists of AmForth word files, define the contents of the pre-compiled dictionary
* `arch_*.inc`: includes additional words specific to MCU architecture, follows the prims words in flash memory
* `mcu/*.inc`: config files for specific boards/targets
* `amforth32.ld`: the main linker file; defines the basic AmForth 32-bit memory layout
* `*.ld`: MCU target/board specific linker file; configures amforth32.ld options and defines the MEMORY regions

# Linker files

The final assembly of AmForth binary is controlled by linker files. The core linker file `amforth32.ld` defines the memory layout described above. The MCU linker files primarily define the specific memory regions of the corresponding target/board and include `amforth32.ld` to allocate the required memory sections.
There will be a separate linker file for each MCU target.

## Linker symbols

Note that while symbols defined in linker files can be referenced in assembler files, their nature constrains their usage.
Primarily it means that they cannot be used as immediate values in assembler code.

This is because the assembler processes source code before the linker, so it can't resolve symbols defined only in the linker script when used as immediates. Immediates must be known at assembly time, while linker symbols are resolved later during linking. Using linker symbol improperly fails with confusing error `"Unknown symbol"`. The issue might be that the symbol exists but is used improperly (in a way that would require embedding it into the instruction opcode, as opposed to an instruction "argument" that the linker can handle).

# Code conventions

Every pre-compiled word should have a comment on the same line as the word definition macro containing the stack signature and short description. This line is used to generate the reference card. Example:
```
CODEWORD "rdepth", RDEPTH /* ( -- n ) n is current dept of the return stack */
```
The comment must use the `/* .. */` format to be compatible with both ARM and RV assembler. A longer description optionally follows this header line, again enclosed in `/* .. */`.

`#` can be used as comment marker when it is the first character on the line, or the first character after the label.

The word definition must end with the `END` macro (it allows emitting proper function blocks for words). The `END` macro requires the same symbol argument that was used to start the word definition.

`NONAME` and `HEADLESS` macro invocations must include a name argument. The name is not included in the word definition but it is used when transpiling Forth code to ITC. `NONAME` and `HEADLESS` words are excluded from the reference card, but should still have the standard comment line.
