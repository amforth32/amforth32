# SPDX-License-Identifier: GPL-3.0-only

COLON "binary", BINARY /* ( -- ) set base to binary */
    .word XT_TWO,XT_BASE,XT_STORE,XT_EXIT
END BINARY
