CODEWORD "unloop", UNLOOP /* (R: loop-sys -- ) remove loop-sys, required if you want exit the word rather then leave the loop */
  pop {r0, r1}
  storeindex r0
  storelimit r1
  NEXT
END UNLOOP

