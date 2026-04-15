# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
# Labels for a few hardware ports
# -----------------------------------------------------------------------------

# : pin.in ( pin port -- )
#     >r dup %1000 and if
#         %0100 swap r> $4 + m4fix
#     else
#         %0100 swap r> m4fix
#     then
# ;

# DOCONDBRANCH *TAKES* THE BRANCH ON ZERO SO THE
# LOGIC IS REVERSED FROM FORTH SOURCE 

CONSTANT "R32_GPIOA_CFGLR" , R32_GPIOA_CFGLR , 0x40010800              # 
CONSTANT "porta"           , PORTA           , 0x40010800              # ( -- u ) GPIO: porta
CONSTANT "portb"           , PORTB           , 0x40010800 + 0x400 * 1  # ( -- u ) GPIO: portb
CONSTANT "portc"           , PORTC           , 0x40010800 + 0x400 * 2  # ( -- u ) GPIO: portc
CONSTANT "portd"           , PORTD           , 0x40010800 + 0x400 * 3  # ( -- u ) GPIO: portd
CONSTANT "porte"           , PORTE           , 0x40010800 + 0x400 * 4  # ( -- u ) GPIO: porte

CONSTANT "R32_RCC_APB2PCENR" , R32_RCC_APB2PCENR, 0x40021018


# : port.enable ( port -- )
#     porta - $400 / 2+ 1 swap lshift R32_RCC_APB2PCENR mset 
# ;

# : port.disable ( port -- )
#     porta - $400 / 2+ 1 swap lshift R32_RCC_APB2PCENR mclr
# ;

COLON "port.enable" , PORT_ENABLE # ( port -- ) GPIO: enable GPIO operations on port
  .word XT_PORTA , XT_MINUS , XT_DOLITERAL , 0x400 , XT_SLASH , XT_2PLUS
  .word XT_ONE , XT_SWAP , XT_LSHIFT , XT_R32_RCC_APB2PCENR , XT_MSET 
  .word XT_EXIT 

COLON "port.disable" , PORT_DISABLE # ( port -- ) GPIO: enable GPIO operations on port
  .word XT_PORTA , XT_MINUS , XT_DOLITERAL , 0x400 , XT_SLASH , XT_2PLUS
  .word XT_ONE , XT_SWAP , XT_LSHIFT , XT_R32_RCC_APB2PCENR , XT_MCLR
  .word XT_EXIT 

COLON "pin.in" , PIN_IN # ( pin port -- ) GPIO: make pin on port a floating input 
  .word XT_TO_R , XT_DUP , XT_DOLITERAL , 0x08 , XT_AND
  .word XT_DOCONDBRANCH, PIN_IN1
        .word XT_DOLITERAL
        .word 0b0100
        .word XT_SWAP
        .word XT_R_FROM
        .word XT_CELLPLUS
        .word XT_M4FIX
        .word XT_DOBRANCH , PIN_IN2         
PIN_IN1:
        .word XT_DOLITERAL
        .word 0b0100
        .word XT_SWAP
        .word XT_R_FROM
        .word XT_M4FIX
PIN_IN2: 
  .word XT_EXIT 

# : pin.pp     ( pin port -- )
#     >r dup %1000 and if
#         %0001 swap r> $4 + m4fix
#     else
#         %0001 swap r> m4fix
#     then
# ;

COLON "pin.pp" , PIN_PP # ( pin port -- ) GPIO: make pin on port a push-pull output (10MHz)
  .word XT_TO_R , XT_DUP , XT_DOLITERAL , 0x08 , XT_AND
  .word XT_DOCONDBRANCH, PIN_PP1        # so if pin > 7 then and is != 0 so DONT branch
        .word XT_DOLITERAL
        .word 0b0001
        .word XT_SWAP
        .word XT_R_FROM
        .word XT_CELLPLUS
        .word XT_M4FIX
        .word XT_DOBRANCH , PIN_PP2 
PIN_PP1:
        .word XT_DOLITERAL
        .word 0b0001
        .word XT_SWAP
        .word XT_R_FROM
        .word XT_M4FIX
PIN_PP2: 
  .word XT_EXIT 

COLON "pin.pp.af.fast" , PIN_PP_AF_FAST # ( pin port -- ) GPIO: make pin on port a push-pull alt fun output (50MHz)
  .word XT_TO_R , XT_DUP , XT_DOLITERAL , 0x08 , XT_AND
  .word XT_DOCONDBRANCH, PIN_PP_AF_FAST1     # so if pin > 7 then and is != 0 so DONT branch
        .word XT_DOLITERAL
        .word 0b1011
        .word XT_SWAP
        .word XT_R_FROM
        .word XT_CELLPLUS
        .word XT_M4FIX
        .word XT_DOBRANCH , PIN_PP_AF_FAST2
