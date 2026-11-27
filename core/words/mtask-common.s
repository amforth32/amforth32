# transpiling core/src/mtask.f on 2026/11/27 00:55:42

# \# # SPDX-License-Identifier: GPL-3.0-only


CONSTANT "taskn" , TASKN , TASKN
END TASKN

CONSTANT "task-block" , TASK_BLOCK, TASK_BLOCK_SIZE
END TASK_BLOCK


# 0 constant task.active
CONSTANT "task.active", TASKDOTACTIVE, 0x0
/*
   valid USER_STATUS values
*/
END TASKDOTACTIVE
#======================================================================
# 1 constant task.suspended
CONSTANT "task.suspended", TASKDOTSUSPENDED, 0x1
END TASKDOTSUSPENDED
#======================================================================
# 2 constant task.failed
CONSTANT "task.failed", TASKDOTFAILED, 0x2
END TASKDOTFAILED

#======================================================================
# : vacant \# ( -- ) a task that does nothing
COLON "vacant", VACANT /* ( -- ) a task that does nothing */
    # begin pause again ;
1:  .word XT_PAUSE, XT_DOBRANCH, 1b, XT_EXIT
END VACANT

#======================================================================
# : reserve \# ( a -- ) wait for resource to be available and claim
COLON "reserve", RESERVE /* ( a -- ) wait for resource to be available and claim */
    # begin pause dup @ until false swap ! ;
1:  .word XT_PAUSE, XT_DUP, XT_FETCH, XT_DOCONDBRANCH, 1b, XT_FALSE, XT_SWAP, XT_STORE, XT_EXIT
END RESERVE

#======================================================================
# : release \# ( a -- ) mark resource as not available
COLON "release", RELEASE /* ( a -- ) mark resource as not available */
    # true swap ! ;
    .word XT_TRUE, XT_SWAP, XT_STORE, XT_EXIT
END RELEASE

#======================================================================
# : task@ \# ( n -- a ) returns task block of task n
COLON "task@", TASKAT /* ( n -- a ) returns task block of task n */
    # task-block * symbol RAM_TASK0 + ;
    .word XT_TASK_BLOCK, XT_STAR, XT_DOLITERAL, RAM_TASK0, XT_PLUS, XT_EXIT
END TASKAT

#======================================================================
# : task.active? \# ( n -- f ) is task n active
COLON "task.active?", TASKDOTACTIVEQ /* ( n -- f ) is task n active */
    # task@ symbol USER_STATUS + @ task.active = ;
    .word XT_TASKAT, XT_DOLITERAL, USER_STATUS, XT_PLUS, XT_FETCH, XT_TASKDOTACTIVE, XT_EQUAL, XT_EXIT
END TASKDOTACTIVEQ

#======================================================================
# : task.suspended? \# ( n -- f ) is task n suspended
COLON "task.suspended?", TASKDOTSUSPENDEDQ /* ( n -- f ) is task n suspended */
    # task@ symbol USER_STATUS + @ task.suspended = ;
    .word XT_TASKAT, XT_DOLITERAL, USER_STATUS, XT_PLUS, XT_FETCH, XT_TASKDOTSUSPENDED, XT_EQUAL, XT_EXIT
END TASKDOTSUSPENDEDQ

#======================================================================
# : task.failed? \# ( n -- f ) is task n failed
COLON "task.failed?", TASKDOTFAILEDQ /* ( n -- f ) is task n failed */
    # task@ symbol USER_STATUS + @ task.failed = ;
    .word XT_TASKAT, XT_DOLITERAL, USER_STATUS, XT_PLUS, XT_FETCH, XT_TASKDOTFAILED, XT_EQUAL, XT_EXIT
END TASKDOTFAILEDQ

#======================================================================
# : task! \# ( xt n -- ) write task to slot n
COLON "task!", TASKBANG /* ( xt n -- ) write task to slot n */
    # dup 1 taskn within not if symbol ENTASK throw then
    .word XT_DUP, XT_ONE, XT_TASKN, XT_WITHIN, XT_NOT, XT_DOCONDBRANCH, 1f, XT_DOLITERAL, ENTASK, XT_THROW
