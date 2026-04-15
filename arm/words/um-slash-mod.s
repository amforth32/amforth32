CODEWORD "um/mod", UMSLASHMOD /* ( ud u1 -- u2 u3 ) u3 is the quotient and u2 the remainder of ud / u1 */
/*
All values and arithmetic are unsigned. Throws if u1 is zero or if the quotient lies outside the range of a single-cell unsigned integer.
*/
    @ Same algorithm as if performing the division by hand, just in binary.
    @ Inputs:  hi:lo = 64-bit dividend, TOS = 32-bit divisor
    @ Outputs: hi:lo = 64-bit quotient, rem = 32-bit remainder
    hi  .req r0
    lo  .req r1
    rem .req r2
    idx .req r3
umslashmod:
    cbnz TOS, 4f        @ throw if divisor is zero
    throw EDIVZ
4:  popnos hi
    cmp hi, #0          @ if hi == 0, use the quicker u/mod
    beq uslashmod    
    popnos lo 
    @ TODO: could use CLZ to skip shifting through 0 bit prefix bit by bit and save some iterations
    mov     idx, #64        @ Loop counter for 64 bits
    mov     rem, #0         @ Initialize remainder to 0
1:  lsls    lo, lo, #1      @ Shift dividend/quotient low word
    adcs    hi, hi, hi      @ Shift dividend/quotient high word into carry (adc is how to lsl by 1 bit with carry)
    adcs    rem, rem, rem   @ Shift carry into remainder, also catch the bit shifting off at the top
    bcs     5f              @ If Carry is set, r3 is now effectively 33-bits, force the divisor subtraction 
    cmp     rem, TOS        @ Can we subtract the divisor?
    blo     2f              @ If remainder < divisor, skip
5:  sub     rem, rem, TOS   @ remainder -= divisor
    adds    lo, lo, #1      @ Set the lowest bit of quotient
2:  subs    idx, idx, #1    @ Decrement loop counter
    bne     1b

    cbz hi, 3f      @ if hi > 0, then quotient is too large
    throw ERANGE
3:  pushnos rem
    mov TOS, lo
    .unreq rem
    .unreq lo
    .unreq hi
    NEXT
END UMSLASHMOD
