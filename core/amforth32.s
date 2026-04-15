# This file contains steps that are executed early in the assembly structure,
# before words definitions are compiled.
# Code here should pertain to general AmForth32 architecture only.

# Allocate core system RAM areas: stacks, tib, user areas, ...
# TODO: should this be configurable?
RAMALLOT ram_vector, 256*cellsize, 4
RAMALLOT datastack, datastack_size, 4
RAMALLOT returnstack, returnstack_size, 4
RAMALLOT leavestack, leavestack_size, 4
RAMALLOT userarea, userarea_size, 4
RAMALLOT refill_buf, refill_buf_size, 4
.if WANT_DEBUGGER == YES
RAMALLOT debug_buf, refill_buf_size, 4
.endif
# EXCEPTION CODES

# Standard Exceptions
# https://forth-standard.org/standard/exception (Table 9.1)
.include "words/throwerr.s"
