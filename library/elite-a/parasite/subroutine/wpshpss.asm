\ ******************************************************************************
\
\       Name: WPSHPSS
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Clear the scanner, reset the ball line and sun line heaps
\
\ ------------------------------------------------------------------------------
\
\ This routine is a duplicate of WPSHPS that is close enough to the NWSTARS
\ routine for it to be called by a branch instruction.
\
\ ******************************************************************************

.WPSHPSS

 JMP WPSHPS             \ Jump to WPSHPS to clear the scanner and reset the ball
                        \ line and sun line heaps