PIN_PP_AF_FAST1:
        .word XT_DOLITERAL
        .word 0b1011
        .word XT_SWAP
        .word XT_R_FROM
        .word XT_M4FIX
PIN_PP_AF_FAST2: 
  .word XT_EXIT 

#: pin.low ( pin port -- )
#    >r 1 swap #16 + lshift r> $10 + mset
#;

#: pin.high ( pin port -- )
#    >r 1 swap       lshift r> $10 + mset
#;

# KEEP This works but is slower (160KHz vs 860KHz) then the assembler versions 
# COLON "pin.low" , PIN_LOW # ( pin port -- ) GPIO: make pin on port low
#   .word XT_TO_R , XT_ONE , XT_SWAP , XT_DOLITERAL , 0x10 , XT_PLUS , XT_LSHIFT 
#   .word XT_R_FROM , XT_DOLITERAL , 0x10 , XT_PLUS , XT_MSET
#   .word XT_EXIT

# COLON "pin.high" , PIN_HIGH # ( pin port -- ) GPIO: make pin on port high
#   .word XT_TO_R , XT_ONE , XT_SWAP ,  XT_LSHIFT 
#   .word XT_R_FROM , XT_DOLITERAL , 0x10 , XT_PLUS , XT_MSET
#   .word XT_EXIT

CODEWORD "pin.high" , PIN_HIGH # ( pin port -- ) GPIO: make pin on port high
  li t0    , 1         # 
  lw t1    , 0(s4)     # pin
  sll t1   , t0 , t1   # pin mask 
  sw  t1   , 0x10(s3)  # set/clr register (port in TOS)
  addi s4, s4, 4       # contract stack 
  loadtos              # load TOS (from stack)
  NEXT  

CODEWORD "pin.low" , PIN_LOW # ( pin port -- ) GPIO: make pin on port low
  li t0    , 1         # 
  lw t1    , 0(s4)     # pin
  addi t1  , t1, 0x10  # add 16 
  sll t1   , t0 , t1   # pin mask 
  sw  t1   , 0x10(s3)  # set/clr register (port in TOS)
  addi s4, s4, 4       # contract stack 
  loadtos              # load TOS (from stack)
  NEXT  

CODEWORD "pin.tog" , PIN_TOG # ( pin port -- ) GPIO: toggle pin on port

   li t0    , 1         # 
   lw t1    , 0(s4)     # pin
   sll t1   , t0, t1    # pin mask
   lw t2    , 0x0C(s3)  # OUTDR (s3 has port)
   and t2   , t2, t1    # if zero want to set
   bne t2 , zero , 1f
   # set the pin 
   sw t1 , 0x10(s3)     # set via the set/reset register
   j 2f 
1: # clr the pin
   slli t1,t1,16
   sw t1 , 0x10(s3)     # clr via the set/reset register
2:
   addi s4, s4, 4       # contract stack 
   loadtos              # load TOS (from stack)
   NEXT

#      li t0 , R32_GPIOC_OUTDR
#      lw t1 , 0(t0)
#      andi t1, t1, 0b1
#      beq t1,zero, 1f   # if zero then pin not set so set
#      li t0 , R32_GPIOC_BSHR
#      li t1 , 1 << 16 # %....01 
#      sw t1 , 0(t0)
#      j 2f     
# 1:   li t0 , R32_GPIOC_BSHR
#      li t1 , 1 # %....01 
#      sw t1 , 0(t0)
# 2:
# NEXT 


# ???? What were you thinking?
# sufficient to store to set/clr willy nilly

# MFD CODEWORD "pin.high" , PIN_HIGH  # ( pin port -- )  GPIO: make pin on port high
#   li t0    , 1         # 
#   lw t1    , 0(s4)     # pin
#   sll t1   , t0 , t1   # pin mask 
#   lw t2    , 0x10(s3)  # t2 is contents of set/clr register
#   or t3    , t2 , t1   # t3 = (1 << pin ) | set/clr reg 
#   sw  t3   , 0x10(s3)  # store back to set/clr reg 
#   addi s4, s4, 4       # contract stack 
#   loadtos              # load TOS (from stack)
#   NEXT
  