1: 
    # dup task.active? if symbol ETACTV throw then
    .word XT_DUP, XT_TASKDOTACTIVEQ, XT_DOCONDBRANCH, 2f, XT_DOLITERAL, ETACTV, XT_THROW
2: 
    # swap over task@ symbol USER_XT + !
    .word XT_SWAP, XT_OVER, XT_TASKAT, XT_DOLITERAL, USER_XT, XT_PLUS, XT_STORE
    # task.warm ;
    .word XT_TASKDOTWARM, XT_EXIT
END TASKBANG

#======================================================================
# : operator? \# ( -- f ) is current task the operator task?
COLON "operator?", OPERATORQ /* ( -- f ) is current task the operator task? */
    # up@ symbol RAM_TASK0 = ;
    .word XT_UP_FETCH, XT_DOLITERAL, RAM_TASK0, XT_EQUAL, XT_EXIT
END OPERATORQ

#======================================================================
# :~ init-task \# ( n -- ) configure task block for task n
NONAME "init-task", INITMINUSTASK /* ( n -- ) configure task block for task n */
    # task@ >r
    .word XT_TASKAT, XT_TO_R
    # r@ symbol USER_XT  +  @ >body r@ symbol USER_IP + !
    .word XT_R_FETCH, XT_DOLITERAL, USER_XT, XT_PLUS, XT_FETCH, XT_TO_BODY, XT_R_FETCH, XT_DOLITERAL, USER_IP, XT_PLUS, XT_STORE
    # r@ symbol USER_SP0 +  r@ symbol USER_SP + !
    .word XT_R_FETCH, XT_DOLITERAL, USER_SP0, XT_PLUS, XT_R_FETCH, XT_DOLITERAL, USER_SP, XT_PLUS, XT_STORE
    # r@ symbol USER_RP0 +  r@ symbol USER_RP + !
    .word XT_R_FETCH, XT_DOLITERAL, USER_RP0, XT_PLUS, XT_R_FETCH, XT_DOLITERAL, USER_RP, XT_PLUS, XT_STORE
    # r@ symbol USER_LP0 +  r@ symbol USER_LP + !
    .word XT_R_FETCH, XT_DOLITERAL, USER_LP0, XT_PLUS, XT_R_FETCH, XT_DOLITERAL, USER_LP, XT_PLUS, XT_STORE
    # task.suspended            r@ symbol USER_STATUS + !
    .word XT_TASKDOTSUSPENDED, XT_R_FETCH, XT_DOLITERAL, USER_STATUS, XT_PLUS, XT_STORE
    # rdrop ;
    .word XT_RDROP, XT_EXIT
END INITMINUSTASK

#======================================================================
# : task.warm \# ( n -- ) reset task n
COLON "task.warm", TASKDOTWARM /* ( n -- ) reset task n */
    # dup 1 taskn within not if symbol ENTASK throw then
    .word XT_DUP, XT_ONE, XT_TASKN, XT_WITHIN, XT_NOT, XT_DOCONDBRANCH, 1f, XT_DOLITERAL, ENTASK, XT_THROW
1: 
# make sure the task is not resetting itself while running
# dup task.active? if symbol ETACTV throw then

    # \ configure the task
    # dup init-task
    .word XT_DUP, XT_INITMINUSTASK
    # \ reset task state
    # task@ >r
    .word XT_TASKAT, XT_TO_R
    # 0 r@ symbol USER_HANDLER + !
    .word XT_ZERO, XT_R_FETCH, XT_DOLITERAL, USER_HANDLER, XT_PLUS, XT_STORE
    # 0 r@ symbol USER_LOOP_INDEX + !
    .word XT_ZERO, XT_R_FETCH, XT_DOLITERAL, USER_LOOP_INDEX, XT_PLUS, XT_STORE
    # 0 r@ symbol USER_LOOP_LIMIT + !
    .word XT_ZERO, XT_R_FETCH, XT_DOLITERAL, USER_LOOP_LIMIT, XT_PLUS, XT_STORE
    # 10 r@ symbol USER_BASE + !
    .word XT_DOLITERAL, 0xA, XT_R_FETCH, XT_DOLITERAL, USER_BASE, XT_PLUS, XT_STORE
    # rdrop ;
    .word XT_RDROP, XT_EXIT
