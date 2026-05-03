# This file contains steps that are executed early in the assembly structure,
# before words definitions are compiled.
# Code here should pertain to general AmForth32 architecture only.

# Allocate core system RAM areas: stacks, tib, user areas, ...
# TODO: should this be configurable?

.macro DO_TASK i
    RAMALLOT TASK\i\()_returnstack , returnstack_size , 4
    RAMALLOT TASK\i\()_datastack   , datastack_size   , 4
    RAMALLOT TASK\i\()_leavestack  , leavestack_size  , 4
    RAMALLOT TASK\i\()_userarea    , userarea_size    , 4
    RAMALLOT TASK\i\()_refill_buf  , refill_buf_size  , 4
    .if WANT_DEBUGGER == YES
    RAMALLOT TASK\i\()_debug_buf   , refill_buf_size  , 4
    .endif
.endm

.altmacro
.set i, 0
.rept TASKN 
    DO_TASK %i
    .set i, i+1
.endr
.noaltmacro

.equ TASK_BLOCK_SIZE , RAM_lower_TASK1_returnstack - RAM_lower_TASK0_returnstack
.equ ISR_UP, RAM_lower_TASK0_userarea + TASK_BLOCK_SIZE * (TASKN-1) 


#RAMALLOT isr_returnstack,32*cellsize
#RAMALLOT isr_datastack,32*cellsize
RAMALLOT ram_vector, 256*cellsize, 4
#RAMALLOT datastack, datastack_size, 4
#RAMALLOT returnstack, returnstack_size, 4
RAMALLOT leavestack, leavestack_size, 4
#RAMALLOT userarea, userarea_size, 4
#RAMALLOT isr_userarea, userarea_size, 4
RAMALLOT refill_buf, refill_buf_size, 4
.if WANT_DEBUGGER == YES
RAMALLOT debug_buf, refill_buf_size, 4
.endif
# EXCEPTION CODES

# Standard Exceptions
# https://forth-standard.org/standard/exception (Table 9.1)
.include "words/throwerr.s"
