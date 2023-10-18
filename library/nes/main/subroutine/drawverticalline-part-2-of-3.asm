\ ******************************************************************************
\
\       Name: DrawVerticalLine (Part 2 of 3)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw the top end or bottom end of the line
\
\ ******************************************************************************

.vlin2

                        \ If we get here then we need to move down by one
                        \ character block without drawing anything, and then
                        \ move on to drawing the middle portion of the line

 STY T                  \ Set A = R + Y
 LDA R                  \       = pixels to left draw + current pixel row
 ADC T                  \
                        \ So A contains the total number of pixels left to draw
                        \ in our line

 SBC #7                 \ At this point the C flag is clear, as the above
                        \ addition won't overflow, so this sets A = R + Y - 8
                        \ and sets the flags accordingly

 BCC vlin3              \ If the above subtraction didn't underflow then
                        \ R + Y < 8, so there is less than one block height to
                        \ draw, so there would be nothing more to draw after
                        \ moving down one line, so jump to vlin3 to return
                        \ from the subroutine

 JMP vlin12             \ Jump to vlin12 to move on drawing the middle
                        \ portion of the line

.vlin3

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 RTS                    \ Return from the subroutine

.vlin4

                        \ We now draw either the top end or the bottom end of
                        \ the line into the nametable entry in SC2(1 0)

 STY Q                  \ Set Q to the pixel row of the top of the line that we
                        \ want to draw (which will be Y1 mod 8 for the top end
                        \ of the line, or 0 for the bottom end of the line)
                        \
                        \ For the top end of the line, we draw down from row
                        \ Y1 mod 8 to the bottom of the character block, which
                        \ will correctly draw the top end of the line
                        \
                        \ For the bottom end of the line, we draw down from row
                        \ 0 until R runs down, which will correctly draw the
                        \ bottom end of the line

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is non-zero for the tile
 LDA (SC2,X)            \ containing the pixels that we want to draw, then a
 BNE vlin6              \ tile has already been allocated to this entry, so skip
                        \ the following

 LDA firstFreeTile      \ If firstFreeTile is zero then we have run out of tiles
 BEQ vlin5              \ to use for drawing lines and pixels, so jump to vlin2
                        \ via vlin5 to move on to the next character block down,
                        \ as we don't have enough dynamic tiles to draw the top
                        \ block of the line

 STA (SC2,X)            \ Otherwise firstFreeTile contains the number of the
                        \ next available tile for drawing, so allocate this
                        \ tile to cover the pixels that we want to draw by
                        \ setting the nametable entry to the tile number we just
                        \ fetched

 INC firstFreeTile      \ Increment firstFreeTile to point to the next available
                        \ dynamic tile for drawing, so it can be used the next
                        \ time we need to draw lines or pixels into a tile

 JMP vlin8              \ Jump to vlin8 to draw the line, starting by drawing
                        \ the top end into the newly allocated tile number in A

.vlin5

 JMP vlin2              \ Jump to vlin2 to move on to the next character block
                        \ down

