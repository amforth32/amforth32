#======================================================================
#======================================================================
# transpiling xt2string.f on 2026/03/13 19:41:45
# \ # SPDX-License-Identifier: GPL-3.0-only
# 
# : xt>string \# ( xt c-addr u ) leave string associated with name of xt
# {
# /*
# xt>string always returns a valid string. If xt>nfa leaves a zero NFA
# (indicating a failure to find a valid NFA ) then xt>string leaves
# "" Similarly, if a valid NFA is found and the dictionary backcheck
# fails then "" is again left. If xt>nfa indicates that a NONAME or
# HEADLESS word was found, this is compile-time optionally checked against
# a select list of NONAME and HEADLESS words and their name returned if
# found or "nn|hl" if not
# */
# }
#     dup flash.low dp.ram.max within invert if
#         drop s" " exit
#     then
# 
#     >r r@ xt>nfa 0= if s" " rdrop exit then
# 
#     r@ xt>nfa dup @ 3 <> if
#         dup count find-xt if drop count else drop s" " rdrop exit then
#     else
#         drop
#         { .ifnb  YES }
#         r@ case
#            symbol XT_DOBRANCH      of s" (branch)" endof
#            symbol XT_DOCONDBRANCH  of s" (?branch)" endof
#            symbol XT_LMARK         of s" <mark" endof
#            symbol XT_GMARK         of s" mark>" endof
#            symbol XT_LRESOLVE      of s" <resolve" endof
#            symbol XT_GRESOLVE      of s" resolve>" endof
#            symbol XT_DOTO          of s" (to)" endof
#            symbol XT_FLASHDOTFLUSH of s" flash.flush" endof
#            symbol XT_DOLITERAL     of s" (literal)" endof
#            symbol XT_DOXLITERAL    of s" (xliteral)" endof
#            symbol XT_DODO          of s" (do)" endof
#            symbol XT_DOLOOP        of s" (loop)" endof
#            symbol XT_DOPLUSLOOP    of s" (+loop)" endof
#            drop s" nn|hl" false
#        endcase
#        { .else }
#        s" nn|hl"
#        { .endif }
#    then
#    rdrop
# ;
# 

# ----------------------------------------------------------------------
COLON "xt>string", XT2STRING /* ( xt -- c-addr u ) leave string associated with name of xt */
/*
xt>string always returns a valid string. If xt>nfa leaves a zero NFA
(indicating a failure to find a valid NFA ) then xt>string leaves
"" Similarly, if a valid NFA is found and the dictionary backcheck
fails then "" is again left. If xt>nfa indicates that a NONAME or
HEADLESS word was found, this is compile-time optionally checked against
a select list of NONAME and HEADLESS words and their name returned if
found or "nn|hl" if not
*/
	.word XT_DUP
	.word XT_FLASH_LOW
	.word XT_DP_RAM_MAX
	.word XT_WITHIN
	.word XT_INVERT
	.word XT_DOCONDBRANCH,XT2STRING_0001 /* if */
	.word XT_DROP
	STRING ""
	.word XT_FINISH
XT2STRING_0001: /* then */
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_XT2NFA
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0002 /* if */
	STRING ""
	.word XT_RDROP
	.word XT_FINISH
XT2STRING_0002: /* then */
	.word XT_R_FETCH
	.word XT_XT2NFA
	.word XT_DUP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 3
	.word XT_NOTEQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0003 /* if */
	.word XT_DUP
	.word XT_COUNT
	.word XT_FINDXT
	.word XT_DOCONDBRANCH,XT2STRING_0004 /* if */
	.word XT_DROP
	.word XT_COUNT
	.word XT_DOBRANCH,XT2STRING_0005
XT2STRING_0004: /* else */
	.word XT_DROP
	STRING ""
	.word XT_RDROP
	.word XT_FINISH
XT2STRING_0005: /* then */
	.word XT_DOBRANCH,XT2STRING_0006
XT2STRING_0003: /* else */
	.word XT_DROP
