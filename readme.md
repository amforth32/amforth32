![ARM](https://github.com/amforth32/amforth32/actions/workflows/arm-build.yaml/badge.svg)
![ARM/Linux](https://github.com/amforth32/amforth32/actions/workflows/arm-linux-build.yaml/badge.svg)
![RISC-V](https://github.com/amforth32/amforth32/actions/workflows/rv-build.yaml/badge.svg)

This is a fork of https://sourceforge.net/p/amforth/code/2462/.

The purpose is to advance the 32-bit ARM and RISC-V variants of AmForth.

For more information see the [documentation](https://amforth32.github.io/amforth32/) and the READMEs in the respective directories:

* [core/](core) - the shared 32-bit AmForth core
* [arm/](arm) - the ARM architecture core (Cortex M3/4)
* [rv/](rv) - the RISC-V architecture core
* rv/mcu/..., arm/mcu/... - AmForth for different boards and targets

Pre-built binaries for various targets are available as Github releases.

## Available MCUs/Boards

### RISC-V 32

* [WCH CH32V307 / dev board v307, v305, v203 ](rv/mcu/ch32v307) @[refcard](https://amforth32.github.io/amforth32/refcards/rv/rv-307.html)
* [Generic RISCV-32 / QEMU -M virt](rv/mcu/qemu) @[refcard](https://amforth32.github.io/amforth32/refcards/rv/rv-QEM.html)


### ARM 32

* [Renesas RA4M1 / Arduino UNO R4](arm/mcu/ra4m1) @[refcard](https://amforth32.github.io/amforth32/refcards/arm/arm-UNOR4.html)
* [TI LM4F120 / Stellaris Launchpad (+QEMU emulation)](arm/mcu/lm4f120) @[refcard](https://amforth32.github.io/amforth32/refcards/arm/arm-LM4.html)
* [Generic ARM-32 / Linux, Raspberry PI (+Docker emulation)](arm/mcu/linux) @[refcard](https://amforth32.github.io/amforth32/refcards/arm-linux/arm-LINUX.html)
* [Generic ARM-32 / QEMU -M virt](arm/mcu/qemu) @[refcard](https://amforth32.github.io/amforth32/refcards/arm/arm-QEM.html)

From the original AmForth README:

```

Author:
    Matthias Trute <mtrute@users.sourceforge.net>
    died 2020-03-25

Maintainer:
    2025-     Tristan Williams
    2020-2022 Erich Wälde <erwaelde@users.sourceforge.net>

Major Contributors:
    Erich Waelde
    Michael Kalus
    Leon Maurer
    Ullrich Hoffmann
    Karl Lund
    Enoch
    Bradford Rodriguez (MSP430 code from Camelforth 0.5)
    Matthias Koch (RV32IM + ARM Code from mecrisp)
    Tristan Williams

License: General Public License (GPL) Version 3 from 2007. See the
file LICENSE.txt or http://www.gnu.org/licenses/gpl.html. This
license applies to all files unless a file has some different
attribution in it.

AmForth is an interactive Forth for various controllers
It does not need additional hard or software. It works 
completely on the controller (no cross-compiler). AmForth 
uses the indirect threading forth implementation technique.

...

Documentation can be found in the doc/ subdirectory and
on the homepage http://amforth.sourceforge.net/.

Contact, bug reports, questions, wishes etc:
    mailto:amforth-devel@lists.sourceforge.net

```