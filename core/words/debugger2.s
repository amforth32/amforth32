
USER "debug.next", DEBUG_NEXT, USER_DEBUG_NEXT /* next debug action, 0 if none */
END DEBUG_NEXT

USER "debug.break", DEBUG_BREAK, USER_DEBUG_BREAK /* XT of debugger, invoked when BREAK is reached */
END DEBUG_BREAK

NONAME ".ready.debugger", PROMPTREADYDEBUGGER
    .word XT_CR
    STRING "# "
    .word XT_TYPE
    .word XT_EXIT
END PROMPTREADYDEBUGGER

/*
  used during debugger development
  MUST be used to end debugger word definition 
IMMED "\073d", SEMICOLOND
        .word XT_COMPILE
        .word XT_EXITD
        .word XT_LBRACKET
        .word XT_REVEAL
        .word XT_FLASHDOTFLUSH
        .word XT_EXIT
END SEMICOLOND
*/
