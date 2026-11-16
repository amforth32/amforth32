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
# transpiling lib/transpiled/mtask.f on 2026/11/16 20:19:55
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
# 
# :~ init-task \# ( n -- ) configure task block for task n
#     task@ >r
#     r@ symbol USER_XT  +  @ >body r@ symbol USER_IP + !
#     r@ symbol USER_SP0 +  r@ symbol USER_SP + !
#     r@ symbol USER_RP0 +  r@ symbol USER_RP + !
#     r@ symbol USER_LP0 +  r@ symbol USER_LP + !
#     0                     r@ symbol USER_STATUS + !
#     rdrop
# ;
# 
# :~ init-user \# ( -- )
# 
#     \ set the UP register to TASK0
#     symbol RAM_TASK0 up!
# 
#     taskn 0 ?do
#         \ link task i+1 to task i
#         i 1+ task@ i task@ symbol USER_LINK + !
# 
#         \ set task XT
#         i 0= if ['] quit else ['] vacant then
#         i task@ symbol USER_XT + !
#         i 0= if
#             \ cannot use task.warm on TASK0 because it is already running
#             \ just make sure the task is configured properly
#             i init-task
#             \ set operator as active
#             true i task@ symbol USER_STATUS + !
#         else
#             i task.warm
#         then
#     loop
# 
#     \ close the task ring
#     up@ taskn 1- task@ symbol USER_LINK + !
# ;
# 
# : task! \# ( xt n -- ) write task to slot n
#     dup 1 taskn within not if symbol ENTASK throw then
#     task@ >r
#     dup   r@ symbol USER_XT + !
#     >body r> symbol USER_IP + !
# ;
# 
# : task.warm \# ( n -- ) reset task n
#     dup 1 taskn within not if symbol ENTASK throw then
#     \ make sure the task is not resetting itself while running
#     dup task@ up@ = if symbol ENTASK throw then
# 
#     \ configure the task
#     dup init-task
#     \ reset task state
#     task@ >r
#     0 r@ symbol USER_LOOP_INDEX + !
#     0 r@ symbol USER_LOOP_LIMIT + !
#     10 r@ symbol USER_BASE + !
#     rdrop
# ;
# 
# : task.warm-all \# ( -- ) reset all tasks except operator
#     taskn 1- 1 ?do i task.warm loop
# ;
# 
# : +task \# ( n -- ) make task n active
#     dup 1 taskn within not if symbol ENTASK throw then
#     task@ symbol USER_STATUS + true swap !
# ;
# 
# : -task \# ( n -- ) make task n inactive (sleep)
#     dup 1 taskn within not if symbol ENTASK throw then
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
# : task.ds \# ( n -- ) show datastack of task n (when dormant)
#     dup 0 taskn within not if symbol ENTASK throw then
#     task@ dup up@ = if drop s" EXECUTING" type cr exit then
#     dup symbol USER_SP0 + swap symbol USER_SP + @     \# ( sp0 sp )
#     over over - 2 rshift s" DS(" type dec. s" ): " type
#     ?do i @ . cell +loop
#     cr
# ;
# 
# : task.rs \# ( n -- ) show datastack of task n (when dormant)
#     dup 0 taskn within not if symbol ENTASK throw then
#     task@ dup up@ = if drop s" EXECUTING" type cr exit then
#     dup symbol USER_RP0 + swap symbol USER_RP + @     \# ( sp0 sp )
#     over over - 2 rshift s" RS(" type dec. s" ): " type
#     ?do i @ . cell +loop
#     cr
# ;
# 
# : task.bt \# ( n -- ) show datastack of task n (when dormant)
#     dup 0 taskn within not if symbol ENTASK throw then
#     task@ dup up@ = if drop s" EXECUTING" type cr exit then
#     s" BT: " type
#     dup symbol USER_RP0 + swap dup symbol USER_RP + @ swap   \# ( sp0 sp up )
#     symbol USER_IP + @ \# ( sp0 sp ip )
#     ?dup if
#         \ ip points to next word to be executed
#         dup cell- @ \# (sp0 sp ip wd)
#         xt>string type space \# emit wd
#         .ip then \# emit ip
#     ?do i @ .ip cell +loop
#     cr
# ;
# 
# : task.ua \# ( n -- ) show user area of task n
#     \ drop
#     s" OFF A....... [A]..... Desc............ OFF A....... [A]..... Desc............"
#     type cr
#     symbol userarea_size 4 / 0 do
#         i cells 3 u.r space \ print cell offset
#         dup task-block * symbol RAM_TASK0 + ( n -- addr ) \ addr is taskN UA
#         i cells + dup hex. @ hex. \ emit i-th UA field address and value
#         i 4 * case
#         symbol USER_LINK        of s" LINK............ " type endof
#         symbol USER_STATUS      of s" STATUS.......... " type endof
#         symbol USER_XT          of s" XT.............. " type endof
#         symbol USER_HANDLER     of s" HANDLER......... " type endof
#         symbol USER_LOOP_INDEX  of s" LOOP_INDEX...... " type endof
#         symbol USER_LOOP_LIMIT  of s" LOOP_LIMIT...... " type endof
#         symbol USER_RP          of s" RP.............. " type endof
#         symbol USER_SP          of s" SP.............. " type endof
#         symbol USER_LP          of s" LP.............. " type endof
#         symbol USER_IP          of s" IP.............. " type endof
#         symbol USER_TOS         of s" TOS............. " type endof
#         symbol USER_BASE        of s" BASE............ " type endof
#         symbol USER_EMIT        of s" EMIT............ " type endof
# { .if WANT_DEBUGGER == 1 }
#         symbol USER_DEBUG_BREAK of s" USER_DEBUG_BREAK " type endof
#         symbol USER_DEBUG_NEXT  of s" USER_DEBUG_NEXT. " type endof
# { .endif }
#         s" ................ " type
#         endcase
#         i 1+ 2 mod 0= if cr then
#     loop
#     drop
# ;
# 
# : show.tasks \# ( -- ) show all tasks
#     \ need single or multi
#     symbol XT_PAUSE defer@ symbol XT_NOP = if
#         s" single"
#     else
#         s" multi"
#     then type cr
#     s" # UP...... ? LINK.... .DS .RS .LS NAME...." type cr
#     taskn 0 ?do
#         i .
#         i task@
#         dup hex.
#         dup symbol USER_STATUS + @ if
#             [char] A emit else [char] S emit then space
#         dup symbol USER_LINK   + @ hex.
#         dup dup symbol USER_SP0 + swap symbol USER_SP + @ - 2 rshift 3 u.r space
#         dup dup symbol USER_RP0 + swap symbol USER_RP + @ - 2 rshift 3 u.r space
#         dup dup symbol USER_LP0 + swap symbol USER_LP + @ - 2 rshift 3 u.r space
#         symbol USER_XT + @ xt>string type
#         cr
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
NONAME "init-task", INITMINUSTASK /* ( n -- ) configure task block for task n */
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
	.word USER_STATUS
	.word XT_PLUS
	.word XT_STORE
	.word XT_RDROP
	.word XT_EXIT
