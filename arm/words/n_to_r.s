CODEWORD "n>r", N_TO_R /* ( xu .. x1 u -- ) (R: -- xu .. x1 u) move u items from data stack to return stack */
    mov r0, TOS
    mov r1, TOS
1:
    loadtos
    push {TOS}
    subs r0,1
    bne 1b
    push {r1}
    loadtos
    NEXT
END N_TO_R
