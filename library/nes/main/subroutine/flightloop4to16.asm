\ ******************************************************************************
\
\       Name: FlightLoop4To16
\       Type: Subroutine
\   Category: Main loop
\    Summary: Display in-flight messages, call parts 4 to 12 of the main flight
\             loop for each slot, and fall through into parts 13 to 16
\
\ ******************************************************************************

.main24

 DEC DLY                \ Decrement the delay counter in DLY, which is used to
                        \ control how long flight messages remain on-screen

 BMI main27             \ If DLY is now negative, jump to main27 to set DLY to
                        \ zero and skip the following, as there is no flight
                        \ message to display

 BEQ main25             \ DLY is now zero so it must have been non-zero before
                        \ we decremented it, so jump to main25 to remove the
                        \ flight message from the screen, as its timer has run
                        \ down

                        \ DLY is non-zero, so we need to redraw any flight
                        \ messages we may have, so they remain on-screen while
                        \ DLY is still ticking down

 JSR PrintFlightMessage \ Print the current in-flight message, if there is one

 JMP main26             \ Jump to main26 to display the message we just printed
                        \ and continue with the rest of the main loop

.main25

 JSR CLYNS              \ Clear the bottom two text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the two bottom rows

.main26

 JSR DrawMessageInNMI   \ Configure the NMI to update the in-flight message part
                        \ of the screen (which is either the current in-flight
                        \ message, or the part of the screen that the call to
                        \ CLYNS just cleared)

 JMP MA16               \ Jump to MA16 to skip the following and continue with
                        \ the rest of the main loop

.FlightLoop4To16

 LDA QQ11               \ If this is not the space view (i.e. QQ11 is non-zero),
 BNE main24             \ jump to main24 to print the flight message for
                        \ non-space views, rejoining the main subroutine at MA16
                        \ below

 DEC DLY                \ Decrement the delay counter in DLY, which is used to
                        \ control how long flight messages remain on-screen

 BMI main27             \ If DLY is now 0 or negative, jump to main27 to set DLY
 BEQ main27             \ to zero and skip the following, as there is no flight
                        \ message to display

                        \ DLY is non-zero, so we need to redraw any flight
                        \ messages we may have, so they remain on-screen while
                        \ DLY is still ticking down

 JSR PrintFlightMessage \ Print the current flight message, if there is one

 JMP MA16               \ Jump to MA16 to skip the following and continue with
                        \ the rest of the main loop

.main27

 LDA #0                 \ Set DLY to 0 so that it doesn't decrement below zero
 STA DLY

.MA16

 LDA ECMP               \ If our E.C.M is not on, skip to MA69, otherwise keep
 BEQ MA69               \ going to drain some energy

 JSR DENGY              \ Call DENGY to deplete our energy banks by 1

 BEQ MA70               \ If we have no energy left, jump to MA70 to turn our
                        \ E.C.M. off

.MA69

 LDA ECMA               \ If an E.C.M is going off (ours or an opponent's) then
 BEQ MA66               \ keep going, otherwise skip to MA66

 LDA #128               \ Set K+2 = 128 to send to the DrawLightning routine as
 STA K+2                \ the x-coordinate of the centre of the lightning, so
                        \ it is centred on-screen

 LDA #127               \ Set K = 127 to send to the DrawLightning routine as
 STA K                  \ half the height of the lightning, so it fills the
                        \ whole screen width

 LDA halfScreenHeight   \ Set K+3 to the y-coordinate of the centre of the
 STA K+3                \ screen in halfScreenHeight, to send to the
                        \ DrawLightning routine as the y-coordinate of the
                        \ centre of the lightning, so it is centred on-screen

 STA K+1                \ Set K+1 to the y-coordinate of the centre of the
                        \ screen in halfScreenHeight, to send to the
                        \ DrawLightning routine as half the height of the
                        \ lightning, so it fills the whole screen height

 JSR DrawLightning_b6   \ Draw the lightning effect of the E.C.M. going off

 DEC ECMA               \ Decrement the E.C.M. countdown timer, and if it has
 BNE MA66               \ reached zero, keep going, otherwise skip to MA66

.MA70

 JSR ECMOF              \ If we get here then either we have either run out of
                        \ energy, or the E.C.M. timer has run down, so switch
                        \ off the E.C.M.

.MA66

 LDX #0                 \ We are about to work our way through all the ships in
                        \ the bubble, calling MAL1 (parts 4 to 12 of the main
                        \ flight loop) for each of them, so set X as a ship slot
                        \ counter

 LDA FRIN               \ If slot 0 is empty, jump to main28 to move on to the
 BEQ main28             \ next slot

 JSR MAL1               \ Call parts 4 to 12 of the main flight loop to update
                        \ the ship in slot 0

.main28

 LDX #2                 \ We deal with the sun/space station in slot 1 below, so
                        \ we now skip to slot 2 by setting X accordingly

.main29

 LDA FRIN,X             \ If slot X is empty then we have reached the last slot,
 BEQ main30             \ so jump to main30 to stop updating the slots

 JSR MAL1               \ Call parts 4 to 12 of the main flight loop to update
                        \ the ship in slot X

 JMP main29             \ Loop back until we have updated all the ship slots

.main30

 LDX #1                 \ We now process the sun/space station in slot 1, so we
                        \ set X as the slot number

 LDA FRIN+1             \ If slot 1 is empty then there is no sun or space
 BEQ MA18               \ station (which can happen in witchspace), so jump to
                        \ part 13 of the main loop as we are done updating the
                        \ ship slots

 BPL main31             \ If bit 7 of the ship type is clear, then this is the
                        \ space station rather than the sun, so jump to main31
                        \ to skip the following

 LDY #0                 \ Set the "space station present" flag to 0, as we are
 STY SSPR               \ no longer in the space station's safe zone

.main31

 JSR MAL1               \ Call parts 4 to 12 of the main flight loop to update
                        \ the sun or space station in slot 2

                        \ Fall through into part 13 to continue working through
                        \ the main flight loop

