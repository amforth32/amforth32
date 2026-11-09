# SPDX-License-Identifier: GPL-3.0-only

# link to the next task block
.equ USER_LINK       ,   0*cellsize
# task status (0 = inactive) 
.equ USER_STATUS     ,   1*cellsize
# task word
.equ USER_XT         ,   2*cellsize
# task exception handler
.equ USER_HANDLER    ,   3*cellsize

# current loop index
.equ USER_LOOP_INDEX ,   4*cellsize
# current loop limit
.equ USER_LOOP_LIMIT ,   5*cellsize

# saved return stack pointer
.equ USER_RP         ,   6*cellsize
# saved data stack pointer
.equ USER_SP         ,   7*cellsize
# saved leave stack pointer
.equ USER_LP         ,   8*cellsize
# saved instruction pointer
.equ USER_IP         ,   9*cellsize
# saved top of data stack
.equ USER_TOS        ,  10*cellsize

# task number base
.equ USER_BASE       ,  11*cellsize
# task emit word (unused)
.equ USER_EMIT       ,  12*cellsize

.if WANT_DEBUGGER == YES
.equ USER_DEBUG_BREAK,  13*cellsize
.equ USER_DEBUG_NEXT ,  14*cellsize
.endif

/* TODO: check that userarea_size is large enough */
.equ userarea_size, 16 * cellsize
.global userarea_size
