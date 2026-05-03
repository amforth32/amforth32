/*
Found 1 name(s) that resolve to multiple XT symbols:
  name='1ms':
    xtname='XT_N1MS'  file='./arm/words/ms.s'
    xtname='XT_1MS'  file='./arm/mcu/ra4m1/words/ms.s'
*/
#======================================================================
#======================================================================
# transpiling mtask-common.f on 2026/05/02 03:31:31
# \# # SPDX-License-Identifier: GPL-3.0-only
# 
# {
# CONSTANT "taskn" , TASKN , TASKN
# END TASKN
# 
# CONSTANT "task-block" , TASK_BLOCK, TASK_BLOCK_SIZE
# END TASK_BLOCK
# }
# 
# : vacant \# ( -- ) a task that does nothing
#     begin pause again
# ;
# 
# :~ init-user \# ( -- )
# 
#     \ for TASK0 operator when this is executed sp and rp not
#     \ correct but that is not important as they will written
#     \ on first task switch. However, for task1...taskn-1 they
#     \ ARE the initial values
# 
#     symbol RAM_lower_TASK0_userarea    up!
#     symbol RAM_upper_TASK0_returnstack up@ symbol USER_RP0 + !
#     symbol RAM_upper_TASK0_returnstack up@ symbol USER_RP  + !
#     symbol RAM_upper_TASK0_datastack   up@ symbol USER_SP0 + !
#     symbol RAM_upper_TASK0_datastack   up@ symbol USER_SP +  !
#     symbol RAM_upper_TASK0_leavestack  up@ symbol USER_LP0 + !
#     symbol RAM_upper_TASK0_leavestack  up@ symbol USER_LP  + !
# 
#     taskn 1 ?do
#         task-block 0 do
#             i symbol USER_HANDLER cells < if
#                 up@ i + @ task-block j * + up@ i + task-block j * + !
#             then
#         cell +loop
#     loop
# 
#     taskn 1- 0 ?do
#         \   task0 + (i+1 mod (taskn-1)) * task-block
#         up@ task-block i 1+ taskn 1- mod * +
#         up@ task-block i taskn 1- mod * + symbol USER_LINK + !
# 
#         ['] vacant >body
#         up@ task-block i taskn 1- mod * + symbol USER_IP + !
# 
#         i 0= if ['] quit else ['] vacant then
#         up@ task-block i taskn 1- mod * + symbol USER_XT + !
# 
#         i 0= if true else false then
#         up@ task-block i * + symbol USER_STATUS + !
#     loop
# ;
# 
# : task! \# ( xt n -- ) write task to slot n
#     dup 1 taskn 1- within not if symbol ENTASK throw then
#     task-block * symbol RAM_lower_TASK0_userarea + >r
#     dup   r@ symbol USER_XT + !
#     >body r> symbol USER_IP + !
# ;
# 
# : +task \# ( n -- ) make task n active
#     dup 1 taskn 1- within not if symbol ENTASK throw then
#     task-block * symbol RAM_lower_TASK0_userarea +
#     symbol USER_STATUS + true swap !
# ;
# 
# : -task \# ( n -- ) make task n inactive (sleep)
#     dup 1 taskn 1- within not if symbol ENTASK throw then
#     task-block * symbol RAM_lower_TASK0_userarea +
#     symbol USER_STATUS + false swap !
# ;
# 
# : single \# ( -- ) disable task switching
#     symbol XT_NOP is pause
# ;
# 
# : multi \# ( -- ) enable task switchin
#     ['] mtpause is pause
# ;
# 
# : show.task \# ( -- ) show tasks
#     \ need single or multi
#     symbol XT_PAUSE defer@ symbol XT_NOP = if
#         s" single"
#     else
#         s" multi"
#     then type cr
#     s" # UP...... ? LINK.... NAME...." type cr
#     taskn 1- 0 ?do
#         up@ task-block i * +
#         i .
#         dup hex.
#         dup symbol USER_STATUS + @ if
#             [char] A emit else [char] S emit then space
#         dup symbol USER_LINK   + @ hex.
#             symbol USER_XT + @ xt>string type
#         cr
#     loop
# ;
# 
# : show.user \# ( n -- ) show user area task n
#     \ drop
#     s" OFF A....... [A]..... Desc........ OFF A....... [A]..... Desc........"
#     type cr
#     32 0 do
#         i cells 3 u.r space up@ i cells + dup hex. @ hex.
#         i case
#             0 of s" one......... " type endof
#             1 of s" one......... " type endof
#             2 of s" one......... " type endof
#             3 of s" one......... " type endof
#             4 of s" one......... " type endof
#             5 of s" one......... " type endof
#             6 of s" one......... " type endof
#             7 of s" one......... " type endof
#             8 of s" one......... " type endof
#             9 of s" one......... " type endof
#            10 of s" one......... " type endof
#            11 of s" one......... " type endof
#            12 of s" one......... " type endof
#            13 of s" one......... " type endof
#            14 of s" one......... " type endof
#            15 of s" one......... " type endof
#            16 of s" one......... " type endof
#            17 of s" one......... " type endof
#            18 of s" one......... " type endof
#            19 of s" one......... " type endof
#            20 of s" one......... " type endof
#            21 of s" one......... " type endof
#            22 of s" one......... " type endof
#            23 of s" one......... " type endof
#            24 of s" one......... " type endof
#            25 of s" one......... " type endof
#            26 of s" one......... " type endof
#            27 of s" one......... " type endof
#            28 of s" one......... " type endof
#            29 of s" one......... " type endof
#            30 of s" one......... " type endof
#            31 of s" one......... " type endof
#         endcase
#         i 1+ 2 mod 0= if cr then
#     loop
# ;

