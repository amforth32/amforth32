# SPDX-License-Identifier: GPL-3.0-only
# timer 6 basic timer
# p 255 manual             

.equ R32_RCC_APB1PCENR  , 0x4002101C # APB1 peripheral clock enable register 0x00000000

.equ R32_PFIC_IENR2     , 0xE000E108 # PFIC interrupt enable set register2 [64-95] 
.equ R32_PFIC_IPRR2     , 0xE000E288 # PFIC interrupt pending clear register2
.equ R32_PFIC_IRER2     , 0xE000E188 # PFIC interrupt disable set register2 [64-95] 

.equ R16_TIM8_CTLR1     , 0x40013400 # Control register1 0x0000
.equ R16_TIM8_CTLR2     , 0x40013404 # Control register2 0x0000
.equ R16_TIM8_SMCFGR    , 0x40013408 # Slave mode configuration register 0x0000
.equ R16_TIM8_DMAINTENR , 0x4001340C # DMA/interrupt enable register 0x0000
.equ R16_TIM8_INTFR     , 0x40013410 # Interrupt flag register 0x0000
.equ R16_TIM8_SWEVGR    , 0x40013414 # Event generation register 0x0000
.equ R16_TIM8_CHCTLR1   , 0x40013418 # Compare/capture control register1 0x0000
.equ R16_TIM8_CHCTLR2   , 0x4001341C # Compare/capture control register2 0x0000
.equ R16_TIM8_CCER      , 0x40013420 # Compare/capture enable register 0x0000
.equ R16_TIM8_CNT       , 0x40013424 # Counter 0x0000
.equ R16_TIM8_PSC       , 0x40013428 # Prescaler 0x0000
.equ R16_TIM8_ATRLR     , 0x4001342C # Auto-reload register 0xFFFF
.equ R16_TIM8_RPTCR     , 0x40013430 # Repeat count register 0x0000
.equ R16_TIM8_CH1CVR    , 0x40013434 # Compare/capture register1 0x0000
.equ R16_TIM8_CH2CVR    , 0x40013438 # Compare/capture register2 0x0000
.equ R16_TIM8_CH3CVR    , 0x4001343C # Compare/capture register3 0x0000
.equ R16_TIM8_CH4CVR    , 0x40013440 # Compare/capture register4 0x0000
.equ R16_TIM8_BDTR      , 0x40013444 # Break and deadband register 0x0000
.equ R16_TIM8_DMACFGR   , 0x40013448 # DMA configuration register 0x0000
.equ R16_TIM8_DMAADR    , 0x4001344C # DMA address register in continuous mode 0x0000 

# CONSTANT "#T6" , T6INTNUM , 70 # ( -- u ) TRAP: trap number for timer 6

CODEWORD "+T8.clk" , PLUS_T8_CLK # ( -- ) TIMER8: enable peripheral clock for timer8

         li  t0, R32_RCC_APB1PCENR
         lw  t1, 0(t0)
         ori t1, t1, (1<<8)
         sw  t1, 0(t0)
         NEXT

CODEWORD "-T8.clk" , MINUS_T8_CLK # ( -- ) TIMER8: disable peripheral clock for timer8

         li   t0, R32_RCC_APB1PCENR
         lw   t1, 0(t0)
         andi t1, t1, ~(1<<8)
         sw   t1, 0(t0)
         NEXT

CODEWORD "+T8" , PLUS_T8 # ( -- ) TIMER8: enable timer8 peripheral

         li  t0, R16_TIM8_CTLR1
         lh  t1, 0(t0)
         ori t1, t1, 1
         sh  t1, 0(t0)
         NEXT

CODEWORD "-T8" , MINUS_T8 # ( -- ) TIMER8: disable timer8 peripheral

         li   t0, R16_TIM8_CTLR1
         lh   t1, 0(t0)
         andi t1, t1,~1 
         sh   t1, 0(t0)
         NEXT

# 
CODEWORD "T8@" , T8_FETCH # ( -- u16 ) TIMER8: read counter value

         savetos
         li   t0, R16_TIM8_CNT
         lhu  s3, 0(t0)
         NEXT    

CODEWORD "T8!" , T8_STORE # ( u16 -- ) TIMER8: write counter value

         li   t0, R16_TIM8_CNT
         sh   s3, 0(t0)
         loadtos
         NEXT

