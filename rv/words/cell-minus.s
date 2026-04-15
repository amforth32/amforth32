# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "cell-", CELLMINUS /* ( n1 -- n2 ) n2 = n1 - cellsize */
  addi s3, s3, -cellsize
  NEXT
END CELLMINUS
