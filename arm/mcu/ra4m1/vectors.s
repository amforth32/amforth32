
IRQ_VECTORS:
/* .include "arm/vectors.s" */

.word RAM_upper_TASK0_returnstack @ 00: Stack top address

.word PFA_COLD        @ 01: Reset Vector
.word isrstub         @ 02: NMI
.word 0               @ 03: HARD fault
.word 0     @ 04: MPU fault
.word 0     @ 05: bus fault
.word 0     @ 06: usage fault
.word 0               @ 07: Reserved
.word 0               @ 08: Reserved
.word 0               @ 09: Reserved
.word 0               @ 10: Reserved
.word 0     @ 11: SVCall handler
.word 0     @ 12: Debug monitor handler
.word 0               @ 13: Reserved
.word 0     @ 14: PendSV handler
.word isrstub         @ 15: SysTick handler


/*  RA4M1 User Manual
    13.3.1 Interrupt Vector Table

    13.2.6 ICU Event Link Setting Register n (IELSRn)
    Address: 0x40006300 + 4n :
    * IELS[7:0] - ICU Event Link Select ; 0 = disabled, otherwise Event Table 13.4.
    * IR[16] - Interrupt Status Flag ; write 0 to clear request
    * DTCE[24] - DTC Activation Enable ; activates DTC instead of NVIC
    
*/

.word isrstub @ 16: ICU.IELSR0
.word isrstub @ 17: ICU.IELSR1
.word isrstub @ 18: ICU.IELSR2
.word isrstub @ 19: ICU.IELSR3
.word isrstub @ 20: ICU.IELSR4
.word isrstub @ 21: ICU.IELSR5
.word isrstub @ 22: ICU.IELSR6
.word isrstub @ 23: ICU.IELSR7
.word isrstub @ 24: ICU.IELSR8
.word isrstub @ 25: ICU.IELSR9
.word isrstub @ 26: ICU.IELSR10
.word isrstub @ 27: ICU.IELSR11
.word isrstub @ 28: ICU.IELSR12
.word isrstub @ 29: ICU.IELSR13
.word isrstub @ 30: ICU.IELSR14
.word isrstub @ 31: ICU.IELSR15
.word isrstub @ 32: ICU.IELSR16
.word isrstub @ 33: ICU.IELSR17
.word isrstub @ 34: ICU.IELSR18
.word isrstub @ 35: ICU.IELSR19
.word isrstub @ 36: ICU.IELSR20
.word isrstub @ 37: ICU.IELSR21
.word isrstub @ 38: ICU.IELSR22
.word isrstub @ 39: ICU.IELSR23
.word isrstub @ 40: ICU.IELSR24
.word isrstub @ 41: ICU.IELSR25
.word isrstub @ 42: ICU.IELSR26
.word isrstub @ 43: ICU.IELSR27
.word isrstub @ 44: ICU.IELSR28
.word isrstub @ 45: ICU.IELSR29
.word isrstub @ 46: ICU.IELSR30
.word isrstub @ 47: ICU.IELSR31

