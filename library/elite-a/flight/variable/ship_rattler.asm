\ ******************************************************************************
\
\       Name: SHIP_RATTLER
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Rattler
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_RATTLER

 EQUB 2                 \ Max. canisters on demise = 2
 EQUW 6000              \ Targetable area          = 77.46 * 77.46
 EQUB &6E               \ Edges data offset (low)
 EQUB &D6               \ Faces data offset (low)
 EQUB 89                \ Max. edge count          = (89 - 1) / 4 = 22
 EQUB 0                 \ Gun vertex               = 0
 EQUB 42                \ Explosion count          = 9, as (4 * n) + 6 = 42
 EQUB 90                \ Number of vertices       = 90 / 6 = 15
 EQUB 26                \ Number of edges          = 26
 EQUW 150               \ Bounty                   = 150
 EQUB 52                \ Number of faces          = 52 / 4 = 13
 EQUB 10                \ Visibility distance      = 10
 EQUB 113               \ Max. energy              = 113
 EQUB 31                \ Max. speed               = 31
 EQUB &00               \ Edges data offset (high)
 EQUB &00               \ Faces data offset (high)
 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
 EQUB %00100010         \ Laser power              = 4
                        \ Missiles                 = 2

\VERTEX    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    0,   60,     9,     8,     3,     2,         31     \ Vertex 0
 VERTEX   40,    0,   40,    10,     9,     4,     3,         31     \ Vertex 1
 VERTEX  -40,    0,   40,     8,     7,     2,     1,         31     \ Vertex 2
 VERTEX   60,    0,    0,    11,    10,     5,     4,         31     \ Vertex 3
 VERTEX  -60,    0,    0,     7,     6,     1,     0,         31     \ Vertex 4
 VERTEX   70,    0,  -40,    12,    12,    11,     5,         31     \ Vertex 5
 VERTEX  -70,    0,  -40,    12,    12,     6,     0,         31     \ Vertex 6
 VERTEX    0,   20,  -40,    15,    15,    15,    15,         31     \ Vertex 7
 VERTEX    0,  -20,  -40,    15,    15,    15,    15,         31     \ Vertex 8
 VERTEX  -10,    6,  -40,    12,    12,    12,    12,         10     \ Vertex 9
 VERTEX  -10,   -6,  -40,    12,    12,    12,    12,         10     \ Vertex 10
 VERTEX  -20,    0,  -40,    12,    12,    12,    12,         10     \ Vertex 11
 VERTEX   10,    6,  -40,    12,    12,    12,    12,         10     \ Vertex 12
 VERTEX   10,   -6,  -40,    12,    12,    12,    12,         10     \ Vertex 13
 VERTEX   20,    0,  -40,    12,    12,    12,    12,         10     \ Vertex 14

.SHIP_RATTLER_EDGES

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       4,       6,     6,     0,         31    \ Edge 0
 EDGE       2,       4,     7,     1,         31    \ Edge 1
 EDGE       0,       2,     8,     2,         31    \ Edge 2
 EDGE       0,       1,     9,     3,         31    \ Edge 3
 EDGE       1,       3,    10,     4,         31    \ Edge 4
 EDGE       3,       5,    11,     5,         31    \ Edge 5
 EDGE       6,       7,    12,     0,         31    \ Edge 6
 EDGE       6,       8,    12,     6,         31    \ Edge 7
 EDGE       4,       7,     1,     0,         31    \ Edge 8
 EDGE       4,       8,     7,     6,         31    \ Edge 9
 EDGE       2,       7,     2,     1,         31    \ Edge 10
 EDGE       2,       8,     8,     7,         31    \ Edge 11
 EDGE       0,       7,     3,     2,         31    \ Edge 12
 EDGE       0,       8,     9,     8,         31    \ Edge 13
 EDGE       1,       7,     4,     3,         31    \ Edge 14
 EDGE       1,       8,    10,     9,         31    \ Edge 15
 EDGE       3,       7,     5,     4,         31    \ Edge 16
 EDGE       3,       8,    11,    10,         31    \ Edge 17
 EDGE       5,       7,    12,     5,         31    \ Edge 18
 EDGE       5,       8,    12,    11,         31    \ Edge 19
 EDGE       9,      10,    12,    12,         10    \ Edge 20
 EDGE      10,      11,    12,    12,         10    \ Edge 21
 EDGE      11,       9,    12,    12,         10    \ Edge 22
 EDGE      12,      13,    12,    12,         10    \ Edge 23
 EDGE      13,      14,    12,    12,         10    \ Edge 24
 EDGE      14,      12,    12,    12,         10    \ Edge 25

.SHIP_RATTLER_FACES

\FACE normal_x, normal_y, normal_z, visibility
 FACE      -26,       92,        6,         31    \ Face 0
 FACE      -23,       92,       11,         31    \ Face 1
 FACE       -9,       93,       18,         31    \ Face 2
 FACE        9,       93,       18,         31    \ Face 3
 FACE       23,       92,       11,         31    \ Face 4
 FACE       26,       92,        6,         31    \ Face 5
 FACE      -26,      -92,        6,         31    \ Face 6
 FACE      -23,      -92,       11,         31    \ Face 7
 FACE       -9,      -93,       18,         31    \ Face 8
 FACE        9,      -93,       18,         31    \ Face 9
 FACE       23,      -92,       11,         31    \ Face 10
 FACE       26,      -92,        6,         31    \ Face 11
 FACE        0,        0,      -96,         31    \ Face 12

