\ ******************************************************************************
\
\       Name: HLOIN (Part 4 of 5)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw the right end of the line
\
\ ******************************************************************************

.hlin17

                        \ We now finish off the drawing process with the right
                        \ end of the line

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is non-zero for the tile
 LDA (SC2,X)            \ containing the pixels that we want to draw, then a
 BNE hlin19             \ pattern has already been allocated to this entry, so
                        \ skip the following

 LDA firstFreePattern   \ If firstFreePattern is zero then we have run out of
 BEQ hlin18             \ patterns to use for drawing lines and pixels, so jump
                        \ to hlin30 via hlin18 to return from the subroutine, as
                        \ we don't have enough patterns to draw the right end
                        \ of the line

 STA (SC2,X)            \ Otherwise firstFreePattern contains the number of the
                        \ next available pattern for drawing, so allocate this
                        \ pattern to cover the pixels that we want to draw by
                        \ setting the nametable entry to the pattern number we
                        \ just fetched

 INC firstFreePattern   \ Increment firstFreePattern to point to the next
                        \ available pattern for drawing, so it can be used the
                        \ next time we need to draw lines or pixels into a
                        \ drawing

 JMP hlin21             \ Jump to hlin21 to draw the right end of the line into
                        \ the newly allocated pattern number in A

.hlin18

 JMP hlin30             \ Jump to hlin30 to return from the subroutine

.hlin19

                        \ If we get here then A contains the tile number that's
                        \ already allocated to this part of the line in the
                        \ nametable buffer

 CMP #60                \ If A >= 60, then the pattern that's already allocated
 BCS hlin21             \ is one of the patterns we have reserved for drawing,
                        \ so jump to hlin21 to draw the right end of the line

 CMP #37                \ If A < 37, then the pattern that's already allocated
 BCC hlin18             \ is one of the icon bar tiles, so jump to hlin30 via
                        \ hlin18 to return from the subroutine, as we can't draw
                        \ on the icon bar

                        \ If we get here then 37 <= A <= 59, so the pattern
                        \ that's already allocated is one of the pre-rendered
                        \ patterns containing horizontal and vertical lines
                        \
                        \ We don't want to draw over the top of the pre-rendered
                        \ patterns as that will break them, so instead we make a
                        \ copy of the pre-rendered pattern into a newly
                        \ allocated pattern, and then draw our line into the
                        \ this new pattern, thus preserving what's already shown
                        \ on-screen while still drawing our new line

 LDX pattBufferHiDiv8   \ Set SC3(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC3+1              \              = (pattBufferHi A) + A * 8
 ASL A                  \
 ROL SC3+1              \ So SC3(1 0) is the address in the pattern buffer for
 ASL A                  \ pattern number A (as each pattern contains 8 bytes of
 ROL SC3+1              \ pattern data), which means SC3(1 0) points to the
 ASL A                  \ pattern data for the tile containing the pre-rendered
 ROL SC3+1              \ pattern that we want to copy
 STA SC3

 LDA firstFreePattern   \ If firstFreePattern is zero then we have run out of
 BEQ hlin18             \ patterns for drawing lines and pixels, so jump to
                        \ hlin30 via hlin18 to return from the subroutine, as we
                        \ don't have enough patterns to draw the right end
                        \ of the line

 LDX #0                 \ Otherwise firstFreePattern contains the number of the
 STA (SC2,X)            \ next available pattern for drawing, so allocate this
                        \ tile to contain the pre-rendered pattern that we want
                        \ to copy by setting the nametable entry to the pattern
                        \ number we just fetched

 INC firstFreePattern   \ Increment firstFreePattern to point to the next
                        \ available pattern for drawing, so it can be used the
                        \ next time we need to draw lines or pixels into a
                        \ pattern

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ pattern number A (as each pattern contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the pattern we just fetched
 ROL SC+1
 STA SC

                        \ We now have a new pattern in SC(1 0) into which we can
                        \ draw the right end of our line, so we now need to copy
                        \ the pre-rendered pattern that we want to draw on top
                        \ of
                        \
                        \ Each pattern is made up of eight bytes, so we simply
                        \ need to copy eight bytes from SC3(1 0) to SC(1 0)

 STY T                  \ Store Y in T so we can retrieve it after the following
                        \ loop

 LDY #7                 \ We now copy eight bytes from SC3(1 0) to SC(1 0), so
                        \ set a counter in Y

.hlin20

 LDA (SC3),Y            \ Copy the Y-th byte of SC3(1 0) to the Y-th byte of
 STA (SC),Y             \ SC(1 0)

 DEY                    \ Decrement the counter

 BPL hlin20             \ Loop back until we have copied all eight bytes

 LDY T                  \ Restore the value of Y from before the loop, so it
                        \ once again contains the pixel row offset within the
                        \ each character block for the line we are drawing

 JMP hlin22             \ Jump to hlin22 to draw the right end of the line into
                        \ the tile that we just copied

.hlin21

                        \ If we get here then we have either allocated a new
                        \ pattern number for the line, or the pattern number
                        \ already allocated to this part of the line is >= 60,
                        \ which is a pattern into which we can draw
                        \
                        \ In either case the pattern number is in A

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ pattern number A (as each pattern contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

.hlin22

                        \ We now draw the right end of our horizontal line

 LDA X2                 \ Set X = X2 mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line ends (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide)

 LDA TWFL,X             \ Fetch a ready-made byte with X pixels filled in at the
                        \ left end of the byte (so the filled pixels start at
                        \ the left edge and go up to point X), which is the
                        \ shape we want for the right end of the line

 JMP hlin29             \ Jump to hlin29 to poke the pixel byte into the pattern
                        \ buffer

