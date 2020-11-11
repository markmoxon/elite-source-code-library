\ ******************************************************************************
\       Name: BR1
\ ******************************************************************************

.BR1

 JSR ZEKTRAN
 LDA #3
 JSR DOXC
 LDX #3
 JSR FX200
 LDX #CYL
 LDA #6
 JSR TITLE
 CMP #&60
 BNE P%+5

.BRGO

 JMP DEMON
 CMP #&44
 BNE QU5
 JSR DFAULT
 JSR SVE

.QU5

 JSR DFAULT
 JSR msblob
 LDA #7
 LDX #ASP
 JSR TITLE
 JSR ping
\JSRhyp1 was here...
 JSR TT111
 JSR jmp
 LDX #5

.likeTT112

 LDA QQ15,X
 STA QQ2,X
 DEX
 BPL likeTT112
 INX
 STX EV
 LDA QQ3
 STA QQ28
 LDA QQ5
 STA tek
 LDA QQ4
 STA gov

