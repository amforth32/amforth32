
NOCON "R32_RCC_AHBPCENR", R32UNDERRCCUNDERAHBPCENR, 1073877012
END R32UNDERRCCUNDERAHBPCENR
NOCON "R8_USB_CTRL", R8UNDERUSBUNDERCTRL, 1073886208
END R8UNDERUSBUNDERCTRL
NOCON "UC_CLR_ALL", UCUNDERCLRUNDERALL, 2
END UCUNDERCLRUNDERALL
NOCON "RING_BYTEMASK", RINGUNDERBYTEMASK, 1023
END RINGUNDERBYTEMASK
NOCON "R8_UEP2_TX_CTRL", R8UNDERUEP2UNDERTXUNDERCTRL, 1073886434
END R8UNDERUEP2UNDERTXUNDERCTRL
NOCON "R8_UEP2_RX_CTRL", R8UNDERUEP2UNDERRXUNDERCTRL, 1073886435
END R8UNDERUEP2UNDERRXUNDERCTRL
NOVAR "usb.int.count", USBDOTINTDOTCOUNT
END USBDOTINTDOTCOUNT
NOVAR "usb.rst.count", USBDOTRSTDOTCOUNT
END USBDOTRSTDOTCOUNT
NOVAR "usb.setup.count", USBDOTSETUPDOTCOUNT
END USBDOTSETUPDOTCOUNT
NOVAR "usb.xfer.count", USBDOTXFERDOTCOUNT
END USBDOTXFERDOTCOUNT
NOVAR "usb.susp.count", USBDOTSUSPDOTCOUNT
END USBDOTSUSPDOTCOUNT
NOVAR "usb.other.count", USBDOTOTHERDOTCOUNT
END USBDOTOTHERDOTCOUNT
# ----------------------------------------------------------------------
NONAME "usb.zero", USBDOTZERO /* ( -- ) zero usb debug stats */
	.word XT_ZERO
	.word XT_USBDOTINTDOTCOUNT
	.word XT_STORE
	.word XT_ZERO
	.word XT_USBDOTRSTDOTCOUNT
	.word XT_STORE
	.word XT_ZERO
	.word XT_USBDOTSETUPDOTCOUNT
	.word XT_STORE
	.word XT_ZERO
	.word XT_USBDOTXFERDOTCOUNT
	.word XT_STORE
	.word XT_ZERO
	.word XT_USBDOTSUSPDOTCOUNT
	.word XT_STORE
	.word XT_ZERO
	.word XT_USBDOTOTHERDOTCOUNT
	.word XT_STORE
	.word XT_EXIT
END USBDOTZERO
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "usb.stats", USBDOTSTATS /* ( -- ) usb debug stats  */
	.word XT_USBDOTINTDOTCOUNT
	.word XT_FETCH
	.word XT_DOT
	.word XT_CR
	.word XT_USBDOTRSTDOTCOUNT
	.word XT_FETCH
	.word XT_DOT
	.word XT_CR
	.word XT_USBDOTSETUPDOTCOUNT
	.word XT_FETCH
	.word XT_DOT
	.word XT_CR
	.word XT_USBDOTXFERDOTCOUNT
	.word XT_FETCH
	.word XT_DOT
	.word XT_CR
	.word XT_USBDOTSUSPDOTCOUNT
	.word XT_FETCH
	.word XT_DOT
	.word XT_CR
	.word XT_USBDOTOTHERDOTCOUNT
	.word XT_FETCH
	.word XT_DOT
	.word XT_CR
	.word XT_EXIT
END USBDOTSTATS
# ----------------------------------------------------------------------
NONVAR "EP0buf", EP0BUF, 16
END EP0BUF
NOCON "R8_USB_INT_FG", R8UNDERUSBUNDERINTUNDERFG, 1073886218
END R8UNDERUSBUNDERINTUNDERFG
NOCON "R8_UEP0_TX_CTRL", R8UNDERUEP0UNDERTXUNDERCTRL, 1073886426
END R8UNDERUEP0UNDERTXUNDERCTRL
NOCON "UEP_T_TOG_DATA1", UEPUNDERTUNDERTOGUNDERDATA1, 8
END UEPUNDERTUNDERTOGUNDERDATA1
NOCON "UEP_T_RES_ACK", UEPUNDERTUNDERRESUNDERACK, 0
END UEPUNDERTUNDERRESUNDERACK
NOCON "UEP_T_RES_NAK", UEPUNDERTUNDERRESUNDERNAK, 2
END UEPUNDERTUNDERRESUNDERNAK
NOCON "UEP_R_RES_ACK", UEPUNDERRUNDERRESUNDERACK, 0
END UEPUNDERRUNDERRESUNDERACK
CONSTANT "#usbhs", HASHUSBHS, 85
END HASHUSBHS
NONVAR "rb-buf", RBMINUSBUF, 256
END RBMINUSBUF
NONVAR "tb-buf", TBMINUSBUF, 256
END TBMINUSBUF
NOVAR "rb-head", RBMINUSHEAD
END RBMINUSHEAD
NOVAR "rb-tail", RBMINUSTAIL
END RBMINUSTAIL
NOVAR "tb-head", TBMINUSHEAD
END TBMINUSHEAD
NOVAR "tb-tail", TBMINUSTAIL
END TBMINUSTAIL
NONVAR "EP2_RX_buf", EP2UNDERRXUNDERBUF, 128
END EP2UNDERRXUNDERBUF
NONVAR "EP2_TX_buf", EP2UNDERTXUNDERBUF, 128
END EP2UNDERTXUNDERBUF
NONVAR "EP3_TX_buf", EP3UNDERTXUNDERBUF, 16
END EP3UNDERTXUNDERBUF
# ----------------------------------------------------------------------
NONAME "rb-empty?", RBMINUSEMPTYQ 
	.word XT_RBMINUSHEAD
	.word XT_FETCH
	.word XT_RBMINUSTAIL
	.word XT_FETCH
	.word XT_EQUAL
	.word XT_EXIT
END RBMINUSEMPTYQ
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "rb-full?", RBMINUSFULLQ 
	.word XT_RBMINUSHEAD
	.word XT_FETCH
	.word XT_1PLUS
	.word XT_RINGUNDERBYTEMASK /* RING_BYTEMASK (nocon) */
	.word XT_AND
	.word XT_RBMINUSTAIL
	.word XT_FETCH
	.word XT_EQUAL
	.word XT_EXIT
END RBMINUSFULLQ
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "rb-count", RBMINUSCOUNT 
	.word XT_RBMINUSHEAD
	.word XT_FETCH
	.word XT_RBMINUSTAIL
	.word XT_FETCH
	.word XT_MINUS
	.word XT_RINGUNDERBYTEMASK /* RING_BYTEMASK (nocon) */
	.word XT_AND
	.word XT_EXIT
END RBMINUSCOUNT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "rb-push", RBMINUSPUSH 
	.word XT_RBMINUSHEAD
	.word XT_FETCH
	.word XT_DUP
	.word XT_1PLUS
	.word XT_RINGUNDERBYTEMASK /* RING_BYTEMASK (nocon) */
	.word XT_AND
	.word XT_DUP
	.word XT_RBMINUSTAIL
	.word XT_FETCH
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,RBMINUSPUSH_0001 /* if */
	.word XT_2DROP
	.word XT_DROP
	.word XT_ZERO
	.word XT_FINISH
RBMINUSPUSH_0001: /* then */
	.word XT_TO_R
	.word XT_RBMINUSBUF
	.word XT_PLUS
	.word XT_CSTORE
	.word XT_R_FROM
	.word XT_RBMINUSHEAD
	.word XT_STORE
	.word XT_MINUSONE
	.word XT_EXIT
END RBMINUSPUSH
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "rb-pop", RBMINUSPOP 
	.word XT_RBMINUSTAIL
	.word XT_FETCH
	.word XT_DUP
	.word XT_RBMINUSBUF
	.word XT_PLUS
	.word XT_CFETCH
	.word XT_SWAP
	.word XT_1PLUS
	.word XT_RINGUNDERBYTEMASK /* RING_BYTEMASK (nocon) */
	.word XT_AND
	.word XT_RBMINUSTAIL
	.word XT_STORE
	.word XT_EXIT
END RBMINUSPOP
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "tb-empty?", TBMINUSEMPTYQ 
	.word XT_TBMINUSHEAD
	.word XT_FETCH
	.word XT_TBMINUSTAIL
	.word XT_FETCH
	.word XT_EQUAL
	.word XT_EXIT
END TBMINUSEMPTYQ
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "tb-full?", TBMINUSFULLQ 
	.word XT_TBMINUSHEAD
	.word XT_FETCH
	.word XT_1PLUS
	.word XT_RINGUNDERBYTEMASK /* RING_BYTEMASK (nocon) */
	.word XT_AND
	.word XT_TBMINUSTAIL
	.word XT_FETCH
	.word XT_EQUAL
	.word XT_EXIT
END TBMINUSFULLQ
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "tb-count", TBMINUSCOUNT 
	.word XT_TBMINUSHEAD
	.word XT_FETCH
	.word XT_TBMINUSTAIL
	.word XT_FETCH
	.word XT_MINUS
	.word XT_RINGUNDERBYTEMASK /* RING_BYTEMASK (nocon) */
	.word XT_AND
	.word XT_EXIT
