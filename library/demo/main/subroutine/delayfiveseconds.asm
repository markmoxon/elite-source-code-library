\ ******************************************************************************
\
\       Name: DelayFiveSeconds
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Wait for 5.1 seconds
\
\ ******************************************************************************

.DelayFiveSeconds

 LDY #255               \ Wait for 255/50 of a second (5.1 seconds) and return
 JMP DELAY              \ from the subroutine using a tail call

