\ ******************************************************************************
\
\       Name: missileNames_b6
\       Type: Variable
\   Category: Dashboard
\    Summary: Tile numbers for the four missile indicators on the dashboard, as
\             offsets from the start of tile row 22
\
\ ------------------------------------------------------------------------------
\
\ The active missile (i.e. the one that is armed and fired first) is the one
\ with the highest number, so missile 4 (top-left) will be armed before missile
\ 3 (top-right), and so on.
\
\ ******************************************************************************

.missileNames_b6

 EQUB 0                 \ Missile numbers are from 1 to 4, so this value is
                        \ never used

 EQUB 95                \ Missile 1 (bottom-right)

 EQUB 94                \ Missile 2 (bottom-left)

 EQUB 63                \ Missile 3 (top-right)

 EQUB 62                \ Missile 4 (top-left)

