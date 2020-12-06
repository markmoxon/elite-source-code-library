\ ******************************************************************************
\
\       Name: SFS2
\       Type: Subroutine
\   Category: Moving
\    Summary: Move a ship in space along one of the coordinate axes
\
\ ------------------------------------------------------------------------------
\
\ Move a ship's coordinates by a certain amount in the direction of one of the
\ axes, where X determines the axis. Mathematically speaking, this routine
\ translates the ship along a single axis by a signed delta.
\
\ Arguments:
\
\   A                   The amount of movement, i.e. the signed delta
\
\   X                   Determines which coordinate axis of INWK to move:
\
\                         * X = 0 moves the ship along the x-axis
\
\                         * X = 3 moves the ship along the y-axis
\
\                         * X = 6 moves the ship along the z-axis
\
\ ******************************************************************************

.SFS2

 ASL A                  \ Set R = |A * 2|, with the C flag set to bit 7 of A
 STA R

 LDA #0                 \ Set bit 7 of A to the C flag, i.e. the sign bit from
 ROR A                  \ the original argument in A

 JMP MVT1               \ Add the delta R with sign A to (x_lo, x_hi, x_sign)
                        \ (or y or z, depending on the value in X) and return
                        \ from the subroutine using a tail call

