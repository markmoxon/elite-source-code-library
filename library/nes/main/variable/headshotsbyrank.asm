\ ******************************************************************************
\
\       Name: headShotsByRank
\       Type: Variable
\   Category: Status
\    Summary: Lookup table for headshots by rank and status condition
\
\ ******************************************************************************

.headShotsByRank

 EQUB  0,  1,  2        \ Harmless        (docked/green, yellow, red)
 EQUB  3,  4,  5        \ Mostly Harmless (docked/green, yellow, red)
 EQUB  6,  6,  7        \ Poor            (docked/green, yellow, red)
 EQUB  8,  8,  8        \ Average
 EQUB  9,  9,  9        \ Above Average
 EQUB 10, 10, 10        \ Competent
 EQUB 11, 11, 11        \ Dangerous
 EQUB 12, 12, 12        \ Deadly
 EQUB 13, 13, 13        \ Elite
 EQUB 14, 14, 14        \ Unused

