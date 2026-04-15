# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "ashift", ASHIFT /* ( n1 u -- n2  ) n2 = n1 >> u (arithmetic shift right, sign filled) */
  lw t0, 0(s4)
  addi s4, s4, 4
  sra s3, t0, s3
  NEXT
END ASHIFT
