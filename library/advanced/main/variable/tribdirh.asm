\ ******************************************************************************
\
\       Name: TRIBDIRH
\       Type: Variable
\   Category: Missions
\    Summary: ???
\
\ ******************************************************************************

IF _MASTER_VERSION OR _APPLE_VERSION \ Comment

\.TRIBDIRH              \ These instructions are commented out in the original
\                       \ source
\EQUB 0 
\EQUB 0
\EQUB &FF
\EQUB 0

ELIF _C64_VERSION

.TRIBDIRH

 EQUB 0                 \ ???
 EQUB 0
 EQUB &FF
 EQUB 0

ENDIF

