
# -----------------------------------------------------------------------------
  CODEWORD  "move", MOVE /* ( addr1 addr2 n -- ) copy n bytes from addr1 to addr2 */
/* This can cope with overlapping memory areas */
# -----------------------------------------------------------------------------

move:
    # Get parameters from data stack
    # s3 = byte count (TOS)
    # 0(s4) = destination address
    # 4(s4) = source address

    # Load source and destination from data stack
    lw      t0, 4(s4)           # t0 = source address
    lw      t1, 0(s4)           # t1 = destination address
    addi    s4, s4, 8           # Pop 2 items from data stack

    # Check if count is zero
    beq     s3, zero, 9f        # 9: move_done
    
    # Check if source == destination
    beq     t0, t1, 9f          # 9: move_done
    
    # Determine copy direction: if source < destination, copy backward
    bltu    t0, t1, 2f          # 2: move_backward
    
1:  # move_forward: source >= destination
    add     t2, t0, zero        # t2 = source pointer
    add     t3, t1, zero        # t3 = destination pointer
    add     t4, s3, zero        # t4 = counter
    
3:  # forward_loop
    lbu     t5, 0(t2)           # Load byte from source
    sb      t5, 0(t3)           # Store byte to destination
    
    addi    t2, t2, 1           # Increment source
    addi    t3, t3, 1           # Increment destination
    addi    t4, t4, -1          # Decrement counter
    
    bnez    t4, 3b              # 3: forward_loop - continue if counter != 0
    j       9f                  # 9: move_done
    
2:  # move_backward: source < destination with potential overlap
    add     t2, t0, s3          # t2 = source + count (one past end)
    add     t3, t1, s3          # t3 = destination + count (one past end)
    add     t4, s3, zero        # t4 = counter
    
4:  # backward_loop
    addi    t2, t2, -1          # Decrement to current source position
    addi    t3, t3, -1          # Decrement to current dest position
    
    lbu     t5, 0(t2)           # Load byte from source
    sb      t5, 0(t3)           # Store byte to destination
    
    addi    t4, t4, -1          # Decrement counter
    
    bnez    t4, 4b              # 4: backward_loop - continue if counter != 0
    
9:  # move_done
    # Pop count from TOS by loading next item
    lw      s3, 0(s4)
    addi    s4, s4, 4
    
    NEXT
END MOVE
