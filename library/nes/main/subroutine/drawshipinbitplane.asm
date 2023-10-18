\ ******************************************************************************
\
\       Name: DrawShipInBitplane
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Flip the drawing bitplane and draw the current ship in the newly
\             flipped bitplane
\
\ ******************************************************************************

.DrawShipInBitplane

 JSR FlipDrawingPlane   \ Flip the drawing bitplane so we draw into the bitplane
                        \ that isn't visible on-screen

 JSR LL9_b1             \ Draw the current ship into the newly flipped drawing
                        \ bitplane

                        \ Fall through into DrawBitplaneInNMI to configure the
                        \ NMI to send the drawing bitplane to the PPU

