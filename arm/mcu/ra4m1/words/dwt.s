# SPDX-License-Identifier: GPL-3.0-only

# ========================================
# DWT CYCCNT - 32-bit Cycle Counter Setup
# ========================================

.equ DEMCR      , 0xE000EDFC  /* Debug Exception and Monitor Control */
.equ DWT_CTRL   , 0xE0001000  /* DWT Control Register */
.equ DWT_CYCCNT , 0xE0001004  /* 32-bit Cycle Count Register */

CODEWORD "dwt.init" , DWTDOTINIT /* ( -- ) initialise the DWT CYCCNT 32b counter */

    /* Enable trace system */
    ldr   r0, =DEMCR    /* DEMCR */
    ldr   r1, [r0]
    orr   r1, r1, #(1<<24)   /* Set TRCENA bit */
    str   r1, [r0]

    /* Reset cycle counter to zero */
    ldr   r0, =DWT_CYCCNT    /* DWT_CYCCNT */
    mov   r1, #0
    str   r1, [r0]

    NEXT
END DWTDOTINIT

CODEWORD "-dwt" , MINUSDWT /* ( -- ) reset the DWT CYCCNT 32b counter to zero */

    ldr   r0, =DWT_CYCCNT    /* DWT_CYCCNT */
    mov   r1, #0
    str   r1, [r0]

    NEXT
END MINUSDWT

CODEWORD "+dwt" , PLUSDWT /* ( -- ) start the DWT CYCCNT 32b counter */

    ldr   r0, =DWT_CTRL      /* DWT_CTRL */
    ldr   r1, [r0]
    orr   r1, r1, #1         /* Set CYCCNTENA bit (bit 0) */
    str   r1, [r0]

    NEXT
END PLUSDWT

CODEWORD "dwt@" , DWT_FETCH /* ( -- n ) read the DWT CYCCNT 32b counter */

    ldr   r0, =DWT_CYCCNT    /* DWT_CYCCNT */
    savetos 
    ldr   TOS, [r0]          /* r0 = cycle count */
    
    NEXT
END DWT_FETCH

CODEWORD "dwt-ms" , DWT_MS /* ( n -- ) delay (busy) n milliseconds (max int delay is 89s) */

    ldr   r1, =DWT_CYCCNT     /* DWT_CYCCNT address */
    ldr   r2, [r1]            /* Get start count */
    ldr   r3, =48000          /* 48000 cycles per millisecond at 48MHz */
    mul   r0, TOS, r3         /* Convert ms to cycles */

1:
    ldr   r3, [r1]            /* Read current count */
    sub   r3, r3, r2          /* Elapsed = current - start (handles wrap) */
    cmp   r3, r0              /* Compare elapsed to target */
    blo   1b                  /* Loop until elapsed >= target */
    loadtos 
    NEXT
END DWT_MS

CODEWORD "dwt-us" , DWT_US /* ( n -- ) delay (busy) n microseconds (max int delay is 89s) */

    ldr   r1, =DWT_CYCCNT     /* DWT_CYCCNT address */
    ldr   r2, [r1]            /* Get start count */
    ldr   r3, =48             /* 48 cycles per microsecond at 48MHz */
    mul   r0, TOS, r3         /* Convert ms to cycles */

1:
    ldr   r3, [r1]            /* Read current count */
    sub   r3, r3, r2          /* Elapsed = current - start (handles wrap) */
    cmp   r3, r0              /* Compare elapsed to target */
    blo   1b                  /* Loop until elapsed >= target */
    loadtos 
    NEXT
END DWT_US
        
/*
> show dwt
LFA..... (LFA)... FFA..... (FFA)... NFA..... XT...... (XT).... 
0000A680 0000A64C 0000A684 00000000 0000A688 0000A690 CODEWORD dwt-us
0000A648 0000A628 0000A64C 00000000 0000A650 0000A658 CODEWORD dwt-ms
0000A624 0000A600 0000A628 00000000 0000A62C 0000A634 CODEWORD dwt@
0000A5FC 0000A5DC 0000A600 00000000 0000A604 0000A60C CODEWORD +dwt
0000A5D8 0000A5A4 0000A5DC 00000000 0000A5E0 0000A5E8 CODEWORD -dwt
0000A5A0 0000A580 0000A5A4 00000000 0000A5A8 0000A5B4 CODEWORD dwt.init
 ok
> : yy dwt@ 100 dwt-us dwt@ swap - u. ;
 ok
> yy
4868  ok
> : zz dwt@ 1000 dwt-ms dwt@ swap - u. ;
 ok
> zz
48000070  ok
> 

*/

