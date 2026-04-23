# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "1ms", 1MS /* ( -- ) 1ms busy delay loop (96MHz system clock) */

# For CH32V307 @ 96MHz
# 96E6/1000 cycles and two instructions plus VM change
# would imply 48E3 cycles...but perhaps due to pipeline
# hazard on branch the loop seems to take 3 cycles always.

    li t0, 32000
1:
    addi t0,t0,-1
    bne t0,zero,1b
    NEXT
END 1MS

CODEWORD "1s", 1S /* ( -- ) SYSTEM: 1s busy delay loop (96MHz system clock) */

# For CH32V307 @ 96MHz
# 96E6/1000 cycles and two instructions plus VM change
# would imply 48E3 cycles...but perhaps due to pipeline
# hazard on branch the loop seems to take 3 cycles always.

    li t0, 32000000
1:
    addi t0,t0,-1
    bne t0,zero,1b
    NEXT
END 1S

# COLON "ms", MS /* ( n -- )  n ms busy delay loop */

# XT_MS_LOOP:
#   .word XT_PAUSE
#   .word XT_1MINUS
#   .word XT_1MS
#   .word XT_DUP,XT_ZEROEQUAL
#   .word XT_DOCONDBRANCH
#   .word XT_MS_LOOP
#   .word XT_DROP,XT_EXIT
# END MS

#======================================================================
#======================================================================
# transpiling ms.f on 2026/05/08 05:36:54
# \ ============================================================
# \ ms.init / tick@ -- RTC as a free-running 32-bit counter
# \                    clocked at HSE/128
# \ With HSE = 8 MHz: 62.5 kHz tick, 16 us resolution, wraps ~19 h.
# \ Requires HSE to be running (RCC_CTLR HSERDY=1) before ms.init.
# \ ============================================================
# 
# : constant~ constant ;
# 
# 
# \ ---- Register addresses -------------------------------------
# $40002804 constant~ ms.CTLRL     \ RTC_CTLRL
# $40002808 constant~ ms.PSCRH     \ RTC_PSCRH
# $4000280C constant~ ms.PSCRL     \ RTC_PSCRL
# $40002818 constant~ ms.CNTH      \ RTC_CNTH
# $4000281C constant~ ms.CNTL      \ RTC_CNTL
# $4002101C constant~ ms.APB1ENR   \ RCC_APB1PCENR
# $40021020 constant~ ms.BDCTLR    \ RCC_BDCTLR
# $40007000 constant~ ms.PWRCR     \ PWR_CTLR
# 
# \ ---- Bit masks ----------------------------------------------
# $18000000 constant~ ms.M.APB1    \ MASK: PWREN(28) | BKPEN(27)
# $00000100 constant~ ms.M.DBP     \ MASK: PWR_CR.DBP (bit 8)
# $00000300 constant~ ms.M.RTCSEL  \ MASK: RTCSEL=HSE/128 (bits 9:8)
# $00008000 constant~ ms.M.RTCEN   \ MASK: RTCEN (bit 15)
# $0020     constant~ ms.M.RTOFF   \ MASK: CTLRL.RTOFF
# $0010     constant~ ms.M.CNF     \ MASK: CTLRL.CNF
# $FFEF     constant~ ms.M.~CNF    \ MASK: inverse of CNF
# 
# : ms.init  ( -- )
#    ms.APB1ENR @  ms.M.APB1   or   ms.APB1ENR !
#    ms.PWRCR   @  ms.M.DBP    or   ms.PWRCR   !
#    ms.BDCTLR  @  ms.M.RTCSEL or   ms.BDCTLR  !
#    ms.BDCTLR  @  drop
#    ms.BDCTLR  @  ms.M.RTCEN  or   ms.BDCTLR  !
#    begin ms.CTLRL h@ ms.M.RTOFF and until
#    ms.CTLRL h@   ms.M.CNF    or   ms.CTLRL h!
#    0 ms.PSCRH h!  0 ms.PSCRL h!
#    ms.CTLRL h@   ms.M.~CNF   and  ms.CTLRL h!
#    begin ms.CTLRL h@ ms.M.RTOFF and until ;
# 
# : tick@  ( -- u32 )
#    begin
#       ms.CNTH h@  ms.CNTL h@  ms.CNTH h@   
#       rot over =                             
#       dup 0= if  >r 2drop r>  then           
#    until                                     
#    #16 lshift or
# ;
# 
# #62500 constant ms.tickf
# 
# : ms ( n -- )
#     tick@ swap
#     ms.tickf um* #1000 um/mod nip >r
#     begin
#         pause tick@ over - r@ u>
#     until drop rdrop
# ;
# ----------------------------------------------------------------------
NOCON "ms.CTLRL",MSDOTCTLRL,0x40002804
END MSDOTCTLRL
NOCON "ms.PSCRH",MSDOTPSCRH,0x40002808
END MSDOTPSCRH
NOCON "ms.PSCRL",MSDOTPSCRL,0x4000280c
END MSDOTPSCRL
NOCON "ms.CNTH",MSDOTCNTH,0x40002818
END MSDOTCNTH
NOCON "ms.CNTL",MSDOTCNTL,0x4000281c
END MSDOTCNTL
NOCON "ms.APB1ENR",MSDOTAPB1ENR,0x4002101c
END MSDOTAPB1ENR
NOCON "ms.BDCTLR",MSDOTBDCTLR,0x40021020
END MSDOTBDCTLR
NOCON "ms.PWRCR",MSDOTPWRCR,0x40007000
END MSDOTPWRCR
NOCON "ms.M.APB1",MSDOTMDOTAPB1,0x18000000
END MSDOTMDOTAPB1
NOCON "ms.M.DBP",MSDOTMDOTDBP,0x100
END MSDOTMDOTDBP
NOCON "ms.M.RTCSEL",MSDOTMDOTRTCSEL,0x300
END MSDOTMDOTRTCSEL
NOCON "ms.M.RTCEN",MSDOTMDOTRTCEN,0x8000
END MSDOTMDOTRTCEN
NOCON "ms.M.RTOFF",MSDOTMDOTRTOFF,0x20
END MSDOTMDOTRTOFF
NOCON "ms.M.CNF",MSDOTMDOTCNF,0x10
END MSDOTMDOTCNF
NOCON "ms.M.~CNF",MSDOTMDOTTILDECNF,0xffef
END MSDOTMDOTTILDECNF
# ----------------------------------------------------------------------
COLON "ms.init", MSDOTINIT 
	.word XT_MSDOTAPB1ENR
	.word XT_FETCH
	.word XT_MSDOTMDOTAPB1
	.word XT_OR
	.word XT_MSDOTAPB1ENR
	.word XT_STORE
	.word XT_MSDOTPWRCR
	.word XT_FETCH
	.word XT_MSDOTMDOTDBP
	.word XT_OR
	.word XT_MSDOTPWRCR
	.word XT_STORE
	.word XT_MSDOTBDCTLR
	.word XT_FETCH
	.word XT_MSDOTMDOTRTCSEL
	.word XT_OR
	.word XT_MSDOTBDCTLR
	.word XT_STORE
	.word XT_MSDOTBDCTLR
	.word XT_FETCH
	.word XT_DROP
	.word XT_MSDOTBDCTLR
	.word XT_FETCH
	.word XT_MSDOTMDOTRTCEN
	.word XT_OR
	.word XT_MSDOTBDCTLR
	.word XT_STORE
