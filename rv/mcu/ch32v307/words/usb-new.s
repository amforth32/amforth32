# COLON "usb-emit?" , USB_EMITQ          # ( -- f ) able to emit?
#     .word XT_TB_FULLQ , XT_INVERT
#     .word XT_EXIT

# COLON "usb-emit" , USB_EMIT            # ( c -- ) push or drop
#     .word XT_TB_PUSH , XT_DROP
#     .word XT_EXIT

# COLON "usb-emit-pause" , USB_EMIT_PAUSE   # ( c -- ) push or pause
#     .word XT_PAUSE , XT_USB_EMITQ , XT_DOCONDBRANCH , PFA_USB_EMIT_PAUSE
#     .word XT_USB_EMIT
#     .word XT_EXIT

# COLON "usb-key?" , USB_KEYQ
#     .word XT_RB_EMPTYQ , XT_INVERT
#     .word XT_EXIT

# COLON "usb-key" , USB_KEY
#     .word XT_RB_POP
#     .word XT_EXIT

# COLON "usb-key-pause" , USB_KEY_PAUSE
#     .word XT_PAUSE , XT_USB_KEYQ , XT_DOCONDBRANCH , PFA_USB_KEY_PAUSE
#     .word XT_USB_KEY
#     .word XT_EXIT

# ======================================================================
# Phase 2.4 additions to usb-new.s:
#   - 512-byte EP2 RX, EP2 TX DMA buffers
#   - 64-byte EP3 TX DMA buffer (interrupt endpoint, mostly unused)
#   - rb (host→Forth) and tb (Forth→host) ring buffers in asm
#   - Forth-visible CODEWORDs: rb-push, rb-pop, rb-empty?, rb-full?,
#                              tb-push, tb-pop, tb-empty?, tb-full?
#   - Buffer-address constants for use from Forth
# ======================================================================

# ---- DMA buffers (asm-allocated, in normal RAM) ---------------------
# Bulk endpoints use 512-byte packets at HS.
# Interrupt EP3 we provide 64 bytes even though we never send on it.
# NVARIABLE allocates n cells. 512 bytes = 128 cells. 64 bytes = 16 cells.

#NVARIABLE "EP2_RX_buf" , EP2_RX_BUF , 128
#NVARIABLE "EP2_TX_buf" , EP2_TX_BUF , 128
#NVARIABLE "EP3_TX_buf" , EP3_TX_BUF , 16

# ---- Ring buffer storage --------------------------------------------
# Two rings, 512 bytes each (capacity 511 — one slot sacrificed to
# distinguish empty from full). Head and tail are byte indices in
# [0..511], updated atomically via single-word stores.

#NVARIABLE "rb-buf"  , RB_BUF  , 128    # 512 bytes
#NVARIABLE "rb-head" , RB_HEAD , 1
#NVARIABLE "rb-tail" , RB_TAIL , 1

#NVARIABLE "tb-buf"  , TB_BUF  , 128    # 512 bytes
#NVARIABLE "tb-head" , TB_HEAD , 1
#NVARIABLE "tb-tail" , TB_TAIL , 1

#CONSTANT "rb-mask" , K_RB_MASK , 0x1FF
#CONSTANT "tb-mask" , K_TB_MASK , 0x1FF

# ---- USB endpoint register addresses --------------------------------
# (Already in usb-new.s? Add only if missing.)

.equ R32_UEP_CONFIG_REG  , 0x40023410
.equ R32_UEP2_RX_DMA_REG , 0x40023424
.equ R32_UEP2_TX_DMA_REG , 0x40023460
.equ R32_UEP3_TX_DMA_REG , 0x40023464
.equ R16_UEP2_MAX_LEN_REG, 0x400234A0
.equ R16_UEP3_MAX_LEN_REG, 0x400234A4
.equ R16_UEP2_T_LEN_REG  , 0x400234E0
.equ R8_UEP2_TX_CTRL_REG , 0x400234E2
.equ R8_UEP2_RX_CTRL_REG , 0x400234E3
.equ R16_UEP3_T_LEN_REG  , 0x400234E4
.equ R8_UEP3_TX_CTRL_REG , 0x400234E6

