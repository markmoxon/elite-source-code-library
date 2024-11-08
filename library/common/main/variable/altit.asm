.ALTIT

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
 SKIP 1                 \ Our altitude above the surface of the planet or sun
ELIF _ELECTRON_VERSION
 SKIP 1                 \ Our altitude above the surface of the planet
ENDIF
                        \
                        \   * 255 = we are a long way above the surface
                        \
                        \   * 1-254 = our altitude as the square root of:
                        \
                        \       x_hi^2 + y_hi^2 + z_hi^2 - 6^2
                        \
                        \     where our ship is at the origin, the centre of the
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Comment
                        \     planet/sun is at (x_hi, y_hi, z_hi), and the
                        \     radius of the planet/sun is 6
ELIF _ELECTRON_VERSION
                        \     planet is at (x_hi, y_hi, z_hi), and the radius
                        \     of the planet is 6
ENDIF
                        \
                        \   * 0 = we have crashed into the surface

