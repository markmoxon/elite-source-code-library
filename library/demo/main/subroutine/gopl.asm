\ ******************************************************************************
\
\       Name: GOPL
\       Type: Subroutine
\   Category: Demo
\    Summary: ???
\
\ ******************************************************************************

.GOPL

                        \ From TACTICS (Part 3 of 7) in disc

 JSR SPS1               \ The ship is not hostile and it is not docking, so call
                        \ SPS1 to calculate the vector to the planet and store
                        \ it in XX15

 JMP TA151              \ Jump to TA151 to make the ship head towards the planet

