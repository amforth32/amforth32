# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "execute", EXECUTE /* ( xt -- ) execute XT at the top of the stack */

  mv s1,s3
  loadtos
  j DO_EXECUTE
END EXECUTE
