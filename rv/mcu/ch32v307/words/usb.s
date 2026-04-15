# SPDX-License-Identifier: GPL-3.0-only
.if WANT_USB

# int main(void)
# {
# 	SystemCoreClockUpdate( );
# 	Delay_Init( );
# 	USART_Printf_Init( 115200 );
		
# 	printf( "SystemClk:%d\r\n", SystemCoreClock );
# 	printf( "Simulate USB-CDC Device running on USBHS Controller\r\n" );
# 	RCC_Configuration( );

# 	/* Tim7 init */
# 	TIM7_Init( );

# 	/* Usart2 init */
# 	UART2_Init( 1, DEF_UARTx_BAUDRATE, DEF_UARTx_STOPBIT, DEF_UARTx_PARITY );

# 	/* USB20 device init */
# 	USBHS_RCC_Init( );
# 	USBHS_Device_Init( ENABLE );

# 	while(1)
# 	{
# 		UART2_DataRx_Deal( );
# 		UART2_DataTx_Deal( );
# 	}
# }

# void USBHS_RCC_Init( void )
# {
#     RCC_USBCLK48MConfig( RCC_USBCLK48MCLKSource_USBPHY );
#     RCC_USBHSPLLCLKConfig( RCC_HSBHSPLLCLKSource_HSE );
#     RCC_USBHSConfig( RCC_USBPLL_Div2 );
#     RCC_USBHSPLLCKREFCLKConfig( RCC_USBHSPLLCKREFCLK_4M );
#     RCC_USBHSPHYPLLALIVEcmd( ENABLE );
#     RCC_AHBPeriphClockCmd( RCC_AHBPeriph_USBHS, ENABLE );
# }

# Chapter 3 RCC

.equ R32_RCC_CTLR      , 0x40021000 # Clock control register , 0x000, 0xx83
.equ R32_RCC_CFGR0     , 0x40021004 # Clock configuration register 0 , 0x00000000
.equ R32_RCC_INTR      , 0x40021008 # Clock interrupt register , 0x00000000
.equ R32_RCC_APB2PRSTR , 0x4002100C # APB2 peripheral reset register , 0x00000000
.equ R32_RCC_APB1PRSTR , 0x40021010 # APB1 peripheral reset register , 0x00000000
.equ R32_RCC_AHBPCENR  , 0x40021014 # AHB peripheral clock enable register , 0x00000014
.equ R32_RCC_APB2PCENR , 0x40021018 # APB2 peripheral clock enable register , 0x00000000
.equ R32_RCC_APB1PCENR , 0x4002101C # APB1 peripheral clock enable register , 0x00000000
.equ R32_RCC_BDCTLR    , 0x40021020 # Backup domain control register , 0x00000000
.equ R32_RCC_RSTSCKR   , 0x40021024 # Control/status register , 0x0C000000
.equ R32_RCC_AHBRSTR   , 0x40021028 # AHB peripheral reset register , 0x00000000
.equ R32_RCC_CFGR2     , 0x4002102C # Clock configuration register 2 , 0x00000000 

# Chapter 22 below is the device I want

# GLobal registers

.equ R8_USB_CTRL       , 0x40023400 # USB control register , 0x06
.equ R8_USB_INT_EN     , 0x40023402 # USB interrupt enable register 0
.equ R8_USB_DEV_AD     , 0x40023403 # USB device address register 0
.equ R16_USB_FRAME_NO  , 0x40023404 # USB frame number register 0
.equ R8_USB_SUSPEND    , 0x40023406 # USB suspend register 0
.equ R8_USB_SPPED_TYPE , 0x40023408 # USB current speed type register 0
.equ R8_USB_MIS_ST     , 0x40023409 # USB miscellaneous status register xx10_1000b
.equ R8_USB_INT_FG     , 0x4002340A # USB interrupt flag register 0
.equ R8_USB_INT_ST     , 0x4002340B # USB interrupt status register 0, 0xx_xxxxb
.equ R16_USB_RX_LEN    , 0x4002340C # USB receive length register xx 

