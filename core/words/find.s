# SPDX-License-Identifier: GPL-3.0-only

COLON "find", FIND /* ( c-addr -- 0 | xt -1 | xt 1 ) search for word matching counted string, return xt if found */
    .word XT_COUNT
    .word XT_FINDXT
    .word XT_EXIT 
END FIND
