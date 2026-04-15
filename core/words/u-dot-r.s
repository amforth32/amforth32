# SPDX-License-Identifier: GPL-3.0-only

COLON "u.r", UDOTR /* ( u u2 -- ) print u as unsigned, right aligned at width u2 */
    .word  XT_ZERO, XT_SWAP, XT_UDDOTR, XT_EXIT
END UDOTR
