# SPDX-License-Identifier: GPL-3.0-only

COLON "vallot" , VALLOT /* ( u -- ) allocate u bytes from the variable RAM pool */
    .word XT_VP
    .word XT_PLUS
    .word XT_DOTO, XT_VP

    .word XT_VP
    .word XT_VPDOTMAX
    .word XT_LESS , XT_DOCONDBRANCH, VALLOT_0000
    .word XT_FINISH
VALLOT_0000:
    STRING "ram pool overwrites ram dictionary"
    .word XT_TYPE
    .word XT_DOLITERAL, -50, XT_THROW
    .word XT_EXIT 
END VALLOT
