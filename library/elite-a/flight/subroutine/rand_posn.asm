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
 STA &46
 STX &49
 STA &06
 LSR A
 ROR &48
 LSR A
 ROR &4B
 LSR A
 STA &4A
 TXA
 AND #&1F
 STA &47
 LDA #&50
 SBC &47
 SBC &4A
 STA &4D
 JMP DORND

