# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "2*", 2STAR /* ( n1 -- n2 ) n2 = 2 * n1 */
  add s3, s3, s3
  NEXT
END 2STAR
