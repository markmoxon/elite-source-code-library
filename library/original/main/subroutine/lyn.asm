\ ******************************************************************************
\
\       Name: LYN
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear most of a row of pixels
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\ Set pixels 0-233 to the value in A, starting at the pixel pointed to by SC.
\
\ Arguments:
\
\   A                   The value to store in pixels 1-233 (the only value that
\                       is actually used is A = 0, which clears those pixels)
\
\ Returns:
\
\   Y                   Y is set to 0
\
\ Other entry points:
\
\   SC5                 Contains an RTS
\
ELIF _ELECTRON_VERSION
\ Zero memory from page X to page &75 (inclusive).
\
\ Arguments:
\
\   X                   The page of screen memory from which to start clearing
\
ENDIF
\ ******************************************************************************

.LYN

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Platform

 LDY #233               \ Set up a counter in Y to count down from pixel 233

.EE2

 STA (SC),Y             \ Store A in the Y-th byte after the address pointed to
                        \ by SC

 DEY                    \ Decrement Y

 BNE EE2                \ Loop back until Y is zero

.SC5

ELIF _ELECTRON_VERSION

 JSR ZES1               \ Call ZES1 to zero-fill the page in X

 INX                    \ Increment X to point to the next page in memory

 CPX #&76               \ Loop back to zero the next page until we have reached
 BNE LYN                \ page &76 (so page &75 is the last page to be zeroed)

ENDIF

 RTS                    \ Return from the subroutine

