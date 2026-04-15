# SPDX-License-Identifier: GPL-3.0-only
USART1_BASE      = 0x40013800
USART1_DATAR     = USART1_BASE + 0x04

USART_STATR_TXE  = 0x0080            
USART_STATR_TC   = 0x0040
USART_STATR_RXNE = 0x0020
R32_USART1_BRR = 0x40013808

# -----------------------------------------------------------------------------

  CONSTANT "R32_USART1_STATR" , R32_USART1_STATR , 0x40013800
  
  COLON "usart1.init" , USART1_INIT

  .WORD XT_PORTA                   # Enable GPIOA 
  .WORD XT_PORT_ENABLE             # 

#  .WORD XT_ONE                     # USART1 needs to be 
  .WORD XT_DOLITERAL               # enabled by setting 
#  .WORD 0xE                        # bit 14 of this reg
#  .WORD XT_LSHIFT                  #
  .WORD (1<14)
  .WORD XT_R32_RCC_APB2PCENR       # <-- here 
  .WORD XT_MSET

  .WORD XT_DOLITERAL
  .WORD 0x0A                       # PA10 RX
  .WORD XT_PORTA 
  .WORD XT_PIN_IN

  .WORD XT_DOLITERAL
  .WORD 0x09                       # PA09 TX
  .WORD XT_PORTA 
  .WORD XT_PIN_PP_AF_FAST

  # Set up BAUDRATE for system clock of 96MHz
  
  .word XT_DOLITERAL
  .word 0x341                      # 115200 -> $341 38400 -> $964
#  .word 0x964                      # 115200 -> $341 38400 -> $964
  .word XT_R32_USART1_STATR        # base 
  .word XT_CELLPLUS , XT_CELLPLUS  # R32_USART1_BRR
  .word XT_STORE 

  # Enable usart (module,tx,rx)

  .word XT_DOLITERAL
#  .word 0x200C                     # (1<<13) | (1<<3) | (1<<2)
  .word (1<<3)|(1<<2)
  .word XT_R32_USART1_STATR        # base 
  .word XT_CELLPLUS
  .word XT_CELLPLUS
  .word XT_CELLPLUS                # R32_USART1_CTLR1
  .word XT_MSET

  .word XT_DOLITERAL
#  .word 0x200C                     # (1<<13) | (1<<3) | (1<<2)
  .word (1<<13)
  .word XT_R32_USART1_STATR        # base 
  .word XT_CELLPLUS
  .word XT_CELLPLUS
  .word XT_CELLPLUS                # R32_USART1_CTLR1
  .word XT_MSET 

  .word XT_EXIT 

# -----------------------------------------------------------------------------
  CODEWORD  "serial-key", SERIAL_KEY
# -----------------------------------------------------------------------------

  savetos
  li t0 , USART1_DATAR              #
  lw s3 , 0(t0)

  NEXT

# -----------------------------------------------------------------------------
  CODEWORD  "serial-key?", SERIAL_KEYQ
# -----------------------------------------------------------------------------

  savetos
  li t0 , USART1_BASE               # load USART1 (base) address
  lw t1 , 0(t0)
  andi s3, t1 , USART_STATR_RXNE    # which is 1 if data waiting put in TOS 
        # question for FORTH is return -1 or !0
        # macro or subroutine
        # beqz s3 , +? BOOLIFY            # turns !0 in to -1 
        # li s3, -1 
        # +?

  NEXT

# -----------------------------------------------------------------------------
  CODEWORD  "serial-emit", SERIAL_EMIT
# -----------------------------------------------------------------------------

  li t0 , USART1_BASE               # load USART1 (base) address 

1:      lw t1 , 0(t0)                     # base contains status   
        andi t1 , t1 , USART_STATR_TXE    # wait until buffer empty
        beqz t1 , 1b                      # which is 1   

        li t1 , USART1_DATAR              # load TX data buffer address 
        sb s3 , 0(t1)                     # mv TOS to TX data buffer

2:      lw t1 , 0(t0)                     # wait until transmission complete
        andi t1 , t1 , USART_STATR_TC     # which is 1 
        beqz t1 , 2b                      # IS THIS NEEDED?
        
  loadtos

  NEXT

# -----------------------------------------------------------------------------
  CODEWORD  "serial-emit?", SERIAL_EMITQ
# -----------------------------------------------------------------------------
   savetos
#  li t0, UART0_TXDATA
#  lw t0, 0(t0)
#  srai t0, t0, 31  # Sign extend the "transmit FIFO full" bit
#  xori s3, t0, -1  # Invert it

# a fudge for the moment FIXME 
  li s3, -1 

  NEXT

# ----------------------------------------------------------------------
# a bit of a take two

