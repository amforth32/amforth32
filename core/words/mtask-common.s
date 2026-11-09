/*
Found 3 name(s) that resolve to multiple XT symbols:
  name='1ms':
    xtname='XT_N1MS'  file='./rv/words/ms.s'
    xtname='XT_1MS'  file='./rv/mcu/ch32v307/words/ms.s'
  name='led.init':
    xtname='XT_LEDDOTINIT'  file='./rv/mcu/ch32v307/words/led.s'
    xtname='XT_LED_INIT'  file='./rv/mcu/ch32v307/words/led.s'
  name='^led':
    xtname='XT_CARETLED'  file='./rv/mcu/ch32v307/words/led.s'
    xtname='XT_TOGLED'  file='./rv/mcu/ch32v307/words/led.s'
*/
#======================================================================
#======================================================================
# transpiling lib/transpiled/mtask.f on 2026/11/09 20:59:34
# \# # SPDX-License-Identifier: GPL-3.0-only
# 
# {
#     CONSTANT "taskn" , TASKN , TASKN
#     END TASKN
# 
#     CONSTANT "task-block" , TASK_BLOCK, TASK_BLOCK_SIZE
#     END TASK_BLOCK
# }
# 
# : vacant \# ( -- ) a task that does nothing
#     begin pause again
# ;
# 
# : reserve \# ( a -- ) wait for resource to be available and claim
#     begin pause dup @ until false swap !
# ;
# 
# : release \# ( a -- ) mark resource as not available
#     true swap !
# ;
# 
# : task@ \# ( n -- a ) returns task block of task n
#     task-block * symbol RAM_TASK0 +
# ;
# 
# :~ init-user \# ( -- )
# 
#     \ for TASK0 operator when this is executed sp and rp not
#     \ correct but that is not important as they will written
#     \ on first task switch. However, for task1...taskn-1 they
#     \ ARE the initial values
# 
#     symbol RAM_TASK0 up!
#     symbol USER_RP0 up@ + up@ symbol USER_RP + !
#     symbol USER_SP0 up@ + up@ symbol USER_SP + !
#     symbol USER_LP0 up@ + up@ symbol USER_LP + !
# 
#     \ taskn 1 ?do
#     \     task-block 0 do
#     \         i symbol USER_HANDLER cells < if
#     \             up@ i + @ task-block j * + up@ i + task-block j * + !
#     \         then
#     \     cell +loop
#     \ loop
# 
#     taskn 1- 0 ?do
#         \ link task i+1 to task i
#         i 1+ task@ i task@ symbol USER_LINK + !
# 
#         \ set task XT
#         i 0= if ['] quit else ['] vacant then
#         i task@ symbol USER_XT + !
#         i 0= if
#             \ set operator as active
#             true i task@ symbol USER_STATUS + !
#         else
#             i task.warm
#         then
#     loop
# 
#     \ close the task ring (exclude the ISR task)
#     up@ taskn 2- task@ symbol USER_LINK + !
# ;
# 
# : task! \# ( xt n -- ) write task to slot n
#     dup 1 taskn 1- within not if symbol ENTASK throw then
#     task@ >r
#     dup   r@ symbol USER_XT + !
#     >body r> symbol USER_IP + !
# ;
# 
# : task.warm \# ( n -- ) reset task n
#     dup 1 taskn 1- within not if symbol ENTASK throw then
#     task@ >r
# 
#     r@ symbol USER_XT  + @ >body r@ symbol USER_IP + !
#     r@ symbol USER_SP0 +       r@ symbol USER_SP + !
#     r@ symbol USER_RP0 +       r@ symbol USER_RP + !
#     r@ symbol USER_LP0 +       r@ symbol USER_LP + !
# 
#     0 r@ symbol USER_LOOP_INDEX + !
#     0 r@ symbol USER_LOOP_LIMIT + !
#     0 r@ symbol USER_STATUS     + !
# 
#     10 r@ symbol USER_BASE + !
# 
#     rdrop
# ;
# 
# : task.warm-all \# ( -- ) reset all tasks execept operator
#     taskn 1- 1 ?do i task.warm loop
# ;
# 
# : +task \# ( n -- ) make task n active
#     dup 1 taskn 1- within not if symbol ENTASK throw then
#     task@ symbol USER_STATUS + true swap !
# ;
# 
# : -task \# ( n -- ) make task n inactive (sleep)
#     dup 1 taskn 1- within not if symbol ENTASK throw then
#     task@ symbol USER_STATUS + false swap !
# ;
# 
# : single \# ( -- ) disable task switching
#     symbol XT_NOP is pause
# ;
# 
# : multi \# ( -- ) enable task switching
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
#         i .
#         i task@
#         dup hex.
#         dup symbol USER_STATUS + @ if
#             [char] A emit else [char] S emit then space
#         dup symbol USER_LINK   + @ hex.
#             symbol USER_XT + @ xt>string type
#         cr
#     loop
# ;
# 
# : show.ua ( n -- ) \ show user area task n
#     \ drop
#     s" OFF A....... [A]..... Desc........ OFF A....... [A]..... Desc........"
#     type cr
#     symbol userarea_size 4 / 0 do
#         i cells 3 u.r space \ print cell offset
#         dup task-block * up@ + ( n -- addr ) \ addr is taskN UA
#         i cells + dup hex. @ hex. \ emit i-th UA field address and value
#         i 4 * case
#         symbol USER_LINK        of s" LINK........ " type endof
#         symbol USER_STATUS      of s" STATUS...... " type endof
#         symbol USER_XT          of s" XT.......... " type endof
#         symbol USER_HANDLER     of s" HANDLER..... " type endof
#         symbol USER_LOOP_INDEX  of s" LOOP_INDEX.. " type endof
#         symbol USER_LOOP_LIMIT  of s" LOOP_LIMIT.. " type endof
#         symbol USER_RP          of s" RP.......... " type endof
#         symbol USER_SP          of s" SP.......... " type endof
#         symbol USER_LP          of s" LP.......... " type endof
#         symbol USER_IP          of s" IP.......... " type endof
#         symbol USER_TOS         of s" TOS......... " type endof
#         symbol USER_BASE        of s" BASE........ " type endof
#         symbol USER_EMIT        of s" EMIT........ " type endof
#         s" ............ " type
#         endcase
#         i 1+ 2 mod 0= if cr then
#     loop
#     drop
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
COLON "reserve", RESERVE /* ( a -- ) wait for resource to be available and claim */
RESERVE_0001: /* begin */
	.word XT_PAUSE
	.word XT_DUP
	.word XT_FETCH
	.word XT_DOCONDBRANCH,RESERVE_0001 /* until */
	.word XT_FALSE
	.word XT_SWAP
	.word XT_STORE
	.word XT_EXIT
