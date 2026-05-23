# SPDX-License-Identifier: GPL-3.0-only

.equ USER_RP0        ,            0
.equ USER_RP         ,   1*cellsize
.equ USER_SP0        ,   2*cellsize
.equ USER_SP         ,   3*cellsize
.equ USER_LP0        ,   4*cellsize
.equ USER_LP         ,   5*cellsize
.equ USER_HANDLER    ,   6*cellsize
.equ USER_BASE       ,   7*cellsize
.equ USER_LOOP_INDEX ,   8*cellsize
.equ USER_LOOP_LIMIT ,   9*cellsize
.equ USER_LINK       ,  10*cellsize
.equ USER_IP         ,  11*cellsize
.equ USER_TOS        ,  12*cellsize
.equ USER_STATUS     ,  13*cellsize
.equ USER_XT         ,  14*cellsize
.equ USER_EMIT       ,  15*cellsize

.if WANT_DEBUGGER == YES
.equ USER_DEBUG_BREAK,  16*cellsize
.equ USER_DEBUG_NEXT ,  17*cellsize
.endif

/* TODO: check that userarea_size is large enough */
.equ userarea_size, (2 + 32) * cellsize
.global userarea_size
