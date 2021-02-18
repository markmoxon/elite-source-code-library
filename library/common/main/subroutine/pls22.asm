\ ******************************************************************************
\
\       Name: PLS22
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Draw a circle or half-circle
\  Deep dive: The sine, cosine and arctan tables
\
\ ------------------------------------------------------------------------------
\
\ Draw a circle or half-circle, used for the planet's equator and meridian, or
\ crater.
\
\ This routine is called from parts 2 and 3 of PL9, and does the following:
\
\   K6(1 0) = K3(1 0) + (XX16 K2) * cos(CNT2) + (XX16+2 K2+2) * sin(CNT2)
\
\   (T X) = - |XX16+1 K2+1| * cos(CNT2) - |XX16+3 K2+3| * sin(CNT2)
\
\ before calling BLINE to draw a circle segment to these coordinates.
\
\ Arguments:
\
\   K(1 0)              The planet's radius
\
\   INWK                The planet's ship data block
\
\   TGT                 The number of segments to draw:
\
\                         * 32 for a half circle (a meridian)
\
\                         * 64 for a half circle (a crater)
\
\   CNT2                The starting segment for drawing the half-circle
\
\ ******************************************************************************

.PLS22

 LDX #0                 \ Set CNT = 0
 STX CNT

 DEX                    \ Set FLAG = &FF to reset the ball line heap in the call
 STX FLAG               \ to the BLINE routine below

.PLL4

 LDA CNT2               \ Set A = CNT2 mod 32
 AND #31
 TAX

 LDA SNE,X              \ Set Q = sin(CNT2)
 STA Q

 LDA K2+2               \ Set A = K2+2
                        \       = |roofv_x / z|

 JSR FMLTU              \ Set R = A * Q / 256
 STA R                  \       = |roofv_x / z| * sin(CNT2) / 256

 LDA K2+3               \ Set A = K2+2
                        \       = |roofv_y / z|

 JSR FMLTU              \ Set K = A * Q / 256
 STA K                  \       = |roofv_y / z| * sin(CNT2) / 256

 LDX CNT2               \ If CNT2 >= 33 then this sets the C flag, otherwise
 CPX #33                \ it's clear

 LDA #0                 \ Shift the C flag into the sign bit of XX16+5, so:
 ROR A                  \
 STA XX16+5             \   XX16+5 = +ve if CNT2 < 33
                        \            -ve if CNT2 >= 33

 LDA CNT2               \ Set A = (CNT2 + 16) mod 32
 CLC
 ADC #16
 AND #31
 TAX

 LDA SNE,X              \ Set Q = sin(CNT2 + 16)
 STA Q                  \       = cos(CNT2)

 LDA K2+1               \ Set A = K2+1
                        \       = |nosev_y / z|

 JSR FMLTU              \ Set K+2 = A * Q / 256
 STA K+2                \         = |nosev_y / z| * cos(CNT2) / 256

 LDA K2                 \ Set A = K2
                        \       = |nosev_x / z|

 JSR FMLTU              \ Set P = A * Q / 256
 STA P                  \       = |nosev_x / z| * cos(CNT2) / 256

 LDA CNT2               \ If (CNT2 + 15) mod 64 >= 33 then this sets the C flag,
 ADC #15                \ otherwise it's clear
 AND #63
 CMP #33

 LDA #0                 \ Shift the C flag into the sign bit of XX16+4, so:
 ROR A                  \
 STA XX16+4             \   XX16+4 = +ve if (CNT2 + 15) mod 64 < 33,
                        \            -ve if (CNT2 + 15) mod 64 >= 33

 LDA XX16+5             \ Set S = the sign of (roofv_x / z * CNT2 < 33 sign)
 EOR XX16+2
 STA S

 LDA XX16+4             \ Set A = the sign of (nosev_x / z * CNT2 + 15 < 33
 EOR XX16               \ sign)

 JSR ADD                \ Set (A X) = (A P) + (S R)
                        \           =   (nosev_x / z) * cos(CNT2)
                        \             + (roofv_x / z) * sin(CNT2)

 STA T                  \ Store the high byte in T, so the result is now:
                        \
                        \   (T X) =  (nosev_x / z) * cos(CNT2)
                        \           + (roofv_x / z) * sin(CNT2)

 BPL PL42               \ If the result is positive, jump down to PL42

 TXA                    \ The result is negative, so we need to negate the
 EOR #%11111111         \ magnitude using two's complement, first doing the low
 CLC                    \ byte in X
 ADC #1
 TAX

 LDA T                  \ And then the high byte in T, making sure to leave the
 EOR #%01111111         \ sign bit alone
 ADC #0
 STA T

.PL42

 TXA                    \ Set K6(1 0) = K3(1 0) + (T X)
 ADC K3                 \
 STA K6                 \ starting with the low bytes

 LDA T                  \ And then doing the high bytes, so we now get:
 ADC K3+1               \
 STA K6+1               \  K6(1 0) = K3(1 0) + (nosev_x / z) * cos(CNT2)
                        \           + (roofv_x / z) * sin(CNT2)

 LDA K                  \ Set R = K = |roofv_y / z| * sin(CNT2) / 256
 STA R

 LDA XX16+5             \ Set S = the sign of (roofv_y / z * CNT2 < 33 sign)
 EOR XX16+3
 STA S

 LDA K+2                \ Set P = K+2 = |nosev_y / z| * cos(CNT2) / 256
 STA P

 LDA XX16+4             \ Set A = the sign of (nosev_y / z * CNT2 + 15 < 33
 EOR XX16+1             \ sign)

 JSR ADD                \ Set (A X) = (A P) + (S R)
                        \           =   |nosev_y / z| * cos(CNT2)
                        \             + |roofv_y / z| * sin(CNT2)

 EOR #%10000000         \ Store the negated high byte in T, so the result is
 STA T                  \ now:
                        \
                        \   (T X) = - |nosev_y / z| * cos(CNT2)
                        \           - |roofv_y / z| * sin(CNT2)

 BPL PL43               \ If the result is positive, jump down to PL43

 TXA                    \ The result is negative, so we need to negate the
 EOR #%11111111         \ magnitude using two's complement, first doing the low
 CLC                    \ byte in X
 ADC #1
 TAX

 LDA T                  \ And then the high byte in T, making sure to leave the
 EOR #%01111111         \ sign bit alone
 ADC #0
 STA T

.PL43

 JSR BLINE              \ Call BLINE to draw this segment, which also returns
                        \ the updated value of CNT in A

 CMP TGT                \ If CNT > TGT then jump to PL40 to stop drawing the
 BEQ P%+4               \ circle (which is how we draw half-circles)
 BCS PL40

 LDA CNT2               \ Set CNT2 = (CNT2 + STP) mod 64
 CLC
 ADC STP
 AND #63
 STA CNT2

 JMP PLL4               \ Jump back to PLL4 to draw the next segment

.PL40

 RTS                    \ Return from the subroutine