END RESERVE
# ----------------------------------------------------------------------
COLON "release", RELEASE /* ( a -- ) mark resource as not available */
	.word XT_TRUE
	.word XT_SWAP
	.word XT_STORE
	.word XT_EXIT
END RELEASE
# ----------------------------------------------------------------------
COLON "task@", TASKAT /* ( n -- a ) returns task block of task n */
	.word XT_TASK_BLOCK
	.word XT_STAR
	.word XT_DOLITERAL
	.word RAM_TASK0
	.word XT_PLUS
	.word XT_EXIT
END TASKAT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "init-user", INITMINUSUSER /* ( -- ) */
	.word XT_DOLITERAL
	.word RAM_TASK0
	.word XT_UP_STORE
	.word XT_DOLITERAL
	.word USER_RP0
	.word XT_UP_FETCH
	.word XT_PLUS
	.word XT_UP_FETCH
	.word XT_DOLITERAL
	.word USER_RP
	.word XT_PLUS
	.word XT_STORE
	.word XT_DOLITERAL
	.word USER_SP0
	.word XT_UP_FETCH
	.word XT_PLUS
	.word XT_UP_FETCH
	.word XT_DOLITERAL
	.word USER_SP
	.word XT_PLUS
	.word XT_STORE
	.word XT_DOLITERAL
	.word USER_LP0
	.word XT_UP_FETCH
	.word XT_PLUS
	.word XT_UP_FETCH
	.word XT_DOLITERAL
	.word USER_LP
	.word XT_PLUS
	.word XT_STORE
	.word XT_TASKN
	.word XT_1MINUS
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,INITMINUSUSER_0001 /* ?do */
	.word XT_DODO
INITMINUSUSER_0002: /* do */
	.word XT_I
	.word XT_1PLUS
	.word XT_TASKAT
	.word XT_I
	.word XT_TASKAT
	.word XT_DOLITERAL
	.word USER_LINK
	.word XT_PLUS
	.word XT_STORE
	.word XT_I
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,INITMINUSUSER_0003 /* if */
	.word XT_DOXLITERAL
	.word XT_QUIT
	.word XT_DOBRANCH,INITMINUSUSER_0004
INITMINUSUSER_0003: /* else */
	.word XT_DOXLITERAL
	.word XT_VACANT
