\ ******************************************************************************
\
\       Name: DrawVerticalLine (Part 1 of 3)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a vertical line from (X1, Y1) to (X1, Y2)
\  Deep dive: Drawing lines in the NES version
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X1                  The screen x-coordinate of the line
\
\   Y1                  The screen y-coordinate of the start of the line
\
\   Y2                  The screen y-coordinate of the end of the line
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.DrawVerticalLine

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 STY YSAV               \ Store Y into YSAV, so we can preserve it across the
                        \ call to this subroutine

 LDY Y1                 \ Set Y = Y1

 CPY Y2                 \ If Y1 = Y2 then the start and end points are the same,
 BEQ vlin3              \ so return from the subroutine (as vlin3 contains
                        \ an RTS)

 BCC vlin1              \ If Y1 < Y2, jump to vlin1 to skip the following code,
                        \ as (X1, Y1) is already the top point

 LDA Y2                 \ Swap the values of Y1 and Y2, so we know that (X1, Y1)
 STA Y1                 \ is at the top and (X1, Y2) is at the bottom
 STY Y2

 TAY                    \ Set Y = Y1 once again

.vlin1

 LDA X1                 \ Set SC2(1 0) = (nameBufferHi 0) + yLookup(Y) + X1 / 8
 LSR A                  \
 LSR A                  \ where yLookup(Y) uses the (yLookupHi yLookupLo) table
 LSR A                  \ to convert the pixel y-coordinate in Y into the number
 CLC                    \ of the first tile on the row containing the pixel
 ADC yLookupLo,Y        \
 STA SC2                \ Adding nameBufferHi and X1 / 8 therefore sets SC2(1 0)
 LDA nameBufferHi       \ to the address of the entry in the nametable buffer
 ADC yLookupHi,Y        \ that contains the tile number for the tile containing
 STA SC2+1              \ the pixel at (X1, Y), i.e. the line we are drawing

 LDA X1                 \ Set S = X1 mod 8, which is the pixel column within the
 AND #7                 \ character block at which we want to draw the start of
 STA S                  \ our line (as each character block has 8 columns)
                        \
                        \ As we are drawing a vertical line, we do not need to
                        \ vary the value of S, as we will always want to draw on
                        \ the same pixel column within each character block

 LDA Y2                 \ Set R = Y2 - Y1
 SEC                    \
 SBC Y1                 \ So R is the height of the line we want to draw, which
 STA R                  \ we will use as a counter as we work our way along the
                        \ line from top to bottom - in other words, R will the
                        \ height remaining that we have to draw

 TYA                    \ Set Y = Y1 mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw the start of
 TAY                    \ our line (as each character block has 8 rows)

 BNE vlin4              \ If Y is non-zero then our vertical line is starting
                        \ inside a character block rather than from the very
                        \ top, so jump to vlin4 to draw the top end of the line

 JMP vlin13             \ Otherwise jump to vlin13 to draw the middle part of
                        \ the line from full-height line segments, as we don't
                        \ need to draw a separate block for the top end

