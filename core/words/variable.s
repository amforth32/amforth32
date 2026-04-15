# SPDX-License-Identifier: GPL-3.0-only

COLON "variable", VARIABLE /* ( "<spaces>name" -- ) create variable definition for name */
      .word XT_FLAGDOTVAR
      .word XT_DOTO
      .word XT_FLAGDOTHEADER
.if WANT_TRANSPILER == YES
      .word XT_TPILE_WORD
.endif
      .word XT_DOCREATE
      .word XT_REVEAL
      .word XT_COMPILE
      .word PFA_DOVARIABLE
      .word XT_ZERO
      .word XT_RAMCOMMA
      .word XT_LBRACKET
      .word XT_FLASHDOTFLUSH
.if WANT_TRANSPILER == YES
      .word XT_TPILE_END
.endif
      .word XT_EXIT 
END VARIABLE
