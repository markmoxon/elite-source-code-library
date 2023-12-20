\ ******************************************************************************
\
\       Name: PLS3
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Calculate (Y A P) = 222 * roofv_x / z
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following, with X determining the vector to use:
\
\   (Y A P) = 222 * roofv_x / z
\
\ though in reality only (Y A) is used.
\
\ Although the code below supports a range of values of X, in practice the
\ routine is only called with X = 15, and then again after X has been
\ incremented to 17. So the values calculated by PLS1 use roofv_x first, then
\ roofv_y. The comments below refer to roofv_x, for the first call.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   Determines which of the INWK orientation vectors to
\                       divide:
\
\                         * X = 15: divides roofv_x
\
\                         * X = 17: divides roofv_y
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X gets incremented by 2 so it points to the next
\                       coordinate in this orientation vector (so consecutive
\                       calls to the routine will start with x, then move onto y
\                       and then z)
\
\ ******************************************************************************

.PLS3

 JSR PLS1               \ Call PLS1 to calculate the following:
 STA P                  \
                        \   P = |roofv_x / z|
                        \   K+3 = sign of roofv_x / z
                        \
                        \ and increment X to point to roofv_y for the next call

 LDA #222               \ Set Q = 222, the offset to the crater
 STA Q

 STX U                  \ Store the vector index X in U for retrieval after the
                        \ call to MULTU

 JSR MULTU              \ Call MULTU to calculate
                        \
                        \   (A P) = P * Q
                        \         = 222 * |roofv_x / z|

 LDX U                  \ Restore the vector index from U into X

 LDY K+3                \ If the sign of the result in K+3 is positive, skip to
 BPL PL12               \ PL12 to return with Y = 0

 EOR #&FF               \ Otherwise the result should be negative, so negate the
 CLC                    \ high byte of the result using two's complement with
 ADC #1                 \ A = ~A + 1

 BEQ PL12               \ If A = 0, jump to PL12 to return with (Y A) = 0

 LDY #&FF               \ Set Y = &FF to be a negative high byte

 RTS                    \ Return from the subroutine

.PL12

 LDY #0                 \ Set Y = 0 to be a positive high byte

 RTS                    \ Return from the subroutine