END TBMINUSCOUNT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "tb-push", TBMINUSPUSH 
	.word XT_TBMINUSHEAD
	.word XT_FETCH
	.word XT_DUP
	.word XT_1PLUS
	.word XT_RINGUNDERBYTEMASK /* RING_BYTEMASK (nocon) */
	.word XT_AND
	.word XT_DUP
	.word XT_TBMINUSTAIL
	.word XT_FETCH
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,TBMINUSPUSH_0001 /* if */
	.word XT_2DROP
	.word XT_DROP
	.word XT_ZERO
	.word XT_FINISH
TBMINUSPUSH_0001: /* then */
	.word XT_TO_R
	.word XT_TBMINUSBUF
	.word XT_PLUS
	.word XT_CSTORE
	.word XT_R_FROM
	.word XT_TBMINUSHEAD
	.word XT_STORE
	.word XT_MINUSONE
	.word XT_EXIT
END TBMINUSPUSH
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "tb-pop", TBMINUSPOP 
	.word XT_TBMINUSTAIL
	.word XT_FETCH
	.word XT_DUP
	.word XT_TBMINUSBUF
	.word XT_PLUS
	.word XT_CFETCH
	.word XT_SWAP
	.word XT_1PLUS
	.word XT_RINGUNDERBYTEMASK /* RING_BYTEMASK (nocon) */
	.word XT_AND
	.word XT_TBMINUSTAIL
	.word XT_STORE
	.word XT_EXIT
END TBMINUSPOP
# ----------------------------------------------------------------------
COLON "+irq", PLUSIRQ 
	.word XT_DUP
	.word XT_DOLITERAL
	.word 5
	.word XT_RSHIFT
	.word XT_CELLS
	.word XT_DOLITERAL
	.word 3758153984 /* PFIC_IENR_BASE (inline constant) */
	.word XT_PLUS
	.word XT_SWAP
	.word XT_DOLITERAL
	.word 0x1f
	.word XT_AND
	.word XT_ONE
	.word XT_SWAP
	.word XT_LSHIFT
	.word XT_SWAP
	.word XT_STORE
	.word XT_EXIT
END PLUSIRQ
# ----------------------------------------------------------------------
COLON "-irq", MINUSIRQ 
	.word XT_DUP
	.word XT_DOLITERAL
	.word 5
	.word XT_RSHIFT
	.word XT_CELLS
	.word XT_DOLITERAL
	.word 3758154112 /* PFIC_IRER_BASE (inline constant) */
	.word XT_PLUS
	.word XT_SWAP
	.word XT_DOLITERAL
	.word 0x1f
	.word XT_AND
	.word XT_ONE
	.word XT_SWAP
	.word XT_LSHIFT
	.word XT_SWAP
	.word XT_STORE
	.word XT_EXIT
END MINUSIRQ
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "+usbhs.clk", PLUSUSBHSDOTCLK 
	.word XT_DOLITERAL
	.word 3506438144 /* USBHS_CFGR2_VAL (inline constant) */
	.word XT_DOLITERAL
	.word 1073877036 /* R32_RCC_CFGR2 (inline constant) */
	.word XT_STORE
	.word XT_R32UNDERRCCUNDERAHBPCENR /* R32_RCC_AHBPCENR (nocon) */
	.word XT_FETCH
	.word XT_DOLITERAL
	.word 2048 /* USBHS_AHBEN_BIT (inline constant) */
	.word XT_OR
	.word XT_R32UNDERRCCUNDERAHBPCENR /* R32_RCC_AHBPCENR (nocon) */
	.word XT_STORE
	.word XT_EXIT
END PLUSUSBHSDOTCLK
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "usb-delay", USBMINUSDELAY 
	.word XT_DOLITERAL
	.word 1000
	.word XT_ZERO
	.word XT_DODO
USBMINUSDELAY_0002: /* do */
	.word XT_DOLOOP,USBMINUSDELAY_0002 /* loop */
USBMINUSDELAY_0001: /* (for ?do IF required) */
	.word XT_EXIT
END USBMINUSDELAY
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "+usbhs-device", PLUSUSBHSMINUSDEVICE 
	.word XT_UCUNDERCLRUNDERALL /* UC_CLR_ALL (nocon) */
	.word XT_DOLITERAL
	.word 4 /* UC_RESET_SIE (inline constant) */
	.word XT_OR
	.word XT_R8UNDERUSBUNDERCTRL /* R8_USB_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_USBMINUSDELAY
	.word XT_UCUNDERCLRUNDERALL /* UC_CLR_ALL (nocon) */
	.word XT_R8UNDERUSBUNDERCTRL /* R8_USB_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_DOLITERAL
	.word 0x10
	.word XT_DOLITERAL
	.word 1073886209 /* R8_UHOST_CTRL (inline constant) */
	.word XT_CSTORE
	.word XT_DOLITERAL
	.word 1 /* UC_DMA_EN (inline constant) */
	.word XT_DOLITERAL
	.word 8 /* UC_INT_BUSY (inline constant) */
	.word XT_OR
	.word XT_DOLITERAL
	.word 32 /* UC_SPEED_HIGH (inline constant) */
	.word XT_OR
	.word XT_R8UNDERUSBUNDERCTRL /* R8_USB_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_DOLITERAL
	.word 32 /* UIE_SETUP_ACT_BIT (inline constant) */
	.word XT_DOLITERAL
	.word 2 /* UIE_TRANSFER_BIT (inline constant) */
	.word XT_OR
	.word XT_DOLITERAL
	.word 1 /* UIE_BUS_RST_BIT (inline constant) */
	.word XT_OR
	.word XT_DOLITERAL
	.word 4 /* UIE_SUSPEND_BIT (inline constant) */
	.word XT_OR
	.word XT_DOLITERAL
	.word 1073886210 /* R8_USB_INT_EN (inline constant) */
	.word XT_CSTORE
	.word XT_DOLITERAL
	.word 1 /* UC_DMA_EN (inline constant) */
	.word XT_DOLITERAL
	.word 8 /* UC_INT_BUSY (inline constant) */
	.word XT_OR
	.word XT_DOLITERAL
	.word 32 /* UC_SPEED_HIGH (inline constant) */
	.word XT_OR
	.word XT_DOLITERAL
	.word 16 /* UC_DEV_PU_EN (inline constant) */
	.word XT_OR
	.word XT_R8UNDERUSBUNDERCTRL /* R8_USB_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_EXIT
END PLUSUSBHSMINUSDEVICE
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "uintst@", UINTSTAT 
	.word XT_DOLITERAL
	.word 1073886219 /* R8_USB_INT_ST (inline constant) */
	.word XT_CFETCH
	.word XT_EXIT
END UINTSTAT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "uintfg@", UINTFGAT 
	.word XT_R8UNDERUSBUNDERINTUNDERFG /* R8_USB_INT_FG (nocon) */
	.word XT_CFETCH
	.word XT_EXIT
END UINTFGAT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "uintfg!", UINTFGBANG 
	.word XT_R8UNDERUSBUNDERINTUNDERFG /* R8_USB_INT_FG (nocon) */
	.word XT_CSTORE
	.word XT_EXIT
END UINTFGBANG
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "cfgr2@", CFGR2AT 
	.word XT_DOLITERAL
	.word 1073877036 /* R32_RCC_CFGR2 (inline constant) */
	.word XT_FETCH
	.word XT_EXIT
END CFGR2AT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "ahbpcenr@", AHBPCENRAT 
	.word XT_R32UNDERRCCUNDERAHBPCENR /* R32_RCC_AHBPCENR (nocon) */
	.word XT_FETCH
	.word XT_EXIT
END AHBPCENRAT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "uctrl@", UCTRLAT 
	.word XT_R8UNDERUSBUNDERCTRL /* R8_USB_CTRL (nocon) */
	.word XT_CFETCH
	.word XT_EXIT
END UCTRLAT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "uinten@", UINTENAT 
	.word XT_DOLITERAL
	.word 1073886210 /* R8_USB_INT_EN (inline constant) */
	.word XT_CFETCH
	.word XT_EXIT
END UINTENAT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "uhost@", UHOSTAT 
	.word XT_DOLITERAL
	.word 1073886209 /* R8_UHOST_CTRL (inline constant) */
	.word XT_CFETCH
	.word XT_EXIT
END UHOSTAT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "uspeed@", USPEEDAT 
	.word XT_DOLITERAL
	.word 1073886216 /* R8_USB_SPPED_TYPE (inline constant) */
	.word XT_CFETCH
	.word XT_EXIT
END USPEEDAT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "umis@", UMISAT 
	.word XT_DOLITERAL
	.word 1073886217 /* R8_USB_MIS_ST (inline constant) */
	.word XT_CFETCH
	.word XT_EXIT
END UMISAT
# ----------------------------------------------------------------------
/* align - ignored */
NODATA "dev-descr", DEVMINUSDESCR
	.byte 18
	.byte 1
	.byte 0x10
	.byte 1
	.byte 2
	.byte 0
	.byte 0
	.byte 64
	.byte 0x9
	.byte 0x12
	.byte 0x1
	.byte 0x0
	.byte 0x1
	.byte 0x0
	.byte 1
	.byte 1
	.byte 2
	.byte 1
	.p2align 2,0x55
	.word XT_EXIT