# MFD CODEWORD "pin.low" , PIN_LOW # ( pin port -- )  GPIO: make pin on port low
#   li t0    , 1         # 
#   lw t1    , 0(s4)     # pin
#   addi t1  , t1, 0x10  # add 16 
#   sll t1   , t0 , t1   # pin mask 
#   lw t2    , 0x10(s3)  # t2 is contents of set/clr register
#   or t3    , t2 , t1   # t3 = (1 << pin ) | set/clr reg 
#   sw  t3   , 0x10(s3)  # store back to set/clr reg 
#   addi s4, s4, 4       # contract stack 
#   loadtos              # load TOS (from stack)
#   NEXT

# ----------------------------------------------------------------------
# new style gpio commands

.equ R32_RCC_APB2PCENR , 0x40021018
.equ R32_GPIOD_BSHR    , 0x40011410
.equ R32_GPIOD_CFGLR   , 0x40011400
.equ R32_GPIOD_OUTDR   , 0x4001140C


.if WANT_PORTA

.equ R32_GPIOA_CFGLR   , 0x40010800 
.equ R32_GPIOA_BSHR    , 0x40010810

CODEWORD "+PA" , PLUS_PA # ( mask -- ) GPIO: Set bits in mask | enable port A clk if mask=0
    bne s3 , zero , 1f 
    li t0, R32_RCC_APB2PCENR
    lw t1, 0(t0)
    li t2 , (1 << 2) 
    or t1, t1, t2 
    sw t1, 0(t0)
    j 2f 
    1:
    li t0 , R32_GPIOA_BSHR
    sw s3 , 0(t0)
    2:
    loadtos
    NEXT 

CODEWORD "-PA" , MINUS_PA # ( mask -- ) GPIO: Clr bits in mask | disable port A clk if mask=0
    bne s3 , zero , 1f 
    li t0, R32_RCC_APB2PCENR
    lw t1, 0(t0)
    li t2 , ~(1 << 2) 
    and t1, t1, t2 
    sw t1, 0(t0)
    j 2f 
    1:
    slli s3 , s3 , 16 
    li t0 , R32_GPIOA_BSHR
    sw s3 , 0(t0)
    2:
    loadtos
    NEXT

CODEWORD "PA~" , PA_TILDE # ( n -- ) GPIO: make pin n a push-pull output 
    slli s3 , s3 , 2 
    li t0, R32_GPIOA_CFGLR
    lw t1 , 0(t0) 
    li t2 , 0xf
    sll t2 , t2 , s3 
    xori t2 , t2 , -1 
    and t1 , t1 , t2
    li t2 , 0b11
    sll t2 , t2 , s3 
    or t1 , t1 , t2
    sw t1 , 0(t0)
    loadtos
    NEXT

CODEWORD "PA~~" , PA_TILDETILDE # ( n -- ) GPIO: make pin n a multiplexed push-pull output 
    slli s3 , s3 , 2 
    li t0, R32_GPIOA_CFGLR
    lw t1 , 0(t0) 
    li t2 , 0xf
    sll t2 , t2 , s3 
    xori t2 , t2 , -1 
    and t1 , t1 , t2
    li t2 , 0b1011
    sll t2 , t2 , s3 
    or t1 , t1 , t2
    sw t1 , 0(t0)
    loadtos
    NEXT

.endif 

.if WANT_PORTB

.equ R32_GPIOB_CFGLR   , 0x40010C00
.equ R32_GPIOB_BSHR    , 0x40010C10

CODEWORD "+PB" , PLUS_PB # ( mask -- ) GPIO: Set bits in mask | enable port B clk if mask=0
    bne s3 , zero , 1f 
    li t0, R32_RCC_APB2PCENR
    lw t1, 0(t0)
    li t2 , (1 << 3) 
    or t1, t1, t2 
    sw t1, 0(t0)
    j 2f 
    1:
    li t0 , R32_GPIOB_BSHR
    sw s3 , 0(t0)
    2:
    loadtos
    NEXT 

CODEWORD "-PB" , MINUS_PB # ( mask -- ) GPIO: Clr bits in mask | disable port B clk if mask=0
    bne s3 , zero , 1f 
    li t0, R32_RCC_APB2PCENR
    lw t1, 0(t0)
    li t2 , ~(1 << 3) 
    and t1, t1, t2 
    sw t1, 0(t0)
    j 2f 
    1:
    slli s3 , s3 , 16 
    li t0 , R32_GPIOB_BSHR
    sw s3 , 0(t0)
    2:
    loadtos
    NEXT