.ifnb YES
	.word XT_R_FETCH
	.word XT_DOLITERAL
	.word XT_DOBRANCH
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0007 /* if */
	.word XT_DROP
	STRING "(branch)"
	.word XT_DOBRANCH,XT2STRING_0008
XT2STRING_0007: /* else */
	.word XT_DOLITERAL
	.word XT_DOCONDBRANCH
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0009 /* if */
	.word XT_DROP
	STRING "(?branch)"
	.word XT_DOBRANCH,XT2STRING_000A
XT2STRING_0009: /* else */
	.word XT_DOLITERAL
	.word XT_LMARK
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_000B /* if */
	.word XT_DROP
	STRING "<mark"
	.word XT_DOBRANCH,XT2STRING_000C
XT2STRING_000B: /* else */
	.word XT_DOLITERAL
	.word XT_GMARK
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_000D /* if */
	.word XT_DROP
	STRING "mark>"
	.word XT_DOBRANCH,XT2STRING_000E
XT2STRING_000D: /* else */
	.word XT_DOLITERAL
	.word XT_LRESOLVE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_000F /* if */
	.word XT_DROP
	STRING "<resolve"
	.word XT_DOBRANCH,XT2STRING_0010
XT2STRING_000F: /* else */
	.word XT_DOLITERAL
	.word XT_GRESOLVE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0011 /* if */
	.word XT_DROP
	STRING "resolve>"
	.word XT_DOBRANCH,XT2STRING_0012
XT2STRING_0011: /* else */
	.word XT_DOLITERAL
	.word XT_DOTO
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0013 /* if */
	.word XT_DROP
	STRING "(to)"
	.word XT_DOBRANCH,XT2STRING_0014
XT2STRING_0013: /* else */
	.word XT_DOLITERAL
	.word XT_FLASHDOTFLUSH
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0015 /* if */
	.word XT_DROP
	STRING "flash.flush"
	.word XT_DOBRANCH,XT2STRING_0016
XT2STRING_0015: /* else */
	.word XT_DOLITERAL
	.word XT_DOLITERAL
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0017 /* if */
	.word XT_DROP
	STRING "(literal)"
	.word XT_DOBRANCH,XT2STRING_0018
XT2STRING_0017: /* else */
	.word XT_DOLITERAL
	.word XT_DOXLITERAL
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_0019 /* if */
	.word XT_DROP
	STRING "(xliteral)"
	.word XT_DOBRANCH,XT2STRING_001A
XT2STRING_0019: /* else */
	.word XT_DOLITERAL
	.word XT_DODO
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_001B /* if */
	.word XT_DROP
	STRING "(do)"
	.word XT_DOBRANCH,XT2STRING_001C
XT2STRING_001B: /* else */
	.word XT_DOLITERAL
	.word XT_DOLOOP
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_001D /* if */
	.word XT_DROP
	STRING "(loop)"
	.word XT_DOBRANCH,XT2STRING_001E
XT2STRING_001D: /* else */
	.word XT_DOLITERAL
	.word XT_DOPLUSLOOP
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2STRING_001F /* if */
	.word XT_DROP
	STRING "(+loop)"
	.word XT_DOBRANCH,XT2STRING_0020
XT2STRING_001F: /* else */
	.word XT_DROP
	STRING "nn|hl"
	.word XT_FALSE
	.word XT_DROP
XT2STRING_0020: /* then */
XT2STRING_001E: /* then */
XT2STRING_001C: /* then */
XT2STRING_001A: /* then */
XT2STRING_0018: /* then */
XT2STRING_0016: /* then */
XT2STRING_0014: /* then */
XT2STRING_0012: /* then */
XT2STRING_0010: /* then */
XT2STRING_000E: /* then */
XT2STRING_000C: /* then */
XT2STRING_000A: /* then */
XT2STRING_0008: /* then */
.else
	STRING "nn|hl"
.endif
XT2STRING_0006: /* then */
	.word XT_RDROP
	.word XT_EXIT
END XT2STRING
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
