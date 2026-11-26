\# # SPDX-License-Identifier: GPL-3.0-only

{
    CONSTANT "taskn" , TASKN , TASKN
    END TASKN

    CONSTANT "task-block" , TASK_BLOCK, TASK_BLOCK_SIZE
    END TASK_BLOCK
}

: vacant \# ( -- ) a task that does nothing
    begin pause again
;

: reserve \# ( a -- ) wait for resource to be available and claim
    begin pause dup @ until false swap !
;

: release \# ( a -- ) mark resource as not available
    true swap !
;

: task@ \# ( n -- a ) returns task block of task n
    task-block * symbol RAM_TASK0 +
;


:~ init-task \# ( n -- ) configure task block for task n
    task@ >r
    r@ symbol USER_XT  +  @ >body r@ symbol USER_IP + !
    r@ symbol USER_SP0 +  r@ symbol USER_SP + !
    r@ symbol USER_RP0 +  r@ symbol USER_RP + !
    r@ symbol USER_LP0 +  r@ symbol USER_LP + !
    0                     r@ symbol USER_STATUS + !
    rdrop
;

:~ init-user \# ( -- )

    \ set the UP register to TASK0
    symbol RAM_TASK0 up!

    taskn 0 ?do
        \ link task i+1 to task i
        i 1+ task@ i task@ symbol USER_LINK + !

        \ set task XT
        i 0= if ['] quit else ['] vacant then
        i task@ symbol USER_XT + !
        i 0= if
            \ cannot use task.warm on TASK0 because it is already running
            \ just make sure the task is configured properly
            i init-task
            \ set operator as active
            true i task@ symbol USER_STATUS + !
        else
            i task.warm
        then 
    loop
    
    \ close the task ring
    up@ taskn 1- task@ symbol USER_LINK + !
;

: task! \# ( xt n -- ) write task to slot n
    dup 1 taskn within not if symbol ENTASK throw then
    task@ >r
    dup   r@ symbol USER_XT + !
    >body r> symbol USER_IP + !
;

: task.warm \# ( n -- ) reset task n
    dup 1 taskn within not if symbol ENTASK throw then
    \ make sure the task is not resetting itself while running
    dup task@ up@ = if symbol ENTASK throw then

    \ configure the task
    dup init-task
    \ reset task state
    task@ >r 
    0 r@ symbol USER_LOOP_INDEX + !
    0 r@ symbol USER_LOOP_LIMIT + !
    10 r@ symbol USER_BASE + !
    rdrop
;

: task.warm-all \# ( -- ) reset all tasks except operator
    taskn 1- 1 ?do i task.warm loop
;

: +task \# ( n -- ) make task n active
    dup 1 taskn within not if symbol ENTASK throw then
    task@ symbol USER_STATUS + true swap !
;

: -task \# ( n -- ) make task n inactive (sleep)
    dup 1 taskn within not if symbol ENTASK throw then
    task@ symbol USER_STATUS + false swap !
;

: single \# ( -- ) disable task switching
    symbol XT_NOP is pause
;

: multi \# ( -- ) enable task switching
    symbol XT_MTPAUSE is pause
;

: task.ds \# ( n -- ) show datastack of task n (when dormant)
    dup 0 taskn within not if symbol ENTASK throw then
    task@ dup up@ = if drop s" EXECUTING" type cr exit then
    dup symbol USER_SP0 + swap symbol USER_SP + @     \# ( sp0 sp ) 
    over over - 2 rshift s" DS(" type dec. s" ): " type
    ?do i @ . cell +loop
    cr
;

: task.rs \# ( n -- ) show datastack of task n (when dormant)
    dup 0 taskn within not if symbol ENTASK throw then
    task@ dup up@ = if drop s" EXECUTING" type cr exit then
    dup symbol USER_RP0 + swap symbol USER_RP + @     \# ( sp0 sp ) 
    over over - 2 rshift s" RS(" type dec. s" ): " type
    ?do i @ . cell +loop
    cr
;

: task.bt \# ( n -- ) show datastack of task n (when dormant)
    dup 0 taskn within not if symbol ENTASK throw then
    task@ dup up@ = if drop s" EXECUTING" type cr exit then
    s" BT: " type
    dup symbol USER_RP0 + swap dup symbol USER_RP + @ swap   \# ( sp0 sp up )
    symbol USER_IP + @ \# ( sp0 sp ip )
    ?dup if
        \ ip points to next word to be executed
        dup cell- @ \# (sp0 sp ip wd) 
        xt>string type space \# emit wd
        .ip then \# emit ip
    ?do i @ .ip cell +loop
    cr
;

: task.ua \# ( n -- ) show user area of task n
    \ drop
    s" OFF A....... [A]..... Desc............ OFF A....... [A]..... Desc............"
    type cr
    symbol userarea_size 4 / 0 do
        i cells 3 u.r space \ print cell offset
        dup task-block * symbol RAM_TASK0 + ( n -- addr ) \ addr is taskN UA
        i cells + dup hex. @ hex. \ emit i-th UA field address and value
        i 4 * case
        symbol USER_LINK        of s" LINK............ " type endof
        symbol USER_STATUS      of s" STATUS.......... " type endof
        symbol USER_XT          of s" XT.............. " type endof
        symbol USER_HANDLER     of s" HANDLER......... " type endof
        symbol USER_LOOP_INDEX  of s" LOOP_INDEX...... " type endof
        symbol USER_LOOP_LIMIT  of s" LOOP_LIMIT...... " type endof
        symbol USER_RP          of s" RP.............. " type endof
        symbol USER_SP          of s" SP.............. " type endof
        symbol USER_LP          of s" LP.............. " type endof
        symbol USER_IP          of s" IP.............. " type endof
        symbol USER_TOS         of s" TOS............. " type endof
        symbol USER_BASE        of s" BASE............ " type endof
        symbol USER_EMIT        of s" EMIT............ " type endof
{ .if WANT_DEBUGGER == 1 }
        symbol USER_DEBUG_BREAK of s" USER_DEBUG_BREAK " type endof
        symbol USER_DEBUG_NEXT  of s" USER_DEBUG_NEXT. " type endof
{ .endif }
        s" ................ " type
        endcase
        i 1+ 2 mod 0= if cr then
    loop
    drop
;

: show.tasks \# ( -- ) show all tasks
    \ need single or multi
    symbol XT_PAUSE defer@ symbol XT_NOP = if
        s" single"
    else
        s" multi"
    then type cr
    s" # UP...... ? LINK.... .DS .RS .LS NAME...." type cr
    taskn 0 ?do
        i .
        i task@
        dup hex.
        dup symbol USER_STATUS + @ if
            [char] A emit else [char] S emit then space
        dup symbol USER_LINK   + @ hex.
        dup dup symbol USER_SP0 + swap symbol USER_SP + @ - 2 rshift 3 u.r space
        dup dup symbol USER_RP0 + swap symbol USER_RP + @ - 2 rshift 3 u.r space
        dup dup symbol USER_LP0 + swap symbol USER_LP + @ - 2 rshift 3 u.r space
        symbol USER_XT + @ xt>string type
        cr
    loop
; 