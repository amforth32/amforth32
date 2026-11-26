# SPDX-License-Identifier: GPL-3.0-only

# ----------------------------------------------------------------------
COLON "isrnop", ISRNOP /* ( -- ) TRAP: default Forth ISR handler, does nothing */
    .word XT_EXITI
END ISRNOP
# ----------------------------------------------------------------------

