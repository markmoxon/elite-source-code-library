\ ******************************************************************************
\
\       Name: HLOIN2
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a horizontal line in a specific colour
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X1                  The screen x-coordinate of the start of the line
\
\   X2                  The screen x-coordinate of the end of the line
\
\   Y1                  The screen y-coordinate of the line
\
\   COL                 The line colour
\
\ ******************************************************************************

.HLOIN2

 LDX X1                 \ Set X = X1

 STY Y2                 \ Set Y2 = Y, the offset within the line buffer of the

 INY                    \ Set Q = Y + 1, so the call to HLOIN3 only draws one
 STY Q                  \ line

 LDA COL                \ Set A to the line colour

 JMP HLOIN3             \ Jump to HLOIN3 to draw a line from (X, Y1) to (X2, Y1)
                        \ in the colour given in A

