# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "dup", DUP /* ( x -- x x ) duplicate TOS */ 
  savetos
  NEXT
END DUP
