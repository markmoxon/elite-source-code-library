\ ******************************************************************************
\
\       Name: TRIBDIR
\       Type: Variable
\   Category: Missions
\    Summary: ???
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

 EQUB 0					\ ???
 EQUB 1
 EQUB &FF
 EQUB 0

ENDIF

