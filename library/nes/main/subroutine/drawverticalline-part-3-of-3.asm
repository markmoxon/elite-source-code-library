\ ******************************************************************************
\
\       Name: DrawVerticalLine (Part 3 of 3)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw the middle portion of the line from full-height blocks
\  Deep dive: Drawing lines in the NES version
\
\ ******************************************************************************

.vlin12

                        \ We now draw the middle part of the line (i.e. the part
                        \ between the top and bottom caps)

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #0                 \ We want to start drawing the line from the top pixel
                        \ line in the next character row, so set Y = 0 to use as
                        \ the pixel row number

                        \ Next, we update SC2(1 0) to the address of the next
                        \ row down in the nametable buffer, which we can do by
                        \ adding 32 as there are 32 tiles in each row

 LDA SC2                \ Set SC2(1 0) = SC2(1 0) + 32
 CLC                    \
 ADC #32                \ Starting with the low bytes
 STA SC2

 BCC vlin13             \ And then the high bytes
 INC SC2+1

.vlin13

                        \ We jump here from part 2 if the line starts at the top
                        \ of a character block

 LDA R                  \ If the height remaining in R is 0 then we have no more
 BEQ vlin11             \ line to draw, so jump to vlin11 to return from the
                        \ subroutine

 SEC                    \ Set A = A - 8
 SBC #8                 \       = R - 8
                        \
                        \ So this subtracts 8 pixels (one block) from the number
                        \ of pixels we still have to draw

 BCS vlin14             \ If the subtraction didn't underflow, then there are at
                        \ least 8 more pixels to draw, so jump to vlin14 to draw
                        \ another block's worth of pixels

 JMP vlin4              \ The subtraction underflowed, so R is less than 8 and
                        \ we need to stop drawing full-height blocks and draw
                        \ the bottom end of the line, so jump to vlin4 with
                        \ Y = 0 to do just this

