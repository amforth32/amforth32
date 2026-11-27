# transpiling core/src/throw.f on 2026/11/27 00:55:46

# SPDX-License-Identifier: GPL-3.0-only

# :~ suspend
NONAME "suspend", SUSPEND
    # task.failed up@ symbol USER_STATUS + ! ;
    .word XT_TASKDOTFAILED, XT_UP_FETCH, XT_DOLITERAL, USER_STATUS, XT_PLUS, XT_STORE, XT_EXIT
END SUSPEND

#======================================================================
# : throw \# ( k*x n -- k*x | i*x n ) if n !=0 jump to just after corresponding CATCH
COLON "throw", THROW /* ( k*x n -- k*x | i*x n ) if n !=0 jump to just after corresponding CATCH */
/*
   THROW restores the stack state to what it was when catch started executing.
   The DS will have the same depth but the contents will have been modified
   by the XT executed by CATCH. THROW pushes n on top of the restored DS.
*/
    # ?dup if             ( n )   \ 0 THROW is no-op
    .word XT_QDUP, XT_DOCONDBRANCH, 1f
.if WANT_THROWTXT == YES 
        # symbol XT_TASK_SAVE execute     \ save task state to UA
        .word XT_TASK_SAVE
.endif 
        # handler @ ?dup if   \ handled throw
        .word XT_HANDLER, XT_FETCH, XT_QDUP, XT_DOCONDBRANCH, 2f
            # rp!             ( n )   \ restore RSP to return to
            .word XT_RP_STORE
            # r> handler !    ( n )   \ restore previous HANDLER
            .word XT_R_FROM, XT_HANDLER, XT_STORE
            # r> swap >r      ( dsp ) \ swap previous DSP with n
            .word XT_R_FROM, XT_SWAP, XT_TO_R
            # sp!             ( xt )  \ DS restored, now the executed xp is on top
            .word XT_SP_STORE
            # drop            ( )     \ drop the xp
            .word XT_DROP
            # r>              ( n )   \ restore the exception number
            .word XT_R_FROM
        # \ Return to the caller of CATCH because RS is restored
        # \ to the state that existed when CATCH began execution
        # else    \ unhandled throw
        .word XT_DOBRANCH, 3f
2: 
            # \ if not the operator suspend yourself
            # operator? not if suspend pause then
            .word XT_OPERATORQ, XT_NOT, XT_DOCONDBRANCH, 4f, XT_SUSPEND, XT_PAUSE
4: 
        # then
3:  # then ;
1:  .word XT_EXIT
END THROW