END TASKDOTWARM

#======================================================================
# : task.warm-all \# ( -- ) reset all suspended tasks
COLON "task.warm-all", TASKDOTWARMMINUSALL /* ( -- ) reset all suspended tasks */
    # taskn 1- 1 ?do i task.suspended? if task.warm then loop ;
    .word XT_TASKN, XT_1MINUS, XT_ONE, XT_QDOCHECK, XT_DOCONDBRANCH, 1f, XT_DODO
2:  .word XT_I, XT_TASKDOTSUSPENDEDQ, XT_DOCONDBRANCH, 3f, XT_TASKDOTWARM
3:  .word XT_DOLOOP, 2b
1:  .word XT_EXIT
END TASKDOTWARMMINUSALL

#======================================================================
# :~ init-user \# ( -- )
NONAME "init-user", INITMINUSUSER /* ( -- )  */

    # \ set the UP register to TASK0
    # symbol RAM_TASK0 up!
    .word XT_DOLITERAL, RAM_TASK0, XT_UP_STORE

    # taskn 0 ?do
    .word XT_TASKN, XT_ZERO, XT_QDOCHECK, XT_DOCONDBRANCH, 1f, XT_DODO
2: 
        # \ link task i+1 to task i
        # i 1+ task@ i task@ symbol USER_LINK + !
        .word XT_I, XT_1PLUS, XT_TASKAT, XT_I, XT_TASKAT, XT_DOLITERAL, USER_LINK, XT_PLUS, XT_STORE

        # \ set task XT
        # i 0= if ['] quit else ['] vacant then
        .word XT_I, XT_ZEROEQUAL, XT_DOCONDBRANCH, 3f, XT_DOXLITERAL, XT_QUIT, XT_DOBRANCH, 4f
3:      .word XT_DOXLITERAL, XT_VACANT
4: 
        # i task@ symbol USER_XT + !
        .word XT_I, XT_TASKAT, XT_DOLITERAL, USER_XT, XT_PLUS, XT_STORE
        # i 0= if
        .word XT_I, XT_ZEROEQUAL, XT_DOCONDBRANCH, 5f
            # \ cannot use task.warm on TASK0 because it is already running
            # \ just make sure the task is configured properly
            # i init-task
            .word XT_I, XT_INITMINUSTASK
            # \ set operator as active
            # task.active i task@ symbol USER_STATUS + !
            .word XT_TASKDOTACTIVE, XT_I, XT_TASKAT, XT_DOLITERAL, USER_STATUS, XT_PLUS, XT_STORE
        # else
        .word XT_DOBRANCH, 6f
5: 
            # i task.warm
            .word XT_I, XT_TASKDOTWARM
        # then
6:  # loop
    .word XT_DOLOOP, 2b
1: 
    # \ close the task ring
    # up@ taskn 1- task@ symbol USER_LINK + ! ;
    .word XT_UP_FETCH, XT_TASKN, XT_1MINUS, XT_TASKAT, XT_DOLITERAL, USER_LINK, XT_PLUS, XT_STORE, XT_EXIT
END INITMINUSUSER

#======================================================================
# : +task \# ( n -- ) make task n active
COLON "+task", PLUSTASK /* ( n -- ) make task n active */
    # dup 1 taskn within not if symbol ENTASK throw then
    .word XT_DUP, XT_ONE, XT_TASKN, XT_WITHIN, XT_NOT, XT_DOCONDBRANCH, 1f, XT_DOLITERAL, ENTASK, XT_THROW
