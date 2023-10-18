\ ******************************************************************************
\
\       Name: LAUN
\       Type: Subroutine
\   Category: Flight
\    Summary: Make the launch sound and draw the launch tunnel
\
\ ------------------------------------------------------------------------------
\
\ This is shown when launching from or docking with the space station.
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ ******************************************************************************

.LAUN

 LDA #&00               \ Clear the screen and set the view type in QQ11 to &00
 JSR ChangeToView       \ (Space view with no fonts loaded)

 JSR HideMostSprites    \ Hide all sprites except for sprite 0 and the icon bar
                        \ pointer

 LDY #12                \ Call the NOISE routine with Y = 12 to make the first
 JSR NOISE              \ sound of the ship launching from the station

 LDA #128               \ Set K+2 = 128 to send to DrawLaunchBox and
 STA K+2                \ DrawLightning as the x-coordinate of the centre of the
                        \ boxes and lightning (so they are centred on-screen)

 LDA halfScreenHeight   \ Set K+3 to half the screen height to send to
 STA K+3                \ DrawLaunchBox and DrawLightning as the y-coordinate of
                        \ the centre of the boxes and lightning (so they are
                        \ centred on-screen)

 LDA #80                \ Set XP to use as a counter for the duration of the
 STA XP                 \ hyperspace effect, so we run the following loop 80
                        \ times

 LDA #112               \ Set YP to use as a counter for when we show the
 STA YP                 \ lightning effect at the end of the tunnel, which we
                        \ show when YP < 100 (so we wait until 13 frames have
                        \ passed before drawing the lightning)
                        \
                        \ Also, at the start of each frame, we keep subtracting
                        \ 16 from STP until STP < YP, and only then do we start
                        \ drawing boxes and, possibly, the lightning

 LDY #4                 \ Wait until four NMI interrupts have passed (i.e. the
 JSR DELAY              \ next four VBlanks)

 LDY #24                \ Call the NOISE routine with Y = 24 to make the second
 JSR NOISE              \ sound of the ship launching from the station

.laun1

 JSR CheckForPause-3    \ Check whether the pause button has been pressed or an
                        \ icon bar button has been chosen, and process pause or
                        \ unpause if a pause-related button has been pressed

 JSR FlipDrawingPlane   \ Flip the drawing bitplane so we draw into the bitplane
                        \ that isn't visible on-screen

 LDA XP                 \ Set STP = 96 + (XP mod 16)
 AND #15                \
 ORA #96                \
 STA STP                \ So over the course of the 80 iterations around the
                        \ loop, STP starts at 96, then counts down from 112 to
                        \ 96, and keeps repeating this countdown until XP is
                        \ zero and STP is 96
                        \
                        \ The higher the value of STP, the closer together the
                        \ lines in the tunnel, so this makes the tunnel lines
                        \ move further away as the animation progresses, giving
                        \ a feeling of moving forwards through the tunnel

 LDA #%10000000         \ Set bit 7 of firstBox so we can detect when we are on
 STA firstBox           \ the first iteration of the laun2 loop

                        \ We now draw the boxes in the launch tunnel effect,
                        \ looping back to hype2 for each new line
                        \
                        \ STP gets decremented by 16 for each box, so STP is
                        \ set to the starting point (in the range 96 to 112),
                        \ and gets decremented by 16 for each box until it is
                        \ negative
                        \
                        \ As STP decreases, the boxes get bigger, so this loop
                        \ draws the boxes from the smallest in the middle and
                        \ working out towards the edges

