# SPDX-License-Identifier: GPL-3.0-only

COLON "char", CHAR /* ( "name" -- c ) parse name return first letter */
    .word XT_PARSENAME
    .word XT_ZEROEQUAL,XT_DOCONDBRANCH,CHAR_1
       .word XT_DOLITERAL, -16, XT_THROW
CHAR_1:
    .word XT_CFETCH
    .word XT_EXIT
END CHAR