1: 
    # dup task.failed? if symbol ETFAIL throw then
    .word XT_DUP, XT_TASKDOTFAILEDQ, XT_DOCONDBRANCH, 2f, XT_DOLITERAL, ETFAIL, XT_THROW
2: 
    # task@ symbol USER_STATUS + task.active swap ! ;
    .word XT_TASKAT, XT_DOLITERAL, USER_STATUS, XT_PLUS, XT_TASKDOTACTIVE, XT_SWAP, XT_STORE, XT_EXIT
END PLUSTASK

#======================================================================
# : -task \# ( n -- ) make task n inactive (sleep)
COLON "-task", MINUSTASK /* ( n -- ) make task n inactive (sleep)  */
    # dup 1 taskn within not if symbol ENTASK throw then
    .word XT_DUP, XT_ONE, XT_TASKN, XT_WITHIN, XT_NOT, XT_DOCONDBRANCH, 1f, XT_DOLITERAL, ENTASK, XT_THROW
1: 
    # dup task.failed? if symbol ETFAIL throw then
    .word XT_DUP, XT_TASKDOTFAILEDQ, XT_DOCONDBRANCH, 2f, XT_DOLITERAL, ETFAIL, XT_THROW
2: 
    # task@ symbol USER_STATUS + task.suspended swap ! ;
    .word XT_TASKAT, XT_DOLITERAL, USER_STATUS, XT_PLUS, XT_TASKDOTSUSPENDED, XT_SWAP, XT_STORE, XT_EXIT
END MINUSTASK

#======================================================================
# : single \# ( -- ) disable task switching
COLON "single", SINGLE /* ( -- ) disable task switching */
    # symbol XT_NOP is pause ;
    .word XT_DOLITERAL, XT_NOP, XT_DOXLITERAL, XT_PAUSE, XT_DEFER_STORE, XT_EXIT
END SINGLE

#======================================================================
# : multi \# ( -- ) enable task switching
COLON "multi", MULTI /* ( -- ) enable task switching */
    # symbol XT_MTPAUSE is pause ;
    .word XT_DOLITERAL, XT_MTPAUSE, XT_DOXLITERAL, XT_PAUSE, XT_DEFER_STORE, XT_EXIT
END MULTI

#======================================================================
# : task.ds \# ( n -- ) show datastack of task n (when dormant)
COLON "task.ds", TASKDOTDS /* ( n -- ) show datastack of task n (when dormant)  */
    # dup 0 taskn within not if symbol ENTASK throw then
    .word XT_DUP, XT_ZERO, XT_TASKN, XT_WITHIN, XT_NOT, XT_DOCONDBRANCH, 1f, XT_DOLITERAL, ENTASK, XT_THROW
1: 
    # dup task.active? if symbol ETACTV throw then
    .word XT_DUP, XT_TASKDOTACTIVEQ, XT_DOCONDBRANCH, 2f, XT_DOLITERAL, ETACTV, XT_THROW
2: 
    # task@ dup symbol USER_SP0 + swap symbol USER_SP + @     \# ( sp0 sp )
    .word XT_TASKAT, XT_DUP, XT_DOLITERAL, USER_SP0, XT_PLUS, XT_SWAP, XT_DOLITERAL, USER_SP, XT_PLUS, XT_FETCH
    # over over - 2 rshift s" DS(" type dec. s" ): " type
    .word XT_OVER, XT_OVER, XT_MINUS, XT_TWO, XT_RSHIFT
    STRING "DS("
    .word XT_TYPE, XT_DECDOT
    STRING "): "
    .word XT_TYPE
    # ?do i @ . cell +loop
    .word XT_QDOCHECK, XT_DOCONDBRANCH, 3f, XT_DODO
4:  .word XT_I, XT_FETCH, XT_DOT, XT_CELL, XT_DOPLUSLOOP, 4b
3: 
    # cr ;
    .word XT_CR, XT_EXIT
END TASKDOTDS

