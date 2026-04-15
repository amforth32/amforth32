# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "drop", DROP /* ( x -- ) drop TOS */
  lw s3, 0(s4)
  addi s4, s4, 4
  NEXT
END DROP
