# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "bogus", BOGUS /* ( x -- x x ) duplicate TOS */

/*
    A test word to show the limitations of software enforced
    protection for stack overflow. If the enforcement framework is
    not used everywhere, then not everywhere is protected. 
*/

  addi s4, s4, -8
  sw s3, 4(s4)
  sw s3,  (s4)
  NEXT
END BOGUS

