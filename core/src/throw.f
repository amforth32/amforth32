\ # SPDX-License-Identifier: GPL-3.0-only

:~ suspend
    task.failed up@ symbol USER_STATUS + ! ;

\ THROW restores the stack state to what it was when catch started executing.
\ The DS will have the same depth but the contents will have been modified
\ by the XT executed by CATCH. THROW pushes n on top of the restored DS.
: throw \# ( k*x n -- k*x | i*x n ) if n !=0 jump to just after corresponding CATCH
    ?dup if             ( n )   \ 0 THROW is no-op
{ .if WANT_THROWTXT == YES }   
        symbol XT_TASK_SAVE execute     \ save task state to UA        
{ .endif }
        handler @ ?dup if   \ handled throw
            rp!             ( n )   \ restore RSP to return to
            r> handler !    ( n )   \ restore previous HANDLER
            r> swap >r      ( dsp ) \ swap previous DSP with n
            sp!             ( xt )  \ DS restored, now the executed xp is on top
            drop            ( )     \ drop the xp
            r>              ( n )   \ restore the exception number
            \ Return to the caller of CATCH because RS is restored
            \ to the state that existed when CATCH began execution
        else    \ unhandled throw
            \ if not the operator suspend yourself
            operator? not if suspend pause then
        then
    then ;
