# This file contains steps that are executed early in the assembly structure,
# before words definitions are compiled.
# Code here should pertain to general AmForth32 architecture only.

# Allocate core system RAM areas: interrupt vector and task areas (stacks, tib, user areas, ...)

RAMALLOT ram_vector, 256*cellsize, 4

# DO_TASK allocates RAM for task number i
.macro DO_TASK i
    .section amramlo
    .set RAM_TASK\i\() , . /* TASK area start  */
    RAMALLOT TASK\i\()_returnstack , returnstack_size , 4
    RAMALLOT TASK\i\()_datastack   , datastack_size   , 4
    RAMALLOT TASK\i\()_leavestack  , leavestack_size  , 4
    .section amramlo
    .set RAM_TASK\i\()_UP , . /* UP block of TASK i */
    RAMALLOT TASK\i\()_userarea    , userarea_size    , 4
    RAMALLOT TASK\i\()_refill_buf  , refill_buf_size  , 4
    .if WANT_DEBUGGER == YES
    RAMALLOT TASK\i\()_debug_buf   , refill_buf_size  , 4
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
# TIB offset from UP
.equ USER_TIB, userarea_size
# DEBUG TIB offset from UP
.equ USER_DEBUG_TIB, USER_TIB + refill_buf_size
# UP block of ISR task (TASKN)
.equ ISR_UP, RAM_TASK0_UP + TASK_BLOCK_SIZE * (TASKN-1)


# EXCEPTION CODES

# Standard Exceptions
# https://forth-standard.org/standard/exception (Table 9.1)
.include "words/throwerr.s"
