\ ******************************************************************************
\
\       Name: beamcol
\       Type: Variable
\   Category: Drawing lines
\    Summary: An unused table of laser colours
\
\ ******************************************************************************

.beamcol

IF NOT(_APPLE_VERSION)

 EQUB WHITE             \ These bytes appear to be unused - perhaps they were
 EQUB WHITE             \ going to be used to set different colours of laser
 EQUB WHITE             \ beam for the different lasers?
 EQUB WHITE

ELIF _APPLE_VERSION

 EQUB VIOLET            \ These bytes appear to be unused - perhaps they were
 EQUB RED               \ going to be used to set different colours of laser
 EQUB GREEN             \ beam for the different lasers?
 EQUB WHITE

ENDIF

