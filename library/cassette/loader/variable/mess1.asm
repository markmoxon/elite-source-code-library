\ ******************************************************************************
\
\       Name: MESS1
\       Type: Variable
\   Category: Utility routines
\    Summary: Contains an OS command string for loading the main game code
\
\ ******************************************************************************

.MESS1

IF DISC

 EQUS "L.ELTcode 1100"  \ This is short for "*LOAD ELTcode 1100"

ELSE

 EQUS "L.ELITEcode F1F" \ This is short for "*LOAD ELITEcode F1F"

ENDIF

 EQUB 13

