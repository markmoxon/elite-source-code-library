\ ******************************************************************************
\
\       Name: lodosc
\       Type: Variable
\   Category: Save and load
\    Summary: The OS command string for loading a commander file
\
\ ******************************************************************************

.lodosc

IF _SNG47

 EQUS "LOAD :1.E.JAMESON  E7E"
 EQUB 13

ELIF _COMPACT

 EQUS "LOAD JAMESON  E7E"
 EQUB 13

ENDIF

