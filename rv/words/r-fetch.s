# SPDX-License-Identifier: GPL-3.0-only
#------------------------------------------------------------------------------
  CODEWORD "r@", R_FETCH /* (R: x -- x )( -- x ) copy top of return stack to data stack */
#------------------------------------------------------------------------------
  savetos
  lw s3, 0(s5)
  NEXT
END R_FETCH

#------------------------------------------------------------------------------
  CODEWORD "r'@", R_PRIMEFETCH /* (R: x1 x2 -- x1 x2 )( -- x1 ) copy second cell of return stack to data stack */
#------------------------------------------------------------------------------
  savetos
  lw s3, 4(s5)
  NEXT
END R_PRIMEFETCH
