#======================================================================
#======================================================================
# transpiling dictopt-newb.f on 2026/03/13 19:41:17
# \ SPDX-License-Identifier: GPL-3.0-only
# 
# : xt>nfa \# ( xt -- nfa | 0 )  Given XT find NFA , 0 if not found, [NFA]==3 if NONAME|HEADLESS
# 
#     \ move cell by cell towards lower address until first byte of current
#     \ cell + address of cell is equal to the xt (which is an address)
#     \ first subtract padding bytes from XT
# 
#     { .if RA_FLASH == YES }
#     \ skip zero cells between XT and potential NFA leaving xt
#     \ one cell above the first non-zero cell found
#     begin
#         dup symbol XT_NOP u< if
#             drop 0 exit
#         else
#             cell- dup
#         then
#     @ 0<> until cell+
#     { .endif }
# 
#     dup 1- begin dup c@ $AA = while 1- repeat ( xt xt1 )
# 
#     swap cell- #64 0 do ( xt1 a ) \ don't go more than 256 bytes back
# 
#         \ don't go below NFA of NOP
#         dup symbol XT_NOP cell- u< if 2drop 0 unloop exit then
# 
#         dup c@ ( xt1 a n )
#         over + 2 pick ( xt1 a xt2 xt1 )
#         = if ( xt1 a )
#             nip unloop exit
#         then
#         cell-
#     loop ( xt1 a )
#     2drop 0
# ;
# 
# 
# : nfa>xt \# ( nfa -- xt ) Given NFA find XT
#     count + aligned
# 
# { .if RA_FLASH == YES }
#     \ move to higher address a where [a] <> 0
#     begin dup cell+ swap @ 0<> until cell-
# { .endif }
# 
# ;
# 
# : ?nfa \# ( nfa -- nfa ) nfa when nfa!=0 and [nfa]!=3
#     ?dup if
#         dup @ 3 = if drop symbol ENFANN throw then
#     else
#         symbol ENFAZ throw
#     then
# ;
# 
# : ffa2cfa \# ( ffa -- xt ) Given FFA find XT
#     cell+ nfa>xt
# ;
# 
# : nfa>string \# ( nfa -- c-addr u ) Given NFA leave c-addr u string
#     count
# ;
# 
# : lfa>ffa \# ( lfa -- ffa ) Given LFA find FFA
#     cell+
# ;
# 
# : ffa>lfa \# ( ffa -- lfa ) Given FFA find LFA
#     cell-
# ;
# 
# : ffa>nfa \# ( ffa -- nfa ) Given FFA find NFA
#     cell+
# ;
# 
# : xt>ffa \# ( xt -- ffa ) Given XT find FFA
#     xt>nfa ?nfa cell-
# ;
# 
# : ffa>string \# ( ffa -- caddr u ) Given FFA leave c-addr u string
#     cell+ count #255 and
# ;
# 
# : xt>lfa \# ( xt -- lfa ) Given XT find LFA
#     xt>nfa ?nfa cell- cell-
# ;
# 

# ----------------------------------------------------------------------
COLON "xt>nfa", XT2NFA /* ( xt -- nfa | 0 )  Given XT find NFA , 0 if not found, [NFA]==3 if NONAME|HEADLESS  */
.if RA_FLASH == YES
XT2NFA_0001: /* begin */
	.word XT_DUP
	.word XT_DOLITERAL
	.word XT_NOP
	.word XT_ULESS
	.word XT_DOCONDBRANCH,XT2NFA_0002 /* if */
	.word XT_DROP
	.word XT_ZERO
	.word XT_FINISH
	.word XT_DOBRANCH,XT2NFA_0003
XT2NFA_0002: /* else */
	.word XT_CELLMINUS
	.word XT_DUP
XT2NFA_0003: /* then */
	.word XT_FETCH
	.word XT_NOTZEROEQUAL
	.word XT_DOCONDBRANCH,XT2NFA_0001 /* until */
	.word XT_CELLPLUS
.endif
	.word XT_DUP
	.word XT_1MINUS
XT2NFA_0004: /* begin */
	.word XT_DUP
	.word XT_CFETCH
	.word XT_DOLITERAL
	.word 0xaa
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2NFA_0005 /* while */
	.word XT_1MINUS
	.word XT_DOBRANCH,XT2NFA_0004 /* repeat */
XT2NFA_0005:
	.word XT_SWAP
	.word XT_CELLMINUS
	.word XT_DOLITERAL
	.word 64
	.word XT_ZERO
	.word XT_DODO
