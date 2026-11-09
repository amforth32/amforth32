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

:~ init-user \# ( -- )

    \ for TASK0 operator when this is executed sp and rp not
    \ correct but that is not important as they will written
    \ on first task switch. However, for task1...taskn-1 they
    \ ARE the initial values

    symbol RAM_TASK0 up!
    symbol USER_RP0 up@ + up@ symbol USER_RP + !
    symbol USER_SP0 up@ + up@ symbol USER_SP + !
    symbol USER_LP0 up@ + up@ symbol USER_LP + !

    \ taskn 1 ?do
    \     task-block 0 do
    \         i symbol USER_HANDLER cells < if
    \             up@ i + @ task-block j * + up@ i + task-block j * + !
    \         then
    \     cell +loop
    \ loop

    taskn 1- 0 ?do
        \ link task i+1 to task i
        i 1+ task@ i task@ symbol USER_LINK + !

        \ set task XT
        i 0= if ['] quit else ['] vacant then
        i task@ symbol USER_XT + !
        i 0= if
            \ set operator as active
            true i task@ symbol USER_STATUS + !
        else
            i task.warm
        then 
    loop
    
    \ close the task ring (exclude the ISR task)
    up@ taskn 2- task@ symbol USER_LINK + !
;

: task! \# ( xt n -- ) write task to slot n
    dup 1 taskn 1- within not if symbol ENTASK throw then
    task@ >r
    dup   r@ symbol USER_XT + !
    >body r> symbol USER_IP + !
;

: task.warm \# ( n -- ) reset task n
    dup 1 taskn 1- within not if symbol ENTASK throw then
    task@ >r

    r@ symbol USER_XT  + @ >body r@ symbol USER_IP + !
    r@ symbol USER_SP0 +       r@ symbol USER_SP + !
    r@ symbol USER_RP0 +       r@ symbol USER_RP + !
    r@ symbol USER_LP0 +       r@ symbol USER_LP + !

    0 r@ symbol USER_LOOP_INDEX + !
    0 r@ symbol USER_LOOP_LIMIT + !
    0 r@ symbol USER_STATUS     + !

    10 r@ symbol USER_BASE + !

    rdrop
;

: task.warm-all \# ( -- ) reset all tasks execept operator
    taskn 1- 1 ?do i task.warm loop
;

: +task \# ( n -- ) make task n active
    dup 1 taskn 1- within not if symbol ENTASK throw then
    task@ symbol USER_STATUS + true swap !
;

: -task \# ( n -- ) make task n inactive (sleep)
    dup 1 taskn 1- within not if symbol ENTASK throw then
    task@ symbol USER_STATUS + false swap !
;

: single \# ( -- ) disable task switching
    symbol XT_NOP is pause
;

: multi \# ( -- ) enable task switching
    ['] mtpause is pause
;

: show.task \# ( -- ) show tasks
    \ need single or multi
    symbol XT_PAUSE defer@ symbol XT_NOP = if
        s" single"
    else
        s" multi"
    then type cr
    s" # UP...... ? LINK.... NAME...." type cr
    taskn 1- 0 ?do
        i .
        i task@
        dup hex.
        dup symbol USER_STATUS + @ if
            [char] A emit else [char] S emit then space
        dup symbol USER_LINK   + @ hex.
            symbol USER_XT + @ xt>string type
        cr
    loop
; 

: show.ua ( n -- ) \ show user area task n
    \ drop
    s" OFF A....... [A]..... Desc........ OFF A....... [A]..... Desc........"
    type cr
    symbol userarea_size 4 / 0 do
        i cells 3 u.r space \ print cell offset
        dup task-block * up@ + ( n -- addr ) \ addr is taskN UA
        i cells + dup hex. @ hex. \ emit i-th UA field address and value
        i 4 * case
        symbol USER_LINK        of s" LINK........ " type endof
        symbol USER_STATUS      of s" STATUS...... " type endof
        symbol USER_XT          of s" XT.......... " type endof
        symbol USER_HANDLER     of s" HANDLER..... " type endof
        symbol USER_LOOP_INDEX  of s" LOOP_INDEX.. " type endof
        symbol USER_LOOP_LIMIT  of s" LOOP_LIMIT.. " type endof
        symbol USER_RP          of s" RP.......... " type endof
        symbol USER_SP          of s" SP.......... " type endof
        symbol USER_LP          of s" LP.......... " type endof
        symbol USER_IP          of s" IP.......... " type endof
        symbol USER_TOS         of s" TOS......... " type endof
        symbol USER_BASE        of s" BASE........ " type endof
        symbol USER_EMIT        of s" EMIT........ " type endof
        s" ............ " type
        endcase
        i 1+ 2 mod 0= if cr then
    loop
    drop
;
