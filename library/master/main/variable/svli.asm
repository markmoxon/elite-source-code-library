\ ******************************************************************************
\
\       Name: SVLI
\       Type: Variable
\   Category: Save and load
\    Summary: The OS command string for saving a commander file
\
\ ******************************************************************************

.SVLI

IF _SNG47

 EQUS "SAVE :1.E.JAMESON  E7E +100 0 0"
 EQUB 13

ELIF _COMPACT

 EQUS "SAVE JAMESON  E7E +100 0 0"
 EQUB 13

ENDIF

