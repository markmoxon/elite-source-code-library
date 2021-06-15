\ ******************************************************************************
\
\       Name: rand_posn
\       Type: Subroutine
\   Category: Universe
\    Summary: AJD
\
\ ******************************************************************************

.rand_posn

 JSR ZINF
 JSR DORND
 STA INWK
 STX INWK+3
 STA T1
 LSR A
 ROR INWK+2
 LSR A
 ROR INWK+5
 LSR A
 STA INWK+4
 TXA
 AND #&1F
 STA INWK+1
 LDA #&50
 SBC INWK+1
 SBC INWK+4
 STA INWK+7
 JMP DORND

