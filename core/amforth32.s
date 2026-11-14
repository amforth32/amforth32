# This file contains steps that are executed early in the assembly structure,
# before words definitions are compiled.
# Code here should pertain to general AmForth32 architecture only.

# Allocate core system RAM areas: interrupt vector/stack and task areas (stacks, tib, user areas, ...)

# Local symbols
.eqv pad, 4 

RAMALLOT ram_vector, ram_vector_size, pad
RAMALLOT ISR_stack, isr_stack_size, pad

# DO_TASK allocates RAM for task number i
.macro DO_TASK i
    .section amramlo
    .set RAM_TASK\i\() , . /* TASK area start  */
    RAMALLOT TASK\i\()_userarea    , userarea_size    , pad
    RAMALLOT TASK\i\()_refill_buf  , refill_buf_size  , pad  
    RAMALLOT TASK\i\()_returnstack , returnstack_size , pad
    RAMALLOT TASK\i\()_datastack   , datastack_size   , pad
    RAMALLOT TASK\i\()_leavestack  , leavestack_size  , pad
    .if WANT_DEBUGGER == YES
    RAMALLOT TASK\i\()_debug_buf   , refill_buf_size  , pad
    .endif
    .section amforth
.endm

.altmacro
.set i, 0
.rept TASKN 
    DO_TASK %i
    .set i, i+1
.endr
.noaltmacro

.equ TASK_BLOCK_SIZE , RAM_TASK1 - RAM_TASK0

# area offsets from UP
.equ USER_TIB, userarea_size + pad
.equ USER_RSTK, USER_TIB + refill_buf_size + pad
.equ USER_RP0, USER_RSTK + returnstack_size
.equ USER_DSTK, USER_RP0 + pad
.equ USER_SP0, USER_DSTK + datastack_size
.equ USER_LSTK, USER_SP0 + pad
.equ USER_LP0, USER_LSTK + leavestack_size
.if WANT_DEBUGGER == YES
.equ USER_DEBUG_TIB, USER_LP0 + pad
.endif

# UP block of ISR task (TASKN)
.equ RAM_ISR_UP, RAM_TASK0 + TASK_BLOCK_SIZE * (TASKN-1)


# EXCEPTION CODES

# Standard Exceptions
# https://forth-standard.org/standard/exception (Table 9.1)
.include "words/throwerr.s"
