\ ******************************************************************************
\
\       Name: PL44
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Return from a planet/sun-drawing routine with a success flag
\
\ ------------------------------------------------------------------------------
\
\ Clear the C flag and return from the subroutine. This is used to return from a
\ planet- or sun-drawing routine with the C flag indicating an overflow in the
\ calculation.
\
\ ******************************************************************************

.PL44

 CLC                    \ Clear the C flag to indicate success

 RTS                    \ Return from the subroutine

