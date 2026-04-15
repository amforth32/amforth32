# SPDX-License-Identifier: GPL-3.0-only

COLON "valign" , VALIGN /* ( -- ) align VP to cell boundary in variable RAM pool  */
    .word XT_VP
    .word XT_ALIGNED
    .word XT_VP
    .word XT_MINUS
    .word XT_VALLOT    
    .word XT_EXIT
END VALIGN

