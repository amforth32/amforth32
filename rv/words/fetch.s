# SPDX-License-Identifier: GPL-3.0-only
  CODEWORD "@", FETCH /* (addr -- x) x = [addr]; load word at addr */

    andi t0, s3, 0x3       /* cell aligned ?        */
    beqz t0, 1f            /* branch if OK          */

    /* handle exception ...                         */

    throw EADRINV

1:  /* normal operation ...                         */

    lw s3, 0(s3)

    NEXT
END FETCH
