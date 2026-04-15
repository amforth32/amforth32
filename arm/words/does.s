@ SPDX-License-Identifier: GPL-3.0-only

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
  /*
    Encode and compile BL instruction
    Because it is a long jump it requires using BLX Rn,
    and therefore the target address has to be loaded into Rn from memory.
    So the final layout of the machine code looks like this:
    0x4800 LDR R0, [PC, #0] @ LDR (literal) encoding: 01101 rrr iiiiiiii
    0x4780 BLX R0 @ BLX (register) encoding: 0100 0111 1 rrrr 000
    PFA_XDODOES+1 32-bit address loaded by the LDR instruction
  */
  .word XT_DOLITERAL
  .word 0x47804800    @ LDR R0, [PC, #0] + BLX R0
  .word XT_COMMA
  .word XT_DOLITERAL
  .word PFA_XDODOES
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

   .word XT_R_FROM @ get the synthetic jump address from return stack
   .word XT_1PLUS  @ set the thumb bit on the jump address
   .word XT_NEWEST @ get the child word's FFA
   .word XT_FETCH
   .word XT_DUP
   .word XT_TO_R
   .word XT_FFA2CFA

   .word XT_MEMMODE , XT_DOCONDBRANCH, 1f
   .word XT_FLASHDOTFLUSH
.if RA_FLASH == YES
   .word XT_RASTORE_I
.else   
   .word XT_STORE_I   @ store the jump address in child's CFA
.endif   
   .word XT_DOBRANCH , 2f
1: .word XT_STORE     @ store the jump address in child's CFA
   .word XT_DOLITERAL
   .word Flag_child
   .word XT_R_FETCH
   .word XT_STORE
2: .word XT_RDROP
   .word XT_EXIT
END DODOES

CODEWORD "(xdoes)", XDODOES /* ( -- u) prepares interpreter state for execution of the DOES> wordlist, u is child's PFA */
  /* W register has child's PFA, push it to TOS */ 
  pushtos FW
  /* IP points to the next word after child's call site,
  that's where we want to return to, so push it to return stack */
  str FIP, [sp, #-4]!
  /* Link register points to the DOES> word list in parent word,
  but we need to account for the XDODOES address stored after the blx instruction.
  The LR value has the thumb bit set, that's why +3 and not +4 */
  add lr, lr , #3  
  mov FIP, lr
  NEXT
END XDODOES
