.XX19

IF _CASSETTE_VERSION

 SKIP NI% - 33          \ XX19(1 0) shares its location with INWK(34 33), which
                        \ contains the address of the ship line heap

ELIF _6502SP_VERSION

 SKIP NI% - 34          \ XX19(1 0) shares its location with INWK(34 33), which
                        \ contains the address of the ship line heap

ENDIF

