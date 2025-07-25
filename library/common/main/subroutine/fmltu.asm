\ ******************************************************************************
\
\       Name: FMLTU
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate A = A * Q / 256
IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\  Deep dive: Multiplication and division using logarithms
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Do the following multiplication of two unsigned 8-bit numbers, returning only
\ the high byte of the result:
\
\   (A ?) = A * Q
\
\ or, to put it another way:
\
\   A = A * Q / 256
\
IF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\ The advanced versions of Elite use logarithms to speed up the multiplication
\ process.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The C flag is clear if A = 0, or set if we return a
\                       result from one of the log tables
\
ELIF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The C flag is set
\
ENDIF
\ ******************************************************************************

.FMLTU

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Other: The FMLTU routine in the advanced versions uses logarithms to speed up the multiplication

 EOR #%11111111         \ Flip the bits in A, set the C flag and rotate right,
 SEC                    \ so the C flag now contains bit 0 of A inverted, and P
 ROR A                  \ contains A inverted and shifted right by one, with bit
 STA P                  \ 7 set to a 1. We can now use P as our source of bits
                        \ to shift right, just as in MU11, just with the logic
                        \ reversed

 LDA #0                 \ Set A = 0 so we can start building the answer in A

.MUL3

 BCS MU7                \ If C (i.e. the next bit from P) is set, do not do the
                        \ addition for this bit of P, and instead skip to MU7
                        \ to just do the shifts

 ADC Q                  \ Do the addition for this bit of P:
                        \
                        \   A = A + Q + C
                        \     = A + Q

 ROR A                  \ Shift A right to catch the next digit of our result.
                        \ If we were interested in the low byte of the result we
                        \ would want to save the bit that falls off the end, but
                        \ we aren't, so we can ignore it

 LSR P                  \ Shift P right to fetch the next bit for the
                        \ calculation into the C flag

 BNE MUL3               \ Loop back to MUL3 if P still contains some set bits
                        \ (so we loop through the bits of P until we get to the
                        \ 1 we inserted before the loop, and then we stop)

                        \ If we get here then the C flag is set as we just
                        \ rotated a 1 out of the right end of P

 RTS                    \ Return from the subroutine

.MU7

 LSR A                  \ Shift A right to catch the next digit of our result,
                        \ pushing a 0 into bit 7 as we aren't adding anything
                        \ here (we can't use a ROR here as the C flag is set, so
                        \ a ROR would push a 1 into bit 7)

 LSR P                  \ Fetch the next bit from P into the C flag

 BNE MUL3               \ Loop back to MUL3 if P still contains some set bits
                        \ (so we loop through the bits of P until we get to the
                        \ 1 we inserted before the loop, and then we stop)

                        \ If we get here then the C flag is set as we just
                        \ rotated a 1 out of the right end of P

 RTS                    \ Return from the subroutine

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION

 STX P                  \ Store X in P so we can preserve it through the call to
                        \ FMLTU

 STA widget             \ Store A in widget, so now widget = argument A

 TAX                    \ Transfer A into X, so now X = argument A

 BEQ MU3                \ If A = 0, jump to MU3 to return a result of 0, as
                        \ 0 * Q / 256 is always 0

                        \ We now want to calculate La + Lq, first adding the low
                        \ bytes (from the logL table), and then the high bytes
                        \ (from the log table)

 LDA logL,X             \ Set A = low byte of La
                        \       = low byte of La (as we set X to A above)

 LDX Q                  \ Set X = Q

 BEQ MU3again           \ If X = 0, jump to MU3again to return a result of 0, as
                        \ A * 0 / 256 is always 0

 CLC                    \ Set A = A + low byte of Lq
 ADC logL,X             \       = low byte of La + low byte of Lq

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Other: Group A: In the FMLTU multiplication routine, the Master version omits half of the logarithm algorithm when compared to the 6502SP version. The effect of this in-game is most noticeable in the Short-range Chart, where the fuel circle is a different shape to the other versions (the Master version looks rather less smooth, as if it has a slightly larger step size, though it's actually down to the less accurate FMLTU routine)

 BMI oddlog             \ If A > 127, jump to oddlog

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Other: See group A

 LDA log,X              \ Set A = high byte of Lq

 LDX widget             \ Set A = A + C + high byte of La
 ADC log,X              \       = high byte of Lq + high byte of La + C
                        \
                        \ so we now have:
                        \
                        \   A = high byte of (La + Lq)

 BCC MU3again           \ If the addition fitted into one byte and didn't carry,
                        \ then La + Lq < 256, so we jump to MU3again to return a
                        \ result of 0 and the C flag clear

                        \ If we get here then the C flag is set, ready for when
                        \ we return from the subroutine below

 TAX                    \ Otherwise La + Lq >= 256, so we return the A-th entry
 LDA antilog,X          \ from the antilog table

 LDX P                  \ Restore X from P so it is preserved

 RTS                    \ Return from the subroutine

ELIF _MASTER_VERSION OR _APPLE_VERSION

 LDA log,X              \ Set A = high byte of Lq

 LDX widget             \ Set A = A + C + high byte of La
 ADC log,X              \       = high byte of Lq + high byte of La + C
                        \
                        \ so we now have:
                        \
                        \   A = high byte of (La + Lq)

 BCC MU3again           \ If the addition fitted into one byte and didn't carry,
                        \ then La + Lq < 256, so we jump to MU3again to return a
                        \ result of 0 and the C flag clear

                        \ If we get here then the C flag is set, ready for when
                        \ we return from the subroutine below

 TAX                    \ Otherwise La + Lq >= 256, so we return the A-th entry
 LDA alogh,X            \ from the antilog table

 LDX P                  \ Restore X from P so it is preserved

 RTS                    \ Return from the subroutine

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Other: See group A

.oddlog

 LDA log,X              \ Set A = high byte of Lq

 LDX widget             \ Set A = A + C + high byte of La
 ADC log,X              \       = high byte of Lq + high byte of La + C
                        \
                        \ so we now have:
                        \
                        \   A = high byte of (La + Lq)

 BCC MU3again           \ If the addition fitted into one byte and didn't carry,
                        \ then La + Lq < 256, so we jump to MU3again to return a
                        \ result of 0 and the C flag clear

                        \ If we get here then the C flag is set, ready for when
                        \ we return from the subroutine below

 TAX                    \ Otherwise La + Lq >= 256, so we return the A-th entry
 LDA antilogODD,X       \ from the antilogODD table

ENDIF

IF _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Other: See group A

.MU3

                        \ If we get here then A (our result) is already 0

 LDX P                  \ Restore X from P so it is preserved

 RTS                    \ Return from the subroutine

.MU3again

 LDA #0                 \ Set A = 0

 LDX P                  \ Restore X from P so it is preserved

 RTS                    \ Return from the subroutine

ELIF _MASTER_VERSION OR _APPLE_VERSION

.MU3again

 LDA #0                 \ Set A = 0

.MU3

                        \ If we get here then A (our result) is already 0

 LDX P                  \ Restore X from P so it is preserved

 RTS                    \ Return from the subroutine

ENDIF

