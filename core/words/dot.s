# SPDX-License-Identifier: GPL-3.0-only

COLON ".", DOT /* ( n -- ) print n as signed number */
   .word XT_S2D, XT_DDOT, XT_EXIT
END DOT