/* # SPDX-License-Identifier: GPL-3.0-only */
CONSTANT "taskn" , TASKN , TASKN
END TASKN
CONSTANT "task-block" , TASK_BLOCK, TASK_BLOCK_SIZE
END TASK_BLOCK
# ----------------------------------------------------------------------
COLON "vacant", VACANT /* ( -- ) a task that does nothing */
VACANT_0001: /* begin */
	.word XT_PAUSE
	.word XT_DOBRANCH,VACANT_0001 /* again */
	.word XT_EXIT
END VACANT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "init-user", INITMINUSUSER /* ( -- )  */
	.word XT_DOLITERAL
	.word RAM_lower_TASK0_userarea
	.word XT_UP_STORE
	.word XT_DOLITERAL
	.word RAM_upper_TASK0_returnstack
	.word XT_UP_FETCH
	.word XT_DOLITERAL
	.word USER_RP0
	.word XT_PLUS
	.word XT_STORE
	.word XT_DOLITERAL
	.word RAM_upper_TASK0_returnstack
	.word XT_UP_FETCH
	.word XT_DOLITERAL
	.word USER_RP
	.word XT_PLUS
	.word XT_STORE
	.word XT_DOLITERAL
	.word RAM_upper_TASK0_datastack
	.word XT_UP_FETCH
	.word XT_DOLITERAL
	.word USER_SP0
	.word XT_PLUS
	.word XT_STORE
	.word XT_DOLITERAL
	.word RAM_upper_TASK0_datastack
	.word XT_UP_FETCH
	.word XT_DOLITERAL
	.word USER_SP
	.word XT_PLUS
	.word XT_STORE
	.word XT_DOLITERAL
	.word RAM_upper_TASK0_leavestack
	.word XT_UP_FETCH
	.word XT_DOLITERAL
	.word USER_LP0
	.word XT_PLUS
	.word XT_STORE
	.word XT_DOLITERAL
	.word RAM_upper_TASK0_leavestack
	.word XT_UP_FETCH
	.word XT_DOLITERAL
	.word USER_LP
	.word XT_PLUS
	.word XT_STORE
	.word XT_TASKN
	.word XT_ONE
	.word XT_QDOCHECK, XT_DOCONDBRANCH,INITMINUSUSER_0001 /* ?do */
	.word XT_DODO
