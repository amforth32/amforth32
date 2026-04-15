# SPDX-License-Identifier: GPL-3.0-only

.equ USER_STATE, 0
.equ USER_FOLLOWER, 1*cellsize

.equ USER_RP, 2*cellsize
.equ USER_SP0, 3*cellsize
.equ USER_SP, 4*cellsize
.equ USER_HANDLER, 5*cellsize
.equ USER_BASE, 6*cellsize
.equ USER_LOOP_INDEX, 7*cellsize
.equ USER_LOOP_LIMIT, 8*cellsize

.if WANT_DEBUGGER == YES
.equ USER_DEBUG_BREAK, 9*cellsize
.equ USER_DEBUG_NEXT, 10*cellsize
.endif

/* TODO: check that userarea_size is large enough */
.equ userarea_size, (2 + 32) * cellsize
.global userarea_size
