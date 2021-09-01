\ ******************************************************************************
\
\       Name: SHIP_SHUTTLE_MK_2
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Shuttle Mk II
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_SHUTTLE_MK_2

 EQUB 15                \ Max. canisters on demise = 15
 EQUW 50 * 50           \ Targetable area          = 50 * 50
 EQUB LO(SHIP_SHUTTLE_MK_2_EDGES - SHIP_SHUTTLE_MK_2) \ Edges data offset (low)
 EQUB LO(SHIP_SHUTTLE_MK_2_FACES - SHIP_SHUTTLE_MK_2) \ Faces data offset (low)
 EQUB 89                \ Max. edge count          = (89 - 1) / 4 = 22
 EQUB 0                 \ Gun vertex               = 0
 EQUB 38                \ Explosion count          = 8, as (4 * n) + 6 = 38
 EQUB 102               \ Number of vertices       = 102 / 6 = 17
 EQUB 28                \ Number of edges          = 28
 EQUW 0                 \ Bounty                   = 0
 EQUB 52                \ Number of faces          = 52 / 4 = 13
 EQUB 10                \ Visibility distance      = 10
 EQUB 32                \ Max. energy              = 32
 EQUB 9                 \ Max. speed               = 9
 EQUB HI(SHIP_SHUTTLE_MK_2_EDGES - SHIP_SHUTTLE_MK_2) \ Edges data offset (high)
 EQUB HI(SHIP_SHUTTLE_MK_2_FACES - SHIP_SHUTTLE_MK_2) \ Faces data offset (high)
 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

\VERTEX    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    0,   40,     3,     2,     1,     0,         31     \ Vertex 0
 VERTEX    0,   20,   30,     4,     3,     0,     0,         31     \ Vertex 1
 VERTEX  -20,    0,   30,     5,     1,     0,     0,         31     \ Vertex 2
 VERTEX    0,  -20,   30,     6,     2,     1,     1,         31     \ Vertex 3
 VERTEX   20,    0,   30,     7,     3,     2,     2,         31     \ Vertex 4
 VERTEX  -20,   20,   20,     8,     5,     4,     0,         31     \ Vertex 5
 VERTEX  -20,  -20,   20,     9,     6,     5,     1,         31     \ Vertex 6
 VERTEX   20,  -20,   20,    10,     7,     6,     2,         31     \ Vertex 7
 VERTEX   20,   20,   20,    11,     7,     4,     3,         31     \ Vertex 8
 VERTEX    0,   20,  -40,    12,    11,     8,     4,         31     \ Vertex 9
 VERTEX  -20,    0,  -40,    12,     9,     8,     5,         31     \ Vertex 10
 VERTEX    0,  -20,  -40,    12,    10,     9,     6,         31     \ Vertex 11
 VERTEX   20,    0,  -40,    12,    11,    10,     7,         31     \ Vertex 12
 VERTEX   -4,    4,  -40,    12,    12,    12,    12,         10     \ Vertex 13
 VERTEX   -4,   -4,  -40,    12,    12,    12,    12,         10     \ Vertex 14
 VERTEX    4,   -4,  -40,    12,    12,    12,    12,         10     \ Vertex 15
 VERTEX    4,    4,  -40,    12,    12,    12,    12,         10     \ Vertex 16

.SHIP_SHUTTLE_MK_2_EDGES

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       2,     1,     0,         31    \ Edge 0
 EDGE       0,       3,     2,     1,         31    \ Edge 1
 EDGE       0,       4,     3,     2,         31    \ Edge 2
 EDGE       0,       1,     0,     3,         31    \ Edge 3
 EDGE       1,       5,     4,     0,         31    \ Edge 4
 EDGE       2,       5,     5,     0,         31    \ Edge 5
 EDGE       2,       6,     5,     1,         31    \ Edge 6
 EDGE       3,       6,     6,     1,         31    \ Edge 7
 EDGE       3,       7,     6,     2,         31    \ Edge 8
 EDGE       4,       7,     7,     2,         31    \ Edge 9
 EDGE       4,       8,     7,     3,         31    \ Edge 10
 EDGE       1,       8,     4,     3,         31    \ Edge 11
 EDGE       5,       9,     8,     4,         31    \ Edge 12
 EDGE       5,      10,     8,     5,         31    \ Edge 13
 EDGE       6,      10,     9,     5,         31    \ Edge 14
 EDGE       6,      11,     9,     6,         31    \ Edge 15
 EDGE       7,      11,    10,     6,         31    \ Edge 16
 EDGE       7,      12,    10,     7,         31    \ Edge 17
 EDGE       8,      12,    11,     7,         31    \ Edge 18
 EDGE       8,       9,    11,     4,         31    \ Edge 19
 EDGE       9,      10,    12,     8,         31    \ Edge 20
 EDGE      10,      11,    12,     9,         31    \ Edge 21
 EDGE      11,      12,    12,    10,         31    \ Edge 22
 EDGE      12,       9,    12,    11,         31    \ Edge 23
 EDGE      13,      14,    12,    12,         10    \ Edge 24
 EDGE      14,      15,    12,    12,         10    \ Edge 25
 EDGE      15,      16,    12,    12,         10    \ Edge 26
 EDGE      16,      13,    12,    12,         10    \ Edge 27

.SHIP_SHUTTLE_MK_2_FACES

\FACE normal_x, normal_y, normal_z, visibility
 FACE      -39,       39,       78,         31    \ Face 0
 FACE      -39,      -39,       78,         31    \ Face 1
 FACE       39,      -39,       78,         31    \ Face 2
 FACE       39,       39,       78,         31    \ Face 3
 FACE        0,       96,        0,         31    \ Face 4
 FACE      -96,        0,        0,         31    \ Face 5
 FACE        0,      -96,        0,         31    \ Face 6
 FACE       96,        0,        0,         31    \ Face 7
 FACE      -66,       66,      -22,         31    \ Face 8
 FACE      -66,      -66,      -22,         31    \ Face 9
 FACE       66,      -66,      -22,         31    \ Face 10
 FACE       66,       66,      -22,         31    \ Face 11
 FACE        0,        0,      -96,         31    \ Face 12

