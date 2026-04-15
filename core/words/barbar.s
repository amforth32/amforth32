# SPDX-License-Identifier: GPL-3.0-only

IMMED "||", BARBAR /* ( -- ) code after || is ignored during compilation if debugger is disabled */
/* : || debug.break @ 0= if postpone \ then ; immediate  */
    .word XT_DEBUG_BREAK
    .word XT_FETCH
    .word XT_ZEROEQUAL
    .word XT_DOCONDBRANCH , BARBAR1 
    .word XT_BACKSLASH
BARBAR1:    
    .word XT_EXIT
END BARBAR
