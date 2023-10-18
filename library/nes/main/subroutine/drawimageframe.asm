\ ******************************************************************************
\
\       Name: DrawImageFrame
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Draw a frame around the system image or commander headshot
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   XC                  The tile column for the top-left corner of the frame
\
\   YC                  The tile row for the top-left corner of the frame
\
\   K                   The number of tiles to draw, minus 1 (so we draw K - 1
\                       tiles)
\
\   K+1                 The number of rows to draw
\
\   SC(1 0)             The address in nametable buffer 0 for the start of the
\                       row, less 1 (we draw from SC(1 0) + 1 onwards)
\
\   SC2(1 0)            The address in nametable buffer 1 for the start of the
\                       row, less 1 (we draw from SC2(1 0) + 1 onwards)
\
\ ******************************************************************************

.DrawImageFrame

 JSR GetNameAddress     \ Get the addresses in the nametable buffers for the
                        \ tile at text coordinate (XC, YC), as follows:
                        \
                        \   SC(1 0) = the address in nametable buffer 0
                        \
                        \   SC2(1 0) = the address in nametable buffer 1

 LDY #0                 \ Set the tile at the top-left corner of the picture
 LDA #64                \ frame to pattern 64
 STA (SC),Y
 STA (SC2),Y

 LDA #60                \ Draw the top edge of the frame using pattern 60
 JSR DrawRowOfTiles

 LDA #62                \ Set the tile at the top-right corner of the picture
 STA (SC),Y             \ frame to pattern 62
 STA (SC2),Y

 DEC K+1                \ Decrement the number of rows to draw, as we have just
                        \ drawn one

 JMP fram2              \ Jump to fram2to start drawing the sides of the frame

.fram1

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA #1                 \ Set the tile at the start of the row (at offset 0) to
 LDY #0                 \ pattern 1, to draw the left edge of the frame
 STA (SC),Y
 STA (SC2),Y

 LDA #2                 \ Set the tile at the end of the row (at offset K) to
 LDY K                  \ pattern 2, to draw the right edge of the frame
 STA (SC),Y
 STA (SC2),Y

.fram2

 LDA SC                 \ Set SC(1 0) = SC(1 0) + 32
 CLC                    \
 ADC #32                \ Starting with the low bytes
 STA SC                 \
                        \ So SC(1 0) now points at the next row down (as there
                        \ are 32 tiles on each row)

 STA SC2                \ Set SC2(1 0) = SC2(1 0) + 32
                        \
                        \ Starting with the low bytes
                        \
                        \ So SC2(1 0) now points at the next row down (as there
                        \ are 32 tiles on each row)

 BCC fram3              \ If the above addition overflowed, increment the high
 INC SC+1               \ high bytes of SC(1 0) and SC2(1 0) accordingly
 INC SC2+1

.fram3

 DEC K+1                \ Decrement the number of rows to draw, as we have just
                        \ moved down a row

 BNE fram1              \ Loop back to fram1 to draw the frame edges, until we
                        \ have drawn the correct number of rows (i.e. K+1 - 1)

 LDY #0                 \ Set the tile at the bottom-left corner of the picture
 LDA #65                \ frame to pattern 65
 STA (SC),Y
 STA (SC2),Y

 LDA #61                \ Draw the top edge of the frame using pattern 61
 JSR DrawRowOfTiles

 LDA #63                \ Set the tile at the bottom-right corner of the picture
 STA (SC),Y             \ frame to pattern 63
 STA (SC2),Y

 RTS                    \ Return from the subroutine

