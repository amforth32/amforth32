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

COLON "trap@" , TRAP_FETCH /* ( n -- xt ) TRAP: fetch the xt at trap number n in RAM vector */
      .word XT_CELLS
      .word XT_TRAP_BASE
      .word XT_PLUS
      .word XT_FETCH
      .word XT_EXIT
END TRAP_FETCH

COLON "trap.init", TRAP_INIT /* ( -- ) TRAP: fill every RAM vector slot with XT of isrnop */
      .word XT_DOLITERAL, ram_vector_size / cellsize   /* 256 slots */
      .word XT_ZERO
      .word XT_DODO
TRAP_INIT_0001: /* do */
      .word XT_DOLITERAL, XT_ISRNOP                     /* ['] isrnop */
      .word XT_I
      .word XT_TRAP_STORE                               /* isrnop i trap! */
      .word XT_DOLOOP, TRAP_INIT_0001 /* loop */
      .word XT_EXIT
END TRAP_INIT

