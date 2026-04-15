# SPDX-License-Identifier: GPL-3.0-only
# transpiling b.f on 2024/03/31 13:50:41
# : blink
#     begin
#         2 led.pulse led.delay
#     again
# ;

# ----------------------------------------------------------------------
COLON "blink", BLINK 
BLINK_0001: # begin
	.word XT_TWO
	.word XT_LED_PULSE
	.word XT_LED_DELAY
	.word XT_DOBRANCH,BLINK_0001 /* again */
	.word XT_EXIT
# ----------------------------------------------------------------------
