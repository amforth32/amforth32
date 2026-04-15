# SPDX-License-Identifier: GPL-3.0-only

VALUE "lp0", LP0, RAM_upper_leavestack /* start of the leave stack */
END LP0

VARIABLE "lp", LP /* leave stack pointer */
END LP

COLON "l>", L_FROM /* ( -- x ) (L: x -- ) move TOS from leave stack to data stack */
    .word XT_LP
    .word XT_FETCH
    .word XT_FETCH
    .word XT_DOLITERAL
    .word 4
    .word XT_LP
    .word XT_PLUSSTORE
    .word XT_EXIT
END L_FROM

COLON "l@", L_FETCH /* ( -- x ) (L: x -- x ) copy TOS from leave stack to data stack */
    .word XT_LP
    .word XT_FETCH
    .word XT_FETCH
    .word XT_EXIT
END L_FETCH

COLON ">l", TO_L /* ( x -- )(L: -- x ) move TOS from data stack to leave stack */
    .word XT_DOLITERAL,-4
    .word XT_LP
    .word XT_PLUSSTORE
    .word XT_LP
    .word XT_FETCH
    .word XT_STORE
    .word XT_EXIT
END TO_L

COLON "ldrop", LDROP /* (L: x -- ) remove TOS from leave stack */
    .word XT_DOLITERAL
    .word 4
    .word XT_LP
    .word XT_PLUSSTORE
    .word XT_EXIT
END LDROP

COLON "ldepth", LDEPTH /* ( -- n ) n is current depth of the leave stack */
    .word XT_LP0
    .word XT_LP, XT_FETCH
    .word XT_MINUS
    .word XT_TWO, XT_RSHIFT /* cells */
    .word XT_EXIT
END LDEPTH

COLON "2l>", 2L_FROM /* ( -- x2 x1 ) (L: x1 x2 -- ) move cell pair from top of leave stack to data stack */
/* Note that the cells are in reverse order on the leave stack than they are on the data stack,
   but they are never interpreted on the leave stack, just stashed for later,
   and the reverse order makes it easier to move the pair between the stacks.
*/
    .word XT_L_FROM
    .word XT_L_FROM
    .word XT_EXIT
END 2L_FROM

COLON "2l@", 2L_FETCH /* ( -- x2 x1 ) (L: x1 x2 -- x1 x2 ) copy cell pair from top of leave stack to data stack */
    .word XT_LP
    .word XT_FETCH
    .word XT_DUP
    .word XT_FETCH
    .word XT_SWAP
    .word XT_CELLPLUS
    .word XT_FETCH
    .word XT_EXIT
END 2L_FETCH

COLON "2>l", 2TO_L /* ( x1 x2 -- )(L: -- x2 x1 ) move cell pair from top of data stack to leave stack */
/* Note that the cells are in reverse order on the leave stack than they are on the data stack,
   but they are never interpreted on the L stack, just stashed for later, and the reverse order makes
   it easier to move the pair between the stacks.
*/
    .word XT_TO_L
    .word XT_TO_L
    .word XT_EXIT
END 2TO_L
