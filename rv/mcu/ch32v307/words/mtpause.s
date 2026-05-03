CODEWORD "mtpause", MTPAUSE

    /* Skip if in interrupt (using software flag) */
    /*
    la      t0, in_isr_flag
    lw      t1, 0(t0)
    bnez    t1, MTPAUSE_done
    */

    csrr    t1, 0x800            /* save interrupt state */
    li      t0, 0x6000           /* disable...           */
    csrw    0x800, t0            /* ...                  */

    sw      s4, USER_SP(s6)
    sw      s5, USER_RP(s6)
    sw      s2, USER_IP(s6)
    sw      s3, USER_TOS(s6)

    /* Find next awake task */
MTPAUSE_loop:
    lw      s6, USER_LINK(s6)   
    lw      t0, USER_STATUS(s6)
    beqz    t0, MTPAUSE_loop

    /* Load incoming state */
    lw      s4, USER_SP(s6)
    lw      s5, USER_RP(s6)
    lw      s2, USER_IP(s6)
    lw      s3, USER_TOS(s6)

    csrw    0x800, t1           /* restore interrupt state */ 

MTPAUSE_done:
    NEXT
END MTPAUSE
