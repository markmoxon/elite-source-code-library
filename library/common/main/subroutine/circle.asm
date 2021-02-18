\ ******************************************************************************
\
\       Name: CIRCLE
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Draw a circle for the planet
\  Deep dive: Drawing circles
\
\ ------------------------------------------------------------------------------
\
\ Draw a circle with the centre at (K3, K4) and radius K. Used to draw the
\ planet's main outline.
\
\ Arguments:
\
\   K                   The planet's radius
\
\   K3(1 0)             Pixel x-coordinate of the centre of the planet
\
\   K4(1 0)             Pixel y-coordinate of the centre of the planet
\
\ ******************************************************************************

.CIRCLE

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT

 JSR CHKON              \ Call CHKON to check whether the circle fits on-screen

 BCS RTS2               \ If CHKON set the C flag then the circle does not fit
                        \ on-screen, so return from the subroutine (as RTS2
                        \ contains an RTS)

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION

 LDA #0                 \ Set LSX2 = 0
 STA LSX2

ENDIF

 LDX K                  \ Set X = K = radius

 LDA #8                 \ Set A = 8

IF _CASSETTE_VERSION OR _DISC_VERSION

 CPX #8                 \ If the radius < 8, skip to PL89
 BCC PL89

ELIF _6502SP_VERSION

 CPX #4                 \ If the radius < 4, skip to PL89
 BCC PL89

ENDIF

 LSR A                  \ Halve A so A = 4

IF _CASSETTE_VERSION OR _DISC_VERSION

 CPX #60                \ If the radius < 60, skip to PL89
 BCC PL89

ELIF _6502SP_VERSION

 CPX #50                \ If the radius < 50, skip to PL89
 BCC PL89

ENDIF

 LSR A                  \ Halve A so A = 2

.PL89

 STA STP                \ Set STP = A. STP is the step size for the circle, so
                        \ the above sets a smaller step size for bigger circles

                        \ Fall through into CIRCLE2 to draw the circle with the
                        \ correct step size