INITMINUSUSER_0002: /* do */
	.word XT_TASK_BLOCK
	.word XT_ZERO
	.word XT_DODO
INITMINUSUSER_0004: /* do */
	.word XT_I
	.word XT_DOLITERAL
	.word USER_HANDLER
	.word XT_CELLS
	.word XT_LESS
	.word XT_DOCONDBRANCH,INITMINUSUSER_0005 /* if */
	.word XT_UP_FETCH
	.word XT_I
	.word XT_PLUS
	.word XT_FETCH
	.word XT_TASK_BLOCK
	.word XT_J
	.word XT_STAR
	.word XT_PLUS
	.word XT_UP_FETCH
	.word XT_I
	.word XT_PLUS
	.word XT_TASK_BLOCK
	.word XT_J
	.word XT_STAR
	.word XT_PLUS
	.word XT_STORE
INITMINUSUSER_0005: /* then */
	.word XT_CELL
	.word XT_DOPLUSLOOP,INITMINUSUSER_0004 /* +loop */
INITMINUSUSER_0003: /* (for ?do IF required) */
	.word XT_DOLOOP,INITMINUSUSER_0002 /* loop */
INITMINUSUSER_0001: /* (for ?do IF required) */
	.word XT_TASKN
	.word XT_1MINUS
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,INITMINUSUSER_0006 /* ?do */
	.word XT_DODO
INITMINUSUSER_0007: /* do */
	.word XT_UP_FETCH
	.word XT_TASK_BLOCK
	.word XT_I
	.word XT_1PLUS
	.word XT_TASKN
	.word XT_1MINUS
	.word XT_MOD
	.word XT_STAR
	.word XT_PLUS
	.word XT_UP_FETCH
	.word XT_TASK_BLOCK
	.word XT_I
	.word XT_TASKN
	.word XT_1MINUS
	.word XT_MOD
	.word XT_STAR
	.word XT_PLUS
	.word XT_DOLITERAL
	.word USER_LINK
	.word XT_PLUS
	.word XT_STORE
	.word XT_DOXLITERAL
	.word XT_VACANT
	.word XT_TO_BODY
	.word XT_UP_FETCH
	.word XT_TASK_BLOCK
	.word XT_I
	.word XT_TASKN
	.word XT_1MINUS
	.word XT_MOD
	.word XT_STAR
	.word XT_PLUS
	.word XT_DOLITERAL
	.word USER_IP
	.word XT_PLUS
	.word XT_STORE
	.word XT_I
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,INITMINUSUSER_0008 /* if */
	.word XT_DOXLITERAL
	.word XT_QUIT
	.word XT_DOBRANCH,INITMINUSUSER_0009
INITMINUSUSER_0008: /* else */
	.word XT_DOXLITERAL
	.word XT_VACANT
INITMINUSUSER_0009: /* then */
	.word XT_UP_FETCH
	.word XT_TASK_BLOCK
	.word XT_I
	.word XT_TASKN
	.word XT_1MINUS
	.word XT_MOD
	.word XT_STAR
	.word XT_PLUS
	.word XT_DOLITERAL
	.word USER_XT
	.word XT_PLUS
	.word XT_STORE
	.word XT_I
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,INITMINUSUSER_000A /* if */
	.word XT_TRUE
	.word XT_DOBRANCH,INITMINUSUSER_000B
INITMINUSUSER_000A: /* else */
	.word XT_FALSE
INITMINUSUSER_000B: /* then */
	.word XT_UP_FETCH
	.word XT_TASK_BLOCK
	.word XT_I
	.word XT_STAR
	.word XT_PLUS
	.word XT_DOLITERAL
	.word USER_STATUS
	.word XT_PLUS
	.word XT_STORE
	.word XT_DOLOOP,INITMINUSUSER_0007 /* loop */
INITMINUSUSER_0006: /* (for ?do IF required) */
	.word XT_EXIT
