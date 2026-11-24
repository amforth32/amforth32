# No duplicate names found.
#======================================================================
#======================================================================
# transpiling ../../../lib/transpiled/rv-systick.f on 2026/11/24 10:06:39
# \# # SPDX-License-Identifier: GPL-3.0-only
# 
# {
# /*
# Faux SysTick for the QEMU virt machine, built on the mtime.s words.
# 
# It provides the names of arm/words/systick.s so that code written for
# the Cortex-M SysTick (e.g. tests/interrupts-cortexm.fr) runs on RV.
# 
# RV has no auto-reloading SysTick. The CLINT mtimecmp fires once, and
# MTIP stays pending until mtimecmp is moved. So the machine timer
# interrupt (trap slot 7) runs systick.isr, which re-arms mtimecmp one
# period ahead and then executes the handler stored at systick# (slot 15,
# the same number as the Cortex-M SysTick exception; mcause 15 is
# reserved on RV so the slot is otherwise unused).
# 
# The handler is an ordinary ;i word. Its (exiti) restores the whole trap
# frame, so the rest of systick.isr is never reached and the extra return
# stack entries are discarded.
# 
# mtime ticks at 10 MHz: 10000 ticks = 1 ms.
# */
# }
# 
# #10000 constant systick.ms        \# ( -- n ) systick ticks per millisecond
# #15    constant systick#          \# ( -- n ) ISR slot number
# 
# variable systick.rvr              \# ( -- a ) reload value, period is rvr+1 ticks
# 
# : systick.period \# ( -- ud ) period in mtime ticks
#     systick.rvr @ 1+ 0
# ;
# 
# : systick.start \# ( -- ) next tick = now + period
#     mtime2@ systick.period d+ mtimecmp!
# ;
# 
# : systick.arm \# ( -- ) next = last target + period; if already past, next = now + period
#     mtimecmp@ systick.period d+               ( next )
#     2dup mtime2@ d- d0< if                    ( next )  \ next - now < 0 : late
#         2drop mtime2@ systick.period d+       ( now+period )
#     then
#     mtimecmp!
# ;
# 
# : systick.isr \# ( -- ) timer interrupt (slot 7): re-arm, then run the systick# handler
#     systick.arm
#     systick# trap@
#     execute
# ;i
# 
# : systick.max \# ( -- ) set reload value to maximum possible $00ffffff
#     $00FFFFFF systick.rvr !
# ;
# 
# : systick! \# ( n -- ) write max count
#     $00FFFFFF and systick.rvr !  systick.start
# ;
# 
# : +systick \# ( -- ) start systick
#     ['] systick.isr 7 trap!  systick.start  7 irq.on
# ;
# 
# : -systick \# ( -- ) stop systick
#     7 irq.off  mtime-
# ;
# 
# : systick.init \# ( -- ) initialize systick
#     systick.max +systick
# ;
# 
# : systick@ \# ( -- n ) read systick counter value
#     mtimecmp@ drop mtime@ -
# ;
# 
# : systick- \# ( -- ) clear systick interrupt flag (no-op, there is no COUNTFLAG)
# ;
# 
# : syscsr@ \# ( -- n ) no CSR on RV, always 0
#     0
# ;

/* # SPDX-License-Identifier: GPL-3.0-only */
/*
Faux SysTick for the QEMU virt machine, built on the mtime.s words.
It provides the names of arm/words/systick.s so that code written for
the Cortex-M SysTick (e.g. tests/interrupts-cortexm.fr) runs on RV.
RV has no auto-reloading SysTick. The CLINT mtimecmp fires once, and
MTIP stays pending until mtimecmp is moved. So the machine timer
interrupt (trap slot 7) runs systick.isr, which re-arms mtimecmp one
period ahead and then executes the handler stored at systick# (slot 15,
the same number as the Cortex-M SysTick exception; mcause 15 is
reserved on RV so the slot is otherwise unused).
The handler is an ordinary ;i word. Its (exiti) restores the whole trap
frame, so the rest of systick.isr is never reached and the extra return
stack entries are discarded.
mtime ticks at 10 MHz: 10000 ticks = 1 ms.
*/
CONSTANT "systick.ms", SYSTICKDOTMS, 10000
END SYSTICKDOTMS
/* ( -- n ) systick ticks per millisecond */
CONSTANT "systick#", SYSTICKHASH, 15
END SYSTICKHASH
/* ( -- n ) ISR slot number */
VARIABLE "systick.rvr", SYSTICKDOTRVR
END SYSTICKDOTRVR
/* ( -- a ) reload value, period is rvr+1 ticks */
# ----------------------------------------------------------------------
COLON "systick.period", SYSTICKDOTPERIOD /* ( -- ud ) period in mtime ticks */
	.word XT_SYSTICKDOTRVR
	.word XT_FETCH
	.word XT_1PLUS
	.word XT_ZERO
	.word XT_EXIT
