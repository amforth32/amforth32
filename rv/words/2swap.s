# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "2swap", 2SWAP /* ( d1 d2 -- d2 d1 ) swap top two cell pairs on the stack */
  mv t0, s3
  lw s3, 4(s4)
  sw t0, 4(s4)

  lw t0, 0(s4)
  lw t1, 8(s4)
  sw t0, 8(s4)
  sw t1, 0(s4)
  NEXT
END 2SWAP