#======================================================================
# : task.rs \# ( n -- ) show return stack of task n (when dormant)
COLON "task.rs", TASKDOTRS /* ( n -- ) show return stack of task n (when dormant)  */
    # dup 0 taskn within not if symbol ENTASK throw then
    .word XT_DUP, XT_ZERO, XT_TASKN, XT_WITHIN, XT_NOT, XT_DOCONDBRANCH, 1f, XT_DOLITERAL, ENTASK, XT_THROW
1: 
    # dup task.active? if symbol ETACTV throw then
    .word XT_DUP, XT_TASKDOTACTIVEQ, XT_DOCONDBRANCH, 2f, XT_DOLITERAL, ETACTV, XT_THROW
2: 
    # task@ dup symbol USER_RP0 + swap symbol USER_RP + @     \# ( sp0 sp )
    .word XT_TASKAT, XT_DUP, XT_DOLITERAL, USER_RP0, XT_PLUS, XT_SWAP, XT_DOLITERAL, USER_RP, XT_PLUS, XT_FETCH
    # over over - 2 rshift s" RS(" type dec. s" ): " type
    .word XT_OVER, XT_OVER, XT_MINUS, XT_TWO, XT_RSHIFT
    STRING "RS("
    .word XT_TYPE, XT_DECDOT
    STRING "): "
    .word XT_TYPE
    # ?do i @ . cell +loop
    .word XT_QDOCHECK, XT_DOCONDBRANCH, 3f, XT_DODO
4:  .word XT_I, XT_FETCH, XT_DOT, XT_CELL, XT_DOPLUSLOOP, 4b
3: 
    # cr ;
    .word XT_CR, XT_EXIT
END TASKDOTRS

#======================================================================
# : task.bt \# ( n -- ) show backtrace of task n (when dormant)
COLON "task.bt", TASKDOTBT /* ( n -- ) show backtrace of task n (when dormant)  */
    # dup 0 taskn within not if symbol ENTASK throw then
    .word XT_DUP, XT_ZERO, XT_TASKN, XT_WITHIN, XT_NOT, XT_DOCONDBRANCH, 1f, XT_DOLITERAL, ENTASK, XT_THROW
1: 
    # dup task.active? if symbol ETACTV throw then
    .word XT_DUP, XT_TASKDOTACTIVEQ, XT_DOCONDBRANCH, 2f, XT_DOLITERAL, ETACTV, XT_THROW
2: 
    # s" BT: " type
    STRING "BT: "
    .word XT_TYPE
    # task@ dup symbol USER_RP0 + swap dup symbol USER_RP + @ swap   \# ( sp0 sp up )
    .word XT_TASKAT, XT_DUP, XT_DOLITERAL, USER_RP0, XT_PLUS, XT_SWAP, XT_DUP, XT_DOLITERAL, USER_RP, XT_PLUS, XT_FETCH, XT_SWAP
    # symbol USER_IP + @ \# ( sp0 sp ip )
    .word XT_DOLITERAL, USER_IP, XT_PLUS, XT_FETCH
    # ?dup if
    .word XT_QDUP, XT_DOCONDBRANCH, 3f
        # \ ip points to next word to be executed
        # dup cell- @ \# (sp0 sp ip wd)
        .word XT_DUP, XT_CELLMINUS, XT_FETCH
        # xt>string type space \# emit wd
        .word XT_XT2STRING, XT_TYPE, XT_SPACE
        # .ip then \# emit ip
        .word XT_DOTIP
3: 
    # ?do i @ .ip cell +loop
    .word XT_QDOCHECK, XT_DOCONDBRANCH, 4f, XT_DODO
5:  .word XT_I, XT_FETCH, XT_DOTIP, XT_CELL, XT_DOPLUSLOOP, 5b
4: 
    # cr ;
    .word XT_CR, XT_EXIT
END TASKDOTBT

