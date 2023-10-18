\ ******************************************************************************
\
\       Name: DrawBoxEdges
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Draw the left and right edges of the box along the sides of the
\             screen, drawing into the nametable buffer for the drawing bitplane
\
\ ******************************************************************************

.DrawBoxEdges

 LDX drawingBitplane    \ If the drawing bitplane is set to 1, jump to boxe1 to
 BNE boxe1              \ draw the box edges in bitplane 1

                        \ Otherwise we draw the box edges in bitplane 0

 LDA boxEdge1           \ Set A to the tile number for the left edge of the box,
                        \ which will either be tile 1 for the normal view (a
                        \ three-pixel wide vertical bar along the right edge of
                        \ the tile), or tile 0 (blank) for the death screen

 STA nameBuffer0+1      \ Write this tile into column 1 on rows 0 to 19 in
 STA nameBuffer0+1*32+1 \ nametable buffer 0 to draw the left edge of the box
 STA nameBuffer0+2*32+1 \ (column 1 is the left edge because the screen is
 STA nameBuffer0+3*32+1 \ scrolled horizontally by one block)
 STA nameBuffer0+4*32+1
 STA nameBuffer0+5*32+1
 STA nameBuffer0+6*32+1
 STA nameBuffer0+7*32+1
 STA nameBuffer0+8*32+1
 STA nameBuffer0+9*32+1
 STA nameBuffer0+10*32+1
 STA nameBuffer0+11*32+1
 STA nameBuffer0+12*32+1
 STA nameBuffer0+13*32+1
 STA nameBuffer0+14*32+1
 STA nameBuffer0+15*32+1
 STA nameBuffer0+16*32+1
 STA nameBuffer0+17*32+1
 STA nameBuffer0+18*32+1
 STA nameBuffer0+19*32+1

 LDA boxEdge2           \ Set A to the tile number for the right edge of the
                        \ box, which will either be tile 2 for the normal view
                        \ (a three-pixel wide vertical bar along the left edge
                        \ of the tile), or tile 0 (blank) for the death screen

 STA nameBuffer0        \ Write this tile into column 0 on rows 0 to 19 in
 STA nameBuffer0+1*32   \ nametable buffer 0 to draw the right edge of the box
 STA nameBuffer0+2*32   \ (column 0 is the right edge because the screen is
 STA nameBuffer0+3*32   \ scrolled horizontally by one block)
 STA nameBuffer0+4*32
 STA nameBuffer0+5*32
 STA nameBuffer0+6*32
 STA nameBuffer0+7*32
 STA nameBuffer0+8*32
 STA nameBuffer0+9*32
 STA nameBuffer0+10*32
 STA nameBuffer0+11*32
 STA nameBuffer0+12*32
 STA nameBuffer0+13*32
 STA nameBuffer0+14*32
 STA nameBuffer0+15*32
 STA nameBuffer0+16*32
 STA nameBuffer0+17*32
 STA nameBuffer0+18*32
 STA nameBuffer0+19*32

 RTS                    \ Return from the subroutine

.boxe1

 LDA boxEdge1           \ Set A to the tile number for the left edge of the box,
                        \ which will either be tile 1 for the normal view (a
                        \ three-pixel wide vertical bar along the right edge of
                        \ the tile), or tile 0 (blank) for the death screen

 STA nameBuffer1+1      \ Write this tile into column 1 on rows 0 to 19 in
 STA nameBuffer1+1*32+1 \ nametable buffer 1 to draw the left edge of the box
 STA nameBuffer1+2*32+1 \ (column 1 is the left edge because the screen is
 STA nameBuffer1+3*32+1 \ scrolled horizontally by one block)
 STA nameBuffer1+4*32+1
 STA nameBuffer1+5*32+1
 STA nameBuffer1+6*32+1
 STA nameBuffer1+7*32+1
 STA nameBuffer1+8*32+1
 STA nameBuffer1+9*32+1
 STA nameBuffer1+10*32+1
 STA nameBuffer1+11*32+1
 STA nameBuffer1+12*32+1
 STA nameBuffer1+13*32+1
 STA nameBuffer1+14*32+1
 STA nameBuffer1+15*32+1
 STA nameBuffer1+16*32+1
 STA nameBuffer1+17*32+1
 STA nameBuffer1+18*32+1
 STA nameBuffer1+19*32+1

 LDA boxEdge2           \ Set A to the tile number for the right edge of the
                        \ box, which will either be tile 2 for the normal view
                        \ (a three-pixel wide vertical bar along the left edge
                        \ of the tile), or tile 0 (blank) for the death screen

 STA nameBuffer1        \ Write this tile into column 0 on rows 0 to 19 in
 STA nameBuffer1+1*32   \ nametable buffer 1 to draw the right edge of the box
 STA nameBuffer1+2*32   \ (column 0 is the right edge because the screen is
 STA nameBuffer1+3*32   \ scrolled horizontally by one block)
 STA nameBuffer1+4*32
 STA nameBuffer1+5*32
 STA nameBuffer1+6*32
 STA nameBuffer1+7*32
 STA nameBuffer1+8*32
 STA nameBuffer1+9*32
 STA nameBuffer1+10*32
 STA nameBuffer1+11*32
 STA nameBuffer1+12*32
 STA nameBuffer1+13*32
 STA nameBuffer1+14*32
 STA nameBuffer1+15*32
 STA nameBuffer1+16*32
 STA nameBuffer1+17*32
 STA nameBuffer1+18*32
 STA nameBuffer1+19*32

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 RTS                    \ Return from the subroutine

