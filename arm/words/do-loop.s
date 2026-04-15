HEADLESS "(loop)", DOLOOP
  ldr r1, =#1 @ increment
  b 1f
END DOLOOP

HEADLESS "(+loop)", DOPLUSLOOP
  poptos r1 @ increment
1:
  loadindex r0
  adds r0, r1
  bvs 2f
  storeindex r0
  ldr FIP, [FIP]
  NEXT
2:
  add FIP, #4
  pop {r0, r1}
  storeindex r0
  storelimit r1
  NEXT
END DOPLUSLOOP