# Endpoint registers 
.equ R32_UEP_CONFIG    , 0x40023410 # Endpoint enable configuration register 00000000h
.equ R32_UEP_TYPE      , 0x40023414 # Endpoint type configuration register 00000000h
.equ R32_UEP_BUF_MOD   , 0x40023418 # Endpoint buffer mode register 00000000h

.equ R32_UEP0_DMA , 0x4002341C # Endpoint0 buffer start address xxxxh
.equ R32_UEP1_RX_DMA , 0x40023420 # Endpoint1 receive buffer start address xxxxh
.equ R32_UEP2_RX_DMA , 0x40023424 # Endpoint2 receive buffer start address xxxxh
.equ R32_UEP3_RX_DMA , 0x40023428 # Endpoint3 receive buffer start address xxxxh
.equ R32_UEP4_RX_DMA , 0x4002342C # Endpoint4 receive buffer start address xxxxh
.equ R32_UEP5_RX_DMA , 0x40023430 # Endpoint5 receive buffer start address xxxxh
.equ R32_UEP6_RX_DMA , 0x40023434 # Endpoint6 receive buffer start address xxxxh
.equ R32_UEP7_RX_DMA , 0x40023438 # Endpoint7 receive buffer start address xxxxh
.equ R32_UEP8_RX_DMA , 0x4002343C # Endpoint8 receive buffer start address xxxxh
.equ R32_UEP9_RX_DMA , 0x40023440 # Endpoint9 receive buffer start address xxxxh
.equ R32_UEP10_RX_DMA , 0x40023444 # Endpoint10 receive buffer start address xxxxh
.equ R32_UEP11_RX_DMA , 0x40023448 # Endpoint11 receive buffer start address xxxxh
.equ R32_UEP12_RX_DMA , 0x4002344C # Endpoint12 receive buffer start address xxxxh
.equ R32_UEP13_RX_DMA , 0x40023450 # Endpoint13 receive buffer start address xxxxh
.equ R32_UEP14_RX_DMA , 0x40023454 # Endpoint14 receive buffer start address xxxxh
.equ R32_UEP15_RX_DMA , 0x40023458 # Endpoint15 receive buffer start address xxxxh
.equ R32_UEP1_TX_DMA , 0x4002345C # Endpoint1 transmit buffer start address xxxxh
.equ R32_UEP2_TX_DMA , 0x40023460 # Endpoint2 transmit buffer start address xxxxh
.equ R32_UEP3_TX_DMA , 0x40023464 # Endpoint3 transmit buffer start address xxxxh
.equ R32_UEP4_TX_DMA , 0x40023468 # Endpoint4 transmit buffer start address xxxxh
.equ R32_UEP5_TX_DMA , 0x4002346C # Endpoint5 transmit buffer start address xxxxh
.equ R32_UEP6_TX_DMA , 0x40023470 # Endpoint6 transmit buffer start address xxxxh
.equ R32_UEP7_TX_DMA , 0x40023474 # Endpoint7 transmit buffer start address xxxxh
.equ R32_UEP8_TX_DMA , 0x40023478 # Endpoint8 transmit buffer start address xxxxh
.equ R32_UEP9_TX_DMA , 0x4002347C # Endpoint9 transmit buffer start address xxxxh
.equ R32_UEP10_TX_DMA , 0x40023480 # Endpoint10 transmit buffer start address xxxxh
.equ R32_UEP11_TX_DMA , 0x40023484 # Endpoint11 transmit buffer start address xxxxh
.equ R32_UEP12_TX_DMA , 0x40023488 # Endpoint12 transmit buffer start address xxxxh
.equ R32_UEP13_TX_DMA , 0x4002348C # Endpoint13 transmit buffer start address xxxxh
.equ R32_UEP14_TX_DMA , 0x40023490 # Endpoint14 transmit buffer start address xxxxh 
.equ R32_UEP15_TX_DMA , 0x40023494 # Endpoint15 transmit buffer start address xxxxh
.equ R16_UEP0_MAX_LEN , 0x40023498 # Endpoint0 maximum length packet register xxxxh
.equ R16_UEP1_MAX_LEN , 0x4002349C # Endpoint1 maximum length packet register xxxxh
.equ R16_UEP2_MAX_LEN , 0x400234A0 # Endpoint2 maximum length packet register xxxxh
.equ R16_UEP3_MAX_LEN , 0x400234A4 # Endpoint3 maximum length packet register xxxxh
.equ R16_UEP4_MAX_LEN , 0x400234A8 # Endpoint4 maximum length packet register xxxxh
.equ R16_UEP5_MAX_LEN , 0x400234AC # Endpoint5 maximum length packet register xxxxh
.equ R16_UEP6_MAX_LEN , 0x400234B0 # Endpoint6 maximum length packet register xxxxh
.equ R16_UEP7_MAX_LEN , 0x400234B4 # Endpoint7 maximum length packet register xxxxh
.equ R16_UEP8_MAX_LEN , 0x400234B8 # Endpoint8 maximum length packet register xxxxh
.equ R16_UEP9_MAX_LEN , 0x400234BC # Endpoint9 maximum length packet register xxxxh
.equ R16_UEP10_MAX_LEN , 0x400234C0 # Endpoint10 maximum length packet register xxxxh
.equ R16_UEP11_MAX_LEN , 0x400234C4 # Endpoint11 maximum length packet register xxxxh
.equ R16_UEP12_MAX_LEN , 0x400234C8 # Endpoint12 maximum length packet register xxxxh
.equ R16_UEP13_MAX_LEN , 0x400234CC # Endpoint13 maximum length packet register xxxxh
.equ R16_UEP14_MAX_LEN , 0x400234D0 # Endpoint14 maximum length packet register xxxxh
.equ R16_UEP15_MAX_LEN , 0x400234D4 # Endpoint15 maximum length packet register xxxxh
.equ R16_UEP0_T_LEN , 0x400234D8 # Endpoint0 transmit length register xxxxh
.equ R8_UEP0_TX_CTRL , 0x400234DA # Endpoint0 transmit control register 00h
.equ R8_UEP0_RX_CTRL , 0x400234DB # Endpoint0 receive control register 00h
.equ R16_UEP1_T_LEN , 0x400234DC # Endpoint1 transmit length register xxxxh
.equ R8_UEP1_TX_CTRL , 0x400234DE # Endpoint1 transmit control register 00h
.equ R8_UEP1_RX_CTRL , 0x400234DF # Endpoint1 receive control register 00h
.equ R16_UEP2_T_LEN , 0x400234E0 # Endpoint2 transmit length register xxxxh
.equ R8_UEP2_TX_CTRL , 0x400234E2 # Endpoint2 transmit control register 00h
.equ R8_UEP2_RX_CTRL , 0x400234E3 # Endpoint2 receive control register 00h
.equ R16_UEP3_T_LEN , 0x400234E4 # Endpoint3 transmit length register xxxxh
.equ R8_UEP3_TX_CTRL , 0x400234E6 # Endpoint3 transmit control register 00h
.equ R8_UEP3_RX_CTRL , 0x400234E7 # Endpoint3 receive control register 00h
.equ R16_UEP4_T_LEN , 0x400234E8 # Endpoint4 transmit length register xxxxh
.equ R8_UEP4_TX_CTRL , 0x400234EA # Endpoint4 transmit control register 00h
.equ R8_UEP4_RX_CTRL , 0x400234EB # Endpoint4 receive control register 00h
.equ R16_UEP5_T_LEN , 0x400234EC # Endpoint5 transmit length register xxxxh
.equ R8_UEP5_TX_CTRL , 0x400234EE # Endpoint5 transmit control register 00h
.equ R8_UEP5_RX_CTRL , 0x400234EF # Endpoint5 receive control register 00h
.equ R16_UEP6_T_LEN , 0x400234F0 # Endpoint6 transmit length register xxxxh
.equ R8_UEP6_TX_CTRL , 0x400234F2 # Endpoint6 transmit control register 00h
.equ R8_UEP6_RX_CTRL , 0x400234F3 # Endpoint6 receive control register 00h
.equ R16_UEP7_T_LEN , 0x400234F4 # Endpoint7 transmit length register xxxxh
.equ R8_UEP7_TX_CTRL , 0x400234F6 # Endpoint7 transmit control register 00h
.equ R8_UEP7_RX_CTRL , 0x400234F7 # Endpoint7 receive control register 00h
.equ R16_UEP8_T_LEN , 0x400234F8 # Endpoint8 transmit length register xxxxh
.equ R8_UEP8_TX_CTRL , 0x400234FA # Endpoint8 transmit control register 00h
.equ R8_UEP8_RX_CTRL , 0x400234FB # Endpoint8 receive control register 00h 
.equ R16_UEP9_T_LEN , 0x400234FC # Endpoint9 transmit length register xxxxh
.equ R8_UEP9_TX_CTRL , 0x400234FE # Endpoint9 transmit control register 00h
.equ R8_UEP9_RX_CTRL , 0x400234FF # Endpoint9 receive control register 00h
.equ R16_UEP10_T_LEN , 0x40023500 # Endpoint10 transmit length register xxxxh
.equ R8_UEP10_TX_CTRL , 0x40023502 # Endpoint10 transmit control register 00h
.equ R8_UEP10_RX_CTRL , 0x40023503 # Endpoint10 receive control register 00h
.equ R16_UEP11_T_LEN , 0x40023504 # Endpoint11 transmit length register xxxxh
.equ R8_UEP11_TX_CTRL , 0x40023506 # Endpoint11 transmit control register 00h
.equ R8_UEP11_RX_CTRL , 0x40023507 # Endpoint11 receive control register 00h
.equ R16_UEP12_T_LEN , 0x40023508 # Endpoint12 transmit length register xxxxh
.equ R8_UEP12_TX_CTRL , 0x4002350A # Endpoint12 transmit control register 00h
.equ R8_UEP12_RX_CTRL , 0x4002350B # Endpoint12 receive control register 00h
.equ R16_UEP13_T_LEN , 0x4002350C # Endpoint13 transmit length register xxxxh
.equ R8_UEP13_TX_CTRL , 0x4002350E # Endpoint13 transmit control register 00h
.equ R8_UEP13_RX_CTRL , 0x4002350F # Endpoint13 receive control register 00h
.equ R16_UEP14_T_LEN , 0x40023510 # Endpoint14 transmit length register xxxxh
.equ R8_UEP14_TX_CTRL , 0x40023512 # Endpoint14 transmit control register 00h
.equ R8_UEP14_RX_CTRL , 0x40023513 # Endpoint14 receive control register 00h
.equ R16_UEP15_T_LEN , 0x40023514 # Endpoint15 transmit length register xxxxh
.equ R8_UEP15_TX_CTRL , 0x40023516 # Endpoint15 transmit control register 00h
.equ R8_UEP15_RX_CTRL , 0x40023517 # Endpoint15 receive control register 00h 


