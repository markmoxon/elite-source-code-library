\ ******************************************************************************
\
\       Name: DV41
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate (P R) = 256 * DELTA / A
\
\ ------------------------------------------------------------------------------
\
\ Calculate the following division and remainder:
\
\   P = DELTA / A
\
\   R = remainder as a fraction of A, where 1.0 = 255
\
\ Another way of saying the above is this:
\
\   (P R) = 256 * DELTA / A
\
\ This uses the same shift-and-subtract algorithm as TIS2, but this time we
\ keep the remainder.
\
\ Returns:
\
\   C flag              The C flag is cleared
\
\ ******************************************************************************

.DV41

 STA Q                  \ Store A in Q

 LDA DELTA              \ Fetch the speed from DELTA into A

IF NOT(_ELITE_A_6502SP_PARA)

                        \ Fall through into DVID4 to do:
                        \
                        \   (P R) = 256 * A / Q
                        \         = 256 * DELTA / A

ELIF _ELITE_A_6502SP_PARA

 JMP DVID4              \ AJD

ENDIF

