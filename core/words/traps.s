# SPDX-License-Identifier: GPL-3.0-only

.equ ram_vector_base, RAM_lower_ram_vector

CONSTANT "trap.base" , TRAP_BASE , ram_vector_base /* beginning of Forth interrupt table */
END TRAP_BASE

COLON "trap!" , TRAP_STORE /* ( xt n -- ) TRAP: store xt at trap number n in RAM vector */
      .word XT_CELLS
      .word XT_TRAP_BASE
      .word XT_PLUS
      .word XT_STORE 
      .word XT_EXIT
END TRAP_STORE