# CONSTANT "R32_UEP_CONFIG"  , K_UEP_CONFIG   , 0x40023410
# CONSTANT "R32_UEP2_RX_DMA" , K_UEP2_RX_DMA  , 0x40023424
# CONSTANT "R32_UEP2_TX_DMA" , K_UEP2_TX_DMA  , 0x40023460
# CONSTANT "R32_UEP3_TX_DMA" , K_UEP3_TX_DMA  , 0x40023464
# CONSTANT "R16_UEP2_MAX_LEN", K_UEP2_MAX_LEN , 0x400234A0
# CONSTANT "R16_UEP3_MAX_LEN", K_UEP3_MAX_LEN , 0x400234A4
# CONSTANT "R16_UEP2_T_LEN"  , K_UEP2_T_LEN   , 0x400234E0
# CONSTANT "R8_UEP2_TX_CTRL" , K_UEP2_TX_CTRL , 0x400234E2
# CONSTANT "R8_UEP2_RX_CTRL" , K_UEP2_RX_CTRL , 0x400234E3
# CONSTANT "R16_UEP3_T_LEN"  , K_UEP3_T_LEN   , 0x400234E4
# CONSTANT "R8_UEP3_TX_CTRL" , K_UEP3_TX_CTRL , 0x400234E6

# ---- Ring buffer primitives -----------------------------------------
# ---- Ring buffer primitives -----------------------------------------

# CODEWORD "rb-empty?" , RB_EMPTYQ
#     savetos
#     la   t0 , RB_HEAD_ram
#     lw   t1 , 0(t0)
#     la   t0 , RB_TAIL_ram
#     lw   t2 , 0(t0)
#     sub  t1 , t1 , t2
#     seqz s3 , t1
#     neg  s3 , s3
#     NEXT

# CODEWORD "rb-full?" , RB_FULLQ
#     savetos
#     la   t0 , RB_HEAD_ram
#     lw   t1 , 0(t0)
#     addi t1 , t1 , 1
#     andi t1 , t1 , 0x1FF
#     la   t0 , RB_TAIL_ram
#     lw   t2 , 0(t0)
#     sub  t1 , t1 , t2
#     seqz s3 , t1
#     neg  s3 , s3
#     NEXT

# CODEWORD "rb-push" , RB_PUSH
#     la   t0 , RB_HEAD_ram
#     lw   t1 , 0(t0)
#     addi t2 , t1 , 1
#     andi t2 , t2 , 0x1FF
#     la   t3 , RB_TAIL_ram
#     lw   t3 , 0(t3)
#     beq  t2 , t3 , 1f
#     la   t3 , RB_BUF_ram
#     add  t3 , t3 , t1
#     sb   s3 , 0(t3)
#     sw   t2 , 0(t0)
#     li   s3 , -1
#     NEXT
# 1:
#     li   s3 , 0
#     NEXT

# CODEWORD "rb-pop" , RB_POP
#     savetos
#     la   t0 , RB_TAIL_ram
#     lw   t1 , 0(t0)
#     la   t2 , RB_BUF_ram
#     add  t2 , t2 , t1
#     lbu  s3 , 0(t2)
#     addi t1 , t1 , 1
#     andi t1 , t1 , 0x1FF
#     sw   t1 , 0(t0)
#     NEXT

# CODEWORD "rb-count" , RB_COUNT
#     savetos
#     la   t0 , RB_HEAD_ram
#     lw   t1 , 0(t0)
#     la   t0 , RB_TAIL_ram
#     lw   t2 , 0(t0)
#     sub  t1 , t1 , t2
#     andi s3 , t1 , 0x1FF
#     NEXT

