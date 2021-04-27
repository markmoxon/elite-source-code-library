\ ******************************************************************************
\
\       Name: PL21
\       Type: Subroutine
\   Category: Drawing planets
IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Return from a planet/sun-drawing routine with a failure flag
ELIF _ELECTRON_VERSION
\    Summary: Return from a planet-drawing routine with a failure flag
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\ Set the C flag and return from the subroutine. This is used to return from a
\ planet- or sun-drawing routine with the C flag indicating an overflow in the
\ calculation.
ELIF _ELECTRON_VERSION
\ Set the C flag and return from the subroutine. This is used to return from a
\ planet-drawing routine with the C flag indicating an overflow in the
\ calculation.
ENDIF
\
\ ******************************************************************************

.PL21

 SEC                    \ Set the C flag to indicate an overflow

 RTS                    \ Return from the subroutine

