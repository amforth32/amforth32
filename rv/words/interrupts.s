# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "+int" , PLUSINT /* ( -- ) enable interrupts */
    csrsi mstatus, 0x8
    NEXT
END PLUSINT    

CODEWORD "-int" , MINUSINT /* ( -- ) disable interrupts */
    csrci mstatus, 0x8 
    NEXT
END MINUSINT
