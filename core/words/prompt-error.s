# SPDX-License-Identifier: GPL-3.0-only

DEFER ".error", PROMPTERROR, XT_PROMPTERROR_DEFAULT
END PROMPTERROR

NONAME ".error.default", PROMPTERROR_DEFAULT
    STRING " ?? "
    .word XT_TYPE
    .word XT_BASE
    .word XT_FETCH
    .word XT_TO_R
    .word XT_DECIMAL
    .word XT_DOT
    .word XT_TO_IN
    .word XT_FETCH
    .word XT_DOT
    .word XT_R_FROM
    .word XT_BASE
    .word XT_STORE
    .word XT_EXIT
END PROMPTERROR_DEFAULT
