\ ******************************************************************************
\
\       Name: beamcol
\       Type: Variable
\   Category: Drawing lines
\    Summary: Colours for ???
\
\ ******************************************************************************

.beamcol

IF NOT(_APPLE_VERSION)

 EQUB WHITE             \ These bytes appear to be unused - perhaps they were
 EQUB WHITE             \ going to be used to set different colours of laser
 EQUB WHITE             \ beam for the different lasers?
 EQUB WHITE

ELIF _APPLE_VERSION

 EQUB VIOLET            \ ???
 EQUB RED
 EQUB GREEN
 EQUB WHITE

ENDIF

