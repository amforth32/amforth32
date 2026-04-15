# SPDX-License-Identifier: GPL-3.0-only

COLON "(create)", DOCREATE /* (C: "name" -- ) parse name, write header, set newest */
    .word XT_PARSENAME,XT_WLSCOPE
    .word XT_DOCREATE_IN
.if WANT_TRANSPILER == YES
    .word XT_TPILE_WXT
.endif
    .word XT_EXIT
END DOCREATE

NONAME "(create.in)", DOCREATE_IN
    .word XT_DUP,XT_NEWEST,XT_CELLPLUS,XT_STORE
    .word XT_HEADER,XT_NEWEST,XT_STORE         
    .word XT_EXIT
END DOCREATE_IN
