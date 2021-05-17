.CABTMP

IF _CASSETTE_VERSION \ Platform
 SKIP 0                 \ Cabin temperature
ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION OR _ELITE_A_VERSION
 SKIP 1                 \ Cabin temperature
ENDIF
                        \
                        \ The ambient cabin temperature in deep space is 30,
                        \ which is displayed as one notch on the dashboard bar
                        \
                        \ We get higher temperatures closer to the sun
                        \
                        \ CABTMP shares a location with MANY, but that's OK as
                        \ MANY+0 would contain the number of ships of type 0,
                        \ and as there is no ship type 0 (they start at 1), the
                        \ byte at MANY+0 is not used for storing a ship type
                        \ and can be used for the cabin temperature instead

