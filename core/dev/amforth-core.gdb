# AmForth specific gdb commands
# loaded by amforth.gdb

# commands to dump a word header
# $arg0 should be the address of the corresponding header field

define .lfa
  set var $addr = $arg0
  printf "LFA 0x%08x: ", $addr
  output/a *(int)$addr
  printf "\n"
  set $addr = $addr + 4
  .ffa $addr
end

define .ffa
  set var $addr = $arg0
  set var $flags = *(unsigned int *)$addr
  printf "FFA 0x%08x: 0x%08x ", $addr, $flags
  # Decode flags
  if $flags & 0x0001
    printf "RAVar, "
  end
  if $flags & 0x0002
    printf "RA2Var, "
  end
  if $flags & 0x0004
    printf "Colon, "
  end
  if $flags & 0x0008
    printf "Const, "
  end
  if $flags & 0x0010
    printf "Imm, "
  end
  if $flags & 0x0020
    printf "Val, "
  end
  if $flags & 0x0040
    printf "Dfr, "
  end
  if $flags & 0x0080
    printf "Ini, "
  end
  if $flags & 0x0100
    printf "Table, "
  end
  if $flags & 0x0100
    printf "PVal, "
  end
  if $flags & 0x0100
    printf "Child, "
  end
  printf "\n"
  set $addr = $addr + 4
  .nfa $addr
end

define .nfa
  set var $addr = $arg0
  set var $len = *(char *)$addr
  set $addr = $addr + 1
  printf "NFA 0x%08x: \"%s\"\n", $addr, *(char *)$addr@$len
  set $addr = $addr + $len
  # need to 4-byte align the next field address
  set $addr = (((unsigned int)$addr + 3) & ~3)
  .cfa $addr
end

define .cfa
  set var $addr = $arg0
  printf "CFA 0x%08x: ", $addr
  output/a *(int)$addr
  printf "\n"
  set $addr = $addr + 4
  .pfa $addr
end

define .pfa
  set var $addr = $arg0
  set var $cfa = $addr - 4
  printf "PFA 0x%08x: ", $addr
  if *(int *)$cfa == $addr
    # CODEWORD
    list *$addr
  else
    output/a *(int)$addr
    printf "\n"
    set var $count = 5
    while $count > 0
      set $addr = $addr + 4
      printf "    0x%08x: ", $addr
      output/a *(int)$addr
      printf "\n"
      set $count = $count - 1
    end
  end
end

# dump important memory pointers
define .mps
  printf "DP: "
  x/a *(unsigned int *)PFA_DP
  x/a *(unsigned int *)(PFA_DP+4)
  printf "VP: "
  x/a *(unsigned int *)PFA_VP
  x/a *(unsigned int *)(PFA_VP+4)
end

# show flash cache
define .fc
  printf "         dp "
  x/xw &DP_ram
  printf "   dp.flash "
  x/xw &DP_FLASH_ram
  printf "forth-wlist "
  x/xw &FORTH_WORDLIST_ram
  printf "   dp.cache "
  x/dw &DP_CACHE_ram
  printf "flash.cache "
  x/2xw &FLASH_CACHE_ram
end


# set breakpoint in the `break` word
define bb
  hbreak PFA_BREAK
end
