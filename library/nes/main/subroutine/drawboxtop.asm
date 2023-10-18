\ ******************************************************************************
\
\       Name: DrawBoxTop
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Draw the top edge of the box along the top of the screen in
\             nametable buffer 0
\
\ ******************************************************************************

.DrawBoxTop

 LDY #1                 \ Set Y as an index into the nametable, as we want to
                        \ draw the top bar from column 1 to 31

 LDA #3                 \ Set A = 3 as the tile number to use for the top of the
                        \ box (it's a three-pixel high horizontal bar)

.boxt1

 STA nameBuffer0,Y      \ Set the Y-th entry in nametable 0 to tile 3

 INY                    \ Increment the column counter

 CPY #32                \ Loop back until we have drawn in columns 1 through 31
 BNE boxt1

 RTS                    \ Return from the subroutine

