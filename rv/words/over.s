# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "over", OVER /* ( x1 x2 -- x1 x2 x1 ) copy NOS to the top */
  addi s4, s4, -4
  sw s3, 0(s4)
  lw s3, 4(s4)
  NEXT
END OVER
