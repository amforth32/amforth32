# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "i", I /* ( -- n) inner-most loop index */
    savetos
    loadindex t0
    loadlimit t1
    add s3, t0, t1
    NEXT
END I
