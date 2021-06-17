\ ******************************************************************************
\
\       Name: ship_dragon
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Dragon
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.ship_dragon

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 26192             \ Targetable area          = 161.83 * 161.83
 EQUB &4A               \ Edges data offset (low)  = &004A
 EQUB &9E               \ Faces data offset (low)  = &009E
 EQUB 65                \ Max. edge count          = (65 - 1) / 4 = 16
 EQUB 0                 \ Gun vertex               = 0
 EQUB 60                \ Explosion count          = 13, as (4 * n) + 6 = 60
 EQUB 54                \ Number of vertices       = 54 / 6 = 9
 EQUB 21                \ Number of edges          = 21
IF NOT(_ELITE_A_SHIPS_W)
 EQUW 0                 \ Bounty                   = 0
ELIF _ELITE_A_SHIPS_W
 EQUW 200               \ Bounty                   = 200
ENDIF
 EQUB 56                \ Number of faces          = 56 / 4 = 14
 EQUB 32                \ Visibility distance      = 32
IF NOT(_ELITE_A_SHIPS_W)
 EQUB 247               \ Max. energy              = 247
ELIF _ELITE_A_SHIPS_W
 EQUB 255               \ Max. energy              = 255
ENDIF
 EQUB 20                \ Max. speed               = 20
 EQUB &00               \ Edges data offset (high) = &004A
 EQUB &00               \ Faces data offset (high) = &009E
 EQUB 0                 \ Normals are scaled by    = 2^0 = 1
IF NOT(_ELITE_A_SHIPS_W)
 EQUB %01000111         \ Laser power              = 8
                        \ Missiles                 = 7

ELIF _ELITE_A_SHIPS_W
 EQUB %01001111         \ Laser power              = 9
                        \ Missiles                 = 7

ENDIF

\VERTEX    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    0,  250,    11,     6,     5,     0,         31     \ Vertex 0
 VERTEX  216,    0,  124,     7,     6,     1,     0,         31     \ Vertex 1
 VERTEX  216,    0, -124,     8,     7,     2,     1,         31     \ Vertex 2
 VERTEX    0,   40, -250,    13,    12,     3,     2,         31     \ Vertex 3
 VERTEX    0,  -40, -250,    13,    12,     9,     8,         31     \ Vertex 4
 VERTEX -216,    0, -124,    10,     9,     4,     3,         31     \ Vertex 5
 VERTEX -216,    0,  124,    11,    10,     5,     4,         31     \ Vertex 6
 VERTEX    0,   80,    0,    15,    15,    15,    15,         31     \ Vertex 7
 VERTEX    0,  -80,    0,    15,    15,    15,    15,         31     \ Vertex 8

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       1,       7,     1,     0,         31    \ Edge 0
 EDGE       2,       7,     2,     1,         31    \ Edge 1
 EDGE       3,       7,     3,     2,         31    \ Edge 2
 EDGE       5,       7,     4,     3,         31    \ Edge 3
 EDGE       6,       7,     5,     4,         31    \ Edge 4
 EDGE       0,       7,     0,     5,         31    \ Edge 5
 EDGE       1,       8,     7,     6,         31    \ Edge 6
 EDGE       2,       8,     8,     7,         31    \ Edge 7
 EDGE       4,       8,     9,     8,         31    \ Edge 8
 EDGE       5,       8,    10,     9,         31    \ Edge 9
 EDGE       6,       8,    11,    10,         31    \ Edge 10
 EDGE       0,       8,     6,    11,         31    \ Edge 11
 EDGE       0,       1,     6,     0,         31    \ Edge 12
 EDGE       1,       2,     7,     1,         31    \ Edge 13
 EDGE       5,       6,    10,     4,         31    \ Edge 14
 EDGE       0,       6,    11,     5,         31    \ Edge 15
 EDGE       2,       3,    12,     2,         31    \ Edge 16
 EDGE       2,       4,    12,     8,         31    \ Edge 17
 EDGE       3,       5,    13,     3,         31    \ Edge 18
 EDGE       4,       5,    13,     9,         31    \ Edge 19
 EDGE       3,       4,    13,    12,         31    \ Edge 20

\FACE normal_x, normal_y, normal_z, visibility
 FACE       16,       90,       28,         31    \ Face 0
 FACE       33,       90,        0,         31    \ Face 1
 FACE       25,       91,      -14,         31    \ Face 2
 FACE      -25,       91,      -14,         31    \ Face 3
 FACE      -33,       90,        0,         31    \ Face 4
 FACE      -16,       90,       28,         31    \ Face 5
 FACE       16,      -90,       28,         31    \ Face 6
 FACE       33,      -90,        0,         31    \ Face 7
 FACE       25,      -91,      -14,         31    \ Face 8
 FACE      -25,      -91,      -14,         31    \ Face 9
 FACE      -33,      -90,        0,         31    \ Face 10
 FACE      -16,      -90,       28,         31    \ Face 11
 FACE       48,        0,      -82,         31    \ Face 12
 FACE      -48,        0,      -82,         31    \ Face 13