CODEWORD "PB~" , PB_TILDE # ( n -- ) GPIO: make pin n a push-pull output 
    slli s3 , s3 , 2 
    li t0, R32_GPIOB_CFGLR
    lw t1 , 0(t0) 
    li t2 , 0xf
    sll t2 , t2 , s3 
    xori t2 , t2 , -1 
    and t1 , t1 , t2
    li t2 , 0b11
    sll t2 , t2 , s3 
    or t1 , t1 , t2
    sw t1 , 0(t0)
    loadtos
    NEXT

.endif 

.if WANT_PORTC

CODEWORD "+PC" , PLUS_PC # ( mask -- ) GPIO: Set bits in mask | enable port C clk if mask=0
    bne s3 , zero , 1f 
    li t0, R32_RCC_APB2PCENR
    lw t1, 0(t0)
    li t2 , (1 << 4) 
    or t1, t1, t2 
    sw t1, 0(t0)
    j 2f 
    1:
    li t0 , R32_GPIOC_BSHR
    sw s3 , 0(t0)
    2:
    loadtos
    NEXT 

CODEWORD "-PC" , MINUS_PC # ( mask -- ) GPIO: Clr bits in mask | enable port C clk if mask=0
    bne s3 , zero , 1f 
    li t0, R32_RCC_APB2PCENR
    lw t1, 0(t0)
    li t2 , ~(1 << 4) 
    and t1, t1, t2 
    sw t1, 0(t0)
    j 2f 
    1:
    slli s3 , s3 , 16 
    li t0 , R32_GPIOC_BSHR
    sw s3 , 0(t0)
    2:
    loadtos
    NEXT

CODEWORD "PC~" , PC_TILDE # ( n -- ) GPIO: make pin n a push-pull output 
    slli s3 , s3 , 2 
    li t0, R32_GPIOC_CFGLR
    lw t1 , 0(t0) 
    li t2 , 0xf
    sll t2 , t2 , s3 
    xori t2 , t2 , -1 
    and t1 , t1 , t2
    li t2 , 0b11
    sll t2 , t2 , s3 
    or t1 , t1 , t2
    sw t1 , 0(t0)
    loadtos
    NEXT

CODEWORD "PC~~" , PC_TILDETILDE # ( n -- ) GPIO: make pin n a multiplexed push-pull output 
    slli s3 , s3 , 2 
    li t0, R32_GPIOC_CFGLR
    lw t1 , 0(t0) 
    li t2 , 0xf
    sll t2 , t2 , s3 
    xori t2 , t2 , -1 
    and t1 , t1 , t2
    li t2 , 0b1011
    sll t2 , t2 , s3 
    or t1 , t1 , t2
    sw t1 , 0(t0)
    loadtos
    NEXT

.endif 


.if WANT_PORTD

CODEWORD "+PD" , PLUS_PD # ( mask -- ) GPIO: Set bits in mask | enable port D clk if mask=0
    bne s3 , zero , 1f 
    li t0, R32_RCC_APB2PCENR
    lw t1, 0(t0)
    li t2 , (1 << 5) 
    or t1, t1, t2 
    sw t1, 0(t0)
    j 2f 
    1:
    li t0 , R32_GPIOD_BSHR
    sw s3 , 0(t0)
    2:
    loadtos
    NEXT 

CODEWORD "-PD" , MINUS_PD # ( mask -- ) GPIO: Clr bits in mask | enable port D clk if mask=0
    bne s3 , zero , 1f 
    li t0, R32_RCC_APB2PCENR
    lw t1, 0(t0)
    li t2 , ~(1 << 5) 
    and t1, t1, t2 
    sw t1, 0(t0)
    j 2f 
    1:
    slli s3 , s3 , 16 
    li t0 , R32_GPIOD_BSHR
    sw s3 , 0(t0)
    2:
    loadtos
    NEXT

CODEWORD "^PD" , TOG_PD # ( mask -- ) GPIO: Toggle pins in mask
    li t0 , R32_GPIOD_OUTDR
    lw t1 , 0(t0)
    and t1 , t1  , s3 
    beq t1 ,zero , 1f
    slli s3 , s3 , 16
    li t0 , R32_GPIOD_BSHR
    sw s3 , 0(t0)
    j 2f
    1:
    li t0 , R32_GPIOD_BSHR
    sw s3 , 0(t0)
    2:
    loadtos 
    NEXT

CODEWORD "PD~" , PD_TILDE # ( n -- ) GPIO: make pin n a push-pull output 
    slli s3 , s3 , 2 
    li t0, R32_GPIOD_CFGLR
    lw t1 , 0(t0) 
    li t2 , 0xf
    sll t2 , t2 , s3 
    xori t2 , t2 , -1 
    and t1 , t1 , t2
    li t2 , 0b11
    sll t2 , t2 , s3 
    or t1 , t1 , t2
    sw t1 , 0(t0)
    loadtos
    NEXT

