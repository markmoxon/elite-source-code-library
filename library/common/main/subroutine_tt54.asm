\ ******************************************************************************
\
\       Name: TT54
\       Type: Subroutine
\   Category: Universe
\    Summary: Twist the selected system's seeds
\  Deep dive: Twisting the system seeds
\
\ ------------------------------------------------------------------------------
\
\ This routine twists the three 16-bit seeds in QQ15 once.
\
\ ******************************************************************************

.TT54

 LDA QQ15               \ X = tmp_lo = w0_lo + w1_lo
 CLC
 ADC QQ15+2
 TAX

 LDA QQ15+1             \ Y = tmp_hi = w1_hi + w1_hi + C
 ADC QQ15+3
 TAY

 LDA QQ15+2             \ w0_lo = w1_lo
 STA QQ15

 LDA QQ15+3             \ w0_hi = w1_hi
 STA QQ15+1

 LDA QQ15+5             \ w1_hi = w2_hi
 STA QQ15+3

 LDA QQ15+4             \ w1_lo = w2_lo
 STA QQ15+2

 CLC                    \ w2_lo = X + w1_lo
 TXA
 ADC QQ15+2
 STA QQ15+4

 TYA                    \ w2_hi = Y + w1_hi + C
 ADC QQ15+3
 STA QQ15+5

 RTS                    \ The twist is complete so return from the subroutine

