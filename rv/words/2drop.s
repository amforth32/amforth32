# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "2drop", 2DROP /* ( d -- ) drop top cell pair from the stack */ 
  lw s3, 4(s4)
  addi s4, s4, 8
  NEXT
END 2DROP
