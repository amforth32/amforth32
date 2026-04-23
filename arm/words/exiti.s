# SPDX-License-Identifier: GPL-3.0-only
# Helper word for 

CODEWORD "(exiti)", EXITI /* return from interrupt handler; compiled by ;i. */
     ldr r0 , [up,#USER_LINK]
     ldr sp , [r0,#USER_RP]
     pop {r4-r11,pc}
END EXITI

