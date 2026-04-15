# SPDX-License-Identifier: GPL-3.0-only

COLON "search" , SEARCH /* ( s1 s2 -- s3 f ) search s1 for s2 leaving flag and tail string s3. No match s3==s1 */
    .word XT_2SWAP
#    
    .word XT_2DUP
    .word XT_TO_R
    .word XT_TO_R
#    
    .word XT_SIFT
#
    .word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,SEARCH_0001 /* if */
	.word XT_2DROP
    .word XT_R_FROM
    .word XT_R_FROM
	.word XT_FALSE
	.word XT_DOBRANCH,SEARCH_0002
SEARCH_0001: /* else */
    .word XT_RDROP
    .word XT_RDROP
	.word XT_TRUE
SEARCH_0002: /* then */
	.word XT_EXIT



#

    .word XT_EXIT

COLON "sub-string?", SUBMINUSSTRINGQ /* ( s1 s2 -- f ) f is true if s1 found in s2 */
# ( s1 s2 -- f ) STRING: f is true if s1 found in s2
    .word XT_SIFT
    .word XT_NIP
    .word XT_NIP
    .word XT_EXIT

COLON "sift" , SIFT /* ( s1 s2 -- s3 f ) find s1 in s2 leaving flag and tail string s3 */

SIFT_0001: /* while */
    .word XT_TWO
    .word XT_PICK
    .word XT_OVER
    .word XT_GREATER
    .word XT_INVERT
    .word XT_DOCONDBRANCH,SIFT_0002 /* while */
    .word XT_2OVER
    .word XT_DOLITERAL
    .word 3
    .word XT_PICK
    .word XT_OVER
    .word XT_COMPARE
    .word XT_DOCONDBRANCH,SIFT_0003 /* while */
    .word XT_ONE
    .word XT_SLASHSTRING
    .word XT_DOBRANCH,SIFT_0001 /* repeat */
SIFT_0003:
    .word XT_2NIP
    .word XT_TRUE
    .word XT_EXIT
SIFT_0002: /* then */
    .word XT_2DROP
    .word XT_FALSE
    .word XT_EXIT
