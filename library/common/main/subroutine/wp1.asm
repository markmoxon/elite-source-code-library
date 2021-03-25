\ ******************************************************************************
\
\       Name: WP1
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Reset the ball line heap
\
\ ******************************************************************************

.WP1

 LDA #1                 \ Set LSP = 1 to reset the ball line heap pointer
 STA LSP

 LDA #&FF               \ Set LSX2 = &FF to indicate the ball line heap is empty
 STA LSX2

 RTS                    \ Return from the subroutine

