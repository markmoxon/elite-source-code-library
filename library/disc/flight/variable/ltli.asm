\ ******************************************************************************
\
\       Name: LTLI
\       Type: Variable
\   Category: Loader
IF NOT(_ELITE_A_VERSION)
\    Summary: The OS command string for loading the docked code file T.CODE
ELIF _ELITE_A_VERSION
\    Summary: The OS command string for loading the docked code file 1.D
ENDIF
\
\ ******************************************************************************

.LTLI

IF NOT(_ELITE_A_VERSION)

 EQUS "L.T.CODE"
 EQUB 13

ELIF _ELITE_A_VERSION

 EQUS "L.1.D"
 EQUB 13

ENDIF

