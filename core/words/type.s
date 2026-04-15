# SPDX-License-Identifier: GPL-3.0-only

COLON "type", TYPE /* ( s -- ) emit string s */
   .word XT_BOUNDS
   .word XT_QDOCHECK,XT_DOCONDBRANCH,PFA_TYPE_LEAVE
   .word XT_DODO
PFA_TYPE_LOOP:
   .word XT_I, XT_CFETCH, XT_EMIT
   .word XT_DOLOOP,PFA_TYPE_LOOP
PFA_TYPE_LEAVE:
   .word XT_EXIT
END TYPE

COLON "itype", ITYPE /* ( s -- ) emit string s */
    .word XT_TYPE,XT_EXIT
END ITYPE
