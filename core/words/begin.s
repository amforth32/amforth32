# SPDX-License-Identifier: GPL-3.0-only

IMMED "begin", BEGIN /* ( -- )(C: -- a ) start of while/repeat, until or again loop */
    .word XT_LMARK
    .word XT_EXIT
END BEGIN
