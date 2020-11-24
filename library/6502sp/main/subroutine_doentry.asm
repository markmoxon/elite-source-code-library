\ ******************************************************************************
\       Name: DOENTRY
\ ******************************************************************************

.DOENTRY

 \after dock
 JSR RES2
 JSR LAUN
 STZ DELTA
 STZ QQ22+1 \<<
 STZ GNTMP
\++
 LDA #FF
 STA FSH
 STA ASH
 STA ENERGY
 JSR HALL
 LDY #44
 JSR DELAY
 LDA TP
 AND #3
 BNE EN1
 LDA TALLY+1
 BEQ EN4
 LDA GCNT
 LSR A
 BNE EN4
 JMP BRIEF

.EN1

 CMP #3
 BNE EN2
 JMP DEBRIEF

.EN2

 LDA GCNT
 CMP #2
 BNE EN4
 LDA TP
 AND #&F
 CMP #2
 BNE EN3
 LDA TALLY+1
 CMP #5
 BCC EN4
 JMP BRIEF2

.EN3

 CMP #6
 BNE EN5
 LDA QQ0
 CMP #215
 BNE EN4
 LDA QQ1
 CMP #84
 BNE EN4
 JMP BRIEF3

.EN5

 CMP #10
 BNE EN4
 LDA QQ0
 CMP #63
 BNE EN4
 LDA QQ1
 CMP #72
 BNE EN4
 JMP DEBRIEF2

.EN4

 JMP BAY

.BRKBK

 LDA #(BRBR MOD256)
 SEI
 STA BRKV
 LDA #(BRBR DIV256)
 STA BRKV+1
 CLI
 RTS

