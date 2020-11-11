\ ******************************************************************************
\
\       Name: CHKON
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Check whether a circle will fit on-screen
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   K                   The circle's radius
\
\   K3(1 0)             Pixel x-coordinate of the centre of the circle
\
\   K4(1 0)             Pixel y-coordinate of the centre of the circle
\
\ Returns:
\
\   C flag              Clear if the circle fits on-screen, set if it doesn't
\
\   P(2 1)              Maximum y-coordinate of circle on-screen
\
\   (A X)               Minimum y-coordinate of circle on-screen
\
\ ******************************************************************************

.CHKON

 LDA K3                 \ Set A = K3 + K
 CLC
 ADC K

 LDA K3+1               \ Set A = K3+1 + 0 + any carry from above, so this
 ADC #0                 \ effectively sets A to the high byte of K3(1 0) + K:
                        \
                        \   (A ?) = K3(1 0) + K

 BMI PL21               \ If A has bit 7 set then we overflowed, so jump to
                        \ PL21 to set the C flag and return from the subroutine

 LDA K3                 \ Set A = K3 - K
 SEC
 SBC K

 LDA K3+1               \ Set A = K3+1 - 0 - any carry from above, so this
 SBC #0                 \ effectively sets A to the high byte of K3(1 0) - K:
                        \
                        \   (A ?) = K3(1 0) - K

 BMI PL31               \ If the result is negative then the result is good,
                        \ so skip to PL31 to continue on

 BNE PL21               \ The result underflowed, so jump to PL21 to set the C
                        \ flag and return from the subroutine

.PL31

 LDA K4                 \ Set P+1 = K4 + K
 CLC
 ADC K
 STA P+1

 LDA K4+1               \ Set A = K4+1 + 0 + any carry from above, so this
 ADC #0                 \ does the following:
                        \
                        \   (A P+1) = K4(1 0) + K

 BMI PL21               \ If A has bit 7 set then we overflowed, so jump to
                        \ PL21 to set the C flag and return from the subroutine

 STA P+2                \ Store the high byte in P+2, so now we have:
                        \
                        \   P(2 1) = K4(1 0) + K

 LDA K4                 \ Set X = K4 - K
 SEC
 SBC K
 TAX

 LDA K4+1               \ Set A = K4+1 - 0 - any carry from above, so this
 SBC #0                 \ does the following:
                        \
                        \   (A X) = K4(1 0) - K

 BMI PL44               \ If the result is negative then the result is good, so
                        \ jump to PL44 to clear the C flag and return from the
                        \ subroutine using a tail call

 BNE PL21               \ The result underflowed, so jump to PL21 to set the C
                        \ flag and return from the subroutine

 CPX #2*Y-1             \ The high byte of the result is zero, so check the low
                        \ byte against 2 * #Y - 1 and return the C flag
                        \ accordingly. The constant #Y is the y-coordinate of
                        \ the mid-point of the space view, so 2 * #Y - 1 is 191,
                        \ the y-coordinate of the bottom pixel row of the space
                        \ view. So this returns:
                        \
                        \   * C flag is set if coordinate (A X) is past the
                        \     bottom of the screen
                        \
                        \   * C flag is clear if coordinate (A X) is on-screen

 RTS                    \ Return from the subroutine

