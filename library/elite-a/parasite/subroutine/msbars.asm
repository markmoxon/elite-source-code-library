\ ******************************************************************************
\
\       Name: MSBARS
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw a specific indicator in the dashboard's missile bar
\
\ ------------------------------------------------------------------------------
\
\ This routine wraps the standard MSBAR routine and ensures that X is never
\ greater than 3. This enables ships to support large numbers of missiles, while
\ still only having four indicators on the dashboard.
\
\ Arguments:
\
\   X                   The number of the missile indicator to update (counting
\                       from right to left and starting at 0 rather than 1, so
\                       indicator NOMSL - 1 is the leftmost indicator)
\
\   Y                   The colour of the missile indicator:
\
\                         * &00 = black (no missile)
\
\                         * &0E = red (armed and locked)
\
\                         * &E0 = yellow/white (armed)
\
\                         * &EE = green/cyan (disarmed)
\
\ Returns:
\
\   X                   X is preserved
\
\   Y                   Y is set to 0
\
\ ******************************************************************************

.MSBARS

 CPX #4                 \ If X < 4 then jump to n_mok to skip the following
 BCC n_mok              \ instruction

 LDX #3                 \ Set X = 3 so X is never bigger than 3

.n_mok

 JMP MSBAR              \ Jump to MSBAR to draw the missile indicator

