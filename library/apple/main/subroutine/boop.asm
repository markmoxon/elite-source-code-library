
\ ******************************************************************************
\
\       Name: BOOP
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a long, low beep
\
\ ******************************************************************************

.BOOP

 LDY #99                \ Set the length of the loop below to 99 clicks, so we
                        \ make a total of 100 clicks in the call to SOBEEP, to
                        \ give a long beep

 LDX #255               \ Set the period of the sound at 255 for a low beep

 BNE SOBEEP             \ Jump to SOBEEP to make a long, low beep (this BNE is
                        \ effectively a JMP as X is never zero)

