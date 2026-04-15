# SPDX-License-Identifier: GPL-3.0-only

COLON "?abort", QABORT /* ( f s -- ) abort and type string s if f true */
        .word XT_ROT,XT_DOCONDBRANCH,QABO1
        .word XT_TYPE,XT_ABORT
QABO1:  .word XT_2DROP,XT_EXIT
END QABORT
