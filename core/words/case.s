# SPDX-License-Identifier: GPL-3.0-only

IMMED "case" , CASE /* ( x -- x ) test value x for case..of..endof..endcase */
    .word XT_ZERO
    .word XT_EXIT 
END CASE

IMMED "of" , OF /* ( x n -- | x ) if x equals n do body of..endof else leave x on stack */
    .word XT_1PLUS
    .word XT_TO_R
    .word XT_COMPILE , XT_OVER 
    .word XT_COMPILE , XT_EQUAL
    .word XT_DOXLITERAL , XT_IF
    .word XT_EXECUTE 
    .word XT_COMPILE , XT_DROP
    .word XT_R_FROM
    .word XT_EXIT 
END OF

IMMED "endof" , ENDOF /* ( -- ) close for of in of..endof */
     .word XT_TO_R 
     .word XT_DOXLITERAL , XT_ELSE , XT_EXECUTE 
     .word XT_R_FROM  
     .word XT_EXIT
END ENDOF

IMMED "endcase" , ENDCASE /* ( x -- ) close for case in case..of..endof..endcase */
     .word XT_COMPILE , XT_DROP
     .word XT_ZERO , XT_DODO
ENDCASE1:
     .word XT_DOXLITERAL , XT_THEN , XT_EXECUTE, XT_DOLOOP , ENDCASE1
     .word XT_EXIT
END ENDCASE

