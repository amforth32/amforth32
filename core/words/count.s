# SPDX-License-Identifier: GPL-3.0-only

COLON "count", COUNT /* ( addr -- addr+1 n ) get count information out of a counted string */
    .word XT_DUP,XT_1PLUS,XT_SWAP,XT_CFETCH,XT_EXIT
END COUNT
