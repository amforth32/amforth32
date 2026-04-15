@------------------------------------------------------------------------------
  CODEWORD "dnegate", DNEGATE /* ( d1 -- d2 ) d2 = -d1 */
@------------------------------------------------------------------------------

  bl dnegate
NEXT

dnegate:
  ldr r0, [DSP]
  movs r1, #0
  mvns r0, r0
  mvns TOS, TOS
  adds r0, #1
  adcs TOS, r1
  str r0, [DSP]
  bx lr
END DNEGATE
