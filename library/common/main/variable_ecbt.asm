\ ******************************************************************************
\
\       Name: ECBT
\       Type: Variable
\   Category: Dashboard
\    Summary: The character definition for the E.C.M. indicator
\
\ ------------------------------------------------------------------------------
\
\ The character definition for the E.C.M. indicator's "E" bulb that gets
\ displayed on the dashboard. The E.C.M. indicator uses the first 5 rows of the
\ space station's "S" bulb below, as the bottom 5 rows of the "E" match the top
\ 5 rows of the "S". Each pixel is in mode 5 colour 2 (%10), which is
\ yellow/white.
\
\ ******************************************************************************

.ECBT

IF _CASSETTE_VERSION

 EQUB %11100000
 EQUB %11100000
 EQUB %10000000

ELIF _6502SP_VERSION

 EQUD &FFAAFFFF
 EQUD &FFFFAAFF
 EQUD &FF00FFFF
 EQUD &FFFF00FF

ENDIF

