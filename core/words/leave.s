# SPDX-License-Identifier: GPL-3.0-only
IMMED "leave", LEAVE /* ( -- )(R: loop-sys -- ) immediately leave the current DO..LOOP */
    .word XT_COMPILE,XT_UNLOOP
    .word XT_AHEAD,XT_TO_L,XT_EXIT
END LEAVE
