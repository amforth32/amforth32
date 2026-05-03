# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "+int" , PLUSINT /* ( -- ) enable interrupts */
    cpsie   i                      @ clear PRIMASK, enable all maskable interrupts
    NEXT
END PLUSINT    

CODEWORD "-int" , MINUSINT /* ( -- ) disable interrupts */
    cpsid   i                      @ set PRIMASK, disable all maskable interrupts
    NEXT
END MINUSINT
