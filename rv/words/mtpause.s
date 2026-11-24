HEADLESS "mtpause", MTPAUSE

    /* No task switch inside an interrupt handler: in-isr? counts the
       Forth handlers that are running (+1 in isrstub, -1 in (exiti)) */

    la      t0, IN_ISRQ_ram
    lw      t1, 0(t0)
    bnez    t1, MTPAUSE_done

    csrrci  t1, mstatus, 0x8    /* t1 = old mstatus, then clear MIE (atomic) */

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

    andi    t1, t1, 0x8         /* keep only the old MIE bit */
    csrs    mstatus, t1         /* set MIE again only if it was set before */

MTPAUSE_done:
    NEXT
END MTPAUSE