END DEVMINUSDESCR
NODATA "cfg-descr", CFGMINUSDESCR
	.byte 9
	.byte 2
	.byte 67
	.byte 0
	.byte 2
	.byte 1
	.byte 0
	.byte 0x80
	.byte 50
	.byte 9
	.byte 4
	.byte 0
	.byte 0
	.byte 1
	.byte 2
	.byte 2
	.byte 1
	.byte 0
	.byte 5
	.byte 0x24
	.byte 0
	.byte 0x10
	.byte 1
	.byte 5
	.byte 0x24
	.byte 1
	.byte 0
	.byte 0
	.byte 4
	.byte 0x24
	.byte 2
	.byte 2
	.byte 5
	.byte 0x24
	.byte 6
	.byte 0
	.byte 1
	.byte 7
	.byte 5
	.byte 0x83
	.byte 3
	.byte 64
	.byte 0
	.byte 9
	.byte 9
	.byte 4
	.byte 1
	.byte 0
	.byte 2
	.byte 10
	.byte 0
	.byte 0
	.byte 0
	.byte 7
	.byte 5
	.byte 2
	.byte 2
	.byte 0
	.byte 2
	.byte 0
	.byte 7
	.byte 5
	.byte 0x82
	.byte 2
	.byte 0
	.byte 2
	.byte 0
	.p2align 2,0x55
	.word XT_EXIT
END CFGMINUSDESCR
NODATA "str0", STR0
	.byte 4
	.byte 3
	.byte 0x9
	.byte 0x4
	.p2align 2,0x55
	.word XT_EXIT
END STR0
NODATA "str1", STR1
	.byte 20
	.byte 3
	.byte 0x61
	.byte 0
	.byte 0x6d
	.byte 0
	.byte 0x66
	.byte 0
	.byte 0x6f
	.byte 0
	.byte 0x72
	.byte 0
	.byte 0x74
	.byte 0
	.byte 0x68
	.byte 0
	.byte 0x33
	.byte 0
	.byte 0x32
	.byte 0
	.p2align 2,0x55
	.word XT_EXIT
END STR1
NODATA "str2", STR2
	.byte 20
	.byte 3
	.byte 0x61
	.byte 0
	.byte 0x6d
	.byte 0
	.byte 0x66
	.byte 0
	.byte 0x6f
	.byte 0
	.byte 0x72
	.byte 0
	.byte 0x74
	.byte 0
	.byte 0x68
	.byte 0
	.byte 0x33
	.byte 0
	.byte 0x32
	.byte 0
	.p2align 2,0x55
	.word XT_EXIT
END STR2
NODATA "line-coding", LINEMINUSCODING
	.byte 0x0
	.byte 0xc2
	.byte 0x1
	.byte 0x0
	.byte 0
	.byte 0
	.byte 8
	.p2align 2,0x55
	.word XT_EXIT
END LINEMINUSCODING
NODATA "status-buf", STATUSMINUSBUF
	.byte 0
	.byte 0
	.p2align 2,0x55
	.word XT_EXIT
END STATUSMINUSBUF
NONVAR "setup-log", SETUPMINUSLOG, 4
END SETUPMINUSLOG
NOVAR "setup-log-idx", SETUPMINUSLOGMINUSIDX
END SETUPMINUSLOGMINUSIDX
NOVAR "bad-request", BADMINUSREQUEST
END BADMINUSREQUEST
NOVAR "bad-desc-type", BADMINUSDESCMINUSTYPE
END BADMINUSDESCMINUSTYPE
NOVAR "pending-addr", PENDINGMINUSADDR
END PENDINGMINUSADDR
NOVAR "current-config", CURRENTMINUSCONFIG
END CURRENTMINUSCONFIG
NOVAR "ep0-tx-src", EP0MINUSTXMINUSSRC
END EP0MINUSTXMINUSSRC
NOVAR "ep0-tx-rem", EP0MINUSTXMINUSREM
END EP0MINUSTXMINUSREM
NOVAR "ep0-tx-tog", EP0MINUSTXMINUSTOG
END EP0MINUSTXMINUSTOG
NOVAR "expecting-out-data", EXPECTINGMINUSOUTMINUSDATA
END EXPECTINGMINUSOUTMINUSDATA
NOVAR "last-desc-type", LASTMINUSDESCMINUSTYPE
END LASTMINUSDESCMINUSTYPE
NOVAR "last-desc-len", LASTMINUSDESCMINUSLEN
END LASTMINUSDESCMINUSLEN
NOVAR "last-sent-len", LASTMINUSSENTMINUSLEN
END LASTMINUSSENTMINUSLEN
NOVAR "last-setup-len", LASTMINUSSETUPMINUSLEN
END LASTMINUSSETUPMINUSLEN
NOVAR "ep2-tx-busy", EP2MINUSTXMINUSBUSY
END EP2MINUSTXMINUSBUSY
NOVAR "ep2-rx-count", EP2MINUSRXMINUSCOUNT
END EP2MINUSRXMINUSCOUNT
NOVAR "ep2-tx-count", EP2MINUSTXMINUSCOUNT
END EP2MINUSTXMINUSCOUNT
NOVAR "last-uintst", LASTMINUSUINTST
END LASTMINUSUINTST
NOVAR "last-dispatch-tag", LASTMINUSDISPATCHMINUSTAG
END LASTMINUSDISPATCHMINUSTAG
NOVAR "last-intfg", LASTMINUSINTFG
END LASTMINUSINTFG
# ----------------------------------------------------------------------
NONAME "setup-rtype", SETUPMINUSRTYPE 
	.word XT_EP0BUF
	.word XT_ZERO
	.word XT_PLUS
	.word XT_CFETCH
	.word XT_EXIT
END SETUPMINUSRTYPE
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "setup-request", SETUPMINUSREQUEST 
	.word XT_EP0BUF
	.word XT_ONE
	.word XT_PLUS
	.word XT_CFETCH
	.word XT_EXIT
END SETUPMINUSREQUEST
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "setup-value-lo", SETUPMINUSVALUEMINUSLO 
	.word XT_EP0BUF
	.word XT_TWO
	.word XT_PLUS
	.word XT_CFETCH
	.word XT_EXIT
END SETUPMINUSVALUEMINUSLO
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "setup-value-hi", SETUPMINUSVALUEMINUSHI 
	.word XT_EP0BUF
	.word XT_DOLITERAL
	.word 3
	.word XT_PLUS
	.word XT_CFETCH
	.word XT_EXIT
END SETUPMINUSVALUEMINUSHI
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "setup-length", SETUPMINUSLENGTH 
	.word XT_EP0BUF
	.word XT_DOLITERAL
	.word 6
	.word XT_PLUS
	.word XT_CFETCH
	.word XT_EP0BUF
	.word XT_DOLITERAL
	.word 7
	.word XT_PLUS
	.word XT_CFETCH
	.word XT_DOLITERAL
	.word 8
	.word XT_LSHIFT
	.word XT_OR
	.word XT_EXIT
END SETUPMINUSLENGTH
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "log-setup-bytes", LOGMINUSSETUPMINUSBYTES 
	.word XT_SETUPMINUSRTYPE
	.word XT_SETUPMINUSLOG
	.word XT_SETUPMINUSLOGMINUSIDX
	.word XT_FETCH
	.word XT_PLUS
	.word XT_CSTORE
	.word XT_SETUPMINUSLOGMINUSIDX
	.word XT_FETCH
	.word XT_1PLUS
	.word XT_DOLITERAL
	.word 0xf
	.word XT_AND
	.word XT_SETUPMINUSLOGMINUSIDX
	.word XT_STORE
	.word XT_SETUPMINUSREQUEST
	.word XT_SETUPMINUSLOG
	.word XT_SETUPMINUSLOGMINUSIDX
	.word XT_FETCH
	.word XT_PLUS
	.word XT_CSTORE
	.word XT_SETUPMINUSLOGMINUSIDX
	.word XT_FETCH
	.word XT_1PLUS
	.word XT_DOLITERAL
	.word 0xf
	.word XT_AND
	.word XT_SETUPMINUSLOGMINUSIDX
	.word XT_STORE
	.word XT_EXIT
END LOGMINUSSETUPMINUSBYTES
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "ep0-stall", EP0MINUSSTALL 
	.word XT_UEPUNDERTUNDERTOGUNDERDATA1 /* UEP_T_TOG_DATA1 (nocon) */
	.word XT_DOLITERAL
	.word 3 /* UEP_T_RES_STALL (inline constant) */
	.word XT_OR
	.word XT_R8UNDERUEP0UNDERTXUNDERCTRL /* R8_UEP0_TX_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_DOLITERAL
	.word 8 /* UEP_R_TOG_DATA1 (inline constant) */
	.word XT_DOLITERAL
	.word 3 /* UEP_R_RES_STALL (inline constant) */
	.word XT_OR
	.word XT_DOLITERAL
	.word 1073886427 /* R8_UEP0_RX_CTRL (inline constant) */
	.word XT_CSTORE
	.word XT_EXIT
