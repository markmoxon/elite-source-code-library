\ ******************************************************************************
\       Name: BEGIN
\ ******************************************************************************

.BEGIN

\JSRBRKBK
 LDX #(CATF-COMC)
 LDA #0

.BEL1

 STA COMC,X
 DEX
 BPL BEL1
 LDA XX21+SST*2-2
 STA spasto
 LDA XX21+SST*2-1
 STA spasto+1

