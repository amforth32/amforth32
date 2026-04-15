/*
# SPDX-License-Identifier: GPL-3.0-only
# SEE (Version 2) , does not disassemble CODEWORDS 
# ----------------------------------------------------------------------
*/
NONAME "bip", BIP 
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_DP0DOTRAM
	.word XT_LESS
	.word XT_DOCONDBRANCH,BIP_0001 /* if */
	.word XT_R_FETCH
	.word XT_FLASH_CELL
	.word XT_MOD
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,BIP_0002 /* if */
	.word XT_DOLITERAL /* # [char] */
	.word 46 /* . */
	.word XT_EMIT
	.word XT_SPACE
	.word XT_DOBRANCH,BIP_0003
BIP_0002: /* else */
	.word XT_SPACE
	.word XT_SPACE
BIP_0003: /* then */
	.word XT_DOBRANCH,BIP_0004
BIP_0001: /* else */
	.word XT_DOLITERAL /* # [char] */
	.word 114 /* r */
	.word XT_EMIT
	.word XT_SPACE
BIP_0004: /* then */
	.word XT_RDROP
	.word XT_EXIT
END BIP
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.flags", SEEDOTFLAGS /* ( n -- c-addr u ) leave string indicating FFA flag */
	.word XT_DOLITERAL
	.word 0xffff
	.word XT_AND
	.word XT_FLAGDOTINIT
	.word XT_INVERT
	.word XT_AND
	.word XT_FLAGDOTCODE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SEEDOTFLAGS_0001 /* if */
	.word XT_DROP
	STRING " codword"
	.word XT_DOBRANCH,SEEDOTFLAGS_0002
SEEDOTFLAGS_0001: /* else */
	.word XT_FLAGDOTVAR
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SEEDOTFLAGS_0003 /* if */
	.word XT_DROP
	STRING " variable"
	.word XT_DOBRANCH,SEEDOTFLAGS_0004
SEEDOTFLAGS_0003: /* else */
	.word XT_FLAGDOTDVAR
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SEEDOTFLAGS_0005 /* if */
	.word XT_DROP
	STRING " dvariable"
	.word XT_DOBRANCH,SEEDOTFLAGS_0006
SEEDOTFLAGS_0005: /* else */
	.word XT_FLAGDOTCOLON
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SEEDOTFLAGS_0007 /* if */
	.word XT_DROP
	STRING " colon"
	.word XT_DOBRANCH,SEEDOTFLAGS_0008
SEEDOTFLAGS_0007: /* else */
	.word XT_FLAGDOTCON
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SEEDOTFLAGS_0009 /* if */
	.word XT_DROP
	STRING " constant"
	.word XT_DOBRANCH,SEEDOTFLAGS_000A
SEEDOTFLAGS_0009: /* else */
	.word XT_FLAGDOTIMMED
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SEEDOTFLAGS_000B /* if */
	.word XT_DROP
	STRING " immediate"
	.word XT_DOBRANCH,SEEDOTFLAGS_000C
SEEDOTFLAGS_000B: /* else */
	.word XT_FLAGDOTVALUE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SEEDOTFLAGS_000D /* if */
	.word XT_DROP
	STRING " value"
	.word XT_DOBRANCH,SEEDOTFLAGS_000E
SEEDOTFLAGS_000D: /* else */
	.word XT_FLAGDOTDEFER
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SEEDOTFLAGS_000F /* if */
	.word XT_DROP
	STRING " defer"
	.word XT_DOBRANCH,SEEDOTFLAGS_0010
SEEDOTFLAGS_000F: /* else */
	.word XT_FLAGDOTPVALUE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SEEDOTFLAGS_0011 /* if */
	.word XT_DROP
	STRING " pvalue"
	.word XT_DOBRANCH,SEEDOTFLAGS_0012
SEEDOTFLAGS_0011: /* else */
	.word XT_FLAGDOTCHILD
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,SEEDOTFLAGS_0013 /* if */
	.word XT_DROP
	STRING " child"
	.word XT_DOBRANCH,SEEDOTFLAGS_0014
SEEDOTFLAGS_0013: /* else */
	.word XT_DROP
	STRING " unknown"
	.word XT_FALSE
	.word XT_DROP
SEEDOTFLAGS_0014: /* then */
SEEDOTFLAGS_0012: /* then */
SEEDOTFLAGS_0010: /* then */
SEEDOTFLAGS_000E: /* then */
SEEDOTFLAGS_000C: /* then */
SEEDOTFLAGS_000A: /* then */
SEEDOTFLAGS_0008: /* then */
SEEDOTFLAGS_0006: /* then */
SEEDOTFLAGS_0004: /* then */
SEEDOTFLAGS_0002: /* then */
	.word XT_EXIT
