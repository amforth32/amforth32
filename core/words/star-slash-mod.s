COLON "*/mod", STARSLASHMOD /* ( n1 n2 n3 -- n4 n5) n5 is the quotient and n4 the remainder of n1 * n2 / n3 */
/* Multiply n1 by n2 producing the intermediate double-cell result d. Divide d by n3 producing the single-cell remainder n4 and the single-cell quotient n5.

An ambiguous condition exists if n3 is zero, or if the quotient n5 lies outside the range of a single-cell signed integer. If d and n3 differ in sign, the implementation-defined result returned will be the same as that returned by either the phrase >R M* R> FM/MOD or the phrase >R M* R> SM/REM. */
	.word XT_TO_R
	.word XT_MSTAR
	.word XT_R_FROM
	.word XT_MSLASHMOD
	.word XT_EXIT
END STARSLASHMOD
