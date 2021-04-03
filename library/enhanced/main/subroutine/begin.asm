\ ******************************************************************************
\
\       Name: BEGIN
\       Type: Subroutine
\   Category: Loader
\    Summary: Initialise the configuration variables and start the game
\
\ ******************************************************************************

.BEGIN

IF _DISC_DOCKED \ Platform

 JSR BRKBK              \ Call BRKBK to set BRKV to point to the BRBR routine

ELIF _6502SP_VERSION

\JSR BRKBK              \ This instruction is commented out in the original
                        \ source

ENDIF

IF _DISC_DOCKED OR _6502SP_VERSION


 LDX #(CATF-COMC)       \ We start by zeroing all the configuration variables
                        \ between COMC and CATF, to set them to their default
                        \ values, so set a counter in X for CATF - COMC bytes

ELIF _MASTER_VERSION

 LDX #(DTAPE-COMC)      \ We start by zeroing all the configuration variables
                        \ between COMC and DTAPE, to set them to their default
                        \ values, so set a counter in X for DTAPE - COMC bytes


ENDIF

 LDA #0                 \ Set A = 0 so we can zero the variables

.BEL1

 STA COMC,X             \ Zero the X-th configuration variable

 DEX                    \ Decrement the loop counter

 BPL BEL1               \ Loop back to BEL1 to zero the next byte, until we have
                        \ zeroed them all

IF _6502SP_VERSION OR _MASTER_VERSION \ Platform

 LDA XX21+SST*2-2       \ Set spasto(1 0) to the Coriolis space station entry
 STA spasto             \ from the ship blueprint lookup table at XX21 (so
 LDA XX21+SST*2-1       \ spasto(1 0) points to the Coriolis blueprint)
 STA spasto+1

ENDIF

IF _MASTER_VERSION

 JSR JAMESON            \ Call JAMESON to set the last saved commander to the
                        \ default "JAMESON" commander

ENDIF

                        \ Fall through into TT170 to start the game