END SYSTICKDOTPERIOD
# ----------------------------------------------------------------------
COLON "systick.start", SYSTICKDOTSTART /* ( -- ) next tick = now + period */
	.word XT_MTIME2AT
	.word XT_SYSTICKDOTPERIOD
	.word XT_DPLUS
	.word XT_MTIMECMPBANG
	.word XT_EXIT
END SYSTICKDOTSTART
# ----------------------------------------------------------------------
COLON "systick.arm", SYSTICKDOTARM /* ( -- ) next = last target + period; if already past, next = now + period */
	.word XT_MTIMECMPAT
	.word XT_SYSTICKDOTPERIOD
	.word XT_DPLUS
	.word XT_2DUP
	.word XT_MTIME2AT
	.word XT_DMINUS
	.word XT_DZEROLESS
	.word XT_DOCONDBRANCH,SYSTICKDOTARM_0001 /* if */
	.word XT_2DROP
	.word XT_MTIME2AT
	.word XT_SYSTICKDOTPERIOD
	.word XT_DPLUS
SYSTICKDOTARM_0001: /* then */
	.word XT_MTIMECMPBANG
	.word XT_EXIT
END SYSTICKDOTARM
# ----------------------------------------------------------------------
COLON "systick.isr", SYSTICKDOTISR /* ( -- ) timer interrupt (slot 7): re-arm, then run the systick# handler */
	.word XT_SYSTICKDOTARM
	.word XT_SYSTICKHASH
	.word XT_TRAP_FETCH
	.word XT_EXECUTE
	.word XT_EXITI
END SYSTICKDOTISR
# ----------------------------------------------------------------------
COLON "systick.max", SYSTICKDOTMAX /* ( -- ) set reload value to maximum possible $00ffffff */
	.word XT_DOLITERAL
	.word 0xffffff
	.word XT_SYSTICKDOTRVR
	.word XT_STORE
	.word XT_EXIT
END SYSTICKDOTMAX
# ----------------------------------------------------------------------
COLON "systick!", SYSTICKBANG /* ( n -- ) write max count */
	.word XT_DOLITERAL
	.word 0xffffff
	.word XT_AND
	.word XT_SYSTICKDOTRVR
	.word XT_STORE
	.word XT_SYSTICKDOTSTART
	.word XT_EXIT
END SYSTICKBANG
# ----------------------------------------------------------------------
COLON "+systick", PLUSSYSTICK /* ( -- ) start systick */
	.word XT_DOXLITERAL
	.word XT_SYSTICKDOTISR
	.word XT_DOLITERAL
	.word 7
	.word XT_TRAP_STORE
	.word XT_SYSTICKDOTSTART
	.word XT_DOLITERAL
	.word 7
	.word XT_IRQ_ON
	.word XT_EXIT
END PLUSSYSTICK
# ----------------------------------------------------------------------
COLON "-systick", MINUSSYSTICK /* ( -- ) stop systick */
	.word XT_DOLITERAL
	.word 7
	.word XT_IRQ_OFF
	.word XT_MTIMEMINUS
	.word XT_EXIT
END MINUSSYSTICK
# ----------------------------------------------------------------------
COLON "systick.init", SYSTICKDOTINIT /* ( -- ) initialize systick */
	.word XT_SYSTICKDOTMAX
	.word XT_PLUSSYSTICK
	.word XT_EXIT
END SYSTICKDOTINIT
# ----------------------------------------------------------------------
COLON "systick@", SYSTICKAT /* ( -- n ) read systick counter value */
	.word XT_MTIMECMPAT
	.word XT_DROP
	.word XT_MTIMEFETCH
	.word XT_MINUS
	.word XT_EXIT
END SYSTICKAT
# ----------------------------------------------------------------------
COLON "systick-", SYSTICKMINUS /* ( -- ) clear systick interrupt flag (no-op, there is no COUNTFLAG) */
	.word XT_EXIT
END SYSTICKMINUS
# ----------------------------------------------------------------------
COLON "syscsr@", SYSCSRAT /* ( -- n ) no CSR on RV, always 0 */
	.word XT_ZERO
	.word XT_EXIT
END SYSCSRAT
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
