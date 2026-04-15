.word RAM_upper_returnstack @ 00: Stack top address

.word PFA_COLD        @ 01: Reset Vector
.word nullhandler     @ 02: NMI
.word faulthandler    @ 03: HARD fault
.word nullhandler     @ 04: MPU fault
.word nullhandler     @ 05: bus fault
.word nullhandler     @ 06: usage fault
.word 0               @ 07: Reserved
.word 0               @ 08: Reserved
.word 0               @ 09: Reserved
.word 0               @ 10: Reserved
.word nullhandler     @ 11: SVCall handler
.word nullhandler     @ 12: Debug monitor handler
.word 0               @ 13: Reserved
.word nullhandler     @ 14: PendSV handler
.word nullhandler     @ 15: SysTick handler
