/*
Found 3 name(s) that resolve to multiple XT symbols:
  name='1ms':
    xtname='XT_N1MS'  file='./rv/words/ms.s'
    xtname='XT_1MS'  file='./rv/mcu/ch32v307/words/ms.s'
  name='led.init':
    xtname='XT_LEDDOTINIT'  file='./rv/mcu/ch32v307/words/led.s'
    xtname='XT_LED_INIT'  file='./rv/mcu/ch32v307/words/led.s'
  name='^led':
    xtname='XT_CARETLED'  file='./rv/mcu/ch32v307/words/led.s'
    xtname='XT_TOGLED'  file='./rv/mcu/ch32v307/words/led.s'
*/
#======================================================================
#======================================================================
# transpiling lib/transpiled/backtrace.f on 2026/11/16 20:10:26
# : ?ip \# ( a -- f ) is a likely to be a valid IP address
# \# i.e. is it within the address ranges where words are compiled
#     dup flash.low memmode if dp else dp.flash then within if
#         drop true
#     else
#         dp0.ram memmode if dp.ram else dp then within
#     then
# ;
# 
# : ip2xt \# ( a -- xt u true | a false ) convert IP to the XT of its containing word, u = a - xt (in cells)
#     dup ?ip not if false exit then \# leave a as is if not an IP address
#     #100 0 do ( a ) \# don't go more than 100 cells back
#         dup colon? if ( xt )
#             i true
#             unloop exit
#         then ( a )
#         cell-
#     loop ( a )
#     false
# ;
# 
# : ip2name \# ( a -- u s true | u a false ) convert IP a to the name of its containing word, u = a - xt (in cells)
#     ip2xt if ( xt u )
#         swap dup xt>nfa ?dup if ( u xt nfa )
#             dup @ 3 = if ( u xt nfa )
#                 drop false \# noname, return xt
#             else ( u xt nfa )
#                 nip nfa>string true
#             then
#         else ( u xt ) \# nfa not found
#             false
#         then
#     else ( a ) \# xt not found
#         0 swap false
#     then
# ;
# 
# : .ip \# ( a -- ) print ip as xt+offset
#     ip2name \ ( u s true | u a false )
#     if type
#     else over if 8x. else uhex. then
#     then \ ( u )
#     ?dup if #43 emit dec. then
# ;
# 
# \ The backtrace always omits the top two frames which are .bt and the word that call it,
# \ usually debugger or execute. The skip `u` is counted from there.
# : .bt \# ( u -- ) print return stack (top first) skipping top u cells, use word names
#     rdepth over - dup 0 <= if 2drop exit then ( u depth )
#     swap cells rp@ + swap 0 ?do dup @ .ip cell+ loop
#     drop
# ;
# 
# : .rs \# ( u -- ) print return stack (top first) skipping top u cells, use raw IP addresses
#     rdepth over - dup 0 <= if 2drop exit then ( u depth )
#     swap cells rp@ + swap 0 ?do dup @ . cell+ loop
#     drop
# ;
# 
# : .itc \# ( u1 u2 -- ) dump u1 XTs starting from current IP u2 cells down the return stack
#     rdepth over - 0 <= if 2drop drop exit then
#     cells rp@ + @ ( u1 ip ) \# get the IP
#     swap 0 ?do ( ip )
#         s" |D " type dup 8x. space dup @ dup 8x. space xt>string type
#         i 0= if s"    <<(IP)<<" type then
#         cr cell+
#     loop
#     drop
# ;

# ----------------------------------------------------------------------
COLON "?ip", QIP /* ( a -- f ) is a likely to be a valid IP address */
/* i.e. is it within the address ranges where words are compiled */
	.word XT_DUP
	.word XT_FLASH_LOW
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,QIP_0001 /* if */
	.word XT_DP
	.word XT_DOBRANCH,QIP_0002
QIP_0001: /* else */
	.word XT_DP_FLASH