END EP0MINUSSTALL
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "ep0-status-in", EP0MINUSSTATUSMINUSIN 
	.word XT_ZERO
	.word XT_DOLITERAL
	.word 1073886424 /* R16_UEP0_T_LEN (inline constant) */
	.word XT_HSTORE
	.word XT_UEPUNDERTUNDERTOGUNDERDATA1 /* UEP_T_TOG_DATA1 (nocon) */
	.word XT_UEPUNDERTUNDERRESUNDERACK /* UEP_T_RES_ACK (nocon) */
	.word XT_OR
	.word XT_R8UNDERUEP0UNDERTXUNDERCTRL /* R8_UEP0_TX_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_EXIT
END EP0MINUSSTATUSMINUSIN
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "ep0-arm-tog", EP0MINUSARMMINUSTOG 
	.word XT_DOLITERAL
	.word 1073886424 /* R16_UEP0_T_LEN (inline constant) */
	.word XT_HSTORE
	.word XT_EP0MINUSTXMINUSTOG
	.word XT_FETCH
	.word XT_UEPUNDERTUNDERRESUNDERACK /* UEP_T_RES_ACK (nocon) */
	.word XT_OR
	.word XT_R8UNDERUEP0UNDERTXUNDERCTRL /* R8_UEP0_TX_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_EP0MINUSTXMINUSTOG
	.word XT_FETCH
	.word XT_UEPUNDERTUNDERTOGUNDERDATA1 /* UEP_T_TOG_DATA1 (nocon) */
	.word XT_XOR
	.word XT_EP0MINUSTXMINUSTOG
	.word XT_STORE
	.word XT_EXIT
END EP0MINUSARMMINUSTOG
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "ep0-tx-next", EP0MINUSTXMINUSNEXT 
	.word XT_EP0MINUSTXMINUSREM
	.word XT_FETCH
	.word XT_QDUP
	.word XT_DOCONDBRANCH,EP0MINUSTXMINUSNEXT_0001 /* if */
	.word XT_DOLITERAL
	.word 64
	.word XT_MIN
	.word XT_DUP
	.word XT_TO_R
	.word XT_EP0MINUSTXMINUSSRC
	.word XT_FETCH
	.word XT_EP0BUF
	.word XT_R_FETCH
	.word XT_MOVE
	.word XT_R_FETCH
	.word XT_EP0MINUSTXMINUSSRC
	.word XT_PLUSSTORE
	.word XT_R_FETCH
	.word XT_NEGATE
	.word XT_EP0MINUSTXMINUSREM
	.word XT_PLUSSTORE
	.word XT_R_FROM
	.word XT_EP0MINUSARMMINUSTOG
EP0MINUSTXMINUSNEXT_0001: /* then */
	.word XT_EXIT
END EP0MINUSTXMINUSNEXT
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "send-descriptor", SENDMINUSDESCRIPTOR 
	.word XT_SETUPMINUSLENGTH
	.word XT_DUP
	.word XT_LASTMINUSSETUPMINUSLEN
	.word XT_STORE
	.word XT_MIN
	.word XT_DUP
	.word XT_LASTMINUSSENTMINUSLEN
	.word XT_STORE
	.word XT_EP0MINUSTXMINUSREM
	.word XT_STORE
	.word XT_EP0MINUSTXMINUSSRC
	.word XT_STORE
	.word XT_UEPUNDERTUNDERTOGUNDERDATA1 /* UEP_T_TOG_DATA1 (nocon) */
	.word XT_EP0MINUSTXMINUSTOG
	.word XT_STORE
	.word XT_EP0MINUSTXMINUSNEXT
	.word XT_EXIT
END SENDMINUSDESCRIPTOR
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "+ep-bulk", PLUSEPMINUSBULK 
	.word XT_EP2UNDERRXUNDERBUF
	.word XT_DOLITERAL
	.word 1073886244 /* R32_UEP2_RX_DMA (inline constant) */
	.word XT_STORE
	.word XT_EP2UNDERTXUNDERBUF
	.word XT_DOLITERAL
	.word 1073886304 /* R32_UEP2_TX_DMA (inline constant) */
	.word XT_STORE
	.word XT_EP3UNDERTXUNDERBUF
	.word XT_DOLITERAL
	.word 1073886308 /* R32_UEP3_TX_DMA (inline constant) */
	.word XT_STORE
	.word XT_DOLITERAL
	.word 512
	.word XT_DOLITERAL
	.word 1073886368 /* R16_UEP2_MAX_LEN (inline constant) */
	.word XT_HSTORE
	.word XT_DOLITERAL
	.word 64
	.word XT_DOLITERAL
	.word 1073886372 /* R16_UEP3_MAX_LEN (inline constant) */
	.word XT_HSTORE
	.word XT_UEPUNDERRUNDERRESUNDERACK /* UEP_R_RES_ACK (nocon) */
	.word XT_DOLITERAL
	.word 32 /* UEP_R_AUTO_TOG (inline constant) */
	.word XT_OR
	.word XT_R8UNDERUEP2UNDERRXUNDERCTRL /* R8_UEP2_RX_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_UEPUNDERTUNDERRESUNDERNAK /* UEP_T_RES_NAK (nocon) */
	.word XT_DOLITERAL
	.word 32 /* UEP_T_AUTO_TOG (inline constant) */
	.word XT_OR
	.word XT_R8UNDERUEP2UNDERTXUNDERCTRL /* R8_UEP2_TX_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_UEPUNDERTUNDERRESUNDERNAK /* UEP_T_RES_NAK (nocon) */
	.word XT_DOLITERAL
	.word 1073886438 /* R8_UEP3_TX_CTRL (inline constant) */
	.word XT_CSTORE
	.word XT_ZERO
	.word XT_EP2MINUSTXMINUSBUSY
	.word XT_STORE
	.word XT_DOLITERAL
	.word 0x4000c
	.word XT_DOLITERAL
	.word 1073886224 /* R32_UEP_CONFIG (inline constant) */
	.word XT_STORE
	.word XT_EXIT
END PLUSEPMINUSBULK
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "ep2-rx-drain", EP2MINUSRXMINUSDRAIN 
	.word XT_DOLITERAL
	.word 1073886220 /* R16_USB_RX_LEN (inline constant) */
	.word XT_HFETCH
	.word XT_DUP
	.word XT_EP2MINUSRXMINUSCOUNT
	.word XT_PLUSSTORE
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,EP2MINUSRXMINUSDRAIN_0001 /* ?do */
	.word XT_DODO
EP2MINUSRXMINUSDRAIN_0002: /* do */
	.word XT_EP2UNDERRXUNDERBUF
	.word XT_I
	.word XT_PLUS
	.word XT_CFETCH
	.word XT_RBMINUSPUSH
	.word XT_DROP
	.word XT_DOLOOP,EP2MINUSRXMINUSDRAIN_0002 /* loop */
EP2MINUSRXMINUSDRAIN_0001: /* (for ?do IF required) */
	.word XT_RBMINUSCOUNT
	.word XT_DOLITERAL
	.word 512
	.word XT_LESS
	.word XT_DOCONDBRANCH,EP2MINUSRXMINUSDRAIN_0003 /* if */
	.word XT_R8UNDERUEP2UNDERRXUNDERCTRL /* R8_UEP2_RX_CTRL (nocon) */
	.word XT_CFETCH
	.word XT_DOLITERAL
	.word 0xfc
	.word XT_AND
	.word XT_UEPUNDERRUNDERRESUNDERACK /* UEP_R_RES_ACK (nocon) */
	.word XT_OR
	.word XT_R8UNDERUEP2UNDERRXUNDERCTRL /* R8_UEP2_RX_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_MINUSLED
	.word XT_DOBRANCH,EP2MINUSRXMINUSDRAIN_0004
EP2MINUSRXMINUSDRAIN_0003: /* else */
	.word XT_R8UNDERUEP2UNDERRXUNDERCTRL /* R8_UEP2_RX_CTRL (nocon) */
	.word XT_CFETCH
	.word XT_DOLITERAL
	.word 0xfc
	.word XT_AND
	.word XT_DOLITERAL
	.word 2 /* UEP_R_RES_NAK (inline constant) */
	.word XT_OR
	.word XT_R8UNDERUEP2UNDERRXUNDERCTRL /* R8_UEP2_RX_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_PLUSLED
EP2MINUSRXMINUSDRAIN_0004: /* then */
	.word XT_EXIT
END EP2MINUSRXMINUSDRAIN
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "ep2-tx-pump-unsafe", EP2MINUSTXMINUSPUMPMINUSUNSAFE 
	.word XT_EP2MINUSTXMINUSBUSY
	.word XT_FETCH
	.word XT_DOCONDBRANCH,EP2MINUSTXMINUSPUMPMINUSUNSAFE_0001 /* if */
	.word XT_FINISH
EP2MINUSTXMINUSPUMPMINUSUNSAFE_0001: /* then */
	.word XT_TBMINUSCOUNT
	.word XT_QDUP
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,EP2MINUSTXMINUSPUMPMINUSUNSAFE_0002 /* if */
	.word XT_FINISH
