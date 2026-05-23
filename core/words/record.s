# SPDX-License-Identifier: GPL-3.0-only
/*
a recognizer for records

: 0x3A (default but not record.minlen and :noname)
= 0x3D

*/

VALUE "record.char" , RECORDDOTCHAR, 0x3A
END RECORDDOTCHAR

VALUE "record.minlen" , RECORDDOTMINLEN , 8
END RECORDDOTMINLEN

DEFER "record.do" , RECORDDOTDO, XT_2DROP /* ( a n -- ) */
END RECORDDOTDO

DATA "rectype-record", RECTYPE_RECORD
    .word XT_NOP 
    .word XT_NOP 
    .word XT_NOP
END RECTYPE_RECORD

# ----------------------------------------------------------------------
COLON "rec-record", REC_RECORD
	.word XT_OVER
	.word XT_CFETCH
	.word XT_RECORDDOTCHAR
	.word XT_EQUAL
	.word XT_NOT
	.word XT_DOCONDBRANCH,HEXDOTINT_0001 /* if */
	.word XT_2DROP                       
    .word XT_RECTYPE_NULL
	.word XT_FINISH
HEXDOTINT_0001: /* then */
	.word XT_DUP
	.word XT_RECORDDOTMINLEN
	.word XT_LESS
	.word XT_DOCONDBRANCH,HEXDOTINT_0002 /* if */
	.word XT_2DROP
    .word XT_RECTYPE_NULL
	.word XT_FINISH
HEXDOTINT_0002: /* then */
	.word XT_1MINUS
	.word XT_SWAP
	.word XT_1PLUS
	.word XT_SWAP
	.word XT_RECORDDOTDO
    .word XT_RECTYPE_RECORD
	.word XT_EXIT
END REC_RECORD


