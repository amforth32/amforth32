HEADLESS "(?branch)", DOCONDBRANCH /* ( f -- ) if f is false jump to address in next cell, otherwise continue after it */
    mov r0, TOS
    loadtos
    cmp r0, #0
    beq PFA_DOBRANCH
    adds FIP, #4
    NEXT
END DOCONDBRANCH
