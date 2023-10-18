\ ******************************************************************************
\
\       Name: FlipDrawingPlane
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Flip the drawing bitplane
\
\ ******************************************************************************

.FlipDrawingPlane

 LDA drawingBitplane    \ Set X to the opposite bitplane to the current drawing
 EOR #1                 \ bitplane
 TAX

 JSR SetDrawingBitplane \ Set X as the new drawing bitplane, so this effectively
                        \ flips the drawing bitplane between 0 and 1

 JMP ClearDrawingPlane  \ Jump to ClearDrawingPlane to clear the buffers for the
                        \ new drawing bitplane, returning from the subroutine
                        \ using a tail call

