.nameTileBuffHi

 SKIP 1                 \ (nameTileBuffHi nameTileBuffLo) contains the address
                        \ of the nametable buffer for the tile we are sending to
                        \ the PPU from bitplane 0 (i.e. for tile number
                        \ sendingNameTile in bitplane 0)
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

 SKIP 1                 \ (nameTileBuffHi nameTileBuffLo) contains the address
                        \ of the nametable buffer for the tile we are sending to
                        \ the PPU from bitplane 1 (i.e. for tile number
                        \ sendingNameTile in bitplane 1)
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