.vlin14

 STA R                  \ Store the updated number of pixels left to draw, which
                        \ we calculated in the subtraction above

 LDX #0                 \ If the nametable buffer entry is zero for the tile
 LDA (SC2,X)            \ containing the pixels that we want to draw, then a
 BEQ vlin15             \ pattern has not yet been allocated to this entry, so
                        \ jump to vlin15 to place a pre-rendered pattern into
                        \ the nametable entry

 CMP #60                \ If A < 60, then the drawing that's already allocated
 BCC vlin17             \ is either an icon bar drawing, or one of the
                        \ pre-rendered patterns containing horizontal and
                        \ vertical lines, so jump to vlin17 to process drawing
                        \ on top off the pre-rendered pattern

                        \ If we get here then the pattern number already
                        \ allocated to this part of the line is >= 60, which is
                        \ a pattern into which we can draw
                        \
                        \ The pattern number is in A

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ pattern number A (as each pattern contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

 LDX S                  \ Set X to the pixel column within the character block
                        \ at which we want to draw our line, which we stored in
                        \ S in part 1

 LDY #0                 \ We are going to draw a vertical line from pixel row 0
                        \ to row 7, so set an index in Y to count up

                        \ We repeat the following code eight times, so it draws
                        \ eight pixels from the top of the character block to
                        \ the bottom

 LDA (SC),Y             \ Draw a pixel at x-coordinate X into the Y-th byte
 ORA TWOS,X             \ of SC(1 0)
 STA (SC),Y

 INY                    \ Increment the index in Y

 LDA (SC),Y             \ Draw a pixel at x-coordinate X into the Y-th byte
 ORA TWOS,X             \ of SC(1 0)
 STA (SC),Y

 INY                    \ Increment the index in Y

 LDA (SC),Y             \ Draw a pixel at x-coordinate X into the Y-th byte
 ORA TWOS,X             \ of SC(1 0)
 STA (SC),Y

 INY                    \ Increment the index in Y

 LDA (SC),Y             \ Draw a pixel at x-coordinate X into the Y-th byte
 ORA TWOS,X             \ of SC(1 0)
 STA (SC),Y

 INY                    \ Increment the index in Y

 LDA (SC),Y             \ Draw a pixel at x-coordinate X into the Y-th byte
 ORA TWOS,X             \ of SC(1 0)
 STA (SC),Y

 INY                    \ Increment the index in Y

 LDA (SC),Y             \ Draw a pixel at x-coordinate X into the Y-th byte
 ORA TWOS,X             \ of SC(1 0)
 STA (SC),Y

 INY                    \ Increment the index in Y

 LDA (SC),Y             \ Draw a pixel at x-coordinate X into the Y-th byte
 ORA TWOS,X             \ of SC(1 0)
 STA (SC),Y

 INY                    \ Increment the index in Y

 LDA (SC),Y             \ Draw a pixel at x-coordinate X into the Y-th byte
 ORA TWOS,X             \ of SC(1 0)
 STA (SC),Y

 JMP vlin12             \ Loop back to move down a row and draw the next block

.vlin15

 LDA S                  \ Set A to the pixel column within the character block
                        \ at which we want to draw our line, which we stored in
                        \ S in part 1

 CLC                    \ Patterns 52 to 59 contain pre-rendered patterns, each
 ADC #52                \ containing a single-pixel vertical line, with a line
 STA (SC2,X)            \ at column 0 in pattern 52, a line at column 1 in
                        \ pattern 53, and so on up to column 7 in pattern 58,
                        \ so this sets the nametable entry for the character
                        \ block we are drawing to the correct pre-rendered
                        \ pattern for drawing a vertical line in pixel column A

.vlin16

 JMP vlin12             \ Loop back to move down a row and draw the next block

.vlin17

                        \ If we get here then A <= 59, so the pattern that's
                        \ already allocated is either an icon bar pattern, or
                        \ one of the pre-rendered patterns containing horizontal
                        \ and vertical lines
                        \
                        \ We jump here with X = 0, so the write to (SC2,X)
                        \ below will work properly

 STA SC                 \ Set SC to the number of the pattern that is already
                        \ allocated to this part of the screen, so we can
                        \ retrieve it later

 LDA firstFreePattern   \ If firstFreePattern is zero then we have run out of
 BEQ vlin16             \ patterns to use for drawing lines and pixels, so jump
                        \ to vlin16 to move down by one character block without
                        \ drawing anything, as we don't have enough patterns to
                        \ draw this part of the line

 INC firstFreePattern   \ Increment firstFreePattern to point to the next
                        \ available pattern for drawing, so it can be used the
                        \ next time we need to draw lines or pixels into a
                        \ pattern

 STA (SC2,X)            \ Otherwise firstFreePattern contains the number of the
                        \ next available pattern for drawing, so allocate this
                        \ tile to contain the pre-rendered pattern that we want
                        \ to copy by setting the nametable entry to the pattern
                        \ number we just fetched

 LDX pattBufferHiDiv8   \ Set SC3(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC3+1              \              = (pattBufferHi A) + A * 8
 ASL A                  \
 ROL SC3+1              \ So SC3(1 0) is the address in the pattern buffer for
 ASL A                  \ pattern number A (as each pattern contains 8 bytes of
 ROL SC3+1              \ pattern data), which means SC3(1 0) points to the
 ASL A                  \ pattern data for the pattern we just fetched
 ROL SC3+1
 STA SC3

 LDA SC                 \ Set A to the number of the pattern that is already
                        \ allocated to this part of the screen, which we stored
                        \ in SC above

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ pattern number A (as each pattern contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the pre-rendered
 ROL SC+1               \ pattern that we want to copy
 STA SC

                        \ We now have a new pattern in SC3(1 0) into which we
                        \ can draw the middle part of our line, so we now need
                        \ to copy the pattern of the pre-rendered pattern that
                        \ we want to draw on top of
                        \
                        \ Each pattern is made up of eight bytes, so we simply
                        \ need to copy eight bytes from SC(1 0) to SC3(1 0)

 STY T                  \ Store Y in T so we can retrieve it after the following
                        \ loop

 LDY #7                 \ We now copy eight bytes from SC(1 0) to SC3(1 0), so
                        \ set a counter in Y

 LDX S                  \ Set X to the pixel column within the character block
                        \ at which we want to draw our line, which we stored in
                        \ S in part 1

.vlin18

 LDA (SC),Y             \ Draw a pixel at x-coordinate X into the Y-th byte
 ORA TWOS,X             \ of SC(1 0) and store the result in the Y-th byte of
 STA (SC3),Y            \ SC3(1 0), so this copies the pre-rendered pattern,
                        \ superimposes our vertical line on the result and
                        \ stores it in the pattern buffer for the tile we just
                        \ allocated

 DEY                    \ Decrement the counter

 BPL vlin18             \ Loop back until we have copied all eight bytes

 BMI vlin16             \ Jump to vlin12 via vlin16 to move down a row and draw
                        \ the next block

