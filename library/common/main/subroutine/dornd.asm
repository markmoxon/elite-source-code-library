\ ******************************************************************************
\
\       Name: DORND
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Generate random numbers
\  Deep dive: Generating random numbers
\             Fixing ship positions
\
\ ------------------------------------------------------------------------------
\
\ Set A and X to random numbers (though note that X is set to the random number
\ that was returned in A the last time DORND was called).
\
\ The C and V flags are also set randomly.
\
\ If we want to generate a repeatable sequence of random numbers, when
\ generating explosion clouds, for example, then we call DORND2 to ensure that
\ the value of the C flag on entry doesn't affect the outcome, as otherwise we
\ might not get the same sequence of numbers if the C flag changes.
\
IF NOT(_ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA)
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   DORND2              Make sure the C flag doesn't affect the outcome
\
ENDIF
\ ******************************************************************************

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA)

.DORND2

 CLC                    \ Clear the C flag so the value of the C flag on entry
                        \ doesn't affect the outcome

ENDIF

.DORND

 LDA RAND               \ Calculate the next two values f2 and f3 in the feeder
 ROL A                  \ sequence:
 TAX                    \
 ADC RAND+2             \   * f2 = (f1 << 1) mod 256 + C flag on entry
 STA RAND               \   * f3 = f0 + f2 + (1 if bit 7 of f1 is set)
 STX RAND+2             \   * C flag is set according to the f3 calculation

 LDA RAND+1             \ Calculate the next value m2 in the main sequence:
 TAX                    \
 ADC RAND+3             \   * A = m2 = m0 + m1 + C flag from feeder calculation
 STA RAND+1             \   * X = m1
 STX RAND+3             \   * C and V flags set according to the m2 calculation

 RTS                    \ Return from the subroutine

