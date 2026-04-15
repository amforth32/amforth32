
CODEWORD "execute", EXECUTE /* ( xt -- ) execute XT at the top of the stack */
    mov FW, TOS
    loadtos
    b DO_EXECUTE
END EXECUTE
