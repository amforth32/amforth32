# SPDX-License-Identifier: GPL-3.0-only
# timer 6 basic timer
# p 255 manual             

.equ R32_RCC_APB1PCENR  , 0x4002101C # APB1 peripheral clock enable register 0x00000000

.equ R32_PFIC_IENR2     , 0xE000E108 # PFIC interrupt enable set register2 [64-95] 
.equ R32_PFIC_IPRR2     , 0xE000E288 # PFIC interrupt pending clear register2
.equ R32_PFIC_IRER2     , 0xE000E188 # PFIC interrupt disable set register2 [64-95] 

.equ R16_TIM6_CTLR1     , 0x40001000 # TIM6 control register1 0x0000
.equ R16_TIM6_CTLR2     , 0x40001004 # TIM6 control register2 0x0000
.equ R16_TIM6_DMAINTENR , 0x4000100C # TIM6 DMA/interrupt enable register 0x0000
.equ R16_TIM6_INTFR     , 0x40001010 # TIM6 interrupt flag register 0x0000
.equ R16_TIM6_SWEVGR    , 0x40001014 # TIM6 event generation register 0x0000
.equ R16_TIM6_CNT       , 0x40001024 # TIM6 counter 0x0000
.equ R16_TIM6_PSC       , 0x40001028 # TIM6 prescaler 0x0000
.equ R16_TIM6_ATRLR     , 0x4000102C # TIM6 auto-reload register 0xFFFF


CONSTANT "#T6" , T6INTNUM , 70 # ( -- u ) TRAP: trap number for timer 6

CODEWORD "+T6.clk" , PLUS_T6_CLK # ( -- ) TIMER6: enable peripheral clock for timer6

         li  t0, R32_RCC_APB1PCENR
         lw  t1, 0(t0)
         ori t1, t1, (1<<4)
         sw  t1, 0(t0)
         NEXT

CODEWORD "-T6.clk" , MINUS_T6_CLK # ( -- ) TIMER6: disable peripheral clock for timer6

         li   t0, R32_RCC_APB1PCENR
         lw   t1, 0(t0)
         andi t1, t1, ~(1<<4)
         sw   t1, 0(t0)
         NEXT

CODEWORD "+T6" , PLUS_T6 # ( -- ) TIMER6: enable timer6 peripheral

         li  t0, R16_TIM6_CTLR1
         lh  t1, 0(t0)
         ori t1, t1, 1
         sh  t1, 0(t0)
         NEXT

CODEWORD "-T6" , MINUS_T6 # ( -- ) TIMER6: disable timer6 peripheral

         li   t0, R16_TIM6_CTLR1
         lh   t1, 0(t0)
         andi t1, t1,~1 
         sh   t1, 0(t0)
         NEXT

CODEWORD "T6@" , T6_FETCH # ( -- u16 ) TIMER6: read counter value

         savetos
         li   t0, R16_TIM6_CNT
         lhu  s3, 0(t0)
         NEXT    

CODEWORD "T6!" , T6_STORE # ( u16 -- ) TIMER6: write counter value

         li   t0, R16_TIM6_CNT
         sh   s3, 0(t0)
         loadtos
         NEXT

CODEWORD "T6.rel@" , T6RLR_FETCH # ( -- u16 ) TIMER6: read reload/comparison value

         savetos
         li   t0, R16_TIM6_ATRLR
         lhu  s3, 0(t0)
         NEXT    

CODEWORD "T6.rel!" , T6RLR_STORE # ( u16 -- ) TIMER6: write reload/comparison value

         li   t0, R16_TIM6_ATRLR
         sh   s3, 0(t0)
         loadtos
         NEXT

# This control flag seems to have no function. autoreload is the default. errata perhaps
# +T6.rel and -T6.rel commented out

# CODEWORD "+T6.rel" , PLUS_T6_REL # ( -- ) TIMER6: enable auto reload 

#           li  t0, R16_TIM6_CTLR1
#           lh  t1, 0(t0)
#           ori t1, t1, (1<<7)
#           sh  t1, 0(t0)
#           NEXT

# CODEWORD "-T6.rel" , MINUS_T6_REL # ( -- ) TIMER6: disable auto reload 

#           li   t0, R16_TIM6_CTLR1
#           lh   t1, 0(t0)
#           andi t1, t1, ~(1<<7)
#           sh   t1, 0(t0)
#           NEXT

CODEWORD "+T6.int" , PLUS_T6_INT # ( -- ) TIMER6: enable interrupt
         
         li   t0, R16_TIM6_DMAINTENR
         lhu  t1, 0(t0)
         ori  t1, t1,1 
         sh   t1, 0(t0)

         li   t0, R32_PFIC_IENR2   # this IS required 
         lw   t1, 0(t0)
         ori  t1, t1, 1 << 6 
         sw   t1, 0(t0)
         
         NEXT

CODEWORD "-T6.int" , MINUS_T6_INT # ( -- ) TIMER6: disable interrupt
         
         li   t0, R16_TIM6_DMAINTENR
         lhu  t1, 0(t0)
         andi  t1, t1,~1 
         sh   t1, 0(t0)

         li   t0, R32_PFIC_IRER2
         lw   t1, 0(t0)
         ori  t1, t1, 1 << 6
         sw   t1, 0(t0)
         
         NEXT


CODEWORD "T6-" , T6_MINUS # ( -- ) TIMER6: clear interrupt flag

         li   t0, R16_TIM6_INTFR
         sw   x0, 0(t0)

#        not necessary to clear pending, left for personal education 
#        li   t0, R32_PFIC_IPRR2
#        lw   t1, 0(t0)
#        li   t2, 1 << 6
#        or   t1, t1, t2
#        sw   t1, 0(t0)

         NEXT

CODEWORD "T6.pre!" , T6_PRE_STORE # ( u16 -- ) TIMER6: write to 16bit prescaler register

         li   t0, R16_TIM6_PSC
         sh   s3, 0(t0)
         loadtos
         
         NEXT

CODEWORD "T6.pre@" , T6_PRE_FETCH # (  -- u16 ) TIMER6: read from 16bit prescaler register

         savetos
         li   t0, R16_TIM6_PSC
         lhu   s3, 0(t0)
         
         NEXT

