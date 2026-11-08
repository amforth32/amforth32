# Agent guide

## Project map

AmForth 32 is a Forth system assembled from shared, architecture, and MCU-specific sources:

- `core/` contains the shared 32-bit Forth implementation, common words, configuration, linker layout, and build utilities.
- `arm/` contains the Thumb-2 ARM Cortex-M architecture layer and targets in `arm/mcu/` (Linux, QEMU virt, LM4F120/LM3 QEMU, and RA4M1/UNO R4).
- `rv/` contains the RV32IM architecture layer and targets in `rv/mcu/` (QEMU virt and WCH CH32V307 variants).
- `core/words/`, `arm/words/`, `rv/words/`, and each target's `words/` provide the dictionary words. `dict_*.inc` files select which words are assembled into a target.
- `lib/`, `examples/`, and `tests/` contain Forth libraries, examples, and test programs. `tools/` contains host-side utilities. `dist/` contains generated reference cards and release artifacts.

Each MCU directory is a build entry point. Its `amforth.s`, configuration, dictionary include, and linker script combine with the shared and architecture layers. Build artifacts go under that target's `build/` directory; do not commit generated build output unless explicitly requested.

## Build workflow

Run Make from the MCU directory being built. The MCU Makefile sets target-specific configuration and includes `arm/dev/Makefile` or `rv/dev/Makefile`, which in turn includes `core/dev/Makefile`.

- `make help` lists the targets and default build target in the current MCU directory.
- `make config` prints the selected target, linker script, cross-toolchain, and include paths.
- `make toolchain` installs the architecture cross-toolchain under `toolchain/` when needed.
- `make` or `make all` builds the ELF, BIN, HEX, listing, symbols, dependencies, and text/HTML reference card.
- `make clean` removes generated files under that target's `build/` and `words/build-info.s`.
- QEMU targets commonly provide `make stdio`, `make pty`, `make debug`, and `make gdb`; check that MCU's Makefile and `make help` for exact support.
- `make tests` runs the standard suite under QEMU. Use `WANT_IGNORECASE=1 make tests` because the standard test sources use uppercase word names. `make test TEST=<name>` runs an individual test file from `tests/`.
- `make tests-mcu` uses the attached physical board and serial configuration. Target-specific commands such as `upload`, `boot`, `ocd`, and `shell` may communicate with or modify real hardware; inspect the selected target and its README before using them.
- The Linux ARM target also defines `dtests`, `drun`, and `run`; target-specific Makefiles may override or extend shared target behavior.

Cross-toolchain defaults and setup are defined in `arm/dev/Makefile` and `rv/dev/Makefile`. MCU Makefiles may use a local, git-ignored `.env` for serial ports and programmer/debugger paths. Do not overwrite or expose local `.env` settings.

## Editing guidance

- Read the nearest `readme.md`, target Makefile, and relevant `config.inc`, `dict_*.inc`, and linker script before changing target behavior. The root and `core/readme.md` explain the overall layout and assembly model.
- Preserve the source layering: common functionality belongs in `core/`, CPU-specific code in `arm/` or `rv/`, and board/peripheral code in the relevant `mcu/<target>/` directory.
- A Forth word's same-line definition comment supplies its stack signature and reference-card description. Keep it in `/* ... */` form for compatibility with both assemblers. Close word definitions with the matching `END` macro; give `NONAME` and `HEADLESS` invocations their required name.
- Native code words are architecture-specific; ITC/colon words can be shared. Check dictionary include selection before adding a word so the correct targets include it.
- Linker scripts define symbols resolved at link time. Do not use linker-defined symbols where assembler-time immediate constants are required.
- ARM code is Thumb-2. Code-word entry points and cross-file jump targets must preserve Thumb interworking conventions described in `arm/readme.md`.
- Follow existing architecture register assignments in `arm/readme.md` and `rv/readme.md` when editing assembly.

## Verification

Prefer the narrowest relevant build or test from the affected MCU directory. QEMU test targets require the corresponding emulator and cross-toolchain. Do not run hardware upload or flash operations as a verification step unless the user specifically requested hardware programming. Report commands run and any missing local toolchain/emulator when summarizing changes.
