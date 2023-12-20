\ ******************************************************************************
\
\       Name: HLOIN (Part 1 of 5)
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a horizontal line from (X1, Y) to (X2, Y) using EOR logic
\  Deep dive: Drawing lines in the NES version
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X1                  The screen x-coordinate of the start of the line
\
\   X2                  The screen x-coordinate of the end of the line
\
\   Y                   The screen y-coordinate of the line
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\   X2                  X2 is decremented
\
\ ******************************************************************************

.hlin1

 JMP hlin23             \ Jump to hlin23 to draw the line when it's all within
                        \ one character block

 LDY YSAV               \ Restore Y from YSAV, so that it's preserved

.hlin2

 RTS                    \ Return from the subroutine

.HLOIN

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 STY YSAV               \ Store Y into YSAV, so we can preserve it across the
                        \ call to this subroutine

 LDX X1                 \ Set X = X1

 CPX X2                 \ If X1 = X2 then the start and end points are the same,
 BEQ hlin2              \ so return from the subroutine (as hlin2 contains
                        \ an RTS)

 BCC hlin3              \ If X1 < X2, jump to hlin3 to skip the following code,
                        \ as (X1, Y) is already the left point

 LDA X2                 \ Swap the values of X1 and X2, so we know that (X1, Y)
 STA X1                 \ is on the left and (X2, Y) is on the right
 STX X2

 TAX                    \ Set X = X1 once again

.hlin3

 DEC X2                 \ Decrement X2 so we do not draw a pixel at the end
                        \ point

 TXA                    \ Set SC2(1 0) = (nameBufferHi 0) + yLookup(Y) + X1 / 8
 LSR A                  \
 LSR A                  \ where yLookup(Y) uses the (yLookupHi yLookupLo) table
 LSR A                  \ to convert the pixel y-coordinate in Y into the number
 CLC                    \ of the first tile on the row containing the pixel
 ADC yLookupLo,Y        \
 STA SC2                \ Adding nameBufferHi and X1 / 8 therefore sets SC2(1 0)
 LDA nameBufferHi       \ to the address of the entry in the nametable buffer
 ADC yLookupHi,Y        \ that contains the tile number for the tile containing
 STA SC2+1              \ the pixel at (X1, Y), i.e. the line we are drawing

 TYA                    \ Set Y = Y mod 8, which is the pixel row within the
 AND #7                 \ character block at which we want to draw the start of
 TAY                    \ our line (as each character block has 8 rows)
                        \
                        \ As we are drawing a horizontal line, we do not need to
                        \ vary the value of Y, as we will always want to draw on
                        \ the same pixel row within each character block

 TXA                    \ Set T = X1 with bits 0-2 cleared
 AND #%11111000         \
 STA T                  \ Each character block contains 8 pixel rows, so to get
                        \ the address of the first byte in the character block
                        \ that we need to draw into, as an offset from the start
                        \ of the row, we clear bits 0-2
                        \
                        \ T is therefore the offset within the row of the start
                        \ of the line at x-coordinate X1

 LDA X2                 \ Set A = X2 with bits 0-2 cleared
 AND #%11111000         \
 SEC                    \ A is therefore the offset within the row of the end
                        \ of the line at x-coordinate X2

 SBC T                  \ Set A = A - T
                        \
                        \ So A contains the width of the line in terms of pixel
                        \ bytes (which is the same as the number of character
                        \ blocks that the line spans, less 1 and multiplied by
                        \ 8)

 BEQ hlin1              \ If the line starts and ends in the same character
                        \ block then A will be zero, so jump to hlin23 via hlin1
                        \ to draw the line when it's all within one character
                        \ block

 LSR A                  \ Otherwise set R = A / 8
 LSR A                  \
 LSR A                  \ So R contains the number of character blocks that the
 STA R                  \ line spans, less 1 (so R = 0 means it spans one block,
                        \ R = 1 means it spans two blocks, and so on)

