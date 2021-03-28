\ ******************************************************************************
\
\       Name: LLX30
\       Type: Subroutine
\   Category: Drawing lines
\    Summary: Draw a ship line using smooth animation, by drawing the ship's new
\             line and erasing the corresponding old line from the screen
\
\ ------------------------------------------------------------------------------
\
\ This routine implements smoother ship animation by erasing and redrawing each
\ individual line in the ship, rather than the approach in the other Acornsoft
\ versions of the game, which erase the entire existing ship before drawing the
\ new one.
\
\ Here's the new approach in this routine:
\
\   * Draw the new line
\   * Fetch the corresponding existing line (in position XX14) from the heap
\   * Store the new line in the heap at this position, replacing the old one
\   * If the existing line we just took from the heap is on-screen, erase it
\
\ Arguments:
\
\   XX14                The offset within the line heap where we add the new
\                       line's coordinates
\
\   X1                  The screen x-coordinate of the start of the line to add
\                       to the ship line heap
\
\   Y1                  The screen y-coordinate of the start of the line to add
\                       to the ship line heap
\
\   X2                  The screen x-coordinate of the end of the line to add
\                       to the ship line heap
\
\   Y2                  The screen y-coordinate of the end of the line to add
\                       to the ship line heap
\
\   XX19(1 0)           XX19(1 0) shares its location with INWK(34 33), which
\                       contains the ship line heap address pointer
\
\ Returns:
\
\   XX14                The offset of the next line in the line heap
\
\ ******************************************************************************

.LLX30

 LDY XX14               \ Set Y = XX14, to get the offset within the ship line
                        \ heap where we want to insert our new line

 CPY XX14+1             \ Compare XX14 and XX14+1 and store the flags on the
 PHP                    \ stack so we can retrieve them later

 LDX #3                 \ We now want to copy the line coordinates (X1, Y1) and
                        \ (X2, Y2) to XX12...XX12+3, so set a counter to copy
                        \ 4 bytes

.LLXL

 LDA X1,X               \ Copy the X-th byte of X1/Y1/X2/Y2 to the X-th byte of
 STA XX12,X             \ XX12

 DEX                    \ Decrement the loop counter

 BPL LLXL               \ Loop back until we have copied all four bytes

 JSR LL30               \ Draw a line from (X1, Y1) to (X2, Y2)

 LDA (XX19),Y           \ Set X1 to the Y-th coordinate on the ship line heap,
 STA X1                 \ i.e. one we are replacing in the heap

 LDA XX12               \ Replace it with the X1 coordinate in XX12
 STA (XX19),Y

 INY                    \ Increment the index to point to the Y1 coordinate

 LDA (XX19),Y           \ Set Y1 to the Y-th coordinate on the ship line heap,
 STA Y1                 \ i.e. one we are replacing in the heap

 LDA XX12+1             \ Replace it with the Y1 coordinate in XX12+1
 STA (XX19),Y

 INY                    \ Increment the index to point to the X2 coordinate

 LDA (XX19),Y           \ Set X1 to the Y-th coordinate on the ship line heap,
 STA X2

 LDA XX12+2             \ Replace it with the X2 coordinate in XX12+2
 STA (XX19),Y

 INY                    \ Increment the index to point to the Y2 coordinate

 LDA (XX19),Y           \ Set Y2 to the Y-th coordinate on the ship line heap,
 STA Y2

 LDA XX12+3             \ Replace it with the Y2 coordinate in XX12+3
 STA (XX19),Y

 INY                    \ Increment the index to point to the next coordinate
 STY XX14               \ and store the updated index in XX14

 PLP                    \ Restore the result of the comparison above, so if the
 BCS LL82               \ original value of XX14 >= XX14+1, then we have already
                        \ redrawn all the lines from the old ship's line heap,
                        \ so return from the subroutine (as LL82 contains an
                        \ RTS)

 JMP LL30               \ Otherwise there are still more lines to erase from the
                        \ old ship on-screen, so the coordinates in (X1, Y1) and
                        \ (X2, Y2) that we just pulled from the ship line heap
                        \ point to a line that is still on-screen, so call LL30
                        \ to draw this line and erase it from the screen,
                        \ returning from the subroutine using a tail call

