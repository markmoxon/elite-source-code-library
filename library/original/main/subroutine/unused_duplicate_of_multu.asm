\ ******************************************************************************
\
\       Name: Unused duplicate of MULTU
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: An unused duplicate of the MULTU routine
\
\ ------------------------------------------------------------------------------
\
\ This is a duplicate of the MULTU routine, but with no entry label, so it can't
\ be called by name. It is unused, and could have been culled to save a few
\ bytes (24 to be precise), but it's still here, unnamed, unloved and unvisited,
\ through no fault of its own.
\
\ ******************************************************************************

IF NOT(_ELITE_A_VERSION)
 LDX Q
 BEQ MU1
 DEX
 STX T
 LDA #0
 LDX #8
 LSR P

ENDIF

.MUL6K                  \ This label is a duplicate of a label in the MULTU
                        \ routine
                        \
                        \ In the original source this label is MUL6, but
                        \ because BeebAsm doesn't allow us to redefine labels,
                        \ I have renamed it to MUL6K

 BCC P%+4
 ADC T
 ROR A
 ROR P
 DEX
 BNE MUL6K
 RTS

