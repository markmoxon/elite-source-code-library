\ ******************************************************************************
\
\       Name: DCS1
\       Type: Subroutine
\   Category: Flight
\    Summary: 
\
\ ******************************************************************************

.DCS1

 JSR P%+3
 LDA K%+NI%+10
 LDX #0
 JSR TAS7
 LDA K%+NI%+12
 LDX #3
 JSR TAS7
 LDA K%+NI%+14
 LDX #6

.TAS7

 ASL A
 STA R
 LDA #0
 ROR A
 EOR #128
 EOR K3+2,X
 BMI TS71
 LDA R
 ADC K3,X
 STA K3,X
 BCC TS72
 INC K3+1,X

.TS72

 RTS

.TS71

 LDA K3,X
 SEC
 SBC R
 STA K3,X
 LDA K3+1,X
 SBC #0
 STA K3+1,X
 BCS TS72
 LDA K3,X
 EOR #&FF
 ADC #1
 STA K3,X
 LDA K3+1,X
 EOR #&FF
 ADC #0
 STA K3+1,X
 LDA K3+2,X
 EOR #128
 STA K3+2,X
 JMP TS72

