
CODEWORD "(aligned)", LPARENALIGINEDRPAREN /* ( c-addr -- a-addr ) */
    adds TOS, TOS, #3
    movs r0, #3
    mvns r0, r0
    ands TOS, TOS, r0
    NEXT
END LPARENALIGINEDRPAREN