END INITMINUSUSER
# ----------------------------------------------------------------------
COLON "task!", TASKBANG /* ( xt n -- ) write task to slot n  */
	.word XT_DUP
	.word XT_ONE
	.word XT_TASKN
	.word XT_1MINUS
	.word XT_WITHIN
	.word XT_NOT
	.word XT_DOCONDBRANCH,TASKBANG_0001 /* if */
	.word XT_DOLITERAL
	.word ENTASK
	.word XT_THROW
TASKBANG_0001: /* then */
	.word XT_TASK_BLOCK
	.word XT_STAR
	.word XT_DOLITERAL
	.word RAM_lower_TASK0_userarea
	.word XT_PLUS
	.word XT_TO_R
	.word XT_DUP
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word USER_XT
	.word XT_PLUS
	.word XT_STORE
	.word XT_TO_BODY
	.word XT_R_FROM
	.word XT_DOLITERAL
	.word USER_IP
	.word XT_PLUS
	.word XT_STORE
	.word XT_EXIT
END TASKBANG
# ----------------------------------------------------------------------
COLON "+task", PLUSTASK /* ( n -- ) make task n active */
	.word XT_DUP
	.word XT_ONE
	.word XT_TASKN
	.word XT_1MINUS
	.word XT_WITHIN
	.word XT_NOT
	.word XT_DOCONDBRANCH,PLUSTASK_0001 /* if */
	.word XT_DOLITERAL
	.word ENTASK
	.word XT_THROW
PLUSTASK_0001: /* then */
	.word XT_TASK_BLOCK
	.word XT_STAR
	.word XT_DOLITERAL
	.word RAM_lower_TASK0_userarea
	.word XT_PLUS
	.word XT_DOLITERAL
	.word USER_STATUS
	.word XT_PLUS
	.word XT_TRUE
	.word XT_SWAP
	.word XT_STORE
	.word XT_EXIT
END PLUSTASK
# ----------------------------------------------------------------------
COLON "-task", MINUSTASK /* ( n -- ) make task n inactive (sleep) */
	.word XT_DUP
	.word XT_ONE
	.word XT_TASKN
	.word XT_1MINUS
	.word XT_WITHIN
	.word XT_NOT
	.word XT_DOCONDBRANCH,MINUSTASK_0001 /* if */
	.word XT_DOLITERAL
	.word ENTASK
	.word XT_THROW
MINUSTASK_0001: /* then */
	.word XT_TASK_BLOCK
	.word XT_STAR
	.word XT_DOLITERAL
	.word RAM_lower_TASK0_userarea
	.word XT_PLUS
	.word XT_DOLITERAL
	.word USER_STATUS
	.word XT_PLUS
	.word XT_FALSE
	.word XT_SWAP
	.word XT_STORE
	.word XT_EXIT
END MINUSTASK
# ----------------------------------------------------------------------
COLON "single", SINGLE /* ( -- ) disable task switching  */
	.word XT_DOLITERAL
	.word XT_NOP
	.word XT_DOXLITERAL
	.word XT_PAUSE
	.word XT_DEFER_STORE
	.word XT_EXIT
END SINGLE
# ----------------------------------------------------------------------
COLON "multi", MULTI /* ( -- ) enable task switchin  */
	.word XT_DOXLITERAL
	.word XT_MTPAUSE
	.word XT_DOXLITERAL
	.word XT_PAUSE
	.word XT_DEFER_STORE
	.word XT_EXIT
END MULTI
# ----------------------------------------------------------------------
COLON "show.task", SHOWDOTTASK /* ( -- ) show tasks  */
	.word XT_DOLITERAL
	.word XT_PAUSE
	.word XT_DEFER_FETCH
	.word XT_DOLITERAL
	.word XT_NOP
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTTASK_0001 /* if */
	STRING "single"
	.word XT_DOBRANCH,SHOWDOTTASK_0002
SHOWDOTTASK_0001: /* else */
	STRING "multi"
