\ ******************************************************************************
\
\       Name: DrawHangarWallLine
\       Type: Subroutine
\   Category: Ship hangar
\    Summary: Draw a vertical hangar wall line from top to bottom, stopping when
\             it bumps into existing on-screen content
\
\ ******************************************************************************

.DrawHangarWallLine

 STA S                  \ Store A in S so we can retrieve it when returning
                        \ from the subroutine

 STY YSAV               \ Store Y in YSAV so we can retrieve it when returning
                        \ from the subroutine

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

 LDA S                  \ Set T = S mod 8, which is the pixel column within the
 AND #7                 \ character block at which we want to draw the start of
 STA T                  \ our line (as each character block has 8 columns)
                        \
                        \ As we are drawing a vertical line, we do not need to
                        \ vary the value of T, as we will always want to draw on
                        \ the same pixel column within each character block

.hanw1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is zero for the tile
 LDA (SC2,X)            \ containing the pixels that we want to draw, then a
 BEQ hanw3              \ pattern has not yet been allocated to this entry, so
                        \ jump to hanw3 to allocate a new pattern

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ pattern number A (as each pattern contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

 LDY #0                 \ We want to start drawing the line from the top pixel
                        \ line in the next character row, so set Y = 0 to use as
                        \ the pixel row number

 LDX T                  \ Set X to the pixel column within the character block
                        \ at which we want to draw our line, which we stored in
                        \ T above

.hanw2

 LDA (SC),Y             \ We now work out whether the pixel in column X would
 AND TWOS,X             \ overlap with the top edge of the on-screen ship, which
                        \ we do by AND'ing the pixel pattern with the on-screen
                        \ pixel pattern in SC+Y, so if there are any pixels in
                        \ both the pixel pattern and on-screen, they will be set
                        \ in the result

 BNE hanw5              \ If the result is non-zero then our pixel in column X
                        \ does indeed overlap with the on-screen ship, so we
                        \ need to stop drawing our well line, so jump to hanw5
                        \ to return from the subroutine

                        \ If we get here then our pixel in column X does not
                        \ overlap with the on-screen ship, so we can draw it

 LDA (SC),Y             \ Draw a pixel at x-coordinate X into the Y-th byte
 ORA TWOS,X             \ of SC(1 0)
 STA (SC),Y

 INY                    \ Increment the y-coordinate in Y so we move down the
                        \ line by one pixel

 CPY #8                 \ If Y <> 8, loop back to hanw2 draw the next pixel as
 BNE hanw2              \ we haven't yet reached the bottom of the character
                        \ block containing the line's top end

 JMP hanw4              \ Otherwise we have finished drawing the vertical line
                        \ in this character row, so jump to hanw4 to move down
                        \ to the next row

.hanw3

 LDA T                  \ Set A to the pixel column within the character block
                        \ at which we want to draw our line, which we stored in
                        \ T above

 CLC                    \ Patterns 52 to 59 contain pre-rendered patterns as
 ADC #52                \ follows:
                        \
                        \   * Pattern 52 has a vertical line in pixel column 0
                        \   * Pattern 53 has a vertical line in pixel column 1
                        \     ...
                        \   * Pattern 58 has a vertical line in pixel column 6
                        \   * Pattern 59 has a vertical line in pixel column 7
                        \
                        \ So A contains the pre-rendered pattern number that
                        \ contains an 8-pixel line in pixel column T, and as T
                        \ contains the offset of the pixel column for the line
                        \ we are drawing, this means A contains the correct
                        \ pattern number for this part of the line

 STA (SC2,X)            \ Display the pre-rendered pattern on-screen by setting
                        \ the nametable entry to A

.hanw4

                        \ Next, we update SC2(1 0) to the address of the next
                        \ row down in the nametable buffer, which we can do by
                        \ adding 32 as there are 32 tiles in each row

 LDA SC2                \ Set SC2(1 0) = SC2(1 0) + 32
 CLC                    \
 ADC #32                \ Starting with the low bytes
 STA SC2

 BCC hanw1              \ And then the high bytes, jumping to hanw1 when we are
 INC SC2+1              \ done to draw the vertical line on the next row
 JMP hanw1

.hanw5

 LDA S                  \ Retrieve the value of A we stored above, so A is
                        \ preserved

 LDY YSAV               \ Retrieve the value of Y we stored above, so Y is
                        \ preserved

 RTS                    \ Return from the subroutine

