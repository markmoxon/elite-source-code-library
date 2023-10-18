\ ******************************************************************************
\
\       Name: HLOIN (Part 5 of 5)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw the line when it's all within one character block
\
\ ******************************************************************************

.hlin23

                        \ If we get here then the line starts and ends in the
                        \ same character block

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is non-zero for the tile
 LDA (SC2,X)            \ containing the pixels that we want to draw, then a
 BNE hlin25             \ tile has already been allocated to this entry, so skip
                        \ the following

 LDA firstFreeTile      \ If firstFreeTile is zero then we have run out of tiles
 BEQ hlin24             \ to use for drawing lines and pixels, so jump to hlin30
                        \ via hlin24 to return from the subroutine, as we don't
                        \ have enough dynamic tiles to draw the line

 STA (SC2,X)            \ Otherwise firstFreeTile contains the number of the
                        \ next available tile for drawing, so allocate this tile
                        \ to cover the pixels that we want to draw by setting
                        \ the nametable entry to the tile number we just fetched

 INC firstFreeTile      \ Increment firstFreeTile to point to the next available
                        \ dynamic tile for drawing, so it can be used the next
                        \ time we need to draw lines or pixels into a tile

 JMP hlin27             \ Jump to hlin27 to draw the line into the newly
                        \ allocated tile number in A

.hlin24

 JMP hlin30             \ Jump to hlin30 to return from the subroutine

.hlin25

                        \ If we get here then A contains the tile number that's
                        \ already allocated to this part of the line in the
                        \ nametable buffer

 CMP #60                \ If A >= 60, then the tile that's already allocated is
 BCS hlin27             \ one of the tiles we have reserved for dynamic drawing,
                        \ so jump to hlin27 to draw the line into the tile
                        \ number in A

 CMP #37                \ If A < 37, then the tile that's already allocated is
 BCC hlin24             \ one of the icon bar tiles, so jump to hlin30 via
                        \ hlin24 to return from the subroutine, as we can't draw
                        \ on the icon bar

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
 BEQ hlin24             \ dynamic tiles for drawing lines and pixels, so jump to
                        \ hlin30 via hlin24 to return from the subroutine, as we
                        \ don't have enough dynamic tiles to draw the line

 LDX #0                 \ Otherwise firstFreeTile contains the number of the
 STA (SC2,X)            \ next available tile for drawing, so allocate this tile
                        \ to contain the pre-rendered tile that we want to copy
                        \ by setting the nametable entry to the tile number we
                        \ just fetched

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
                        \ we can draw our line, so we now need to copy the
                        \ pattern of the pre-rendered tile that we want to draw
                        \ on top of
                        \
                        \ Each pattern is made up of eight bytes, so we simply
                        \ need to copy eight bytes from SC3(1 0) to SC(1 0)

 STY T                  \ Store Y in T so we can retrieve it after the following
                        \ loop

 LDY #7                 \ We now copy eight bytes from SC3(1 0) to SC(1 0), so
                        \ set a counter in Y

.hlin26

 LDA (SC3),Y            \ Copy the Y-th byte of SC3(1 0) to the Y-th byte of
 STA (SC),Y             \ SC(1 0)

 DEY                    \ Decrement the counter

 BPL hlin26             \ Loop back until we have copied all eight bytes

 LDY T                  \ Restore the value of Y from before the loop, so it
                        \ once again contains the pixel row offset within the
                        \ each character block for the line we are drawing

 JMP hlin28             \ Jump to hlin28 to draw the line into the tile that
                        \ we just copied

.hlin27

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

.hlin28

                        \ We now draw our horizontal line into the relevant
                        \ character block

 LDA X1                 \ Set X = X1 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

 LDA TWFR,X             \ Fetch a ready-made byte with X pixels filled in at the
                        \ right end of the byte (so the filled pixels start at
                        \ point X and go all the way to the end of the byte),
                        \ which is the shape we want for the left end of the
                        \ line

 STA T                  \ Store the pixel shape for the right end of the line in
                        \ T

 LDA X2                 \ Set X = X2 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line ends (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

 LDA TWFL,X             \ Fetch a ready-made byte with X pixels filled in at the
                        \ left end of the byte (so the filled pixels start at
                        \ the left edge and go up to point X), which is the
                        \ shape we want for the right end of the line

 AND T                  \ Set A to the overlap of the pixel byte for the left
                        \ end of the line (in T) and the right end of the line
                        \ (in A) by AND'ing them together, which gives us the
                        \ pixels that are in the horizontal line we want to draw

.hlin29

 EOR (SC),Y             \ Store this into the pattern buffer at SC(1 0), using
 STA (SC),Y             \ EOR logic so it merges with whatever is already
                        \ on-screen, so we have now drawn our entire horizontal
                        \ line within this one character block

.hlin30

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

 RTS                    \ Return from the subroutine

