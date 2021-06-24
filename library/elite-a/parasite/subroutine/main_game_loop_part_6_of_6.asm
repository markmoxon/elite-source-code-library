\ ******************************************************************************
\
\       Name: Main game loop for flight (Part 6 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: AJD
\
\ ******************************************************************************

.FRCE_FLIGHT

 PHA                \ Like main game loop 6
 LDA QQ22+1
 BNE d_locked
 PLA
 JSR TT102
 JMP d_3fc0

.d_locked

 PLA
 JSR d_416c
 JMP d_3fc0

