# SPDX-License-Identifier: GPL-3.0-only
COLON "?stack", QSTACK /* ( -- ) throw if stack depth is negative */
    .word XT_DEPTH
    .word XT_ZEROLESS
    .word XT_DOCONDBRANCH,PFA_QSTACK1
      .word XT_DOLITERAL, -4, XT_THROW
PFA_QSTACK1:
    .word XT_EXIT
END QSTACK
