@------------------------------------------------------------------------------
  CODEWORD  "m*", MSTAR /* ( n1 n2 -- d ) d = n1*n2 */
@------------------------------------------------------------------------------
    ldr r0, [DSP]
    smull r0, TOS, TOS, r0
    str r0, [DSP]
    NEXT
END MSTAR

@------------------------------------------------------------------------------
  CODEWORD  "ud/mod", UDSLASHMOD /* (ud1 ud2 -- ud3 ud4 ) ud3 remainder, ud4 quotient of ud1 / ud2 */
@------------------------------------------------------------------------------
@  throw if divisor is zero
  ldr  r0, [DSP, #0]
  orrs r0, r0, TOS
  bne 2f
  throw EDIVZ
2:
  bl ud_slash_mod
  NEXT

ud_slash_mod:
   push {r4, r5}

   @ ( DividendL DividendH DivisorL DivisorH -- RemainderL RemainderH ResultL ResultH )
   @   8         4         0        TOS      -- 8          4          0       TOS
  dndlo .req r0 @ Dividend-Low / Quotient-Low
  dndhi .req r1 @ Dividend-High / Quotient-High
  remlo .req r2 @ Remainder-Low
  remhi .req r3 @ Remainder-High
  dsrlo .req r4 @ Divisor-Low
  dsrhi .req r5 @ Divisor-High
  @ TOS used for iteration index

   movs remhi, #0 @ initialize remainder
   movs remlo, #0
   ldr  dndhi, [DSP, #4] @ load dividend
   ldr  dndlo, [DSP, #8]
   movs dsrhi, TOS  @ load divisor
   ldr  dsrlo, [DSP, #0]
   mov TOS, #64 @ 64 individual long division steps.
3:
    @ Shift the long chain of four registers.
    lsls dndlo, #1
    adcs dndhi, dndhi
    adcs remlo, remlo
    adcs remhi, remhi

    @ Compare Divisor with top two registers
    cmp remhi, dsrhi @ Check high part first
    bhi 1f
    blo 2f

    cmp remlo, dsrlo @ High part is identical. Low part decides.
    blo 2f

    @ Subtract Divisor from two top registers
1:  subs remlo, dsrlo @ Subtract low part
    sbcs remhi, dsrhi @ Subtract high part with carry

    @ Insert a bit into Result which is inside LSB of the long register.
    adds dndlo, #1
2:
   subs TOS, #1
   bne 3b

   @ Now place all values to their destination.
   movs TOS, dndhi       @ Quotient-High
   str  dndlo, [DSP, #0] @ Quotient-Low
   str  remhi, [DSP, #4] @ Remainder-High
   str  remlo, [DSP, #8] @ Remainder-Low

   pop {r4, r5}
   bx lr

   .unreq dndlo
   .unreq dndhi
   .unreq dsrlo
   .unreq remlo
   .unreq remhi
END UDSLASHMOD

@------------------------------------------------------------------------------
  CODEWORD  "d/mod", DSLASHMOD /* (d1 d2 -- d3 d4 ) d3 remainder, d4 quotient of d1 / d2 */
@------------------------------------------------------------------------------
  @ throw if dividend is zero
  ldr  r0, [DSP, #0]
  orrs r0, r0, TOS
  bne 1f
  throw EDIVZ
1:
  bl d_slash_mod
NEXT

d_slash_mod:  @ ( 1L 1H 2L TOS: 2H -- Rem-L Rem-H Quot-L TOS: Quot-H )
@------------------------------------------------------------------------------
  @ Check Divisor
  push {lr}
  movs r0, TOS, asr #31 @ Turn MSB into 0xffffffff or 0x00000000
  beq 2f
    @ ? / -
    bl dnegate
    bl dswap
    movs r0, TOS, asr #31 @ Turn MSB into 0xffffffff or 0x00000000
    beq 1f
    @ - / -
    bl dnegate
    bl dswap
    bl ud_slash_mod

    bl dswap
    bl dnegate @ Negative remainder
    bl dswap
    pop {pc}

1:  @ + / -
    bl dswap
    bl ud_slash_mod
    bl dnegate  @ Negative result
    pop {pc}

2:  @ ? / +
    bl dswap
    movs r0, TOS, asr #31 @ Turn MSB into 0xffffffff or 0x00000000
    beq 3f
    @ - / +
    bl dnegate
    bl dswap

    bl ud_slash_mod

    bl dnegate @ Negative result
    bl dswap
    bl dnegate @ Negative remainder
    bl dswap
    pop {pc}

3:  @ + / +
    bl dswap
    bl ud_slash_mod
    pop {pc}
END DSLASHMOD

@------------------------------------------------------------------------------
  CODEWORD  "d/", DSLASH /* ( d1 d2 -- d3 ) d3 is quotient of d1 / d2 */
@------------------------------------------------------------------------------
  bl d_slash_mod
  ldm DSP!, {r0, r1, r2}
  subs DSP, #4
  str r0, [DSP]
  NEXT
END DSLASH

@------------------------------------------------------------------------------
@ --- Double comparisions ---
@------------------------------------------------------------------------------

@------------------------------------------------------------------------------
  CODEWORD  "d<", DLESS /* ( d1 d2 -- f ) f = d1 < d2 */
@------------------------------------------------------------------------------
  ldm DSP!, {r0, r1, r2}

  @ Check High:
  cmp TOS, r1
  bgt 2f @ True
  bne 1f @ False - Not bigger, not equal --> Lower.
  @ Fall through if high part is equal

  @ Check Low:
  cmp r0, r2
  bgt 2f

@ False:
1:movs TOS, #0
  NEXT

@ True
2:movs TOS, #0
  mvns TOS, TOS
  NEXT
END DLESS

@------------------------------------------------------------------------------
  CODEWORD  "d>", DGREATER /* ( d1 d2 -- f ) f = d1 > d2 */
@------------------------------------------------------------------------------
  ldm DSP!, {r0, r1, r2}

  @ Check High:
  cmp r1, TOS
  bgt 2f @ True
  bne 1f @ False - Not bigger, not equal --> Lower.
  @ Fall through if high part is equal

  @ Check Low:
  cmp r2, r0
  bgt 2f

@ False:
1:movs TOS, #0
  NEXT

@ True
2:movs TOS, #0
  mvns TOS, TOS
  NEXT
END DGREATER

@------------------------------------------------------------------------------
  CODEWORD  "d0<", DZEROLESS /* ( d -- f ) f = d < 0 */
@------------------------------------------------------------------------------
  adds DSP, #4
  movs TOS, TOS, asr #31    @ Turn MSB into 0xffffffff or 0x00000000
  NEXT
END DZEROLESS

@------------------------------------------------------------------------------
  CODEWORD  "d0=", DZEROEQUAL /* ( d -- f ) f = d == 0 */
@------------------------------------------------------------------------------
  popnos r0
  cmp r0, #0
  beq 1f
    movs TOS, #0
  NEXT

1:subs TOS, #1
  sbcs TOS, TOS
  NEXT
END DZEROEQUAL

@------------------------------------------------------------------------------
  CODEWORD  "d=", DEQUAL /* ( d1 d2 -- f ) f = d1 == d2 */
@------------------------------------------------------------------------------
  ldm DSP!, {r0, r1, r2}

  cmp r0, r2
  beq 1f
    movs TOS, #0
  NEXT

1:subs TOS, r1       @ Z=equality; if equal, TOS=0
  subs TOS, #1      @ Wenn es Null war, gibt es jetzt einen Überlauf
  sbcs TOS, TOS
  NEXT
END DEQUAL

CODEWORD  "s>d", S2D /* ( n -- d ) converts n to double cell d (MSB cell is higher in the stack) */
  savetos
  movs TOS, TOS, asr #31
  NEXT
END S2D