CODEWORD "T8.rel@" , T8RLR_FETCH # ( -- u16 ) TIMER8: read reload/comparison value

         savetos
         li   t0, R16_TIM8_ATRLR
         lhu  s3, 0(t0)
         NEXT    

CODEWORD "T8.rel!" , T8RLR_STORE # ( u16 -- ) TIMER8: write reload/comparison value

         li   t0, R16_TIM8_ATRLR
         sh   s3, 0(t0)
         loadtos
         NEXT


CODEWORD "T8.cc1!" , T8CC1_STORE # ( u16 -- ) TIMER8: write comparison register 1 

         li   t0, R16_TIM8_CH1CVR
         sh   s3, 0(t0)
         loadtos
         NEXT


CODEWORD "+T8.cc1" , PLUS_T8CC1 # ( u16 -- ) TIMER8: enable cc output  

         li   t0, R16_TIM8_CCER
         lh   t1, 0(t0)
         ori  t1, t1 , 1
         sh   t1, 0(t0)
         NEXT


CODEWORD "+T8.pwm1" , PLUS_T8PWM1 #
         li  t0, R16_TIM8_CHCTLR1
         lh  t1, 0(t0)
         ori t1, t1, 0b1101000
         sh   t1, 0(t0)
         NEXT

CODEWORD "+T8.ug" , PLUS_T8UG #
         li  t0, R16_TIM8_SWEVGR 
         lh  t1, 0(t0)
         ori t1, t1, 0b1
         sh   t1, 0(t0)
         NEXT


# This control flag seems to have no function. autoreload is the default. errata perhaps
# +T6.rel and -T6.rel commented out

CODEWORD "+T8.rel" , PLUS_T8_REL # ( -- ) TIMER8: enable auto reload 

           li  t0, R16_TIM8_CTLR1
           lh  t1, 0(t0)
           ori t1, t1, (1<<7)
           sh  t1, 0(t0)
           NEXT

CODEWORD "-T8.rel" , MINUS_T8_REL # ( -- ) TIMER8: disable auto reload 

           li   t0, R16_TIM8_CTLR1
           lh   t1, 0(t0)
           andi t1, t1, ~(1<<7)
           sh   t1, 0(t0)
           NEXT

# TWTW commented out

# CODEWORD "+T6.int" , PLUS_T6_INT # ( -- ) TIMER6: enable interrupt
         
#          li   t0, R16_TIM6_DMAINTENR
#          lhu  t1, 0(t0)
#          ori  t1, t1,1 
#          sh   t1, 0(t0)

#          li   t0, R32_PFIC_IENR2   # this IS required 
#          lw   t1, 0(t0)
#          ori  t1, t1, 1 << 6 
#          sw   t1, 0(t0)
         
#          NEXT

# CODEWORD "-T6.int" , MINUS_T6_INT # ( -- ) TIMER6: disable interrupt
         
#          li   t0, R16_TIM6_DMAINTENR
#          lhu  t1, 0(t0)
#          andi  t1, t1,~1 
#          sh   t1, 0(t0)

#          li   t0, R32_PFIC_IRER2
#          lw   t1, 0(t0)
#          ori  t1, t1, 1 << 6
#          sw   t1, 0(t0)
         
#          NEXT


# CODEWORD "T6-" , T6_MINUS # ( -- ) TIMER6: clear interrupt flag

#          li   t0, R16_TIM6_INTFR
#          sw   x0, 0(t0)

# #        not necessary to clear pending, left for personal education 
# #        li   t0, R32_PFIC_IPRR2
# #        lw   t1, 0(t0)
# #        li   t2, 1 << 6
# #        or   t1, t1, t2
# #        sw   t1, 0(t0)

#          NEXT

CODEWORD "T8.pre!" , T8_PRE_STORE # ( u16 -- ) TIMER8: write to 16bit prescaler register

         li   t0, R16_TIM8_PSC
         sh   s3, 0(t0)
         loadtos
         
         NEXT

CODEWORD "T8.pre@" , T8_PRE_FETCH # (  -- u16 ) TIMER8: read from 16bit prescaler register

         savetos
         li   t0, R16_TIM8_PSC
         lhu   s3, 0(t0)
         
         NEXT

