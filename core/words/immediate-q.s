# SPDX-License-Identifier: GPL-3.0-only

NONAME "immediate?", IMMEDIATEQ
    .word XT_FETCH
    .word  XT_DOLITERAL
    .word  Flag_immediate
    .word  XT_TUCK
    .word  XT_AND
    .word  XT_EQUAL
    .word  XT_DOCONDBRANCH, 1f
        .word  XT_ONE
        .word  XT_EXIT
1:
    .word  XT_MINUSONE
    .word  XT_EXIT
END IMMEDIATEQ