# TWTW

CODEWORD "+usb.clk" , PLUS_USB_CLOCK
    li t0, R32_RCC_CFGR0
    lw t1, 0(t0)
    li t2, 0b10 << 22
    or t1, t1, t2
    sw t1, 0(t0)
    NEXT

CODEWORD "-usb.clk" , MINUS_USB_CLOCK
    li  t0, R32_RCC_CFGR0
    lw  t1, 0(t0)
    li  t2, ~(0b10 << 22)
    and t1, t1, t2
    sw  t1, 0(t0)
    NEXT

CODEWORD "+usb" , PLUS_USB
    li t0, R8_USB_CTRL          # p361 
    lb t1, 0(t0)
    # device 1.5M pulup
    # splat                     #   DS.Pxxxx
    li t1, 0b01010110           # 0b01010110 = device 
    sb t1, 0(t0)
    NEXT 

CONSTANT "rxu" , RXU , USBHS_EP3_Rx_Buf
CONSTANT "txu" , TXU , USBHS_EP4_Tx_Buf

# MFD CODEWORD "usb.deal" , UDB_DEAL
#    jal deal
#    NEXT
    
# typedef struct __attribute__((packed)) _RING_BUFF_COMM
# {
#     volatile uint8_t  LoadPtr;
#     volatile uint8_t  DealPtr;
#     volatile uint8_t  RemainPack;
#     volatile uint8_t  StopFlag;
#     volatile uint16_t PackLen[DEF_Ring_Buffer_Max_Blks];
# } RING_BUFF_COMM, *pRING_BUFF_COMM;


