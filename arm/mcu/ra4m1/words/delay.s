
# Delay processing busy waits on the Cortex-M4 system timer, SysTick
# RA4M1 provides external SYSTICCLK clock fixed at 32.768 kHz as an alternative to using the MCU clock 48Mhz.
# We're using SYSTICCLK here.
# Ref: Cortex-M4 User Guide: 4.4 System timer, SysTick
# Ref: Renesas RA4M1 User Manual: 2.9 SysTick System Timer

ARM_CONSTANT "ARM_SYST_CSR", ARM_SYST_CSR, 0xE000E010 
# SYST_CSR SysTick Control and Status Register
# Bits   | Name     | Function
# ----------------------------
# [31:17] | -         | Reserved
# [16]    | COUNTFLAG | Returns 1 if timer counted to 0 since last time this was read.
# [15:3]  | -         | Reseverd
# [2]     | CLKSOURCE | Clock source: 0 = external clock / 1 = processor clock.
# [1]     | TICKINT   | Enables SysTick exception request; Software can use COUNTFLAG to determine if SysTick has ever counted to zero.
# [0]     | ENABLE    | Enables the counter
# When ENABLE is set to 1, the counter loads the RELOAD value from the SYST_RVR register
# and then counts down. On reaching 0, it sets the COUNTFLAG to 1 and optionally asserts the
# SysTick depending on the value of TICKINT. It then loads the RELOAD value again, and begins counting.

ARM_CONSTANT "ARM_SYST_RVR", ARM_SYST_RVR, 0xE000E014
# SYST_RVR SysTick Reload Value Register (lower 24 bits only)
# The RELOAD value can be any value in the range 0x00000001-0x00FFFFFF. A start value of 0 is possible,
# but has no effect because the SysTick exception request and COUNTFLAG are activated when counting from 1 to 0.
# The RELOAD value is calculated according to its use. For example, to generate a multi-shot
# timer with a period of N processor clock cycles, use a RELOAD value of N-1. If the SysTick
# interrupt is required every 100 clock pulses, set RELOAD to 99.

ARM_CONSTANT "ARM_SYST_CVR", ARM_SYST_CVR, 0xE000E018
# SYST_CVR SysTick Current Value Register (lower 24 bits only)
# Reads return the current value of the SysTick counter.
# A write of any value clears the field to 0, and also clears the SYST_CSR COUNTFLAG bit to 0.

.equ RA4_TIMER_RELOAD_VALUE, 0x00FFFFFF

ARM_COLON "delay-init", DELAY_INIT
    @ Disable SysTick during setup
    .word XT_ZERO, XT_ARM_SYST_CSR, XT_STORE

    @ Maximum reload value for 24 bit timer
    .word XT_DOLITERAL, RA4_TIMER_RELOAD_VALUE, XT_ARM_SYST_RVR, XT_STORE

    @ Any write to current clears it
    .word XT_ZERO, XT_ARM_SYST_CVR, XT_STORE

    @ Enable SysTick with SYSTICCLK = 32.768kHz clock
    .word XT_ONE, XT_ARM_SYST_CSR, XT_STORE
.word XT_EXIT

# Wait for n ticks of the SysTick timer.
# tick = 1/32.768 kHz = 0.00003051757812 s ~ 30.5 us
# Clamps n to be no more than RA4_TIMER_RELOAD_VALUE
# which translates to about 512 seconds max delay
ARM_COLON "delay-ticks", DELAY_TICKS
@ ( n -- ) waits for n ticks of the timer, tick ~ 30 microseconds
    # make sure n is no more than RA4_TIMER_RELOAD_VALUE
    .word XT_DOLITERAL, RA4_TIMER_RELOAD_VALUE, XT_AND
    .word XT_ARM_SYST_CVR, XT_FETCH     @ ( n start-ticks )
DELAY_TICKS_LOOP:
      .word XT_PAUSE, XT_2DUP
      .word XT_ARM_SYST_CVR, XT_FETCH, XT_MINUS     @ ( n start-ticks n elapsed-ticks )
      # need to handle timer wrapping around zero, i.e elapsed ticks is negative
      .word XT_DUP, XT_ZEROLESS, XT_DOCONDBRANCH, DELAY_CHECK_ELAPSED_TICKS
      # if elapsed ticks are negative, add the reload value
      .word XT_DOLITERAL, RA4_TIMER_RELOAD_VALUE, XT_PLUS
DELAY_CHECK_ELAPSED_TICKS:
      # otherwise if n < elapsed-ticks exit
      .word XT_UGREATER, XT_NOT, XT_DOCONDBRANCH, DELAY_TICKS_LOOP
    .word XT_2DROP
.word XT_EXIT


.equ RA4_MS_TICKS, 33
# Number of timer ticks per millisecond
#   1 tick = 30.5 us
#   1 ms = 1000 us / 30.5 us = 32.78 ticks

COLON "ms", MS
@ ( n -- ) waits n milliseconds
MS_LOOP:
        @ if n <= 0 leave
        .word XT_DUP, XT_ZEROLESS, XT_NOT, XT_DOCONDBRANCH, MS_LEAVE
        @ wait RA4_MS_TICKS ticks
        .word XT_DOLITERAL, RA4_MS_TICKS, XT_DELAY_TICKS
        @ decrement n, repeat
        .word XT_1MINUS, XT_DOBRANCH, MS_LOOP
MS_LEAVE:
    .word XT_DROP, XT_EXIT

