# SPDX-License-Identifier: GPL-3.0-only

USER "handler", HANDLER, USER_HANDLER /* used by catch/throw */
END HANDLER

COLON "catch", CATCH /* ( i*x xt -- j*x 0 | i*x n ) execute XT and check for exceptions */

    .word XT_SP_FETCH
    .word XT_TO_R
    .word XT_HANDLER
    .word XT_FETCH
    .word XT_TO_R
    .word XT_RP_FETCH
    .word XT_HANDLER
    .word XT_STORE
    .word XT_EXECUTE
    .word XT_R_FROM
    .word XT_HANDLER
    .word XT_STORE
    .word XT_R_FROM
    .word XT_DROP
    .word XT_ZERO
    .word XT_EXIT
END CATCH
