# SPDX-License-Identifier: GPL-3.0-only

IMMED "endloop", ENDLOOP /* (C: a -- )(L: i*a -- ) resolve all the jumps of the do..loop  */

        .word XT_LRESOLVE
ENDLOOP1:
        .word XT_L_FROM,XT_QDUP,XT_DOCONDBRANCH, ENDLOOP2
        .word XT_THEN, XT_DOBRANCH, ENDLOOP1
ENDLOOP2:
	.word XT_EXIT
END ENDLOOP
