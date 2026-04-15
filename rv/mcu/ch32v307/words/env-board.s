# SPDX-License-Identifier: GPL-3.0-only

ENVIRONMENT "board", BOARD /* ( -- addr u ) string with board identifier */

.ifdef TARGET_203
    STRING "WCH CH32V203"
.endif

.ifdef TARGET_307
    STRING "WCH CH32V307"
.endif

.ifdef TARGET_305
    STRING "WCH CH32V305"
.endif


    .word XT_EXIT
END BOARD

