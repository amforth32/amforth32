# AmForth specific gdb commands for ARM
# load with `source amforth.gdb`

# source shared core commands
source amforth-core.gdb

# command to dump the data stack
define .s
  # print TOS
  printf "TOS: %x\n", $r7
  # grab the DSP
  set var $frame = $r8
  # rest of the data stack
  while $frame < &RAM_upper_datastack
    # print *(int)$frame
    x/x $frame
    set $frame = $frame + 4
  end
end

# command to dump the return stack
define .r
  set var $frame = $sp
  while $frame < &RAM_upper_returnstack
    # location of the next XT to run after EXIT
    x/a $frame
    # next XT to run after EXIT
    # x/a *(int)$frame
    set $frame = $frame + 4
  end
end

# to help stepping through colon words, put a breakpoint at DO_EXECUTE
# and add commands to step twice to get into the next word's code.
# You can then move to the next word with 'continue'.
# Use 'disable/enable' to (de)activate the breakpoint.
# Optionally pass word XT symbol to break when that word is being executed.
define bde
  if $argc == 1
    hbreak DO_EXECUTE if $r9 == $arg0
  else
    hbreak DO_EXECUTE
  end
  commands
    step 2
  end
end