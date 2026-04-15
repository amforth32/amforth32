# SPDX-License-Identifier: GPL-3.0-only

COLON "ms", MS /* ( u -- )  u ms delay loop */

XT_MS_LOOP:
  .word XT_1MINUS
  .word XT_1MS
  .word XT_DUP,XT_ZEROEQUAL
  .word XT_DOCONDBRANCH
  .word XT_MS_LOOP
  .word XT_DROP,XT_EXIT
END MS
