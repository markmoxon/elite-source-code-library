\ ******************************************************************************
\
\       Name: SendPatternsToPPU (Part 6 of 6)
\       Type: Subroutine
\   Category: PPU
\    Summary: Save progress for use in the next VBlank and return from the
\             subroutine
\
\ ******************************************************************************

.spat30

                        \ We now store the following variables, so they can be
                        \ picked up when we return in the next VBlank:
                        \
                        \   * (pattTileBuffHi pattTileBuffLo)
                        \
                        \   * sendingPattTile

 STX pattTileCounter    \ Store X in pattTileCounter to use below

 LDX nmiBitplane        \ Set (pattTileBuffHi pattTileBuffLo) for this bitplane
 STY pattTileBuffLo,X   \ to dataForPPU(1 0) + Y (which is the address of the
 LDA dataForPPU+1       \ next byte of data to be sent from the pattern buffer
 STA pattTileBuffHi,X   \ in the next VBlank)

 LDA pattTileCounter    \ Set sendingPattTile for this bitplane to the value of
 STA sendingPattTile,X  \ X we stored above (which is the number / 8 of the next
                        \ tile to be sent from the pattern buffer in the next
                        \ VBlank)

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

