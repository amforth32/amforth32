
@------------------------------------------------------------------------------
  CODEWORD  "fill", FILL /* ( addr n c -- ) fill n bytes from addr with c */
@------------------------------------------------------------------------------
  poptos r0 @ filler
  poptos r1 @ count
  @ TOS      Destination

  cbz r1, 2f
1:
  subs r1, #1
  strb r0, [TOS, r1]
  bne 1b
2:
  loadtos
  NEXT
END FILL

@ -----------------------------------------------------------------------------
  CODEWORD  "+!", PLUSSTORE /* ( n addr -- ) [addr] = [addr] + n; add n to the word at addr */
@ -----------------------------------------------------------------------------
  ldm DSP!, {r0, r1} @ X is the new TOS after the store completes.
  ldr  r2, [TOS]     @ Load the current cell value
  adds r2, r0        @ Do the add
  str  r2, [TOS]     @ Store it back
  movs TOS, r1
  NEXT
END PLUSSTORE

@ -----------------------------------------------------------------------------
  CODEWORD  "c@", CFETCH /* ( addr -- c ) c = byte([addr]); load byte at addr */
@ -----------------------------------------------------------------------------
  ldrb TOS, [TOS]
  NEXT
END CFETCH

@ -----------------------------------------------------------------------------
  CODEWORD  "c!", CSTORE /* ( c addr -- ) [addr] = byte(c); store byte c to addr */
@ -----------------------------------------------------------------------------
  ldm DSP!, {r0, r1} @ X is the new TOS after the store completes.
  strb r0, [TOS]     @ Popping both saves a cycle.
  movs TOS, r1
  NEXT
END CSTORE

# -----------------------------------------------------------------------------
CODEWORD  "h@", HFETCH /* ( addr -- x ) x = half([addr]); load halfword at addr */
# -----------------------------------------------------------------------------
  ldrh TOS, [TOS]
  NEXT
END HFETCH

# -----------------------------------------------------------------------------
  CODEWORD  "h!", HSTORE /* ( x addr -- ) [addr] = half(x); store halfword x to addr */
# -----------------------------------------------------------------------------
  popnos r0
  strh r0, [TOS]
  loadtos
  NEXT
END HSTORE
