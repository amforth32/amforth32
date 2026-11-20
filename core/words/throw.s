# SPDX-License-Identifier: GPL-3.0-only
COLON "throw", THROW /* ( k * x n -- k * x | i * x n ) if n !=0 jump to just after corresponding CATCH */
/*
    THROW restores the stack state to what it was when catch started executing.
    The DS will have the same depth but the contents will have been modified
    by the XT executed by CATCH. THROW pushes n on top of the restored DS.

: could-fail ( -- char )
   KEY DUP [CHAR] Q = IF 1 THROW THEN ;
: do-it ( a b -- c) 2DROP could-fail ;

: try-it ( --)
   1 2 ['] do-it CATCH IF
   ( x1 x2 ) 2DROP ." There was an exception" CR
   ELSE ." The character was " EMIT CR
   THEN
;

; retry-it ( -- )
   BEGIN 1 2 ['] do-it CATCH WHILE
   ( x1 x2) 2DROP ." Exception, keep trying" CR
   REPEAT ( char )
   ." The character was " EMIT CR
;


*/
    # 0 THROW is no-op
    .word XT_QDUP
    .word XT_DOCONDBRANCH,PFA_THROW1
.if WANT_THROWTXT==YES
      # type the error message    
      .word XT_DUP
      .word XT_ERRQ
      .word XT_TYPE
.endif      
      # restore RSP to return to
      .word XT_HANDLER
      .word XT_FETCH
      .word XT_RP_STORE
      # restore previous HANDLER
      .word XT_R_FROM
      .word XT_HANDLER
      .word XT_STORE
      # swap previous DSP for the exception number
      .word XT_R_FROM
      .word XT_SWAP
      .word XT_TO_R
      # restore previous DSP
      .word XT_SP_STORE
      # drop the executed XP (it was on the stack when DSP was saved)
      .word XT_DROP
      # restore the exception number
      .word XT_R_FROM
      # RS is now restored to the state that existed when CATCH execution started,
      # so EXIT will return to the next word after CATCH    
PFA_THROW1:
    .word XT_EXIT
END THROW


