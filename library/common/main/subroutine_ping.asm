\ ******************************************************************************
\
\       Name: ping
\       Type: Subroutine
\   Category: Universe
\    Summary: Set the selected system to the current system
\
\ ******************************************************************************

.ping

 LDX #1                 \ We want to copy the X- and Y-coordinates of the
                        \ current system in (QQ0, QQ1) to the selected system's
                        \ coordinates in (QQ9, QQ10), so set up a counter to
                        \ copy two bytes

.pl1

 LDA QQ0,X              \ Load byte X from the current system in QQ0/QQ1

 STA QQ9,X              \ Store byte X in the selected system in QQ9/QQ10

 DEX                    \ Decrement the loop counter

 BPL pl1                \ Loop back for the next byte to copy

 RTS                    \ Return from the subroutine