END INITMINUSTASK
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "init-user", INITMINUSUSER /* ( -- ) */
	.word XT_DOLITERAL
	.word RAM_TASK0
	.word XT_UP_STORE
	.word XT_TASKN
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
	.word XT_I
	.word XT_INITMINUSTASK
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
	.word XT_1MINUS
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
	.word XT_WITHIN
	.word XT_NOT
	.word XT_DOCONDBRANCH,TASKDOTWARM_0001 /* if */
	.word XT_DOLITERAL
	.word ENTASK
	.word XT_THROW
TASKDOTWARM_0001: /* then */
	.word XT_DUP
	.word XT_TASKAT
	.word XT_UP_FETCH
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTWARM_0002 /* if */
	.word XT_DOLITERAL
	.word ENTASK
	.word XT_THROW
TASKDOTWARM_0002: /* then */
	.word XT_DUP
	.word XT_INITMINUSTASK
	.word XT_TASKAT
	.word XT_TO_R
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
COLON "task.warm-all", TASKDOTWARMMINUSALL /* ( -- ) reset all tasks except operator */
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
COLON "task.ds", TASKDOTDS /* ( n -- ) show datastack of task n (when dormant) */
	.word XT_DUP
	.word XT_ZERO
	.word XT_TASKN
	.word XT_WITHIN
	.word XT_NOT
	.word XT_DOCONDBRANCH,TASKDOTDS_0001 /* if */
	.word XT_DOLITERAL
	.word ENTASK
	.word XT_THROW
TASKDOTDS_0001: /* then */
	.word XT_TASKAT
	.word XT_DUP
	.word XT_UP_FETCH
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTDS_0002 /* if */
	.word XT_DROP
	STRING "EXECUTING"
	.word XT_TYPE
	.word XT_CR
	.word XT_FINISH
