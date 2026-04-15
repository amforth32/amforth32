# SPDX-License-Identifier: GPL-3.0-only

DATA "rectype-null", RECTYPE_NULL
    .word XT_FAIL  
    .word XT_FAIL  
    .word XT_FAIL
END RECTYPE_NULL

NONAME "fail", FAIL
    .word XT_DOLITERAL, -13, XT_THROW
END FAIL
