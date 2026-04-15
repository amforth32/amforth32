# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "pick", PICK /* ( xu .. x1 x0 u -- xu ... x1 x0 xu ) copy u-th stack cell to the top */
# -----------------------------------------------------------------------------
  sll s3, s3, 2
  add s3, s3, s4
  lw s3, 0(s3)
  NEXT
END PICK
