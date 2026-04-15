# SPDX-License-Identifier: GPL-3.0-only
#------------------------------------------------------------------------------
  CODEWORD "dnegate", DNEGATE /* ( d1 -- d2 ) d2 = -d1 */
#------------------------------------------------------------------------------

  lw t0, 0(s4) # Low
  xori t0, t0, -1
  xori s3, s3, -1
  sw t0, 0(s4)

  savetos
  li s3, 1
  savetos
  li s3, 0

  j PFA_DPLUS
END DNEGATE