SHOWDOTTASK_0002: /* then */
	.word XT_TYPE
	.word XT_CR
	STRING "# UP...... ? LINK.... NAME...."
	.word XT_TYPE
	.word XT_CR
	.word XT_TASKN
	.word XT_1MINUS
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SHOWDOTTASK_0003 /* ?do */
	.word XT_DODO
SHOWDOTTASK_0004: /* do */
	.word XT_UP_FETCH
	.word XT_TASK_BLOCK
	.word XT_I
	.word XT_STAR
	.word XT_PLUS
	.word XT_I
	.word XT_DOT
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_DUP
	.word XT_DOLITERAL
	.word USER_STATUS
	.word XT_PLUS
	.word XT_FETCH
	.word XT_DOCONDBRANCH,SHOWDOTTASK_0005 /* if */
	.word XT_DOLITERAL 
	.word 65 /* A */
	.word XT_EMIT
	.word XT_DOBRANCH,SHOWDOTTASK_0006
SHOWDOTTASK_0005: /* else */
	.word XT_DOLITERAL 
	.word 83 /* S */
	.word XT_EMIT
SHOWDOTTASK_0006: /* then */
	.word XT_SPACE
	.word XT_DUP
	.word XT_DOLITERAL
	.word USER_LINK
	.word XT_PLUS
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_DOLITERAL
	.word USER_XT
	.word XT_PLUS
	.word XT_FETCH
	.word XT_XT2STRING
	.word XT_TYPE
	.word XT_CR
	.word XT_DOLOOP,SHOWDOTTASK_0004 /* loop */
SHOWDOTTASK_0003: /* (for ?do IF required) */
	.word XT_EXIT
END SHOWDOTTASK
# ----------------------------------------------------------------------
COLON "show.user", SHOWDOTUSER /* ( n -- ) show user area task n  */
	STRING "OFF A....... [A]..... Desc........ OFF A....... [A]..... Desc........"
	.word XT_TYPE
	.word XT_CR
	.word XT_DOLITERAL
	.word 32
	.word XT_ZERO
	.word XT_DODO
SHOWDOTUSER_0002: /* do */
	.word XT_I
	.word XT_CELLS
	.word XT_DOLITERAL
	.word 3
	.word XT_UDOTR
	.word XT_SPACE
	.word XT_UP_FETCH
	.word XT_I
	.word XT_CELLS
	.word XT_PLUS
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_I
	.word XT_ZERO
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0003 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0004
SHOWDOTUSER_0003: /* else */
	.word XT_ONE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0005 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0006
