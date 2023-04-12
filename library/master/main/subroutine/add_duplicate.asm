\ ******************************************************************************
\
\       Name: ADDK
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (A X) = (A P) + (S R)
\
\ ******************************************************************************

.ADDK

 STA T1                 \ This is an exact duplicate of the ADD routine, which
 AND #%10000000         \ is also present in this source, so it isn't clear why
 STA T                  \ this duplicate exists
 EOR S                  \
 BMI MU8K               \ See the ADD routine for an explanation of the code
 LDA R
 CLC
 ADC P
 TAX
 LDA S
 ADC T1
 ORA T
 RTS

.MU8K

 LDA S
 AND #%01111111
 STA U
 LDA P
 SEC
 SBC R
 TAX
 LDA T1
 AND #%01111111
 SBC U
 BCS MU9K
 STA U
 TXA
 EOR #&FF
 ADC #1
 TAX
 LDA #0
 SBC U
 ORA #%10000000

.MU9K

 EOR T
 RTS

