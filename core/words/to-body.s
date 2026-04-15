# SPDX-License-Identifier: GPL-3.0-only

COLON ">body", TO_BODY /* ( xt -- pfa ) given xt return pfa */
    .word XT_CELLPLUS,XT_EXIT
END TO_BODY
