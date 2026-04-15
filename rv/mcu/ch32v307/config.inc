# SPDX-License-Identifier: GPL-3.0-only

.include "core/config.inc"

.equ flash_page, 4*1024
.equ flash_cell, 2
.equ flash_erased, 0xE339E339 /* a word in erased flash */

.equ WANT_NESTED_ISR   , NO

# what Forth word groups do you want included in the core 

.equ WANT_CASE         , YES
.equ WANT_MATCH        , YES
.equ WANT_FORNEXT      , NO

.equ WANT_SEE          , YES


.equ WANT_TIMER6       , NO
.equ WANT_SYSTICK      , NO

.equ WANT_PORTD        , NO
.equ WANT_PORTC        , YES 
.equ WANT_PORTB        , YES
.equ WANT_PORTA        , YES

.equ WANT_CODE         , NO
.equ WANT_TABLE        , NO

# ----------------------------------------------------------------------
# Do NOT change these options. Not currently available. 

.equ WANT_USB_OPERATOR , NO   # if YES - USB prompt if NO serial prompt
.equ WANT_USB          , NO   # if YES - USB code included 
.equ WANT_FLOAT        , NO

# ----------------------------------------------------------------------
# generate some pure GAS abolute expressions as a consequence of above 

# -- GAS .if can only handle absolute expressions and I don't want CPP

.equ WANT_ASM_BUILD , YES

.if WANT_ASM_BUILD
    .equ WANT_C_BUILD      , NO
    .equ WANT_USB_OPERATOR , NO
    .equ WANT_USB          , NO
    .equ WANT_FLOAT        , NO
.else
    .equ WANT_C_BUILD , YES
.endif            

# -- if you WANT_USB_OPERATOR you WANT_USB

.if WANT_USB_OPERATOR
    .equ WANT_USB     , YES
.endif         