.equ R32_USART1_STATR , 0x40013800 # UASRT1 status register 0x000000C0
.equ R32_USART1_DATAR , 0x40013804 # UASRT1 data register 0x000000XX
.equ R32_USART1_BRR   , 0x40013808 # UASRT1 baud rate register 0x00000000
.equ R32_USART1_CTLR1 , 0x4001380C # UASRT1 control register1 0x00000000
.equ R32_USART1_CTLR2 , 0x40013810 # UASRT1 control register2 0x00000000
.equ R32_USART1_CTLR3 , 0x40013814 # UASRT1 control register3 0x00000000
.equ R32_USART1_GPR   , 0x40013818 # UASRT1 guard time and prescaler register 0x00000000

.equ R32_PFIC_IENR1   , 0xE000E104 # Interrupt 32-63 enable setting register


CODEWORD "+usart1.int.idle" , PLUS_USART1_INT_IDLE # ( -- ) USART1: enable idle interrupt
         li t0, R32_USART1_CTLR1
         lw t1, 0(t0)
         ori t1,t1,(1<<4)
         sw t1, 0(t0)
         NEXT

CODEWORD "-usart1.int.idle" , MINUS_USART1_INT_IDLE # ( -- ) USART1: disable idle interrupt
         li t0, R32_USART1_CTLR1
         lw t1, 0(t0)
         andi t1,t1,~(1<<4)
         sw t1, 0(t0)
         NEXT

CODEWORD "-usart1.rx" , MINUS_USART1_RX # ( -- ) USART1: disable receiver
         li t0, R32_USART1_CTLR1
         lw t1, 0(t0)
         andi t1,t1,~(1<<2)
         sw t1, 0(t0)
         NEXT


CODEWORD "+usart1.int" , PLUS_USART1_INT # ( -- ) USART1: enable global interrupt 
         
         li   t0, R32_PFIC_IENR1   # this IS required 
         lw   t1, 0(t0)
         li   t2, 1 << 21  # 53-32 
         or   t1, t1, t2 
         sw   t1, 0(t0)
         
         NEXT


CODEWORD "+usart1.dmarx" , PLUS_USART1_DMARX # ( -- ) USART1: enable DMA
         li t0, R32_USART1_CTLR3
         lw t1, 0(t0)
         ori t1,t1,~(1<<6)
         sw t1, 0(t0)
         NEXT

CONSTANT "#usart1" , USART1INTNUM, 53 # USART1: interrupt trap number

# ----------------------------------------------------------------------
# DMA for RX (channel 5)

.equ R32_DMA1_INTFR  , 0x40020000 # DMA1 interrupt flag register
.equ R32_DMA1_INTFCR , 0x40020004 # DMA1 interrupt flag clear register

.equ R32_DMA1_CFGR5  , 0x40020058 # DMA1 channel5 configuration register
.equ R32_DMA1_CNTR5  , 0x4002005C # DMA1 channel5 transferred data register 
.equ R32_DMA1_PADDR5 , 0x40020060 # DMA1 channel5 peripheral address register 
.equ R32_DMA1_MADDR5 , 0x40020064 # DMA1 channel5 memory address register 

# ok so set R32_DMA1_PADDR5 to USART DATA
#       set R32_DMA1_MADDR5 to somewhere in memory
# can make a modified txq routine (amforth.S) to try and see
# when the reception transmision is complete (by outputing "C" perhaps)

# CODEWORD "dma1" , DMA1 # ( -- ) bucket
#          # disable DMA1
#          # set source periph USART1 DATA
#          # set memory SOMEWHERE
#          # set options
#          # enable interrupts 
#          # do also in FPIC ...

#          NEXT

# CODEWORD "+dma1" , PLUS_DMA1 # ( -- ) bucket
#          NEXT 

# CODEWORD "dma1-" , DMA1_MINUS # ( -- )

# ----------------------------------------------------------------------
# : serial
#     ['] serial-key?       ['] key?  cell+ @ !
#     ['] serial-key-pause  ['] key   cell+ @ !
#     ['] serial-emit?      ['] emit? cell+ @ !
#     ['] serial-emit-pause ['] emit  cell+ @ !
# ;
COLON "serial", SERIAL # ( -- ) SERIAL: switch operator prompt to serial connection 
	.word XT_DOLITERAL
	.word XT_SERIAL_KEYQ
	.word XT_DOLITERAL
	.word XT_KEYQ
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_DOLITERAL
	.word XT_SERIAL_KEY_PAUSE
	.word XT_DOLITERAL
	.word XT_KEY
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_DOLITERAL
	.word XT_SERIAL_EMITQ
	.word XT_DOLITERAL
	.word XT_EMITQ
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_DOLITERAL
	.word XT_SERIAL_EMIT_PAUSE
	.word XT_DOLITERAL
	.word XT_EMIT
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_EXIT
# ----------------------------------------------------------------------

