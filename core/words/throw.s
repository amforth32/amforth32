# SPDX-License-Identifier: GPL-3.0-only
COLON "throw", THROW /* ( n -- ) throw exception n if n != 0 */
    .word XT_QDUP
    .word XT_DOCONDBRANCH,PFA_THROW1
.if WANT_THROWTXT==YES    
      .word XT_DUP
      .word XT_ERRQ
      .word XT_TYPE
.endif      
      .word XT_HANDLER
      .word XT_FETCH
      .word XT_RP_STORE
      .word XT_R_FROM
      .word XT_HANDLER
      .word XT_STORE
      .word XT_R_FROM
      .word XT_SWAP
      .word XT_TO_R
      .word XT_SP_STORE
      .word XT_DROP
      .word XT_R_FROM    
PFA_THROW1:
    .word XT_EXIT
END THROW


