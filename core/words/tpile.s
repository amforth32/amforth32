/*
    Emits a stream of tokens when words are compiled. Tokens can be easily converted to ITC given a list of XT addresses (from a symbol table). See (#transpile directive in amforth-shell)

    Doesn't handle (see XT_COMMA references):
    * :noname (no word token or word XT emitted)
    * does> parent/child word
    * postpone
    * to : current definition compiles oddly, e.g.
        # pvp cell+ cell+ to pvp \ increment pvp
        .word XT_PVP, XT_CELLPLUS, XT_CELLPLUS, XT_DOXLITERAL, 0x400055A8, XT_DEFER_STORE
 */

VARIABLE "tpile", TPILE /* ( -- f ) transpiling status */
END TPILE

COLON "tpile+", TPILEPLUS /* ( -- ) enable transpiling during compilation */
    .word XT_TRUE, XT_TPILE, XT_STORE, XT_EXIT
END TPILEPLUS

COLON "tpile-", TPILEMINUS /* ( -- ) disable transpiling during compilation */
    .word XT_FALSE, XT_TPILE, XT_STORE, XT_EXIT
END TPILEMINUS

NONAME "tpile.word", TPILE_WORD /* ( -- ) emits word token prefix indicating the word type */
    .word XT_TPILE, XT_FETCH, XT_DOCONDBRANCH, 1f
        .word XT_FLAGDOTHEADER, XT_FLAGDOTCOLON, XT_EQUAL, XT_DOCONDBRANCH, 2f
            STRING "WW"
            .word XT_TYPE, XT_DOBRANCH, 1f
2:      .word XT_FLAGDOTHEADER, XT_FLAGDOTIMMED, XT_EQUAL, XT_DOCONDBRANCH, 3f
            STRING "WI"
            .word XT_TYPE, XT_DOBRANCH, 1f
3:      .word XT_FLAGDOTHEADER, XT_FLAGDOTVAR, XT_EQUAL, XT_DOCONDBRANCH, 4f
            STRING "WV"
            .word XT_TYPE, XT_DOBRANCH, 1f
4:      .word XT_FLAGDOTHEADER, XT_FLAGDOTCON, XT_EQUAL, XT_DOCONDBRANCH, 5f
            STRING "WC"
            .word XT_TYPE, XT_DOBRANCH, 1f
5:      .word XT_FLAGDOTHEADER, XT_FLAGDOTVALUE, XT_EQUAL, XT_DOCONDBRANCH, 6f
            STRING "WU"
            .word XT_TYPE, XT_DOBRANCH, 1f
6:      .word XT_FLAGDOTHEADER, XT_FLAGDOTDEFER, XT_EQUAL, XT_DOCONDBRANCH, 7f
            STRING "WD"
            .word XT_TYPE, XT_DOBRANCH, 1f
7:      /* otherwise */
            STRING "W?"
            .word XT_TYPE
1:   .word XT_EXIT
END TPILE_WORD

NONAME "tpile.name", TPILE_NAME /* ( s -- s ) called from header to append the word name to the word token prefix */
    .word XT_TPILE, XT_FETCH, XT_DOCONDBRANCH, 1f
        .word XT_2DUP, XT_BOUNDS
        .word XT_QDOCHECK,XT_DOCONDBRANCH, 1f
            .word XT_DODO
2:          .word XT_I, XT_CFETCH, XT_2XDOT
            .word XT_DOLOOP, 2b
        .word XT_SPACE
1:  .word XT_EXIT
END TPILE_NAME

NONAME "tpile.wxt", TPILE_WXT /* ( -- ) called after word token is emitted, emits XT token of current word */
    .word XT_TPILE, XT_FETCH, XT_DOCONDBRANCH, 1f
        .word XT_DOLITERAL, 88, XT_EMIT /* X */
        .word XT_DP, XT_8XDOT, XT_SPACE
1:   .word XT_EXIT
END TPILE_WXT

NONAME "tpile.end", TPILE_END /* ( -- ) called by semicolon to emit end of word token */
    .word XT_TPILE, XT_FETCH, XT_DOCONDBRANCH, 1f
        STRING "END "
        .word XT_TYPE
1:  .word XT_EXIT
END TPILE_END

NONAME "tpile.xt", TPILE_XT /* ( xt -- xt ) called when XT is compiled, emits XT token */
    .word XT_TPILE, XT_FETCH, XT_DOCONDBRANCH, 1f
        .word XT_DOLITERAL, 88, XT_EMIT /* X */
        .word XT_DUP, XT_8XDOT, XT_SPACE
1:   .word XT_EXIT
END TPILE_XT

NONAME "tpile.lit", TPILE_LIT /* ( x -- x ) called when literal value is compiled, emits literal token */
    .word XT_TPILE, XT_FETCH, XT_DOCONDBRANCH, 1f
        .word XT_DOLITERAL, 36, XT_EMIT /* $ */
        .word XT_DUP, XT_UHEXDOT
1:   .word XT_EXIT
END TPILE_LIT

NONAME "tpile.slit", TPILE_SLIT /* ( s -- s ) called when string literal is compiled, emits string token */
    .word XT_TPILE, XT_FETCH, XT_DOCONDBRANCH, 1f
        .word XT_DOLITERAL, 83, XT_EMIT /* S */
        .word XT_2DUP, XT_BOUNDS
        .word XT_QDOCHECK,XT_DOCONDBRANCH, 1f
            .word XT_DODO
2:          .word XT_I, XT_CFETCH, XT_2XDOT
            .word XT_DOLOOP, 2b
        .word XT_SPACE
1:  .word XT_EXIT
END TPILE_SLIT

NONAME "tpile.fwd", TPILE_FWD /* ( a -- a ) called by >mark, emits forward jump token  */
    .word XT_TPILE, XT_FETCH, XT_DOCONDBRANCH, 1f
        .word XT_DOLITERAL, 70, XT_EMIT /* F */
        .word XT_DUP, XT_8XDOT, XT_SPACE
1:   .word XT_EXIT
END TPILE_FWD

NONAME "tpile.back", TPILE_BACK /* ( a -- a ) called by <resolve, emits backward jump token  */
    .word XT_TPILE, XT_FETCH, XT_DOCONDBRANCH, 1f
        .word XT_DOLITERAL, 66, XT_EMIT /* B */
        .word XT_DUP, XT_8XDOT, XT_SPACE
1:   .word XT_EXIT
END TPILE_BACK

NONAME "tpile.label", TPILE_LABEL /* ( a -- a ) called by <mark and >resolve, emits label token */
    .word XT_TPILE, XT_FETCH, XT_DOCONDBRANCH, 1f
        .word XT_DOLITERAL, 76, XT_EMIT /* L */
        .word XT_DUP, XT_8XDOT, XT_SPACE
1:   .word XT_EXIT
END TPILE_LABEL

