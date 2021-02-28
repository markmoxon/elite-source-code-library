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
\   Y                   The new colour of the missile indicator:
\
\                         * &00 = black (no missile)
\
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
\                         * &0E = red (armed and locked)
\
\                         * &E0 = yellow/white (armed)
\
\                         * &EE = green/cyan (disarmed)
ELIF _6502SP_VERSION
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

 LDX NOMSL              \ Call MSBAR to update the leftmost indicator in the
 JSR MSBAR              \ dashboard's missile bar, which returns with Y = 0

 STY MSAR               \ Set MSAR = 0 to indicate that the leftmost missile
                        \ is no longer seeking a target lock

 RTS                    \ Return from the subroutine

