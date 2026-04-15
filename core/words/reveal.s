# SPDX-License-Identifier: GPL-3.0-only

COLON "reveal", REVEAL /* ( -- ) makes the newest word entry visible in its wordlist */
    .word XT_NEWEST,XT_CELLPLUS,XT_FETCH /* fetch the WID */
    .word XT_QDUP,XT_DOCONDBRANCH, REVEAL1 /* exit if WID is 0 */
    .word XT_NEWEST,XT_FETCH /* fetch the FFA of the newest word */
    /* ( wid ffa ) */
    .word XT_SWAP,XT_DOTO1 /* update the wordlist value */
REVEAL1:
    .word XT_EXIT
END REVEAL

