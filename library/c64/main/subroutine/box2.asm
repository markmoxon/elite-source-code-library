\ ******************************************************************************
\
\       Name: BOX2
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Draw the left and right edges of the border box for the space view
\
\ ******************************************************************************

.BOX2

 LDX #18                \ The space view is 18 character rows tall, so set a
                        \ row counter in X so we draw edges along the sides of
                        \ the space view only

 STX T2                 \ Store the value of X in T2 so we can retrieve it for
                        \ the right edge below

 LDY #LO(SCBASE+3*8)    \ Set (Y SC) to the address of the fourth byte in the
 STY SC                 \ screen bitmap, so we draw the border box in the
 LDY #HI(SCBASE+3*8)    \ rightmost two pixels of the four-character screen
                        \ border on the left

 LDA #%00000011         \ Set a pixel byte in A with the two rightmost pixels
                        \ set, to use for drawing the left edge of the border
                        \ box

 JSR BOXS2              \ Draw the left vertical edge of the border box

 LDY #LO(SCBASE+36*8)   \ Set (Y SC) to the address of the first byte to the
 STY SC                 \ right of the game screen, skipping the four character 
 LDY #HI(SCBASE+36*8)   \ border on the left and the 32 characters of the game
                        \ screen, so we draw the border box in the leftmost two
                        \ pixels of the four-character screen border on the
                        \ right

 LDA #%11000000         \ Set a pixel byte in A with the two leftmost pixels
                        \ set, to use for drawing the right edge of the border
                        \ box

 LDX T2                 \ Set X to the height of the border box that we stored
                        \ in T2 above

 JSR BOXS2              \ Draw the right vertical edge of the border box

 LDA #1                 \ This draws a pixel in character column 35 on the first
 STA SCBASE+&118        \ character row, which is within the four-character
                        \ border to the right of the game screen
                        \
                        \ The palette for this part of the screen is black on
                        \ black, so the result isn't visible, and it's unclear
                        \ what this is for; perhaps it was a visual check used
                        \ during development to ensure that the border area was
                        \ indeed not showing any pixels
                        \
                        \ This write is manually reversed in the DEATH routine

 LDX #0                 \ Set X = 0 so we draw a horizontal line across the
                        \ screen at pixel y-coordinate 0

                        \ Fall into BOXS to draw the top horizontal edge of the
                        \ border box at y-coordinate 0

