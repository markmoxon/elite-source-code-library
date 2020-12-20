\ ******************************************************************************
\
\       Name: PAS1
\       Type: Subroutine
\   Category: Missions
\    Summary: 
\
\ ******************************************************************************

.PAS1

 LDA #112
 STA INWK+3

 LDA #0
 STA INWK

 STA INWK+6

 LDA #2
 STA INWK+7

 JSR LL9

 JSR MVEIT

 JMP RDKEY              \ Scan the keyboard for a key press and return the
                        \ internal key number in X (or 0 for no key press),
                        \ returning from the subroutine using a tail call

