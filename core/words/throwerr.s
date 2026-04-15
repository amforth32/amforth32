# SPDX-License-Identifier: GPL-3.0-only

.print "INFO: using THROWERR"		

.macro THROWERR, ERRSYM, ERRNUM, ERRSTRING
    .equ \ERRSYM , \ERRNUM
.if WANT_THROWTXT == YES    
    .p2align 2,0x55
.if \ERRNUM == -1
    .word 0
.else
    .word 90b
.endif    
90: .word \ERRNUM
    .byte 8f - 7f
7:  .ascii "\ERRSTRING"
8:  .p2align 2,0xaa
.endif
.endm

# EXCEPTION CODES

# Standard Exceptions
# https://forth-standard.org/standard/exception (Table 9.1)
_THROWERR_start:
THROWERR EABRT,    -1	, "ABORT"
THROWERR EABRTQ,   -2	, "ABORT\x22"
THROWERR EDSOVR,   -3	, "stack overflow"
THROWERR EDSUND,   -4	, "stack underflow"
THROWERR ERSOVR,   -5	, "return stack overflow"
THROWERR ERSUND,   -6	, "return stack underflow"
THROWERR ELOOPD,   -7	, "do-loops nested too deeply during execution"
THROWERR EDCOVR,   -8	, "dictionary overflow"
THROWERR EADRINV,  -9	, "invalid memory address"
THROWERR EDIVZ,    -10	, "division by zero"
THROWERR ERANGE,   -11	, "result out of range"
THROWERR EARGT,    -12	, "argument type mismatch"
THROWERR EUNDEF,   -13	, "undefined word"
THROWERR ECOMPO,   -14	, "interpreting a compile-only word"
THROWERR EFRGET,   -15	, "invalid FORGET"
THROWERR ENMEMP,   -16	, "attempt to use zero-length string as a name"
THROWERR ENUMOVR,  -17	, "pictured numeric output string overflow"
THROWERR EPAROVR,  -18	, "parsed string overflow"
THROWERR ENMLONG,  -19	, "definition name too long"
THROWERR EROWRT,   -20	, "write to a read-only location"
THROWERR EUNSUP,   -21	, "unsupported operation"
THROWERR ECTRL,    -22	, "control structure mismatch"
THROWERR EALIGN,   -23	, "address alignment exception"
THROWERR EARGN,    -24	, "invalid numeric argument"
THROWERR ERSIMB,   -25	, "return stack imbalance"
THROWERR ELOOPP,   -26	, "loop parameters unavailable"
THROWERR ERECUR,   -27	, "invalid recursion"
THROWERR EUINTR,   -28	, "user interrupt"
THROWERR ECOMPN,   -29	, "compiler nesting"
THROWERR EOBSOL,   -30	, "obsolescent feature"
THROWERR EBODY,    -31	, ">BODY used on non-CREATEd definition"
THROWERR ENMINV,   -32	, "invalid name argument (e.g., TO name)"

THROWERR EWLDEL,   -47	, "compilation word list deleted"
THROWERR EPOSTP,   -48	, "invalid POSTPONE"
THROWERR ESOOVL,   -49	, "search-order overflow"
THROWERR ESOUND,   -50	, "search-order underflow"
THROWERR EWLCHG,   -51	, "compilation word list changed"
THROWERR ECSOVR,   -52	, "control-flow stack overflow"
THROWERR EESOVR,   -53	, "exception stack overflow"

# # AmForth32 Exceptions
THROWERR EFCACHE,  -256 , "flash.cache is misaligned"
THROWERR EFCELLA,  -257 , "attempt to allot outside flash.cell"
THROWERR EFWADDR,  -258 , "attempt to write below flash limit"
THROWERR ENFAZ,    -259 , "NFA is not found"
THROWERR ENFANN,   -260 , "NFA is from NONAME or HEADLESS"
THROWERR EALIALI,  -261 , "attempt to alias an alias"

.if WANT_THROWTXT == YES    

CONSTANT "err-wordlist" , ERR_WORDLIST , 90b

# ----------------------------------------------------------------------
NONAME "(err?)", LPARENERRQRPAREN 
	.word XT_TO_R
	.word XT_R_FETCH
	.word XT_FETCH
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,LPARENERRQRPAREN_0001 /* if */
	.word XT_R_FETCH
	.word XT_CELLPLUS
	.word XT_COUNT
	.word XT_FALSE
	.word XT_DOBRANCH,LPARENERRQRPAREN_0002
LPARENERRQRPAREN_0001: /* else */
	.word XT_R_FETCH
	.word XT_CELLMINUS
	.word XT_FETCH
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,LPARENERRQRPAREN_0003 /* if */
	STRING "err# not known"
	.word XT_FALSE
	.word XT_DOBRANCH,LPARENERRQRPAREN_0004
LPARENERRQRPAREN_0003: /* else */
	.word XT_TRUE
LPARENERRQRPAREN_0004: /* then */
LPARENERRQRPAREN_0002: /* then */
	.word XT_RDROP
	.word XT_EXIT
END LPARENERRQRPAREN
# ----------------------------------------------------------------------
COLON "err?", ERRQ /* ( n -- c-addr u ) search err-wordlist for err num = n and return error string  */
	.word XT_DOXLITERAL
	.word XT_LPARENERRQRPAREN
	.word XT_ERR_WORDLIST
	.word XT_TRAVERSEWORDLIST
	.word XT_ROT
	.word XT_DROP
	.word XT_EXIT
END ERRQ
# ----------------------------------------------------------------------

.endif 
_THROWERR_finish:
.equ _THROWERR_size , _THROWERR_finish - _THROWERR_start


