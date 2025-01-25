\ ******************************************************************************
\
\       Name: cleargrap
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear screen memory for the top part of the graphics screen mode
\             (the space view), drawing blue borders along the sides as we do so
\
\ ******************************************************************************

.cleargrap

 LDY #16                \ Set a counter in Y to clear the 17 character rows of
                        \ the space view

.cleargl

 JSR clearrow           \ Clear character row Y in screen memory, drawing blue
                        \ borders along the left and right edges as we do so

 DEY                    \ Decrement the row counter

 BPL cleargl            \ Loop back until we have cleared all 17 character rows

 INY                    \ Y is decremented to 255 by the loop, so this sets Y to
                        \ zero

 STY XC                 \ Move the text cursor to column 0 on row 0
 STY YC

 RTS                    \ Return from the subroutine

