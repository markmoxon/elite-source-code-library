\ ******************************************************************************
\
\       Name: LL120
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (Y X) = (S x1_lo) * XX12+2 or (S x1_lo) / XX12+2
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following:
\
\   * If T = 0, this is a shallow slope, so calculate (Y X) = (S x1_lo) * XX12+2
\
\   * If T <> 0, this is a steep slope, so calculate (Y X) = (S x1_lo) / XX12+2
\
\ giving (Y X) the opposite sign to the slope direction in XX12+3.
\
\ Arguments:
\
\   T                   The gradient of slope:
\
\                         * 0 if it's a shallow slope
\
\                         * &FF if it's a steep slope
\
\ Other entry points:
\
\   LL122               Calculate (Y X) = (S R) * Q and set the sign to the
\                       opposite of the top byte on the stack
\
\ ******************************************************************************

.LL120

 LDA XX15               \ Set R = x1_lo
 STA R

IF _CASSETTE_VERSION OR _MASTER_VERSION OR _6502SP_VERSION \ Comment

\.LL120                 \ This label is commented out in the original source

ENDIF

 JSR LL129              \ Call LL129 to do the following:
                        \
                        \   Q = XX12+2
                        \     = line gradient
                        \
                        \   A = S EOR XX12+3
                        \     = S EOR slope direction
                        \
                        \   (S R) = |S R|
                        \
                        \ So A contains the sign of S * slope direction

 PHA                    \ Store A on the stack so we can use it later

 LDX T                  \ If T is non-zero, then it's a steep slope, so jump
 BNE LL121              \ down to LL121 to calculate this instead:
                        \
                        \   (Y X) = (S R) / Q

.LL122

                        \ The following calculates:
                        \
                        \   (Y X) = (S R) * Q
                        \
                        \ using the same shift-and-add algorithm that's
                        \ documented in MULT1

 LDA #0                 \ Set A = 0

 TAX                    \ Set (Y X) = 0 so we can start building the answer here
 TAY

 LSR S                  \ Shift (S R) to the right, so we extract bit 0 of (S R)
 ROR R                  \ into the C flag

 ASL Q                  \ Shift Q to the left, catching bit 7 in the C flag

 BCC LL126              \ If C (i.e. the next bit from Q) is clear, do not do
                        \ the addition for this bit of Q, and instead skip to
                        \ LL126 to just do the shifts

.LL125

 TXA                    \ Set (Y X) = (Y X) + (S R)
 CLC                    \
 ADC R                  \ starting with the low bytes
 TAX

 TYA                    \ And then doing the high bytes
 ADC S
 TAY

.LL126

 LSR S                  \ Shift (S R) to the right
 ROR R

 ASL Q                  \ Shift Q to the left, catching bit 7 in the C flag

 BCS LL125              \ If C (i.e. the next bit from Q) is set, loop back to
                        \ LL125 to do the addition for this bit of Q

 BNE LL126              \ If Q has not yet run out of set bits, loop back to
                        \ LL126 to do the "shift" part of shift-and-add until
                        \ we have done additions for all the set bits in Q, to
                        \ give us our multiplication result

 PLA                    \ Restore A, which we calculated above, from the stack

 BPL LL133              \ If A is positive jump to LL133 to negate (Y X) and
                        \ return from the subroutine using a tail call

 RTS                    \ Return from the subroutine

