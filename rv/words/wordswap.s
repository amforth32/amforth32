# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "><" WORDSWAP /*  ( n1 - n2 ) swap the two halves of TOS */

#         slli t0, s3, 16      # Shift low word left by 16 bits into t0
#         srli t1, s3, 16      # Shift high word right by 16 bits into t1
#         or   s3, t0, t1      # Combine them back into s3

    slli t0, s3, (cellsize * 8 / 2 ) # Shift low word left into t0
    srli t1, s3, (cellsize * 8 / 2 ) # Shift high word right into t1
    or   s3, t0, t1                  # Combine them back into s3

    NEXT
END WORDSWAP
