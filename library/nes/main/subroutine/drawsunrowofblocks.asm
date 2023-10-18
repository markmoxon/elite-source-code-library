\ ******************************************************************************
\
\       Name: DrawSunRowOfBlocks
\       Type: Subroutine
\   Category: Drawing suns
\    Summary: Draw a row of character blocks that contain sunlight, silhouetting
\             any existing content against the sun
\
\ ------------------------------------------------------------------------------
\
\ This routine fills a row of whole character blocks with sunlight, turning any
\ existing content into a black silhouette on the cyan sun. It effectively fills
\ the character blocks containing the horizontal pixel line (P, Y) to (P+1, Y).
\
\ Arguments:
\
\   P                   A pixel x-coordinate in the character block from which
\                       we start the fill
\
\   P+1                 A pixel x-coordinate in the character block where we
\                       finish the fill
\
\   Y                   A pixel y-coordinate on the character row to fill
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.DrawSunRowOfBlocks

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 STY YSAV               \ Store Y in YSAV so we can retrieve it below

 LDA P                  \ Set SC2(1 0) = (nameBufferHi 0) + yLookup(Y) + P * 8
 LSR A                  \
 LSR A                  \ where yLookup(Y) uses the (yLookupHi yLookupLo) table
 LSR A                  \ to convert the pixel y-coordinate in Y into the number
 CLC                    \ of the first tile on the row containing the pixel
 ADC yLookupLo,Y        \
 STA SC2                \ Adding nameBufferHi and P * 8 therefore sets SC2(1 0)
 LDA nameBufferHi       \ to the address of the entry in the nametable buffer
 ADC yLookupHi,Y        \ that contains the tile number for the tile containing
 STA SC2+1              \ the pixel at (P, Y)

 LDA P+1                \ Set Y = (P+1 - P) * 8 - 1
 SEC                    \
 SBC P                  \ So Y is the number of tiles we need to fill in the row
 LSR A
 LSR A
 LSR A
 TAY
 DEY

.fill1

 LDA (SC2),Y            \ If the nametable entry for the Y-th tile is non-zero,
 BNE fill2              \ then there is already something there, so jump to
                        \ fill2 to fill this tile using EOR logic (so the pixels
                        \ that are already there are still visible against the
                        \ sun, as black pixels on the sun's cyan background)

 LDA #51                \ Otherwise the nametable entry is zero, which is just
 STA (SC2),Y            \ the background, so set this tile to pattern 51

 DEY                    \ Decrement the tile counter in Y

 BPL fill1              \ Loop back until we have filled the entire row of tiles

 LDY YSAV               \ Retrieve the value of Y we stored above

 RTS                    \ Return from the subroutine

.fill2

                        \ If we get here then A contains the pattern number of
                        \ the non-empty tile that we want to fill, so we now
                        \ need to fill that pattern in the pattern buffer while
                        \ keeping the existing content

 STY T                  \ Store Y in T so we can retrieve it below

 LDY pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STY SC+1               \             = (pattBufferHiAddr A*8)
 ASL A                  \
 ROL SC+1               \ This is the address of pattern number A in the current
 ASL A                  \ pattern buffer, as each pattern in the buffer consists
 ROL SC+1               \ of eight bytes
 ASL A                  \
 ROL SC+1               \ So this is the address of the pattern for the tile
 STA SC                 \ that we want to fill, so now to fill it

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #7                 \ We now loop through each pixel row within this tile's
                        \ pattern, filling the whole pattern with cyan, but
                        \ EOR'ing with the pattern that is already there so it
                        \ is still visible against the sun, as black pixels on
                        \ the sun's cyan background

.fill3

 LDA #%11111111         \ Invert the Y-th pixel row by EOR'ing with %11111111
 EOR (SC),Y
 STA (SC),Y

 DEY                    \ Decrement Y to point to the pixel line above

 BPL fill3              \ Loop back until we have filled all 8 pixel lines in
                        \ the pattern

 LDY T                  \ Retrieve the value of Y we stored above, so it now
                        \ contains the tile counter from the loop at fill1

 DEY                    \ Decrement the tile counter in Y, as we just filled a
                        \ tile

 BPL fill1              \ If there are still more tiles to fill on this row,
                        \ loop back to fill1 to continue filling them

 LDY YSAV               \ Retrieve the value of Y we stored above

 RTS                    \ Return from the subroutine

