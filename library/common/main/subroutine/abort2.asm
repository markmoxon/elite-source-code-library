\ ******************************************************************************
\
\       Name: ABORT2
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Set/unset the lock target for a missile and update the dashboard
\
\ ------------------------------------------------------------------------------
\
\ Set the lock target for the leftmost missile and update the dashboard.
\
\ Arguments:
\
\   X                   The slot number of the ship to lock our missile onto, or
\                       &FF to remove missile lock
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
ELIF _ELECTRON_VERSION
\   Y                   The new shape of the missile indicator:
\
\                         * &04 = black (no missile)
\
\                         * &11 = black "T" in white square (armed and locked)
\
\                         * &0D = black box in white square (armed)
\
\                         * &09 = white square (disarmed)
ELIF _6502SP_VERSION OR _MASTER_VERSION
\   Y                   The new colour of the missile indicator:
\
\                         * &00 = black (no missile)
\
\                         * #RED2 = red (armed and locked)
\
\                         * #YELLOW2 = yellow/white (armed)
\
\                         * #GREEN2 = green (disarmed)
ENDIF
\
\ ******************************************************************************

.ABORT2

 STX MSTG               \ Store the target of our missile lock in MSTG

IF NOT(_ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA)

 LDX NOMSL              \ Call MSBAR to update the leftmost indicator in the
 JSR MSBAR              \ dashboard's missile bar, which returns with Y = 0

ELIF _ELITE_A_FLIGHT

 LDX NOMSL              \ AJD
 DEX
 JSR MSBAR

ELIF _ELITE_A_6502SP_PARA

 LDX NOMSL              \ AJD
 DEX
 JSR MSBAR_FLIGHT

ENDIF

 STY MSAR               \ Set MSAR = 0 to indicate that the leftmost missile
                        \ is no longer seeking a target lock

 RTS                    \ Return from the subroutine

