\ ******************************************************************************
\
\       Name: FastForwardJump
\       Type: Subroutine
\   Category: Flight
\    Summary: Perform an in-system jump
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The status at the end of the jump:
\
\                         * Clear if the jump ends with us being far enough away
\                           from the planet or sun to do another jump
\
\                         * Set if the jump ends with us being too close to the
\                           planet or sun to do another jump
\
\ ******************************************************************************

.FastForwardJump

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 JSR InSystemJump       \ Call InSystemJump to do an in-system jump

                        \ Fall through into CheckJumpSafety to work out if we
                        \ are too close to the planet or sun to do another
                        \ in-system jump, returning the result in the C flag
                        \ accordingly

