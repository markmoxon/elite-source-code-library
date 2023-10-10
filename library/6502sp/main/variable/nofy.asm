\ ******************************************************************************
\
\       Name: NOFY
\       Type: Variable
IF NOT(_NES_VERSION)
\   Category: Demo
ELIF _NES_VERSION
\   Category: Combat demo
ENDIF
\    Summary: The y-coordinates of the scroll text letter grid
\
\ ******************************************************************************

.NOFY

 EQUB 0                 \ Grid points 0-2
 EQUB 0
 EQUB 0

 EQUB WY                \ Grid points 3-5
 EQUB WY
 EQUB WY

 EQUB 2*WY              \ Grid points 6-8
 EQUB 2*WY
 EQUB 2*WY

IF NOT(_NES_VERSION)

 EQUB 2.5*WY            \ Grid points 9-B
 EQUB 2.5*WY
 EQUB 2.5*WY

ELIF _NES_VERSION

 EQUB 3*WY              \ Grid points 9-B
 EQUB 3*WY
 EQUB 3*WY

ENDIF

