# SPDX-License-Identifier: GPL-3.0-only
# clock.S

.globl HSE96

.text

.equ RCC_CTLR        , 0x40021000 # Clock control register 0x0000xx83
.equ RCC_CFGR0       , 0x40021004 # Clock configuration register 0 0x00000000
.equ RCC_INTR        , 0x40021008 # Clock interrupt register 0x00000000
.equ RCC_APB2PRSTR   , 0x4002100C # APB2 peripheral reset register 0x00000000
.equ RCC_APB1PRSTR   , 0x40021010 # APB1 peripheral reset register 0x00000000
.equ RCC_AHBPCENR    , 0x40021014 # AHB peripheral clock enable register 0x00000014
.equ RCC_APB2PCENR   , 0x40021018 # APB2 peripheral clock enable register 0x00000000
.equ RCC_APB1PCENR   , 0x4002101C # APB1 peripheral clock enable register 0x00000000
.equ RCC_BDCTLR      , 0x40021020 # Backup domain control register 0x00000000
.equ RCC_RSTSCKR     , 0x40021024 # Control/status register 0x0C000000
.equ RCC_AHBRSTR     , 0x40021028 # AHB peripheral reset register 0x00000000
.equ RCC_CFGR2       , 0x4002102C # Clock configuration register 2 0x00000000 

HSE96:

.ifnb 
    addi    sp,sp,-32
    sw  s0,28(sp)
    addi    s0,sp,32
    sw  zero,-20(s0)
    sw  zero,-24(s0)
.endif

     li  t0  , RCC_CTLR          # start HSI first  
     lw  t1  , 0(t0) 
     li  t2  , 0x00000001        # could use ori but want pattern         
     or  t2  , t1 , t2 
     sw  t2  , 0(t0)

     li  t3  , RCC_CFGR0         # ?? HSI with no PLL and no dividers
     lw  t4  , 0(t3)
     #li  t5  , 0xF87F0000   # a trial
     li  t5  , 0xF8FF0000 # this WORKS please do not delete this
     and t5  , t4 , t5
     sw  t5  , 0(t3)

     lw  t1  , 0(t0)
     li  t2  , 0xFEF6FFFF        # ?? 
     and t2  , t1 , t2 
     sw  t2  , 0(t0)
     
     lw  t1  , 0(t0)
     li  t2  , 0xFFFBFFFF        # ?? do not bypase HSE
     and t2  , t1 , t2 
     sw  t2  , 0(t0)

     lw  t4  , 0(t3)             # ?? no USB clk div + PLL config OK
     li  t5  , 0xFF80FFFF
     and t5  , t4 , t5
     sw  t5  , 0(t3)

# CH32V30x_D8C

     li  t0  , RCC_CTLR          
     lw  t1  , 0(t0) 
     li  t2  , 0xEBFFFFFF
     and t2  , t1 , t2 
     sw  t2  , 0(t0)

     li  t0  , RCC_INTR
     li  t2  , 0x00FF0000
     sw  t2  , 0(t0)

     li  t0  , RCC_CFGR2
     li  t2  , 0x00000000
     sw  t2  , 0(t0)

# now bringing up the external oscillator 
    
     li  t0  , RCC_CTLR          # start HSE OK
     lw  t1  , 0(t0) 
     li  t2  , (1<<16)           # HSEON
     or  t2  , t1 , t2 
     sw  t2  , 0(t0)

     li  t2  , (1<<17)           # HSERDY     OK
1:   lw  t1  , 0(t0)             # RCC_CTLR already in t0 
     and t1  , t1 , t2
     beq t1  , zero , 1b         # wait on HSERDY set
    
    # two OR with zero removed leaving 
        
    lw  t4  , 0(t3)             # RCC_CFGR0 already in t3 
    li  t5  , 0x00000400        # RCC_PPRE1_DIV2
    or  t5  , t4 , t5
    sw  t5  , 0(t3)

#                RCC_PLLSRC RCC_PLLXTRE PCC_PLLMULL 
.equ PLLCLEAR , ~(0x00010000 | 0x00020000 | 0x003C0000 )

     lw  t4  , 0(t3)             # RCC_CFGR0 already in t3 
     li  t5  , PLLCLEAR          #
     and  t5  , t4 , t5
     sw  t5  , 0(t3)

# (RCC_PLLSRC_HSE | RCC_PLLXTPRE_HSE | RCC_PLLMULL12_EXTEN)
.equ PLLSETUP , (0x00010000 | 0x00000000 | 0x00280000)

     lw  t4  , 0(t3)             # RCC_CFGR0 already in t3 
     li  t5  , PLLSETUP          #
     or  t5  , t4 , t5
     sw  t5  , 0(t3)

# ----------------------------------------------------------------------
# this is where the issue seems to start with t0...
        
.ifnb YES # this is from the .list file and "works" 

    lui	a5,0x40021
 	lw	a3,0(a5) # 40021000 <R32_RCC_CTLR>
 	lui	a5,0x40021
 	lui	a4,0x1000
 	or	a4,a3,a4
 	sw	a4,0(a5) # 40021000 <R32_RCC_CTLR>
    
.else    # I would like to use t0.. but it crashes
    
    #lui t0, 0x40021 
    #li  t0  , RCC_CTLR
    #lw  t2  , 0(t0)             # RCC_CTRL already in t0 OK
    #li  t1  , (1<<24)           # PLLON
    #or  t2  , t1 , t2
    #sw  t2  , 0(t0)             #

    # try rep a3 with t1       # Trying to get to the bottom
       lui a5 , 0x40021        # of why this will not work. 
       lw t2  , 0(a5)          # loading to tn seems to cause
       lui a5 , 0x40021        # a hang. I don't think it is
       lui t1 , 0x1000         # an interrupt (t0..t2) overwrite 
       or t1 , t2, t1          # as it will hang with t4 or t6 
       sw t1 , 0(a5)           # which are not used in handler
    
.endif    

.ifnb   # compiler code - notice the repeat loads
    
6:    
    lui a5,0x40021
    lw  a4,0(a5) # 40021000 <R32_RCC_CTLR>
    lui a5,0x2000
    and a5,a4,a5
    beqz    a5,6b # 4444 <SetSysClockTo96_HSE+0x114>

.else
1:   li  t2  , (1<<25)           # PLLRDY  Hanging here
     li  t0  , RCC_CTLR
     lw  t1  , 0(t0)             # RCC_CTLR already in t0 
     and t1  , t1 , t2
     beq t1  , zero , 1b         # wait on PLLRDY set
.endif

# ----------------------------------------------------------------------
    
    lw  t4  , 0(t3)             # RCC_CFGR0 already in t3 
    li  t5  , ~(0b11)           # clear in prep for below
    and t5  , t4 , t5
    sw  t5  , 0(t3)

    lw  t4  , 0(t3)             # RCC_CFGR0 already in t3 
    li  t5  , 0b10              # clear in prep for below
    or  t5  , t4 , t5           # set PLL as system clock
    sw  t5  , 0(t3)
    
    li   t5  , 0b1100           # which clock is in use
1:  lw   t4  , 0(t3)            # RCC_CFGR0 already in t3
    and  t4  , t4 , t5          # looking for PLL = 0b1000
    andi t4  , t4,  8 
    beq  t4  , zero , 1b        # wait on clock is PLL 

5:
    nop
.ifnb  
    lw  s0,28(sp)
    addi    sp,sp,32
.endif    
    ret
    
