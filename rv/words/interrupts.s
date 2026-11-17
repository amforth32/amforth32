# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "+int" , PLUSINT /* ( -- ) enable interrupts */
    csrsi mstatus, 0x8
    NEXT
END PLUSINT    

CODEWORD "-int" , MINUSINT /* ( -- ) disable interrupts */
    csrci mstatus, 0x8
    NEXT
END MINUSINT

CODEWORD "int?" , INTQ /* ( -- f ) true if interrupts enabled */
    savetos
    csrr    t1, mstatus
    andi    t1, t1, 0x8          /* MIE */
    snez    t1, t1               /* 1 if enabled, else 0 */
    neg     s3, t1               /* -1 (true) or 0 (false) */
    NEXT
END INTQ
