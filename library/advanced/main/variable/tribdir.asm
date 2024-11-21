\ ******************************************************************************
\
\       Name: TRIBDIR
\       Type: Variable
\   Category: Missions
\    Summary: The low byte of the four 16-bit directions in which Trumble
\             sprites can move
\
\ ******************************************************************************

IF _MASTER_VERSION OR _APPLE_VERSION \ Comment

\.TRIBDIR               \ These instructions are commented out in the original
\                       \ source
\EQUB 0
\EQUB 1
\EQUB &FF
\EQUB 0

ELIF _C64_VERSION

.TRIBDIR

 EQUB 0                 \ Four directions: 0, 1, -1, 0
 EQUB 1
 EQUB &FF
 EQUB 0

ENDIF

