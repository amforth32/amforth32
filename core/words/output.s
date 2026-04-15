# 
# : dec. \# ( n -- ) print n in base 10
#     base @ swap #10 base ! . base !
# ;
# 
# : uhex. \# ( u -- ) print u in base 16
#     base @ swap #16 base ! u. base !
# ;
# 
# ----------------------------------------------------------------------
COLON "dec.", DECDOT /* ( n -- ) print n in base 10 */
	.word XT_BASE
	.word XT_FETCH
	.word XT_SWAP
	.word XT_DOLITERAL
	.word 10
	.word XT_BASE
	.word XT_STORE
	.word XT_DOT
	.word XT_BASE
	.word XT_STORE
	.word XT_EXIT
END DECDOT
# ----------------------------------------------------------------------
NONAME "uhex.", UHEXDOT /* ( u -- ) print u in base 16 */
	.word XT_BASE
	.word XT_FETCH
	.word XT_SWAP
	.word XT_DOLITERAL
	.word 16
	.word XT_BASE
	.word XT_STORE
	.word XT_UDOT
	.word XT_BASE
	.word XT_STORE
	.word XT_EXIT
END UHEXDOT