END SEEDOTFLAGS
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.header", SEEDOTHEADER 
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_XT2LFA
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_DUP
	.word XT_BIP
	.word XT_FETCH
	.word XT_HEXDOT
	STRING "LFA"
	.word XT_TYPE
	.word XT_CR
	.word XT_R_FETCH
	.word XT_XT2FFA
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_DUP
	.word XT_BIP
	.word XT_FETCH
	.word XT_DUP
	.word XT_HEXDOT
	STRING "FFA"
	.word XT_TYPE
	.word XT_SEEDOTFLAGS
	.word XT_TYPE
	.word XT_CR
	.word XT_R_FETCH
	.word XT_XT2NFA
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_DUP
	.word XT_BIP
	.word XT_FETCH
	.word XT_HEXDOT
	STRING "NFA >> "
	.word XT_TYPE
	.word XT_R_FETCH
	.word XT_XT2STRING
	.word XT_TYPE
	STRING " <<"
	.word XT_TYPE
	.word XT_CR
	.word XT_R_FETCH
	.word XT_DUP
	.word XT_XT2NFA
	.word XT_CELLPLUS
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SEEDOTHEADER_0001 /* ?do */
	.word XT_DODO
SEEDOTHEADER_0002: /* do */
	.word XT_I
	.word XT_HEXDOT
	.word XT_I
	.word XT_FETCH
	.word XT_I
	.word XT_BIP
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,SEEDOTHEADER_0003 /* if */
	STRING ".z."
	.word XT_DOBRANCH,SEEDOTHEADER_0004
SEEDOTHEADER_0003: /* else */
	STRING "..."
SEEDOTHEADER_0004: /* then */
	.word XT_TYPE
	.word XT_CR
	.word XT_CELL
	.word XT_DOPLUSLOOP,SEEDOTHEADER_0002 /* +loop */
SEEDOTHEADER_0001: /* (for ?do IF required) */
	.word XT_RDROP
	.word XT_EXIT
END SEEDOTHEADER
# ----------------------------------------------------------------------
NOVAR "see.xt",SEEDOTXT
END SEEDOTXT
NOVAR "see.lfa",SEEDOTLFA
END SEEDOTLFA
NOVAR "see.ip",SEEDOTIP
END SEEDOTIP
NOVAR "see.done?",SEEDOTDONEQ
END SEEDOTDONEQ
# ----------------------------------------------------------------------
NONAME "see.ip++", SEEDOTIPPLUSPLUS 
	.word XT_CELL
	.word XT_SEEDOTIP
	.word XT_PLUSSTORE
	.word XT_EXIT
END SEEDOTIPPLUSPLUS
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.line", SEEDOTLINE 
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_BIP
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_HEXDOT
	.word XT_EXIT
END SEEDOTLINE
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.do.exit", SEEDOTDODOTEXIT 
	.word XT_SEEDOTLINE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_XT2STRING
	.word XT_TYPE
	.word XT_SPACE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_SEEDOTXT
	.word XT_FETCH
	.word XT_XT2LFA
	.word XT_MINUS
	.word XT_CELL
	.word XT_PLUS
	.word XT_UDOT
	STRING "bytes"
	.word XT_TYPE
	.word XT_CR
	.word XT_TRUE
	.word XT_SEEDOTDONEQ
	.word XT_STORE
	.word XT_EXIT
END SEEDOTDODOTEXIT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.do.child.exit", SEEDOTDODOTCHILDDOTEXIT 
	.word XT_SEEDOTLINE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_XT2STRING
	.word XT_TYPE
	.word XT_SPACE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_SEEDOTXT
	.word XT_FETCH
	.word XT_MINUS
	.word XT_CELL
	.word XT_PLUS
	.word XT_UDOT
	STRING "bytes"
	.word XT_TYPE
	.word XT_CR
	.word XT_TRUE
	.word XT_SEEDOTDONEQ
	.word XT_STORE
	.word XT_EXIT
END SEEDOTDODOTCHILDDOTEXIT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.any?", SEEDOTANYQ 
	.word XT_DROP
	.word XT_TRUE
	.word XT_EXIT
END SEEDOTANYQ
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.do.slit", SEEDOTDODOTSLIT 
	.word XT_SEEDOTLINE
	STRING "(sliteral) "
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_SEEDOTLINE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_COUNT
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_CFETCH
	.word XT_1PLUS
	.word XT_ALIGNED
	.word XT_FOUR
	.word XT_SLASH
	.word XT_1MINUS
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,SEEDOTDODOTSLIT_0001 /* ?do */
	.word XT_DODO
