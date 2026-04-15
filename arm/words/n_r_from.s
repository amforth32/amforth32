CODEWORD "nr>", N_R_FROM /* (R: xu .. x1 u -- )( -- xu .. x1 u ) move u items from return stack to data stack */
    pop {r1}
    mov r0, r1
    savetos
1:
    pop {TOS}
    savetos
    subs r0,1
    bne 1b
    mov TOS, r1
    NEXT
END N_R_FROM
