\ ******************************************************************************
\
\       Name: DrawRowOfTiles
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Draw a row of tiles into the nametable buffer
\
\ ------------------------------------------------------------------------------
\
\ This routine effectively draws K tiles at SC(1 0) and SC2(1 0), but omitting
\ the first tile.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The pattern number to use for the row of tiles
\
\   K                   The number of tiles to draw, minus 1 (so we draw K - 1
\                       tiles)
\
\   SC(1 0)             The address in nametable buffer 0 for the start of the
\                       row, less 1 (we draw from SC(1 0) + 1 onwards)
\
\   SC2(1 0)            The address in nametable buffer 1 for the start of the
\                       row, less 1 (we draw from SC2(1 0) + 1 onwards)
\
\ ******************************************************************************

.DrawRowOfTiles

 LDY #1                 \ We start drawing from SC(1 0) + 1, so set an index
                        \ counter in Y

.drow1

 STA (SC),Y             \ Draw the pattern in A into the Y-th nametable entry
 STA (SC2),Y            \ in both the nametable buffers

 INY                    \ Increment the index counter

 CPY K                  \ Loop back until we have drawn K - 1 tiles
 BNE drow1

 RTS                    \ Return from the subroutine

