# SPDX-License-Identifier: GPL-3.0-only

.include "core/config.inc"

.equ flash_page, 2*1024
.equ flash_cell, 8
.equ flash_erased, 0xFFFFFFFF /* a word in erased flash */

.equ returnstack_size, 256 * cellsize

# RA4 has non-rewritable code flash with 8 byte flash page.
.equ RA_FLASH, YES

.equ WANT_SEE , YES



