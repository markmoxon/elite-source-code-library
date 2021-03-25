.XX14

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

 SKIP 1                 \ This byte appears to be unused

ELIF _MASTER_VERSION

 SKIP 2                 \ ???

ENDIF