#======================================================================
# : task.ua \# ( n -- ) show user area of task n
COLON "task.ua", TASKDOTUA /* ( n -- ) show user area of task n */
    # \ drop
    # s" OFF A....... [A]..... Desc............ OFF A....... [A]..... Desc............"
    STRING "OFF A....... [A]..... Desc............ OFF A....... [A]..... Desc............"
    # type cr
    .word XT_TYPE, XT_CR
    # symbol userarea_size 4 / 0 do
    .word XT_DOLITERAL, userarea_size, XT_FOUR, XT_SLASH, XT_ZERO, XT_DODO
1: 
        # i cells 3 u.r space \ print cell offset
        .word XT_I, XT_CELLS, XT_DOLITERAL, 0x3, XT_UDOTR, XT_SPACE
        # dup task-block * symbol RAM_TASK0 + ( n -- addr ) \ addr is taskN UA
        .word XT_DUP, XT_TASK_BLOCK, XT_STAR, XT_DOLITERAL, RAM_TASK0, XT_PLUS
        # i cells + dup hex. @ hex. \ emit i-th UA field address and value
        .word XT_I, XT_CELLS, XT_PLUS, XT_DUP, XT_HEXDOT, XT_FETCH, XT_HEXDOT
        # i 4 * case
        .word XT_I, XT_FOUR, XT_STAR
        # symbol USER_LINK        of s" LINK............ " type endof
        .word XT_DOLITERAL, USER_LINK, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 2f, XT_DROP
        STRING "LINK............ "
        .word XT_TYPE, XT_DOBRANCH, 3f
2: 
        # symbol USER_STATUS      of s" STATUS.......... " type endof
        .word XT_DOLITERAL, USER_STATUS, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 4f, XT_DROP
        STRING "STATUS.......... "
        .word XT_TYPE, XT_DOBRANCH, 5f
4: 
        # symbol USER_XT          of s" XT.............. " type endof
        .word XT_DOLITERAL, USER_XT, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 6f, XT_DROP
        STRING "XT.............. "
        .word XT_TYPE, XT_DOBRANCH, 7f
6: 
        # symbol USER_HANDLER     of s" HANDLER......... " type endof
        .word XT_DOLITERAL, USER_HANDLER, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 8f, XT_DROP
        STRING "HANDLER......... "
        .word XT_TYPE, XT_DOBRANCH, 9f
8: 
        # symbol USER_LOOP_INDEX  of s" LOOP_INDEX...... " type endof
        .word XT_DOLITERAL, USER_LOOP_INDEX, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 10f, XT_DROP
        STRING "LOOP_INDEX...... "
        .word XT_TYPE, XT_DOBRANCH, 11f
10: 
        # symbol USER_LOOP_LIMIT  of s" LOOP_LIMIT...... " type endof
        .word XT_DOLITERAL, USER_LOOP_LIMIT, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 12f, XT_DROP
        STRING "LOOP_LIMIT...... "
        .word XT_TYPE, XT_DOBRANCH, 13f
12: 
        # symbol USER_RP          of s" RP.............. " type endof
        .word XT_DOLITERAL, USER_RP, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 14f, XT_DROP
        STRING "RP.............. "
        .word XT_TYPE, XT_DOBRANCH, 15f
14: 
        # symbol USER_SP          of s" SP.............. " type endof
        .word XT_DOLITERAL, USER_SP, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 16f, XT_DROP
        STRING "SP.............. "
        .word XT_TYPE, XT_DOBRANCH, 17f
16: 
        # symbol USER_LP          of s" LP.............. " type endof
        .word XT_DOLITERAL, USER_LP, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 18f, XT_DROP
        STRING "LP.............. "
        .word XT_TYPE, XT_DOBRANCH, 19f
18: 
        # symbol USER_IP          of s" IP.............. " type endof
        .word XT_DOLITERAL, USER_IP, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 20f, XT_DROP
        STRING "IP.............. "
        .word XT_TYPE, XT_DOBRANCH, 21f
