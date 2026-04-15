# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "unloop", UNLOOP /* (R: loop-sys -- ) remove loop-sys; required if you want exit the word rather then leave the loop */
    # restore loop-sys
    lw t0, 0(s5)
    storelimit t0
    lw t0, 4(s5)
    storeindex t0
    addi s5, s5, 8
    NEXT
END UNLOOP
