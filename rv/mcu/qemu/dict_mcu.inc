# SPDX-License-Identifier: GPL-3.0-only

.include "words/serial.qem"
.include "words/applturnkey.s"
.include "words/type0.s" # not sure 
.include "words/wordswap.s"
.include "words/irq.s"

.include "words/systick.s"   # faux SysTick (rv/words/systick.s), needs irq.s
