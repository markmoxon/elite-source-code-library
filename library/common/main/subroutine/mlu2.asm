\ ******************************************************************************
\
\       Name: MLU2
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (A P) = |A| * Q
\
\ ------------------------------------------------------------------------------
\
\ Do the following multiplication of a sign-magnitude 8-bit number P with an
\ unsigned number Q:
\
\   (A P) = |A| * Q
\
\ ******************************************************************************

.MLU2

 AND #%01111111         \ Clear the sign bit in P, so P = |A|
 STA P

IF NOT(_ELITE_A_6502SP_PARA)

                        \ Fall through into MULTU to calculate:
                        \
                        \   (A P) = P * Q
                        \         = |A| * Q

ELIF _ELITE_A_6502SP_PARA

 JMP MULTU              \ Call MULTU to calculate:
                        \
                        \   (A P) = P * Q
                        \         = |A| * Q
                        \
                        \ and return from the subroutine using a tail call

ENDIF

