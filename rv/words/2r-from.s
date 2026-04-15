# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "2r>", 2R_FROM /* (R: d -- )( -- d ) move top 2 cells from return stack to data stack */
  savetos
  pop t0
  pop s3
  savetos
  mv s3,t0
  NEXT
END 2R_FROM
