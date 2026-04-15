# SPDX-License-Identifier: GPL-3.0-only

COLON "ud.", UDDOT /* ( ud -- ) print ud as unsigned double */
    .word XT_ZERO, XT_UDDOTR, XT_SPACE, XT_EXIT
END UDDOT