TASKDOTDS_0002: /* then */
	.word XT_DUP
	.word XT_DOLITERAL
	.word USER_SP0
	.word XT_PLUS
	.word XT_SWAP
	.word XT_DOLITERAL
	.word USER_SP
	.word XT_PLUS
	.word XT_FETCH
/* ( sp0 sp )  */
	.word XT_OVER
	.word XT_OVER
	.word XT_MINUS
	.word XT_TWO
	.word XT_RSHIFT
	STRING "DS("
	.word XT_TYPE
	.word XT_DECDOT
	STRING "): "
	.word XT_TYPE
	.word XT_QDOCHECK, XT_DOCONDBRANCH,TASKDOTDS_0003 /* ?do */
	.word XT_DODO
TASKDOTDS_0004: /* do */
	.word XT_I
	.word XT_FETCH
	.word XT_DOT
	.word XT_CELL
	.word XT_DOPLUSLOOP,TASKDOTDS_0004 /* +loop */
TASKDOTDS_0003: /* (for ?do IF required) */
	.word XT_CR
	.word XT_EXIT
END TASKDOTDS
# ----------------------------------------------------------------------
COLON "task.rs", TASKDOTRS /* ( n -- ) show datastack of task n (when dormant) */
	.word XT_DUP
	.word XT_ZERO
	.word XT_TASKN
	.word XT_WITHIN
	.word XT_NOT
	.word XT_DOCONDBRANCH,TASKDOTRS_0001 /* if */
	.word XT_DOLITERAL
	.word ENTASK
	.word XT_THROW
TASKDOTRS_0001: /* then */
	.word XT_TASKAT
	.word XT_DUP
	.word XT_UP_FETCH
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTRS_0002 /* if */
	.word XT_DROP
	STRING "EXECUTING"
	.word XT_TYPE
	.word XT_CR
	.word XT_FINISH
TASKDOTRS_0002: /* then */
	.word XT_DUP
	.word XT_DOLITERAL
	.word USER_RP0
	.word XT_PLUS
	.word XT_SWAP
	.word XT_DOLITERAL
	.word USER_RP
	.word XT_PLUS
	.word XT_FETCH
/* ( sp0 sp )  */
	.word XT_OVER
	.word XT_OVER
	.word XT_MINUS
	.word XT_TWO
	.word XT_RSHIFT
	STRING "RS("
	.word XT_TYPE
	.word XT_DECDOT
	STRING "): "
	.word XT_TYPE
	.word XT_QDOCHECK, XT_DOCONDBRANCH,TASKDOTRS_0003 /* ?do */
	.word XT_DODO
TASKDOTRS_0004: /* do */
	.word XT_I
	.word XT_FETCH
	.word XT_DOT
	.word XT_CELL
	.word XT_DOPLUSLOOP,TASKDOTRS_0004 /* +loop */
TASKDOTRS_0003: /* (for ?do IF required) */
	.word XT_CR
	.word XT_EXIT
END TASKDOTRS
# ----------------------------------------------------------------------
COLON "task.bt", TASKDOTBT /* ( n -- ) show datastack of task n (when dormant) */
	.word XT_DUP
	.word XT_ZERO
	.word XT_TASKN
	.word XT_WITHIN
	.word XT_NOT
	.word XT_DOCONDBRANCH,TASKDOTBT_0001 /* if */
	.word XT_DOLITERAL
	.word ENTASK
	.word XT_THROW
TASKDOTBT_0001: /* then */
	.word XT_TASKAT
	.word XT_DUP
	.word XT_UP_FETCH
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTBT_0002 /* if */
	.word XT_DROP
	STRING "EXECUTING"
	.word XT_TYPE
	.word XT_CR
	.word XT_FINISH
TASKDOTBT_0002: /* then */
	STRING "BT: "
	.word XT_TYPE
	.word XT_DUP
	.word XT_DOLITERAL
	.word USER_RP0
	.word XT_PLUS
	.word XT_SWAP
	.word XT_DUP
	.word XT_DOLITERAL
	.word USER_RP
	.word XT_PLUS
	.word XT_FETCH
	.word XT_SWAP
/* ( sp0 sp up ) */
	.word XT_DOLITERAL
	.word USER_IP
	.word XT_PLUS
	.word XT_FETCH
/* ( sp0 sp ip ) */
	.word XT_QDUP
	.word XT_DOCONDBRANCH,TASKDOTBT_0003 /* if */
	.word XT_DUP
	.word XT_CELLMINUS
	.word XT_FETCH
/* (sp0 sp ip wd)  */
	.word XT_XT2STRING
	.word XT_TYPE
	.word XT_SPACE
