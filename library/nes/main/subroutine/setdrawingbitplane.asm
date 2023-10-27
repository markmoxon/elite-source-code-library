\ ******************************************************************************
\
\       Name: SetDrawingBitplane
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Set the drawing bitplane to a specified value
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The new value of the drawing bitplane
\
\ ******************************************************************************

.SetDrawingBitplane

 STX drawingBitplane    \ Set the drawing bitplane to X

 LDA lastPattern,X      \ Set the next free pattern number in firstFreePattern
 STA firstFreePattern   \ to the number of the last pattern that was sent to the
                        \ PPU for the new bitplane

 LDA nameBufferHiAddr,X \ Set the high byte of the nametable buffer for the new
 STA nameBufferHi       \ bitplane in nameBufferHiAddr

 LDA #0                 \ Set the low byte of pattBufferAddr(1 0) to zero (we
 STA pattBufferAddr     \ will set the high byte in SetPatternBuffer below

 STA drawingPlaneDebug  \ Set drawingPlaneDebug = 0 (though this value is never
                        \ read, so this has no effect)

                        \ Fall through into SetPatternBuffer to set the high
                        \ bytes of the patten buffer address variables