QIP_0002: /* then */
	.word XT_WITHIN
	.word XT_DOCONDBRANCH,QIP_0003 /* if */
	.word XT_DROP
	.word XT_TRUE
	.word XT_DOBRANCH,QIP_0004
QIP_0003: /* else */
	.word XT_DP0DOTRAM
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,QIP_0005 /* if */
	.word XT_DP_RAM
	.word XT_DOBRANCH,QIP_0006
QIP_0005: /* else */
	.word XT_DP
QIP_0006: /* then */
	.word XT_WITHIN
QIP_0004: /* then */
	.word XT_EXIT
END QIP
# ----------------------------------------------------------------------
COLON "ip2xt", IP2XT /* ( a -- xt u true | a false ) convert IP to the XT of its containing word, u = a - xt (in cells) */
	.word XT_DUP
	.word XT_QIP
	.word XT_NOT
	.word XT_DOCONDBRANCH,IP2XT_0001 /* if */
	.word XT_FALSE
	.word XT_FINISH
IP2XT_0001: /* then */
/* leave a as is if not an IP address */
	.word XT_DOLITERAL
	.word 100
	.word XT_ZERO
	.word XT_DODO
IP2XT_0003: /* do */
/* don't go more than 100 cells back */
	.word XT_DUP
	.word XT_COLONQ
	.word XT_DOCONDBRANCH,IP2XT_0004 /* if */
	.word XT_I
	.word XT_TRUE
	.word XT_UNLOOP
	.word XT_FINISH
IP2XT_0004: /* then */
	.word XT_CELLMINUS
	.word XT_DOLOOP,IP2XT_0003 /* loop */
IP2XT_0002: /* (for ?do IF required) */
	.word XT_FALSE
	.word XT_EXIT
END IP2XT
# ----------------------------------------------------------------------
COLON "ip2name", IP2NAME /* ( a -- u s true | u a false ) convert IP a to the name of its containing word, u = a - xt (in cells) */
	.word XT_IP2XT
	.word XT_DOCONDBRANCH,IP2NAME_0001 /* if */
	.word XT_SWAP
	.word XT_DUP
	.word XT_XT2NFA
	.word XT_QDUP
	.word XT_DOCONDBRANCH,IP2NAME_0002 /* if */
	.word XT_DUP
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 3
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,IP2NAME_0003 /* if */
	.word XT_DROP
	.word XT_FALSE
/* noname, return xt */
	.word XT_DOBRANCH,IP2NAME_0004
IP2NAME_0003: /* else */
	.word XT_NIP
	.word XT_NFA2STRING
	.word XT_TRUE
IP2NAME_0004: /* then */
	.word XT_DOBRANCH,IP2NAME_0005
IP2NAME_0002: /* else */
/* nfa not found */
	.word XT_FALSE
IP2NAME_0005: /* then */
	.word XT_DOBRANCH,IP2NAME_0006
IP2NAME_0001: /* else */
/* xt not found */
	.word XT_ZERO
	.word XT_SWAP
	.word XT_FALSE
IP2NAME_0006: /* then */
	.word XT_EXIT
END IP2NAME
# ----------------------------------------------------------------------
COLON ".ip", DOTIP /* ( a -- ) print ip as xt+offset */
	.word XT_IP2NAME
	.word XT_DOCONDBRANCH,DOTIP_0001 /* if */
	.word XT_TYPE
	.word XT_DOBRANCH,DOTIP_0002
DOTIP_0001: /* else */
	.word XT_OVER
	.word XT_DOCONDBRANCH,DOTIP_0003 /* if */
	.word XT_8XDOT
	.word XT_DOBRANCH,DOTIP_0004
DOTIP_0003: /* else */
	.word XT_UHEXDOT
DOTIP_0004: /* then */
DOTIP_0002: /* then */
	.word XT_QDUP
	.word XT_DOCONDBRANCH,DOTIP_0005 /* if */
	.word XT_DOLITERAL
	.word 43
	.word XT_EMIT
	.word XT_DECDOT
