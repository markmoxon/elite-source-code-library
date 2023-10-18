\ ******************************************************************************
\
\       Name: PlayDemo
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Play the combat demo
\
\ ******************************************************************************

.PlayDemo

 JSR RES2               \ Reset a number of flight variables and workspaces

 JSR ResetCommander_b6  \ Reset the current commander to the default "JAMESON"
                        \ commander

 LDA #0                 \ Set the fuel level to zero so we can't hyperspace out
 STA QQ14               \ of the demo

 STA CASH               \ Zero the two lowest bytes of the cash reserves so no
 STA CASH+1             \ missions are triggered

 LDA #&FF               \ Give our ship an E.C.M.
 STA ECM

 LDA #1                 \ Give our ship an energy unit
 STA ENGY

 LDA #POW+128           \ Give our ship a beam laser
 STA LASER

 LDA #&FF               \ Set demoInProgress = &FF to indicate that we are
 STA demoInProgress     \ playing the demo

 JSR SOLAR              \ Set up data blocks and slots for the planet and
                        \ sun

 LDA #0                 \ Set our ship's speed to zero
 STA DELTA

 STA ALPHA              \ Set ALPHA and ALP1 to 0, so our roll angle is 0
 STA ALP1

 STA QQ12               \ Set QQ12 = 0 to indicate that we are not docked

 STA VIEW               \ Set the space view to the front view

 JSR TT66               \ Clear the screen and set the view type in QQ11 to &00
                        \ (Space view with no fonts loaded)

 LSR demoInProgress     \ Clear bit 7 of demoInProgress

 JSR CopyNameBuffer0To1 \ Copy the contents of nametable buffer 0 to nametable
                        \ buffer and tell the NMI handler to send pattern
                        \ entries up to the first free tile

 JSR SetupFullViewInNMI \ Configure the PPU to send tiles for the full screen
                        \ during VBlank

 JSR SetupSpaceView     \ Set up the NMI variables for the space view

 JSR FixRandomNumbers   \ Fix the random number seeds to a known value so the
                        \ random numbers generated are always the same when we
                        \ run the demo

 JSR SetupDemoShip      \ Set up the ship workspace for a new ship that's to our
                        \ upper left and in front of us, pointing into the
                        \ screen

 LDA #6                 \ Set the ship's pitch counter to 6 to make it pitch
 STA INWK+30            \ slightly in a positive direction (pitch down), so it
                        \ starts diving gently towards the middle of the screen

 LDA #24                \ Set the ship's roll counter to 24 to make it roll in
 STA INWK+29            \ a positive direction (clockwise), for just under a
                        \ quarter roll (24 * 1/16 radians = 1.5 radians = 86
                        \ degrees)

 LDA #18                \ Call NWSHP with A = 18 to add a new Mamba ship to our
 JSR NWSHP              \ local bubble of universe

 LDA #10                \ Run ten iterations of the main flight loop so the
 JSR RunDemoFlightLoop  \ Mamba flies into the screen for a while

 LDA #&92               \ Set the ship's pitch counter to -18 to make it pitch
 STA K%+2*NIK%+30       \ slightly in a negative direction (pull up), so it
                        \ starts flying gently towards the top-left of the
                        \ screen
                        \
                        \ The ship will have been spawned in ship slot 2, so
                        \ this directly updates byte #30 in the ship's data
                        \ block in K%, where each data block is NIK% bytes long

 LDA #1                 \ Set the ship's acceleration to 1 to make it accelerate
 STA K%+2*NIK%+28       \ away from us
                        \
                        \ The ship will have been spawned in ship slot 2, so
                        \ this directly updates byte #28 in the ship's data
                        \ block in K%, where each data block is NIK% bytes long

 JSR SetupDemoShip      \ Set up the ship workspace for a new ship that's to our
                        \ upper left and in front of us, pointing into the
                        \ screen

 LDA #6                 \ Set the ship's pitch counter to 6 to make it pitch
 STA INWK+30            \ slightly in a positive direction (pitch down), so it
                        \ starts diving gently towards the middle of the screen

 ASL INWK+2             \ Flip the sign of x_sign so the ship is now to our
                        \ upper right and in front of us

 LDA #&C0               \ Set the ship's roll counter to -64 to make it roll in
 STA INWK+29            \ a negative direction (anti-clockwise), for two-thirds
                        \ of a roll (64 * 1/16 radians = 4.0 radians = 229
                        \ degrees)

 LDA #KRA               \ Call NWSHP to add a new Krait ship to our local bubble
 JSR NWSHP              \ of universe

 LDA #6                 \ Run six iterations of the main flight loop so the
 JSR RunDemoFlightLoop  \ Krait flies into the screen for a while and the Mamba
                        \ starts to pull away from the middle of the screen

 JSR SetupDemoShip      \ Set up the ship workspace for a new ship that's to our
                        \ upper left and in front of us, pointing into the
                        \ screen

 LDA #6                 \ Set the ship's pitch counter to 6 to make it pitch
 STA INWK+30            \ slightly in a positive direction (pitch down), so it
                        \ starts diving gently towards the middle of the screen

 ASL INWK+2             \ Flip the sign of x_sign so the ship is now to our
                        \ upper right and in front of us

 LDA #0                 \ Set x_lo = 0 so the ship is directly above us
 STA INWK

 LDA #70                \ Set z_lo = 70 so the ship starts out a little further
 STA INWK+6             \ in front than the others

 LDA #SH3               \ Call NWSHP to add a new Sidewinder ship to our local
 JSR NWSHP              \ bubble of universe

 LDA #5                 \ Run five iterations of the main flight loop
 JSR RunDemoFlightLoop  \ Sidewinder flies into the screen for a while

 LDA #&C0               \ Set the ship's pitch counter to -64 to make it pitch
 STA K%+4*NIK%+30       \ strongly in a negative direction (pull up), so it
                        \ starts flying towards the top-middle of the screen
                        \
                        \ The ship will have been spawned in ship slot 4, so
                        \ this directly updates byte #30 in the ship's data
                        \ block in K%, where each data block is NIK% bytes long

 LDA #11                \ Run 11 iterations of the main flight loop so all three
 JSR RunDemoFlightLoop  \ ships pull away from the centre of the screen

 LDA #50                \ Set the NMI timer so it starts counting down from 50,
 STA nmiTimer           \ so the (nmiTimerHi nmiTimerLo) will tick up to one
                        \ second after 50 VBlanks (which is one second on PAL
                        \ systems or 0.83 seconds on NTSC)

 LDA #0                 \ Set the NMI timer in (nmiTimerHi nmiTimerLo) to zero
 STA nmiTimerLo         \ so we can use it to count how long the combat demo
 STA nmiTimerHi         \ runs for (i.e. how long it takes for us to eliminate
                        \ all three ships)

 JSR SIGHT_b3           \ Draw the laser crosshairs

 LSR allowInSystemJump  \ Clear bit 7 of allowInSystemJump to allow in-system
                        \ jumps, so the call to UpdateIconBar displays the
                        \ fast-forward icon (though choosing this in the demo
                        \ doesn't do an in-system jump, but skips the rest of
                        \ the demo instead)

 JSR UpdateIconBar_b3   \ Update the icon bar to show the correct buttons for
                        \ the weapons we have given our ship (i.e. missiles and
                        \ E.C.M.)

 LDA tuneSpeedCopy      \ Set tuneSpeed = tuneSpeedCopy, to ensure that the
 STA tuneSpeed          \ music speed is set correctly for the current tune (so
                        \ this resets any speed-ups that have been applied,
                        \ such as in the combat demo)

 LDA #16                \ Set our ship's speed to 16, so we start the demo by
 STA DELTA              \ flying forwards

 JMP MLOOP              \ Jump to MLOOP to run the main game loop for the
                        \ duration of the combat demo
                        \
                        \ Part 15 of the main flight loop contains a check to
                        \ see whether the demo is enabled (which it is) and if
                        \ so, whether we have destroyed all three ships, in
                        \ which case it jumps to ShowScrollText with A = 1 to
                        \ show the scroll text with the results of combat
                        \ practice

