@------------------------------------------------------------------------------
CODEWORD  "move", MOVE /* ( addr1 addr2 n -- ) copy n bytes from addr1 to addr2 */
/* This can cope with overlapping memory areas */
@------------------------------------------------------------------------------
  # TODO: Why are we saving these? We don't do that anywhere.
  push {r0, r1, r2}

  poptos r1
  poptos r2
  @ TOS:     Source address

  @ Count > 0 ?
  cmp r1, #0
  beq 3f @ Nothing to do if count is zero.

  @ Compare source and destination address to find out which direction to copy.
  cmp r2, TOS
  beq 3f @ If source and destionation are the same, nothing to do.
  blo 2f

  subs TOS, #1
  subs r2, #1

1:@ Source > Destination --> Backward move
  ldrb r0, [TOS, r1]
  strb r0, [r2, r1]
  subs r1, #1
  bne 1b
  b 3f

2:@ Source < Destination --> Forward move
  ldrb r0, [TOS]
  strb r0, [r2]
  adds TOS, #1
  adds r2, #1
  subs r1, #1
  bne 2b

3:  loadtos
  pop {r0, r1, r2}
  NEXT
END MOVE
