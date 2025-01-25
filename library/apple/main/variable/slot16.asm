.slot16

 SKIP 1                 \ The slot number containing the disk controller card,
                        \ multiplied by 16 to move the slot number into the top
                        \ nibble (so the value is &x0 for slot x)
                        \
                        \ This can then be used as an offset to add to the soft
                        \ switch addresses for the disk controller, to ensure we
                        \ access the addresses for the correct slot

