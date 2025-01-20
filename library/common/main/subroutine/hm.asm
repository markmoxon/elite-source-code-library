\ ******************************************************************************
\
\       Name: hm
\       Type: Subroutine
\   Category: Charts
\    Summary: Select the closest system and redraw the chart crosshairs
\
\ ------------------------------------------------------------------------------
\
IF NOT(_APPLE_VERSION)
\ Set the system closest to galactic coordinates (QQ9, QQ10) as the selected
\ system, redraw the crosshairs on the chart accordingly (if they are being
\ shown), and if this is not the space view, clear the bottom three text rows of
\ the screen.
ELIF _APPLE_VERSION
\ Set the system closest to galactic coordinates (QQ9, QQ10) as the selected
\ system, redraw the crosshairs on the chart accordingly (if they are being
\ shown), and clear two text rows at the bottom of the screen.
ENDIF
\
\ ******************************************************************************

.hm

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will erase the crosshairs currently there

 JSR TT111              \ Select the system closest to galactic coordinates
                        \ (QQ9, QQ10)

 JSR TT103              \ Draw small crosshairs at coordinates (QQ9, QQ10),
                        \ which will draw the crosshairs at our current home
                        \ system

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Platform

 LDA QQ11               \ If this is a space view, return from the subroutine
 BEQ SC5                \ (as SC5 contains an RTS)

                        \ Otherwise fall through into CLYNS to clear space at
                        \ the bottom of the screen

ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION

 JMP CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ move the text cursor to the first cleared row, and
                        \ return from the subroutine using a tail call

ELIF _APPLE_VERSION

 JMP CLYNS              \ Clear two text rows at the bottom of the screen, move
                        \ the text cursor to the cleared row, and return from
                        \ the subroutine using a tail call

ENDIF

