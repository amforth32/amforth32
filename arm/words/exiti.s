# SPDX-License-Identifier: GPL-3.0-only
# Helper word for 

CODEWORD "(exiti)", EXITI /* return from interrupt handler; compiled by ;i. */
#     ldr r0 , [up,#USER_LINK]
#     ldr sp , [r0,#USER_RP]

     # the `b DO_EXECUTE` ends up in DO_COLON because that's the XT of the ISR word.
     # DO_COLON will push FIP to the return stack before executing the word.
     # so we need to compensate for that push here, otherwise the pop that follows
     # will not be aligned with the push in isrstub and we're off the rails.
     # add sp, 4

    /* restore SP from the inactive task's return stack,
     this should fix any stack imbalance before restoring all registers */
    mrs r0, PSP
    ldr r1, [r0], #4
    mov sp, r1
    msr PSP, r0


     # This must match the push in isrstub
     pop {r4-r11, lr}
     bx lr
END EXITI

