\ ******************************************************************************
\
\       Name: DrawBlankButton2x2
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Draw a blank icon bar button as a 2x2 tile block
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The number of the top-left tile of the icon bar button
\                       we want to draw, given as a nametable offset from the
\                       first tile in the icon bar (i.e. the tile in the
\                       top-left corner of the icon bar)
\
\   SC(1 0)             The address of the nametable entries for the on-screen
\                       icon bar in nametable buffer 0
\
\   SC2(1 0)            The address of the nametable entries for the on-screen
\                       icon bar in nametable buffer 1
\
\ ******************************************************************************

.DrawBlankButton2x2

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA #4                 \ Set A = 4, which is the number of the top-left pattern
                        \ for a blank 2x2 icon bar button

 STA (SC),Y             \ Set the top-left corner of the 2x2 tile block we want
 STA (SC2),Y            \ to draw to the pattern in A, in both nametable buffers

 INY                    \ Increment Y to move right by one tile

 LDA #5                 \ Set A = 5, which is the number of the top-right
                        \ pattern for a blank 2x2 icon bar button

 STA (SC),Y             \ Set the top-right corner of the 2x2 tile block we want
 STA (SC2),Y            \ to draw to the pattern in A, in both nametable buffers

 TYA                    \ Set Y = Y + 31
 CLC                    \
 ADC #31                \ So Y now points to the bottom-left tile of the 2x2
 TAY                    \ tile block that we want to draw buffers (as there are
                        \ 32 tiles in a row and we already moved right by one)

 LDA #36                \ Set A = 36, which is the number of the bottom-left
                        \ pattern for a blank 2x2 icon bar button

 STA (SC),Y             \ Set the bottom-left corner of the 2x2 tile block we
 STA (SC2),Y            \ want to draw to the pattern in A, in both nametable
                        \ buffers

 INY                    \ Increment Y to move right by one tile

 LDA #37                \ Set A = 37, which is the number of the bottom-right
                        \ pattern for a blank 2x2 icon bar button

 STA (SC),Y             \ Set the bottom-right corner of the 2x2 tile block we
 STA (SC2),Y            \ want to draw to the pattern in A, in both nametable
                        \ buffers

 RTS                    \ Return from the subroutine

