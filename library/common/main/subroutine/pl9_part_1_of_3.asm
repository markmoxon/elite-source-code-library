\ ******************************************************************************
\
IF NOT(_APPLE_VERSION)
\       Name: PL9 (Part 1 of 3)
ELIF _APPLE_VERSION
\       Name: PL9
ENDIF
\       Type: Subroutine
\   Category: Drawing planets
IF NOT(_APPLE_VERSION)
\    Summary: Draw the planet, with either an equator and meridian, or a crater
ELIF _APPLE_VERSION
\    Summary: Draw the planet as a plain circle
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF NOT(_APPLE_VERSION)
\ Draw the planet with radius K at pixel coordinate (K3, K4), and with either an
\ equator and meridian, or a crater.
ELIF _APPLE_VERSION
\ Draw the planet with radius K at pixel coordinate (K3, K4).
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   K(1 0)              The planet's radius
\
\   K3(1 0)             Pixel x-coordinate of the centre of the planet
\
\   K4(1 0)             Pixel y-coordinate of the centre of the planet
\
\   INWK                The planet's ship data block
\
\ ******************************************************************************

.PL9

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Tube

 JSR WPLS2              \ Call WPLS2 to remove the planet from the screen

ELIF _6502SP_VERSION

 JSR LS2FL              \ Call LS2FL to send the ball line heap to the I/O
                        \ processor for drawing on-screen, which will erase the
                        \ planet from the screen

 STZ LSP                \ Reset the ball line heap by setting the ball line heap
                        \ pointer to 0

ENDIF

IF NOT(_APPLE_VERSION)

 JSR CIRCLE             \ Call CIRCLE to draw the planet's new circle

 BCS PL20               \ If the call to CIRCLE returned with the C flag set,
                        \ then the circle does not fit on-screen, so jump to
                        \ PL20 to return from the subroutine

 LDA K+1                \ If K+1 is zero, jump to PL25 as K(1 0) < 256, so the
 BEQ PL25               \ planet fits on the screen and we can draw meridians or
                        \ craters

.PL20

ELIF _APPLE_VERSION

 JMP CIRCLE             \ Call CIRCLE to draw the planet's new circle, returning
                        \ from the subroutine using a tail call

\BCS PL20               \ These instructions are commented out in the original
\                       \ source, as the Apple II version only has circles for
\LDA K+1                \ planets, with no meridians or craters
\BEQ PL25
\
\.PL20
\
\RTS

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Tube

 RTS                    \ The planet doesn't fit on-screen, so return from the
                        \ subroutine

ELIF _6502SP_VERSION

 JMP LS2FL              \ The planet doesn't fit on-screen, so jump to LS2FL to
                        \ send the ball line heap to the I/O processor for
                        \ drawing on-screen, returning from the subroutine using
                        \ a tail call

ENDIF

IF NOT(_APPLE_VERSION)

.PL25

ENDIF

IF _C64_VERSION

 LDA PLTOG              \ If PLTOG is zero then planetary details are not
 BEQ PL20               \ enabled, so jump to PL20 to return from the subroutine
                        \
                        \ In the original source the jump instruction is
                        \ accompanied by a comment "sob!", which perhaps shows
                        \ how sad the authors were to have to disable craters
                        \ and meridians by default on the Commodore 64

ENDIF

IF NOT(_APPLE_VERSION)

 LDA TYPE               \ If the planet type is 128 then it has an equator and
 CMP #128               \ a meridian, so this jumps to PL26 if this is not a
 BNE PL26               \ planet with an equator - in other words, if it is a
                        \ planet with a crater

                        \ Otherwise this is a planet with an equator and
                        \ meridian, so fall through into the following to draw
                        \ them

ENDIF

