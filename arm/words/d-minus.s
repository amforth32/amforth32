@------------------------------------------------------------------------------
  CODEWORD "d-", DMINUS /* ( d1 d2 - d3 ) d3 = d1 - d2 */
@------------------------------------------------------------------------------
  ldm DSP!, {r0, r1, r2}
  subs r2, r0     @  Low-part first
  sbcs r1, TOS   @ High-part with carry
  movs TOS, r1

  subs DSP, #4
  str r2, [DSP]
  NEXT
END DMINUS
