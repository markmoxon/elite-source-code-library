\ ******************************************************************************
\
\       Name: HLOIN (Part 3 of 5)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw the middle part of the line
\
\ ******************************************************************************

                        \ We now draw the middle part of the line (i.e. the part
                        \ between the left and right caps)

.hlin11

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is zero for the tile
 LDA (SC2,X)            \ containing the pixels that we want to draw, then a
 BEQ hlin13             \ tile has not yet been allocated to this entry, so jump
                        \ to hlin13 to allocate a new dynamic tile

                        \ If we get here then A contains the tile number that's
                        \ already allocated to this part of the line in the
                        \ nametable buffer

 CMP #60                \ If A < 60, then the tile that's already allocated is
 BCC hlin15             \ either an icon bar tile, or one of the pre-rendered
                        \ tiles containing horizontal and vertical line
                        \ patterns, so jump to hlin15 to process drawing on top
                        \ off the pre-rendered tile

                        \ If we get here then the tile number already allocated
                        \ to this part of the line is >= 60, which is a dynamic
                        \ tile into which we can draw
                        \
                        \ The tile number is in A

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

 LDA #%11111111         \ Set A to a pixel byte containing eight pixels in a row

 EOR (SC),Y             \ Store this into the pattern buffer at SC(1 0), using
 STA (SC),Y             \ EOR logic so it merges with whatever is already
                        \ on-screen, so we have now drawn one character block
                        \ of the middle portion of the line

.hlin12

 INC SC2                \ Increment SC2(1 0) to point to the next tile number to
 BNE P%+4               \ the right in the nametable buffer
 INC SC2+1

 DEC R                  \ Decrement the number of character blocks in which we
                        \ need to draw, as we have just drawn one block

 BNE hlin11             \ If there are still more character blocks to draw, loop
                        \ back to hlin11 to draw the next one

 JMP hlin17             \ Otherwise we have finished drawing the middle portion
                        \ of the line, so jump to hlin17 to draw the right end
                        \ of the line

.hlin13

                        \ If we get here then there is no dynamic tile allocated
                        \ to the part of the line we want to draw, so we can use
                        \ one of the pre-rendered tiles that contains an 8-pixel
                        \ horizontal line on the correct pixel row
                        \
                        \ We jump here with X = 0

 TYA                    \ Set A = Y + 37
 CLC                    \
 ADC #37                \ Tiles 37 to 44 contain pre-rendered patterns as
                        \ follows:
                        \
                        \   * Tile 37 has a horizontal line on pixel row 0
                        \   * Tile 38 has a horizontal line on pixel row 1
                        \     ...
                        \   * Tile 43 has a horizontal line on pixel row 6
                        \   * Tile 44 has a horizontal line on pixel row 7
                        \
                        \ So A contains the pre-rendered tile number that
                        \ contains an 8-pixel line on pixel row Y, and as Y
                        \ contains the offset of the pixel row for the line we
                        \ are drawing, this means A contains the correct tile
                        \ number for this part of the line

 STA (SC2,X)            \ Display the pre-rendered tile on-screen by setting
                        \ the nametable entry to A

 JMP hlin12             \ Jump up to hlin12 to move on to the next character
                        \ block to the right

.hlin14

                        \ If we get here then A + Y = 50, which means we can
                        \ alter the current pre-rendered tile to draw our line
                        \
                        \ This is how it works. Tiles 44 to 51 contain
                        \ pre-rendered patterns as follows:
                        \
                        \   * Tile 44 has a horizontal line on pixel row 7
                        \   * Tile 45 is filled from pixel row 7 to pixel row 6
                        \   * Tile 46 is filled from pixel row 7 to pixel row 5
                        \     ...
                        \   * Tile 50 is filled from pixel row 7 to pixel row 1
                        \   * Tile 51 is filled from pixel row 7 to pixel row 0
                        \
                        \ Y contains the number of the pixel row for the line we
                        \ are drawing, so if A + Y = 50, this means:
                        \
                        \   * We want to draw pixel row 0 on top of tile 50
                        \   * We want to draw pixel row 1 on top of tile 49
                        \     ...
                        \   * We want to draw pixel row 5 on top of tile 45
                        \   * We want to draw pixel row 6 on top of tile 44
                        \
                        \ In other words, if A + Y = 50, then we want to draw
                        \ the pixel row just above the rows that are already
                        \ filled in the pre-rendered pattern, which means we
                        \ can simply swap the pre-rendered pattern to the next
                        \ one in the list (e.g. going from four filled lines to
                        \ five filled lines, for example)
                        \
                        \ We jump here with a BEQ, so the C flag is set for the
                        \ following addition, so the C flag can be used as the
                        \ plus 1 in the two's complement calculation

 TYA                    \ Set A = 51 + C + ~Y
 EOR #&FF               \       = 51 + (1 + ~Y)
 ADC #51                \       = 51 - Y
                        \
                        \ So A contains the number of the pre-rendered tile that
                        \ has our horizontal line drawn on pixel row Y, and all
                        \ the lines below that filled, which is what we want

 STA (SC2,X)            \ Display the pre-rendered tile on-screen by setting
                        \ the nametable entry to A

 INC SC2                \ Increment SC2(1 0) to point to the next tile number to
 BNE P%+4               \ the right in the nametable buffer
 INC SC2+1

 DEC R                  \ Decrement the number of character blocks in which we
                        \ need to draw, as we have just drawn one block

 BNE hlin11             \ If there are still more character blocks to draw, loop
                        \ back to hlin11 to draw the next one

 JMP hlin17             \ Otherwise we have finished drawing the middle portion
                        \ of the line, so jump to hlin17 to draw the right end
                        \ of the line

