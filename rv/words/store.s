# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "!", STORE /* ( x addr -- ) [addr] = x; store word x at addr */

    andi t0, s3, 0x3       /* cell aligned ?        */
    beqz t0, 1f            /* branch if OK          */

    /* handle exception ...                         */
  
    throw EADRINV
    
1:  /* normal operation ...                         */

    lw t0, 0(s4)
    sw t0, 0(s3)
    lw s3, 4(s4)
    addi s4, s4, 8
    NEXT
END STORE
