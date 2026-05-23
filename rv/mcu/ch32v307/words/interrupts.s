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

CODEWORD "int?" , INTQ /* ( -- f ) true if interrupts enabled */
    savetos
    mv      s3, zero             /* set TOS to false */
    csrr    t1, 0x800            /* get interrupt state */
    andi    t1, t1, 0x0008       /* Mask out everything except Bit 3 (GIE) */
    beq     t1, zero, 1f         /* If Bit 3 is 0, skip to the end (false) */
    li      s3, -1               /* ...they are so TOS is true */
1:    
    NEXT
END INTQ

