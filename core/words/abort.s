# SPDX-License-Identifier: GPL-3.0-only

COLON "abort", ABORT /* ( i*x -- )(R: j*x -- ) throw EABRT exception (-1) */
    .word XT_TRUE
    .word XT_THROW
END ABORT
