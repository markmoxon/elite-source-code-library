\ ******************************************************************************
\
\       Name: UNWISE
\       Type: Subroutine
\   Category: Ship hangar
\    Summary: Switch the main line-drawing routine between EOR and OR logic by
\             sending a draw_mode command to the I/O processor
\
\ ******************************************************************************


.UNWISE

 LDA #&94               \ Send command &94 to the I/O processor:
 JMP tube_write         \
                        \   draw_mode()
                        \
                        \ which will toggle the line drawing mode between EOR
                        \ and OR, and return from the subroutine using a tail
                        \ call

