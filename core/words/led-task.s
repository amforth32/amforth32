/*
Found 1 name(s) that resolve to multiple XT symbols:
  name='1ms':
    xtname='XT_1MS'  file='./arm/mcu/ra4m1/words/ms.s'
    xtname='XT_N1MS'  file='./arm/mcu/qemu/words/ms.s'
*/
#======================================================================
#======================================================================
# transpiling led.f on 2026/04/29 11:25:48
# : led-task
#     begin 7 emit #2000 ms again
# ;
# 

# ----------------------------------------------------------------------
COLON "led-task", LEDMINUSTASK 
LEDMINUSTASK_0001: /* begin */
	.word XT_DOLITERAL
	.word 7
	.word XT_EMIT
	.word XT_DOLITERAL
	.word 2000
	.word XT_MS
	.word XT_DOBRANCH,LEDMINUSTASK_0001 /* again */
	.word XT_EXIT
END LEDMINUSTASK
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
