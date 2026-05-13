# SPDX-License-Identifier: GPL-3.0-only

/*
On the QEMU virt machine, mtime is at address 0x200BFF8 and
ticks at 10 MHz (1 tick = 100 ns, 10000 ticks = 1 ms). It is a 64 bit
counter but only the low word is used. No init is required. 
*/

.equ MTIME_LO, 0x0200BFF8

CODEWORD "mtime@", MTIMEFETCH /* ( -- n ) read RV mtime low 32 bits */
    savetos
    li t0, MTIME_LO
    lw s3 , 0(t0)
    NEXT
END MTIMEFETCH

CODEWORD "1ms", N1MS  /* ( -- ) busy-wait 1 millisecond */
    li      t0, MTIME_LO
    lw      t1, 0(t0)              /* t1 = start */
    li      t2, 100000             /* ticks per ms */
1:
    lw      t3, 0(t0)              /* t3 = now */
    sub     t3, t3, t1             /* t3 = elapsed (wrap-safe) */
    bltu    t3, t2, 1b             /* loop until elapsed >= ticks */
    NEXT
END N1MS

COLON "ms", MS /* ( n -- ) a non-busy n ms delay that executes PAUSE  */
	.word XT_DOLITERAL
	.word 10000
	.word XT_STAR
	.word XT_TO_R
	.word XT_MTIMEFETCH
MS_0001: /* begin */
	.word XT_PAUSE
	.word XT_MTIMEFETCH
	.word XT_OVER
	.word XT_MINUS
	.word XT_R_FETCH
	.word XT_UGREATER
	.word XT_DOCONDBRANCH,MS_0001 /* until */
	.word XT_DROP
	.word XT_RDROP
	.word XT_EXIT
END MS

CONSTANT "ms.tickf",MSDOTTICKF,10000000
END MSDOTTICKF

CODEALIAS "ms.init", MSDOTINIT, NOP /* ( -- ) start free running counter that backs ms */ 
END MSDOTINIT

CODEALIAS "tick@" , TICKFETCH , MTIMEFETCH /* ( -- n ) value of free running 32 bit 10MHz counter */
END TICKFETCH
