# SPDX-License-Identifier: GPL-3.0-only

DEFER ".error", PROMPTERROR, XT_PROMPTERROR_DEFAULT
END PROMPTERROR

NONAME ".error.default", PROMPTERROR_DEFAULT
.if WANT_THROWTXT == YES
    # it is important that there is no task switch (pause)
    # before TRACEDOTBT is called, otherwise the UA state
    # will be overwritten and the trace will be wrong
    .word XT_TRACEDOTBT, XT_CR
    # type the error message    
    .word XT_DUP
    .word XT_ERRQ
    .word XT_TYPE
.endif
    # amforth-shell looks for this error format
    # while waiting for the end of response,
    # so this must be at the end
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
