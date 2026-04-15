# SPDX-License-Identifier: GPL-3.0-only

DEFER "source", SOURCE, XT_SOURCETIB /* ( -- s ) contents of current source */
END SOURCE

COLON "source-tib", SOURCETIB /* ( -- s ) contents of TIB */

    .word XT_TIB
    .word XT_NUMBERTIB
    .word XT_FETCH
    .word XT_EXIT
END SOURCETIB
