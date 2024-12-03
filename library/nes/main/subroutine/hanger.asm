\ ******************************************************************************
\
\       Name: HANGER
\       Type: Subroutine
\   Category: Ship hangar
\    Summary: Display the ship hangar
\
\ ------------------------------------------------------------------------------
\
\ This routine is called after the ships in the hangar have been drawn, so all
\ it has to do is draw the hangar's background.
\
\ The hangar background is made up of two parts:
\
\   * The hangar floor consists of four screen-wide horizontal lines at the
\     y-coordinates given in the yHangarFloor table, which are close together at
\     the horizon and further apart as the eye moves down and towards us, giving
\     the hangar a simple sense of perspective
\
\   * The back wall of the hangar consists of equally spaced vertical lines
\     that join the horizon to the top of the screen
\
\ The ships in the hangar have already been drawn by this point, so the lines
\ are drawn so they don't overlap anything that's already there, which makes
\ them look like they are behind and below the ships. This is achieved by
\ drawing the lines in from the screen edges until they bump into something
\ already on-screen. For the horizontal lines, when there are multiple ships in
\ the hangar, this also means drawing lines between the ships, as well as in
\ from each side.
\
\ This routine does a similar job to the routine of the same name in the BBC
\ Master version of Elite, but the code is significantly different.
\
\ ******************************************************************************

.HANGER

                        \ We start by drawing the floor

 LDX #0                 \ We are going to work our way through the four lines in
                        \ the hangar floor, so

.hang1

 STX TGT                \ Store the line number in TGT so we can retrieve it
                        \ later

 LDA yHangarFloor,X     \ Set Y to the pixel y-coordinate of the line, from the
 TAY                    \ yHangarFloor table

 LDA #8                 \ Set A = 8 so the call to HAL3 draws a horizontal line
                        \ that starts at pixel x-coordinate 8 (i.e. just inside
                        \ the left box edge surrounding the view)

 LDX #28                \ Set X = 28 so the call to HAL3 draws a horizontal line
                        \ of up to 28 blocks (i.e. almost the full screen width)

 JSR HAL3               \ Call HAL3 to draw a line from the left edge of the
                        \ screen, going right until we bump into something
                        \ already on-screen, at which point it stops drawing

 LDA #240               \ Set A = 240 so the call to HAS3 draws a horizontal
                        \ line that starts at pixel x-coordinate 240 (i.e. just
                        \ inside the right box edge surrounding the view)

 LDX #28                \ Set X = 28 so the call to HAS3 draws a horizontal line
                        \ of up to 28 blocks (i.e. almost the full screen width)

 JSR HAS3               \ Draw a horizontal line from the right edge of the
                        \ screen, going left until we bump into something
                        \ already on-screen, at which point stop drawing

 LDA HANGFLAG           \ Fetch the value of HANGFLAG, which gets set to 0 in
                        \ the HALL routine above if there is only one ship

 BEQ hang2              \ If HANGFLAG is zero, jump to hang2 to skip the
                        \ following as there is only one ship in the hangar

                        \ If we get here then there are multiple ships in the
                        \ hangar, so we also need to draw the horizontal line in
                        \ the gap between the ships

 LDA #128               \ Set A = 128 so the call to HAL3 draws a horizontal
                        \ line that starts at pixel x-coordinate 128 (i.e.
                        \ from halfway across the screen)

 LDX #12                \ Set X = 12 so the call to HAL3 draws a horizontal line
                        \ of up to 12 blocks, which will be enough to draw
                        \ between the ships

 JSR HAL3               \ Call HAL3 to draw a line from the halfway point across
                        \ the right half of the screen, going right until we
                        \ bump into something already on-screen, at which point
                        \ it stops drawing

 LDA #127               \ Set A = 127 so the call to HAS3 draws a horizontal
                        \ line that starts at pixel x-coordinate 127 (i.e.
                        \ just before the halfway point)

 LDX #12                \ Set X = 12 so the call to HAL3 draws a horizontal line
                        \ of up to 12 blocks, which will be enough to draw
                        \ between the ships

 JSR HAS3               \ Draw a horizontal line from the right edge of the
                        \ screen, going left until we bump into something
                        \ already on-screen, at which point stop drawing

.hang2

                        \ We have finished threading our horizontal line behind
                        \ the ships already on-screen, so now for the next line

 LDX TGT                \ Set X to the number of the floor line we are drawing

 INX                    \ Increment X to move on to the next floor line

 CPX #4                 \ Loop back to hang1 to draw the next floor line until
 BNE hang1              \ we have drawn all four

                        \ The floor is done, so now we move on to the back wall

 JSR DORND              \ Set A to a random number between 0 and 7, with bit 2
 AND #7                 \ set, to give a random number in the range 4 to 7,
 ORA #4                 \ which we use as the x-coordinate of the first vertical
                        \ line in the hangar wall

 LDY #0                 \ Set Y = 0 so the call to DrawHangarWallLine starts
                        \ drawing the wall lines in the first tile of the screen
                        \ row, at the left edge of the screen

.hang3

 JSR DrawHangarWallLine \ Draw a vertical wall line at x-coordinate A

 CLC                    \ Add 10 to A
 ADC #10

 BCS hang4              \ If adding 10 made the addition overflow then we have
                        \ fallen off the right edge of the screen, so jump to
                        \ hang4 to return from the subroutine

 CMP #248               \ Loop back until we have drawn lines all the way to the
 BCC hang3              \ right edge of the screen, not going further than an
                        \ x-coordinate of 247

.hang4

 RTS                    \ Return from the subroutine

