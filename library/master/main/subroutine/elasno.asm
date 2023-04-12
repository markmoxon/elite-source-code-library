\ ******************************************************************************
\
\       Name: ELASNO
\       Type: Subroutine
\   Category: Sound
\    Summary: Make the sound of us being hit
\
\ ******************************************************************************

.ELASNO

 LDY #9                 \ Call the NOISE routine with Y = 9 to make the first
 JSR NOISE              \ sound of us being hit

 LDY #5                 \ Call the NOISE routine with Y = 5 to make the second
 BRA NOISE              \ sound of us being hit, returning from the subroutine
                        \ using a tail call

