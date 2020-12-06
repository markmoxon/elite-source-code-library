\ ******************************************************************************
\
\       Name: Unused duplicate of MULTU
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Unused duplicate of the MULTU routine
\
\ ------------------------------------------------------------------------------
\
\ This is a duplicate of the MULTU routine, but with no entry label, so it can't
\ be called by name. It is unused, and could have been culled to save a few
\ bytes (24 to be precise), but it's still here.
\
\ In the disc version it has the label MULTU6, but here in the cassette version
\ it's unnamed, unloved and unvisited, through no fault of its own.
\
\ ******************************************************************************

{
 LDX Q
 BEQ MU1
 DEX
 STX T
 LDA #0
 LDX #8
 LSR P

.MUL6

 BCC P%+4
 ADC T
 ROR A
 ROR P
 DEX
 BNE MUL6
 RTS
}

