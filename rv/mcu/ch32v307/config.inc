# SPDX-License-Identifier: GPL-3.0-only

.include "core/config.inc"

.equ flash_page, 4*1024
.equ flash_cell, 2
.equ flash_erased, 0xE339E339 /* a word in erased flash */


.equ YES , 1
.equ NO  , 0


.equ WANT_NESTED_ISR   , NO

# what Forth word groups do you want included in the core 

.equ WANT_CASE         , YES
.equ WANT_MATCH        , NO
.equ WANT_FORNEXT      , NO

.equ WANT_SEE          , YES

.equ WANT_TIMER6       , NO
.equ WANT_SYSTICK      , YES

.equ WANT_PORTD        , NO
.equ WANT_PORTC        , YES 
.equ WANT_PORTB        , YES
.equ WANT_PORTA        , YES

.equ WANT_CODE         , NO
.equ WANT_TABLE        , NO

.equ WANT_RECORD       , YES

# ----------------------------------------------------------------------

.equ WANT_USB_OPERATOR , YES # if YES - USB prompt if NO serial prompt
.equ WANT_USB          , YES # if YES - USB code included 
.equ WANT_FLOAT        , NO

# ----------------------------------------------------------------------
# generate some pure GAS abolute expressions as a consequence of above 

# -- GAS .if can only handle absolute expressions and I don't want CPP

.ifdef TARGET_305

# PORTA is needed by onboard LED 
.equ WANT_PORTA        , YES


.endif

.equ WANT_ASM_BUILD , YES

.if WANT_ASM_BUILD
    .equ WANT_C_BUILD , NO
.else
    .equ WANT_C_BUILD , YES
.endif            

# -- if you WANT_USB_OPERATOR you WANT_USB

.if WANT_USB_OPERATOR
    .equ WANT_USB     , YES
.endif         



