\ ******************************************************************************
\
\       Name: DELI
\       Type: Variable
\   Category: Save and load
\    Summary: The OS command string for deleting a file
\
\ ******************************************************************************

.DELI

IF _DISC_DOCKED
 EQUS "DE.:0.E.1234567"
ELIF _6502SP_VERSION
 EQUS "DELETE:0.E.1234567"
ENDIF
 EQUB 13

