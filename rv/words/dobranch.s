# SPDX-License-Identifier: GPL-3.0-only
HEADLESS "(branch)", DOBRANCH /* ( -- ) jump to address stored in the next cell */
   lw s2,0(s2)
   NEXT
END DOBRANCH
