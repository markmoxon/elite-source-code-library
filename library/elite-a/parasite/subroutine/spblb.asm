\ ******************************************************************************
\
\       Name: SPBLB
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Light up the space station indicator ("S") on the dashboard by
\             sending a draw_S command to the I/O processor
\
\ ******************************************************************************

.SPBLB

 LDA #&92               \ Send command &92 to the I/O processor:
 JMP tube_write         \
                        \   draw_S()
                        \
                        \ which will toggle the space station indicator ("S") on
                        \ the dashboard and return from the subroutine using a
                        \ tail call

