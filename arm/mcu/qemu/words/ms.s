.if CORTEXM == YES
# use default systick based ms
.include "arm/words/ms.s"
.else
# use CNTPCT based ms for Cortex-A CPUs
.include "words/ms-cntpct.s"
.endif
