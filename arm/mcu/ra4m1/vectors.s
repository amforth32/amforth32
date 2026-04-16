
IRQ_VECTORS:
.include "arm/vectors.s"

/*  RA4M1 User Manual
    13.3.1 Interrupt Vector Table
    ARM_ICTR.INTLINESNUM=0 => 32 interrupts
*/

.word led_handler @ 16: ICU.IELSR0 = AGT0
.word 0 @ 17: ICU.IELSR1
.word 0 @ 18: ICU.IELSR2
.word 0 @ 19: ICU.IELSR3
.word 0 @ 20: ICU.IELSR4
.word 0 @ 21: ICU.IELSR5
.word 0 @ 22: ICU.IELSR6
.word 0 @ 23: ICU.IELSR7
.word 0 @ 24: ICU.IELSR8
.word 0 @ 25: ICU.IELSR9
.word 0 @ 26: ICU.IELSR10
.word 0 @ 27: ICU.IELSR11
.word 0 @ 28: ICU.IELSR12
.word 0 @ 29: ICU.IELSR13
.word 0 @ 30: ICU.IELSR14
.word 0 @ 31: ICU.IELSR15
.word 0 @ 32: ICU.IELSR16
.word 0 @ 33: ICU.IELSR17
.word 0 @ 34: ICU.IELSR18
.word 0 @ 35: ICU.IELSR19
.word 0 @ 36: ICU.IELSR20
.word 0 @ 37: ICU.IELSR21
.word 0 @ 38: ICU.IELSR22
.word 0 @ 39: ICU.IELSR23
.word 0 @ 40: ICU.IELSR24
.word 0 @ 41: ICU.IELSR25
.word 0 @ 42: ICU.IELSR26
.word 0 @ 43: ICU.IELSR27
.word 0 @ 44: ICU.IELSR28
.word 0 @ 45: ICU.IELSR29
.word 0 @ 46: ICU.IELSR30
.word 0 @ 47: ICU.IELSR31