EP2MINUSTXMINUSPUMPMINUSUNSAFE_0002: /* then */
	.word XT_DOLITERAL
	.word 512
	.word XT_MIN
	.word XT_DUP
	.word XT_TO_R
	.word XT_ZERO
	.word XT_QDOCHECK, XT_DOCONDBRANCH,EP2MINUSTXMINUSPUMPMINUSUNSAFE_0003 /* ?do */
	.word XT_DODO
EP2MINUSTXMINUSPUMPMINUSUNSAFE_0004: /* do */
	.word XT_TBMINUSPOP
	.word XT_EP2UNDERTXUNDERBUF
	.word XT_I
	.word XT_PLUS
	.word XT_CSTORE
	.word XT_DOLOOP,EP2MINUSTXMINUSPUMPMINUSUNSAFE_0004 /* loop */
EP2MINUSTXMINUSPUMPMINUSUNSAFE_0003: /* (for ?do IF required) */
	.word XT_R_FROM
	.word XT_DUP
	.word XT_EP2MINUSTXMINUSCOUNT
	.word XT_PLUSSTORE
	.word XT_DOLITERAL
	.word 1073886432 /* R16_UEP2_T_LEN (inline constant) */
	.word XT_HSTORE
	.word XT_R8UNDERUEP2UNDERTXUNDERCTRL /* R8_UEP2_TX_CTRL (nocon) */
	.word XT_CFETCH
	.word XT_DOLITERAL
	.word 0xfc
	.word XT_AND
	.word XT_UEPUNDERTUNDERRESUNDERACK /* UEP_T_RES_ACK (nocon) */
	.word XT_OR
	.word XT_R8UNDERUEP2UNDERTXUNDERCTRL /* R8_UEP2_TX_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_ONE
	.word XT_EP2MINUSTXMINUSBUSY
	.word XT_STORE
	.word XT_EXIT
END EP2MINUSTXMINUSPUMPMINUSUNSAFE
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "ep2-tx-pump", EP2MINUSTXMINUSPUMP 
	.word XT_HASHUSBHS
	.word XT_MINUSIRQ
	.word XT_EP2MINUSTXMINUSPUMPMINUSUNSAFE
	.word XT_HASHUSBHS
	.word XT_PLUSIRQ
	.word XT_EXIT
END EP2MINUSTXMINUSPUMP
# ----------------------------------------------------------------------
NOVAR "txc-call-count", TXCMINUSCALLMINUSCOUNT
END TXCMINUSCALLMINUSCOUNT
# ----------------------------------------------------------------------
NONAME "ep2-tx-complete", EP2MINUSTXMINUSCOMPLETE 
	.word XT_ONE
	.word XT_TXCMINUSCALLMINUSCOUNT
	.word XT_PLUSSTORE
	.word XT_ZERO
	.word XT_EP2MINUSTXMINUSBUSY
	.word XT_STORE
	.word XT_R8UNDERUEP2UNDERTXUNDERCTRL /* R8_UEP2_TX_CTRL (nocon) */
	.word XT_CFETCH
	.word XT_DOLITERAL
	.word 0xfc
	.word XT_AND
	.word XT_UEPUNDERTUNDERRESUNDERNAK /* UEP_T_RES_NAK (nocon) */
	.word XT_OR
	.word XT_R8UNDERUEP2UNDERTXUNDERCTRL /* R8_UEP2_TX_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_EP2MINUSTXMINUSPUMPMINUSUNSAFE
	.word XT_EXIT
END EP2MINUSTXMINUSCOMPLETE
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "handle-get-descriptor", HANDLEMINUSGETMINUSDESCRIPTOR 
	.word XT_SETUPMINUSVALUEMINUSHI
	.word XT_DUP
	.word XT_LASTMINUSDESCMINUSTYPE
	.word XT_STORE
	.word XT_DOLITERAL
	.word 1 /* DESC_TYPE_DEVICE (inline constant) */
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSGETMINUSDESCRIPTOR_0001 /* if */
	.word XT_DROP
	.word XT_DOLITERAL
	.word 18 /* DEV_DESCR_LEN (inline constant) */
	.word XT_DUP
	.word XT_LASTMINUSDESCMINUSLEN
	.word XT_STORE
	.word XT_TO_R
	.word XT_DEVMINUSDESCR
	.word XT_R_FROM
	.word XT_SENDMINUSDESCRIPTOR
	.word XT_DOBRANCH,HANDLEMINUSGETMINUSDESCRIPTOR_0002
HANDLEMINUSGETMINUSDESCRIPTOR_0001: /* else */
	.word XT_DOLITERAL
	.word 2 /* DESC_TYPE_CONFIG (inline constant) */
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSGETMINUSDESCRIPTOR_0003 /* if */
	.word XT_DROP
	.word XT_DOLITERAL
	.word 67 /* CFG_DESCR_LEN (inline constant) */
	.word XT_DUP
	.word XT_LASTMINUSDESCMINUSLEN
	.word XT_STORE
	.word XT_TO_R
	.word XT_CFGMINUSDESCR
	.word XT_R_FROM
	.word XT_SENDMINUSDESCRIPTOR
	.word XT_DOBRANCH,HANDLEMINUSGETMINUSDESCRIPTOR_0004
HANDLEMINUSGETMINUSDESCRIPTOR_0003: /* else */
	.word XT_DOLITERAL
	.word 3 /* DESC_TYPE_STRING (inline constant) */
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSGETMINUSDESCRIPTOR_0005 /* if */
	.word XT_DROP
	.word XT_SETUPMINUSVALUEMINUSLO
	.word XT_ZERO
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSGETMINUSDESCRIPTOR_0006 /* if */
	.word XT_DROP
	.word XT_STR0
	.word XT_DOLITERAL
	.word 4 /* STR0_LEN (inline constant) */
	.word XT_SENDMINUSDESCRIPTOR
	.word XT_DOBRANCH,HANDLEMINUSGETMINUSDESCRIPTOR_0007
HANDLEMINUSGETMINUSDESCRIPTOR_0006: /* else */
	.word XT_ONE
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSGETMINUSDESCRIPTOR_0008 /* if */
	.word XT_DROP
	.word XT_STR1
	.word XT_DOLITERAL
	.word 20 /* STR1_LEN (inline constant) */
	.word XT_SENDMINUSDESCRIPTOR
	.word XT_DOBRANCH,HANDLEMINUSGETMINUSDESCRIPTOR_0009
HANDLEMINUSGETMINUSDESCRIPTOR_0008: /* else */
	.word XT_TWO
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSGETMINUSDESCRIPTOR_000A /* if */
	.word XT_DROP
	.word XT_STR2
	.word XT_DOLITERAL
	.word 20 /* STR2_LEN (inline constant) */
	.word XT_SENDMINUSDESCRIPTOR
	.word XT_DOBRANCH,HANDLEMINUSGETMINUSDESCRIPTOR_000B
HANDLEMINUSGETMINUSDESCRIPTOR_000A: /* else */
	.word XT_EP0MINUSSTALL
	.word XT_ONE
	.word XT_BADMINUSDESCMINUSTYPE
	.word XT_PLUSSTORE
	.word XT_DROP
HANDLEMINUSGETMINUSDESCRIPTOR_000B: /* then */
HANDLEMINUSGETMINUSDESCRIPTOR_0009: /* then */
HANDLEMINUSGETMINUSDESCRIPTOR_0007: /* then */
	.word XT_DOBRANCH,HANDLEMINUSGETMINUSDESCRIPTOR_000C
HANDLEMINUSGETMINUSDESCRIPTOR_0005: /* else */
	.word XT_DOLITERAL
	.word 6 /* DESC_TYPE_QUALIFIER (inline constant) */
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSGETMINUSDESCRIPTOR_000D /* if */
	.word XT_DROP
	.word XT_EP0MINUSSTALL
	.word XT_DOBRANCH,HANDLEMINUSGETMINUSDESCRIPTOR_000E
HANDLEMINUSGETMINUSDESCRIPTOR_000D: /* else */
	.word XT_EP0MINUSSTALL
	.word XT_ONE
	.word XT_BADMINUSDESCMINUSTYPE
	.word XT_PLUSSTORE
	.word XT_DROP
HANDLEMINUSGETMINUSDESCRIPTOR_000E: /* then */
HANDLEMINUSGETMINUSDESCRIPTOR_000C: /* then */
HANDLEMINUSGETMINUSDESCRIPTOR_0004: /* then */
HANDLEMINUSGETMINUSDESCRIPTOR_0002: /* then */
	.word XT_EXIT
END HANDLEMINUSGETMINUSDESCRIPTOR
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "handle-set-address", HANDLEMINUSSETMINUSADDRESS 
	.word XT_SETUPMINUSVALUEMINUSLO
	.word XT_PENDINGMINUSADDR
	.word XT_STORE
	.word XT_EP0MINUSSTATUSMINUSIN
	.word XT_EXIT
END HANDLEMINUSSETMINUSADDRESS
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "handle-set-configuration", HANDLEMINUSSETMINUSCONFIGURATION 
	.word XT_SETUPMINUSVALUEMINUSLO
	.word XT_CURRENTMINUSCONFIG
	.word XT_STORE
	.word XT_PLUSEPMINUSBULK
	.word XT_EP0MINUSSTATUSMINUSIN
	.word XT_EXIT
