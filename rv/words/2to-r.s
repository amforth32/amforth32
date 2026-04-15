# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "2>r", 2TO_R /* ( d -- )(R: -- d ) move top two cells from data stack to return stack */
  mv t0,s3
  loadtos
  push s3
  loadtos
  push t0
  NEXT
END 2TO_R
