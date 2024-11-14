\ ******************************************************************************
\
\       Name: TRIBMA
\       Type: Variable
\   Category: Missions
\    Summary: ???
\
\ ******************************************************************************

IF _MASTER_VERSION OR _APPLE_VERSION \ Comment

\.TRIBMA                \ These instructions are commented out in the original
\                       \ source
\EQUB 0
\EQUB 4
\EQUB &C
\EQUB &1C
\EQUB &3C
\EQUB &7C
\EQUB &FC
\EQUB &FC

ELIF _C64_VERSION

.TRIBMA

 EQUB 0                 \ ???
 EQUB 4
 EQUB &C
 EQUB &1C
 EQUB &3C
 EQUB &7C
 EQUB &FC
 EQUB &FC

ENDIF

