\ ******************************************************************************
\
\       Name: SESCP
\       Type: Subroutine
\   Category: Flight
\    Summary: Spawn an escape pod from the current (parent) ship
\
\ ------------------------------------------------------------------------------
\
\ This is called when an enemy ship has run out of both energy and luck, so it's
\ time to bail.
\
\ ******************************************************************************

.SESCP

 LDX #ESC               \ Set X to the ship type for an escape pod

 LDA #%11111110         \ Set A to an AI flag that has AI enabled, is hostile,
                        \ but has no E.C.M.

                        \ Fall through into SFS1 to spawn the escape pod

