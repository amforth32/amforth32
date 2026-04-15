# SPDX-License-Identifier: GPL-3.0-only
DEFER "key", KEY, XT_SERIAL_KEY_PAUSE /* ( -- c ) receive single character, pause until available */
END KEY

COLON "serial-key-pause" , SERIAL_KEY_PAUSE /* ( -- c ) receive single character, pause until available */
    .word XT_PAUSE,XT_SERIAL_KEYQ, XT_DOCONDBRANCH, PFA_SERIAL_KEY_PAUSE
    .word XT_SERIAL_KEY
    .word XT_EXIT
END SERIAL_KEY_PAUSE

# this I want visible 

#VARIABLE "cnt" , CNT 

#: usb-key? ( -- f ) rxc @ #16 ashift cnt @ - 0= invert ;
#: usb-key  ( -- c ) cnt @ dup rxu + c@ swap 1+ $ff and cnt ! ;  
