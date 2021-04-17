\ ******************************************************************************
\
\       Name: Main flight loop (Part 1 of 16)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Seed the random number generator
\  Deep dive: Program flow of the main game loop
\             Generating random numbers
\
\ ------------------------------------------------------------------------------
\
\ The main flight loop covers most of the flight-specific aspects of Elite. This
\ section covers the following:
\
\   * Seed the random number generator
\
\ Other entry points:
\
\   M%                  The entry point for the main flight loop
\
\ ******************************************************************************

.M%

 LDA K%                 \ We want to seed the random number generator with a
                        \ pretty random number, so fetch the contents of K%,
                        \ which is the x_lo coordinate of the planet. This value
                        \ will be fairly unpredictable, so it's a pretty good
                        \ candidate

 STA RAND               \ Store the seed in the first byte of the four-byte
                        \ random number seed that's stored in RAND

IF _ELECTRON_VERSION

 LDA #0                 \ ???
 LDX #1

.L0D49

 DEC L0BFD,X
 BPL L0D54

 STA L0BFD,X
 STA L0BFB,X

.L0D54

 DEX
 BPL L0D49

ENDIF

