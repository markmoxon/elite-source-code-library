.clearingNameTile

 SKIP 1                 \ The number of the first tile to clear in nametable
                        \ buffer 0 when the NMI handler clears tiles, divided
                        \ by 8
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

 SKIP 1                 \ The number of the first tile to clear in nametable
                        \ buffer 1 when the NMI handler clears tiles, divided
                        \ by 8
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