.vlin6

 CMP #60                \ If A >= 60, then the tile that's already allocated is
 BCS vlin8              \ one of the tiles we have reserved for dynamic drawing,
                        \ so jump to vlin8 to draw the line, starting by drawing
                        \ the top end into the tile number in A

 CMP #37                \ If A < 37, then the tile that's already allocated is
 BCC vlin5              \ one of the icon bar tiles, so jump to vlin2 via vlin5
                        \ to move down by one character block without drawing
                        \ anything, as we can't draw on the icon bar

                        \ If we get here then 37 <= A <= 59, so the tile that's
                        \ already allocated is one of the pre-rendered tiles
                        \ containing horizontal and vertical line patterns
                        \
                        \ We don't want to draw over the top of the pre-rendered
                        \ patterns as that will break them, so instead we make a
                        \ copy of the pre-rendered tile's pattern in a newly
                        \ allocated dynamic tile, and then draw our line into
                        \ the dynamic tile, thus preserving what's already shown
                        \ on-screen while still drawing our new line

 LDX pattBufferHiDiv8   \ Set SC3(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC3+1              \              = (pattBufferHi A) + A * 8
 ASL A                  \
 ROL SC3+1              \ So SC3(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC3+1              \ pattern data), which means SC3(1 0) points to the
 ASL A                  \ pattern data for the tile containing the pre-rendered
 ROL SC3+1              \ pattern that we want to copy
 STA SC3

 LDA firstFreeTile      \ If firstFreeTile is zero then we have run out of
 BEQ vlin5              \ dynamic tiles for drawing lines and pixels, so jump to
                        \ vlin2 via vlin5 to move down by one character block
                        \ without drawing anything, as we don't have enough
                        \ dynamic tiles to draw the top end of the line

 LDX #0                 \ Otherwise firstFreeTile contains the number of the
 STA (SC2,X)            \ next available tile for drawing, so allocate this
                        \ tile to cover the pixels that we want to copy by
                        \ setting the nametable entry to the tile number we just
                        \ fetched

 INC firstFreeTile      \ Increment firstFreeTile to point to the next available
                        \ dynamic tile for drawing, so it can be used the next
                        \ time we need to draw lines or pixels into a tile

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the dynamic tile we just fetched
 ROL SC+1
 STA SC

                        \ We now have a new dynamic tile in SC(1 0) into which
                        \ we can draw the top end of our line, so we now need
                        \ to copy the pattern of the pre-rendered tile that we
                        \ want to draw on top of
                        \
                        \ Each pattern is made up of eight bytes, so we simply
                        \ need to copy eight bytes from SC3(1 0) to SC(1 0)

 STY T                  \ Store Y in T so we can retrieve it after the following
                        \ loop

 LDY #7                 \ We now copy eight bytes from SC3(1 0) to SC(1 0), so
                        \ set a counter in Y

.vlin7

 LDA (SC3),Y            \ Copy the Y-th byte of SC3(1 0) to the Y-th byte of
 STA (SC),Y             \ SC(1 0)

 DEY                    \ Decrement the counter

 BPL vlin7              \ Loop back until we have copied all eight bytes

 LDY T                  \ Restore the value of Y from before the loop, so it
                        \ once again contains the pixel row offset within the
                        \ each character block for the line we are drawing

 JMP vlin9              \ Jump to hlin8 to draw the top end of the line into
                        \ the tile that we just copied

.vlin8

                        \ If we get here then we have either allocated a new
                        \ tile number for the line, or the tile number already
                        \ allocated to this part of the line is >= 60, which is
                        \ a dynamic tile into which we can draw
                        \
                        \ In either case the tile number is in A

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ tile number A (as each tile contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

.vlin9

 LDX S                  \ Set X to the pixel column within the character block
                        \ at which we want to draw our line, which we stored in
                        \ S in part 1

 LDY Q                  \ Set Y to y-coordinate of the start of the line, which
                        \ we stored in Q above

 LDA R                  \ If the height remaining in R is 0 then we have no more
 BEQ vlin11             \ line to draw, so jump to vlin11 to return from the
                        \ subroutine

.vlin10

 LDA (SC),Y             \ Draw a pixel at x-coordinate X into the Y-th byte
 ORA TWOS,X             \ of SC(1 0)
 STA (SC),Y

 DEC R                  \ Decrement the height remaining counter in R, as we
                        \ just drew a pixel

 BEQ vlin11             \ If the height remaining in R is 0 then we have no more
                        \ line to draw, so jump to vlin11 to return from the
                        \ subroutine

 INY                    \ Increment the y-coordinate in Y so we move down the
                        \ line by one pixel

 CPY #8                 \ If Y < 8, loop back to vlin10 draw the next pixel as
 BCC vlin10             \ we haven't yet reached the bottom of the character
                        \ block containing the line's top end

 BCS vlin12             \ If Y >= 8 then we have drawn our vertical line from
                        \ the starting point to the bottom of the character
                        \ block containing the line's top end, so jump to vlin12
                        \ to move down one row to draw the middle portion of the
                        \ line

.vlin11

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 RTS                    \ Return from the subroutine

