/*
To support debugging of colon words (which is somewhat inconvenient in GDB), the interpreter is modified to allow interrupting the normal COLON word interpretation cycle after each word. This is achieved by designating a register as a `DEBUG` register (ARM: r6, RV: s7) and checking in each cycle if its value is 0. If not it indicates the currently running debug action that is interpreted by the debugger. This adds overhead of a single test and jump instruction to the normal interpreter cycle. All other overhead is incurred only when the debugger is activated. AmForth can be rebuilt with `WANT_DEBUGGER` set to `NO` to eliminate all debugger overhead (including code).

One of the main goals was to allow writing the debugger in Forth for both convenience and portability. Consequently it is critical that the debugger word is executed normally (without further interruptions). Therefore the DEBUG register is cleared when entering the debugger word and restored when the debugger word exits (`exitd`).

To enter the debugging regime, the word `break` sets up the `DEBUG` register which causes the interpreter to be interrupted in the following cycle (before executing next word). The debugger sends debugging information back to the terminal emulator (the data stack, backtrace and a short list of XTs to be executed next). The debug info lines are prefixed with `|D ` to enable post-processing on the host side (amforth-shell uses that). After sending the info the debugger then waits for input from the operator.

Debugger interprets user input as follows:
* `c`  - continue, resume normal execution (until `break` is hit again)
* `s` - step, executes single interpreter cycle and stops again
* `n` - next, steps until the same `rstack` depth is reached again, for stepping through the current word without diving down into called words
* `r` - return, steps until the current word is fully executed and returns to the calling word
* any other input is evaluated as a Forth expression and the result is returned

Step simply leaves the DEBUG hook in place and resumes interpreter for single cycle and stops again. Continue instead clears the debug hook so the interpreter resumes normal execution until it hits the `break` word again. Next and Return step repeatedly until `rdepth` is the same (Next) or one less (Return). Executing Forth expressions leaves the debugger in control.
To indicate that debugger is in control it emits `#` as its prompt character, instead of `>` which indicates the interpreter is in control.

The DEBUG register is controlled through the USER variable `debug.next`, which determines the next debug action by being the source of value to restore into the DEBUG register when the debugger word exits. Continue sets it to 0, which means the DEBUG register will be cleared when interpreter resumes. The other actions set it to a value representing the action (lowest 2 bits) and optional argument (highest 30 bits).

`debug.break` is kind of a defer for the debugger word (but a user variable instead). It can be used to disable the debugger by setting it to 0. Words `debug+` and `debug-` do just that.

*/
# ======================================================================
# ======================================================================
# transpiling ../amforth/lib/backtrace.frt on 2026/03/16 23:15:21
# : ?ip \# ( a -- f ) is a likely to be a valid IP address
# \# i.e. is it within the address ranges where words are compiled
#     dup flash.low memmode if dp else dp.flash then within if
#         drop true
#     else
#         dp0.ram memmode if dp.ram else dp then within
#     then
# ;
# 
# \ ' ?ip @ constant docolon
# 
# : ?xt \# ( a -- f ) is a likely an XT
#     colon?
# ;
# 
# : ip2xt \# ( a -- xt u true | a false ) convert IP to the XT of its containing word, u = a - xt (in cells)
#     dup ?ip not if false exit then \# leave a as is if not an IP address
#     #100 0 do ( a ) \# don't go more than 100 cells back
#         dup ?xt if ( xt )
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
# : .bt \# ( u -- ) print return stack (top first) skipping top u cells, use word names
#     rdepth over - dup 0 <= if 2drop exit then ( u depth )
#     swap cells rp@ + swap 0 ?do ( a )
#         dup @ ip2name if
#             type
#         else over if 8x. else dbg.uh. then
#         then ( a u )
#         ?dup if #43 emit dbg.d. then ( a )
#     cell+ loop
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
# 
# \ testing words
# \ : tt ?dup if 1- recurse else 0 break then ;
# \ : fib
# \     break
# \     dup 2 <= if drop 1 exit then
# \     dup 1- recurse swap 1- 1- recurse +
# \ ;
# 
# \ debug.next[1:0] denotes the next debug action, 0 means no action
# \ debug.next[31:2] is action specific argument value
# \ debug actions
# 1 constant debug.step    \# single step, no argument
# 2 constant debug.rdepth  \# step until rdepth, argument is desired rdepth
# 
# : debugger \# ( -- ) implements debug actions
#     debug.next @ 2 and if \# is next action step until rdepth ?
#         debug.next @ 2 rshift rdepth < if
#             (exitd) \# rdepth is more than desired, keep going
#         then
#     then
#     \# emit stack state
#     s" |D PS: " type .s cr
#     s" |D RS: " type 1 .bt cr
#     5 1 .itc .ok .ready.debugger
#     begin
#         \# receive input from user
#         debug_buf dup refill-buf-size accept cr \# ( s )
#         \# (c)ontinue - resume normal execution
#         2dup s" c" compare not if 2drop
#             0 debug.next ! (exitd) then
#         \# (s)tep - single interpreter cycle
#         2dup s" s" compare not if 2drop
#             debug.step debug.next ! (exitd) then
#         \# (n)ext - step until we're back in the same word
#         2dup s" n" compare not if 2drop
#             rdepth 2 lshift debug.rdepth or debug.next ! (exitd) then
#         \# (r)eturn - step until we're out of current word
#         2dup s" r" compare not if 2drop
#             rdepth 1- 2 lshift debug.rdepth or debug.next ! (exitd) then
#         \# ( s ) otherwise evaluate the expression and repeat
#         s" |D " type (evaluate) .ok .ready.debugger
#     again
# ;d
# 
# : debug+ \# ( -- ) enable debugger, break will interrupt execution
#     ['] debugger debug.break ! ;
# 
# : debug- \# ( -- ) disable debugger, break will do nothing
#     0 debug.break ! ;
# 
# \ debug+

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
	.word XT_IP2NAME
	.word XT_DOCONDBRANCH,DOTBT_0004 /* if */
	.word XT_TYPE
	.word XT_DOBRANCH,DOTBT_0005
