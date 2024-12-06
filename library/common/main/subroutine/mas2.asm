\ ******************************************************************************
\
\       Name: MAS2
\       Type: Subroutine
\   Category: Maths (Geometry)
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
\    Summary: Calculate a cap on the maximum distance to the planet or sun
ELIF _ELECTRON_VERSION
\    Summary: Calculate a cap on the maximum distance to the planet
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Given a value in Y that points to the start of a ship data block as an offset
\ from K%, calculate the following:
\
\   A = A OR x_sign OR y_sign OR z_sign
\
\ and clear the sign bit of the result. The K% workspace contains the ship data
\ blocks, so the offset in Y must be 0 or a multiple of NI% (as each block in
\ K% contains NI% bytes).
\
\ The result effectively contains a maximum cap of the three values (though it
\ might not be one of the three input values - it's just guaranteed to be
\ larger than all of them).
\
\ If Y = 0 and A = 0, then this calculates the maximum cap of the highest byte
\ containing the distance to the planet, as K%+2 = x_sign, K%+5 = y_sign and
\ K%+8 = z_sign (the first slot in the K% workspace represents the planet).
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The offset from K% for the start of the ship data block
\                       to use
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A OR K%+2+Y OR K%+5+Y OR K%+8+Y, with bit 7 cleared
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   m                   Do not include A in the calculation
\
\ ******************************************************************************

.m

 LDA #0                 \ Set A = 0 and fall through into MAS2 to calculate the
                        \ OR of the three bytes at K%+2+Y, K%+5+Y and K%+8+Y

.MAS2

 ORA K%+2,Y             \ Set A = A OR x_sign OR y_sign OR z_sign
 ORA K%+5,Y
 ORA K%+8,Y

 AND #%01111111         \ Clear bit 7 in A

 RTS                    \ Return from the subroutine