CODEWORD "PD~~" , PD_TILDETILDE # ( n -- ) GPIO: make pin n a multiplexed push-pull output 
    slli s3 , s3 , 2 
    li t0, R32_GPIOD_CFGLR
    lw t1 , 0(t0) 
    li t2 , 0xf
    sll t2 , t2 , s3 
    xori t2 , t2 , -1 
    and t1 , t1 , t2
    li t2 , 0b1011
    sll t2 , t2 , s3 
    or t1 , t1 , t2
    sw t1 , 0(t0)
    loadtos
    NEXT

CODEWORD "~PD" , TILDE_PD # ( n -- ) GPIO: make pin n a floating input
    slli s3 , s3 , 2 
    li t0, R32_GPIOD_CFGLR
    lw t1 , 0(t0) 
    li t2 , 0xf
    sll t2 , t2 , s3 
    xori t2 , t2 , -1 
    and t1 , t1 , t2
    li t2 , 0b0100
    sll t2 , t2 , s3 
    or t1 , t1 , t2
    sw t1 , 0(t0)
    loadtos
    NEXT

CODEWORD "~~PD" , TILDETILDE_PD # ( n -- ) GPIO: make pin n a floating input with pullup
    slli s3 , s3 , 2 
    li t0 , R32_GPIOD_CFGLR
    lw t1 , 0(t0) 
    li t2 , 0xf
    sll t2 , t2 , s3 
    xori t2 , t2 , -1 
    and t1 , t1 , t2
    li t2 , 0b1000
    sll t2 , t2 , s3 
    or t1 , t1 , t2
    sw t1 , 0(t0)
    srli s3 , s3 , 2  
    li t0 , R32_GPIOD_OUTDR
    lw t1 , 0(t0)
    li t2 , 1
    sll t2 , t2 , s3 
    or t1 , t1 , t2  
    sw t1 , 0(t0) 
    loadtos
    NEXT
.endif




.ifnb
: +PC \# ( mask -- ) GPIO: Set bits in mask | enable port C clk if mask=0
    {
    bne x3 , zero , 1f 
    li t0, R32_RCC_APB2PCENR
    lw t1, 0(t0)
    li t2 , (1 << 4) 
    or t1, t1, t2 
    sw t1, 0(t0)
    j 2f 
    1:
    li t0 , R32_GPIOC_BSHR
    sw x3 , 0(t0)
    2:
    loadtos
    }
;

: -PC \# ( mask -- ) GPIO: Clr bits in mask | disable port C clk if mask=0
    {
    bne x3 , zero , 1f 
    li t0, R32_RCC_APB2PCENR
    lw t1, 0(t0)
    li t2 , ~(1 << 4) 
    and t1, t1, t2 
    sw t1, 0(t0)
    j 2f 
    1:
    slli x3 , x3 , 16 
    li t0 , R32_GPIOC_BSHR
    sw x3 , 0(t0)
    2:
    loadtos
    }
;

: ^PC \# ( mask -- ) GPIO: Toggle pins in mask
    {
    li t0 , R32_GPIOC_OUTDR
    lw t1 , 0(t0)
    and t1 , t1  , x3 
    beq t1 ,zero , 1f
    slli x3 , x3 , 16
    li t0 , R32_GPIOC_BSHR
    sw x3 , 0(t0)
    j 2f
    1:
    li t0 , R32_GPIOC_BSHR
    sw x3 , 0(t0)
    2:
    loadtos 
    }
;

: PC~ ( n -- ) \# GPIO: make pin n a push-pull output 
    {
    slli x3 , x3 , 2 
    li t0, R32_GPIOC_CFGLR
    lw t1 , 0(t0) 
    li t2 , 0xf
    sll t2 , t2 , x3 
    xori t2 , t2 , -1 
    and t1 , t1 , t2
    li t2 , 0b11
    sll t2 , t2 , x3 
    or t1 , t1 , t2
    sw t1 , 0(t0)
    loadtos
    }
;

: ~PC ( n -- ) \# GPIO: make pin n a floating input 
    {
    slli x3 , x3 , 2 
    li t0, R32_GPIOC_CFGLR
    lw t1 , 0(t0) 
    li t2 , 0xf
    sll t2 , t2 , x3 
    xori t2 , t2 , -1 
    and t1 , t1 , t2
    li t2 , 0b0100
    sll t2 , t2 , x3 
    or t1 , t1 , t2
    sw t1 , 0(t0)
    loadtos
    }
;

.endif




