# SPDX-License-Identifier: GPL-3.0-only
.ifdef TARGET_203 

COLON "led.init", LEDDOTINIT 
	.word XT_PORTB
	.word XT_PORT_ENABLE
	.word XT_TWO
	.word XT_PORTB
	.word XT_PIN_PP
	.word XT_EXIT

COLON "+led", PLUSLED 
	.word XT_TWO
	.word XT_PORTB
	.word XT_PIN_HIGH
	.word XT_EXIT

COLON "-led", MINUSLED 
	.word XT_TWO
	.word XT_PORTB
	.word XT_PIN_LOW
	.word XT_EXIT

COLON "^led", CARETLED 
	.word XT_TWO
	.word XT_PORTB
	.word XT_PIN_TOG
	.word XT_EXIT

CODEWORD "led.delay" , LED_DELAY # ( -- ) LED: make arbitary delay for blinky
.equ led_cycles , 2000000 * 8
        li  t0 , led_cycles
10:
        addi t0, t0, -1
        bne t0, zero, 10b
        NEXT

.equ R32_GPIOB_OUTDR , 0x40010C0C 
.equ R32_GPIOB_BSHR  , 0x40010C10

CODEWORD "led.pulse" , LED_PULSE # ( u -- ) LED: make arbitary delay for blinky u=[0..3]
.equ led_cycles , 96000000 / 40

     andi s3,s3, 3  # only 0,1,2,3
     beq s3,zero,11f
     li t0,1
     sll s3,s3,t0 
     
20:  
     li t0 , R32_GPIOB_OUTDR
     lw t1 , 0(t0)
     andi t1, t1, 1 << 2 
     beq t1,zero, 1f   # if zero then pin not set so set
     li t0 , R32_GPIOB_BSHR
     li t1 , 1 << (16+2) # %....01 
     sw t1 , 0(t0)
     j 2f     
1:   li t0 , R32_GPIOB_BSHR
     li t1 , 1 << 2 # %....01 
     sw t1 , 0(t0)
2:
     li  t0 , led_cycles
10:
     addi t0, t0, -1
     bne t0, zero, 10b

     addi s3, s3, -1 
     bne s3 , zero, 20b
     
11:  loadtos 

     NEXT

.else

# These are from CH32FV2x_V3xRM.PDF section 10.3.1
#.equ R32_GPIOB_CFGLR,   0x40010C00 # PB port configuration register low
#.equ R32_GPIOB_OUTDR,   0x40010C0C # PB port output data register
#.equ R32_RCC_APB2PCENR, 0x40021018 # APB2 peripheral clock enable register

.equ R32_GPIOC_CFGLR   , 0x40011000 # PC port config reg low
.equ R32_GPIOC_OUTDR   , 0x4001100C # PC port output data register 
.equ R32_RCC_APB2PCENR , 0x40021018 # APB2 peripheral clock enable register

# From https://github.com/openwch/ch32v307/blob/7ec2dd5a66cef60f88519a52d55230fc678093be/EVT/EXAM/SRC/Peripheral/inc/ch32v30x_rcc.h#L13
.equ RCC_APB2Periph_GPIOC, (1 << 4)

# This is the default config (0x44444444) except for the last bits, which set
# GPIOB into 2MHz (slow clock) push-pull output mode
.equ GPIOC_CONFIG, 0x44444441


CODEWORD "led.init" , LED_INIT # ( -- ) LED: Init (not) on-board LED jumpered to PC0

     li t0, R32_RCC_APB2PCENR
     lw t1, 0(t0)
     ori t1, t1, RCC_APB2Periph_GPIOC
     sw t1, 0(t0)

     # Set pin 0 of GPIOC to (max) 2MHz push-pull output
     li t0, R32_GPIOC_CFGLR
     li t1, GPIOC_CONFIG
     sw t1, 0(t0)

NEXT

# use 10.3.1.5 Port Set/Reset Register (GPIOx_BSHR) (x=A/B/C/D/E)
# [31:16] clear the bit [15:0] set the bit | only write 1 has effect

.equ R32_GPIOC_BSHR , 0x40011010  # set reset mem reg 

CODEWORD "+led" , PLUSLED # ( -- ) LED: turn on (not) on-board LED jumpered to PC0
     li t0 , R32_GPIOC_BSHR
     li t1 , 1 << 16 # %....01 
     sw t1 , 0(t0)
NEXT            

CODEWORD "-led" , MINUSLED # ( -- ) LED: turn off (not) on-board LED jumpered to PC0
     li t0 , R32_GPIOC_BSHR
     li t1 , 1 # %....01 
     sw t1 , 0(t0)
NEXT            

CODEWORD "^led" , TOGLED # ( -- ) LED: toggle (not) on-board LED jumpered to PC0
     li t0 , R32_GPIOC_OUTDR
     lw t1 , 0(t0)
     andi t1, t1, 0b1
     beq t1,zero, 1f   # if zero then pin not set so set
     li t0 , R32_GPIOC_BSHR
     li t1 , 1 << 16 # %....01 
     sw t1 , 0(t0)
     j 2f     
1:   li t0 , R32_GPIOC_BSHR
     li t1 , 1 # %....01 
     sw t1 , 0(t0)
2:
NEXT 

CODEWORD "led.delay" , LED_DELAY # ( -- ) LED: make arbitary delay for blinky
.equ led_cycles , 2000000 * 8
        li  t0 , led_cycles
10:
        addi t0, t0, -1
        bne t0, zero, 10b
NEXT

CODEWORD "led.pulse" , LED_PULSE # ( u -- ) LED: make arbitary delay for blinky u=[0..3]
.equ led_cycles , 96000000 / 40

     andi s3,s3, 3  # only 0,1,2,3
     beq s3,zero,11f
     li t0,1
     sll s3,s3,t0 
     
20:  
     li t0 , R32_GPIOC_OUTDR
     lw t1 , 0(t0)
     andi t1, t1, 0b1
     beq t1,zero, 1f   # if zero then pin not set so set
     li t0 , R32_GPIOC_BSHR
     li t1 , 1 << 16 # %....01 
     sw t1 , 0(t0)
     j 2f     
1:   li t0 , R32_GPIOC_BSHR
     li t1 , 1 # %....01 
     sw t1 , 0(t0)
2:
     li  t0 , led_cycles
10:
     addi t0, t0, -1
     bne t0, zero, 10b

     addi s3, s3, -1 
     bne s3 , zero, 20b
     
11:  loadtos 

NEXT

.endif
