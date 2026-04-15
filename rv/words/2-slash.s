# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "2/", 2SLASH /* ( n1 -- n2 ) n2 = n1 / 2 */
  srai s3, s3, 1
  NEXT
END 2SLASH