# CODEWORD "tb-empty?" , TB_EMPTYQ
#     savetos
#     la   t0 , TB_HEAD_ram
#     lw   t1 , 0(t0)
#     la   t0 , TB_TAIL_ram
#     lw   t2 , 0(t0)
#     sub  t1 , t1 , t2
#     seqz s3 , t1
#     neg  s3 , s3
#     NEXT

# CODEWORD "tb-full?" , TB_FULLQ
#     savetos
#     la   t0 , TB_HEAD_ram
#     lw   t1 , 0(t0)
#     addi t1 , t1 , 1
#     andi t1 , t1 , 0x1FF
#     la   t0 , TB_TAIL_ram
#     lw   t2 , 0(t0)
#     sub  t1 , t1 , t2
#     seqz s3 , t1
#     neg  s3 , s3
#     NEXT

# CODEWORD "tb-push" , TB_PUSH
#     la   t0 , TB_HEAD_ram
#     lw   t1 , 0(t0)
#     addi t2 , t1 , 1
#     andi t2 , t2 , 0x1FF
#     la   t3 , TB_TAIL_ram
#     lw   t3 , 0(t3)
#     beq  t2 , t3 , 1f
#     la   t3 , TB_BUF_ram
#     add  t3 , t3 , t1
#     sb   s3 , 0(t3)
#     sw   t2 , 0(t0)
#     li   s3 , -1
#     NEXT
# 1:
#     li   s3 , 0
#     NEXT

# CODEWORD "tb-pop" , TB_POP
#     savetos
#     la   t0 , TB_TAIL_ram
#     lw   t1 , 0(t0)
#     la   t2 , TB_BUF_ram
#     add  t2 , t2 , t1
#     lbu  s3 , 0(t2)
#     addi t1 , t1 , 1
#     andi t1 , t1 , 0x1FF
#     sw   t1 , 0(t0)
#     NEXT

# CODEWORD "tb-count" , TB_COUNT
#     savetos
#     la   t0 , TB_HEAD_ram
#     lw   t1 , 0(t0)
#     la   t0 , TB_TAIL_ram
#     lw   t2 , 0(t0)
#     sub  t1 , t1 , t2
#     andi s3 , t1 , 0x1FF
#     NEXT
    
# ---- usb-key / usb-emit / usb redirector ----------------------------
# These are COLONs that can now reference the asm-defined XTs.

# COLON "usb-key?" , USB_KEYQ
#     .word XT_RB_EMPTYQ , XT_INVERT
#     .word XT_EXIT

# COLON "usb-key" , USB_KEY
#     .word XT_RB_POP
#     .word XT_EXIT

# COLON "usb-key-pause" , USB_KEY_PAUSE
#     .word XT_PAUSE , XT_USB_KEYQ , XT_DOCONDBRANCH , PFA_USB_KEY_PAUSE
#     .word XT_USB_KEY
#     .word XT_EXIT

# COLON "usb-emit?" , USB_EMITQ
#     .word XT_TB_FULLQ , XT_INVERT
#     .word XT_EXIT

# COLON "usb-emit" , USB_EMIT
#     .word XT_TB_PUSH , XT_DROP
#     .word XT_EXIT

# COLON "usb-emit-pause" , USB_EMIT_PAUSE
#     .word XT_PAUSE , XT_USB_EMITQ , XT_DOCONDBRANCH , PFA_USB_EMIT_PAUSE
#     .word XT_USB_EMIT
#     .word XT_EXIT

# # usb : rewire key/emit deferred vectors to point at usb-key/usb-emit.
# # Matches your existing pattern with ['] X ['] standard cell+ @ !

