\ ******************************************************************************
\
\       Name: LL9_FLIGHT
\       Type: Subroutine
\   Category: Drawing ships
\    Summary: Draw a ship (flight version)
\
\ ******************************************************************************

.LL25

 JMP PLANET             \ Jump to the PLANET routine, returning from the
                        \ subroutine using a tail call

.LL9_FLIGHT

 LDA TYPE               \ If the ship type is negative then this indicates a
 BMI LL25               \ planet or sun, so jump to PLANET via LL25 above

 JMP LL9                \ Jump to LL9 to draw the ship

