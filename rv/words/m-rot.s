# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "-rot", MROT /* (x1 x2 x3 -- x3 x1 x2) rotate top 3 cells on stack right, TOS becomes 3OS */
# -----------------------------------------------------------------------------
  lw t0, 0(s4)
  lw t1, 4(s4)
  sw t1, 0(s4)
  sw s3, 4(s4)
  mv s3, t0
  NEXT
END MROT
