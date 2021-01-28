\ ******************************************************************************
\
\       Name: WPLS2
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Remove the planet from the screen
\
\ ------------------------------------------------------------------------------
\
\ We do this by redrawing it using the lines stored in the ball line heap when
\ the planet was originally drawn by the BLINE routine.
\
\ Other entry points:
\
\   WPLS-1              Contains an RTS
\
\ ******************************************************************************

.WPLS2

 LDY LSX2               \ If LSX2 is non-zero (which indicates the ball line
 BNE WP1                \ heap is empty), jump to WP1 to reset the line heap
                        \ without redrawing the planet

                        \ Otherwise Y is now 0, so we can use it as a counter to
                        \ loop through the lines in the line heap, redrawing
                        \ each one to remove the planet from the screen, before
                        \ resetting the line heap once we are done

.WPL1

 CPY LSP                \ If Y >= LSP then we have reached the end of the line
 BCS WP1                \ heap and have finished redrawing the planet (as LSP
                        \ points to the end of the heap), so jump to WP1 to
                        \ reset the line heap, returning from the subroutine
                        \ using a tail call

 LDA LSY2,Y             \ Set A to the y-coordinate of the current heap entry

 CMP #&FF               \ If the y-coordinate is &FF, this indicates that the
 BEQ WP2                \ next point in the heap denotes the start of a line
                        \ segment, so jump to WP2 to put it into (X1, Y1)

 STA Y2                 \ Set (X2, Y2) to the x- and y-coordinates from the
 LDA LSX2,Y             \ heap
 STA X2

 JSR LOIN               \ Draw a line from (X1, Y1) to (X2, Y2)

 INY                    \ Increment the loop counter to point to the next point

 LDA SWAP               \ If SWAP is non-zero then we swapped the coordinates
 BNE WPL1               \ when filling the heap in BLINE, so loop back WPL1
                        \ for the next point in the heap

 LDA X2                 \ Swap (X1, Y1) and (X2, Y2), so the next segment will
 STA X1                 \ be drawn from the current (X2, Y2) to the next point
 LDA Y2                 \ in the heap
 STA Y1

 JMP WPL1               \ Loop back to WPL1 for the next point in the heap

.WP2

 INY                    \ Increment the loop counter to point to the next point

 LDA LSX2,Y             \ Set (X1, Y1) to the x- and y-coordinates from the
 STA X1                 \ heap
 LDA LSY2,Y
 STA Y1

 INY                    \ Increment the loop counter to point to the next point

 JMP WPL1               \ Loop back to WPL1 for the next point in the heap
