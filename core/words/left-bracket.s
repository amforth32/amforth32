# SPDX-License-Identifier: GPL-3.0-only
IMMED "[", LBRACKET /* ( -- ) enter interpreter mode */
    .word XT_ZERO, XT_STATE, XT_STORE
    .word XT_EXIT
END LBRACKET
