# SPDX-License-Identifier: GPL-3.0-only
# Helper word for 

CODEWORD "(exiti)", EXITI /* return from interrupt handler; compiled by ;i. */

     # the `b DO_EXECUTE` ends up in DO_COLON because that's the XT of the ISR word.
     # DO_COLON will push FIP to the return stack before executing the word.
     # so we need to compensate for that push here, otherwise the pop that follows
     # will not be aligned with the push in isrstub and we're off the rails.
     # We do that by saving SP on the interrupted task's return stack and restoring it here.

.if CORTEXM == YES
    /* restore SP from the inactive task's return stack,
     this should fix any stack imbalance before restoring all registers */
    mrs r0, PSP
.if WANT_DEBUGGER == YES
    /* we also save DEBUG_BREAK on the task RS so restore it first */
    ldr r1, [r0], #4
    str r1, [UP, #USER_DEBUG_BREAK]
.endif
    ldr r1, [r0], #4
    mov sp, r1
    msr PSP, r0
.else
    /* We don't have separate ISR stack, at least pop the FIP from handler DO_COLON */
    add sp, 4
.endif


     # This must match the push in isrstub
     pop {r4-r11, lr}
     bx lr
END EXITI

