# SPDX-License-Identifier: GPL-3.0-only

VALUE "forth-recognizer", FORTHRECOGNIZER, PFA_CFG_RECOGNIZER

DATA "cfg-recognizer", CFG_RECOGNIZER

.if WANT_RECORD == YES
.word 3
.word XT_REC_RECORD
.else
.word 2
.endif

.word XT_REC_FIND
.word XT_REC_NUM

