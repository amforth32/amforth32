# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "2over", 2OVER /* ( d1 d2 -- d1 d2 d1 ) copy 2nd cell pair to the top of the stack */
  savetos
  lw s3, 12(s4)
  savetos
  lw s3, 12(s4)
  NEXT
END 2OVER