CONSTANT "usb.rb"   , USB_RB   , tw_rb_buf # ( -- a ) USB: start of USB recieve ring buffer
CONSTANT "usb.tb"   , USB_TB   , tw_tb_buf # ( -- a ) USB: start of USB transmit ring buffer 

CODEWORD "rb?" , RBQ # ( -- f ) USB: true if byte available in USB ring buffer
   savetos
   jal tw_rb_q
   mv s3 , a0
   NEXT

CODEWORD "rb@" , RB_FETCH # ( --  c ) USB: fetch byte from USB (rx) ring buffer
   savetos
   jal tw_rb_pop
   mv s3 , a0
   NEXT

CODEWORD "tb!" , TB_STORE # ( c --   ) USB: write byte to USB (tx) ring buffer
   mv a0 , s3
   jal tw_tb_push
   loadtos
   NEXT

# ----------------------------------------------------------------------
# : usb
#     ['] usb-key?       ['] key?  cell+ @ !
#     ['] usb-key-pause  ['] key   cell+ @ !
#     ['] usb-emit?      ['] emit? cell+ @ !
#     ['] usb-emit-pause ['] emit  cell+ @ !
# ;
COLON "usb", USB   # ( -- ) USB: switch operator prompt to USB connection
	.word XT_DOLITERAL
	.word XT_USB_KEYQ
	.word XT_DOLITERAL
	.word XT_KEYQ
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_DOLITERAL
	.word XT_USB_KEY_PAUSE
	.word XT_DOLITERAL
	.word XT_KEY
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_DOLITERAL
	.word XT_USB_EMITQ
	.word XT_DOLITERAL
	.word XT_EMITQ
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_DOLITERAL
	.word XT_USB_EMIT_PAUSE
	.word XT_DOLITERAL
	.word XT_EMIT
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_EXIT
# ----------------------------------------------------------------------
COLON "usb-emit" , USB_EMIT # ( c -- ) USB: emit c on usb connection 
    .word XT_TB_STORE
    .word XT_EXIT
