.nameTileCounter

 SKIP 1                 \ Counts tiles as they are written to the PPU nametable
                        \ in the NMI handler
                        \
                        \ Contains the tile number divided by 8, so it counts up
                        \ 4 for every 32 tiles sent
                        \
                        \ We divide by 8 because there are 1024 entries in each
                        \ nametable, which doesn't fit into one byte, so we
                        \ divide by 8 so the maximum counter value is 128
                        \
                        \ This variable is used internally by the
                        \ SendNametableToPPU routine

