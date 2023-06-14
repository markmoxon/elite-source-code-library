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
IF _ELECTRON_VERSION \ Comment
\   * Update the sound channel's duration counter to ensure sounds are allocated
\     a minimum duration (unless they are stopped by a higher priority sound)
\
ENDIF
\ Other entry points:
\
\   M%                  The entry point for the main flight loop
\
\ ******************************************************************************

.M%

IF _NES_VERSION

 LDA QQ11
 BNE C853A
 JSR ChangeDrawingPhase

.C853A

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDA K%                 \ We want to seed the random number generator with a
                        \ pretty random number, so fetch the contents of K%,
                        \ which is the x_lo coordinate of the planet. This value
                        \ will be fairly unpredictable, so it's a pretty good
                        \ candidate

IF _NES_VERSION

 EOR nmiTimerLo         \ EOR the value of K% with the low byte of the NMI
                        \ timer, which gets updated by the NMI interrupt
                        \ routine, so this will be fairly unpredictable too

ENDIF

 STA RAND               \ Store the seed in the first byte of the four-byte
                        \ random number seed that's stored in RAND

IF _ELECTRON_VERSION \ Electron: Because the Electron only has two sound channels (one noise and one tone), each sound is allocated a minimum duration, during which time it can only be stopped by a higher priority sound coming along

                        \ The following processes each sound channel to ensure
                        \ that sounds last for their minimum duration (see the
                        \ SFX variable for more details)

 LDA #0                 \ Set A = 0 so we can use it for resetting the sound
                        \ channel's duration and priority values below

 LDX #1                 \ Set X as a sound channel counter, starting with
                        \ channel 1 and then doing channel 0

.SFXL

 DEC SFXDU,X            \ Decrement this sound channel's SFXDU duration value

 BPL P%+8               \ If the duration is still positive, skip the following
                        \ two instructions

 STA SFXDU,X            \ The duration just reached zero, so the sound on this
 STA SFXPR,X            \ channel has reached the end of its minimum duration,
                        \ so we zero the channel's SFXDU duration and SFXPR
                        \ priority values so any new sounds that need to be made
                        \ will be made regardless of priority

 DEX                    \ Decrement the sound channel

 BPL SFXL               \ Loop back to process the next sound channel until we
                        \ have done both

ENDIF

IF _MASTER_VERSION \ Comment

\LDA TRIBCT             \ These instructions are commented out in the original
\BEQ NOMVETR            \ source
\JMP MVTRIBS
\
\.NOMVETR

ENDIF

