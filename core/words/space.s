# SPDX-License-Identifier: GPL-3.0-only

COLON "space", SPACE /* ( -- ) emit a space */
    .word XT_BL,XT_EMIT,XT_EXIT
END SPACE
