# SPDX-License-Identifier: GPL-3.0-only

.include "core/config.inc"

.ifdef TARGET_LM4
/* TODO: this is made up, needs correcting */
.equ flash_page, 1*1024
.equ flash_cell, 4
.equ flash_erased, 0xFFFFFFFF /* a word in erased flash */
.endif
