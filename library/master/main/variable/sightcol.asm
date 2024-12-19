\ ******************************************************************************
\
\       Name: sightcol
\       Type: Variable
\   Category: Drawing lines
\    Summary: Colours for the crosshair sights on the different laser types
IF _C64_VERSION
\  Deep dive: Sprite usage in Commodore 64 Elite
ENDIF
\
\ ******************************************************************************

.sightcol

IF NOT(_C64_VERSION OR _APPLE_VERSION)

 EQUB YELLOW            \ Pulse lasers have yellow sights

 EQUB CYAN              \ Beam lasers have cyan sights

 EQUB CYAN              \ Military lasers have cyan sights

 EQUB YELLOW            \ Mining lasers have yellow sights

ELIF _C64_VERSION

 EQUB 7                 ; Pulse lasers have yellow sights

 EQUB 7                 ; Beam lasers have yellow sights

 EQUB 13                ; Military lasers have light green sights

 EQUB 4                 ; Mining lasers have purple sights

ELIF _APPLE_VERSION

 EQUB BLUE              \ Pulse lasers have blue sights

 EQUB RED               \ Beam lasers have red sights

 EQUB WHITE             \ Military lasers have white sights

 EQUB WHITE             \ Mining lasers have white sights

ENDIF

