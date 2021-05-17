\ ******************************************************************************
\
\       Name: DORND
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Generate random numbers
\  Deep dive: Generating random numbers
\
\ ------------------------------------------------------------------------------
\
\ Set A and X to random numbers. The C and V flags are also set randomly.
\
IF NOT(_ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP)
\ Other entry points:
\
\   DORND2              Restricts the value of RAND+2 so that bit 0 is always 0
\
ENDIF
\ ******************************************************************************

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP)

.DORND2

 CLC                    \ This ensures that bit 0 of r2 is 0

ENDIF

.DORND

 LDA RAND               \ r2´ = ((r0 << 1) mod 256) + C
 ROL A                  \ r0´ = r2´ + r2 + bit 7 of r0
 TAX
 ADC RAND+2             \ C = C flag from r0´ calculation
 STA RAND
 STX RAND+2

 LDA RAND+1             \ A = r1´ = r1 + r3 + C
 TAX                    \ X = r3´ = r1
 ADC RAND+3
 STA RAND+1
 STX RAND+3

 RTS                    \ Return from the subroutine

