# SPDX-License-Identifier: GPL-3.0-only

COLON "0>", GREATERZERO /* ( n -- f ) f = n > 0 */
    .word XT_ZERO,XT_GREATER,XT_EXIT
END GREATERZERO

