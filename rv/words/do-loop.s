# SPDX-License-Identifier: GPL-3.0-only
HEADLESS "(loop)" , DOLOOP
  li t0, 1 # increment
  j DOPLUSLOOP1
END DOLOOP

HEADLESS "(+loop)" , DOPLUSLOOP
  mv t0, s3 # increment
  loadtos
DOPLUSLOOP1:
  loadindex t1 # index
  add t2,t1,t0 # t2 = index + inc
  slt t3,t0,zero # t3 = increment < 0
  slt t4,t2,t1 # t4 = index + inc < index
  bne t3, t4, DOLOOP_LEAVE # leave if sign overflow
    mv t1, t2   # update index
    storeindex t1
    lw s2,0(s2) # jump back to start
    NEXT
DOLOOP_LEAVE:
  # restore loop-sys
  lw t1, 0(s5)
  storelimit t1
  lw t1, 4(s5)
  storeindex t1
  addi s5, s5, 8

  # skip loop address
  addi s2,s2,4
  NEXT
END DOPLUSLOOP
