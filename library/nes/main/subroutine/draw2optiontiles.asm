\ ******************************************************************************
\
\       Name: Draw2OptionTiles
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Draw a top and bottom tile over the top of an icon bar button in
\             the Pause icon bar to change an option icon to a non-default state
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The tile column of the top and bottom tiles that we want
\                       to draw
\
\   SC(1 0)             The address of the nametable entries for the on-screen
\                       icon bar in nametable buffer 0
\
\   SC2(1 0)            The address of the nametable entries for the on-screen
\                       icon bar in nametable buffer 1
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.Draw2OptionTiles

 LDA barNames3+14,Y     \ Set A to the nametable entry for the top tile of this
                        \ option's icon when it is not in the default state,
                        \ which can be found in entry Y + 14 of the barNames3
                        \ table

 STA (SC),Y             \ Set the top tile of the block we want to draw to the
 STA (SC2),Y            \ pattern in A, in both nametable buffers

 STY T                  \ Store Y in T so we can retrieve it below

 TYA                    \ Set Y = Y + 32
 CLC                    \
 ADC #32                \ So Y now points to the next tile down in the row below
 TAY                    \ (as there are 32 tiles in a row)

 LDA barNames3+14,Y     \ Set A to the nametable entry for the bottom tile of
                        \ this option's icon when it is not in the default
                        \ state, which can be found in entry Y + 14 of the
                        \ barNames3 table

 STA (SC),Y             \ Set the bottom tile of the block we want to draw to
 STA (SC2),Y            \ the pattern in A, in both nametable buffers

 LDY T                  \ Restore Y from T so it is preserved

 RTS                    \ Return from the subroutine

