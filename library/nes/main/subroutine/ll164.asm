\ ******************************************************************************
\
\       Name: LL164
\       Type: Subroutine
\   Category: Flight
\    Summary: Make the hyperspace sound and draw the hyperspace tunnel
\
\ ------------------------------------------------------------------------------
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ ******************************************************************************

.LL164

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 JSR HideStardust       \ Hide the stardust sprites

 JSR HideExplosionBurst \ Hide the four sprites that make up the explosion burst

 JSR MakeHyperSound     \ Make the hyperspace sound

 LDA #128               \ This value is not used in the following, so this has
 STA K+2                \ no effect

 LDA #72                \ This value is not used in the following, so this has
 STA K+3                \ no effect

 LDA #64                \ Set XP to use as a counter for each frame of the
 STA XP                 \ hyperspace effect, so we run the following loop 64
                        \ times for an animation of 64 frames

                        \ We now draw 64 frames of hyperspace effect, looping
                        \ back to hype1 for each new frame

.hype1

 JSR CheckPauseButton   \ Check whether the pause button has been pressed or an
                        \ icon bar button has been chosen, and process pause or
                        \ unpause if a pause-related button has been pressed

 JSR DORND              \ Set X to a random number between 0 and 15
 AND #15
 TAX

 LDA hyperspaceColour,X \ Set the visible colour to entry number X from the
 STA visibleColour      \ hyperspaceColour table, so this sets the hyperspace
                        \ colour randomly to one of the colours in the table

 JSR FlipDrawingPlane   \ Flip the drawing bitplane so we draw into the bitplane
                        \ that isn't visible on-screen

 LDA XP                 \ Set STP = XP mod 32
 AND #31                \
 STA STP                \ So over the course of the 64 iterations around the
                        \ loop, STP starts at 0, then counts down from 31 to 0,
                        \ and then counts down from 31 to 1 again
                        \
                        \ The higher the value of STP, the closer together the
                        \ lines in the hyperspace effect, so this makes the
                        \ lines move further away as the effect progresses,
                        \ giving a feeling of moving through hyperspace

 LDA #8                 \ Set X1 = 8 so we draw horizontal lines from
 STA X1                 \ x-coordinate 8 on the left of the screen

 LDA #248               \ Set X2 = 248 so we draw horizontal lines to
 STA X2                 \ x-coordinate 248 on the right of the screen

                        \ We now draw the lines in the hyperspace effect (with
                        \ lines in the top half of the screen and the same
                        \ lines, reflected, in the bottom half), looping back
                        \ to hype2 for each new line
                        \
                        \ STP gets incremented by 16 for each line, so STP is
                        \ set to the starting point (in the range 0 to 31), plus
                        \ 16 for the first line, plus 32 for the second line,
                        \ and so on until we get to 90, at which point we stop
                        \ drawing lines for this frame
                        \
                        \ As STP increases, the lines get closer to the middle
                        \ of the screen, so this loop draws the lines, starting
                        \ with the lines furthest from the centre and working in
                        \ towards the centre

.hype2

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA STP                \ Set STP = STP + 16
 CLC                    \
 ADC #16                \ And set A to the new value of STP
 STA STP

 CMP #90                \ If A >= 90, jump to hype3 to move on to the next frame
 BCS hype3              \ (so we stop drawing lines in this frame)

 STA Q                  \ Set Q to the new value of STP

                        \ We now calculate how far this horizontal line is from
                        \ the centre of the screen in a vertical direction, with
                        \ the result being lines that are closer together, the
                        \ closer they are to the centre
                        \
                        \ We space out the lines using a reciprocal algorithm,
                        \ where the distance of line n from the centre is
                        \ proportional to 1/n, so the lines get spaced roughly
                        \ in the proportions of 1/2, 1/3, 1/4, 1/5 and so on, so
                        \ the lines bunch closer together as n increases
                        \
                        \ STP also includes the iteration number, modded so it
                        \ runs from 31 to 0, so over the course of the animation
                        \ the lines move away from the centre line, as the
                        \ iteration decreases and the value of R below increases

 LDA #8                 \ Set A = 8 to use in the following division

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q
                        \     = 256 * 8 / STP
                        \
                        \ So R is the vertical distance of the current line from
                        \ the centre of the screen
                        \
                        \ The minimum value of STP is 16 and the maximum is 89
                        \ (the latter being enforced by the comparison above),
                        \ so R ranges from 128 to 23

 LDA R                  \ Set K+1 = R - 20
 SEC                    \
 SBC #20                \ This sets the range of values in K+1 to 108 to 3
 STA K+1

                        \ We can now use K+1 as the vertical distance of this
                        \ line from the centre of the screen, to give us an
                        \ effect where the horizontal lines spread out as they
                        \ get away from the centre, and which move away from the
                        \ centre as the animation progresses, with the movement
                        \ being bigger the further away the line
                        \
                        \ We now draw this line twice, once above the centre and
                        \ once below the centre, so the lines in the top and
                        \ bottom parts of the screen are mirrored, and the
                        \ overall effect is of hyperspacing forwards, sandwiched
                        \ between two horizontal planes, one above and one below

 LDA halfScreenHeight   \ Set A = halfScreenHeight - K+1
 SBC K+1                \
                        \ So A is the y-coordinate of the line in the top half
                        \ of the screen

 BCC hype2              \ If A <= 0 then the line is off the top of the screen,
 BEQ hype2              \ so jump to hype2 to move on to the next line

 TAY                    \ Set Y = A, to use as the y-coordinate for this line
                        \ in the hyperspace effect

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y)

 INC X2                 \ The HLOIN routine decrements X2, so increment it back
                        \ to its original value

 LDA K+1                \ Set A = halfScreenHeight + K+1
 CLC                    \
 ADC halfScreenHeight   \ So A is the y-coordinate of the line in the bottom
                        \ half of the screen

 TAY                    \ Set Y = A, to use as the y-coordinate for this line
                        \ in the hyperspace effect

 JSR HLOIN              \ Draw a horizontal line from (X1, Y) to (X2, Y)

 INC X2                 \ The HLOIN routine decrements X2, so increment it back
                        \ to its original value

 JMP hype2              \ Loop back to hype2 to draw the next horizontal line
                        \ in this iteration

.hype3

 JSR DrawBitplaneInNMI  \ Configure the NMI to send the drawing bitplane to the
                        \ PPU after drawing the box edges and setting the next
                        \ free tile number

 DEC XP                 \ Decrement the frame counter in XP

 BNE hype1              \ Loop back to hype1 to draw the next frame of the
                        \ animation, until the frame counter runs down to 0

 JMP WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU,
                        \ and return from the subroutine using a tail call

