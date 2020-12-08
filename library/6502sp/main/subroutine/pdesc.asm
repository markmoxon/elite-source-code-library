\ ******************************************************************************
\       Name: PDESC
\ ******************************************************************************

.PDESC

\pink volcanoes string
 LDA QQ8
 ORA QQ8+1
 BNE PD1
 LDA QQ12
 BPL PD1
 LDY #NRU%

.PDL1

 LDA RUPLA-1,Y
 CMP ZZ
 BNE PD2
 LDA RUGAL-1,Y
 AND #127
 CMP GCNT
 BNE PD2
 LDA RUGAL-1,Y
 BMI PD3

 LDA TP                 \ Fetch bit 0 of TP into the C flag, and skip to PD1 if
 LSR A                  \ it is clear (i.e. if mission 1 is not in progress)
 BCC PD1

 JSR MT14               \ Mission 1 is in progress, so call MT14

 LDA #1
 EQUB &2C

.PD3

 LDA #176
 JSR DETOK2
 TYA
 JSR DETOK3
 LDA #177
 BNE PD4

.PD2

 DEY
 BNE PDL1

.PD1

 LDX #3

{
.PDL1

 LDA QQ15+2,X
 STA RAND,X
 DEX
 BPL PDL1 \set DORND seed
 LDA #5
}

.PD4

 JMP DETOK

