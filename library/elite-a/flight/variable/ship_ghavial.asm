\ ******************************************************************************
\
\       Name: SHIP_GHAVIAL
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Ghavial
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_GHAVIAL

 EQUB 3                 \ Max. canisters on demise = 3
 EQUW 9728              \ Targetable area          = 98.63 * 98.63
 EQUB LO(SHIP_GHAVIAL_EDGES - SHIP_GHAVIAL)        \ Edges data offset (low)
 EQUB LO(SHIP_GHAVIAL_FACES - SHIP_GHAVIAL)        \ Faces data offset (low)
 EQUB 97                \ Max. edge count          = (97 - 1) / 4 = 24
 EQUB 0                 \ Gun vertex               = 0
 EQUB 34                \ Explosion count          = 7, as (4 * n) + 6 = 34
 EQUB 72                \ Number of vertices       = 72 / 6 = 12
 EQUB 22                \ Number of edges          = 22
IF NOT(_ELITE_A_SHIPS_S OR _ELITE_A_SHIPS_U)
 EQUW 100               \ Bounty                   = 100
ELIF _ELITE_A_SHIPS_S OR _ELITE_A_SHIPS_U
 EQUW 300               \ Bounty                   = 300
ENDIF
 EQUB 48                \ Number of faces          = 48 / 4 = 12
 EQUB 10                \ Visibility distance      = 10
IF NOT(_ELITE_A_SHIPS_S OR _ELITE_A_SHIPS_U)
 EQUB 114               \ Max. energy              = 114
ELIF _ELITE_A_SHIPS_S
 EQUB 123               \ Max. energy              = 123
ELIF _ELITE_A_SHIPS_U
 EQUB 115               \ Max. energy              = 115
ENDIF
 EQUB 16                \ Max. speed               = 16
 EQUB HI(SHIP_GHAVIAL_EDGES - SHIP_GHAVIAL)        \ Edges data offset (high)
 EQUB HI(SHIP_GHAVIAL_FACES - SHIP_GHAVIAL)        \ Faces data offset (high)
 EQUB 0                 \ Normals are scaled by    = 2^0 = 1
IF NOT(_ELITE_A_SHIPS_U)
 EQUB %00100111         \ Laser power              = 4
                        \ Missiles                 = 7

ELIF _ELITE_A_SHIPS_U
 EQUB %00101111         \ Laser power              = 5
                        \ Missiles                 = 7

ENDIF

\VERTEX    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX   30,    0,  100,     7,     6,     1,     0,         31     \ Vertex 0
 VERTEX  -30,    0,  100,    11,     6,     5,     0,         31     \ Vertex 1
 VERTEX   40,   30,  -26,     3,     2,     1,     0,         31     \ Vertex 2
 VERTEX  -40,   30,  -26,     5,     4,     3,     0,         31     \ Vertex 3
 VERTEX   60,    0,  -20,     8,     7,     2,     1,         31     \ Vertex 4
 VERTEX   40,    0,  -60,     9,     8,     3,     2,         31     \ Vertex 5
 VERTEX  -60,    0,  -20,    11,    10,     5,     4,         31     \ Vertex 6
 VERTEX  -40,    0,  -60,    10,     9,     4,     3,         31     \ Vertex 7
 VERTEX    0,  -30,  -20,    15,    15,    15,    15,         31     \ Vertex 8
 VERTEX   10,   24,    0,     0,     0,     0,     0,          9     \ Vertex 9
 VERTEX  -10,   24,    0,     0,     0,     0,     0,          9     \ Vertex 10
 VERTEX    0,   22,   10,     0,     0,     0,     0,          9     \ Vertex 11

.SHIP_GHAVIAL_EDGES

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       2,     1,     0,         31    \ Edge 0
 EDGE       4,       2,     2,     1,         31    \ Edge 1
 EDGE       5,       2,     3,     2,         31    \ Edge 2
 EDGE       3,       2,     0,     3,         31    \ Edge 3
 EDGE       7,       3,     4,     3,         31    \ Edge 4
 EDGE       6,       3,     5,     4,         31    \ Edge 5
 EDGE       3,       1,     0,     5,         31    \ Edge 6
 EDGE       0,       8,     7,     6,         31    \ Edge 7
 EDGE       4,       8,     8,     7,         31    \ Edge 8
 EDGE       5,       8,     9,     8,         31    \ Edge 9
 EDGE       7,       8,    10,     9,         31    \ Edge 10
 EDGE       6,       8,    11,    10,         31    \ Edge 11
 EDGE       1,       8,     6,    11,         31    \ Edge 12
 EDGE       1,       0,     6,     0,         31    \ Edge 13
 EDGE       0,       4,     7,     1,         31    \ Edge 14
 EDGE       4,       5,     8,     2,         31    \ Edge 15
 EDGE       5,       7,     9,     3,         31    \ Edge 16
 EDGE       7,       6,    10,     4,         31    \ Edge 17
 EDGE       6,       1,    11,     5,         31    \ Edge 18
 EDGE       9,      10,     0,     0,          9    \ Edge 19
 EDGE      10,      11,     0,     0,          9    \ Edge 20
 EDGE      11,       9,     0,     0,          9    \ Edge 21

.SHIP_GHAVIAL_FACES

\FACE normal_x, normal_y, normal_z, visibility
 FACE        0,       62,       14,         31    \ Face 0
 FACE       51,       36,       12,         31    \ Face 1
 FACE       51,       28,      -25,         31    \ Face 2
 FACE        0,       48,      -42,         31    \ Face 3
 FACE      -51,       28,      -25,         31    \ Face 4
 FACE      -51,       36,       12,         31    \ Face 5
 FACE        0,      -62,       15,         31    \ Face 6
 FACE       28,      -56,        7,         31    \ Face 7
 FACE       27,      -55,      -13,         31    \ Face 8
 FACE        0,      -51,      -38,         31    \ Face 9
 FACE      -27,      -55,      -13,         31    \ Face 10
 FACE      -28,      -56,        7,         31    \ Face 11