20: 
        # symbol USER_TOS         of s" TOS............. " type endof
        .word XT_DOLITERAL, USER_TOS, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 22f, XT_DROP
        STRING "TOS............. "
        .word XT_TYPE, XT_DOBRANCH, 23f
22: 
        # symbol USER_BASE        of s" BASE............ " type endof
        .word XT_DOLITERAL, USER_BASE, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 24f, XT_DROP
        STRING "BASE............ "
        .word XT_TYPE, XT_DOBRANCH, 25f
24: 
        # symbol USER_EMIT        of s" EMIT............ " type endof
        .word XT_DOLITERAL, USER_EMIT, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 26f, XT_DROP
        STRING "EMIT............ "
        .word XT_TYPE, XT_DOBRANCH, 27f
26: 
.if WANT_DEBUGGER == 1 
        # symbol USER_DEBUG_BREAK of s" USER_DEBUG_BREAK " type endof
        .word XT_DOLITERAL, USER_DEBUG_BREAK, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 28f, XT_DROP
        STRING "USER_DEBUG_BREAK "
        .word XT_TYPE, XT_DOBRANCH, 29f
28: 
        # symbol USER_DEBUG_NEXT  of s" USER_DEBUG_NEXT. " type endof
        .word XT_DOLITERAL, USER_DEBUG_NEXT, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 30f, XT_DROP
        STRING "USER_DEBUG_NEXT. "
        .word XT_TYPE, XT_DOBRANCH, 31f
30: 
.endif 
        # s" ................ " type
        STRING "................ "
        .word XT_TYPE
        # endcase
        .word XT_DROP
31: 
29: 
27: 
25: 
23: 
21: 
19: 
17: 
15: 
13: 
11: 
9: 
7: 
5: 
3: 
        # i 1+ 2 mod 0= if cr then
        .word XT_I, XT_1PLUS, XT_TWO, XT_MOD, XT_ZEROEQUAL, XT_DOCONDBRANCH, 32f, XT_CR
32: 
    # loop
    .word XT_DOLOOP, 1b
    # drop ;
    .word XT_DROP, XT_EXIT
END TASKDOTUA

#======================================================================
# : show.tasks \# ( -- ) show all tasks
COLON "show.tasks", SHOWDOTTASKS /* ( -- ) show all tasks */
    # \ need single or multi
    # symbol XT_PAUSE defer@ symbol XT_NOP = if
    .word XT_DOLITERAL, XT_PAUSE, XT_DEFER_FETCH, XT_DOLITERAL, XT_NOP, XT_EQUAL, XT_DOCONDBRANCH, 1f
        # s" single"
        STRING "single"
    # else
    .word XT_DOBRANCH, 2f
1: 
        # s" multi"
        STRING "multi"
    # then type cr
2:  .word XT_TYPE, XT_CR
    # s" # UP...... ? LINK.... .DS .RS .LS NAME...." type cr
    STRING "# UP...... ? LINK.... .DS .RS .LS NAME...."
    .word XT_TYPE, XT_CR
    # taskn 0 ?do
    .word XT_TASKN, XT_ZERO, XT_QDOCHECK, XT_DOCONDBRANCH, 3f, XT_DODO
4: 
        # i .
        .word XT_I, XT_DOT
        # i task@
        .word XT_I, XT_TASKAT
        # dup hex.
        .word XT_DUP, XT_HEXDOT
        # dup symbol USER_STATUS + @
        .word XT_DUP, XT_DOLITERAL, USER_STATUS, XT_PLUS, XT_FETCH
        # case
        # task.active of [char] A emit endof
        .word XT_TASKDOTACTIVE, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 5f, XT_DROP, XT_DOLITERAL, 0x41, XT_EMIT, XT_DOBRANCH, 6f
5: 
        # task.suspended  of [char] S emit endof
        .word XT_TASKDOTSUSPENDED, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 7f, XT_DROP, XT_DOLITERAL, 0x53, XT_EMIT, XT_DOBRANCH, 8f
