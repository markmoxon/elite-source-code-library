\ ******************************************************************************
\
\       Name: SP1
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw the space station on the compass
\
\ ******************************************************************************

.SP1

 JSR SPS4               \ Call SPS4 to calculate the vector to the space station
                        \ and store it in XX15

                        \ Fall through into SP2 to draw XX15 on the compass

