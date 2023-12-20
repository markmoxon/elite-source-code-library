\ ******************************************************************************
\
\       Name: GetLaserPattern
\       Type: Subroutine
\   Category: Equipment
\    Summary: Get the pattern number for a specific laser's equipment sprite
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The laser power
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The pattern number for the first sprite for this type of
\                       laser, minus 140, so we return:
\
\                           * 0 (for pattern 140) for the mining laser
\
\                           * 4 (for pattern 144) for the beam laser
\
\                           * 8 (for pattern 148) for the pulse laser
\
\                           * 12 (for pattern 152) for the military laser
\
\ ******************************************************************************

.GetLaserPattern

 LDA #0                 \ Set A to the return value for pattern 140 (for the
                        \ mining laser)

 CPX #Armlas            \ If the laser power in X is equal to a military laser,
 BEQ glsp3              \ jump to glsp3 to the return value for pattern 152

 CPX #POW+128           \ If the laser power in X is equal to a beam laser,
 BEQ glsp2              \ jump to glsp2 to the return value for pattern 144

 CPX #Mlas              \ If the laser power in X is equal to a mining laser,
 BNE glsp1              \ jump to glsp2 to the return value for pattern 140

 LDA #8                 \ If we get here then this must be a pulse laser, so
                        \ set A to the return value for pattern 148

.glsp1

 RTS                    \ Return from the subroutine

.glsp2

 LDA #4                 \ This is a beam laser, so set A to the return value for
                        \ pattern 145

 RTS                    \ Return from the subroutine

.glsp3

 LDA #12                \ This is a military laser, so set A to the return value
                        \ for pattern 152

 RTS                    \ Return from the subroutine

