# SPDX-License-Identifier: GPL-3.0-only
COLON "cr", CR /* ( -- ) emit CR then emit LF */
    .word XT_DOLITERAL,13,XT_EMIT
    .word XT_DOLITERAL,10,XT_EMIT
    .word XT_EXIT
END CR
