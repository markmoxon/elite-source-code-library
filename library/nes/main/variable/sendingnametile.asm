.sendingNameTile

 SKIP 1                 \ The number of the most recent tile that was sent to
                        \ the PPU nametable by the NMI handler for bitplane
                        \ 0 (or the number of the first tile to send if none
                        \ have been sent), divided by 8
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

 SKIP 1                 \ The number of the most recent tile that was sent to
                        \ the PPU nametable by the NMI handler for bitplane
                        \ 1 (or the number of the first tile to send if none
                        \ have been sent), divided by 8
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

