\ ******************************************************************************
\
\       Name: TRIBDIRH
\       Type: Variable
\   Category: Missions
\    Summary: The high byte of the four 16-bit directions in which Trumble
\             sprites can move
\
\ ******************************************************************************

IF _MASTER_VERSION OR _APPLE_VERSION

\.TRIBDIRH              \ These instructions are commented out in the original
\                       \ source
\EQUB 0
\EQUB 0
\EQUB &FF
\EQUB 0

ELIF _C64_VERSION

.TRIBDIRH

 EQUB 0                 \ Four directions: 0, 1, -1, 0
 EQUB 0
 EQUB &FF
 EQUB 0

ENDIF

