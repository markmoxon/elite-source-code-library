\ ******************************************************************************
\
\       Name: FixRandomNumbers
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Fix the random number seeds to a known value so the random numbers
\             generated are always the same when we run the demo
\
\ ******************************************************************************

.FixRandomNumbers

 LDA #&75               \ Set the random number seeds to a known state, so the
 STA RAND               \ demo plays out in the same way every time
 LDA #&0A
 STA RAND+1
 LDA #&2A
 STA RAND+2
 LDX #&E6
 STX RAND+3

 RTS                    \ Return from the subroutine

