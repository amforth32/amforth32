@------------------------------------------------------------------------------
  CODEWORD "d2/", D2SLASH /* ( d1 -- d2 ) d2 = d1 / 2 */
@------------------------------------------------------------------------------
  ldr r0, [DSP]
  lsls r1, TOS, #31 @ Prepare Carry
  asrs TOS, #1     @ Shift signed high part right
  lsrs r0, #1       @ Shift low part
  orrs r0, r1
  str r0, [DSP]
  NEXT
END DSLASH
