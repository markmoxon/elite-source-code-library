\ ******************************************************************************
\
\       Name: ADD_DUPLICATE
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (A X) = (A P) + (S R)
\
\ ******************************************************************************

.ADD_DUPLICATE
{
 STA T1                 \ This is an exact duplicate of the ADD routine, which
 AND #%10000000         \ is also present in this source, so it isn't clear why
 STA T                  \ this duplicate exists (it is surrounded by braces as
 EOR S                  \ BeebAsm doesn't allow us to redefine labels, unlike
 BMI MU8                \ BBC BASIC). See the ADD routine for an explanation
 LDA R                  \ of the code
 CLC
 ADC P
 TAX
 LDA S
 ADC T1
 ORA T
 RTS

.MU8

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
 BCS MU9
 STA U
 TXA
 EOR #&FF
 ADC #1
 TAX
 LDA #0
 SBC U
 ORA #%10000000

.MU9

 EOR T
 RTS
}