.laun2

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA STP                \ Set STP = STP + 16
 SEC                    \
 SBC #16                \ And set A to the new value of STP

 BMI laun4              \ If STP is now negative, then jump to laun4 to move on
                        \ to the next frame, so we stop drawing boxes in this
                        \ frame

 STA STP                \ Update STP with the new value

 CMP YP                 \ If STP >= YP, jump to laun2 to keep reducing STP until
 BCS laun2              \ STP < YP

 STA Q                  \ Set Q to the new value of STP

                        \ We now calculate how far the top edge of this box is
                        \ from the centre of the screen in a vertical direction,
                        \ with the result being boxes that are closer together,
                        \ the closer they are to the centre
                        \
                        \ We space out the boxes using a reciprocal algorithm,
                        \ where the distance of line n from the centre is
                        \ proportional to 1/n, so the boxes get spaced roughly
                        \ in the proportions of 1/2, 1/3, 1/4, 1/5 and so on, so
                        \ the boxes bunch closer together as n increases
                        \
                        \ STP also includes the iteration number, modded so it
                        \ runs from 15 to 0, so over the course of the animation
                        \ the boxes move away from the centre line, as the
                        \ iteration decreases and the value of R below increases

 LDA #8                 \ Set A = 8 to use in the following division

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q
                        \     = 256 * 8 / STP
                        \
                        \ So R is the vertical distance of the current box top
                        \ top from the centre of the screen
                        \
                        \ The maximum value of STP is 112 - 16 = 96, and the
                        \ minimum is 0 (the latter being enforced by the
                        \ comparison above), so R ranges from 21 to 255

 LDA R                  \ Set A = R - 20
 SEC                    \
 SBC #20                \ This sets the range of values in A to 1 to 235

                        \ We can now use A as half the height of the box to
                        \ draw, to give us an effect where the boxes are more
                        \ spread out as they get taller, and which get bigger
                        \ as the animation progresses, with the difference in
                        \ size between frames being more pronounced with the
                        \ bigger boxes

 CMP #84                \ If A >= 84, jump to laun4 to move on to the next frame
 BCS laun4              \ as the box is outside the edges of the screen (so we
                        \ can stop drawing lines in this frame as we have now
                        \ drawn them all)

 STA K+1                \ Set K+1 = A to send to DrawLaunchBox and DrawLightning
                        \ as half the height of the box/lightning

 LSR A                  \ Set K = 1.5 * K+1 to send to DrawLaunchBox and
 ADC K+1                \ DrawLightning as half the width of the box, so the box
 STA K                  \ is 50% wider than it is tall (as it's a space station
                        \ slot)

 ASL firstBox           \ Set the C flag to bit 7 of firstBox and zero firstBox
                        \ (as we know that only bit 7 of firstBox is set before
                        \ the shift)

 BCC laun3              \ If the C flag is clear then this is not the first
                        \ iteration of the laun2 loop for this frame, so jump to
                        \ laun3 to draw the box, skipping the lightning (so we
                        \ only draw the lightning on the first iteration of
                        \ laun2 for this frame

                        \ If we get here then this is the first iteration of the
                        \ laun2 loop for this frame, so we consider drawing the
                        \ lightning effect at the end of the tunnel

 LDA YP                 \ If YP >= 100, jump to laun3 to skip drawing the
 CMP #100               \ lightning as the tunnel exit is too small to contain
 BCS laun3              \ the lightning effect

 LDA K+1                \ If K+1 >= 72, jump to laun5 to draw the lightning but
 CMP #72                \ without drawing any boxes, as the first box (which is
 BCS laun5              \ the smallest) doesn't fit on-screen

 LDA STP                \ Store the value of STP on the stack so we can retrieve
 PHA                    \ it after the call to DrawLightning (as DrawLightning
                        \ corrupts the value of STP)

 JSR DrawLightning_b6   \ Call DrawLightning to draw the lightning effect at the
                        \ end of the tunnel, centred on the centre of the screen
                        \ and in a rectangle with a half-height of K and a
                        \ half-width of 1.5 * K (so it fits within the smallest
                        \ launch box)

 PLA                    \ Restore the value of STP that we stored on the stack
 STA STP

.laun3

 JSR DrawLaunchBox_b6   \ Draw a box centred on the centre of the screen, with a
                        \ half-height of K and a half-width of 1.5 * K

 JMP laun2              \ Loop back to laun2 to draw the next box

.laun4

 JSR DrawBitplaneInNMI  \ Configure the NMI to send the drawing bitplane to the
                        \ PPU after drawing the box edges and setting the next
                        \ free tile number

 DEC YP                 \ Decrement the lightning counter in YP

 DEC XP                 \ Decrement the frame counter in XP

 BNE laun1              \ Loop back to laun1 to draw the next frame of the
                        \ animation, until the frame counter runs down to 0

 LDY #23                \ Call the NOISE routine with Y = 23 to make the third
 JMP NOISE              \ sound of the ship launching from the station,
                        \ returning from the subroutine using a tail call

.laun5

                        \ We call this from the first iteration of the loop in
                        \ this frame, and when K+1 >= 72, which means that the
                        \ first box in this frame (which will be the smallest)
                        \ is too big for the screen, so we just draw the
                        \ lightning effect and don't draw any boxes

 LDA #72                \ Set K+1 = 72 to pass to DrawLightning as half the
 STA K+1                \ height of the lightning effect

 LDA STP                \ Store the value of STP on the stack so we can retrieve
 PHA                    \ it after the call to DrawLightning (as DrawLightning
                        \ corrupts the value of STP)

 JSR DrawLightning_b6   \ Call DrawLightning to draw the lightning effect at the
                        \ end of the tunnel, centred on the centre of the screen
                        \ and in a rectangle with a half-height of K and a
                        \ half-width of 1.5 * K (so it fits within the smallest
                        \ launch box)

 PLA                    \ Restore the value of STP that we stored on the stack
 STA STP

 JMP laun2              \ Loop back to laun2 to draw the next box

 RTS                    \ Return from the subroutine