DOTBT_0004: /* else */
	.word XT_OVER
	.word XT_DOCONDBRANCH,DOTBT_0006 /* if */
	.word XT_8XDOT
	.word XT_DOBRANCH,DOTBT_0007
DOTBT_0006: /* else */
	.word XT_UHEXDOT
DOTBT_0007: /* then */
DOTBT_0005: /* then */
	.word XT_QDUP
	.word XT_DOCONDBRANCH,DOTBT_0008 /* if */
	.word XT_DOLITERAL
	.word 43
	.word XT_EMIT
	.word XT_DECDOT
DOTBT_0008: /* then */
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
COLON ".itc", DOTITC /* ( u1 u2 -- ) dump u1 XTs starting from current IP u2 cells down the return stack  */
/* The output is a vertical dump of the ITC at the current IP position, one line per cell showing the IP address, the value it contains, and if it's an XT the name of its corresponding word. The `<<(IP)<<` marker shows what is the next XT to be executed.
The second parameter (TOS) says how many return stack entries to skip, this allows viewing code at any level along the current backtrace. 
*/
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

/*
 debug.next[1:0] denotes the next debug action, 0 means no action
 debug.next[31:2] is action specific argument value
 debug actions:
*/
CONSTANT "debug.step",DEBUGDOTSTEP,1 /* single step, no argument */
END DEBUGDOTSTEP

CONSTANT "debug.rdepth",DEBUGDOTRDEPTH,2 /* step until rdepth, argument is desired rdepth */
END DEBUGDOTRDEPTH

# ----------------------------------------------------------------------
NONAME "debugger", DEBUGGER /* ( -- ) implements debug actions */
	.word XT_DEBUG_NEXT
	.word XT_FETCH
	.word XT_TWO
	.word XT_AND
	.word XT_DOCONDBRANCH,DEBUGGER_0001 /* if */