SHOWDOTUSER_0005: /* else */
	.word XT_TWO
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0007 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0008
SHOWDOTUSER_0007: /* else */
	.word XT_DOLITERAL
	.word 3
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0009 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_000A
SHOWDOTUSER_0009: /* else */
	.word XT_FOUR
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_000B /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_000C
SHOWDOTUSER_000B: /* else */
	.word XT_DOLITERAL
	.word 5
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_000D /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_000E
SHOWDOTUSER_000D: /* else */
	.word XT_DOLITERAL
	.word 6
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_000F /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0010
SHOWDOTUSER_000F: /* else */
	.word XT_DOLITERAL
	.word 7
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0011 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0012
SHOWDOTUSER_0011: /* else */
	.word XT_DOLITERAL
	.word 8
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0013 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0014
SHOWDOTUSER_0013: /* else */
	.word XT_DOLITERAL
	.word 9
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0015 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0016
SHOWDOTUSER_0015: /* else */
	.word XT_DOLITERAL
	.word 10
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0017 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0018
SHOWDOTUSER_0017: /* else */
	.word XT_DOLITERAL
	.word 11
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0019 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_001A
SHOWDOTUSER_0019: /* else */
	.word XT_DOLITERAL
	.word 12
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_001B /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_001C
SHOWDOTUSER_001B: /* else */
	.word XT_DOLITERAL
	.word 13
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_001D /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_001E
SHOWDOTUSER_001D: /* else */
	.word XT_DOLITERAL
	.word 14
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_001F /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0020
SHOWDOTUSER_001F: /* else */
	.word XT_DOLITERAL
	.word 15
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0021 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0022
SHOWDOTUSER_0021: /* else */
	.word XT_DOLITERAL
	.word 16
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0023 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0024
SHOWDOTUSER_0023: /* else */
	.word XT_DOLITERAL
	.word 17
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0025 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0026
SHOWDOTUSER_0025: /* else */
	.word XT_DOLITERAL
	.word 18
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0027 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0028
SHOWDOTUSER_0027: /* else */
	.word XT_DOLITERAL
	.word 19
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0029 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_002A
SHOWDOTUSER_0029: /* else */
	.word XT_DOLITERAL
	.word 20
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_002B /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_002C
SHOWDOTUSER_002B: /* else */
	.word XT_DOLITERAL
	.word 21
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_002D /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_002E
SHOWDOTUSER_002D: /* else */
	.word XT_DOLITERAL
	.word 22
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_002F /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0030
SHOWDOTUSER_002F: /* else */
	.word XT_DOLITERAL
	.word 23
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0031 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0032
SHOWDOTUSER_0031: /* else */
	.word XT_DOLITERAL
	.word 24
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0033 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0034
SHOWDOTUSER_0033: /* else */
	.word XT_DOLITERAL
	.word 25
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0035 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0036
SHOWDOTUSER_0035: /* else */
	.word XT_DOLITERAL
	.word 26
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0037 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0038
SHOWDOTUSER_0037: /* else */
	.word XT_DOLITERAL
	.word 27
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0039 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_003A
SHOWDOTUSER_0039: /* else */
	.word XT_DOLITERAL
	.word 28
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_003B /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_003C
SHOWDOTUSER_003B: /* else */
	.word XT_DOLITERAL
	.word 29
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_003D /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_003E
SHOWDOTUSER_003D: /* else */
	.word XT_DOLITERAL
	.word 30
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_003F /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0040
SHOWDOTUSER_003F: /* else */
	.word XT_DOLITERAL
	.word 31
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0041 /* if */
	.word XT_DROP
	STRING "one......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUSER_0042
SHOWDOTUSER_0041: /* else */
	.word XT_DROP
SHOWDOTUSER_0042: /* then */
SHOWDOTUSER_0040: /* then */
SHOWDOTUSER_003E: /* then */
SHOWDOTUSER_003C: /* then */
SHOWDOTUSER_003A: /* then */
SHOWDOTUSER_0038: /* then */
SHOWDOTUSER_0036: /* then */
SHOWDOTUSER_0034: /* then */
SHOWDOTUSER_0032: /* then */
SHOWDOTUSER_0030: /* then */
SHOWDOTUSER_002E: /* then */
SHOWDOTUSER_002C: /* then */
SHOWDOTUSER_002A: /* then */
SHOWDOTUSER_0028: /* then */
SHOWDOTUSER_0026: /* then */
SHOWDOTUSER_0024: /* then */
SHOWDOTUSER_0022: /* then */
SHOWDOTUSER_0020: /* then */
SHOWDOTUSER_001E: /* then */
SHOWDOTUSER_001C: /* then */
SHOWDOTUSER_001A: /* then */
SHOWDOTUSER_0018: /* then */
SHOWDOTUSER_0016: /* then */
SHOWDOTUSER_0014: /* then */
SHOWDOTUSER_0012: /* then */
SHOWDOTUSER_0010: /* then */
SHOWDOTUSER_000E: /* then */
SHOWDOTUSER_000C: /* then */
SHOWDOTUSER_000A: /* then */
SHOWDOTUSER_0008: /* then */
SHOWDOTUSER_0006: /* then */
SHOWDOTUSER_0004: /* then */
	.word XT_I
	.word XT_1PLUS
	.word XT_TWO
	.word XT_MOD
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUSER_0043 /* if */
	.word XT_CR
SHOWDOTUSER_0043: /* then */
	.word XT_DOLOOP,SHOWDOTUSER_0002 /* loop */
SHOWDOTUSER_0001: /* (for ?do IF required) */
	.word XT_EXIT
END SHOWDOTUSER
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
