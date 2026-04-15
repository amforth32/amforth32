# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "j", J /* ( -- n) second loop index */
  savetos
  lw s3,0(s5) # usual assumptions about J
  lw t0,4(s5)
  add s3,s3,t0
  NEXT
END J
