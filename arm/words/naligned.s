# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "naligned" , NALIGNED /* ( n a1 -- a2 ) n = 2**u; a2 is a1 aligned (up) at n bytes */
naligned:
    ldr     r1, [DSP]       @ r1 = n (byte count from NOS)
    add     DSP, DSP, #4    @ pop stack (remove n)

    sub     r0, r1, #1      @ r0 = n - 1 (alignment mask)
    add     TOS, TOS, r0    @ TOS = a + (n - 1)
    mvn     r0, r0          @ r0 = ~(n - 1)
    and     TOS, TOS, r0    @ TOS = (a + mask) & ~mask

    @ TOS now contains aligned address (new TOS)
    NEXT                    @ return to Forth interpreter
END NALIGNED