# COLON "usb" , USB_REDIRECT
#     .word XT_DOLITERAL , XT_USB_KEYQ
#     .word XT_DOLITERAL , XT_KEYQ , XT_CELLPLUS , XT_FETCH , XT_STORE
#     .word XT_DOLITERAL , XT_USB_KEY_PAUSE
#     .word XT_DOLITERAL , XT_KEY , XT_CELLPLUS , XT_FETCH , XT_STORE
#     .word XT_DOLITERAL , XT_USB_EMITQ
#     .word XT_DOLITERAL , XT_EMITQ , XT_CELLPLUS , XT_FETCH , XT_STORE
#     .word XT_DOLITERAL , XT_USB_EMIT_PAUSE
#     .word XT_DOLITERAL , XT_EMIT , XT_CELLPLUS , XT_FETCH , XT_STORE
#     .word XT_EXIT 

# ======================================================================
# usb-new.s — USBHS device-mode setup for CH32V307 from Forth
# Complete Phase 1 + Phase 2 asm primitives.
# Phase 2.x Forth code lives in usb-forth1.f.
# ======================================================================

# ---- Register addresses (asm scope only) ----------------------------

.equ R32_RCC_AHBPCENR    , 0x40021014
.equ R32_RCC_CFGR2       , 0x4002102C

.equ R8_USB_CTRL         , 0x40023400
.equ R8_UHOST_CTRL       , 0x40023401
.equ R8_USB_INT_EN       , 0x40023402
.equ R8_USB_DEV_AD       , 0x40023403
.equ R8_USB_SPPED_TYPE   , 0x40023408
.equ R8_USB_MIS_ST       , 0x40023409
.equ R8_USB_INT_FG       , 0x4002340A
.equ R8_USB_INT_ST       , 0x4002340B

# ---- USB CONTROL bit values -----------------------------------------

.equ USBHS_CFGR2_VAL     , 0xD1000000
.equ USBHS_AHBEN_BIT     , 0x00000800

.equ UC_SPEED_HIGH       , 0x20
.equ UC_DEV_PU_EN        , 0x10
.equ UC_INT_BUSY         , 0x08
.equ UC_RESET_SIE        , 0x04
.equ UC_CLR_ALL          , 0x02
.equ UC_DMA_EN           , 0x01

.equ UIE_SETUP_ACT_BIT   , 0x20
.equ UIE_SUSPEND_BIT     , 0x04
.equ UIE_TRANSFER_BIT    , 0x02
.equ UIE_BUS_RST_BIT     , 0x01

.equ PFIC_IENR_BASE      , 0xE000E100

# ---- EP0 DMA buffer (64 bytes = 16 cells) ---------------------------

# NVARIABLE "EP0buf" , EP0BUF , 16

# ---- Forth-visible register address constants -----------------------

# CONSTANT "R8_USB_DEV_AD"      , K_USB_DEV_AD     , 0x40023403
# CONSTANT "R8_USB_INT_FG"      , K_USB_INT_FG     , 0x4002340A
# CONSTANT "R32_UEP0_DMA"       , K_UEP0_DMA       , 0x4002341C
# CONSTANT "R16_UEP0_MAX_LEN"   , K_UEP0_MAX_LEN   , 0x40023498
# CONSTANT "R16_UEP0_T_LEN"     , K_UEP0_T_LEN     , 0x400234D8
# CONSTANT "R8_UEP0_TX_CTRL"    , K_UEP0_TX_CTRL   , 0x400234DA
# CONSTANT "R8_UEP0_RX_CTRL"    , K_UEP0_RX_CTRL   , 0x400234DB

# ---- Forth-visible bit-mask constants -------------------------------

# CONSTANT "UIF_BUS_RST"        , K_UIF_BUS_RST    , 0x01
# CONSTANT "UIF_TRANSFER"       , K_UIF_TRANSFER   , 0x02
# CONSTANT "UIF_SUSPEND"        , K_UIF_SUSPEND    , 0x04
# CONSTANT "UIF_SETUP_ACT"      , K_UIF_SETUP_ACT  , 0x20

# CONSTANT "UEP_T_TOG_DATA1"    , K_UEP_T_TOG_DATA1, 0x08
# CONSTANT "UEP_R_TOG_DATA1"    , K_UEP_R_TOG_DATA1, 0x08

