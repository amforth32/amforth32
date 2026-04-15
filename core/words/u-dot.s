# SPDX-License-Identifier: GPL-3.0-only

COLON "u.", UDOT /* ( u -- ) print u as unsigned */
    .word  XT_ZERO, XT_UDDOT, XT_EXIT
END UDOT

