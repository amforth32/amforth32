# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "?dup", QDUP /* ( x -- x x | 0 ) duplicate TOS if it is not zero */
# -----------------------------------------------------------------------------
  beq s3, zero, 1f
    savetos
1:NEXT
END QDUP
