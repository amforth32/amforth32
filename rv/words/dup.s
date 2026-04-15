# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "dup", DUP /* ( x -- x x ) duplicate TOS */ 
  addi s4, s4, -4
  sw s3, 0(s4)
  NEXT
END DUP
