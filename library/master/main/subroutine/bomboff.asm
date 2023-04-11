\ ******************************************************************************
\
\       Name: BOMBOFF
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw the zig-zag lightning bolt for the energy bomb
\
\ ******************************************************************************

.BOMBOFF

 LDA #CYAN              \ Change the current colour to cyan
 STA COL

 LDA QQ11               \ If the current view is non-zero (i.e. not a space
 BNE BOMBR1             \ view), return from the subroutine (as BOMBR1 contains
                        \ an RTS)

 LDY #1                 \ We now want to loop through the 10 (BOMBTBX, BOMBTBY)
                        \ coordinates, drawing a total of 9 lines between them
                        \ to make the lightning effect, so set an index in Y
                        \ to point to the end-point for each line, starting with
                        \ the second coordinate pair

 LDA BOMBTBX            \ Store the first coordinate pair from (BOMBTBX,
 STA XX12               \ BOMBTBY) in (XX12, XX12+1)
 LDA BOMBTBY
 STA XX12+1

.BOMBL1

 LDA XX12               \ Set (X1, Y1) = (XX12, XX12+1)
 STA X1                 \
 LDA XX12+1             \ so the start point for this line
 STA Y1

 LDA BOMBTBX,Y          \ Set X2 = Y-th x-coordinate from BOMBTBX
 STA X2

 STA XX12               \ Set XX12 = X2

 LDA BOMBTBY,Y          \ Set Y2 = Y-th y-coordinate from BOMBTBY, so we now
 STA Y2                 \ have:
                        \
                        \   (X2, Y2) = Y-th coordinate from (BOMBTBX, BOMBTBY)

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

.BOMBR1

 RTS                    \ Return from the subroutine

