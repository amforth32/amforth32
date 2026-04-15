@ -----------------------------------------------------------------------------
  CODEWORD "compare", COMPARE  /* ( addr1 n1 addr2 n2 -- f ) f is true if the strings are different (based on WANT_IGNORECASE) */
@ -----------------------------------------------------------------------------
  bl compare
  mvns TOS, TOS
NEXT

.if WANT_IGNORECASE==1
.macro lowercase Register @ Ein Zeichen in einem Register wird auf Lowercase umgestellt.
  @    Hex Dec  Hex Dec
  @ A  41  65   61  97  a
  @ Z  5A  90   7A  122 z
  cmp \Register, #0x41
  blo 5f
  cmp \Register, #0x5B
  it lo
  addlo \Register, #0x20
5:  
.endm
.endif

compare:

  poptos r1  @ Length of second string
  popnos r0  @ Length of first  string
  cmp r0, r1
  beq 1f

    loadtos
    movs TOS, #0
    bx lr

1: @ Lengths are equal. Compare characters.
   popnos r1  @ Address of first string.
                   @ TOS contains address of second string.

   @ How many characters to compare left ?
2: cmp r0, #0
   beq 3f

     subs r0, #1
     ldrb r2, [r1, r0]
     ldrb r3, [TOS, r0]

.if WANT_IGNORECASE==1
  .print "INFO: Using IGNORECASE for word comparison"
     lowercase r2
     lowercase r3
.endif

     cmp r2, r3
     beq 2b

     @ Unequal
     movs TOS, #0
     bx lr

3: @ Equal !
   movs TOS, #0
   mvns TOS, TOS
   bx lr

END COMPARE
