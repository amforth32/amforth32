# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "naligned", NALIGNED /* ( n a1 -- a2 ) a2 is a1 aligned (up) at n bytes (n must be power of 2)  */
naligned:
    lw      t1, 0(s4)       # t1 = n (byte count from NOS)
    addi    s4, s4, 4       # pop stack (remove n)

    addi    t0, t1, -1      # t0 = n - 1 (alignment mask)
    add     s3, s3, t0      # s3 = a + (n - 1)
    not     t0, t0          # t0 = ~(n - 1)
    and     s3, s3, t0      # s3 = (a + mask) & ~mask

    # s3 now contains aligned address (new TOS)
    NEXT                    # return to Forth interpreter
END NALIGNED
