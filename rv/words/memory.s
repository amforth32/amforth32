# SPDX-License-Identifier: GPL-3.0-only
# Memory access

# This seems to have some problems Mon 15 Dec 25 12:07:29
# and only appears to work for backward copy....
# replacing by move.s 
# # -----------------------------------------------------------------------------
#   CODEWORD  "move",MOVE  # Move some bytes around. This can cope with overlapping memory areas.
# # -----------------------------------------------------------------------------
#   addi s5, s5, -12
#   sw ra,  8(s5)
#   sw a0, 4(s5)
#   sw a1, 0(s5)   

#   popdadouble a0, a1

#   # Count > 0 ?
#   beq a0, zero, 3f # Nothing to do if count is zero.

#   # Compare source and destination address to find out which direction to copy.
#   beq a1, s3, 3f # If source and destionation are the same, nothing to do.
#   bltu a3, s3, 2f
  
#   addi s3, s3, -1
#   addi s5, a1, -1

# 1:# Source > Destination --> Backward move
#   add t0, s3, a0
#   lbu t0, 0(t0)
  
#   add t1, a1, a0
#   sb t0, 0(t1)
  
#   addi a0, a0, -1
#   bne a0, zero, 1b
#   j 3f

# 2:# Source < Destination --> Forward move
#   lbu t0, 0(s3)
#   sb t0, 0(a1)
  
#   addi s3, s3, 1
#   addi a1, a1, 1
#   addi a0, a0, -1
#   bne a0, zero, 2b

# 3:
#   lw s3, 0(s4)
#   addi s4, s4, 4

#   lw ra,  8(s5)
#   lw a0, 4(s5)
#   lw a1, 0(s5)
#   addi s5, s5, 12

#   NEXT



# -----------------------------------------------------------------------------
  CODEWORD  "fill", FILL  /* ( addr n c -- ) fill n bytes from addr with c */
# -----------------------------------------------------------------------------
/*
 6.1.1540 FILL CORE ( c-addr u char -- ) If u is greater than zero, store char in each of u consecutive characters of memory beginning at c-addr.
*/
  addi s5, s5, -8
  sw a0,  4(s5)
  sw a1, 0(s5)

  popdadouble a0, a1
  #popda a0 # Filling byte
  #popda a1 # Count
  # TOS       Destination

  beq a1, zero, 2f

1:addi a1, a1, -1
  add t0, s3, a1
  sb a0, 0(t0)
  bne a1, zero, 1b

2:
  lw s3, 0(s4)
  addi s4, s4, 4

  lw a0,  4(s5)
  lw a1, 0(s5)
  addi s5, s5, 8

  NEXT
END FILL

# -----------------------------------------------------------------------------
  CODEWORD  "+!", PLUSSTORE /* ( n addr -- ) [addr] = [addr] + n; add n to the word at addr */
# -----------------------------------------------------------------------------
  lw t0, 0(s4)
    lw t1, 0(s3)
    add t0, t0, t1
    sw t0, 0(s3)
  lw s3, 4(s4)
  addi s4, s4, 8
  NEXT
END PLUSSTORE

# -----------------------------------------------------------------------------
  CODEWORD  "c@", CFETCH /* ( addr -- c ) c = byte([addr]); load byte at addr */
# -----------------------------------------------------------------------------
  lbu s3, 0(s3)
  NEXT
END CFETCH

# -----------------------------------------------------------------------------
  CODEWORD  "c!", CSTORE /* ( c addr -- ) [addr] = byte(c); store byte c to addr */
# -----------------------------------------------------------------------------
  lw t0, 0(s4)
  sb t0, 0(s3)
  lw s3, 4(s4)
  addi s4, s4, 8
  NEXT
END CSTORE

# -----------------------------------------------------------------------------
  CODEWORD  "h@", HFETCH /* ( addr -- x ) x = half([addr]); load halfword at addr */
# -----------------------------------------------------------------------------
  lhu s3, 0(s3)
  NEXT
END HFETCH

# -----------------------------------------------------------------------------
  CODEWORD  "h!", HSTORE /* ( x addr -- ) [addr] = half(x); store halfword x to addr */
# -----------------------------------------------------------------------------
  lw t0, 0(s4)
  sh t0, 0(s3)
  lw s3, 4(s4)
  addi s4, s4, 8
  NEXT
END HSTORE
