# SPDX-License-Identifier: GPL-3.0-only
# timer 9 advanced timer
# chapter 14 
# p 255 manual             

.equ R32_RCC_APB2PCENR  , 0x40021018
.equ R32_PFIC_IENR2     , 0xE000E108 # PFIC interrupt enable set register2 [64-95] 
.equ R32_PFIC_IPRR2     , 0xE000E288 # PFIC interrupt pending clear register2
.equ R32_PFIC_IRER2     , 0xE000E188 # PFIC interrupt disable set register2 [64-95] 

.equ R16_TIM9_CTLR1     , 0x40014C00 # Control register1 0x0000
.equ R16_TIM9_CTLR2     , 0x40014C04 # Control register2 0x0000
.equ R16_TIM9_SMCFGR    , 0x40014C08 # Slave mode configuration register 0x0000
.equ R16_TIM9_DMAINTENR , 0x40014C0C # DMA/interrupt enable register 0x0000
.equ R16_TIM9_INTFR     , 0x40014C10 # Interrupt flag register 0x0000
.equ R16_TIM9_SWEVGR    , 0x40014C14 # Event generation register 0x0000
.equ R16_TIM9_CHCTLR1   , 0x40014C18 # Compare/capture control register1 0x0000
.equ R16_TIM9_CHCTLR2   , 0x40014C1C # Compare/capture control register2 0x0000
.equ R16_TIM9_CCER      , 0x40014C20 # Compare/capture enable register 0x0000
.equ R16_TIM9_CNT       , 0x40014C24 # Counter 0x0000
.equ R16_TIM9_PSC       , 0x40014C28 # Prescaler 0x0000
.equ R16_TIM9_ATRLR     , 0x40014C2C # Auto-reload register 0xFFFF
.equ R16_TIM9_RPTCR     , 0x40014C30 # Repeat count register 0x0000
.equ R16_TIM9_CH1CVR    , 0x40014C34 # Compare/capture register1 0x0000
.equ R16_TIM9_CH2CVR    , 0x40014C38 # Compare/capture register2 0x0000
.equ R16_TIM9_CH3CVR    , 0x40014C3C # Compare/capture register3 0x0000
.equ R16_TIM9_CH4CVR    , 0x40014C40 # Compare/capture register4 0x0000
.equ R16_TIM9_BDTR      , 0x40014C44 # Break and deadband register 0x0000
.equ R16_TIM9_DMACFGR   , 0x40014C48 # DMA configuration register 0x0000
.equ R16_TIM9_DMAADR    , 0x40014C4C # DMA address register in continuous mode 0x0000


# CONSTANT "#T6" , T6INTNUM , 70 # ( -- u ) TRAP: trap number for timer 6

CODEWORD "+T9.clk" , PLUS_T9_CLK # ( -- ) TIMER9: enable peripheral clock for timer8

         li  t0, R32_RCC_APB2PCENR
         li  t1, (1<<19)
         lw  t2, 0(t0)
         or  t1, t1, t2
         sw  t1, 0(t0)
         NEXT

CODEWORD "-T9.clk" , MINUS_T9_CLK # ( -- ) TIMER8: disable peripheral clock for timer8

         li  t0, R32_RCC_APB2PCENR
         li  t1, ~(1<<19)
         lw  t2, 0(t0)
         and t1, t1, t2
         sw  t1, 0(t0)
         NEXT

CODEWORD "+T9" , PLUS_T9 # ( -- ) TIMER8: enable timer8 peripheral

         li  t0, R16_TIM9_CTLR1
         lh  t1, 0(t0)
         ori t1, t1, 1
         sh  t1, 0(t0)
         NEXT

CODEWORD "-T9" , MINUS_T9 # ( -- ) TIMER8: disable timer8 peripheral

         li   t0, R16_TIM9_CTLR1
         lh   t1, 0(t0)
         andi t1, t1,~1 
         sh   t1, 0(t0)
         NEXT

 
