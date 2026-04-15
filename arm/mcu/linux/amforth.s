
.include "config.inc"
.include "build-config.inc"
.include "arm/macros.inc"
.include "user.inc"

.syntax unified

.align 4
.text
.global _start
_start:
  ldr r0, =PFA_ARGV  @ Save the initial stack pointer, as it contains
  str sp, [r0]       @ command line arguments. Do this only once on first entry.

  ldr r0, =PFA_COLD
  bx r0 @ Switch to thumb mode

/*
  It seems qemu-arm-static really dislikes having a tiny text segment, next to the large forth segment.
  The small .text section ends up not loading correctly, it is allocated but filled with zeros, thus segfault.
  It seems allocating a page-worth of bytes in the intervening .data section helps the qemu elf loader work correctly.
*/
.data
.space 0x1000
.align 8

.thumb

.section amforth, "awx" @ Everything is writeable and executable

STARTDICT

.include "dict_prims.inc"
.include "dict_secs.inc"
.include "dict_env.inc"
.include "dict_mcu.inc"

ENDDICT