XT2NFA_0007: /* do */
	.word XT_DUP
	.word XT_DOLITERAL
	.word XT_NOP
	.word XT_CELLMINUS
	.word XT_ULESS
	.word XT_DOCONDBRANCH,XT2NFA_0008 /* if */
	.word XT_2DROP
	.word XT_ZERO
	.word XT_UNLOOP
	.word XT_FINISH
XT2NFA_0008: /* then */
	.word XT_DUP
	.word XT_CFETCH
	.word XT_OVER
	.word XT_PLUS
	.word XT_TWO
	.word XT_PICK
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,XT2NFA_0009 /* if */
	.word XT_NIP
	.word XT_UNLOOP
	.word XT_FINISH
XT2NFA_0009: /* then */
	.word XT_CELLMINUS
	.word XT_DOLOOP,XT2NFA_0007 /* loop */
XT2NFA_0006: /* (for ?do IF required) */
	.word XT_2DROP
	.word XT_ZERO
	.word XT_EXIT
END XT2NFA
# ----------------------------------------------------------------------
COLON "nfa>xt", NFA2XT /* ( nfa -- xt ) Given NFA find XT */
	.word XT_COUNT
	.word XT_PLUS
	.word XT_ALIGNED
.if RA_FLASH == YES
NFA2XT_0001: /* begin */
	.word XT_DUP
	.word XT_CELLPLUS
	.word XT_SWAP
	.word XT_FETCH
	.word XT_NOTZEROEQUAL
	.word XT_DOCONDBRANCH,NFA2XT_0001 /* until */
	.word XT_CELLMINUS
.endif
	.word XT_EXIT
END NFA2XT
# ----------------------------------------------------------------------
COLON "?nfa", QNFA /* ( nfa -- nfa ) nfa when nfa!=0 and [nfa]!=3 */
	.word XT_QDUP
	.word XT_DOCONDBRANCH,QNFA_0001 /* if */
	.word XT_DUP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 3
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,QNFA_0002 /* if */
	.word XT_DROP
	.word XT_DOLITERAL
	.word ENFANN
	.word XT_THROW
QNFA_0002: /* then */
	.word XT_DOBRANCH,QNFA_0003
QNFA_0001: /* else */
	.word XT_DOLITERAL
	.word ENFAZ
	.word XT_THROW
QNFA_0003: /* then */
	.word XT_EXIT
END QNFA
# ----------------------------------------------------------------------
COLON "ffa2cfa", FFA2CFA /* ( ffa -- xt ) Given FFA find XT */
	.word XT_CELLPLUS
	.word XT_NFA2XT
	.word XT_EXIT
END FFA2CFA
# ----------------------------------------------------------------------
COLON "nfa>string", NFA2STRING /* ( nfa -- c-addr u ) Given NFA leave c-addr u string  */
	.word XT_COUNT
	.word XT_EXIT
END NFA2STRING
# ----------------------------------------------------------------------
COLON "lfa>ffa", LFA2FFA /* ( lfa -- ffa ) Given LFA find FFA */
	.word XT_CELLPLUS
	.word XT_EXIT
END LFA2FFA
# ----------------------------------------------------------------------
COLON "ffa>lfa", FFA2LFA /* ( ffa -- lfa ) Given FFA find LFA */
	.word XT_CELLMINUS
	.word XT_EXIT
END FFA2LFA
# ----------------------------------------------------------------------
COLON "ffa>nfa", FFA2NFA /* ( ffa -- nfa ) Given FFA find NFA */
	.word XT_CELLPLUS
	.word XT_EXIT
END FFA2NFA
# ----------------------------------------------------------------------
COLON "xt>ffa", XT2FFA /* ( xt -- ffa ) Given XT find FFA */
	.word XT_XT2NFA
	.word XT_QNFA
	.word XT_CELLMINUS
	.word XT_EXIT
END XT2FFA
# ----------------------------------------------------------------------
COLON "ffa>string", FFA2STRING /* ( ffa -- caddr u ) Given FFA leave c-addr u string */
	.word XT_CELLPLUS
	.word XT_COUNT
	.word XT_DOLITERAL
	.word 255
	.word XT_AND
	.word XT_EXIT
END FFA2STRING
# ----------------------------------------------------------------------
COLON "xt>lfa", XT2LFA /* ( xt -- lfa ) Given XT find LFA */
	.word XT_XT2NFA
	.word XT_QNFA
	.word XT_CELLMINUS
	.word XT_CELLMINUS
	.word XT_EXIT
END XT2LFA
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
