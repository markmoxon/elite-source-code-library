\ ******************************************************************************
\
\       Name: DrawDashNames
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw the dashboard into the nametable buffers for both bitplanes
\
\ ******************************************************************************

.DrawDashNames

 LDY #7*32              \ We are about to draw the dashboard, which consists of
                        \ 7 rows of 32 tiles, so set a tile counter in Y to use
                        \ as an index into the dashNames table, so we can copy
                        \ the nametable entries from dashNames into the
                        \ nametable buffer

.ddsh1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA dashNames-1,Y      \ Set A to the Y-th nametable entry in dashNames
                        \
                        \ Note that we fetch from dashNames-1 as the screen is
                        \ horizontally scrolled by one tile (see below)

 STA nameBuffer0+22*32,Y    \ Store the nametable entry in both nametable
 STA nameBuffer1+22*32,Y    \ buffers, so that the dashboard starts at row 22

 DEY                    \ Decrement the tile counter in Y

 BNE ddsh1              \ Loop back to write the next nametable entry until we
                        \ have written all 7 rows of 32 tiles

                        \ Because the horizontal scroll in PPU_SCROLL is set to
                        \ 8, the leftmost tile on each row is scrolled around to
                        \ the right side, which means that in terms of tiles,
                        \ column 1 is the left edge of the screen, then columns
                        \ 2 to 31 form the body of the screen, and column 0 is
                        \ the right edge of the screen
                        \
                        \ We therefore have to fix the tiles that appear at the
                        \ end of each row, i.e. column 0 on row 22 (for the end
                        \ of the top row of the dashboard) all the way down to
                        \ column 0 on row 28 (for the end of the bottom row of
                        \ the dashboard)

 LDA nameBuffer0+23*32  \ Wrap around the scrolled tile on row 22
 STA nameBuffer0+22*32

 LDA nameBuffer0+24*32  \ Wrap around the scrolled tile on row 23
 STA nameBuffer0+23*32

 LDA nameBuffer0+25*32  \ Wrap around the scrolled tile on row 24
 STA nameBuffer0+24*32

 LDA nameBuffer0+26*32  \ Wrap around the scrolled tile on row 25
 STA nameBuffer0+25*32

                        \ Interestingly, the scrolled tile on row 26 is omitted,
                        \ though I'm not sure why

 LDA nameBuffer0+28*32  \ Wrap around the scrolled tile on row 27
 STA nameBuffer0+27*32

 LDA nameBuffer0+29*32  \ Wrap around the scrolled tile on row 28
 STA nameBuffer0+28*32

                        \ Finally, we have to clear up the overspill in column 0
                        \ on row 29

 LDA #0                 \ Set the first tile on row 29 to the blank tile
 STA nameBuffer0+29*32

 RTS                    \ Return from the subroutine

