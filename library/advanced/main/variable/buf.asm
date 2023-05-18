.BUF

IF _6502SP_VERSION \ Platform

 SKIP 100               \ The line buffer used by DASC to print justified text

ELIF _MASTER_VERSION OR _NES_VERSION

 SKIP 90                \ The line buffer used by DASC to print justified text

ENDIF