END HANDLEMINUSSETMINUSCONFIGURATION
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "handle-get-configuration", HANDLEMINUSGETMINUSCONFIGURATION 
	.word XT_CURRENTMINUSCONFIG
	.word XT_FETCH
	.word XT_EP0BUF
	.word XT_CSTORE
	.word XT_EP0BUF
	.word XT_ONE
	.word XT_SENDMINUSDESCRIPTOR
	.word XT_EXIT
END HANDLEMINUSGETMINUSCONFIGURATION
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "handle-get-status", HANDLEMINUSGETMINUSSTATUS 
	.word XT_STATUSMINUSBUF
	.word XT_DOLITERAL
	.word 2 /* STATUS_LEN (inline constant) */
	.word XT_SENDMINUSDESCRIPTOR
	.word XT_EXIT
END HANDLEMINUSGETMINUSSTATUS
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "handle-set-feature", HANDLEMINUSSETMINUSFEATURE 
	.word XT_EP0MINUSSTATUSMINUSIN
	.word XT_EXIT
END HANDLEMINUSSETMINUSFEATURE
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "handle-clear-feature", HANDLEMINUSCLEARMINUSFEATURE 
	.word XT_EP0MINUSSTATUSMINUSIN
	.word XT_EXIT
END HANDLEMINUSCLEARMINUSFEATURE
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "handle-class-request", HANDLEMINUSCLASSMINUSREQUEST 
	.word XT_SETUPMINUSREQUEST
	.word XT_DOLITERAL
	.word 32 /* CDC_SET_LINE_CODING (inline constant) */
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSCLASSMINUSREQUEST_0001 /* if */
	.word XT_DROP
	.word XT_ONE
	.word XT_EXPECTINGMINUSOUTMINUSDATA
	.word XT_STORE
	.word XT_DOBRANCH,HANDLEMINUSCLASSMINUSREQUEST_0002
HANDLEMINUSCLASSMINUSREQUEST_0001: /* else */
	.word XT_DOLITERAL
	.word 33 /* CDC_GET_LINE_CODING (inline constant) */
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSCLASSMINUSREQUEST_0003 /* if */
	.word XT_DROP
	.word XT_LINEMINUSCODING
	.word XT_DOLITERAL
	.word 7 /* LINE_CODING_LEN (inline constant) */
	.word XT_SENDMINUSDESCRIPTOR
	.word XT_DOBRANCH,HANDLEMINUSCLASSMINUSREQUEST_0004
HANDLEMINUSCLASSMINUSREQUEST_0003: /* else */
	.word XT_DOLITERAL
	.word 34 /* CDC_SET_CONTROL_LINE_STATE (inline constant) */
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSCLASSMINUSREQUEST_0005 /* if */
	.word XT_DROP
	.word XT_EP0MINUSSTATUSMINUSIN
	.word XT_DOBRANCH,HANDLEMINUSCLASSMINUSREQUEST_0006
HANDLEMINUSCLASSMINUSREQUEST_0005: /* else */
	.word XT_EP0MINUSSTALL
	.word XT_ONE
	.word XT_BADMINUSREQUEST
	.word XT_PLUSSTORE
	.word XT_DROP
HANDLEMINUSCLASSMINUSREQUEST_0006: /* then */
HANDLEMINUSCLASSMINUSREQUEST_0004: /* then */
HANDLEMINUSCLASSMINUSREQUEST_0002: /* then */
	.word XT_EXIT
END HANDLEMINUSCLASSMINUSREQUEST
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "handle-standard-request", HANDLEMINUSSTANDARDMINUSREQUEST 
	.word XT_SETUPMINUSREQUEST
	.word XT_DOLITERAL
	.word 0 /* USB_GET_STATUS (inline constant) */
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSSTANDARDMINUSREQUEST_0001 /* if */
	.word XT_DROP
	.word XT_HANDLEMINUSGETMINUSSTATUS
	.word XT_DOBRANCH,HANDLEMINUSSTANDARDMINUSREQUEST_0002
HANDLEMINUSSTANDARDMINUSREQUEST_0001: /* else */
	.word XT_DOLITERAL
	.word 1 /* USB_CLEAR_FEATURE (inline constant) */
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSSTANDARDMINUSREQUEST_0003 /* if */
	.word XT_DROP
	.word XT_HANDLEMINUSCLEARMINUSFEATURE
	.word XT_DOBRANCH,HANDLEMINUSSTANDARDMINUSREQUEST_0004
HANDLEMINUSSTANDARDMINUSREQUEST_0003: /* else */
	.word XT_DOLITERAL
	.word 3 /* USB_SET_FEATURE (inline constant) */
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSSTANDARDMINUSREQUEST_0005 /* if */
	.word XT_DROP
	.word XT_HANDLEMINUSSETMINUSFEATURE
	.word XT_DOBRANCH,HANDLEMINUSSTANDARDMINUSREQUEST_0006
HANDLEMINUSSTANDARDMINUSREQUEST_0005: /* else */
	.word XT_DOLITERAL
	.word 5 /* USB_SET_ADDRESS (inline constant) */
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSSTANDARDMINUSREQUEST_0007 /* if */
	.word XT_DROP
	.word XT_HANDLEMINUSSETMINUSADDRESS
	.word XT_DOBRANCH,HANDLEMINUSSTANDARDMINUSREQUEST_0008
HANDLEMINUSSTANDARDMINUSREQUEST_0007: /* else */
	.word XT_DOLITERAL
	.word 6 /* USB_GET_DESCRIPTOR (inline constant) */
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSSTANDARDMINUSREQUEST_0009 /* if */
	.word XT_DROP
	.word XT_HANDLEMINUSGETMINUSDESCRIPTOR
	.word XT_DOBRANCH,HANDLEMINUSSTANDARDMINUSREQUEST_000A
HANDLEMINUSSTANDARDMINUSREQUEST_0009: /* else */
	.word XT_DOLITERAL
	.word 8 /* USB_GET_CONFIGURATION (inline constant) */
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSSTANDARDMINUSREQUEST_000B /* if */
	.word XT_DROP
	.word XT_HANDLEMINUSGETMINUSCONFIGURATION
	.word XT_DOBRANCH,HANDLEMINUSSTANDARDMINUSREQUEST_000C
HANDLEMINUSSTANDARDMINUSREQUEST_000B: /* else */
	.word XT_DOLITERAL
	.word 9 /* USB_SET_CONFIGURATION (inline constant) */
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSSTANDARDMINUSREQUEST_000D /* if */
	.word XT_DROP
	.word XT_HANDLEMINUSSETMINUSCONFIGURATION
	.word XT_DOBRANCH,HANDLEMINUSSTANDARDMINUSREQUEST_000E
HANDLEMINUSSTANDARDMINUSREQUEST_000D: /* else */
	.word XT_EP0MINUSSTALL
	.word XT_ONE
	.word XT_BADMINUSREQUEST
	.word XT_PLUSSTORE
	.word XT_DROP
HANDLEMINUSSTANDARDMINUSREQUEST_000E: /* then */
HANDLEMINUSSTANDARDMINUSREQUEST_000C: /* then */
HANDLEMINUSSTANDARDMINUSREQUEST_000A: /* then */
HANDLEMINUSSTANDARDMINUSREQUEST_0008: /* then */
HANDLEMINUSSTANDARDMINUSREQUEST_0006: /* then */
HANDLEMINUSSTANDARDMINUSREQUEST_0004: /* then */
HANDLEMINUSSTANDARDMINUSREQUEST_0002: /* then */
	.word XT_EXIT
END HANDLEMINUSSTANDARDMINUSREQUEST
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "handle-setup", HANDLEMINUSSETUP 
	.word XT_LOGMINUSSETUPMINUSBYTES
	.word XT_ZERO
	.word XT_EP0MINUSTXMINUSREM
	.word XT_STORE
	.word XT_SETUPMINUSRTYPE
	.word XT_DOLITERAL
	.word 0x60
	.word XT_AND
	.word XT_DOLITERAL
	.word 0x0
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSSETUP_0001 /* if */
	.word XT_DROP
	.word XT_HANDLEMINUSSTANDARDMINUSREQUEST
	.word XT_DOBRANCH,HANDLEMINUSSETUP_0002
HANDLEMINUSSETUP_0001: /* else */
	.word XT_DOLITERAL
	.word 0x20
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,HANDLEMINUSSETUP_0003 /* if */
	.word XT_DROP
	.word XT_HANDLEMINUSCLASSMINUSREQUEST
	.word XT_DOBRANCH,HANDLEMINUSSETUP_0004
HANDLEMINUSSETUP_0003: /* else */
	.word XT_EP0MINUSSTALL
	.word XT_ONE
	.word XT_BADMINUSREQUEST
	.word XT_PLUSSTORE
	.word XT_DROP
HANDLEMINUSSETUP_0004: /* then */
HANDLEMINUSSETUP_0002: /* then */
	.word XT_EXIT
END HANDLEMINUSSETUP
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "handle-ep0-transfer", HANDLEMINUSEP0MINUSTRANSFER 
	.word XT_PENDINGMINUSADDR
	.word XT_FETCH
	.word XT_QDUP
	.word XT_DOCONDBRANCH,HANDLEMINUSEP0MINUSTRANSFER_0001 /* if */
	.word XT_DOLITERAL
	.word 1073886211 /* R8_USB_DEV_AD (inline constant) */
	.word XT_CSTORE
	.word XT_ZERO
	.word XT_PENDINGMINUSADDR
	.word XT_STORE
