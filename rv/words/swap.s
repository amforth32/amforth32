# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "swap", SWAP /* ( x1 x2 -- x2 x1 ) swap top 2 cells on the stack */
  mv t0, s3
  lw s3, 0(s4)
  sw t0, 0(s4)
  NEXT
END SWAP
