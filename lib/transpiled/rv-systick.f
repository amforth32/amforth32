\# # SPDX-License-Identifier: GPL-3.0-only

{
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
}

#10000 constant systick.ms        \# ( -- n ) systick ticks per millisecond
#15    constant systick#          \# ( -- n ) ISR slot number

variable systick.rvr              \# ( -- a ) reload value, period is rvr+1 ticks

: systick.period \# ( -- ud ) period in mtime ticks
    systick.rvr @ 1+ 0
;

: systick.start \# ( -- ) next tick = now + period
    mtime2@ systick.period d+ mtimecmp!
;

: systick.arm \# ( -- ) next = last target + period; if already past, next = now + period
    mtimecmp@ systick.period d+               ( next )
    2dup mtime2@ d- d0< if                    ( next )  \ next - now < 0 : late
        2drop mtime2@ systick.period d+       ( now+period )
    then
    mtimecmp!
;

: systick.isr \# ( -- ) timer interrupt (slot 7): re-arm, then run the systick# handler
    systick.arm
    systick# trap@
    ?dup if execute then                      \ slot 15 empty: just return
;i

: systick.max \# ( -- ) set reload value to maximum possible $00ffffff
    $00FFFFFF systick.rvr !
;

: systick! \# ( n -- ) write max count
    $00FFFFFF and systick.rvr !  systick.start
;

: +systick \# ( -- ) start systick
    ['] systick.isr 7 trap!  systick.start  7 irq.on
;

: -systick \# ( -- ) stop systick
    7 irq.off  mtime-
;

: systick.init \# ( -- ) initialize systick
    systick.max +systick
;

: systick@ \# ( -- n ) read systick counter value
    mtimecmp@ drop mtime@ -
;

: systick- \# ( -- ) clear systick interrupt flag (no-op, there is no COUNTFLAG)
;

: syscsr@ \# ( -- n ) no CSR on RV, always 0
    0
;