HANDLEMINUSEP0MINUSTRANSFER_0001: /* then */
	.word XT_EXPECTINGMINUSOUTMINUSDATA
	.word XT_FETCH
	.word XT_DOCONDBRANCH,HANDLEMINUSEP0MINUSTRANSFER_0002 /* if */
	.word XT_ZERO
	.word XT_EXPECTINGMINUSOUTMINUSDATA
	.word XT_STORE
	.word XT_EP0MINUSSTATUSMINUSIN
	.word XT_DOBRANCH,HANDLEMINUSEP0MINUSTRANSFER_0003
HANDLEMINUSEP0MINUSTRANSFER_0002: /* else */
	.word XT_EP0MINUSTXMINUSREM
	.word XT_FETCH
	.word XT_DOCONDBRANCH,HANDLEMINUSEP0MINUSTRANSFER_0004 /* if */
	.word XT_EP0MINUSTXMINUSNEXT
	.word XT_DOBRANCH,HANDLEMINUSEP0MINUSTRANSFER_0005
HANDLEMINUSEP0MINUSTRANSFER_0004: /* else */
	.word XT_UEPUNDERTUNDERRESUNDERNAK /* UEP_T_RES_NAK (nocon) */
	.word XT_R8UNDERUEP0UNDERTXUNDERCTRL /* R8_UEP0_TX_CTRL (nocon) */
	.word XT_CSTORE
HANDLEMINUSEP0MINUSTRANSFER_0005: /* then */
HANDLEMINUSEP0MINUSTRANSFER_0003: /* then */
	.word XT_EXIT
END HANDLEMINUSEP0MINUSTRANSFER
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "dispatch-transfer", DISPATCHMINUSTRANSFER 
	.word XT_UINTSTAT
	.word XT_DUP
	.word XT_LASTMINUSUINTST
	.word XT_STORE
	.word XT_DUP
	.word XT_DOLITERAL
	.word 0xf
	.word XT_AND
	.word XT_ZERO
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISPATCHMINUSTRANSFER_0001 /* if */
	.word XT_DROP
	.word XT_DROP
	.word XT_DOLITERAL
	.word 0xe0
	.word XT_LASTMINUSDISPATCHMINUSTAG
	.word XT_STORE
	.word XT_HANDLEMINUSEP0MINUSTRANSFER
	.word XT_DOBRANCH,DISPATCHMINUSTRANSFER_0002
DISPATCHMINUSTRANSFER_0001: /* else */
	.word XT_TWO
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISPATCHMINUSTRANSFER_0003 /* if */
	.word XT_DROP
	.word XT_DOLITERAL
	.word 0x30
	.word XT_AND
	.word XT_DOLITERAL
	.word 0x0
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISPATCHMINUSTRANSFER_0004 /* if */
	.word XT_DROP
	.word XT_DOLITERAL
	.word 0x20
	.word XT_LASTMINUSDISPATCHMINUSTAG
	.word XT_STORE
	.word XT_EP2MINUSRXMINUSDRAIN
	.word XT_DOBRANCH,DISPATCHMINUSTRANSFER_0005
DISPATCHMINUSTRANSFER_0004: /* else */
	.word XT_DOLITERAL
	.word 0x20
	.word XT_OVER
	.word XT_EQUAL
	.word XT_DOCONDBRANCH,DISPATCHMINUSTRANSFER_0006 /* if */
	.word XT_DROP
	.word XT_DOLITERAL
	.word 0x21
	.word XT_LASTMINUSDISPATCHMINUSTAG
	.word XT_STORE
	.word XT_EP2MINUSTXMINUSCOMPLETE
	.word XT_DOBRANCH,DISPATCHMINUSTRANSFER_0007
DISPATCHMINUSTRANSFER_0006: /* else */
	.word XT_DOLITERAL
	.word 0x2f
	.word XT_LASTMINUSDISPATCHMINUSTAG
	.word XT_STORE
	.word XT_DROP
DISPATCHMINUSTRANSFER_0007: /* then */
DISPATCHMINUSTRANSFER_0005: /* then */
	.word XT_DOBRANCH,DISPATCHMINUSTRANSFER_0008
DISPATCHMINUSTRANSFER_0003: /* else */
	.word XT_DOLITERAL
	.word 0xff
	.word XT_LASTMINUSDISPATCHMINUSTAG
	.word XT_STORE
	.word XT_DROP
	.word XT_DROP
DISPATCHMINUSTRANSFER_0008: /* then */
DISPATCHMINUSTRANSFER_0002: /* then */
	.word XT_EXIT
END DISPATCHMINUSTRANSFER
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "usbhs.isr", USBHSDOTISR 
	.word XT_ONE
	.word XT_USBDOTINTDOTCOUNT
	.word XT_PLUSSTORE
	.word XT_R8UNDERUSBUNDERINTUNDERFG /* R8_USB_INT_FG (nocon) */
	.word XT_CFETCH
	.word XT_DUP
	.word XT_LASTMINUSINTFG
	.word XT_STORE
	.word XT_DUP
	.word XT_DOLITERAL
	.word 1 /* UIF_BUS_RST (inline constant) */
	.word XT_AND
	.word XT_DOCONDBRANCH,USBHSDOTISR_0001 /* if */
	.word XT_ONE
	.word XT_USBDOTRSTDOTCOUNT
	.word XT_PLUSSTORE
	.word XT_ZERO
	.word XT_DOLITERAL
	.word 1073886211 /* R8_USB_DEV_AD (inline constant) */
	.word XT_CSTORE
	.word XT_ZERO
	.word XT_PENDINGMINUSADDR
	.word XT_STORE
	.word XT_ZERO
	.word XT_CURRENTMINUSCONFIG
	.word XT_STORE
	.word XT_ZERO
	.word XT_EP0MINUSTXMINUSREM
	.word XT_STORE
	.word XT_ZERO
	.word XT_EXPECTINGMINUSOUTMINUSDATA
	.word XT_STORE
	.word XT_ZERO
	.word XT_EP2MINUSTXMINUSBUSY
	.word XT_STORE
	.word XT_UEPUNDERTUNDERTOGUNDERDATA1 /* UEP_T_TOG_DATA1 (nocon) */
	.word XT_EP0MINUSTXMINUSTOG
	.word XT_STORE
	.word XT_EP0BUF
	.word XT_DOLITERAL
	.word 1073886236 /* R32_UEP0_DMA (inline constant) */
	.word XT_STORE
	.word XT_DOLITERAL
	.word 64
	.word XT_DOLITERAL
	.word 1073886360 /* R16_UEP0_MAX_LEN (inline constant) */
	.word XT_HSTORE
	.word XT_UEPUNDERTUNDERRESUNDERNAK /* UEP_T_RES_NAK (nocon) */
	.word XT_R8UNDERUEP0UNDERTXUNDERCTRL /* R8_UEP0_TX_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_UEPUNDERRUNDERRESUNDERACK /* UEP_R_RES_ACK (nocon) */
	.word XT_DOLITERAL
	.word 1073886427 /* R8_UEP0_RX_CTRL (inline constant) */
	.word XT_CSTORE
	.word XT_UEPUNDERTUNDERRESUNDERNAK /* UEP_T_RES_NAK (nocon) */
	.word XT_DOLITERAL
	.word 32 /* UEP_T_AUTO_TOG (inline constant) */
	.word XT_OR
	.word XT_R8UNDERUEP2UNDERTXUNDERCTRL /* R8_UEP2_TX_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_DOLITERAL
	.word 2 /* UEP_R_RES_NAK (inline constant) */
	.word XT_DOLITERAL
	.word 32 /* UEP_R_AUTO_TOG (inline constant) */
	.word XT_OR
	.word XT_R8UNDERUEP2UNDERRXUNDERCTRL /* R8_UEP2_RX_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_UEPUNDERTUNDERRESUNDERNAK /* UEP_T_RES_NAK (nocon) */
	.word XT_DOLITERAL
	.word 1073886438 /* R8_UEP3_TX_CTRL (inline constant) */
	.word XT_CSTORE
	.word XT_ZERO
	.word XT_DOLITERAL
	.word 1073886224 /* R32_UEP_CONFIG (inline constant) */
	.word XT_STORE
	.word XT_ZERO
	.word XT_RBMINUSHEAD
	.word XT_STORE
	.word XT_ZERO
	.word XT_RBMINUSTAIL
	.word XT_STORE
	.word XT_ZERO
	.word XT_TBMINUSHEAD
	.word XT_STORE
	.word XT_ZERO
	.word XT_TBMINUSTAIL
	.word XT_STORE
	.word XT_DOLITERAL
	.word 1 /* UIF_BUS_RST (inline constant) */
	.word XT_R8UNDERUSBUNDERINTUNDERFG /* R8_USB_INT_FG (nocon) */
	.word XT_CSTORE
