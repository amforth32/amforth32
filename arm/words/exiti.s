# SPDX-License-Identifier: GPL-3.0-only
# Helper word for 

CODEWORD "(exiti)", EXITI /* return from interrupt handler; compiled by ;i. */
    # TODO: this likely needs more work
    bx lr
END EXITI
