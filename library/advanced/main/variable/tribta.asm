\ ******************************************************************************
\
\       Name: TRIBTA
\       Type: Variable
\   Category: Missions
\    Summary: ???
\
\ ******************************************************************************

IF _MASTER_VERSION OR _APPLE_VERSION \ Comment

\.TRIBTA                \ These instructions are commented out in the original
\                       \ source
\EQUB 0
\EQUB 1
\EQUB 2
\EQUB 3
\EQUB 4
\EQUB 5
\EQUB 6
\EQUB 6

ELIF _C64_VERSION

.TRIBTA

 EQUB 0                 \ ???
 EQUB 1
 EQUB 2
 EQUB 3
 EQUB 4
 EQUB 5
 EQUB 6
 EQUB 6

ENDIF

