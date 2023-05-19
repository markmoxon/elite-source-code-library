IF NOT(_NES_VERSION)
\ ******************************************************************************
\
\       Name: HANGFLAG
\       Type: Variable
\   Category: Ship hangar
\    Summary: The number of ships being displayed in the ship hangar
\
\ ******************************************************************************

.HANGFLAG

 EQUB 0

ELIF _NES_VERSION

.HANGFLAG

 SKIP 1                 \ The number of ships being displayed in the ship hangar

ENDIF