# CONSTANT "UEP_T_RES_ACK"      , K_UEP_T_RES_ACK  , 0x00
# CONSTANT "UEP_T_RES_NAK"      , K_UEP_T_RES_NAK  , 0x02
# CONSTANT "UEP_T_RES_STALL"    , K_UEP_T_RES_STALL, 0x03

# CONSTANT "UEP_R_RES_ACK"      , K_UEP_R_RES_ACK  , 0x00
# CONSTANT "UEP_R_RES_NAK"      , K_UEP_R_RES_NAK  , 0x02
# CONSTANT "UEP_R_RES_STALL"    , K_UEP_R_RES_STALL, 0x03

# CONSTANT "#usbhs"             , K_HASH_USBHS     , 85

# ---- Codewords ------------------------------------------------------

# CODEWORD "+usbhs.clk" , PLUS_USBHS_CLK
#     li   t0 , R32_RCC_CFGR2
#     li   t1 , USBHS_CFGR2_VAL
#     sw   t1 , 0(t0)
#     li   t0 , R32_RCC_AHBPCENR
#     lw   t1 , 0(t0)
#     li   t2 , USBHS_AHBEN_BIT
#     or   t1 , t1 , t2
#     sw   t1 , 0(t0)
#     NEXT

# CODEWORD "+usbhs-device" , PLUS_USBHS_DEVICE
#     # CONTROL = CLR_ALL | RESET_SIE
#     li   t0 , R8_USB_CTRL
#     li   t1 , UC_CLR_ALL | UC_RESET_SIE
#     sb   t1 , 0(t0)
#     # short delay
#     li   t2 , 1000
# 1:  addi t2 , t2 , -1
#     bnez t2 , 1b
#     # release reset (preserve CLR_ALL)
#     li   t1 , UC_CLR_ALL
#     sb   t1 , 0(t0)
#     # PHY out of suspend
#     li   t3 , R8_UHOST_CTRL
#     li   t1 , 0x10
#     sb   t1 , 0(t3)
#     # CONTROL = DMA_EN | INT_BUSY | SPEED_HIGH
#     li   t1 , UC_DMA_EN | UC_INT_BUSY | UC_SPEED_HIGH
#     sb   t1 , 0(t0)
#     # INT_EN = SETUP_ACT | TRANSFER | BUS_RST | SUSPEND
#     li   t3 , R8_USB_INT_EN
#     li   t1 , UIE_SETUP_ACT_BIT | UIE_TRANSFER_BIT | UIE_BUS_RST_BIT | UIE_SUSPEND_BIT
#     sb   t1 , 0(t3)
#     # Pull-up enable
#     li   t1 , UC_DMA_EN | UC_INT_BUSY | UC_SPEED_HIGH | UC_DEV_PU_EN
#     sb   t1 , 0(t0)
#     NEXT

# # Enable a PFIC interrupt by number ( n -- )
# CODEWORD "+irq" , PLUS_IRQ
#     mv   t0 , s3
#     loadtos
#     srli t1 , t0 , 5
#     slli t1 , t1 , 2
#     li   t2 , PFIC_IENR_BASE
#     add  t1 , t1 , t2
#     andi t0 , t0 , 31
#     li   t2 , 1
#     sll  t2 , t2 , t0
#     sw   t2 , 0(t1)
#     NEXT

# .equ PFIC_IRER_BASE      , 0xE000E180

# # Disable a PFIC interrupt by number ( n -- )
# CODEWORD "-irq" , MINUS_IRQ
#     mv   t0 , s3
#     loadtos
#     srli t1 , t0 , 5
#     slli t1 , t1 , 2
#     li   t2 , PFIC_IRER_BASE
#     add  t1 , t1 , t2
#     andi t0 , t0 , 31
#     li   t2 , 1
#     sll  t2 , t2 , t0
#     sw   t2 , 0(t1)
#     NEXT

