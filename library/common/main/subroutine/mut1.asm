\ ******************************************************************************
\
\       Name: MUT1
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate R = XX and (A P) = Q * A
\
\ ------------------------------------------------------------------------------
\
\ Do the following assignment, and multiplication of two signed 8-bit numbers:
\
\   R = XX
\   (A P) = Q * A
\
\ ******************************************************************************

.MUT1

 LDX XX                 \ Set R = XX
 STX R

IF NOT(_ELITE_A_6502SP_PARA)

                        \ Fall through into MULT1 to do the following:
                        \
                        \   (A P) = Q * A

ELIF _ELITE_A_6502SP_PARA

 JMP MULT1              \ AJD

ENDIF

