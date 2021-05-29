\ ******************************************************************************
\
\       Name: DELI
\       Type: Variable
\   Category: Save and load
\    Summary: The OS command string for deleting a file
\
\ ******************************************************************************

.DELI

IF _DISC_DOCKED \ Minor

 EQUS "DE.:0.E.1234567"
 EQUB 13

ELIF _6502SP_VERSION

 EQUS "DELETE:0.E.1234567"
 EQUB 13

ELIF _MASTER_VERSION

IF _SNG47

 EQUS "DELETE :1.1234567"
 EQUB 13

ELIF _COMPACT

 EQUS "DELETE 1234567890"
 EQUB 13

ENDIF

ELIF _ELITE_A_VERSION

 EQUS "DEL.:0.E.1234567"
 EQUB 13

ENDIF