.hlin15

                        \ If we get here then A <= 59, so the tile that's
                        \ already allocated is either an icon bar tile, or one
                        \ of the pre-rendered tiles containing horizontal and
                        \ vertical line patterns
                        \
                        \ We jump here with the C flag clear, so the addition
                        \ below will work correctly, and with X = 0, so the
                        \ write to (SC2,X) will also work properly

 STA SC                 \ Set SC to the number of the tile that is already
                        \ allocated to this part of the screen, so we can
                        \ retrieve it later

 TYA                    \ If A + Y = 50, then we are drawing our line just
 ADC SC                 \ above the top line of a pre-rendered tile that is
 CMP #50                \ filled from the bottom row to the row just below Y,
 BEQ hlin14             \ so jump to hlin14 to switch this tile to another
                        \ pre-rendered tile that contains the line we want to
                        \ draw (see hlin14 for a full explanation of this logic)

                        \ If we get here then 37 <= A <= 59, so the tile that's
                        \ already allocated is one of the pre-rendered tiles
                        \ containing horizontal and vertical line patterns, but
                        \ isn't a tile we can simply replace with another
                        \ pre-rendered tile
                        \
                        \ We don't want to draw over the top of the pre-rendered
                        \ patterns as that will break them, so instead we make a
                        \ copy of the pre-rendered tile's pattern in a newly
                        \ allocated dynamic tile, and then draw our line into
                        \ the dynamic tile, thus preserving what's already shown
                        \ on-screen while still drawing our new line

 LDA firstFreeTile      \ If firstFreeTile is zero then we have run out of tiles
 BEQ hlin12             \ to use for drawing lines and pixels, so jump to hlin12
                        \ to move right by one character block without drawing
                        \ anything, as we don't have enough dynamic tiles to
                        \ draw this part of the line

 INC firstFreeTile      \ Increment firstFreeTile to point to the next available
                        \ dynamic tile for drawing, so it can be used the next
                        \ time we need to draw lines or pixels into a tile

 STA (SC2,X)            \ Otherwise firstFreeTile contains the number of the
                        \ next available tile for drawing, so allocate this tile
                        \ to contain the pre-rendered tile that we want to copy
                        \ by setting the nametable entry to the tile number we
                        \ just fetched

 LDX pattBufferHiDiv8   \ Set SC3(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC3+1              \              = (pattBufferHi A) + A * 8
 ASL A                  \
 ROL SC3+1              \ So SC3(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC3+1              \ pattern data), which means SC3(1 0) points to the
 ASL A                  \ pattern data for the dynamic tile we just fetched
 ROL SC3+1
 STA SC3

 LDA SC                 \ Set A to the number of the tile that is already
                        \ allocated to this part of the screen, which we stored
                        \ in SC above

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the pre-rendered
 ROL SC+1               \ pattern that we want to copy
 STA SC

                        \ We now have a new dynamic tile in SC3(1 0) into which
                        \ we can draw the left end of our line, so we now need
                        \ to copy the pattern of the pre-rendered tile that we
                        \ want to draw on top of
                        \
                        \ Each pattern is made up of eight bytes, so we simply
                        \ need to copy eight bytes from SC(1 0) to SC3(1 0)

 STY T                  \ Store Y in T so we can retrieve it after the following
                        \ loop

 LDY #7                 \ We now copy eight bytes from SC(1 0) to SC3(1 0), so
                        \ set a counter in Y

.hlin16

 LDA (SC),Y             \ Copy the Y-th byte of SC(1 0) to the Y-th byte of
 STA (SC3),Y            \ SC3(1 0)

 DEY                    \ Decrement the counter

 BPL hlin16             \ Loop back until we have copied all eight bytes

 LDY T                  \ Restore the value of Y from before the loop, so it
                        \ once again contains the pixel row offset within the
                        \ each character block for the line we are drawing

 LDA #%11111111         \ Set A to a pixel byte containing eight pixels in a row

 EOR (SC3),Y            \ Store this into the pattern buffer at SC3(1 0), using
 STA (SC3),Y            \ EOR logic so it merges with whatever is already
                        \ on-screen, so we have now drawn one character block
                        \ of the middle portion of the line

 JMP hlin12             \ Loop back to hlin12 to continue drawing  the line in
                        \ the next character block to the right

