\ ******************************************************************************
\
\       Name: LL28
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate R = 256 * A / Q
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following, where A < Q:
\
\   R = 256 * A / Q
\
\ This is a sister routine to LL61, which does the division when A >= Q.
\
\ If A >= Q then 255 is returned and the C flag is set to indicate an overflow
\ (the C flag is clear if the division was a success).
\
\ The result is returned in one byte as the result of the division multiplied
\ by 256, so we can return fractional results using integers.
\
IF _CASSETTE_VERSION OR _DISC_VERSION
\ This routine uses the same shift-and-subtract algorithm that's documented in
\ TIS2, but it leaves the fractional result in the integer range 0-255.
ELIF _6502SP_VERSION
\ This routine uses the same logarithm algorithm that's documented in FMLTU,
\ except it subtracts the logarithm values, to do a division instead of a
\ multiplication.
ENDIF
\
\ Returns:
\
\   C flag              Set if the answer is too big for one byte, clear if the
\                       division was a success
\
\ Other entry points:
\
\   LL28+4              Skips the A >= Q check and always returns with C flag
\                       cleared, so this can be called if we know the division
\                       will work
\
\   LL31                Skips the A >= Q check and does not set the R counter,
\                       so this can be used for jumping straight into the
\                       division loop if R is already set to 254 and we know the
\                       division will work
\
\ ******************************************************************************

.LL28

 CMP Q                  \ If A >= Q, then the answer will not fit in one byte,
 BCS LL2                \ so jump to LL2 to return 255

IF _CASSETTE_VERSION OR _DISC_VERSION

 LDX #%11111110         \ Set R to have bits 1-7 set, so we can rotate through 7
 STX R                  \ loop iterations, getting a 1 each time, and then
                        \ getting a 0 on the 8th iteration... and we can also
                        \ use R to catch our result bits into bit 0 each time

ELIF _6502SP_VERSION

 STA widget             \ Store A in widget, so now widget = argument A

 TAX                    \ Transfer A into X, so now X = argument A

 BEQ LLfix              \ If A = 0, jump to LLfix to return a result of 0, as
                        \ 0 * Q / 256 is always 0

                        \ We now want to calculate log(A) + log(Q), first adding
                        \ the low bytes (from the logL table), and then the high
                        \ bytes (from the log table)

 LDA logL,X             \ Set A = low byte of log(X)
                        \       = low byte of log(A) (as we set X to A above)

 LDX Q                  \ Set X = Q

 SEC                    \ Set A = A - low byte of log(Q)
 SBC logL,X             \       = low byte of log(A) - low byte of log(Q)

 BMI noddlog            \ If the subtraction is negative, jump to noddlog

 LDX widget             \ Set A = high byte of log(A) - high byte of log(Q)
 LDA log,X
 LDX Q
 SBC log,X

 BCS LL2                \ If the subtraction fitted into one byte and didn't
                        \ underflow, then log(A) - log(Q) < 256, so we jump to
                        \ LL2 return a result of 255

 TAX                    \ Otherwise we return the A-th entry from the antilog
 LDA antilog,X          \ table

.LLfix

 STA R                  \ Set the result in R to the value of A

 RTS                    \ Return from the subroutine

.noddlog

 LDX widget             \ Set A = high byte of log(A) - high byte of log(Q)
 LDA log,X
 LDX Q
 SBC log,X

 BCS LL2                \ If the subtraction fitted into one byte and didn't
                        \ underflow, then log(A) - log(Q) < 256, so we jump to
                        \ LL2 to return a result of 255

 TAX                    \ Otherwise we return the A-th entry from the antilogODD
 LDA antilogODD,X       \ table

 STA R                  \ Set the result in R to the value of A

 RTS                    \ Return from the subroutine

ENDIF

.LL31

 ASL A                  \ Shift A to the left

 BCS LL29               \ If bit 7 of A was set, then jump straight to the
                        \ subtraction

 CMP Q                  \ If A < Q, skip the following subtraction
 BCC P%+4

 SBC Q                  \ A >= Q, so set A = A - Q

 ROL R                  \ Rotate the counter in R to the left, and catch the
                        \ result bit into bit 0 (which will be a 0 if we didn't
                        \ do the subtraction, or 1 if we did)

 BCS LL31               \ If we still have set bits in R, loop back to LL31 to
                        \ do the next iteration of 7

 RTS                    \ R left with remainder of division

.LL29

 SBC Q                  \ A >= Q, so set A = A - Q

 SEC                    \ Set the C flag to rotate into the result in R

 ROL R                  \ Rotate the counter in R to the left, and catch the
                        \ result bit into bit 0 (which will be a 0 if we didn't
                        \ do the subtraction, or 1 if we did)

 BCS LL31               \ If we still have set bits in R, loop back to LL31 to
                        \ do the next iteration of 7

IF _6502SP_VERSION

 LDA R                  \ Set A to the remainder in R

ENDIF

 RTS                    \ Return from the subroutine with R containing the
                        \ remainder of the division

.LL2

 LDA #255               \ The division is very close to 1, so return the closest
 STA R                  \ possible answer to 256, i.e. R = 255

 RTS                    \ Return from the subroutine

