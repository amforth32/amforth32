.if TARGET_VIRT==1

# VIRT
.include "words/uart-pl011.s"

.else

# MPS2
.include "words/uart-cmsdk.s"

.endif

