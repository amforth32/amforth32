# SPDX-License-Identifier: GPL-3.0-only

IMMED "does>" , DOES /* () compiles (does) followed by a jump and link to xdodoes */
/*
CREATE ... DOES> allows defining word creating words (parent words) that can define the execution semantics of their child words.
The semantics are expressed with forth code following the DOES> word. The words between CREATE and DOES> construct the contents of
child's parameter fields (PFA).

Implementation:
Child's CFA must point to machine code that will
  1) push child's PFA to stack
  2) push IP (pointing to the word following the child word at the call site) to return stack
  3) set IP to point to the words after DOES> in the parent word definition
  4) start another round of the interpreter (DO_NEXT)
 This is largely what XDODOES does, but to accomplish 3) we don't jump to it directly.
 Instead when DOES> compiles (does) into the parent word it follows it with a synthetic
 jump and link instruction that jumps to XDODOES. Child's CFA points to the address
 of this synthetic instruction. This brings the IP value we need into XDODOES through the link register,
 because the words following DOES> follow the synthetic jump.
 */
      .word XT_COMPILE , XT_DODOES

      /* Compute PC relative jump offset to XDODOES
        for a synthetic jump and link instruction */
      .word XT_DOLITERAL
      .word PFA_XDODOES
      .word XT_DP
      .word XT_MINUS
      .word XT_DUP
      .word XT_DOLITERAL
      .word 0x00000FFF
      .word XT_AND
      .word XT_SWAP
      .word XT_DOLITERAL
      .word 0x800
      .word XT_PLUS
      .word XT_DOLITERAL
      .word 0xFFFFF000
      .word XT_AND
      .word XT_DOLITERAL
      .word 0x297
      .word XT_OR
      .word XT_COMMA
      .word XT_DOLITERAL
      .word 20 
      .word XT_LSHIFT
      .word XT_DOLITERAL
      # .word 0x28067 # jalr x0 , 0(t0)
      .word 0x28367   # jalr t1 , 0(t0)
      .word XT_OR
      .word XT_COMMA

      .word XT_EXIT
END DOES

COLON "(does)", DODOES /* (R: addr -- ) addr of the synthetic jump after (does), stored in child's CFA */
/*
  (does) is compiled into the parent word's definition and is executed
  when the parent word is invoked to create a child word.
  It needs to compile the address of the synthetic jump and link into the child's CFA.
  The synthetic jump and link immediately follows the (does) XT in the parent's body,
  therefore the required address will be at the top of the return stack when (does) executes
  (dodoes being a regular colon word).
  We also need to remove this address from the return stack because that is not where we want
  to return when (does) finishes. Instead we want to return to the word that called the parent word,
  i.e the next address on the return stack.
*/

        .word XT_R_FROM # get the synthetic jump address from return stack
        .word XT_NEWEST # get the child word's FFA
        .word XT_FETCH
        .word XT_DUP
        .word XT_TO_R
        .word XT_FFA2CFA
                
        .word XT_MEMMODE , XT_DOCONDBRANCH, 1f
        .word XT_FLASHDOTFLUSH
        .word XT_STORE_I 
        .word XT_DOBRANCH , 2f 
1:      .word XT_STORE # store the jump address in child's CFA
        .word XT_DOLITERAL
        .word Flag_child
        .word XT_R_FETCH
        .word XT_STORE
2:      .word XT_RDROP
        .word XT_EXIT

END DODOES

HEADLESS "(xdoes)", XDODOES /* ( -- u) prepares interpreter state for execution of the DOES> wordlist, u is child's PFA */
  savetos # push child's PFA (it's in the W register) to TOS 
  mv s3, s1
  /*  IP points to the word following the child's XT where it was called,
    this is where we want to return when the child finishes executing,
    so push it to the return stack.
  */
  push s2 
  mv s2 , t1 # set the IP to the address from the link register
  NEXT
END XDODOES

