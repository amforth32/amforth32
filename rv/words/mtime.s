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
# transpiling ../../../lib/transpiled/mtime.f on 2026/11/20 08:21:00
# \# # SPDX-License-Identifier: GPL-3.0-only
# 
# {
# /*
# On the QEMU virt machine, mtime is at address 0x200BFF8 and
# ticks at 10 MHz (1 tick = 100 ns, 10000 ticks = 1 ms). It is a 64 bit
# counter but only the low word is used. No init is required.
# 
# https://docs.riscv.org/reference/isa/extensions/priv-1p13/_attachments/riscv-privileged-priv_1_13.pdf
# 
# */
# }
# 
# $0200BFF8 constant mtime         \ 64-bit, lo word first
# $02004000 constant mtimecmp      \ + 8*hartid
# #10000000 constant mtime.hz
# 
# \ --- reads ---
# 
# {
# # ----------------------------------------------------------------------
# .equ MTIME_LO, 0x0200BFF8
# 
# CODEWORD "mtime@", MTIMEFETCH /* ( -- n ) read RV low 32 bits of 64 bit RV machine counter  */
#     savetos
#     li t0, MTIME_LO
#     lw s3 , 0(t0)
#     NEXT
# END MTIMEFETCH
# }
# 
# \# : mtime@  \# ( -- u ) low 32 bits of 64 bit RV machine counter
# \#    mtime @
# \# ;                    \ low 32: deltas, ms
# 
# : mtime2@ \# ( -- ud ) 64 bit RV machine counter as ud
#    begin  mtime cell+ @  mtime @  mtime cell+ @  ( h1 l h2 )
#       rot over =  dup 0= if >r 2drop r> then
#    until ;                                       ( lo hi )
# 
# \ --- compare (glitch-free 64-bit write on RV32) ---
# 
# : mtimecmp! \# ( ud -- ) set 64 bit RV machine counter alarm
#     -1 mtimecmp !  mtimecmp cell+ !  mtimecmp !
# ;
# 
# : mtimecmp@ \# ( -- ud ) read 64 bit RV machine counter alarm
#     mtimecmp @  mtimecmp cell+ @
# ;
# 
# : mtime- \# ( -- ) clear RV machine counter alarm
#     -1 -1 mtimecmp!
# ;

/* # SPDX-License-Identifier: GPL-3.0-only */
/*
On the QEMU virt machine, mtime is at address 0x200BFF8 and
ticks at 10 MHz (1 tick = 100 ns, 10000 ticks = 1 ms). It is a 64 bit
counter but only the low word is used. No init is required.
https://docs.riscv.org/reference/isa/extensions/priv-1p13/_attachments/riscv-privileged-priv_1_13.pdf
*/
CONSTANT "mtime", MTIME, 33603576
END MTIME
CONSTANT "mtimecmp", MTIMECMP, 33570816
END MTIMECMP
CONSTANT "mtime.hz", MTIMEDOTHZ, 10000000
END MTIMEDOTHZ
# ----------------------------------------------------------------------
.equ MTIME_LO, 0x0200BFF8
CODEWORD "mtime@", MTIMEFETCH /* read RV low 32 bits of 64 bit RV machine counter */
savetos
li t0, MTIME_LO
lw s3 , 0(t0)
NEXT
END MTIMEFETCH
/* : mtime@  \# ( -- u ) low 32 bits of 64 bit RV machine counter  */
/*    mtime @ */
/* ;                    \ low 32: deltas, ms */
# ----------------------------------------------------------------------
COLON "mtime2@", MTIME2AT /* ( -- ud ) 64 bit RV machine counter as ud  */
MTIME2AT_0001: /* begin */
	.word XT_MTIME
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_MTIME
	.word XT_FETCH
	.word XT_MTIME
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_ROT
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DUP
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,MTIME2AT_0002 /* if */
	.word XT_TO_R
	.word XT_2DROP
	.word XT_R_FROM
MTIME2AT_0002: /* then */
	.word XT_DOCONDBRANCH,MTIME2AT_0001 /* until */
	.word XT_EXIT
END MTIME2AT
# ----------------------------------------------------------------------
COLON "mtimecmp!", MTIMECMPBANG /* ( ud -- ) set 64 bit RV machine counter alarm  */
	.word XT_MINUSONE
	.word XT_MTIMECMP
	.word XT_STORE
	.word XT_MTIMECMP
	.word XT_CELLPLUS
	.word XT_STORE
	.word XT_MTIMECMP
	.word XT_STORE
	.word XT_EXIT
END MTIMECMPBANG
# ----------------------------------------------------------------------
COLON "mtimecmp@", MTIMECMPAT /* ( -- ud ) read 64 bit RV machine counter alarm  */
	.word XT_MTIMECMP
	.word XT_FETCH
	.word XT_MTIMECMP
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_EXIT
END MTIMECMPAT
# ----------------------------------------------------------------------
COLON "mtime-", MTIMEMINUS /* ( -- ) clear RV machine counter alarm  */
	.word XT_MINUSONE
	.word XT_MINUSONE
	.word XT_MTIMECMPBANG
	.word XT_EXIT
END MTIMEMINUS
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