/* is next action step until rdepth ? */
	.word XT_DEBUG_NEXT
	.word XT_FETCH
	.word XT_TWO
	.word XT_RSHIFT
	.word XT_RDEPTH
	.word XT_LESS
	.word XT_DOCONDBRANCH,DEBUGGER_0002 /* if */
	.word XT_EXITD
/* rdepth is more than desired, keep going */
DEBUGGER_0002: /* then */
DEBUGGER_0001: /* then */
/* emit stack state */
	STRING "|D PS: "
	.word XT_TYPE
	.word XT_DOTS
	.word XT_CR
	STRING "|D RS: "
	.word XT_TYPE
	.word XT_ONE
	.word XT_DOTBT
	.word XT_CR
	.word XT_DOLITERAL
	.word 5
	.word XT_ONE
	.word XT_DOTITC
	.word XT_PROMPTOK
	.word XT_PROMPTREADYDEBUGGER
DEBUGGER_0003: /* begin */
/* receive input from user */
	.word XT_DEBUG_BUF
	.word XT_DUP
	.word XT_REFILL_BUF_SIZE
	.word XT_ACCEPT
	.word XT_CR
/* ( s ) */
/* (c)ontinue - resume normal execution */
	.word XT_2DUP
	STRING "c"
	.word XT_COMPARE
	.word XT_NOT
	.word XT_DOCONDBRANCH,DEBUGGER_0004 /* if */
	.word XT_2DROP
	.word XT_ZERO
	.word XT_DEBUG_NEXT
	.word XT_STORE
	.word XT_EXITD
DEBUGGER_0004: /* then */
/* (s)tep - single interpreter cycle */
	.word XT_2DUP
	STRING "s"
	.word XT_COMPARE
	.word XT_NOT
	.word XT_DOCONDBRANCH,DEBUGGER_0005 /* if */
	.word XT_2DROP
	.word XT_DEBUGDOTSTEP
	.word XT_DEBUG_NEXT
	.word XT_STORE
	.word XT_EXITD
DEBUGGER_0005: /* then */
/* (n)ext - step until we're back in the same word */
	.word XT_2DUP
	STRING "n"
	.word XT_COMPARE
	.word XT_NOT
	.word XT_DOCONDBRANCH,DEBUGGER_0006 /* if */
	.word XT_2DROP
	.word XT_RDEPTH
	.word XT_TWO
	.word XT_LSHIFT
	.word XT_DEBUGDOTRDEPTH
	.word XT_OR
	.word XT_DEBUG_NEXT
	.word XT_STORE
	.word XT_EXITD
DEBUGGER_0006: /* then */
/* (r)eturn - step until we're out of current word */
	.word XT_2DUP
	STRING "r"
	.word XT_COMPARE
	.word XT_NOT
	.word XT_DOCONDBRANCH,DEBUGGER_0007 /* if */
	.word XT_2DROP
	.word XT_RDEPTH
	.word XT_1MINUS
	.word XT_TWO
	.word XT_LSHIFT
	.word XT_DEBUGDOTRDEPTH
	.word XT_OR
	.word XT_DEBUG_NEXT
	.word XT_STORE
	.word XT_EXITD
DEBUGGER_0007: /* then */
/* ( s ) otherwise evaluate the expression and repeat */
	STRING "|D "
	.word XT_TYPE
	.word XT_LPARENEVALUATERPAREN
	.word XT_PROMPTOK
	.word XT_PROMPTREADYDEBUGGER
	.word XT_DOBRANCH,DEBUGGER_0003 /* again */
	.word XT_EXITD
# ----------------------------------------------------------------------
COLON "debug+", DEBUGPLUS /* ( -- ) enable debugger, break will interrupt execution */
	.word XT_DOXLITERAL
	.word XT_DEBUGGER
	.word XT_DEBUG_BREAK
	.word XT_STORE
	.word XT_EXIT
END DEBUGPLUS
# ----------------------------------------------------------------------
COLON "debug-", DEBUGMINUS /* ( -- ) disable debugger, break will do nothing */
	.word XT_ZERO
	.word XT_DEBUG_BREAK
	.word XT_STORE
	.word XT_EXIT
END DEBUGMINUS
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
