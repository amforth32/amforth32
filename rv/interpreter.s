# SPDX-License-Identifier: GPL-3.0-only
.global DO_EXECUTE

.global _INTERPRETER
.type _INTERPRETER, STT_FUNC
_INTERPRETER:
DOALIAS:
        push s2        # IP
        lw s2 , 0(s1)  # [W]->IP
        NEXT
DOCOLON: 
        push s2   # IP
        mv s2,s1  # W->IP
DO_NEXT:
.if WANT_DEBUGGER == YES
        /* if debug hook is set interrupt the DO_NEXT cycle */
        beq s7, zero, DO_NEXT1
        lw s1, USER_DEBUG_BREAK(s6) /* load debugger into FW */
        mv s7, zero /* clear DEBUG */
        j DO_EXECUTE
DO_NEXT1:
.endif
        lw s1, 0(s2) # @IP -> W 
        addi s2,s2,4 # INC IP
DO_EXECUTE:
        lw a0, 0(s1) # @W, address of some executable code
        addi s1,s1,4 # INC W, points now to PFA
        jalr zero,a0,0 # jump to code
#DO_EXECUTE:
#        lw   s10, 0(s1) # @W, address of some executable code
#        addi s1,s1,4 # INC W, points now to PFA
#        jalr zero,s10,0 # jump to code
.size _INTERPRETER, . - _INTERPRETER

.if WANT_DEBUGGER == YES
CODEWORD "(exitd)", EXITD /* ( -- ) exit from a debugger word */
        /* restore DEBUG hook */
        lw s7, USER_DEBUG_NEXT(s6)
        pop s2 /* restore FIP */
        j DO_NEXT1 /* finish the interrupted DO_NEXT */
END EXITD

.equ DEBUG_STEP, 1

CODEWORD "break", BREAK /* ( -- ) activate the debugger (if enabled) */
        /* check if we are already debugging */
        bne s7, zero, 1f
        /* check if debugger is enabled */
        lw s7, USER_DEBUG_BREAK(s6)
        beq s7, zero, 1f
        /* set debug.next to debug_step */
        li s7, DEBUG_STEP
        sw s7, USER_DEBUG_NEXT(s6)
1:      NEXT
END BREAK

CODEWORD "debug_buf", DEBUG_BUF /* ( -- addr ) debugger input buffer address */
  savetos
  la s3, RAM_lower_debug_buf
  NEXT
END DEBUG_BUF
.endif
