# SPDX-License-Identifier: GPL-3.0-only

COLON ":", COLON /* ( "name" -- ) create a colon word entry in the dictionary */
    .word XT_FLAGDOTCOLON
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
.if WANT_TRANSPILER == YES
    .word XT_TPILE_WORD
.endif
    .word XT_DOCREATE
    .word XT_COLONNONAME
    .word XT_DROP
    .word XT_EXIT
END COLON

COLON ":~", COLONTILDE /* ( "name" -- ) start a colon word that will transpile as a noname */
/* This is equivalent to COLON, the only difference is that it will be transpiled as a noname.
   Regular NONAME cannot be transpiled because the transpilation process needs a name
   so that the word can be found by name when called (ITC can call nonames by their symbol).
*/
    .word XT_FLAGDOTCOLON
    .word XT_DOTO
    .word XT_FLAGDOTHEADER
.if WANT_TRANSPILER == YES
    .word XT_TPILE_NONAME
.endif
    .word XT_DOCREATE
    .word XT_COLONNONAME
    .word XT_DROP
    .word XT_EXIT
END COLONTILDE
