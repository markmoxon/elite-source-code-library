.XX19

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 SKIP NI% - 33          \ XX19(1 0) shares its location with INWK(34 33), which
                        \ contains the address of the ship line heap

ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION OR _ELITE_A_VERSION

 SKIP NI% - 34          \ XX19(1 0) shares its location with INWK(34 33), which
                        \ contains the address of the ship line heap

ENDIF

