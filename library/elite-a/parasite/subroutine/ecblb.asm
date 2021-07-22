\ ******************************************************************************
\
\       Name: ECBLB
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Light up the E.C.M. indicator bulb ("E") on the dashboard by
\             sending a draw_E command to the I/O processor
\
\ ******************************************************************************

.ECBLB

 LDA #&93               \ Send command &93 to the I/O processor:
 JMP tube_write         \
                        \   draw_E()
                        \
                        \ which will toggle the E.C.M. indicator bulb ("E") on
                        \ the dashboard and return from the subroutine using a
                        \ tail call