SEEDOTDODOTSLIT_0002: /* do */
	.word XT_SEEDOTLINE
	STRING "..."
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_DOLOOP,SEEDOTDODOTSLIT_0002 /* loop */
SEEDOTDODOTSLIT_0001: /* (for ?do IF required) */
	.word XT_EXIT
END SEEDOTDODOTSLIT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.do.xt", SEEDOTDODOTXT 
	.word XT_SEEDOTLINE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_DUP
	.word XT_ALIGNED
	.word XT_NOTEQUAL
	.word XT_DOCONDBRANCH,SEEDOTDODOTXT_0001 /* if */
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_FINISH
SEEDOTDODOTXT_0001: /* then */
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_DP_RAM
	.word XT_DP
	.word XT_MAX
	.word XT_ULESS
	.word XT_DOCONDBRANCH,SEEDOTDODOTXT_0002 /* if */
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_XT2STRING
	.word XT_TYPE
SEEDOTDODOTXT_0002: /* then */
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_EXIT
END SEEDOTDODOTXT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.do.next", SEEDOTDODOTNEXT 
	.word XT_SEEDOTLINE
	STRING "NEXT "
	.word XT_TYPE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_SEEDOTLFA
	.word XT_FETCH
	.word XT_MINUS
	.word XT_CELL
	.word XT_PLUS
	.word XT_UDOT
	STRING "bytes"
	.word XT_TYPE
	.word XT_CR
	.word XT_TRUE
	.word XT_SEEDOTDONEQ
	.word XT_STORE
	.word XT_EXIT
END SEEDOTDODOTNEXT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.do.colon", SEEDOTDODOTCOLON 
	.word XT_SEEDOTLINE
	STRING "COLON"
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_EXIT
END SEEDOTDODOTCOLON
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.do.child", SEEDOTDODOTCHILD 
	.word XT_SEEDOTLINE
	STRING "CHILD"
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_EXIT
END SEEDOTDODOTCHILD
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.colon", SEEDOTCOLON /* ( xt -- )  */
	.word XT_DUP
	.word XT_SEEDOTIP
	.word XT_STORE
	.word XT_SEEDOTXT
	.word XT_STORE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_SEEDOTHEADER
	.word XT_FALSE
	.word XT_SEEDOTDONEQ
	.word XT_STORE
	.word XT_SEEDOTDODOTCOLON
SEEDOTCOLON_0001: /* begin */
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_DOXLITERAL
	.word XT_SLITERALQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCOLON_0002 /* if */
	.word XT_DROP
	.word XT_SEEDOTDODOTSLIT
	.word XT_DOBRANCH,SEEDOTCOLON_0003
SEEDOTCOLON_0002: /* else */
	.word XT_DOXLITERAL
	.word XT_EXITQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCOLON_0004 /* if */
	.word XT_DROP
	.word XT_SEEDOTDODOTEXIT
	.word XT_DOBRANCH,SEEDOTCOLON_0005
SEEDOTCOLON_0004: /* else */
	.word XT_DOXLITERAL
	.word XT_SEEDOTANYQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCOLON_0006 /* if */
	.word XT_DROP
	.word XT_SEEDOTDODOTXT
	.word XT_DOBRANCH,SEEDOTCOLON_0007
SEEDOTCOLON_0006: /* else */
	.word XT_DROP
SEEDOTCOLON_0007: /* then */
SEEDOTCOLON_0005: /* then */
SEEDOTCOLON_0003: /* then */
	.word XT_SEEDOTDONEQ
	.word XT_FETCH
	.word XT_DOCONDBRANCH,SEEDOTCOLON_0001 /* until */
	.word XT_EXIT
END SEEDOTCOLON
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.child", SEEDOTCHILD /* ( xt -- ) */
	.word XT_DUP
	.word XT_SEEDOTIP
	.word XT_STORE
	.word XT_SEEDOTXT
	.word XT_STORE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_SEEDOTHEADER
	.word XT_FALSE
	.word XT_SEEDOTDONEQ
	.word XT_STORE
	.word XT_SEEDOTDODOTCHILD
SEEDOTCHILD_0001: /* begin */
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_DOXLITERAL
	.word XT_EXITQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCHILD_0002 /* if */
	.word XT_DROP
	.word XT_SEEDOTDODOTEXIT
	.word XT_DOBRANCH,SEEDOTCHILD_0003
SEEDOTCHILD_0002: /* else */
	.word XT_DOXLITERAL
	.word XT_SEEDOTANYQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCHILD_0004 /* if */
	.word XT_DROP
	.word XT_SEEDOTLINE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_DOBRANCH,SEEDOTCHILD_0005
