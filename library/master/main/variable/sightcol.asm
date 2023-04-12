\ ******************************************************************************
\
\       Name: SIGHTCOL
\       Type: Variable
\   Category: Drawing lines
\    Summary: Colours for the crosshair sights on the different laser types
\
\ ******************************************************************************

.SIGHTCOL

 EQUB YELLOW            \ Pulse lasers have yellow sights

 EQUB CYAN              \ Beam lasers have cyan sights

 EQUB CYAN              \ Military lasers have cyan sights

 EQUB YELLOW            \ Mining lasers have yellow sights

.beamcol

 EQUB WHITE             \ These bytes appear to be unused - perhaps they were
 EQUB WHITE             \ going to be used to set different colours of laser
 EQUB WHITE             \ beam for the different lasers?
 EQUB WHITE

