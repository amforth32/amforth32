HEADLESS "(do)", DODO
    @ save loopsys
    loadindex r0
    loadlimit r1
    push {r0, r1}

    @ create new loopsys from stack
    poptos r0 @ loopindex
    poptos r1 @ looplimit
    add r1, #0x80000000
    storelimit r1
    sub r0, r1
    storeindex r0
    NEXT
END DODO
