# SPDX-License-Identifier: GPL-3.0-only

.include "core/config.inc"

.if TARGET_LM4 == YES

/* TODO: this is made up, needs correcting */
.equ flash_page, 1*1024
.equ flash_cell, 4
.equ flash_erased, 0xFFFFFFFF /* a word in erased flash */

/* SysTick uses the 16 MHz processor clock on LM4F120. */
.equ SYSTICK_TICKS_PER_MS, 16000

.endif

.if TARGET_LM3QEM == YES

/* SysTick uses the 20 MHz processor clock on lm3s6965 QEMU machine */
.equ SYSTICK_TICKS_PER_MS, 20000

.endif