USBHSDOTISR_0001: /* then */
	.word XT_DUP
	.word XT_DOLITERAL
	.word 2 /* UIF_TRANSFER (inline constant) */
	.word XT_AND
	.word XT_DOCONDBRANCH,USBHSDOTISR_0002 /* if */
	.word XT_ONE
	.word XT_USBDOTXFERDOTCOUNT
	.word XT_PLUSSTORE
	.word XT_DISPATCHMINUSTRANSFER
	.word XT_DOLITERAL
	.word 2 /* UIF_TRANSFER (inline constant) */
	.word XT_R8UNDERUSBUNDERINTUNDERFG /* R8_USB_INT_FG (nocon) */
	.word XT_CSTORE
USBHSDOTISR_0002: /* then */
	.word XT_DUP
	.word XT_DOLITERAL
	.word 32 /* UIF_SETUP_ACT (inline constant) */
	.word XT_AND
	.word XT_DOCONDBRANCH,USBHSDOTISR_0003 /* if */
	.word XT_ONE
	.word XT_USBDOTSETUPDOTCOUNT
	.word XT_PLUSSTORE
	.word XT_HANDLEMINUSSETUP
	.word XT_DOLITERAL
	.word 32 /* UIF_SETUP_ACT (inline constant) */
	.word XT_R8UNDERUSBUNDERINTUNDERFG /* R8_USB_INT_FG (nocon) */
	.word XT_CSTORE
USBHSDOTISR_0003: /* then */
	.word XT_DOLITERAL
	.word 4 /* UIF_SUSPEND (inline constant) */
	.word XT_AND
	.word XT_DOCONDBRANCH,USBHSDOTISR_0004 /* if */
	.word XT_ONE
	.word XT_USBDOTSUSPDOTCOUNT
	.word XT_PLUSSTORE
	.word XT_DOLITERAL
	.word 4 /* UIF_SUSPEND (inline constant) */
	.word XT_R8UNDERUSBUNDERINTUNDERFG /* R8_USB_INT_FG (nocon) */
	.word XT_CSTORE
USBHSDOTISR_0004: /* then */
	.word XT_EXITI
END USBHSDOTISR
# ----------------------------------------------------------------------
# ----------------------------------------------------------------------
NONAME "usb.install", USBDOTINSTALL 
	.word XT_DOXLITERAL
	.word XT_USBHSDOTISR
	.word XT_HASHUSBHS
	.word XT_TRAP_STORE
	.word XT_HASHUSBHS
	.word XT_PLUSIRQ
	.word XT_EXIT
END USBDOTINSTALL
# ----------------------------------------------------------------------
COLON "usb-emit", USBMINUSEMIT 
	.word XT_CURRENTMINUSCONFIG
	.word XT_FETCH
	.word XT_ZEROEQUAL
	.word XT_DOCONDBRANCH,USBMINUSEMIT_0001 /* if */
	.word XT_DROP
	.word XT_FINISH
USBMINUSEMIT_0001: /* then */
	.word XT_TBMINUSPUSH
	.word XT_DROP
	.word XT_EP2MINUSTXMINUSPUMP
	.word XT_EXIT
END USBMINUSEMIT
# ----------------------------------------------------------------------
COLON "usb-emit?", USBMINUSEMITQ 
	.word XT_TBMINUSFULLQ
	.word XT_INVERT
	.word XT_EXIT
END USBMINUSEMITQ
# ----------------------------------------------------------------------
COLON "usb-emit-pause", USBMINUSEMITMINUSPAUSE 
	.word XT_PAUSE
USBMINUSEMITMINUSPAUSE_0001: /* begin */
	.word XT_USBMINUSEMITQ
	.word XT_DOCONDBRANCH,USBMINUSEMITMINUSPAUSE_0001 /* until */
	.word XT_USBMINUSEMIT
	.word XT_EXIT
END USBMINUSEMITMINUSPAUSE
# ----------------------------------------------------------------------
COLON "usb-key?", USBMINUSKEYQ 
	.word XT_RBMINUSEMPTYQ
	.word XT_DOCONDBRANCH,USBMINUSKEYQ_0001 /* if */
	.word XT_R8UNDERUEP2UNDERRXUNDERCTRL /* R8_UEP2_RX_CTRL (nocon) */
	.word XT_CFETCH
	.word XT_DOLITERAL
	.word 0xfc
	.word XT_AND
	.word XT_UEPUNDERRUNDERRESUNDERACK /* UEP_R_RES_ACK (nocon) */
	.word XT_OR
	.word XT_R8UNDERUEP2UNDERRXUNDERCTRL /* R8_UEP2_RX_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_FALSE
	.word XT_DOBRANCH,USBMINUSKEYQ_0002
USBMINUSKEYQ_0001: /* else */
	.word XT_TRUE
USBMINUSKEYQ_0002: /* then */
	.word XT_EXIT
END USBMINUSKEYQ
# ----------------------------------------------------------------------
COLON "usb-key", USBMINUSKEY 
	.word XT_RBMINUSPOP
	.word XT_EXIT
END USBMINUSKEY
# ----------------------------------------------------------------------
COLON "usb-key-pause", USBMINUSKEYMINUSPAUSE 
USBMINUSKEYMINUSPAUSE_0001: /* begin */
	.word XT_PAUSE
	.word XT_USBMINUSKEYQ
	.word XT_DOCONDBRANCH,USBMINUSKEYMINUSPAUSE_0001 /* until */
	.word XT_USBMINUSKEY
	.word XT_EXIT
END USBMINUSKEYMINUSPAUSE
# ----------------------------------------------------------------------
COLON "usb-enum?", USBMINUSENUMQ /* ( -- f ) true if device is enumerated and configured */
	.word XT_CURRENTMINUSCONFIG
	.word XT_FETCH
	.word XT_NOTZEROEQUAL
	.word XT_EXIT
END USBMINUSENUMQ
# ----------------------------------------------------------------------
COLON "usb", USB /* ( -- ) switch operator to usb connection, if connection ready (10s TO)  */
	.word XT_TICKAT
	.word XT_DOLITERAL
	.word 10
	.word XT_MSDOTTICKF
	.word XT_STAR
	.word XT_TO_R
USB_0001: /* begin */
	.word XT_TICKAT
	.word XT_OVER
	.word XT_MINUS
	.word XT_R_FETCH
	.word XT_UGREATER
	.word XT_USBMINUSENUMQ
	.word XT_OR
	.word XT_DOCONDBRANCH,USB_0001 /* until */
	.word XT_DROP
	.word XT_RDROP
	.word XT_USBMINUSENUMQ
	.word XT_DOCONDBRANCH,USB_0002 /* if */
	.word XT_PLUSLED
	.word XT_DOLITERAL
	.word 1000
	.word XT_MS
	.word XT_DOXLITERAL
	.word XT_USBMINUSKEYQ
	.word XT_DOXLITERAL
	.word XT_KEYQ
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_DOXLITERAL
	.word XT_USBMINUSKEYMINUSPAUSE
	.word XT_DOXLITERAL
	.word XT_KEY
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_DOXLITERAL
	.word XT_USBMINUSEMITQ
	.word XT_DOXLITERAL
	.word XT_EMITQ
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_DOXLITERAL
	.word XT_USBMINUSEMITMINUSPAUSE
	.word XT_DOXLITERAL
	.word XT_EMIT
	.word XT_CELLPLUS
	.word XT_FETCH
	.word XT_STORE
	.word XT_MINUSLED
USB_0002: /* then */
	.word XT_EXIT
END USB
# ----------------------------------------------------------------------
COLON "usb.init", USBDOTINIT /* ( -- ) init and start usb */
	.word XT_ZERO
	.word XT_CURRENTMINUSCONFIG
	.word XT_STORE
	.word XT_ZERO
	.word XT_EP2MINUSTXMINUSBUSY
	.word XT_STORE
	.word XT_ZERO
	.word XT_PENDINGMINUSADDR
	.word XT_STORE
	.word XT_ZERO
	.word XT_EP0MINUSTXMINUSREM
	.word XT_STORE
	.word XT_ZERO
	.word XT_EXPECTINGMINUSOUTMINUSDATA
	.word XT_STORE
	.word XT_ZERO
	.word XT_RBMINUSHEAD
	.word XT_STORE
	.word XT_ZERO
	.word XT_RBMINUSTAIL
	.word XT_STORE
	.word XT_ZERO
	.word XT_TBMINUSHEAD
	.word XT_STORE
	.word XT_ZERO
	.word XT_TBMINUSTAIL
	.word XT_STORE
	.word XT_UEPUNDERTUNDERTOGUNDERDATA1 /* UEP_T_TOG_DATA1 (nocon) */
	.word XT_EP0MINUSTXMINUSTOG
	.word XT_STORE
	.word XT_PLUSUSBHSDOTCLK
	.word XT_DOLITERAL
	.word 100
	.word XT_MS
	.word XT_UCUNDERCLRUNDERALL /* UC_CLR_ALL (nocon) */
	.word XT_R8UNDERUSBUNDERCTRL /* R8_USB_CTRL (nocon) */
	.word XT_CSTORE
	.word XT_DOLITERAL
	.word 100
	.word XT_MS
	.word XT_PLUSUSBHSMINUSDEVICE
	.word XT_USBDOTINSTALL
	.word XT_EXIT
END USBDOTINIT
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
