# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "1ms", 1MS /* ( -- ) 1ms busy delay loop (96MHz system clock) */

# For CH32V307 @ 96MHz
# 96E6/1000 cycles and two instructions plus VM change
# would imply 48E3 cycles...but perhaps due to pipeline
# hazard on branch the loop seems to take 3 cycles always.

    li t0, 32000
1:
    addi t0,t0,-1
    bne t0,zero,1b
    NEXT
END 1MS

CODEWORD "1s", 1S /* ( -- ) SYSTEM: 1s busy delay loop (96MHz system clock) */

# For CH32V307 @ 96MHz
# 96E6/1000 cycles and two instructions plus VM change
# would imply 48E3 cycles...but perhaps due to pipeline
# hazard on branch the loop seems to take 3 cycles always.

    li t0, 32000000
1:
    addi t0,t0,-1
    bne t0,zero,1b
    NEXT
END 1S

COLON "ms", MS /* ( n -- )  n ms busy delay loop */

XT_MS_LOOP:
  .word XT_PAUSE
  .word XT_1MINUS
  .word XT_1MS
  .word XT_DUP,XT_ZEROEQUAL
  .word XT_DOCONDBRANCH
  .word XT_MS_LOOP
  .word XT_DROP,XT_EXIT
END MS
