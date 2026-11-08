.if TARGET_VIRT==1

# VIRT
.include "words/uart-pl011.s"

.else

# MPS2
.include "words/uart-apb.s"

COLON  "serial-emit", SERIAL_EMIT
    .word XT_DOLITERAL, UART0, XT_APB_EMIT, XT_EXIT
END SERIAL_EMIT

COLON  "serial-emit?", SERIAL_EMITQ
    .word XT_DOLITERAL, UART0, XT_APB_EMITQ, XT_EXIT
END SERIAL_EMITQ

COLON  "serial-key", SERIAL_KEY
    .word XT_DOLITERAL, UART0, XT_APB_KEY, XT_EXIT
END SERIAL_KEY

COLON  "serial-key?", SERIAL_KEYQ
    .word XT_DOLITERAL, UART0, XT_APB_KEYQ, XT_EXIT
END SERIAL_KEYQ

.endif

