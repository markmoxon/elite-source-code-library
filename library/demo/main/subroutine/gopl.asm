\ ******************************************************************************
\
\       Name: GOPL
\       Type: Subroutine
\   Category: Demo
\    Summary: Make the ship head towards the planet
\
\ ------------------------------------------------------------------------------
\
\ The code in this routine has been copied from part 3 of the TACTICS routine in
\ the disc version of Elite.
\
\ ******************************************************************************

.GOPL

 JSR SPS1               \ The ship is not hostile and it is not docking, so call
                        \ SPS1 to calculate the vector to the planet and store
                        \ it in XX15

 JMP TA151              \ Jump to TA151 to make the ship head towards the planet

