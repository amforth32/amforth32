\ # SPDX-License-Identifier: GPL-3.0-only

\ QUIT initializes stack pointers by reading them from the user area and enters the traditional ACCEPT-INTERPRET loop that never ends.
\ It provides the topmost exception catcher as well. Depending on the exception thrown, it prints an error message and restarts itself.
: quit \# ( -- ) top level frame of the VM, endless loop
    symbol XT_LBRACKET execute
    begin
        state @ 0= if .ready then
        refill
        .input if
            ['] interpret catch
            { .if WANT_THROWTXT == YES }
            \ It is important that no colon words run between CATCH and TASK_SAVE_TRACE
            task.save.trace     \ save the return stack to trace_stack.
            { .endif }                
            ?dup if
                dup -2 < if
                    .error
                then
                \ start over; don't want to recurse just jump back to the beginning
                { .word XT_DOBRANCH, PFA_QUIT }
            then
        then
        .ok
    again ;
