# SPDX-License-Identifier: GPL-3.0-only

IMMED "is" , IS /* ( xt "name" -- ) set deferred action "name" to xt */
    .word XT_STATE
    .word XT_FETCH
    .word XT_DOCONDBRANCH , AT0
    .word XT_BRACKETTICK
    .word XT_COMPILE , XT_DEFER_STORE
    .word XT_FINISH
AT0:
    .word XT_TICK
    .word XT_DEFER_STORE
    .word XT_EXIT
END IS

      
