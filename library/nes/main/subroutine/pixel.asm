\ ******************************************************************************
\
\       Name: PIXEL
\       Type: Subroutine
\   Category: Drawing pixels
\    Summary: Draw a 1-pixel dot
\  Deep dive: Drawing pixels in the NES version
\
\ ------------------------------------------------------------------------------
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ Arguments:
\
\   X                   The screen x-coordinate of the point to draw
\
\   A                   The screen y-coordinate of the point to draw
\
\ Returns:
\
\   Y                   Y is preserved
\
\ Other entry points:
\
\   pixl2               Restore the value of Y and return from the subroutine
\
\ ******************************************************************************

.PIXEL

 STX SC2                \ Set SC2 to the pixel's x-coordinate in X

 STY T1                 \ Store Y in T1 so we can retrieve it at the end of the
                        \ subroutine

 TAY                    \ Set Y to the pixel's y-coordinate

 TXA                    \ Set SC(1 0) = (nameBufferHi 0) + yLookup(Y) + X / 8
 LSR A                  \
 LSR A                  \ where yLookup(Y) uses the (yLookupHi yLookupLo) table
 LSR A                  \ to convert the pixel y-coordinate in Y into the number
 CLC                    \ of the first tile on the row containing the pixel
 ADC yLookupLo,Y        \
 STA SC                 \ Adding nameBufferHi and X / 8 therefore sets SC(1 0)
 LDA nameBufferHi       \ to the address of the entry in the nametable buffer
 ADC yLookupHi,Y        \ that contains the tile number for the tile containing
 STA SC+1               \ the pixel at (X, Y), i.e. the line we are drawing

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDX #0                 \ If the nametable buffer entry is non-zero for the tile
 LDA (SC,X)             \ containing the pixel that we want to draw, then a
 BNE pixl1              \ pattern has already been allocated to this entry, so
                        \ skip the following

 LDA firstFreePattern   \ If firstFreePattern is zero then we have run out of
 BEQ pixl2              \ patterns to use for drawing lines and pixels, so jump
                        \ to pixl2 to return from the subroutine, as we can't
                        \ draw the pixel

 STA (SC,X)             \ Otherwise firstFreePattern contains the number of the
                        \ next available pattern for drawing, so allocate this
                        \ pattern to cover the pixel that we want to draw by
                        \ setting the nametable entry to the pattern number we
                        \ just fetched

 INC firstFreePattern   \ Increment firstFreePattern to point to the next
                        \ available pattern for drawing, so it can be added to
                        \ the nametable the next time we need to draw lines or
                        \ pixels into a pattern

.pixl1

 LDX pattBufferHiDiv8   \ Set SC(1 0) = (pattBufferHiDiv8 A) * 8
 STX SC+1               \             = (pattBufferHi 0) + A * 8
 ASL A                  \
 ROL SC+1               \ So SC(1 0) is the address in the pattern buffer for
 ASL A                  \ pattern number A (as each pattern contains 8 bytes of
 ROL SC+1               \ pattern data), which means SC(1 0) points to the
 ASL A                  \ pattern data for the tile containing the line we are
 ROL SC+1               \ drawing
 STA SC

 TYA                    \ Set Y = Y mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw the start of
 TAY                    \ our line (as each character block has 8 rows)

 LDA SC2                \ Set X = X mod 8, which is the horizontal pixel number
 AND #7                 \ within the character block where the line starts (as
 TAX                    \ each pixel line in the character block is 8 pixels
                        \ wide, and we set SC2 to the x-coordinate above)

 LDA TWOS,X             \ Fetch a 1-pixel byte from TWOS where pixel X is set

 ORA (SC),Y             \ Store the pixel byte into screen memory at SC(1 0),
 STA (SC),Y             \ using OR logic so it merges with whatever is already
                        \ on-screen

.pixl2

 LDY T1                 \ Restore the value of Y from T1 so it is preserved

 RTS                    \ Return from the subroutine

