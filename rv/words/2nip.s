# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "2nip", 2NIP /* ( d2 d1 -- d1 ) remove 2nd cell pair from the stack */
  lw t0, 0(s4)
  addi s4, s4, 8
  sw t0, 0(s4)
  NEXT
END 2NIP
