\ ******************************************************************************
\
\       Name: BOMBLINES
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw the zig-zag lightning bolt for the energy bomb
\
\ ******************************************************************************

.BOMBLINES

 LDA #CYAN              \ Change the current colour to cyan
 STA COL

 LDA QQ11               \ If the current view is non-zero (i.e. not a space
 BNE BOMBEX             \ view), return from the subroutine (as BOMBEX contains
                        \ an RTS)

 LDY #1                 \ We now want to loop through the 10 (BOMBX, BOMBY)
                        \ coordinates, drawing a total of 9 lines between them
                        \ to make the lightning effect, so set an index in Y
                        \ to point to the end-point for each line, starting with
                        \ the second coordinate pair

 LDA BOMBX              \ Store the first coordinate pair from (BOMBX, BOMBY) in
 STA XX12               \ (XX12, XX12+1)
 LDA BOMBY
 STA XX12+1

.BOMBL1

 LDA XX12               \ Set (X1, Y1) = (XX12, XX12+1)
 STA X1                 \
 LDA XX12+1             \ so the start point for this line
 STA Y1

 LDA BOMBX,Y            \ Set X2 = Y-th x-coordinate from BOMBX
 STA X2

 STA XX12               \ Set XX12 = X2

 LDA BOMBY,Y            \ Set Y2 = Y-th y-coordinate from BOMBY, so we now have:
 STA Y2                 \
                        \   (X2, Y2) = Y-th coordinate from (BOMBX, BOMBY)

 STA XX12+1             \ Set XX12+1 = Y2, so we now have
                        \
                        \   (XX12, XX12+1) = (X2, Y2)
                        \
                        \ so in the next loop iteration, the start point of the
                        \ line will be the end point of this line, making the
                        \ zig-zag lines all join up like a lightning bolt

 JSR LL30               \ Draw a line from (X1, Y1) to (X2, Y2)

 INY                    \ Increment the loop counter

 CPY #10                \ If Y < 10, loop back until we have drawn all the lines
 BCC BOMBL1

.BOMBEX

 RTS                    \ Return from the subroutine

