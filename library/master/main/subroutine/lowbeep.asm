\ ******************************************************************************
\
\       Name: LOWBEEP
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a long, low beep
\
\ ******************************************************************************

.LOWBEEP

 LDY #0                 \ Call the NOISE routine with Y = 0 to make a long, low
 BRA NOISE              \ beep, returning from the subroutine using a tail call

