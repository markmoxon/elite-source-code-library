\ ******************************************************************************
\
\       Name: TAS1
\       Type: Subroutine
\   Category: Maths (Arithmetic)
\    Summary: Calculate K3 = (x_sign x_hi x_lo) - V(1 0)
\
\ ------------------------------------------------------------------------------
\
\ Calculate one of the following, depending on the value in Y:
\
\   K3(2 1 0) = (x_sign x_hi x_lo) - x-coordinate in V(1 0)
\
\   K3(5 4 3) = (y_sign y_hi z_lo) - y-coordinate in V(1 0)
\
\   K3(8 7 6) = (z_sign z_hi z_lo) - z-coordinate in V(1 0)
\
\ where the first coordinate is from the ship data block in INWK, and the second
\ coordinate is from the ship data block pointed to by V(1 0).
\
\ Arguments:
\
\   V(1 0)              The address of the ship data block to subtract
\
\   Y                   The coordinate in the V(1 0) block to subtract:
\
\                         * If Y = 2, subtract the x-coordinate and store the
\                           result in K3(2 1 0)
\
\                         * If Y = 5, subtract the y-coordinate and store the
\                           result in K3(5 4 3)
\
\                         * If Y = 8, subtract the z-coordinate and store the
\                           result in K3(8 7 6)
\
\ ******************************************************************************

.TAS1

IF _NES_VERSION

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

 LDA (V),Y              \ Copy the sign byte of the V(1 0) coordinate into K+3,
 EOR #%10000000         \ flipping it in the process
 STA K+3

 DEY                    \ Copy the high byte of the V(1 0) coordinate into K+2
 LDA (V),Y
 STA K+2

 DEY                    \ Copy the high byte of the V(1 0) coordinate into K+1,
 LDA (V),Y              \ so now:
 STA K+1                \
                        \   K(3 2 1) = - coordinate in V(1 0)

 STY U                  \ Copy the index (now 0, 3 or 6) into U and X
 LDX U

 JSR MVT3               \ Call MVT3 to add the same coordinates, but this time
                        \ from INWK, so this would look like this for the
                        \ x-axis:
                        \
                        \   K(3 2 1) = (x_sign x_hi x_lo) + K(3 2 1)
                        \            = (x_sign x_hi x_lo) - coordinate in V(1 0)

 LDY U                  \ Restore the index into Y, though this instruction has
                        \ no effect, as Y is not used again, either here or
                        \ following calls to this routine

 STA K3+2,X             \ Store K(3 2 1) in K3+X(2 1 0), starting with the sign
                        \ byte

 LDA K+2                \ And then doing the high byte
 STA K3+1,X

 LDA K+1                \ And finally the low byte
 STA K3,X

 RTS                    \ Return from the subroutine

