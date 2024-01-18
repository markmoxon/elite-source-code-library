\ ******************************************************************************
\
\       Name: ProjectScrollText
\       Type: Subroutine
\   Category: Combat demo
\    Summary: Project a scroll text coordinate onto the screen
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following:
\
\   (A X) = 128 + 256 * (A - 32) / Q
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The x-coordinate to project
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   RTS10               Contains an RTS
\
\ ******************************************************************************

.ProjectScrollText

 SEC                    \ Set A = A - 32
 SBC #32

 BCS proj1              \ If the subtraction didn't underflow then the result is
                        \ positive, so jump to proj1

 EOR #&FF               \ Negate A using two's complement, so A is positive
 ADC #1

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q

 LDA #128               \ Set (A X) = 128 - R
 SEC                    \
 SBC R                  \ Starting with the low bytes
 TAX

 LDA #0                 \ And then the high bytes
 SBC #0                 \
                        \ This gives us the result we want, as 128 + R is the
                        \ same as 128 - (-R)

 RTS                    \ Return from the subroutine

.proj1

 JSR LL28               \ Call LL28 to calculate:
                        \
                        \   R = 256 * A / Q

 LDA R                  \ Set (A X) = R + 128
 CLC                    \
 ADC #128               \ Starting with the low bytes
 TAX

 LDA #0                 \ And then the high bytes
 ADC #0

.RTS10

 RTS                    \ Return from the subroutine

