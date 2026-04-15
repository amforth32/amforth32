# SPDX-License-Identifier: GPL-3.0-only
CODEWORD "2rot", 2ROT /* (d1 d2 d3 -- d2 d3 d1) rotate top 3 cell pairs on stack left, 3rd pair becomes top pair */
  
  lw t4, 16(s4)  # d3 
  lw t3, 12(s4)

  lw t2,  8(s4)  # d2 
  lw t1,  4(s4)

  lw t0,  0(s4)  # d1 
  #  s3 has other

  sw t1 , 12(s4) # d2 
  sw t2 , 16(s4)

  sw s3 , 4(s4)  # d1 
  sw t0 , 8(s4)

  mv s3 , t3     # d3 
  sw t4 , 0(s4)

  NEXT
END 2ROT
