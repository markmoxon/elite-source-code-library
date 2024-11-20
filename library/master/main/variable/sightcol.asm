\ ******************************************************************************
\
\       Name: sightcol
\       Type: Variable
\   Category: Drawing lines
\    Summary: Colours for the crosshair sights on the different laser types
\
\ ******************************************************************************

.sightcol

IF NOT(_APPLE_VERSION)

 EQUB YELLOW            \ Pulse lasers have yellow sights

 EQUB CYAN              \ Beam lasers have cyan sights

 EQUB CYAN              \ Military lasers have cyan sights

 EQUB YELLOW            \ Mining lasers have yellow sights

ELIF _APPLE_VERSION

 EQUB BLUE              \ Pulse lasers have blue sights

 EQUB RED               \ Beam lasers have red sights

 EQUB WHITE             \ Military lasers have white sights

 EQUB WHITE             \ Mining lasers have white sights

ENDIF

