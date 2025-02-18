\ ******************************************************************************
\
\       Name: BEEP
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a short, high beep
\  Deep dive: Sound effects in Apple II Elite
\
\ ******************************************************************************

.BEEP

 LDY #30                \ Set the length of the loop below to 30 clicks, so we
                        \ make a total of 31 clicks in the following

 LDX #110               \ Set the period of the sound at 110 for a high beep

                        \ Fall through into SOBEEP to make a short, high beep

