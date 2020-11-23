\ ******************************************************************************
\       Name: DETOK2
\ ******************************************************************************

.DETOK2

 CMP #32
 BCC DT3
 BIT DTW3
 BPL DT8
 TAX
 TYA
 PHA
 LDA V
 PHA
 LDA V+1
 PHA
 TXA
 JSR TT27
 JMP DT7  \TT27

.DT8

 CMP #91
 BCC DTS
 CMP #129
 BCC DT6
 CMP #215
 BCC DETOK
 SBC #215
 ASL A
 PHA
 TAX
 LDA TKN2,X
 JSR DTS
 PLA
 TAX
 LDA TKN2+1,X  \letter pair

.DTS

 CMP #&41
 BCC DT9
 BIT DTW6
 BMI DT10
 BIT DTW2
 BMI DT5

.DT10

 ORA DTW1

.DT5

 AND DTW8

.DT9

 JMP DASC  \ascii

.DT3

 TAX
 TYA
 PHA
 LDA V
 PHA
 LDA V+1
 PHA  \Magic
 TXA
 ASL A
 TAX
 LDA JMTB-2,X
 STA DTM+1
 LDA JMTB-1,X
 STA DTM+2
 TXA
 LSR A

.DTM

 JSR DASC

.DT7

 PLA
 STA V+1
 PLA
 STA V
 PLA
 TAY
 RTS

.DT6

 STA SC
 TYA
 PHA
 LDA V
 PHA
 LDA V+1
 PHA
 JSR DORND
 TAX
 LDA #0
 CPX #51
 ADC #0
 CPX #102
 ADC #0
 CPX #153
 ADC #0
 CPX #204
 LDX SC
 ADC MTIN-91,X
 JSR DETOK
 JMP DT7  \Multitoken

