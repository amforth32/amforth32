# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "(exiti)", EXITI /* return from interrupt handler; compiled by ;i. */

     # context restore for regs not included in HPE 

     addi s11, s11, -40
            
     lw s1,   0(s11)
     lw s2,   4(s11)
     lw s3,   8(s11)
     lw s4,  12(s11)
     lw s5,  16(s11)
     lw s6,  20(s11)
     lw s7,  24(s11)
     lw s8,  28(s11)
     lw s9,  32(s11)
     lw s10, 36(s11)

     mret 
END EXITI
