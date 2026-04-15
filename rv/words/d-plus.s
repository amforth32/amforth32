# SPDX-License-Identifier: GPL-3.0-only
#------------------------------------------------------------------------------
  CODEWORD "d+", DPLUS /* ( d1 d2 -- d3 ) d3 = d1 + d2 */
#------------------------------------------------------------------------------

  push a0

  lw t0, 8(s4)
  lw t1, 0(s4)

  add a0, t0, t1
  sw a0, 8(s4)

  sltu a0, a0, t0

  lw t0, 4(s4)
  add s3, t0, s3
  add s3, s3, a0

  addi s4, s4, 8

  pop a0

  NEXT
END DPLUS
