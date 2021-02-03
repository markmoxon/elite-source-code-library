\ ******************************************************************************
\
\       Name: Elite loader (Part 3 of 4)
\       Type: Subroutine
\   Category: Loader
\    Summary: Pause for a surprisingly long time (7.67 seconds) so people can
\             enjoy the Acornsoft loading screen
\
\ ******************************************************************************

.ENTRY3

 LDA #129               \ Call OSBYTE with A = 129, X = &FF and Y = 2 to scan
 LDY #2                 \ the keyboard for &2FF centiseconds (7.67 seconds)
 LDX #&FF
 JSR OSBYTE

 LDA #15                \ Call OSBYTE with A = 129 and Y = 0 to flush the input
 LDY #0                 \ buffer
 JSR OSBYTE

 JMP ENTRY4             \ Jump to ENTRY4 to load and run the next part of the
                        \ loader

