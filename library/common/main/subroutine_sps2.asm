\ ******************************************************************************
\
\       Name: SPS2
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (Y X) = A / 10
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following, where A is a signed 8-bit integer and the result is a
\ signed 16-bit integer:
\
\   (Y X) = A / 10
\
\ Returns:
\
\   C flag              The C flag is cleared
\
\ ******************************************************************************

.SPS2

 ASL A                  \ Set X = |A| * 2, and set the C flag to the sign bit of
 TAX                    \ A

 LDA #0                 \ Set Y to have the sign bit from A in bit 7, with the
 ROR A                  \ rest of its bits zeroed, so Y now contains the sign of
 TAY                    \ the original argument

 LDA #20                \ Set Q = 20
 STA Q

 TXA                    \ Copy X into A, so A now contains the argument A * 2

 JSR DVID4              \ Calculate the following:
                        \
                        \   P = A / Q
                        \     = |argument A| * 2 / 20
                        \     = |argument A| / 10

 LDX P                  \ Set X to the result

 TYA                    \ If the sign of the original argument A is negative,
 BMI LL163              \ jump to LL163 to flip the sign of the result

 LDY #0                 \ Set the high byte of the result to 0, as the result is
                        \ positive

 RTS                    \ Return from the subroutine

.LL163

 LDY #&FF               \ The result is negative, so set the high byte to &FF

 TXA                    \ Flip the low byte and add 1 to get the negated low
 EOR #&FF               \ byte, using two's complement
 TAX
 INX

 RTS                    \ Return from the subroutine

