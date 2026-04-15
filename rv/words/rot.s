# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "rot", ROT /* (x1 x2 x3 -- x2 x3 x1) rotate top 3 cells on stack left, 3OS becomes TOS */
# -----------------------------------------------------------------------------
  lw t0, 0(s4)
  lw t1, 4(s4)
  sw s3, 0(s4)
  sw t0, 4(s4)
  mv s3, t1
  NEXT
END ROT
