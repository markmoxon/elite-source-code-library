\ ******************************************************************************
\
\       Name: SHIP_BUSHMASTER
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Bushmaster
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_BUSHMASTER

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 4250              \ Targetable area          = 65.19 * 65.19

 EQUB LO(SHIP_BUSHMASTER_EDGES - SHIP_BUSHMASTER)  \ Edges data offset (low)
 EQUB LO(SHIP_BUSHMASTER_FACES - SHIP_BUSHMASTER)  \ Faces data offset (low)

 EQUB 81                \ Max. edge count          = (81 - 1) / 4 = 20
 EQUB 0                 \ Gun vertex               = 0
 EQUB 30                \ Explosion count          = 6, as (4 * n) + 6 = 30
 EQUB 72                \ Number of vertices       = 72 / 6 = 12
 EQUB 19                \ Number of edges          = 19
IF NOT(_ELITE_A_SHIPS_S)
 EQUW 150               \ Bounty                   = 150
ELIF _ELITE_A_SHIPS_S
 EQUW 250               \ Bounty                   = 250
ENDIF
 EQUB 36                \ Number of faces          = 36 / 4 = 9
 EQUB 20                \ Visibility distance      = 20
 EQUB 74                \ Max. energy              = 74
 EQUB 35                \ Max. speed               = 35

 EQUB HI(SHIP_BUSHMASTER_EDGES - SHIP_BUSHMASTER)  \ Edges data offset (high)
 EQUB HI(SHIP_BUSHMASTER_FACES - SHIP_BUSHMASTER)  \ Faces data offset (high)

 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
IF NOT(_ELITE_A_SHIPS_S)
 EQUB %00100001         \ Laser power              = 4
                        \ Missiles                 = 1

ELIF _ELITE_A_SHIPS_S
 EQUB %00101001         \ Laser power              = 5
                        \ Missiles                 = 1

ENDIF

.SHIP_BUSHMASTER_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    0,   60,     3,     2,     1,     0,         31     \ Vertex 0
 VERTEX   50,    0,   20,     7,     5,     3,     1,         31     \ Vertex 1
 VERTEX  -50,    0,   20,     6,     4,     2,     0,         31     \ Vertex 2
 VERTEX    0,   20,    0,     5,     4,     1,     0,         31     \ Vertex 3
 VERTEX    0,  -20,  -40,    15,    15,    15,    15,         31     \ Vertex 4
 VERTEX    0,   14,  -40,     8,     8,     5,     4,         31     \ Vertex 5
 VERTEX   40,    0,  -40,     8,     8,     7,     5,         31     \ Vertex 6
 VERTEX  -40,    0,  -40,     8,     8,     6,     4,         31     \ Vertex 7
 VERTEX    0,    4,  -40,     8,     8,     8,     8,         10     \ Vertex 8
 VERTEX   10,    0,  -40,     8,     8,     8,     8,         10     \ Vertex 9
 VERTEX    0,   -4,  -40,     8,     8,     8,     8,         10     \ Vertex 10
 VERTEX  -10,    0,  -40,     8,     8,     8,     8,         10     \ Vertex 11

.SHIP_BUSHMASTER_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     3,     1,         31    \ Edge 0
 EDGE       0,       2,     2,     0,         31    \ Edge 1
 EDGE       0,       3,     1,     0,         31    \ Edge 2
 EDGE       0,       4,     3,     2,         31    \ Edge 3
 EDGE       3,       5,     5,     4,         31    \ Edge 4
 EDGE       2,       3,     4,     0,         31    \ Edge 5
 EDGE       1,       3,     5,     1,         31    \ Edge 6
 EDGE       2,       7,     6,     4,         31    \ Edge 7
 EDGE       1,       6,     7,     5,         31    \ Edge 8
 EDGE       2,       4,     6,     2,         31    \ Edge 9
 EDGE       1,       4,     7,     3,         31    \ Edge 10
 EDGE       5,       7,     8,     4,         31    \ Edge 11
 EDGE       5,       6,     8,     5,         31    \ Edge 12
 EDGE       4,       7,     8,     6,         31    \ Edge 13
 EDGE       4,       6,     8,     7,         31    \ Edge 14
 EDGE       8,       9,     8,     8,         10    \ Edge 15
 EDGE       9,      10,     8,     8,         10    \ Edge 16
 EDGE      10,      11,     8,     8,         10    \ Edge 17
 EDGE      11,       8,     8,     8,         10    \ Edge 18

.SHIP_BUSHMASTER_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE      -23,       88,       29,         31      \ Face 0
 FACE       23,       88,       29,         31      \ Face 1
 FACE      -14,      -93,       18,         31      \ Face 2
 FACE       14,      -93,       18,         31      \ Face 3
 FACE      -31,       89,      -13,         31      \ Face 4
 FACE       31,       89,      -13,         31      \ Face 5
 FACE      -42,      -85,       -7,         31      \ Face 6
 FACE       42,      -85,       -7,         31      \ Face 7
 FACE        0,        0,      -96,         31      \ Face 8

