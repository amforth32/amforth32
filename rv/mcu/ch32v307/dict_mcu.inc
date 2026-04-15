# SPDX-License-Identifier: GPL-3.0-only

# MFD wrong chip .include "words/pll.s"

.include "words/usart.s"
.include "words/gpio.s"

.include "words/led.s"
.include "words/blink.s"

.include "words/applturnkey.s"

.include "words/type0.s" 

.if WANT_SYSTICK
.include "words/systick.s"
.endif

.include "words/reset.s"

.if WANT_TIMER6
.include "words/t6.s"
.include "words/t8.s"
.include "words/t9.s"
.endif

.include "words/usb.s"

.if WANT_FLOAT
    .include "words/float.s"
.endif

#.include "words/pc.s"
#.include "words/fast.s"

.include "words/wordswap.s"
