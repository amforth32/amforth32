# SPDX-License-Identifier: GPL-3.0-only
# -----------------------------------------------------------------------------
  CODEWORD "compare", COMPARE /* ( addr1 n1 addr2 n2 -- f ) f is true if both strings are the same (based on WANT_IGNORECASE) */
# -----------------------------------------------------------------------------

.if WANT_IGNORECASE==1
.macro lowercase Register # Convert to lowercase.
  #    Hex Dec  Hex Dec
  # A  41  65   61  97  a
  # Z  5A  90   7A  122 z
  
  sltiu a4, \Register, 0x41
  bne a4, zero, 5f
    sltiu a4, \Register, 0x5B
    beq a4, zero, 5f
      addi \Register, \Register, 0x20    
5:
.endm
.endif

  mv a0, s3
  lw a1, 0(s4)
  lw a2, 4(s4)
  lw s3, 8(s4)
  addi s4, s4, 12

  beq a0, a2, 2f
    # Lengths not equal.
1:  li s3, -1
    j 4f

  # Lengths are equal. Compare characters.
  
2:beq a0, zero, 3f    # Any characters to compare left ?

  lbu a2, 0(a1)
.if WANT_IGNORECASE==1
  .print "INFO: Using IGNORECASE for word comparison"
  lowercase a2
.endif
  lbu a3, 0(s3)
.if WANT_IGNORECASE==1
  lowercase a3
.endif
  bne a2, a3, 1b
  
  addi a0, a0, -1
  addi a1, a1, 1
  addi s3,  s3,  1
  j 2b
  
3: mv s3, zero

4:
  NEXT

END COMPARE
