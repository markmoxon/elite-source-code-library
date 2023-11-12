.lastToSend

 SKIP 1                 \ The last tile or pattern number to send to the PPU,
                        \ potentially potentially overwritten by the flags
                        \
                        \ This variable is used internally by the NMI handler,
                        \ and is set according to bit 3 of the bitplane flags

