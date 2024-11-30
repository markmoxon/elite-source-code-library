\ ******************************************************************************
\
\       Name: BOXS
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Draw a horizontal line across the screen at pixel y-coordinate X
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The pixel y-coordinate for the line
\
\ ******************************************************************************

.BOXS

 STX Y1                 \ Set Y1 = X

 LDX #0                 \ Set X1 = 0
 STX X1

 DEX                    \ Set X2 = 255
 STX X2

 JMP HLOIN              \ Call HLOIN to draw a horizontal line from (X1, Y1) to
                        \ (X2, Y1), so that's from (0, X) to (255, X), and
                        \ return from the subroutine using a tail call