7: 
        # task.failed  of [char] F emit endof
        .word XT_TASKDOTFAILED, XT_OVER, XT_EQUAL, XT_DOCONDBRANCH, 9f, XT_DROP, XT_DOLITERAL, 0x46, XT_EMIT, XT_DOBRANCH, 10f
9: 
        # [char] ? emit
        .word XT_DOLITERAL, 0x3F, XT_EMIT
        # endcase
        .word XT_DROP
10: 
8: 
6: 
        # space
        .word XT_SPACE
        # dup symbol USER_LINK   + @ hex.
        .word XT_DUP, XT_DOLITERAL, USER_LINK, XT_PLUS, XT_FETCH, XT_HEXDOT
        # dup dup symbol USER_SP0 + swap symbol USER_SP + @ - 2 rshift 3 u.r space
        .word XT_DUP, XT_DUP, XT_DOLITERAL, USER_SP0, XT_PLUS, XT_SWAP, XT_DOLITERAL, USER_SP, XT_PLUS, XT_FETCH, XT_MINUS, XT_TWO, XT_RSHIFT, XT_DOLITERAL, 0x3, XT_UDOTR, XT_SPACE
        # dup dup symbol USER_RP0 + swap symbol USER_RP + @ - 2 rshift 3 u.r space
        .word XT_DUP, XT_DUP, XT_DOLITERAL, USER_RP0, XT_PLUS, XT_SWAP, XT_DOLITERAL, USER_RP, XT_PLUS, XT_FETCH, XT_MINUS, XT_TWO, XT_RSHIFT, XT_DOLITERAL, 0x3, XT_UDOTR, XT_SPACE
        # dup dup symbol USER_LP0 + swap symbol USER_LP + @ - 2 rshift 3 u.r space
        .word XT_DUP, XT_DUP, XT_DOLITERAL, USER_LP0, XT_PLUS, XT_SWAP, XT_DOLITERAL, USER_LP, XT_PLUS, XT_FETCH, XT_MINUS, XT_TWO, XT_RSHIFT, XT_DOLITERAL, 0x3, XT_UDOTR, XT_SPACE
        # symbol USER_XT + @ xt>string type
        .word XT_DOLITERAL, USER_XT, XT_PLUS, XT_FETCH, XT_XT2STRING, XT_TYPE
        # cr
        .word XT_CR
    # loop ;
    .word XT_DOLOOP, 4b
3:  .word XT_EXIT
END SHOWDOTTASKS

#======================================================================
# :~ trace.bt \# ( -- ) show saved backtrace of current task
NONAME "trace.bt", TRACEDOTBT /* ( -- ) show saved backtrace of current task */
/*
   Uses saved RSP and IP from UA to interpret contents of the trace_stack
   that was previously saved with task.save.trace.
*/
    # s" BT: " type
    STRING "BT: "
    .word XT_TYPE
    # symbol RAM_upper_trace_stack dup \# (sp0 sp0)
    .word XT_DOLITERAL, RAM_upper_trace_stack, XT_DUP
    # up@ symbol USER_RP0 + rp @ - \# (sp0 sp0 rdepth)
    .word XT_UP_FETCH, XT_DOLITERAL, USER_RP0, XT_PLUS, XT_RP, XT_FETCH, XT_MINUS
    # - \# (sp0 sp)
    .word XT_MINUS
    # up@ symbol USER_IP + @ \# ( sp0 sp ip )
    .word XT_UP_FETCH, XT_DOLITERAL, USER_IP, XT_PLUS, XT_FETCH
    # ?dup if
    .word XT_QDUP, XT_DOCONDBRANCH, 1f
        # .ip then \# emit ip
        .word XT_DOTIP
1: 
    # ?do i @ .ip cell +loop ;
    .word XT_QDOCHECK, XT_DOCONDBRANCH, 2f, XT_DODO
3:  .word XT_I, XT_FETCH, XT_DOTIP, XT_CELL, XT_DOPLUSLOOP, 3b
2:  .word XT_EXIT
END TRACEDOTBT
