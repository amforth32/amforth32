COLON "*/", STARSLASH /* ( n1 n2 n3 -- n4 ) n4 = n1 * n2 / n3 */
/* Multiply n1 by n2 producing the intermediate double-cell result d. Divide d by n3 giving the single-cell quotient n4.

An ambiguous condition exists if n3 is zero or if the quotient n4 lies outside the range of a signed number.
If d and n3 differ in sign, the implementation-defined result returned will be the same as that returned by either the phrase >R M* R> FM/MOD SWAP DROP or the phrase >R M* R> SM/REM SWAP DROP.
*/
	.word XT_STARSLASHMOD
    .word XT_NIP
	.word XT_EXIT
END STARSLASH
