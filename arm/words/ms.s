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
# transpiling lib/transpiled/ms-arm.f on 2026/11/10 21:38:50
# \
# \ Using Systick for the default ARM implementation of ms as that is available
# \ on any Cortex-M target. May be overridden in specific targets.
# \
# \ SYSTICK_TICKS_PER_MS is supplied by the MCU configuration and must match
# \ the clock selected by systick.init.
# : ms ( n -- ) \ delay n milliseconds, calling PAUSE
#     systick@
#     begin
#         \ ( n start )
#         over 0= if 2drop exit then
#         begin
#             \ ( n start )
#             pause
#             systick@
#             over over - \ ( n start end elapsed )
#             \ if elapsed is negative due to systick rollover,
#             \ adjust it by adding timer's 24-bit period (2^24)
#             dup 0< if $01000000 + then
#             \ if elapsed is more than 1 ms leave the loop,
#             \ otherwise drop elapsed and end, and loop again
#             dup symbol SYSTICK_TICKS_PER_MS > dup not if
#                 nip nip
#             then
#         until
#         \ ( n start end elapsed )
#         \ adjust end with elapsed so that it reflects where 1ms elapsed
#         \ end = end + (elapsed - SYSTICK_TICKS_PER_MS)
#         symbol SYSTICK_TICKS_PER_MS - +
#         \ fix ajdusted end if it exceeds the timer range
#         $00ffffff and
#         \ end is now the new start and decrement n
#         nip swap 1- swap
#     again
# ;

# comment \ hanging on its own 0
# comment \ hanging on its own 3
# ----------------------------------------------------------------------
COLON "ms", MS 
	.word XT_SYSTICK_FETCH
MS_0001: /* begin */
	.word XT_OVER
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,MS_0002 /* if */
	.word XT_2DROP
	.word XT_FINISH
MS_0002: /* then */
MS_0003: /* begin */
	.word XT_PAUSE
	.word XT_SYSTICK_FETCH
	.word XT_OVER
	.word XT_OVER
	.word XT_MINUS
	.word XT_DUP
	.word XT_ZEROLESS
	.word XT_DOCONDBRANCH,MS_0004 /* if */
	.word XT_DOLITERAL
	.word 0x1000000
	.word XT_PLUS
MS_0004: /* then */
	.word XT_DUP
	.word XT_DOLITERAL
	.word SYSTICK_TICKS_PER_MS
	.word XT_GREATER
	.word XT_DUP
	.word XT_NOT
	.word XT_DOCONDBRANCH,MS_0005 /* if */
	.word XT_NIP
	.word XT_NIP
MS_0005: /* then */
	.word XT_DOCONDBRANCH,MS_0003 /* until */
	.word XT_DOLITERAL
	.word SYSTICK_TICKS_PER_MS
	.word XT_MINUS
	.word XT_PLUS
	.word XT_DOLITERAL
	.word 0xffffff
	.word XT_AND
	.word XT_NIP
	.word XT_SWAP
	.word XT_1MINUS
	.word XT_SWAP
	.word XT_DOBRANCH,MS_0001 /* again */
	.word XT_EXIT
END MS
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