MSDOTINIT_0001: /* begin */
	.word XT_MSDOTCTLRL
	.word XT_HFETCH
	.word XT_MSDOTMDOTRTOFF
	.word XT_AND
	.word XT_DOCONDBRANCH,MSDOTINIT_0001 /* until */
	.word XT_MSDOTCTLRL
	.word XT_HFETCH
	.word XT_MSDOTMDOTCNF
	.word XT_OR
	.word XT_MSDOTCTLRL
	.word XT_HSTORE
	.word XT_ZERO
	.word XT_MSDOTPSCRH
	.word XT_HSTORE
	.word XT_ZERO
	.word XT_MSDOTPSCRL
	.word XT_HSTORE
	.word XT_MSDOTCTLRL
	.word XT_HFETCH
	.word XT_MSDOTMDOTTILDECNF
	.word XT_AND
	.word XT_MSDOTCTLRL
	.word XT_HSTORE
MSDOTINIT_0002: /* begin */
	.word XT_MSDOTCTLRL
	.word XT_HFETCH
	.word XT_MSDOTMDOTRTOFF
	.word XT_AND
	.word XT_DOCONDBRANCH,MSDOTINIT_0002 /* until */
	.word XT_EXIT
END MSDOTINIT
# ----------------------------------------------------------------------
COLON "tick@", TICKAT 
TICKAT_0001: /* begin */
	.word XT_MSDOTCNTH
	.word XT_HFETCH
	.word XT_MSDOTCNTL
	.word XT_HFETCH
	.word XT_MSDOTCNTH
	.word XT_HFETCH
	.word XT_ROT
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DUP
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,TICKAT_0002 /* if */
	.word XT_TO_R
	.word XT_2DROP
	.word XT_R_FROM
TICKAT_0002: /* then */
	.word XT_DOCONDBRANCH,TICKAT_0001 /* until */
	.word XT_DOLITERAL
	.word 16
	.word XT_LSHIFT
	.word XT_OR
	.word XT_EXIT
END TICKAT
# ----------------------------------------------------------------------
CONSTANT "ms.tickf",MSDOTTICKF,62500
END MSDOTTICKF
# ----------------------------------------------------------------------
COLON "ms", MS 
	.word XT_TICKAT
	.word XT_SWAP
	.word XT_MSDOTTICKF
	.word XT_UMSTAR
	.word XT_DOLITERAL
	.word 1000
	.word XT_UMSLASHMOD
	.word XT_NIP
	.word XT_TO_R
MS_0001: /* begin */
	.word XT_PAUSE
	.word XT_TICKAT
	.word XT_OVER
	.word XT_MINUS
	.word XT_R_FETCH
	.word XT_UGREATER
	.word XT_DOCONDBRANCH,MS_0001 /* until */
	.word XT_DROP
	.word XT_RDROP
	.word XT_EXIT
END MS
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================

