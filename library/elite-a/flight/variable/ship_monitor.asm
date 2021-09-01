\ ******************************************************************************
\
\       Name: SHIP_MONITOR
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Monitor
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_MONITOR

 EQUB 4                 \ Max. canisters on demise = 4
 EQUW 13824             \ Targetable area          = 117.57 * 117.57
 EQUB &7A               \ Edges data offset (low)
 EQUB &D6               \ Faces data offset (low)
 EQUB 101               \ Max. edge count          = (101 - 1) / 4 = 25
 EQUB 0                 \ Gun vertex               = 0
 EQUB 42                \ Explosion count          = 9, as (4 * n) + 6 = 42
 EQUB 102               \ Number of vertices       = 102 / 6 = 17
 EQUB 23                \ Number of edges          = 23
IF NOT(_ELITE_A_SHIPS_S)
 EQUW 400               \ Bounty                   = 400
ELIF _ELITE_A_SHIPS_S
 EQUW 500               \ Bounty                   = 500
ENDIF
 EQUB 44                \ Number of faces          = 44 / 4 = 11
 EQUB 40                \ Visibility distance      = 40
IF NOT(_ELITE_A_SHIPS_S)
 EQUB 132               \ Max. energy              = 132
ELIF _ELITE_A_SHIPS_S
 EQUB 133               \ Max. energy              = 133
ENDIF
 EQUB 16                \ Max. speed               = 16
 EQUB &00               \ Edges data offset (high)
 EQUB &00               \ Faces data offset (high)
 EQUB 0                 \ Normals are scaled by    = 2^0 = 1
 EQUB %00110111         \ Laser power              = 6
                        \ Missiles                 = 7

\VERTEX    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,   10,  140,    15,    15,    15,    15,         31     \ Vertex 0
 VERTEX   20,   40,  -20,     3,     2,     1,     0,         31     \ Vertex 1
 VERTEX  -20,   40,  -20,     0,     5,     4,     3,         31     \ Vertex 2
 VERTEX   50,    0,   10,     8,     7,     2,     1,         31     \ Vertex 3
 VERTEX  -50,    0,   10,     6,     9,     5,     4,         31     \ Vertex 4
 VERTEX   30,    4,  -60,    10,    10,     8,     2,         31     \ Vertex 5
 VERTEX  -30,    4,  -60,    10,    10,     9,     4,         31     \ Vertex 6
 VERTEX   18,   20,  -60,    10,    10,     3,     2,         31     \ Vertex 7
 VERTEX  -18,   20,  -60,    10,    10,     4,     3,         31     \ Vertex 8
 VERTEX    0,  -20,  -60,    10,    10,     9,     8,         31     \ Vertex 9
 VERTEX    0,  -40,   10,     9,     8,     7,     6,         31     \ Vertex 10
 VERTEX    0,   34,   10,     0,     0,     0,     0,         10     \ Vertex 11
 VERTEX    0,   26,   50,     0,     0,     0,     0,         10     \ Vertex 12
 VERTEX   20,  -10,   60,     7,     7,     7,     7,         10     \ Vertex 13
 VERTEX   10,    0,  100,     7,     7,     7,     7,         10     \ Vertex 14
 VERTEX  -20,  -10,   60,     6,     6,     6,     6,         10     \ Vertex 15
 VERTEX  -10,    0,  100,     6,     6,     6,     6,         10     \ Vertex 16

.SHIP_MONITOR_EDGES

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     1,     0,         31    \ Edge 0
 EDGE       1,       3,     2,     1,         31    \ Edge 1
 EDGE       1,       7,     3,     2,         31    \ Edge 2
 EDGE       2,       8,     4,     3,         31    \ Edge 3
 EDGE       2,       4,     5,     4,         31    \ Edge 4
 EDGE       0,       2,     0,     5,         31    \ Edge 5
 EDGE       1,       2,     3,     0,         31    \ Edge 6
 EDGE       0,      10,     7,     6,         31    \ Edge 7
 EDGE       3,      10,     8,     7,         31    \ Edge 8
 EDGE       9,      10,     9,     8,         31    \ Edge 9
 EDGE       4,      10,     6,     9,         31    \ Edge 10
 EDGE       0,       3,     7,     1,         31    \ Edge 11
 EDGE       3,       5,     8,     2,         31    \ Edge 12
 EDGE       6,       4,     9,     4,         31    \ Edge 13
 EDGE       4,       0,     6,     5,         31    \ Edge 14
 EDGE       7,       5,    10,     2,         31    \ Edge 15
 EDGE       8,       7,    10,     3,         31    \ Edge 16
 EDGE       8,       6,    10,     4,         31    \ Edge 17
 EDGE       5,       9,    10,     8,         31    \ Edge 18
 EDGE       6,       9,    10,     9,         31    \ Edge 19
 EDGE      11,      12,     0,     0,         10    \ Edge 20
 EDGE      13,      14,     7,     7,         10    \ Edge 21
 EDGE      15,      16,     6,     6,         10    \ Edge 22

.SHIP_MONITOR_FACES

\FACE normal_x, normal_y, normal_z, visibility
 FACE        0,       62,       11,         31    \ Face 0
 FACE       44,       43,       13,         31    \ Face 1
 FACE       54,       28,      -16,         31    \ Face 2
 FACE        0,       57,      -28,         31    \ Face 3
 FACE      -54,       28,      -16,         31    \ Face 4
 FACE      -44,       43,       13,         31    \ Face 5
 FACE      -38,      -47,       18,         31    \ Face 6
 FACE       38,      -47,       18,         31    \ Face 7
 FACE       39,      -48,      -13,         31    \ Face 8
 FACE      -39,      -48,      -13,         31    \ Face 9
 FACE        0,        0,      -64,         31    \ Face 10

