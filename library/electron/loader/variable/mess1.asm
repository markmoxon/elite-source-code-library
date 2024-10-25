\ ******************************************************************************
\
\       Name: MESS1
\       Type: Variable
\   Category: Utility routines
\    Summary: Contains an OS command string for loading the main game code
\
\ ******************************************************************************

.MESS1

IF _DISC

 EQUS "LOAD EliteCo FFFF2000"
 EQUB 13

ELSE

 EQUS "LOAD ELITEcode FFFF0E00"
 EQUB 13

ENDIF

