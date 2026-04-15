# SPDX-License-Identifier: GPL-3.0-only

COLON "]", RBRACKET /* ( -- ) enter compiler mode */
    .word XT_ONE
    .word XT_STATE
    .word XT_STORE
    .word XT_EXIT
END RBRACKET
