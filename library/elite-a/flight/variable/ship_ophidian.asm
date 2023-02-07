\ ******************************************************************************
\
\       Name: SHIP_OPHIDIAN
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for an Ophidian
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_OPHIDIAN

 EQUB 2                 \ Max. canisters on demise = 2
 EQUW 3720              \ Targetable area          = 60.99 * 60.99
 EQUB LO(SHIP_OPHIDIAN_EDGES - SHIP_OPHIDIAN)      \ Edges data offset (low)
 EQUB LO(SHIP_OPHIDIAN_FACES - SHIP_OPHIDIAN)      \ Faces data offset (low)
 EQUB 113               \ Max. edge count          = (113 - 1) / 4 = 28
 EQUB 0                 \ Gun vertex               = 0
 EQUB 60                \ Explosion count          = 13, as (4 * n) + 6 = 60
 EQUB 120               \ Number of vertices       = 120 / 6 = 20
 EQUB 30                \ Number of edges          = 30
 EQUW 50                \ Bounty                   = 50
 EQUB 48                \ Number of faces          = 48 / 4 = 12
 EQUB 20                \ Visibility distance      = 20
 EQUB 64                \ Max. energy              = 64
 EQUB 34                \ Max. speed               = 34
 EQUB HI(SHIP_OPHIDIAN_EDGES - SHIP_OPHIDIAN)      \ Edges data offset (high)
 EQUB HI(SHIP_OPHIDIAN_FACES - SHIP_OPHIDIAN)      \ Faces data offset (high)
 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
 EQUB %00011010         \ Laser power              = 3
                        \ Missiles                 = 2

\          x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX  -20,    0,   70,     8,     6,     2,     0,         31     \ Vertex 0
 VERTEX   20,    0,   70,     7,     6,     1,     0,         31     \ Vertex 1
 VERTEX    0,   10,   40,     2,     2,     1,     0,         31     \ Vertex 2
 VERTEX  -30,    0,   30,    10,     8,     4,     2,         31     \ Vertex 3
 VERTEX   30,    0,   30,     9,     7,     3,     1,         31     \ Vertex 4
 VERTEX    0,   16,   10,    15,    15,    15,    15,         31     \ Vertex 5
 VERTEX   20,   10,  -50,    11,     9,     5,     3,         31     \ Vertex 6
 VERTEX  -20,   10,  -50,    11,    10,     5,     4,         31     \ Vertex 7
 VERTEX  -30,    0,  -50,    11,    11,    10,     4,         31     \ Vertex 8
 VERTEX  -40,    0,  -50,    15,    15,    15,    15,         16     \ Vertex 9
 VERTEX  -30,    0,  -30,    15,    15,    15,    15,         16     \ Vertex 10
 VERTEX   30,    0,  -50,    11,    11,     9,     3,         31     \ Vertex 11
 VERTEX   40,    0,  -50,    15,    15,    15,    15,         16     \ Vertex 12
 VERTEX   30,    0,  -30,    15,    15,    15,    15,         16     \ Vertex 13
 VERTEX    0,  -10,  -50,    11,    11,    10,     9,         31     \ Vertex 14
 VERTEX    0,  -16,   20,    15,    15,    15,    15,         31     \ Vertex 15
 VERTEX   10,    4,  -50,    11,    11,    11,    11,         16     \ Vertex 16
 VERTEX   10,   -2,  -50,    11,    11,    11,    11,         16     \ Vertex 17
 VERTEX  -10,   -2,  -50,    11,    11,    11,    11,         16     \ Vertex 18
 VERTEX  -10,    4,  -50,    11,    11,    11,    11,         16     \ Vertex 19

.SHIP_OPHIDIAN_EDGES

\     vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     6,     0,         31    \ Edge 0
 EDGE       1,       2,     1,     0,         31    \ Edge 1
 EDGE       0,       2,     2,     0,         31    \ Edge 2
 EDGE       2,       5,     2,     1,         31    \ Edge 3
 EDGE       4,       5,     3,     1,         31    \ Edge 4
 EDGE       3,       5,     4,     2,         31    \ Edge 5
 EDGE       5,       6,     5,     3,         31    \ Edge 6
 EDGE       5,       7,     5,     4,         31    \ Edge 7
 EDGE       0,       3,     8,     2,         31    \ Edge 8
 EDGE       1,       4,     7,     1,         31    \ Edge 9
 EDGE       4,      11,     9,     3,         31    \ Edge 10
 EDGE       3,       8,    10,     4,         31    \ Edge 11
 EDGE       1,      15,     7,     6,         31    \ Edge 12
 EDGE       0,      15,     8,     6,         31    \ Edge 13
 EDGE       4,      15,     9,     7,         31    \ Edge 14
 EDGE       3,      15,    10,     8,         31    \ Edge 15
 EDGE      14,      15,    10,     9,         31    \ Edge 16
 EDGE       6,       7,    11,     5,         31    \ Edge 17
 EDGE       6,      11,    11,     3,         31    \ Edge 18
 EDGE       7,       8,    11,     4,         31    \ Edge 19
 EDGE      11,      14,    11,     9,         31    \ Edge 20
 EDGE       8,      14,    11,    10,         31    \ Edge 21
 EDGE      16,      17,    11,    11,         16    \ Edge 22
 EDGE      17,      18,    11,    11,         16    \ Edge 23
 EDGE      18,      19,    11,    11,         16    \ Edge 24
 EDGE      19,      16,    11,    11,         16    \ Edge 25
 EDGE      12,      13,     9,     3,         16    \ Edge 26
 EDGE      11,      12,     9,     3,         16    \ Edge 27
 EDGE      10,       9,    10,     4,         16    \ Edge 28
 EDGE       9,       8,    10,     4,         16    \ Edge 29

.SHIP_OPHIDIAN_FACES

\     normal_x, normal_y, normal_z, visibility
 FACE        0,       37,       12,         31    \ Face 0
 FACE       11,       28,        5,         31    \ Face 1
 FACE      -11,       28,        5,         31    \ Face 2
 FACE       16,       34,        2,         31    \ Face 3
 FACE      -16,       34,        2,         31    \ Face 4
 FACE        0,       37,       -3,         31    \ Face 5
 FACE        0,      -31,       10,         31    \ Face 6
 FACE       10,      -20,        2,         31    \ Face 7
 FACE      -10,      -20,        2,         31    \ Face 8
 FACE       18,      -32,       -2,         31    \ Face 9
 FACE      -18,      -32,       -2,         31    \ Face 10
 FACE        0,        0,      -37,         31    \ Face 11

