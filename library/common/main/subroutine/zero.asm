\ ******************************************************************************
\
\       Name: ZERO
\       Type: Subroutine
\   Category: Utility routines
IF _CASSETTE_VERSION OR _DISC_VERSION
\    Summary: Zero-fill pages &9, &A, &B, &C and &D
ELIF _6502SP_VERSION
\    Summary: Reset the local bubble of universe and ship status
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ This resets the following workspaces to zero:
\
IF _CASSETTE_VERSION OR _DISC_VERSION
\   * The ship data blocks ascending from K% at &0900
\
\   * The ship line heap descending from WP at &0D40
\
\   * WP workspace variables from FRIN to de, which include the ship slots for
\     the local bubble of universe, and various flight and ship status variables
\     (only a portion of the LSX/LSO sun line heap is cleared)
ELIF _6502SP_VERSION
\   * UP workspace variables from FRIN to de, which include the ship slots for
\     the local bubble of universe, and various flight and ship status variables
ENDIF
\
\ ******************************************************************************

.ZERO

IF _CASSETTE_VERSION

 LDX #&D                \ Point X to page &D

.ZEL

 JSR ZES1               \ Call ZES1 below to zero-fill the page in X

 DEX                    \ Decrement X to point to the next page

 CPX #9                 \ If X is > 9 (i.e. is &A, &B or &C), then loop back
 BNE ZEL                \ up to clear the next page

                        \ Then fall through into ZES1 with X set to 9, so we
                        \ clear page &9 too

ELIF _6502SP_VERSION OR _DISC_VERSION

 LDX #(de-FRIN)         \ We're going to zero the UP workspace variables from
                        \ FRIN to de, so set a counter in X for the correct
                        \ number of bytes

 LDA #0                 \ Set A = 0 so we can zero the variables

.ZEL2

 STA FRIN,X             \ Zero the X-th byte of FRIN to de

 DEX                    \ Decrement the loop counter

 BPL ZEL2               \ Loop back to zero the next variable until we have done
                        \ them all

 RTS                    \ Return from the subroutine

ENDIF

