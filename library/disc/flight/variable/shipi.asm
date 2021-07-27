\ ******************************************************************************
\
\       Name: SHIPI
\       Type: Variable
\   Category: Loader
\    Summary: The OS command string for loading a ship blueprints file
\
\ ******************************************************************************

.SHIPI

IF NOT(_ELITE_A_VERSION)

 EQUS "L.D.MO0"         \ This is short for "*LOAD D.MO0"
 EQUB 13

ELIF _ELITE_A_VERSION

 EQUS "L.S.0"           \ This is short for "*LOAD S.0"
 EQUB 13

ENDIF

