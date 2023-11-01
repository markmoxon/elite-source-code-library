\ ******************************************************************************
\
\       Name: DrawSpaceViewInNMI
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Configure the NMI handler to draw the space view
\
\ ******************************************************************************

.DrawSpaceViewInNMI

 LDA QQ11               \ If this is not the space view, jump to spvw3 to skip
 BNE spvw3              \ the following, as we only need to send the drawing
                        \ bitplane to the PPU and update the dashboard in the
                        \ space view

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0
                        \
                        \ If bit 7 of setupPPUForIconBar is set, then this also
                        \ affects the C flag as follows:
                        \
                        \   * If bit 6 of PPU_STATUS is clear then the C flag
                        \     is set to bit 7 of PPU_STATUS (which is set if
                        \     VBlank has started, clear otherwise)
                        \
                        \   * If bit 6 of PPU_STATUS is set (sprite 0 has been
                        \     hit) then the C flag is cleared
                        \
                        \ So the C flag is set if we are in VBlank, or if we
                        \ aren't in VBlank but the PPU has not yet reached the
                        \ icon bar (i.e. it hasn't started drawing the
                        \ dashboard yet)
                        \
                        \ In other words, the C flag is clear if the PPU is
                        \ currently drawing the dashboard, and set if it is not

 LDA drawingBitplane    \ If the drawing bitplane is 1, jump to spvw1 to send
 BNE spvw1              \ the drawing plane to the PPU without updating the
                        \ whole dashboard first

                        \ If we get here then the drawing bitplane is 0, so now
                        \ we do various checks to determine whether to update
                        \ the whole dashboard before sending to the PPU (as
                        \ updating the whole dashboard takes time)

 LDA sendDashboardToPPU \ Flip the value of sendDashboardToPPU between 0 and &FF
 EOR #&FF               \ so it flips every time we run the main loop with the
 STA sendDashboardToPPU \ drawing bitplane set to 0 (so we only update the whole
                        \ dashboard every other iteration that the drawing
                        \ bitplane is set to 0)

 BMI spvw2              \ If bit 7 of the result is set (so sendDashboardToPPU
                        \ is now &FF), jump to spvw2 to update the whole
                        \ dashboard before sending it to the PPU

 LDA KY1                \ If the B button is being pressed with either the up or
 ORA KY2                \ down button (to change our speed), or the C flag is
 ROR A                  \ set, jump to spvw2 to update the whole dashboard
 BNE spvw2              \ before sending it to the PPU
                        \
                        \ This makes the speed indicator react more quickly to
                        \ speed changes, as it triggers an update of the whole
                        \ dashboard when we are changing speed, and it also
                        \ ensures we do not update the whole dashboard if the
                        \ PPU is currently in the process of drawing it

.spvw1

                        \ If we get here then either the drawing bitplane is 1,
                        \ or it's 0 and the following are true:
                        \
                        \   * sendDashboardToPPU has just flipped to 0
                        \
                        \   * The change speed buttons are not being pressed
                        \
                        \   * The C flag is clear, so the PPU is currently
                        \     drawing the dashboard
                        \
                        \ So we can get away with not updating the dashboard
                        \ for two iterations out of four (i.e. when the drawing
                        \ bitplane is 1), plus an extra iteration (i.e. every
                        \ other iteration with bitplane 0) but only if the speed
                        \ buttons aren't being pressed or the PPU is currently
                        \ drawing the dashboard

 JSR DrawBitplaneInNMI  \ Configure the NMI to send the drawing bitplane to the
                        \ PPU after drawing the box edges and setting the next
                        \ free tile number

 JSR COMPAS             \ Call COMPAS to update the compass

 JMP DrawPitchRollBars  \ Update the pitch and roll bars on the dashboard,
                        \ returning from the subroutine using a tail call

.spvw2

 LDA #%10001000         \ Set the bitplane flags for the drawing bitplane to the
 JSR SetDrawPlaneFlags  \ following:
                        \
                        \   * Bit 2 clear = send tiles up to configured numbers
                        \   * Bit 3 set   = clear buffers after sending data
                        \   * Bit 4 clear = we've not started sending data yet
                        \   * Bit 5 clear = we have not yet sent all the data
                        \   * Bit 6 clear = only send pattern data to the PPU
                        \   * Bit 7 set   = send data to the PPU
                        \
                        \ Bits 0 and 1 are ignored and are always clear
                        \
                        \ This configures the NMI to send pattern data for the
                        \ drawing bitplane to the PPU during VBlank

 JSR COMPAS             \ Call COMPAS to update the compass

 JSR DrawPitchRollBars  \ Update the pitch and roll bars on the dashboard

 JSR DIALS_b6           \ Call DIALS to update the dashboard

 LDX drawingBitplane    \ Set X to the drawing bitplane

 LDA bitplaneFlags,X    \ Set bit 6 of the flags for the drawing bitplane, so
 ORA #%01000000         \ we send both nametable and pattern table data for
 STA bitplaneFlags,X    \ bitplane X to the PPU in the NMI handler

 RTS                    \ Return from the subroutine

.spvw3

                        \ We jump here if this is not the space view, with the
                        \ view type in A

 CMP #&98               \ If this is not the Status Mode screen, jump to spvw6
 BNE spvw6              \ to skip the following, as we can only flash the
                        \ commander image background when it's on-screen in the
                        \ Status Mode view

 JSR GetStatusCondition \ Set X to our ship's status condition

 CPX previousCondition  \ If our condition hasn't changed, jump to spvw4 to
 BEQ spvw4              \ skip the following instruction

 JSR STATUS             \ Call STATUS to refresh the Status Mode screen, so our
                        \ status updates to show the new condition

.spvw4

 LDX previousCondition  \ Set X to the previous status condition

 CPX #3                 \ If the previous status condition was not red, jump to
 BNE spvw5              \ spvw5 to show the alert colour for the previous
                        \ condition

 LDA nmiCounter         \ If nmiCounter div 32 is odd (which will happen half
 AND #32                \ the time, and for 32 VBlanks in a row), jump to spvw5
 BNE spvw5              \ to skip the following

                        \ We get here if the previous condition was red, but
                        \ only for every other block of 32 VBlanks, so this
                        \ flashes the commander image background on and off with
                        \ a period of 32 VBlanks

 INX                    \ Increment X to 4, which will make the background of
                        \ the commander image flash between the top two alert
                        \ colours (i.e. light red and dark red)

.spvw5

 LDA alertColours,X     \ Change the palette so the visible colour is set to the
 STA visibleColour      \ alert colour for our status condition

.spvw6

 RTS                    \ Return from the subroutine

