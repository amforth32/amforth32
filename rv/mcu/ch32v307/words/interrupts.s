# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "+int" , PLUSINT /* ( -- ) enable interrupts */
    li t0 , 0x6088
    csrw 0x800 , t0
    NEXT
END PLUSINT    

CODEWORD "-int" , MINUSINT /* ( -- ) disable interrupts */
    li t0 , 0x6000
    csrw 0x800 , t0
    NEXT
END MINUSINT
