CODEWORD "control@", CONTROLFETCH
    mrs     TOS, control
    savetos
    NEXT
END CONTROLFETCH

CODEWORD "psp@", PSPFETCH
    mrs     TOS, psp
    savetos
    NEXT
END PSPFETCH

CODEWORD "msp@", MSPFETCH
    mrs     TOS, msp
    savetos
    NEXT
END MSPFETCH