# # Write byte to INT_FG (write-1-to-clear) ( c -- )
# CODEWORD "uintfg!" , UINTFG_STORE
#     li   t0 , R8_USB_INT_FG
#     sb   s3 , 0(t0)
#     loadtos
#     NEXT

# # Register fetch primitives for usb.dump

# CODEWORD "cfgr2@"    , CFGR2_FETCH
#     savetos
#     li   t0 , R32_RCC_CFGR2
#     lw   s3 , 0(t0)
#     NEXT

# CODEWORD "ahbpcenr@" , AHBPCENR_FETCH
#     savetos
#     li   t0 , R32_RCC_AHBPCENR
#     lw   s3 , 0(t0)
#     NEXT

# CODEWORD "uctrl@"    , UCTRL_FETCH
#     savetos
#     li   t0 , R8_USB_CTRL
#     lbu  s3 , 0(t0)
#     NEXT

# CODEWORD "uinten@"   , UINTEN_FETCH
#     savetos
#     li   t0 , R8_USB_INT_EN
#     lbu  s3 , 0(t0)
#     NEXT

# CODEWORD "uhost@"    , UHOST_FETCH
#     savetos
#     li   t0 , R8_UHOST_CTRL
#     lbu  s3 , 0(t0)
#     NEXT

# CODEWORD "uspeed@"   , USPEED_FETCH
#     savetos
#     li   t0 , R8_USB_SPPED_TYPE
#     lbu  s3 , 0(t0)
#     NEXT

# CODEWORD "umis@"     , UMIS_FETCH
#     savetos
#     li   t0 , R8_USB_MIS_ST
#     lbu  s3 , 0(t0)
#     NEXT

# CODEWORD "uintfg@"   , UINTFG_FETCH
#     savetos
#     li   t0 , R8_USB_INT_FG
#     lbu  s3 , 0(t0)
#     NEXT

# CODEWORD "uintst@"   , UINTST_FETCH
#     savetos
#     li   t0 , R8_USB_INT_ST
#     lbu  s3 , 0(t0)
#     NEXT

# Counters and helpers

# VARIABLE "usb.int.count"   , USB_INT_COUNT
# VARIABLE "usb.rst.count"   , USB_RST_COUNT
# VARIABLE "usb.setup.count" , USB_SETUP_COUNT
# VARIABLE "usb.xfer.count"  , USB_XFER_COUNT
# VARIABLE "usb.susp.count"  , USB_SUSP_COUNT
# VARIABLE "usb.other.count" , USB_OTHER_COUNT

# COLON "usb.zero" , USB_ZERO
#     .word XT_DOLITERAL , 0 , XT_USB_INT_COUNT   , XT_STORE
#     .word XT_DOLITERAL , 0 , XT_USB_RST_COUNT   , XT_STORE
#     .word XT_DOLITERAL , 0 , XT_USB_SETUP_COUNT , XT_STORE
#     .word XT_DOLITERAL , 0 , XT_USB_XFER_COUNT  , XT_STORE
#     .word XT_DOLITERAL , 0 , XT_USB_SUSP_COUNT  , XT_STORE
#     .word XT_DOLITERAL , 0 , XT_USB_OTHER_COUNT , XT_STORE
#     .word XT_EXIT

# COLON "usb.stats" , USB_STATS
#     .word XT_USB_INT_COUNT   , XT_FETCH , XT_DOT , XT_CR
#     .word XT_USB_RST_COUNT   , XT_FETCH , XT_DOT , XT_CR
#     .word XT_USB_SETUP_COUNT , XT_FETCH , XT_DOT , XT_CR
#     .word XT_USB_XFER_COUNT  , XT_FETCH , XT_DOT , XT_CR
#     .word XT_USB_SUSP_COUNT  , XT_FETCH , XT_DOT , XT_CR
#     .word XT_USB_OTHER_COUNT , XT_FETCH , XT_DOT , XT_CR
#     .word XT_EXIT

