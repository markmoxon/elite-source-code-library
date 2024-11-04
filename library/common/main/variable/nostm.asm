.NOSTM

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment

 SKIP 1                 \ The number of stardust particles shown on screen,
                        \ which is 18 (#NOST) for normal space, and 3 for
                        \ witchspace

ELIF _MASTER_VERSION OR _NES_VERSION

 SKIP 1                 \ The number of stardust particles shown on screen,
                        \ which is 20 (#NOST) for normal space, and 3 for
                        \ witchspace

ENDIF

