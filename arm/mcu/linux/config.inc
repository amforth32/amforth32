
.include "core/config.inc"

.equ datastack_size, 256 * cellsize
.equ returnstack_size, 256 * cellsize
.equ leavestack_size, 32 * cellsize

// RAM 1M (seel linux.ld)
.equ rampool_size, 200*1024 // 200K
