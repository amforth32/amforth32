# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "cold", COLD /* ( i*x -- )(R: j*y -- ) assembler part of the boot sequence, starting the VM */
/* This is assembly part of the startup sequence that creates the basic runtime environment for the virtual machine.
   It sets up the hardware, the stack pointers and the forth registers for the WARM word, 
   then boots the virtual machine by jumping to the inner interpreter.

   MCUs may override this to inject additional initialization at specific points.
*/

  # set up the clock system and make it run
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

.ifnb 
     li  t0  , RCC_CTLR          # start HSI first  
     lw  t1  , 0(t0) 
     li  t2  , 0x00000001        # could use ori but want pattern         
     or  t2  , t1 , t2 
     sw  t2  , 0(t0)

     li  t3  , RCC_CFGR0         # ?? HSI with no PLL and no dividers
     lw  t4  , 0(t3)
     li  t5  , 0xF8FF0000
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

     jal qtest

.endif
.ifnb 

     # move towards HSE

     li  t0  , RCC_CTLR          # start HSE OK
     lw  t1  , 0(t0) 
     li  t2  , (1<<16)           # HSEON
     or  t2  , t1 , t2 
     sw  t2  , 0(t0)

     li  t2  , (1<<17)           # HSERDY     OK
1:   lw  t1  , 0(t0)             # RCC_CTLR already in t0 
     and t1  , t1 , t2
     beq t1  , zero , 1b         # wait on HSERDY set


     lw  t4  , 0(t3)             # RCC_CFGR0 already in t3 OK
     li  t5  , 0x00000000        # RCC_HPRE_DIV1
     or  t5  , t4 , t5
     sw  t5  , 0(t3)

     lw  t4  , 0(t3)             # RCC_CFGR0 already in t3 
     li  t5  , 0x00000000        # RCC_PPRE2_DIV1
     or  t5  , t4 , t5
     sw  t5  , 0(t3)

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

     lw  t2  , 0(t0)             # RCC_CTRL already in t0 OK
     li  t1  , (1<<24)           # PLLON
     or  t2  , t1 , t2
     sw  t2  , 0(t0)             #
     
# 16..12...8...4...0    
# 110110010110000011

     li  t2  , (1<<25)           # PLLRDY  Hanging here    
1:   lw  t1  , 0(t0)             # RCC_CTLR already in t0 
     and t1  , t1 , t2
     beq t1  , zero , 1b         # wait on PLLRDY set

     lw  t4  , 0(t3)             # RCC_CFGR0 already in t3 
     li  t5  , ~(0b11)           # clear in prep for below
     and t5  , t4 , t5
     sw  t5  , 0(t3)

     lw  t4  , 0(t3)             # RCC_CFGR0 already in t3 
     li  t5  , 0b10              # clear in prep for below
     or  t5  , t4 , t5           # set PLL as system clock
     sw  t5  , 0(t3)
     
#      li   t5  , 0b1100           # which clock is in use
# 1:   lw   t4  , 0(t3)            # RCC_CFGR0 already in t3
#      and  t4  , t4 , t5          # looking for PLL = 0b1000
#      addi t4  , t4 , -8          # 
#      bne  t4  , zero , 1b        # wait on clock is PLL 

       li t5 , 96000000
1:     addi t5, t5, -1
       bne t5,zero,1b 
       lw t4 , 0(t3) 
        
.endif 

  # This is the same as in quit, in order to prepare for whatever the user might want to do within "init".

  la s5, RAM_upper_returnstack
  la s4, RAM_upper_datastack # TW hack
.if WANT_DEBUGGER == YES
  mv s7, zero # zero out the DEBUG register
.endif

# BEG COM TW FIXME
  .ifdef initflash
  call initflash
  .endif
# END COM TW FIXME 

  lui  s1,      %hi(XT_WARM)
  addi s1, s1,  %lo(XT_WARM)

ant:

  # la s1, XT_WARM

  j DO_EXECUTE
END COLD
