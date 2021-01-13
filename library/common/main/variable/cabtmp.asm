.CABTMP

IF _CASSETTE_VERSION
 SKIP 0                 \ Cabin temperature
ELIF _6502SP_VERSION OR _DISC_VERSION
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
                        \ but as there is no ship type 0 (they start at 1), MANY
                        \ is unused

