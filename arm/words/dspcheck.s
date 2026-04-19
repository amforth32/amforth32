# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "dspcheck", DSPCHECK /* ( -- a n ) leave address and count for DUMP to view datastack memory */
    savetos
    ldr TOS, =RAM_lower_runover
    bic TOS, TOS, #0xF
    savetos
    mov TOS, #0x18
  NEXT
END DSPCHECK

