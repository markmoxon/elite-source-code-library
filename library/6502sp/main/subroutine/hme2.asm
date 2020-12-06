\ ******************************************************************************
\       Name: HME2
\ ******************************************************************************

.HME2

 LDA #CYAN
 JSR DOCOL
 LDA #14
 JSR DETOK
 JSR TT103
 JSR TT81
 LDA #0
 STA XX20

.HME3

 JSR MT14
 JSR cpl
 LDX DTW5
 LDA INWK+5,X
 CMP #13
 BNE HME6

.HME4

 DEX
 LDA INWK+5,X
 ORA #32
 CMP BUF,X
 BEQ HME4
 TXA
 BMI HME5

.HME6

 JSR TT20
 INC XX20
 BNE HME3
 JSR TT111
 JSR TT103
 LDA #40
 JSR NOISE
 LDA #215
 JMP DETOK
\Not found

.HME5

 LDA QQ15+3
 STA QQ9
 LDA QQ15+1
 STA QQ10
 JSR TT111
 JSR TT103
 JSR MT15
 JMP T95