SEEDOTCHILD_0004: /* else */
	.word XT_DROP
SEEDOTCHILD_0005: /* then */
SEEDOTCHILD_0003: /* then */
	.word XT_SEEDOTDONEQ
	.word XT_FETCH
	.word XT_DOCONDBRANCH,SEEDOTCHILD_0001 /* until */
	STRING "--------   --------"
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTXT
	.word XT_FETCH
	.word XT_FETCH
	.word XT_DUP
	.word XT_TWO
	.word XT_MOD
	.word XT_NOTZEROEQUAL
	.word XT_DOCONDBRANCH,SEEDOTCHILD_0006 /* if */
	.word XT_1MINUS
SEEDOTCHILD_0006: /* then */
	.word XT_CELLPLUS
	.word XT_CELLPLUS
	.word XT_DUP
	.word XT_SEEDOTIP
	.word XT_STORE
	.word XT_SEEDOTXT
	.word XT_STORE
	.word XT_FALSE
	.word XT_SEEDOTDONEQ
	.word XT_STORE
SEEDOTCHILD_0007: /* begin */
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_DOXLITERAL
	.word XT_SLITERALQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCHILD_0008 /* if */
	.word XT_DROP
	.word XT_SEEDOTDODOTSLIT
	.word XT_DOBRANCH,SEEDOTCHILD_0009
SEEDOTCHILD_0008: /* else */
	.word XT_DOXLITERAL
	.word XT_EXITQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCHILD_000A /* if */
	.word XT_DROP
	.word XT_SEEDOTDODOTCHILDDOTEXIT
	.word XT_DOBRANCH,SEEDOTCHILD_000B
SEEDOTCHILD_000A: /* else */
	.word XT_DOXLITERAL
	.word XT_SEEDOTANYQ
	.word XT_OVER
	.word XT_SWAP
	.word XT_EXECUTE
	.word XT_DOCONDBRANCH,SEEDOTCHILD_000C /* if */
	.word XT_DROP
	.word XT_SEEDOTDODOTXT
	.word XT_DOBRANCH,SEEDOTCHILD_000D
SEEDOTCHILD_000C: /* else */
	.word XT_DROP
SEEDOTCHILD_000D: /* then */
SEEDOTCHILD_000B: /* then */
SEEDOTCHILD_0009: /* then */
	.word XT_SEEDOTDONEQ
	.word XT_FETCH
	.word XT_DOCONDBRANCH,SEEDOTCHILD_0007 /* until */
	.word XT_EXIT
END SEEDOTCHILD
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.variable", SEEDOTVARIABLE 
	.word XT_DUP
	.word XT_SEEDOTIP
	.word XT_STORE
	.word XT_SEEDOTXT
	.word XT_STORE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_SEEDOTHEADER
	.word XT_SEEDOTLINE
	STRING "VARIABLE"
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_SEEDOTLINE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_FETCH
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_DOLITERAL /* # [char] */
	.word 35 /* # */
	.word XT_EMIT
	.word XT_DOT
	.word XT_CR
	.word XT_EXIT
END SEEDOTVARIABLE
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.value", SEEDOTVALUE 
	.word XT_DUP
	.word XT_SEEDOTIP
	.word XT_STORE
	.word XT_SEEDOTXT
	.word XT_STORE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_SEEDOTHEADER
	.word XT_SEEDOTLINE
	STRING "VALUE"
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_SEEDOTLINE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_FETCH
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_DOLITERAL /* # [char] */
	.word 35 /* # */
	.word XT_EMIT
	.word XT_DOT
	.word XT_CR
	.word XT_EXIT
END SEEDOTVALUE
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.defer", SEEDOTDEFER 
	.word XT_DUP
	.word XT_SEEDOTIP
	.word XT_STORE
	.word XT_SEEDOTXT
	.word XT_STORE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_SEEDOTHEADER
	.word XT_SEEDOTLINE
	STRING "DEFER"
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_SEEDOTLINE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_FETCH
	.word XT_DUP
	.word XT_HEXDOT
	.word XT_XT2STRING
	.word XT_TYPE
	.word XT_CR
	.word XT_EXIT
