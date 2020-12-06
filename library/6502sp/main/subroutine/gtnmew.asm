\ ******************************************************************************
\       Name: GTNMEW
\ ******************************************************************************

.GTNMEW

\LDY#8\JSRDELAY

.GTNME

 LDX #4

.GTL3

 LDA NA%-5,X
 STA INWK,X
 DEX
 BPL GTL3
 LDA #7
 STA RLINE+2
 LDA #8
 JSR DETOK
 JSR MT26
 LDA #9
 STA RLINE+2
 TYA
 BEQ TR1
 RTS

