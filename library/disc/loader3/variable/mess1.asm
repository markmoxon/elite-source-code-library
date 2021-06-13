\ ******************************************************************************
\
\       Name: MESS1
\       Type: Variable
\   Category: Loader
\    Summary: The OS command string for changing the disc directory to E
\
\ ******************************************************************************

.MESS1

IF NOT(_ELITE_A_VERSION)

 EQUS "*DIR E"
 EQUB 13

ELIF _ELITE_A_VERSION

 EQUS "DIR e"
 EQUB 13

ENDIF