END SEEDOTDEFER
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "see.constant", SEEDOTCONSTANT 
	.word XT_DUP
	.word XT_SEEDOTIP
	.word XT_STORE
	.word XT_SEEDOTXT
	.word XT_STORE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_SEEDOTHEADER
	.word XT_SEEDOTLINE
	STRING "CONSTANT"
	.word XT_TYPE
	.word XT_CR
	.word XT_SEEDOTIPPLUSPLUS
	.word XT_SEEDOTLINE
	.word XT_SEEDOTIP
	.word XT_FETCH
	.word XT_FETCH
	.word XT_DOLITERAL /* # [char] */
	.word 35 /* # */
	.word XT_EMIT
	.word XT_DOT
	.word XT_CR
	.word XT_EXIT
END SEEDOTCONSTANT
# ----------------------------------------------------------------------
COLON "(see)", LPARENSEERPAREN /* ( xt -- ) deconstruct word from XT */
	.word XT_DUP
	.word XT_TO_R
	.word XT_XT2FFA
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 0xffff
	.word XT_AND
	.word XT_FLAGDOTINIT
	.word XT_INVERT
	.word XT_AND
	.word XT_FLAGDOTVAR
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,LPARENSEERPAREN_0001 /* if */
	.word XT_DROP
	.word XT_R_FROM
	.word XT_SEEDOTVARIABLE
	.word XT_DOBRANCH,LPARENSEERPAREN_0002
LPARENSEERPAREN_0001: /* else */
	.word XT_FLAGDOTCOLON
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,LPARENSEERPAREN_0003 /* if */
	.word XT_DROP
	.word XT_R_FROM
	.word XT_SEEDOTCOLON
	.word XT_DOBRANCH,LPARENSEERPAREN_0004
LPARENSEERPAREN_0003: /* else */
	.word XT_FLAGDOTCON
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,LPARENSEERPAREN_0005 /* if */
	.word XT_DROP
	.word XT_R_FROM
	.word XT_SEEDOTCONSTANT
	.word XT_DOBRANCH,LPARENSEERPAREN_0006
LPARENSEERPAREN_0005: /* else */
	.word XT_FLAGDOTDEFER
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,LPARENSEERPAREN_0007 /* if */
	.word XT_DROP
	.word XT_R_FROM
	.word XT_SEEDOTDEFER
	.word XT_DOBRANCH,LPARENSEERPAREN_0008
LPARENSEERPAREN_0007: /* else */
	.word XT_FLAGDOTVALUE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,LPARENSEERPAREN_0009 /* if */
	.word XT_DROP
	.word XT_R_FROM
	.word XT_SEEDOTVALUE
	.word XT_DOBRANCH,LPARENSEERPAREN_000A
LPARENSEERPAREN_0009: /* else */
	.word XT_FLAGDOTPVALUE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,LPARENSEERPAREN_000B /* if */
	.word XT_DROP
	.word XT_R_FROM
	.word XT_SEEDOTVALUE
	.word XT_DOBRANCH,LPARENSEERPAREN_000C
LPARENSEERPAREN_000B: /* else */
	.word XT_FLAGDOTIMMED
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,LPARENSEERPAREN_000D /* if */
	.word XT_DROP
	.word XT_R_FROM
	.word XT_SEEDOTCOLON
	.word XT_DOBRANCH,LPARENSEERPAREN_000E
LPARENSEERPAREN_000D: /* else */
	.word XT_FLAGDOTCHILD
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,LPARENSEERPAREN_000F /* if */
	.word XT_DROP
	.word XT_R_FROM
	.word XT_SEEDOTCHILD
	.word XT_DOBRANCH,LPARENSEERPAREN_0010
LPARENSEERPAREN_000F: /* else */
	STRING "flag type "
	.word XT_TYPE
	.word XT_DOT
	STRING "not supported "
	.word XT_TYPE
	.word XT_CR
	.word XT_FALSE
	.word XT_RDROP
	.word XT_DROP
LPARENSEERPAREN_0010: /* then */
LPARENSEERPAREN_000E: /* then */
LPARENSEERPAREN_000C: /* then */
LPARENSEERPAREN_000A: /* then */
LPARENSEERPAREN_0008: /* then */
LPARENSEERPAREN_0006: /* then */
LPARENSEERPAREN_0004: /* then */
LPARENSEERPAREN_0002: /* then */
	.word XT_EXIT
END LPARENSEERPAREN
# ----------------------------------------------------------------------
COLON "see", SEE /* ( "name" -- ) deconstruct word "name" */
	.word XT_PARSENAME
	.word XT_FINDXT
	.word XT_DOCONDBRANCH,SEE_0001 /* if */
	.word XT_LPARENSEERPAREN
	.word XT_DOBRANCH,SEE_0002
SEE_0001: /* else */
	STRING "name not found"
	.word XT_TYPE
	.word XT_CR
SEE_0002: /* then */
	.word XT_EXIT
END SEE
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
