List of known issues and tasks that need to be done (by area)
Also look for TODO: in source files


# CORE

* review the default sizing of memory regions and sections (especially for the physical targets)
* review unused files (see make unused)

* remove PFA_ prefix from labels that aren't PFAs
* xxx_ram symbols => RAM_xxx symbols (otherwise should be underscore prefixed)
* all words should use the END macro to be proper function blocks (debug_info)
* proper, and extractable comments for all words
* add long word description to the html refcard as title attribute, so that it shows on hover

* leave stack vs interrupts
* sort out issues with `to` word (to.s/alto.s)
* header flags don't each need their own bit in FFA
* runtime defined values and defers are not the same as the compile time defined ones (getters, setters, default values)
* core/aligned.s vs arm|rv/aligned.s
* aligned.s and do-aligned.s are identical
* ud* is broken, what about d*, ud/ ? (need double tests)
* remove doxliteral.s in favor of doliteral.s
* clean up all harcoded cell size values, replace with cellsize symbol (including alignment directives)


# ARM

* `(exiti)` needs work
* better HW fault handling
* can we use LR as top of return stack?

## LM4F120

* review the settings of the various targets
* is flash.s only for lm4 or does it work for the lm3 targets too?

## RA4M1

* make sure FLASH_IMAGE_START is handled correctly

## LINUX

* make dtests is failing


# RISC-V

* CI caching of qemu installation (or maybe try docker instead?)

## CH32V307


# TOOLS

* amshell: make sure the `words` change didn't break autocomplete
* amshell: translate exception number to mnemonic
* amshell: reconsider the greedy echo loop in send_line()


# DOCS

* how to add a new MCU
* how to add a new ARCH
* conventions and standard practices