/* emit wd */
	.word XT_DOTIP
TASKDOTBT_0003: /* then */
/* emit ip */
	.word XT_QDOCHECK, XT_DOCONDBRANCH,TASKDOTBT_0004 /* ?do */
	.word XT_DODO
TASKDOTBT_0005: /* do */
	.word XT_I
	.word XT_FETCH
	.word XT_DOTIP
	.word XT_CELL
	.word XT_DOPLUSLOOP,TASKDOTBT_0005 /* +loop */
TASKDOTBT_0004: /* (for ?do IF required) */
	.word XT_CR
	.word XT_EXIT
END TASKDOTBT
# ----------------------------------------------------------------------
COLON "task.ua", TASKDOTUA /* ( n -- ) show user area of task n */
	STRING "OFF A....... [A]..... Desc............ OFF A....... [A]..... Desc............"
	.word XT_TYPE
	.word XT_CR
	.word XT_DOLITERAL
	.word userarea_size
	.word XT_FOUR
	.word XT_SLASH
	.word XT_ZERO
	.word XT_DODO
TASKDOTUA_0002: /* do */
	.word XT_I
	.word XT_CELLS
	.word XT_DOLITERAL
	.word 3
	.word XT_UDOTR
	.word XT_SPACE
	.word XT_DUP
	.word XT_TASK_BLOCK
	.word XT_STAR
	.word XT_DOLITERAL
	.word RAM_TASK0
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
	.word XT_DOCONDBRANCH,TASKDOTUA_0003 /* if */
	.word XT_DROP
	STRING "LINK............ "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_0004
TASKDOTUA_0003: /* else */
	.word XT_DOLITERAL
	.word USER_STATUS
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_0005 /* if */
	.word XT_DROP
	STRING "STATUS.......... "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_0006
TASKDOTUA_0005: /* else */
	.word XT_DOLITERAL
	.word USER_XT
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_0007 /* if */
	.word XT_DROP
	STRING "XT.............. "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_0008
TASKDOTUA_0007: /* else */
	.word XT_DOLITERAL
	.word USER_HANDLER
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_0009 /* if */
	.word XT_DROP
	STRING "HANDLER......... "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_000A
TASKDOTUA_0009: /* else */
	.word XT_DOLITERAL
	.word USER_LOOP_INDEX
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_000B /* if */
	.word XT_DROP
	STRING "LOOP_INDEX...... "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_000C
TASKDOTUA_000B: /* else */
	.word XT_DOLITERAL
	.word USER_LOOP_LIMIT
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_000D /* if */
	.word XT_DROP
	STRING "LOOP_LIMIT...... "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_000E
TASKDOTUA_000D: /* else */
	.word XT_DOLITERAL
	.word USER_RP
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_000F /* if */
	.word XT_DROP
	STRING "RP.............. "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_0010
TASKDOTUA_000F: /* else */
	.word XT_DOLITERAL
	.word USER_SP
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_0011 /* if */
	.word XT_DROP
	STRING "SP.............. "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_0012
TASKDOTUA_0011: /* else */
	.word XT_DOLITERAL
	.word USER_LP
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_0013 /* if */
	.word XT_DROP
	STRING "LP.............. "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_0014
TASKDOTUA_0013: /* else */
	.word XT_DOLITERAL
	.word USER_IP
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_0015 /* if */
	.word XT_DROP
	STRING "IP.............. "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_0016
TASKDOTUA_0015: /* else */
	.word XT_DOLITERAL
	.word USER_TOS
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_0017 /* if */
	.word XT_DROP
	STRING "TOS............. "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_0018
TASKDOTUA_0017: /* else */
	.word XT_DOLITERAL
	.word USER_BASE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_0019 /* if */
	.word XT_DROP
	STRING "BASE............ "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_001A
TASKDOTUA_0019: /* else */
	.word XT_DOLITERAL
	.word USER_EMIT
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_001B /* if */
	.word XT_DROP
	STRING "EMIT............ "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_001C
TASKDOTUA_001B: /* else */
.if WANT_DEBUGGER == 1
	.word XT_DOLITERAL
	.word USER_DEBUG_BREAK
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_001D /* if */
	.word XT_DROP
	STRING "USER_DEBUG_BREAK "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_001E
TASKDOTUA_001D: /* else */
	.word XT_DOLITERAL
	.word USER_DEBUG_NEXT
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_001F /* if */
	.word XT_DROP
	STRING "USER_DEBUG_NEXT. "
	.word XT_TYPE
	.word XT_DOBRANCH,TASKDOTUA_0020
