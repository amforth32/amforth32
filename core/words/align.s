# SPDX-License-Identifier: GPL-3.0-only
# : align here aligned here - allot ;

COLON "align", ALIGN /* align RAM space to cell size */
    .word XT_MEMMODE, XT_DOCONDBRANCH, 1f
        .word XT_VALIGN, XT_FINISH
1:  /* else we're in RAM mode */
        .word XT_DALIGN, XT_EXIT
END ALIGN