INITMINUSUSER_0004: /* then */
	.word XT_I
	.word XT_TASKAT
	.word XT_DOLITERAL
	.word USER_XT
	.word XT_PLUS
	.word XT_STORE
	.word XT_I
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,INITMINUSUSER_0005 /* if */
	.word XT_TRUE
	.word XT_I
	.word XT_TASKAT
	.word XT_DOLITERAL
	.word USER_STATUS
	.word XT_PLUS
	.word XT_STORE
	.word XT_DOBRANCH,INITMINUSUSER_0006
INITMINUSUSER_0005: /* else */
	.word XT_I
	.word XT_TASKDOTWARM
INITMINUSUSER_0006: /* then */
	.word XT_DOLOOP,INITMINUSUSER_0002 /* loop */
INITMINUSUSER_0001: /* (for ?do IF required) */
	.word XT_UP_FETCH
	.word XT_TASKN
	.word XT_2MINUS
	.word XT_TASKAT
	.word XT_DOLITERAL
	.word USER_LINK
	.word XT_PLUS
	.word XT_STORE
	.word XT_EXIT
END INITMINUSUSER
# ----------------------------------------------------------------------
COLON "task!", TASKBANG /* ( xt n -- ) write task to slot n */
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
	.word XT_TASKAT
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
COLON "task.warm", TASKDOTWARM /* ( n -- ) reset task n */
	.word XT_DUP
	.word XT_ONE
	.word XT_TASKN
	.word XT_1MINUS
	.word XT_WITHIN
	.word XT_NOT
	.word XT_DOCONDBRANCH,TASKDOTWARM_0001 /* if */
	.word XT_DOLITERAL
	.word ENTASK
	.word XT_THROW
TASKDOTWARM_0001: /* then */
	.word XT_TASKAT
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word USER_XT
	.word XT_PLUS
	.word XT_FETCH
	.word XT_TO_BODY
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word USER_IP
	.word XT_PLUS
	.word XT_STORE
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word USER_SP0
	.word XT_PLUS
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word USER_SP
	.word XT_PLUS
	.word XT_STORE
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word USER_RP0
	.word XT_PLUS
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word USER_RP
	.word XT_PLUS
	.word XT_STORE
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word USER_LP0
	.word XT_PLUS
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word USER_LP
	.word XT_PLUS
	.word XT_STORE
	.word XT_ZERO
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word USER_LOOP_INDEX
	.word XT_PLUS
	.word XT_STORE
	.word XT_ZERO
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word USER_LOOP_LIMIT
	.word XT_PLUS
	.word XT_STORE
	.word XT_ZERO
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word USER_STATUS
	.word XT_PLUS
	.word XT_STORE
	.word XT_DOLITERAL
	.word 10
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word USER_BASE
	.word XT_PLUS
	.word XT_STORE
	.word XT_RDROP
	.word XT_EXIT
END TASKDOTWARM
# ----------------------------------------------------------------------
COLON "task.warm-all", TASKDOTWARMMINUSALL /* ( -- ) reset all tasks execept operator */
	.word XT_TASKN
	.word XT_1MINUS
	.word XT_ONE
	.word XT_QDOCHECK, XT_DOCONDBRANCH,TASKDOTWARMMINUSALL_0001 /* ?do */
	.word XT_DODO
TASKDOTWARMMINUSALL_0002: /* do */
	.word XT_I
	.word XT_TASKDOTWARM
	.word XT_DOLOOP,TASKDOTWARMMINUSALL_0002 /* loop */
TASKDOTWARMMINUSALL_0001: /* (for ?do IF required) */
	.word XT_EXIT
END TASKDOTWARMMINUSALL
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
	.word XT_TASKAT
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
	.word XT_TASKAT
	.word XT_DOLITERAL
	.word USER_STATUS
	.word XT_PLUS
	.word XT_FALSE
	.word XT_SWAP
	.word XT_STORE
	.word XT_EXIT
END MINUSTASK
# ----------------------------------------------------------------------
COLON "single", SINGLE /* ( -- ) disable task switching */
	.word XT_DOLITERAL
	.word XT_NOP
	.word XT_DOXLITERAL
	.word XT_PAUSE
	.word XT_DEFER_STORE
	.word XT_EXIT
END SINGLE
# ----------------------------------------------------------------------
COLON "multi", MULTI /* ( -- ) enable task switching */
	.word XT_DOXLITERAL
	.word XT_MTPAUSE
	.word XT_DOXLITERAL
	.word XT_PAUSE
	.word XT_DEFER_STORE
	.word XT_EXIT
END MULTI
# ----------------------------------------------------------------------
COLON "show.task", SHOWDOTTASK /* ( -- ) show tasks */
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
	.word XT_I
	.word XT_DOT
	.word XT_I
	.word XT_TASKAT
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
COLON "show.ua", SHOWDOTUA 
	STRING "OFF A....... [A]..... Desc........ OFF A....... [A]..... Desc........"
	.word XT_TYPE
	.word XT_CR
	.word XT_DOLITERAL
	.word userarea_size
	.word XT_FOUR
	.word XT_SLASH
	.word XT_ZERO
	.word XT_DODO
