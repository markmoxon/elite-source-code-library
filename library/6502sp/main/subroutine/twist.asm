\ ******************************************************************************
\
\       Name: TWIST
\       Type: Subroutine
\   Category: Demo
\    Summary: Pitch the current ship by a small angle in a positive direction
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   TWIST2              Pitch in the direction given in A
\
\ ******************************************************************************

.TWIST2

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A9 &00, or BIT &00A9, which does nothing apart
                        \ from affect the flags

.TWIST

 LDA #0                 \ Set A = 0
 
 STA RAT2               \ Set the pitch direction in RAT2 to A

 LDX #15                \ Rotate (roofv_x, nosev_x) by a small angle (pitch)
 LDY #9                 \ in the direction given in RAT2
 JSR MVS5

 LDX #17                \ Rotate (roofv_y, nosev_y) by a small angle (pitch)
 LDY #11                \ in the direction given in RAT2
 JSR MVS5

 LDX #19                \ Rotate (roofv_z, nosev_z) by a small angle (pitch)
 LDY #13                \ in the direction given in RAT2 and return from the
 JMP MVS5               \ subroutine using a tail call

