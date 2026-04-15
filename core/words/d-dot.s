# SPDX-License-Identifier: GPL-3.0-only

COLON "d.", DDOT /* ( d -- ) print d as signed number */
    .word  XT_ZERO, XT_DDOTR, XT_SPACE, XT_EXIT
END DDOT
