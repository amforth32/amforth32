# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "r>", R_FROM /* (R: x -- )( -- x ) move top of return stack to data stack */
  savetos
  pop s3
  NEXT
END R_FROM
