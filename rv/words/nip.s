# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "nip", NIP /* ( x1 x2 -- x2 ) drop NOS */
  addi s4, s4, 4
  NEXT
END NIP
