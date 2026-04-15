CODEWORD  "um*", UMSTAR /* (u1 u2 -- ud ) ud = u1 * u2 */
    ldr r0, [DSP]  @ To be calculated: Tos * r0
    umull r0, TOS, TOS, r0 @ umull lo, hi, x, y => hi:lo = x*y
    str r0, [DSP]
    NEXT
END UMSTAR
