# SPDX-License-Identifier: GPL-3.0-only

NOVAR "evaluate.strlen", EVALUATEDOTSTRLEN
END EVALUATEDOTSTRLEN

NOVAR "evaluate.str", EVALUATEDOTSTR
END EVALUATEDOTSTR
# ----------------------------------------------------------------------
NONAME "evaluate.source", EVALUATEDOTSOURCE 
    .word XT_EVALUATEDOTSTR
    .word XT_FETCH
    .word XT_EVALUATEDOTSTRLEN
    .word XT_FETCH
    .word XT_EXIT
END EVALUATEDOTSOURCE
# ----------------------------------------------------------------------
NONAME "(evaluate)", LPARENEVALUATERPAREN /* ( a u -- ) interpret a Forth string of length u starting at address a  */
    .word XT_DOLITERAL
    .word XT_SOURCE
    .word XT_DEFER_FETCH
    .word XT_TO_R
    .word XT_TO_IN
    .word XT_FETCH
    .word XT_TO_R
    .word XT_ZERO
    .word XT_TO_IN
    .word XT_STORE
    .word XT_EVALUATEDOTSTRLEN
    .word XT_STORE
    .word XT_EVALUATEDOTSTR
    .word XT_STORE
    .word XT_DOLITERAL
    .word XT_EVALUATEDOTSOURCE
    .word XT_DOTO
    .word XT_SOURCE
    .word XT_DOLITERAL
    .word XT_INTERPRET
    .word XT_CATCH
    .word XT_R_FROM
    .word XT_TO_IN
    .word XT_STORE
    .word XT_R_FROM
    .word XT_DOTO
    .word XT_SOURCE
    .word XT_THROW
    .word XT_EXIT
END LPARENEVALUATERPAREN
# ----------------------------------------------------------------------
IMMED "evaluate", EVALUATE /* ( a u -- ) interpret a Forth string of length u starting at address a  */
    .word XT_STATE
    .word XT_FETCH
    .word XT_DOCONDBRANCH,EVALUATE_0001 /* if */
    .word XT_COMPILE
    .word XT_LPARENEVALUATERPAREN
    .word XT_DOBRANCH,EVALUATE_0002
EVALUATE_0001: /* else */
    .word XT_LPARENEVALUATERPAREN
EVALUATE_0002: /* then */
    .word XT_EXIT
END EVALUATE
