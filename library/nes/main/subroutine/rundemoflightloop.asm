\ ******************************************************************************
\
\       Name: RunDemoFlightLoop
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Run a fixed number of iterations of the main flight loop for the
\             combat demo
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of iterations of the main flight loop to run
\
\ ******************************************************************************

.RunDemoFlightLoop

 STA LASCT              \ Store the number of iterations in LASCT so we can
                        \ access it after running the main flight loop

.dlop1

 JSR FlipDrawingPlane   \ Flip the drawing bitplane so we draw into the bitplane
                        \ that isn't visible on-screen

 JSR FlightLoop4To16    \ Display in-flight messages, call parts 4 to 12 of the
                        \ main flight loop for each ship slot, and finish off
                        \ with parts 13 to 16 of the main flight loop

 JSR DrawBitplaneInNMI  \ Configure the NMI to send the drawing bitplane to the
                        \ PPU after drawing the box edges and setting the next
                        \ free tile number

 LDA iconBarChoice      \ Set A to the number of the icon bar button that has
                        \ been chosen from the icon bar (if any)

 JSR CheckForPause      \ If the Start button has been pressed then process the
                        \ pause menu and set the C flag, otherwise clear it

 DEC LASCT              \ Decrement the iteration counter in LASCT

 BNE dlop1              \ Loop back to run the main flight loop again until we
                        \ have run it the required number of times

 RTS                    \ Return from the subroutine