DOTIP_0005: /* then */
	.word XT_EXIT
END DOTIP
# ----------------------------------------------------------------------
COLON ".bt", DOTBT /* ( u -- ) print return stack (top first) skipping top u cells, use word names */
	.word XT_RDEPTH
	.word XT_OVER
	.word XT_MINUS
	.word XT_DUP
	.word XT_ZERO
	.word XT_LESSEQUAL
	.word XT_DOCONDBRANCH,DOTBT_0001 /* if */
	.word XT_2DROP
	.word XT_FINISH
DOTBT_0001: /* then */
	.word XT_SWAP
	.word XT_CELLS
	.word XT_RP_FETCH
	.word XT_PLUS
	.word XT_SWAP
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,DOTBT_0002 /* ?do */
	.word XT_DODO
DOTBT_0003: /* do */
	.word XT_DUP
	.word XT_FETCH
	.word XT_DOTIP
	.word XT_CELLPLUS
	.word XT_DOLOOP,DOTBT_0003 /* loop */
DOTBT_0002: /* (for ?do IF required) */
	.word XT_DROP
	.word XT_EXIT
END DOTBT
# ----------------------------------------------------------------------
COLON ".rs", DOTRS /* ( u -- ) print return stack (top first) skipping top u cells, use raw IP addresses */
	.word XT_RDEPTH
	.word XT_OVER
	.word XT_MINUS
	.word XT_DUP
	.word XT_ZERO
	.word XT_LESSEQUAL
	.word XT_DOCONDBRANCH,DOTRS_0001 /* if */
	.word XT_2DROP
	.word XT_FINISH
DOTRS_0001: /* then */
	.word XT_SWAP
	.word XT_CELLS
	.word XT_RP_FETCH
	.word XT_PLUS
	.word XT_SWAP
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,DOTRS_0002 /* ?do */
	.word XT_DODO
DOTRS_0003: /* do */
	.word XT_DUP
	.word XT_FETCH
	.word XT_DOT
	.word XT_CELLPLUS
	.word XT_DOLOOP,DOTRS_0003 /* loop */
DOTRS_0002: /* (for ?do IF required) */
	.word XT_DROP
	.word XT_EXIT
END DOTRS
# ----------------------------------------------------------------------
COLON ".itc", DOTITC /* ( u1 u2 -- ) dump u1 XTs starting from current IP u2 cells down the return stack */
	.word XT_RDEPTH
	.word XT_OVER
	.word XT_MINUS
	.word XT_ZERO
	.word XT_LESSEQUAL
	.word XT_DOCONDBRANCH,DOTITC_0001 /* if */
	.word XT_2DROP
	.word XT_DROP
	.word XT_FINISH
DOTITC_0001: /* then */
	.word XT_CELLS
	.word XT_RP_FETCH
	.word XT_PLUS
	.word XT_FETCH
/* get the IP */
	.word XT_SWAP
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,DOTITC_0002 /* ?do */
	.word XT_DODO
DOTITC_0003: /* do */
	STRING "|D "
	.word XT_TYPE
	.word XT_DUP
	.word XT_8XDOT
	.word XT_SPACE
	.word XT_DUP
	.word XT_FETCH
	.word XT_DUP
	.word XT_8XDOT
	.word XT_SPACE
	.word XT_XT2STRING
	.word XT_TYPE
	.word XT_I
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,DOTITC_0004 /* if */
	STRING "   <<(IP)<<"
	.word XT_TYPE
DOTITC_0004: /* then */
	.word XT_CR
	.word XT_CELLPLUS
	.word XT_DOLOOP,DOTITC_0003 /* loop */
DOTITC_0002: /* (for ?do IF required) */
	.word XT_DROP
	.word XT_EXIT
END DOTITC
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
