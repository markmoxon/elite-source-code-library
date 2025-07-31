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

 LDA #%11111110         \ Set A to use as an AI flag that has AI enabled, an
                        \ aggression level of 63 out of 63, and no E.C.M.
                        \
                        \ When spawning an escape pod, this high agression level
                        \ makes the pod turn towards the planet rather than
                        \ towards us
                        \
                        \ This instruction is also used as an entry point to
                        \ spawn missile (when calling via the SFS1-2 entry
                        \ point), in which case the missile has AI (bit 7 set),
                        \ is hostile (bit 6 set) and has been launched (bit 0
                        \ clear); the target slot number is set to 31, but this
                        \ is ignored as the hostile flag means we are the target

                        \ Fall through into SFS1 to spawn the escape pod or
                        \ missile

