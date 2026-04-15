# SPDX-License-Identifier: GPL-3.0-only

COLON "accept", ACCEPT /* ( ca u1 -- u2 ) receive up to u1 bytes or up to newline, store at ca; u2 is count of bytes received. */
    .word XT_OVER,XT_PLUS,XT_OVER
    /* ( ca-start ca-end ca-curr ) */
ACC1:
    .word XT_KEY,XT_DUP,XT_CRLFQ,XT_ZEROEQUAL,XT_DOCONDBRANCH, ACC5
        /* key is not CR or LF */
        .word XT_DUP,XT_DOLITERAL, 8, XT_EQUAL,XT_DOCONDBRANCH, ACC3
            /* key is BS */
            .word XT_DROP, XT_ROT, XT_2DUP, XT_GREATER /* is ca-curr > ca-start ? */
            .word XT_TO_R, XT_ROT, XT_ROT /* undo the ROT */
            .word XT_R_FROM, XT_DOCONDBRANCH, ACC6
                /* emit BS and decrement ca-curr */
	            .word XT_BS, XT_1MINUS, XT_TO_R, XT_OVER, XT_R_FROM, XT_UMAX
ACC6:           .word XT_DOBRANCH, ACC4
ACC3:    
            .word XT_DUP,XT_BL, XT_LESS, XT_DOCONDBRANCH, PFA_ACCEPT6
                /* key is less < 32, non-printable, replace it with BL */
                .word XT_DROP, XT_BL
PFA_ACCEPT6:
            /* ( ca-start ca-end ca-curr key ) */
	        .word XT_TO_R, XT_2DUP, XT_GREATER, XT_R_FROM, XT_SWAP, XT_DOCONDBRANCH, ACC7
                /* ca-end > ca-curr => handle the key */
                .word XT_DUP, XT_EMIT, XT_OVER, XT_CSTORE, XT_1PLUS, XT_OVER, XT_UMIN
	            .word XT_DOBRANCH, ACC4 
ACC7:       /* else */
                .word XT_DROP
ACC4:   .word XT_DOBRANCH, ACC1 /* repeat */
ACC5: /* key is CR or LF */
    .word XT_EMIT,XT_NIP,XT_SWAP,XT_MINUS,XT_EXIT
END ACCEPT

COLON "bs", BS /* ( -- ) emit backspace */
    .word XT_DOLITERAL
    .word 8
    .word XT_DUP
    .word XT_EMIT
    .word XT_SPACE
    .word XT_EMIT
    .word XT_EXIT
END BS

COLON "?crlf", CRLFQ /* ( c -- f ) true if c is CR or LF */
    .word XT_DUP
    .word XT_DOLITERAL
    .word 13
    .word XT_EQUAL
    .word XT_SWAP
    .word XT_DOLITERAL
    .word 10
    .word XT_EQUAL
    .word XT_OR
    .word XT_EXIT
END CRLFQ
