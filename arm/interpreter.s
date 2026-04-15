.global _INTERPRETER
.type _INTERPRETER, STT_FUNC
_INTERPRETER:
.thumb_func
DOALIAS:
        push {FIP}
        ldr FIP, [FW]
        NEXT
.thumb_func /* need to set the thumb bit on the DOCOLON symbol */
DOCOLON: 
        push {FIP}
        mov FIP, FW
.thumb_func
DO_NEXT:
.if WANT_DEBUGGER == YES
        /* if debug hook is set interrupt the DO_NEXT cycle */
        cbz DEBUG, DO_NEXT1
        ldr FW, [up, USER_DEBUG_BREAK] /* load debugger into FW */
        mov DEBUG, #0 /* clear DEBUG */
        b DO_EXECUTE
DO_NEXT1:
.endif
        ldr FW, [FIP], #4
.thumb_func
DO_EXECUTE:
        ldr r0, [FW], #4
        bx r0
.size _INTERPRETER, . - _INTERPRETER

.if WANT_DEBUGGER == YES
CODEWORD "(exitd)", EXITD /* ( -- ) exit from a debugger word */
        /* restore DEBUG hook */
        ldr DEBUG, [up, USER_DEBUG_NEXT]
        pop {FIP} /* restore FIP */
        b DO_NEXT1 /* finish the interrupted DO_NEXT */
        .ltorg
END EXITD

.equ DEBUG_STEP, 1

CODEWORD "break", BREAK /* ( -- ) activate the debugger (if enabled) */
        /* check if we are already debugging */
        cbnz DEBUG, 1f
        /* check if debugger is enabled */
        ldr DEBUG, [up, USER_DEBUG_BREAK]
        cbz DEBUG, 1f
        /* set debug.next to debug_step */
        mov DEBUG, #DEBUG_STEP
        str DEBUG, [up, USER_DEBUG_NEXT]
1:      NEXT
END BREAK

CODEWORD "debug_buf", DEBUG_BUF /* ( -- addr ) debugger input buffer address */
  savetos
  ldr TOS, =RAM_lower_debug_buf
  NEXT
END DEBUG_BUF
.endif