SHOWDOTUA_0002: /* do */
	.word XT_I
	.word XT_CELLS
	.word XT_DOLITERAL
	.word 3
	.word XT_UDOTR
	.word XT_SPACE
	.word XT_DUP
	.word XT_TASK_BLOCK
	.word XT_STAR
	.word XT_UP_FETCH
	.word XT_PLUS
	.word XT_I
	.word XT_CELLS
	.word XT_PLUS
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_I
	.word XT_FOUR
	.word XT_STAR
	.word XT_DOLITERAL
	.word USER_LINK
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUA_0003 /* if */
	.word XT_DROP
	STRING "LINK........ "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUA_0004
SHOWDOTUA_0003: /* else */
	.word XT_DOLITERAL
	.word USER_STATUS
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUA_0005 /* if */
	.word XT_DROP
	STRING "STATUS...... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUA_0006
SHOWDOTUA_0005: /* else */
	.word XT_DOLITERAL
	.word USER_XT
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUA_0007 /* if */
	.word XT_DROP
	STRING "XT.......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUA_0008
SHOWDOTUA_0007: /* else */
	.word XT_DOLITERAL
	.word USER_HANDLER
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUA_0009 /* if */
	.word XT_DROP
	STRING "HANDLER..... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUA_000A
SHOWDOTUA_0009: /* else */
	.word XT_DOLITERAL
	.word USER_LOOP_INDEX
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUA_000B /* if */
	.word XT_DROP
	STRING "LOOP_INDEX.. "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUA_000C
SHOWDOTUA_000B: /* else */
	.word XT_DOLITERAL
	.word USER_LOOP_LIMIT
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUA_000D /* if */
	.word XT_DROP
	STRING "LOOP_LIMIT.. "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUA_000E
SHOWDOTUA_000D: /* else */
	.word XT_DOLITERAL
	.word USER_RP
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUA_000F /* if */
	.word XT_DROP
	STRING "RP.......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUA_0010
SHOWDOTUA_000F: /* else */
	.word XT_DOLITERAL
	.word USER_SP
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUA_0011 /* if */
	.word XT_DROP
	STRING "SP.......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUA_0012
SHOWDOTUA_0011: /* else */
	.word XT_DOLITERAL
	.word USER_LP
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUA_0013 /* if */
	.word XT_DROP
	STRING "LP.......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUA_0014
SHOWDOTUA_0013: /* else */
	.word XT_DOLITERAL
	.word USER_IP
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUA_0015 /* if */
	.word XT_DROP
	STRING "IP.......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUA_0016
SHOWDOTUA_0015: /* else */
	.word XT_DOLITERAL
	.word USER_TOS
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUA_0017 /* if */
	.word XT_DROP
	STRING "TOS......... "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUA_0018
SHOWDOTUA_0017: /* else */
	.word XT_DOLITERAL
	.word USER_BASE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUA_0019 /* if */
	.word XT_DROP
	STRING "BASE........ "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUA_001A
SHOWDOTUA_0019: /* else */
	.word XT_DOLITERAL
	.word USER_EMIT
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUA_001B /* if */
	.word XT_DROP
	STRING "EMIT........ "
	.word XT_TYPE
	.word XT_DOBRANCH,SHOWDOTUA_001C
SHOWDOTUA_001B: /* else */
	STRING "............ "
	.word XT_TYPE
	.word XT_DROP
SHOWDOTUA_001C: /* then */
SHOWDOTUA_001A: /* then */
SHOWDOTUA_0018: /* then */
SHOWDOTUA_0016: /* then */
SHOWDOTUA_0014: /* then */
SHOWDOTUA_0012: /* then */
SHOWDOTUA_0010: /* then */
SHOWDOTUA_000E: /* then */
SHOWDOTUA_000C: /* then */
SHOWDOTUA_000A: /* then */
SHOWDOTUA_0008: /* then */
SHOWDOTUA_0006: /* then */
SHOWDOTUA_0004: /* then */
	.word XT_I
	.word XT_1PLUS
	.word XT_TWO
	.word XT_MOD
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,SHOWDOTUA_001D /* if */
	.word XT_CR
SHOWDOTUA_001D: /* then */
	.word XT_DOLOOP,SHOWDOTUA_0002 /* loop */
SHOWDOTUA_0001: /* (for ?do IF required) */
	.word XT_DROP
	.word XT_EXIT
END SHOWDOTUA
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
