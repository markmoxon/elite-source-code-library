.XSAV2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Comment

 SKIP 1                 \ Temporary storage, used for storing the value of the X
                        \ register in the TT26 routine

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _NES_VERSION

 SKIP 1                 \ Temporary storage, used for storing the value of the X
                        \ register in the CHPR routine

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION

 SKIP 1                 \ This byte appears to be unused

ENDIF

