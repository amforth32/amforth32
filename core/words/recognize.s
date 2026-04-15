# SPDX-License-Identifier: GPL-3.0-only

COLON "recognize", RECOGNIZE /* (addr len recstack -- i*x rectype-? | rectype-null ) walk the recognizer stack */

    .word XT_DOLITERAL
    .word XT_DORECOGNIZE
    .word XT_SWAP
    .word XT_MAPSTACK
    .word XT_ZEROEQUAL
    .word XT_DOCONDBRANCH, 1f
      .word XT_2DROP
      .word XT_RECTYPE_NULL
1:
    .word XT_EXIT
END RECOGNIZE

NONAME "(recognize)", DORECOGNIZE
   .word XT_ROT
   .word XT_ROT
   .word XT_2DUP 
   .word XT_2TO_R
   .word XT_ROT
   .word XT_EXECUTE
   .word XT_2R_FROM
   .word XT_ROT
   .word XT_DUP
   .word XT_RECTYPE_NULL
   .word XT_EQUAL
   .word XT_DOCONDBRANCH, 1f
     .word XT_DROP
     .word XT_ZERO
     .word XT_EXIT
 1:
   .word XT_NIP 
   .word XT_NIP
   .word XT_TRUE
   .word XT_EXIT
END DORECOGNIZE
