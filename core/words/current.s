# SPDX-License-Identifier: GPL-3.0-only

VALUE "current", CURRENT, XT_RAM_WORDLIST /* current compilation wordlist */
END CURRENT

COLON "get-current", GET_CURRENT /* ( -- wid ) get current compilation word list */
    .word XT_CURRENT,XT_EXIT
END GET_CURRENT

COLON "set-current", SETMINUSCURRENT /* ( wid -- ) set current compilation word list to wid */
	.word XT_DOXLITERAL
	.word XT_CURRENT
	.word XT_DEFER_STORE
	.word XT_EXIT
END SETMINUSCURRENT
