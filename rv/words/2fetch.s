# SPDX-License-Identifier: GPL-3.0-only
CODEWORD  "2@", 2FETCH /* ( addr - d ) fetch two cells at addr */

  andi t0, s3, 0x3       /* cell aligned ?        */
  beqz t0, 1f            /* branch if OK          */

  /* handle exception ...                         */

  throw EADRINV

1: /* normal operation ...                        */

  addi s4, s4, -4
  lw   t0, 4(s3)
  sw   t0, 0(s4)
  lw   s3, 0(s3)
  NEXT
END 2FETCH
