# SPDX-License-Identifier: GPL-3.0-only

USER "handler", HANDLER, USER_HANDLER /* used by catch/throw */
END HANDLER

COLON "catch", CATCH /* ( i * x xt -- j * x 0 | i * x n ) execute xt; jump to just after CATCH if xt THROWs n */
/*
    Push an exception frame on the return stack and then execute xt in such a way that control
    can be transferred to a point just after CATCH if THROW is executed during the execution of xt.

    If the execution of xt completes normally (i.e., the exception frame pushed by this CATCH
    is not popped by an execution of THROW) pop the exception frame and return zero on top of the data stack,
    above whatever stack items would have been returned by xt EXECUTE.
    Otherwise, the remainder of the execution semantics are given by THROW.
*/
    # save DSP
    .word XT_SP_FETCH 
    .word XT_TO_R
    # save previous HANDLER
    .word XT_HANDLER
    .word XT_FETCH
    .word XT_TO_R
    # set current handler (RSP to return to)
    .word XT_RP_FETCH
    .word XT_HANDLER
    .word XT_STORE
    # execute XT
    .word XT_EXECUTE
    # EXECUTE returns here if no THROW
    # restore previous HANDLER
    .word XT_R_FROM
    .word XT_HANDLER
    .word XT_STORE
    # discard saved DSP
    .word XT_R_FROM
    .word XT_DROP

    .word XT_ZERO
    .word XT_EXIT
END CATCH
