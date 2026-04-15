# SPDX-License-Identifier: GPL-3.0-only

#------------------------------------------------------------------------------
  CODEWORD  "s>d", S2D /* ( n -- d ) converts n to double cell d (MSB cell is higher in the stack) */
#------------------------------------------------------------------------------
  savetos
  srai s3, s3, 31    # Turn MSB into 0xffffffff or 0x00000000
  NEXT
END S2D

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# Obviously, this is C code and not assembly code. It will not work here, but
# it is the best place to keep it incase (a) it is needed again (b) I need to
# use another C function and want to recall the order of the arguments and how
# to "return" values into the memory space occupied by the datastack s4. 

.ifnb
//                         TOS          NOS          3            4 
int c_udslashmod(uint32_t *mem, uint32_t a , uint32_t b , uint32_t c , uint32_t d )
// STACK PATTERN FROM RIGHT TO LEFT 
//          -- u1h u1l u2h u2l   
//          -- a   b   c   d  
{
  uint64_t numerator   = c * 0x100000000 + d ;
  uint64_t denominator = a * 0x100000000 + b ;
  
  uint64_t q = numerator / denominator ;
  uint64_t r = numerator % denominator ;  
  

  *(mem+2) = (r & 0xFFFFFFFF) ;
  *(mem+1) = (r >> 32 ) & 0xFFFFFFFF ;
  *(mem+0) = (q & 0xFFFFFFFF) ;
  
  return (q >> 32) & 0xFFFFFFFF ; 
}

CODEWORD "ud/mod" , UDSLASHMOD # ( a b c -- c)
    addi a0 , s4 , 0  # by chance, a balanced operation
    mv a1 , s3        # TOS 
    lw a2 , 0(s4)     # NOS
    lw a3 , 4(s4)     # 3 
    lw a4 , 8(s4)     # 4 
    addi s4 , s4 , 0  # by chance, a balanced operation
    jal c_udslashmod  # *mem TOS NOS 3 4
    mv s3 , a0        # return TOS is a0 
    NEXT
.endif
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
  CODEWORD  "ud/mod", UDSLASHMOD /* (ud1 ud2 -- ud3 ud4 ) ud3 remainder, ud4 quotient of ud1 / ud2 */
#------------------------------------------------------------------------------
# TODO: why use s7/s8 as temporary registers?
.macro addc dest, sour1, sour2
  add t2, \sour1, \sour2
  sltu s7, t2, \sour1
  add \dest, t2, t0
  sltu s8, \dest, t2
  or t0, s7, s8
.endm

.macro subc dest, sour1, sour2
  sub t2, \sour1, \sour2
  sltu s7, \sour1, \sour2
  sub \dest, t2, t0
  sltu s8, t2, t0
  or t0, s7, s8
.endm

ud_slash_mod:


   # ( DividendL DividendH DivisorL DivisorH -- RemainderL RemainderH ResultL ResultH )
   #   8         4         0        tos      -- 8          4          0       tos


   # Shift-High Shift-Low Dividend-High Dividend-Low
   #        a3       a2           a1          a0

  addi s5, s5, -16
  sw a0, 12(s5)
  sw a1, 8(s5)
  sw a2, 4(s5)   
  sw a3, 0(s5)


   li a3, 0
   li a2, 0
   lw a1, 4(s4)
   lw a0, 8(s4)

   # Divisor-High Divisor-Low
   #         a5          a4

ud_slash_mod_internal:

   push a4
   push a5

   push t2
   push s7
   push s8
  
   mv a5, s3
   lw a4, 0(s4)

   # For this long division, we need 64 individual division steps.
   li s3, 64

3: 


    # Shift the long chain of four registers.
    li t0, 0

    addc a0, a0, a0
    addc a1, a1, a1
    addc a2, a2, a2
    addc a3, a3, a3

    # Compare Divisor with top two registers
    bltu a5, a3, 1f # Check high part first
    bltu a3, a5, 2f
    # cmp r3, r5 # Check high part first
    # bhi 1f
    # blo 2f

    bltu a2, a4, 2f # High part is identical. Low part decides.
    # cmp r2, r4 
    # blo 2f

    # Subtract Divisor from two top registers
1:  li t0, 0
    subc a2, a2, a4
    subc a3, a3, a5

    # subs r2, r4 # Subtract low part
    # sbcs r3, r5 # Subtract high part with carry

    # Insert a bit into Result which is inside LSB of the long register.
    addi a0, a0, 1
2:


   addi s3, s3, -1
   bne s3, zero, 3b

   # Now place all values to their destination.
   mv s3, a1    # Result-High
   sw a0, 0(s4) # Result-Low
   sw a3, 4(s4) # Remainder-High
   sw a2, 8(s4) # Remainder-Low

   pop s8
   pop s7
   pop t2

   lw a0, 20(s5)
   lw a1, 16(s5)
   lw a2, 12(s5)
   lw a3, 8(s5)
   lw a4, 4(s5)
   lw a5, 0(s5)    
   addi s5, s5, 24

   NEXT

#------------------------------------------------------------------------------
  CODEWORD  "d0<", DZEROLESS /* ( d -- f ) f = d < 0 */
#------------------------------------------------------------------------------
  addi s4, s4, 4
  srai s3, s3, 31    # Turn MSB into 0xffffffff or 0x00000000
  NEXT
END DZEROLESS

#------------------------------------------------------------------------------
  CODEWORD  "d0=", DZEROEQUAL /* ( d -- f ) f = d == 0 */
#------------------------------------------------------------------------------
  lw t0, 0(s4)
  addi s4, s4, 4
  or s3, s3, t0

  sltiu s3, s3, 1
  addi s3, s3, -1
  xori s3, s3, -1

  NEXT
END DZEROEQUAL


