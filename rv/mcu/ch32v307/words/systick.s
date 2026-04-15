# SPDX-License-Identifier: GPL-3.0-only
# systick! systick@ counter reg
# systick!! systick@@ comparison reg
# #systick disable interrupts 

CODEWORD "systick@" , SYSTICK_FETCH # ( -- d ) SYSTICK: returns current value of systick

     .equ STK_CNTH , 0xE000F00C
     .equ STK_CNTL , 0xE000F008

     savetos           # extend and copy up TOS  
     addi s4 , s4 , -4 # extend the stack

     li t0 , STK_CNTL

1:   lw t1 , 4(t0)     # Read high word (A)
     lw t2 , 0(t0)     # Low word
     lw t3 , 4(t0)     # Read high word again (B)
     bne t1 , t3 , 1b  # If (A)!=(B) do it again

     sw t2 , 0(s4)     # Move low word to NOS
     mv s3 , t1        # Move high word to TOS

     NEXT

CODEWORD "systick!" , SYSTICK_STORE # ( d -- ) SYSTICK: writes current value of systick
     
     li t0 , STK_CNTL
     sw s3 , 4(t0)
     loadtos
     sw s3 , 0(t0)
     loadtos
     NEXT 
     

CODEWORD "systick.init" , SYSTICK_INIT # ( -- ) SYSTICK: configures (12E6-1)...0 counter 

     .equ R32_STK_CTLR  , 0xE000F000
     .equ R32_STK_CMPLR , 0xE000F010 

     li t0 , R32_STK_CMPLR   # load top count 
     li t1 , 12000000-1      # 96E6/8 - 1  
     sw t1 , 0(t0)           

     sw zero, 4(t0) 
     

     li t0 , R32_STK_CTLR    # configure
#     li t1 , 0b111011        # 1/8 , down , enable
#     li t1 , 0b101011        # 1/8 , up , enable
     li t1 , 0b101010        # 1/8 , up 
     sw t1 , 0(t0)           # store it 

     NEXT 

CODEWORD "systick.bug" , SYSTICK_BUG # ( -- ) SYSTICK: configures (12E6-1)...0 counter 

     .equ R32_STK_CTLR  , 0xE000F000
     .equ R32_STK_CMPLR , 0xE000F010 

     li t0 , R32_STK_CMPLR   # load top count 
#     li t1 , 2000000-1      # 96E6/8 - 1

     lw t1 , 0(s4)
     addi s4, s4, 4
     sw t1 , 0(t0)
     sw s3 , 4(t0)     

#     sw s3 , 0(t0)
#     sw zero, 4(t0) 
     

     li t0 , R32_STK_CTLR    # configure
#     li t1 , 0b111011        # 1/8 , down , enable
#     li t1 , 0b101011        # 1/8 , up , enable
     li t1 , 0b101010        # 1/8 , up 
     sw t1 , 0(t0)           # store it 
     loadtos
     NEXT 

CODEWORD "systick.12" , SYSTICK_12 # ( -- ) SYSTICK: configures [0..FFFFFFFF] 12MHz rollover counter

     .equ R32_STK_CTLR  , 0xE000F000
     .equ R32_STK_CMPLR , 0xE000F010 

     li t0   , R32_STK_CMPLR   
     sw zero , 0(t0)
     sw zero , 4(t0) 
     

     li t0 , R32_STK_CTLR    # configure
#     li t1 , 0b111011        # 1/8 , down , enable
#     li t1 , 0b101011        # 1/8 , up , enable
     li t1 , 0b100010        # 1/8 , up 
     sw t1 , 0(t0)           # store it 
     NEXT


CODEWORD "systick.rel!" , SYSTICK_REL_STORE # ( d -- ) SYSTICK: write d to accumulator

     li t0  , R32_STK_CMPLR   # load top count 
     lw t1  , 0(s4)           # LSW is NOS
     addi s4, s4, 4           # constract stack 
     sw t1  , 0(t0)           # LSW is NOS (store)
     sw s3  , 4(t0)           # MSW is TOS (store) 
     loadtos 
     NEXT

CODEWORD "systick.rel@" , SYSTICK_REL_FETCH # ( -- d ) SYSTICK: write d to accumulator
     li t0  , R32_STK_CMPLR   # load top count 
     savetos
     lw s3, 0(t0)
     savetos
     lw s3, 4(t0)
     NEXT
     
CODEWORD "systick?" , SYSTICKQ # ( -- f ) SYSTICK: f is true if software flag set
    savetos

    li t0 , R32_STK_CTLR    # a
    lw t1 , 4(t0)           # system count status reg 
    mv s3 , zero            # set TOS to false
    beq t1, zero, 1f        # if zero, count not reached, branch
    li s3 , -1              # count reached set TOS to true  
1:    
    NEXT 

CODEWORD "systick-" , SYSTICKMINUS # ( -- ) SYSTICK: clear systick software flag 

    li t0 , R32_STK_CTLR    # a
    sw zero , 4(t0)         # store zero in system count status reg

    li t2 , 1<<12 
    la t0 , 0xE000E280      # attempt to clear write 1 or 0 ?
    or t1 , t1 , t2 
    sw t1 , 0(t0)           # PFIC_IPRR1 
    
    NEXT 

CODEWORD "-systick" , MINUSSYSTICK # ( -- ) SYSTICK: disable systick module

    li t0 , R32_STK_CTLR    # a
    lw t1 , 0(t0)           # [a]
    li t2 , 0xFFFFFFFE      # %1 invert 32 bit
    and t1 , t1, t2 
    sw t1 , 0(t0)
    
    NEXT 

CONSTANT "#systick" , HASH_SYSTICK, 12 # ( -- u ) TRAP: trap number for systick interrupt

CODEWORD "+systick.int" , PLUS_SYSTICK_INT # ( -- ) SYSTICK: enable systick interrupt

    li t2 , (1<<12)         # 
    li t0 , 0xE000E100      # a PFIC_IENR0
    lw t1 , 0(t0)
    or t1 , t1 , t2 
    sw t1 , 0(t0)           # [a]
    NEXT

CODEWORD "-systick.int" , MINUS_SYSTICK_INT # ( -- ) SYSTICK: disable systick interrupt

    li  t2 , 1<<12           # 
    li  t0 , 0xE000E180      # a PFIC_IRER0
    lw  t1 , 0(t0)
    or  t1 , t1 , t2 
    sw  t1 , 0(t0)           # [a]
    NEXT

CODEWORD "+systick" , PLUSSYSTICK # ( -- ) SYSTICK: enable systick module

    li t0 , R32_STK_CTLR    # a
    lw t1 , 0(t0)           # [a]
    li t2 , 0b1             # %1 
    or t1 , t1, t2 
    sw t1 , 0(t0) 
    NEXT 

# ----------------------------------------------------------------------
COLON "systime", SYSTIME      # ( xt -- ) SYSTICK: time elasped executing xt (in 12MHz ticks) 
	.word XT_MINUSSYSTICK
	.word XT_SYSTICK_12
	.word XT_ZERO
	.word XT_ZERO
	.word XT_SYSTICK_STORE
	.word XT_PLUSSYSTICK
	.word XT_SYSTICK_FETCH
	.word XT_2TO_R
	.word XT_EXECUTE
	.word XT_SYSTICK_FETCH
	.word XT_2R_FROM
	.word XT_DMINUS
	.word XT_EXIT
# ----------------------------------------------------------------------
      
            
