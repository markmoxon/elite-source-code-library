\ ******************************************************************************
\
\       Name: ABORT
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Disarm missiles and update the dashboard indicators
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Comment
\   Y                   The new colour of the missile indicator:
\
\                         * &00 = black (no missile)
\
\                         * &0E = red (armed and locked)
\
\                         * &E0 = yellow/white (armed)
\
\                         * &EE = green/cyan (disarmed)
ELIF _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION
\   Y                   The new colour of the missile indicator:
\
\                         * &00 = black (no missile)
\
\                         * #RED2 = red (armed and locked)
\
\                         * #YELLOW2 = yellow/white (armed)
\
\                         * #GREEN2 = green (disarmed)
ELIF _APPLE_VERSION
\   Y                   The new colour of the missile indicator:
\
\                         * #BLACK = black (no missile)
\
\                         * #RED = red (armed and locked)
\
\                         * #WHITE = white (armed)
\
\                         * #GREEN = green (disarmed)
ELIF _NES_VERSION
\   Y                   The pattern number for the new missile indicator:
\
\                         * 133 = no missile indicator
\
\                         * 109 = red (armed and locked)
\
\                         * 108 = black (disarmed)
\
\                       The armed missile flashes black and red, so the tile is
\                       swapped between 108 and 109 in the main loop
ENDIF
\
IF _ELECTRON_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   ABORT-2             Set the indicator to disarmed (white square)
\
ENDIF
\ ******************************************************************************

IF _ELECTRON_VERSION \ Platform

 LDY #&09               \ Set Y = &09 so we set the missile to a white square
                        \ (disarmed)

ENDIF

.ABORT

IF NOT(_NES_VERSION)

 LDX #&FF               \ Set X to &FF, which is the value of MSTG when we have
                        \ no target lock for our missile

ELIF _NES_VERSION

 LDX #0                 \ Set MSAR = 0 to indicate that the leftmost missile
 STX MSAR               \ is no longer seeking a target lock

 DEX                    \ Set X to &FF, which is the value of MSTG when we have
                        \ no target lock for our missile

ENDIF

                        \ Fall through into ABORT2 to set the missile lock to
                        \ the value in X, which effectively disarms the missile

