\ ******************************************************************************
\
\       Name: BRIEF3
\       Type: Subroutine
\   Category: Missions
\    Summary: Receive the briefing and plans for mission 2
\
\ ******************************************************************************

.BRIEF3

 LDA TP                 \ Set bits 1 and 3 of TP to indicate that mission 1 is
 AND #%11110000         \ complete, and mission 2 is in progress and the plans
 ORA #%00001010         \ have been picked up
 STA TP

 LDA #222               \ Set A = 222 so the call to BRP prints extended token
                        \ 222 (the briefing for mission 2 where we pick up the
                        \ plans we need to take to Birera)

 BNE BRP                \ Jump to BRP to print the extended token in A and show
                        \ the Status Mode screen), returning from the subroutine
                        \ using a tail call (this BNE is effectively a JMP as A
                        \ is never zero)

