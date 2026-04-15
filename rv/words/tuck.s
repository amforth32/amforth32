# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "tuck", TUCK /* ( x1 x2 -- x2 x1 x2 ) insert TOS below 2nd cell of the stack */ 
# -----------------------------------------------------------------------------
  lw t0, 0(s4)
  addi s4, s4, -4
  sw s3, 4(s4)
  sw t0, 0(s4)
  NEXT
END TUCK
