\ ******************************************************************************
\
\       Name: MESS2
\       Type: Variable
\   Category: Loader
\    Summary: The OS command string for loading the main game code binary
\
\ ******************************************************************************

.MESS2

IF _SNG47

 EQUS "L.BCODE FFFF1300"    \ This is short for "*LOAD BDATA FFFF1300"
 EQUB 13

ELIF _COMPACT

 EQUS "L.ELITE FFFF1300"    \ This is short for "*LOAD ELITE FFFF1300"
 EQUB 13

ENDIF

