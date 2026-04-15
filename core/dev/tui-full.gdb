# TUI for debugging
# load with `source tui-full.gdb`

source amforth.gdb

# Custom AmForth layout with Forth stacks and customized register windows.
# This requires Python enabled GDB and the correct version of Python installed on the system.
# ref: https://undo.io/resources/enhance-gdb-with-tui/
# Make sure the sourced files are on GDB search path
source gdb_shared.py
source gdb_backtrace.py
source gdb_tui.py
tui new-layout forth {-horizontal { {-horizontal src 2 asm 3 } 1 status 0 cmd 1 } 3  { fregs 2 fps 1 frs 1 } 1 } 1

# Enable the forth layout and set focus on the command window
layout forth
focus cmd
# disable mouse events so that we can copy/paste from the GDB window (prevents using mouse for scrolling)
set tui mouse-events off