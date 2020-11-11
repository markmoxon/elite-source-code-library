\ ******************************************************************************
\
\       Name: SPBT
\       Type: Variable
\   Category: Dashboard
\    Summary: The character definition for the space station indicator
\
\ ------------------------------------------------------------------------------
\
\ The character definition for the space station indicator's "S" bulb that gets
\ displayed on the dashboard. Each pixel is in mode 5 colour 2 (%10), which is
\ yellow/white.
\
\ ******************************************************************************

.SPBT

IF _CASSETTE_VERSION

 EQUB %11100000
 EQUB %11100000
 EQUB %10000000
 EQUB %11100000
 EQUB %11100000
 EQUB %00100000
 EQUB %11100000
 EQUB %11100000

ELIF _6502SP_VERSION

 EQUD &FFAAFFFF
 EQUD &FFFF00FF
 EQUD &FF00FFFF
 EQUD &FFFF55FF

ENDIF

