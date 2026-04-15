COLON "m/mod", MSLASHMOD /* ( d n1 -- n2 n3 ) n3 is quotient and n2 remainder of d / n1 */
/* Divide d by n1, giving the quotient n3 and the remainder n2.

All values and arithmetic are signed. Throw if n1 is zero or if the quotient n3 lies outside the range of a single-cell signed integer.
OUTLINE:
    * perform the operation on unsigned values um/mod
    * if the signs were different then the quotient is negative
    * if the dividend was negative then the remainder is negative */
# ( dividend divisor -- reminder quotient )
    /* throw if divisor is zero */
    .word XT_DUP, XT_ZEROEQUAL, XT_DOCONDBRANCH, 1f
	.word XT_DOLITERAL, EDIVZ, XT_THROW

    /* stash sign of divisor and negate it if necessary */
1:  .word XT_DUP, XT_ZEROLESS, XT_DUP, XT_TO_R /* (R: divsor-neg? ) */
    .word XT_DOCONDBRANCH, 2f, XT_NEGATE

    /* stash sign of dividend and negate it if necessary */
2:  .word XT_MROT, XT_DUP, XT_ZEROLESS, XT_DUP, XT_TO_R /* (R: divsor-neg? divend-neg?) */
    .word XT_DOCONDBRANCH, 3f, XT_DNEGATE

    /* now perform the unsigned um/mod */
3:  .word XT_ROT, XT_UMSLASHMOD /* (rem quo) (R: divsor-neg? divend-neg?) */
    /* negate remainder if divend-neg? */
    .word XT_R_FETCH, XT_DOCONDBRANCH, 4f
    .word XT_SWAP, XT_NEGATE, XT_SWAP
    /* negate quotient if signs were different (divsor-neg? xor divend-neg?) */
4:  .word XT_R_FROM, XT_R_FROM, XT_XOR, XT_DOCONDBRANCH, 5f
    .word XT_NEGATE

5:  .word XT_EXIT
END MSLASHMOD

COLON "sm/rem", SMSLASHREM /* ( d n1 -- n2 n3 ) alias for m/mod */
    .word XT_MSLASHMOD, XT_EXIT
END SMSLASHREM
