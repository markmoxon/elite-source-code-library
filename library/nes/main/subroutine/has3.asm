\ ******************************************************************************
\
\       Name: HAS3
\       Type: Subroutine
\   Category: Ship hangar
\    Summary: Draw a hangar background line from right to left
\
\ ------------------------------------------------------------------------------
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ ******************************************************************************

.HAS3

 STX R                  \ Set R to the line length in X

 STY YSAV               \ Store Y in YSAV so we can retrieve it below

 LSR A                  \ Set SC2(1 0) = (nameBufferHi 0) + yLookup(Y) + A / 8
 LSR A                  \
 LSR A                  \ where yLookup(Y) uses the (yLookupHi yLookupLo) table
 CLC                    \ to convert the pixel y-coordinate in Y into the number
 ADC yLookupLo,Y        \ of the first tile on the row containing the pixel
 STA SC2                \
 LDA nameBufferHi       \ Adding nameBufferHi and A / 8 therefore sets SC2(1 0)
 ADC yLookupHi,Y        \ to the address of the entry in the nametable buffer
 STA SC2+1              \ that contains the tile number for the tile containing
                        \ the pixel at (A, Y), i.e. the start of the line we are
                        \ drawing

 TYA                    \ Set Y = Y mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw the start of
 TAY                    \ our line (as each character block has 8 rows)
                        \
                        \ As we are drawing a horizontal line, we do not need to
                        \ vary the value of Y, as we will always want to draw on
                        \ the same pixel row within each character block

.hanr1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is zero for the tile
 LDA (SC2,X)            \ containing the pixels that we want to draw, then a
 BEQ hanr8              \ pattern has not yet been allocated to this entry, so
                        \ jump to hanr8 to allocate a new pattern

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ pattern number A (as each pattern contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

 LDA (SC),Y             \ If the pattern data where we want to draw the line is
 BEQ hanr5              \ zero, then there is nothing currently on-screen at
                        \ this point, so jump to hanr5 to draw a full 8-pixel
                        \ line into the pattern data for this tile

                        \ There is something on-screen where we want to draw our
                        \ line, so we now draw the line until it bumps into
                        \ what's already on-screen, so the floor line goes right
                        \ up to the edge of the ship in the hangar

 LDA #%00000001         \ Set A to a pixel byte containing one set pixel at the
                        \ right end of the 8-pixel row, which we can extend to
                        \ the left by one pixel each time until it meets the
                        \ edge of the on-screen ship

.hanr2

 STA T                  \ Store the current pixel pattern in T

 AND (SC),Y             \ We now work out whether the pixel pattern in A would
                        \ overlap with the edge of the on-screen ship, which we
                        \ do by AND'ing the pixel pattern with the on-screen
                        \ pixel pattern in SC+Y, so if there are any pixels in
                        \ both the pixel pattern and on-screen, they will be set
                        \ in the result

 BNE hanr3              \ If the result is non-zero then our pixel pattern in A
                        \ does indeed overlap with the on-screen ship, so this
                        \ is the pattern we want, so jump to hanr3 to draw it

                        \ If we get here then our pixel pattern in A does not
                        \ overlap with the on-screen ship, so we need to extend
                        \ our pattern to the left by one pixel and try again

 LDA T                  \ Shift the whole pixel pattern to the left by one
 SEC                    \ pixel, shifting a set pixel into the right end (bit 0)
 ROL A

 JMP hanr2              \ Jump back to hanr2 to check whether our extended pixel
                        \ pattern has reached the edge of the ship yet

.hanr3

 LDA T                  \ Draw our pixel pattern into the pattern buffer, using
 ORA (SC),Y             \ OR logic so it overwrites what's already there and
 STA (SC),Y             \ merges into the existing ship edge

.hanr4

 LDY YSAV               \ Retrieve the value of Y we stored above, so Y is
                        \ preserved

 RTS                    \ Return from the subroutine

.hanr5

                        \ If we get here then we can draw a full 8-pixel wide
                        \ horizontal line into the pattern data for the current
                        \ tile, as there is nothing there already

 LDA #%11111111         \ Set A to a pixel byte containing eight pixels in a row

 STA (SC),Y             \ Store the 8-pixel line in the Y-th entry in the
                        \ pattern buffer

.hanr6

 DEC R                  \ Decrement the line length in R

 BEQ hanr4              \ If we have drawn all R blocks, jump to hanr4 to return
                        \ from the subroutine

 LDA SC2                \ We now decrement SC2(1 0) to point to the next
 BNE hanr7              \ nametable entry to the left, so check whether the low
                        \ byte of SC2(1 0) is non-zero, and if so jump to hanr7
                        \ to decrement it

 DEC SC2+1              \ Otherwise we also need to decrement the high byte
                        \ before decrementing the low byte round to &FF

.hanr7

 DEC SC2                \ Decrement the low byte of SC2(1 0)

 JMP hanr1              \ Jump back to hanr1 to draw the next block of the
                        \ horizontal line

.hanr8

                        \ If we get here then there is no pattern allocated to
                        \ the part of the line we want to draw, so we can use
                        \ one of the pre-rendered patterns that contains an
                        \ 8-pixel horizontal line on the correct pixel row
                        \
                        \ We jump here with X = 0

 TYA                    \ Set A = Y + 37
 CLC                    \
 ADC #37                \ Patterns 37 to 44 contain pre-rendered patterns as
                        \ follows:
                        \
                        \   * Pattern 37 has a horizontal line on pixel row 0
                        \   * Pattern 38 has a horizontal line on pixel row 1
                        \     ...
                        \   * Pattern 43 has a horizontal line on pixel row 6
                        \   * Pattern 44 has a horizontal line on pixel row 7
                        \
                        \ So A contains the pre-rendered pattern number that
                        \ contains an 8-pixel line on pixel row Y, and as Y
                        \ contains the offset of the pixel row for the line we
                        \ are drawing, this means A contains the correct pattern
                        \ number for this part of the line

 STA (SC2,X)            \ Display the pre-rendered pattern on-screen by setting
                        \ the nametable entry to A

 JMP hanr6              \ Jump up to hanr6 to move on to the next character
                        \ block to the left