TASKDOTUA_001F: /* else */
.endif
	STRING "................ "
	.word XT_TYPE
	.word XT_DROP
TASKDOTUA_0020: /* then */
TASKDOTUA_001E: /* then */
TASKDOTUA_001C: /* then */
TASKDOTUA_001A: /* then */
TASKDOTUA_0018: /* then */
TASKDOTUA_0016: /* then */
TASKDOTUA_0014: /* then */
TASKDOTUA_0012: /* then */
TASKDOTUA_0010: /* then */
TASKDOTUA_000E: /* then */
TASKDOTUA_000C: /* then */
TASKDOTUA_000A: /* then */
TASKDOTUA_0008: /* then */
TASKDOTUA_0006: /* then */
TASKDOTUA_0004: /* then */
	.word XT_I
	.word XT_1PLUS
	.word XT_TWO
	.word XT_MOD
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,TASKDOTUA_0021 /* if */
	.word XT_CR
TASKDOTUA_0021: /* then */
	.word XT_DOLOOP,TASKDOTUA_0002 /* loop */
TASKDOTUA_0001: /* (for ?do IF required) */
	.word XT_DROP
	.word XT_EXIT
END TASKDOTUA
# ----------------------------------------------------------------------
COLON "show.tasks", SHOWDOTTASKS /* ( -- ) show all tasks */
	.word XT_DOLITERAL
	.word XT_PAUSE
	.word XT_DEFER_FETCH
	.word XT_DOLITERAL
	.word XT_NOP
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SHOWDOTTASKS_0001 /* if */
	STRING "single"
	.word XT_DOBRANCH,SHOWDOTTASKS_0002
SHOWDOTTASKS_0001: /* else */
	STRING "multi"
SHOWDOTTASKS_0002: /* then */
	.word XT_TYPE
	.word XT_CR
	STRING "# UP...... ? LINK.... .DS .RS .LS NAME...."
	.word XT_TYPE
	.word XT_CR
	.word XT_TASKN
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SHOWDOTTASKS_0003 /* ?do */
	.word XT_DODO
SHOWDOTTASKS_0004: /* do */
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
	.word XT_DOCONDBRANCH,SHOWDOTTASKS_0005 /* if */
	.word XT_DOLITERAL 
	.word 65 /* A */
	.word XT_EMIT
	.word XT_DOBRANCH,SHOWDOTTASKS_0006
SHOWDOTTASKS_0005: /* else */
	.word XT_DOLITERAL 
	.word 83 /* S */
	.word XT_EMIT
SHOWDOTTASKS_0006: /* then */
	.word XT_SPACE
	.word XT_DUP
	.word XT_DOLITERAL
	.word USER_LINK
	.word XT_PLUS
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_DUP
	.word XT_DUP
	.word XT_DOLITERAL
	.word USER_SP0
	.word XT_PLUS
	.word XT_SWAP
	.word XT_DOLITERAL
	.word USER_SP
	.word XT_PLUS
	.word XT_FETCH
	.word XT_MINUS
	.word XT_TWO
	.word XT_RSHIFT
	.word XT_DOLITERAL
	.word 3
	.word XT_UDOTR
	.word XT_SPACE
	.word XT_DUP
	.word XT_DUP
	.word XT_DOLITERAL
	.word USER_RP0
	.word XT_PLUS
	.word XT_SWAP
	.word XT_DOLITERAL
	.word USER_RP
	.word XT_PLUS
	.word XT_FETCH
	.word XT_MINUS
	.word XT_TWO
	.word XT_RSHIFT
	.word XT_DOLITERAL
	.word 3
	.word XT_UDOTR
	.word XT_SPACE
	.word XT_DUP
	.word XT_DUP
	.word XT_DOLITERAL
	.word USER_LP0
	.word XT_PLUS
	.word XT_SWAP
	.word XT_DOLITERAL
	.word USER_LP
	.word XT_PLUS
	.word XT_FETCH
	.word XT_MINUS
	.word XT_TWO
	.word XT_RSHIFT
	.word XT_DOLITERAL
	.word 3
	.word XT_UDOTR
	.word XT_SPACE
	.word XT_DOLITERAL
	.word USER_XT
	.word XT_PLUS
	.word XT_FETCH
	.word XT_XT2STRING
	.word XT_TYPE
	.word XT_CR
	.word XT_DOLOOP,SHOWDOTTASKS_0004 /* loop */
SHOWDOTTASKS_0003: /* (for ?do IF required) */
	.word XT_EXIT
END SHOWDOTTASKS
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
