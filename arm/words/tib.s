
VARIABLE "#tib", NUMBERTIB /* ( -- addr ) [addr] is number of characters stored in TIB */
END NUMBERTIB

CODEWORD "tib", TIB /* ( -- addr ) terminal input buffer address */
  savetos
  add TOS, UP, #USER_TIB
  NEXT
END TIB
