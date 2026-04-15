# SPDX-License-Identifier: GPL-3.0-only

IMMED "then", THEN /* ( -- )(C: a -- ) ends an if, target of forward jumps */
    .word XT_GRESOLVE
    .word XT_EXIT
END THEN
