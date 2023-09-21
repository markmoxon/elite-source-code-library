\ ******************************************************************************
\
\       Name: NOFX
\       Type: Variable
\   Category: Demo
\    Summary: The x-coordinates of the scroll text letter grid
\
\ ******************************************************************************

.NOFX

IF NOT(_NES_VERSION)

 EQUB 4                 \ Grid points 0-2
 EQUB 8
 EQUB 12

 EQUB 4                 \ Grid points 3-5
 EQUB 8
 EQUB 12

 EQUB 4                 \ Grid points 6-8
 EQUB 8
 EQUB 12

 EQUB 4                 \ Grid points 9-B
 EQUB 8
 EQUB 12

ELIF _NES_VERSION

 EQUB 1                 \ Grid points 0-2
 EQUB 2
 EQUB 3

 EQUB 1                 \ Grid points 3-5
 EQUB 2
 EQUB 3

 EQUB 1                 \ Grid points 6-8
 EQUB 2
 EQUB 3

 EQUB 1                 \ Grid points 9-B
 EQUB 2
 EQUB 3

ENDIF


