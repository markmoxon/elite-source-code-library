\ ******************************************************************************
\
\       Name: PL21S
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Return from a planet/sun-drawing routine with a failure flag
\
\ ------------------------------------------------------------------------------
\
\ This routine is a duplicate of PL21 that is close enough to the PLS6 routine
\ for it to be called by a branch instruction.
\
\ Set the C flag and return from the subroutine. This is used to return from a
\ planet- or sun-drawing routine with the C flag indicating an overflow in the
\ calculation.
\
\ ******************************************************************************

.PL21S

 SEC                    \ Set the C flag to indicate an overflow

 RTS                    \ Return from the subroutine

