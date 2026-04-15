# SPDX-License-Identifier: GPL-3.0-only

/* 
    TODO: This doesn't look right
> 10. 20.
 ok
> .s
4  0 20 0 10  ok
> ud*
 ok
> .s
3  0 0 10  ok

 */
COLON "ud*", UDSTAR /* unclear, maybe broken? */
    .word XT_DUP,XT_TO_R,XT_UMSTAR,XT_DROP
    .word XT_SWAP,XT_R_FROM,XT_UMSTAR,XT_ROT,XT_PLUS,XT_EXIT
END UDSTAR
