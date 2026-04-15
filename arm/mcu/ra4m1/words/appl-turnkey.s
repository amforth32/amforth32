CODEWORD  "halt", HALT
  wfi @ there is not halt instruction, but wait for interrupt should be close enough
NEXT

COLON "appl-turnkey", APPLTURNKEY
  .word XT_DECIMAL
  .word XT_DELAY_INIT
  .word XT_UART_INIT

  @ Emit the AmForth greeting
  .word XT_DOT_VER
  .word XT_SPACE,XT_ENV_BOARD,XT_TYPE, XT_CR
  .word XT_ENV_DOT_BUILD

  @ Turn on the onboard LED to indicate that we successfully got here
  @ If the bootloader is in control the LED is softly pulsing.
  .word XT_LED_INIT, XT_LED_ON

@ Get the ESP32 AT handler connection going
@ TODO: this isn't working yet. For some reason the TDRE never comes on for the SCI1 UART.
@   It seems to initialize correctly, the SCI registers can be read and written.
@   It seems as if the ESP32 isn't reading the bytes sent on the other side,
@   but it's not clear how to debug what's going on there.
  @ .word XT_AT_UART_INIT
  @ STRING "AT +GETTIME"
  @ .word XT_AT, XT_TYPE
  
@ This makes the LED flash forever, used for initial debugging
@ LED_BLINK_LOOP:
@   .word XT_LED_ON, XT_DOLITERAL, 200, XT_MS
@   .word XT_LED_OFF, XT_DOLITERAL, 800, XT_MS
@   .word XT_DOLOOP, LED_BLINK_LOOP

.word XT_EXIT