CODEWORD "T9@" , T9_FETCH # ( -- u16 ) TIMER8: read counter value

         savetos
         li   t0, R16_TIM9_CNT
         lhu  s3, 0(t0)
         NEXT    

CODEWORD "T9.flag@" , T9FLAG_FETCH # ( -- u16 ) TIMER8: read counter value

         savetos
         li   t0, R16_TIM9_INTFR
         lhu  s3, 0(t0)
         NEXT    


CODEWORD "T9!" , T9_STORE # ( u16 -- ) TIMER8: write counter value

         li   t0, R16_TIM9_CNT
         sh   s3, 0(t0)
         loadtos
         NEXT

CODEWORD "T9.rel@" , T9RLR_FETCH # ( -- u16 ) TIMER8: read reload/comparison value

         savetos
         li   t0, R16_TIM9_ATRLR
         lhu  s3, 0(t0)
         NEXT    

CODEWORD "T9.rel!" , T9RLR_STORE # ( u16 -- ) TIMER8: write reload/comparison value

         li   t0, R16_TIM9_ATRLR
         sh   s3, 0(t0)
         loadtos
         NEXT


CODEWORD "T9.cc1!" , T9CC1_STORE # ( u16 -- ) TIMER8: write comparison register 1 

         li   t0, R16_TIM9_CH1CVR
         sh   s3, 0(t0)
         loadtos
         NEXT


CODEWORD "+T9.cc1" , PLUS_T9CC1 # ( u16 -- ) TIMER8: enable cc output  

         li   t0, R16_TIM9_CCER
         lh   t1, 0(t0)
         ori  t1, t1 , 1
         sh   t1, 0(t0)
         NEXT

CODEWORD "+T9.cc1n" , PLUS_T9CC1N # ( u16 -- ) TIMER8: enable cc complementary output  

         li   t0, R16_TIM9_CCER
         lh   t1, 0(t0)
         ori  t1, t1 , 0b100
         sh   t1, 0(t0)
         NEXT

CODEWORD "+T9.moe" , PLUS_T9MOE # ( -- )

         li  t0, R16_TIM9_BDTR
         li  t1, (1<<15)
         lw  t2, 0(t0)
         or  t1, t1, t2
         sw  t1, 0(t0)
         NEXT


CODEWORD "+T9.pwm1" , PLUS_T9PWM1 #
         li   t0, R16_TIM9_CHCTLR1
         lh   t1, 0(t0)
         andi t1, t1,  ~(0b01111000)
                         # 76543210  
         ori  t1, t1,    0b01101000
         sh   t1, 0(t0)
         NEXT

CODEWORD "+T9.ug" , PLUS_T9UG #
         li  t0, R16_TIM9_SWEVGR 
         lh  t1, 0(t0)
         ori t1, t1, 0b1
         sh   t1, 0(t0)
         NEXT


# This control flag seems to have no function. autoreload is the default. errata perhaps
# +T6.rel and -T6.rel commented out

CODEWORD "+T9.rel" , PLUS_T9_REL # ( -- ) TIMER8: enable auto reload 

           li  t0, R16_TIM9_CTLR1
           lh  t1, 0(t0)
           ori t1, t1, (1<<7)
           sh  t1, 0(t0)
           NEXT

CODEWORD "-T9.rel" , MINUS_T9_REL # ( -- ) TIMER8: disable auto reload 

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

CODEWORD "T9.pre!" , T9_PRE_STORE # ( u16 -- ) TIMER8: write to 16bit prescaler register

         li   t0, R16_TIM9_PSC
         sh   s3, 0(t0)
         loadtos
         
         NEXT

CODEWORD "T9.pre@" , T9_PRE_FETCH # (  -- u16 ) TIMER8: read from 16bit prescaler register

         savetos
         li   t0, R16_TIM9_PSC
         lhu   s3, 0(t0)
         
         NEXT

