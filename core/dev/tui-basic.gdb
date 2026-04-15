# Basic TUI for Forth debugging that doesn't use the Python API.
# load with `source tui-basic.gdb`

source amforth.gdb

# Simple layouts using just the default GDB windows: src, asm, cmd
# tui new-layout forth regs 15 {-horizontal src 1 asm 1} 20 status 0 cmd 20
tui new-layout forth {-horizontal { {-horizontal src 2 asm 3 } 1 status 0 cmd 1 } 3 regs 1 } 1

# Enable the forth layout and set focus on the command window
layout forth
focus cmd
# disable mouse events so that we can copy/paste from the GDB window (prevents using mouse for scrolling)
set tui mouse-events off