# ----------------------------------------------------------------------
CODEWORD "usb-emit?" , USB_EMITQ # ( -- f ) USB: f is true if able to emit 
     savetos
     jal tw_tb_full
     xori a0,a0,-1
     mv s3, a0
     NEXT
# ----------------------------------------------------------------------
COLON "usb-emit-pause" , USB_EMIT_PAUSE # ( c -- ) USB: emit c on usb connection if able or pause 
    .word XT_PAUSE,XT_USB_EMITQ, XT_DOCONDBRANCH, PFA_USB_EMIT_PAUSE
    .word XT_USB_EMIT
    .word XT_EXIT



COLON "usb-key?" , USB_KEYQ # ( -- f ) USB: f true if byte avaible in usb connection
    .word XT_RBQ 
    .word XT_EXIT

COLON "usb-key" , USB_KEY # ( -- c ) USB: fetch byte from USB connection 
    .word XT_RB_FETCH
    .word XT_EXIT

COLON "usb-key-pause" , USB_KEY_PAUSE # ( -- c ) USB: fetch byte from USB connection if able or pause 
     # but want XT_KEYQ not XT_SERIAL_KEYQ  
    .word XT_PAUSE,XT_KEYQ, XT_DOCONDBRANCH, PFA_USB_KEY_PAUSE
    .word XT_USB_KEY
    .word XT_EXIT

.endif
