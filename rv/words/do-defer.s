# SPDX-License-Identifier: GPL-3.0-only
HEADLESS "(defer)", DODEFER
  lw s1,0(s1)
  lw s1,0(s1)
  j DO_EXECUTE
  NEXT 
END DODEFER

CODEWORD "odd" , ODD

  lw s1,0(s1)
  j DO_EXECUTE

  NEXT
END ODD

CONSTANT "pfa.odd", PFADOTODD , PFA_ODD 
END PFADOTODD
