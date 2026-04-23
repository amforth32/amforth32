# SPDX-License-Identifier: GPL-3.0-only
# Helper word for 

CODEWORD "(exiti)", EXITI /* return from interrupt handler; compiled by ;i. */
     add sp , sp , #4
     pop {r4-r11,pc}
END EXITI
