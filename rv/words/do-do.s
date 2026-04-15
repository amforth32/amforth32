# SPDX-License-Identifier: GPL-3.0-only
HEADLESS "(do)" , DODO
  # save loop sys
  addi s5, s5, -8
  loadindex t0
  sw t0, 4(s5)
  loadlimit t1
  sw t1, 0(s5)
  # create new loopsys from stack
  mv t0,s3 # loopindex
  loadtos
  mv t1,s3 # looplimit
  loadtos
  li t2, 0x80000000 # magic
  add t1, t1, t2
  storelimit t1
  sub  t0, t0, t1
  storeindex t0
  NEXT
END DODO
