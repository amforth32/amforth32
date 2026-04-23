COLON "led-task", LEDMINUSTASK /* ( -- ) flash built-in LED at 2Hz */ 
LEDMINUSTASK_0001: /* begin */
	.word XT_LED_ON
	.word XT_DOLITERAL
	.word 250
	.word XT_MS
    .word XT_LED_OFF
	.word XT_DOLITERAL
	.word 250
	.word XT_MS
	.word XT_DOBRANCH,LEDMINUSTASK_0001 /* again */
	.word XT_EXIT
END LEDMINUSTASK
