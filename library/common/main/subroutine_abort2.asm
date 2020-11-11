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
\   X                   The slot number of the ship in our missile lock, or &FF
\                       to remove missile lock
\
\   Y                   The new colour of the missile indicator:
\
\                         * &00 = black (no missile)
\
\                         * &0E = red (armed and locked)
\
\                         * &E0 = yellow/white (armed)
\
\                         * &EE = green/cyan (disarmed)
\
\ ******************************************************************************

.ABORT2

 STX MSTG               \ Store the target of our missile lock in MSTG

 LDX NOMSL              \ Update the leftmost indicator in the dashboard's
 JSR MSBAR              \ missile bar, returns with Y = 0

 STY MSAR               \ Set MSAR = 0 to indicate that the leftmost missile
                        \ is no longer seeking a target lock

 RTS                    \ Return from the subroutine

