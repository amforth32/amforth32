# SPDX-License-Identifier: GPL-3.0-only
  CODEWORD "aligned", ALIGNED # ( c-addr -- a-addr )
  andi t0, s3, 1
  add s3, s3, t0
  andi t0, s3, 2
  add s3, s3, t0
  NEXT
