#======================================================================
#======================================================================
# transpiling ../../../lib/empty.f on 2026/03/06 08:51:41
# : empty.ram \# ( -- ) empty the RAM dictionary
#     0 is ram-wordlist
#     memmode if
#         dp0.ram is dp.ram
#     else
#         dp0.ram is dp
#     then
# ;
# 
# : empty.flash \# ( -- ) empty the flash dictionary
#     core-wordlist is forth-wordlist
#     vp0 is vp
#     dp0.flash flash.erase
#     memmode if
#         dp0.flash is dp
#     else
#         dp0.flash is dp.flash
#     then
# ;
# 
# 
# 
# 

# ----------------------------------------------------------------------
COLON "empty.ram", EMPTYDOTRAM /* ( -- ) empty the RAM dictionary */
	.word XT_ZERO
	.word XT_DOXLITERAL
	.word XT_RAM_WORDLIST
	.word XT_DEFER_STORE
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,EMPTYDOTRAM_0001 /* if */
	.word XT_DP0DOTRAM
	.word XT_DOXLITERAL
	.word XT_DP_RAM
	.word XT_DEFER_STORE
	.word XT_DOBRANCH,EMPTYDOTRAM_0002
EMPTYDOTRAM_0001: /* else */
	.word XT_DP0DOTRAM
	.word XT_DOXLITERAL
	.word XT_DP
	.word XT_DEFER_STORE
EMPTYDOTRAM_0002: /* then */
	.word XT_EXIT
END EMPTYDOTRAM
# ----------------------------------------------------------------------
COLON "empty.flash", EMPTYDOTFLASH /* ( -- ) empty the flash dictionary */
	.word XT_CORE_WORDLIST
	.word XT_DOXLITERAL
	.word XT_FORTH_WORDLIST
	.word XT_DEFER_STORE
	.word XT_VP0
	.word XT_DOXLITERAL
	.word XT_VP
	.word XT_DEFER_STORE
	.word XT_DP0_FLASH
	.word XT_FLASH_ERASE
	.word XT_MEMMODE
	.word XT_DOCONDBRANCH,EMPTYDOTFLASH_0001 /* if */
	.word XT_DP0_FLASH
	.word XT_DOXLITERAL
	.word XT_DP
	.word XT_DEFER_STORE
	.word XT_DOBRANCH,EMPTYDOTFLASH_0002
EMPTYDOTFLASH_0001: /* else */
	.word XT_DP0_FLASH
	.word XT_DOXLITERAL
	.word XT_DP_FLASH
	.word XT_DEFER_STORE
EMPTYDOTFLASH_0002: /* then */
	.word XT_EXIT
END EMPTYDOTFLASH
# ----------------------------------------------------------------------
#=====================================================================
#======================================================================
