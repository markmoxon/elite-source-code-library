\ ******************************************************************************
\
\       Name: Main flight loop (Part 16 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Process laser pulsing, E.C.M. energy drain, call stardust routine
\  Deep dive: Program flow of the main game loop
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Process laser pulsing
\
\   * Process E.C.M. energy drain
\
\   * Jump to the stardust routine if we are in a space view
\
\   * Return from the main flight loop
\
\ ******************************************************************************

.MA23

 LDA LAS2               \ If the current view has no laser, jump to MA16 to skip
 BEQ MA16               \ the following

IF NOT(_ELITE_A_6502SP_PARA)

 LDA LASCT              \ If LASCT >= 8, jump to MA16 to skip the following, so
 CMP #8                 \ for a pulse laser with a LASCT between 8 and 10, the
 BCS MA16               \ the laser stays on, but for a LASCT of 7 or less it
                        \ gets turned off and stays off until LASCT reaches zero
                        \ and the next pulse can start (if the fire button is
                        \ still being pressed)
ELIF _ELITE_A_6502SP_PARA

 JSR read_0346          \ Get the value of the I/O processor's copy of LASCT

 CMP #8                 \ If LASCT >= 8, jump to MA16 to skip the following, so
 BCS MA16               \ for a pulse laser with a LASCT between 8 and 10, the
                        \ the laser stays on, but for a LASCT of 7 or less it
                        \ gets turned off and stays off until LASCT reaches zero
                        \ and the next pulse can start (if the fire button is
                        \ still being pressed)

ENDIF
                        \
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
                        \ For pulse lasers, LASCT gets set to 10 in ma1 above,
                        \ and it decrements every vertical sync (50 times a
                        \ second), so this means it pulses five times a second,
                        \ with the laser being on for the first 3/10 of each
                        \ pulse and off for the rest of the pulse
ELIF _ELECTRON_VERSION
                        \ For pulse lasers, LASCT gets set to 10 in ma1 above,
                        \ and it decrements by 4 on every iteration of the main
                        \ game loop, so this means it pulses every fourth
                        \ iteration, with the laser being off for the first
                        \ three iterations, and on for the fourth iteration
ENDIF
                        \
                        \ If this is a beam laser, LASCT is 0 so we always keep
                        \ going here. This means the laser doesn't pulse, but it
                        \ does get drawn and removed every cycle, in a slightly
                        \ different place each time, so the beams still flicker
                        \ around the screen

 JSR LASLI2             \ Redraw the existing laser lines, which has the effect
                        \ of removing them from the screen

 LDA #0                 \ Set LAS2 to 0 so if this is a pulse laser, it will
 STA LAS2               \ skip over the above until the next pulse (this has no
                        \ effect if this is a beam laser)

.MA16

 LDA ECMP               \ If our E.C.M is not on, skip to MA69, otherwise keep
 BEQ MA69               \ going to drain some energy

 JSR DENGY              \ Call DENGY to deplete our energy banks by 1

 BEQ MA70               \ If we have no energy left, jump to MA70 to turn our
                        \ E.C.M. off

.MA69

 LDA ECMA               \ If an E.C.M is going off (our's or an opponent's) then
 BEQ MA66               \ keep going, otherwise skip to MA66

IF _MASTER_VERSION \ Master: The Master version has a unique E.C.M. sound

 LDY #soecm             \ Call the NOISE routine with Y = 7 to make the sound of
 JSR NOISE              \ the E.C.M.

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: In the Electron version, the E.C.M. timer counts down twice as fast as in the other versions to cater for the slower iterations round the main loop

 DEC ECMA               \ Decrement the E.C.M. countdown timer, and if it has
 BNE MA66               \ reached zero, keep going, otherwise skip to MA66

ELIF _ELECTRON_VERSION

 DEC ECMA               \ Decrement the E.C.M. countdown timer twice, and if it
 DEC ECMA               \ has reached zero, keep going, otherwise skip to MA66
 BNE MA66

ENDIF

.MA70

 JSR ECMOF              \ If we get here then either we have either run out of
                        \ energy, or the E.C.M. timer has run down, so switch
                        \ off the E.C.M.

.MA66

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Label

 LDA QQ11               \ If this is not a space view (i.e. QQ11 is non-zero)
 BNE MA9                \ then jump to MA9 to return from the main flight loop
                        \ (as MA9 is an RTS)

ELIF _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION

 LDA QQ11               \ If this is not a space view (i.e. QQ11 is non-zero)
 BNE oh                 \ then jump to oh to return from the main flight loop
                        \ (as oh is an RTS)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION \ Tube

 JMP STARS              \ This is a space view, so jump to the STARS routine to
                        \ process the stardust, and return from the main flight
                        \ loop using a tail call

ELIF _6502SP_VERSION

 JSR STARS              \ This is a space view, so call the STARS routine to
                        \ process the stardust

 JMP PBFL               \ And call PBFL to ask the I/O processor to draw the
                        \ dust particles, returning from the main flight loop
                        \ using a tail call

ENDIF

