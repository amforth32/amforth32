# SPDX-License-Identifier: GPL-3.0-only

CODEWORD "up@", UP_FETCH /* ( -- addr ) addr is the user area pointer */
    savetos
    mv s3, s6
    NEXT
END UP_FETCH

CODEWORD "up!", UP_STORE /* ( addr -- ) set the user area pointer to addr */
    mv s6,s3
    loadtos
    NEXT
END UP_STORE

