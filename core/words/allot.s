# SPDX-License-Identifier: GPL-3.0-only

COLON "allot" , ALLOT /* ( u -- ) allocate u bytes in RAM */
    .word XT_MEMMODE, XT_DOCONDBRANCH, 1f
        .word XT_VALLOT, XT_FINISH
1:  /* else we're in RAM mode */
        .word XT_DALLOT, XT_EXIT
END ALLOT


