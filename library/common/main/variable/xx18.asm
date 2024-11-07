.XX18

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 SKIP 0                 \ Temporary storage used to store coordinates in the
                        \ LL9 ship-drawing routine

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 SKIP 4                 \ Temporary storage used to store coordinates in the
                        \ LL9 ship-drawing routine

ENDIF

