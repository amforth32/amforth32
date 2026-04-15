# SPDX-License-Identifier: GPL-3.0-only

IMMED "match" , MATCH /* ( x -- x ) test value x for match..act..end..endmatch */
    .word XT_ZERO
    .word XT_EXIT 
END MATCH

IMMED "act" , ACT /* ( x xt -- | x ) apply test xt ( x -- f ) if f is t then do body   */
    .word XT_1PLUS
    .word XT_TO_R
    .word XT_COMPILE , XT_OVER 
    .word XT_COMPILE , XT_SWAP
    .word XT_COMPILE , XT_EXECUTE
    .word XT_DOXLITERAL , XT_IF
    .word XT_EXECUTE 
    .word XT_COMPILE , XT_DROP
    .word XT_R_FROM
    .word XT_EXIT 
END ACT

IMMED "end" , END /* ( -- ) close for act in match..act..end..endmatch */
     .word XT_TO_R 
     .word XT_DOXLITERAL , XT_ELSE , XT_EXECUTE 
     .word XT_R_FROM  
     .word XT_EXIT
END END 

IMMED "endmatch" , ENDMATCH /* ( x -- ) close for match in match..act..end..endmatch */
     .word XT_COMPILE , XT_DROP
     .word XT_ZERO , XT_DODO
ENDMATCH1:
     .word XT_DOXLITERAL , XT_THEN , XT_EXECUTE, XT_DOLOOP , ENDMATCH1
     .word XT_EXIT
END ENDMATCH
