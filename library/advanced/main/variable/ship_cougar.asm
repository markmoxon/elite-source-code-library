\ ******************************************************************************
\
\       Name: SHIP_COUGAR
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Cougar
\  Deep dive: Ship blueprints
\             The elusive Cougar
\
\ ******************************************************************************

.SHIP_COUGAR

 EQUB 3                 \ Max. canisters on demise = 3
 EQUW 70 * 70           \ Targetable area          = 70 * 70
 EQUB LO(SHIP_COUGAR_EDGES - SHIP_COUGAR)          \ Edges data offset (low)
 EQUB LO(SHIP_COUGAR_FACES - SHIP_COUGAR)          \ Faces data offset (low)
 EQUB 105               \ Max. edge count          = (105 - 1) / 4 = 26
 EQUB 0                 \ Gun vertex               = 0
 EQUB 42                \ Explosion count          = 9, as (4 * n) + 6 = 42
 EQUB 114               \ Number of vertices       = 114 / 6 = 19
 EQUB 25                \ Number of edges          = 25
 EQUW 0                 \ Bounty                   = 0
 EQUB 24                \ Number of faces          = 24 / 4 = 6
 EQUB 34                \ Visibility distance      = 34
 EQUB 252               \ Max. energy              = 252
 EQUB 40                \ Max. speed               = 40
 EQUB HI(SHIP_COUGAR_EDGES - SHIP_COUGAR)          \ Edges data offset (high)
 EQUB HI(SHIP_COUGAR_FACES - SHIP_COUGAR)          \ Faces data offset (high)
 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00110100         \ Laser power              = 6
                        \ Missiles                 = 4

\VERTEX    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    5,   67,     2,      0,    4,     4,         31    \ Vertex 0
 VERTEX  -20,    0,   40,     1,      0,    2,     2,         31    \ Vertex 1
 VERTEX  -40,    0,  -40,     1,      0,    5,     5,         31    \ Vertex 2
 VERTEX    0,   14,  -40,     4,      0,    5,     5,         30    \ Vertex 3
 VERTEX    0,  -14,  -40,     2,      1,    5,     3,         30    \ Vertex 4
 VERTEX   20,    0,   40,     3,      2,    4,     4,         31    \ Vertex 5
 VERTEX   40,    0,  -40,     4,      3,    5,     5,         31    \ Vertex 6
 VERTEX  -36,    0,   56,     1,      0,    1,     1,         31    \ Vertex 7
 VERTEX  -60,    0,  -20,     1,      0,    1,     1,         31    \ Vertex 8
 VERTEX   36,    0,   56,     4,      3,    4,     4,         31    \ Vertex 9
 VERTEX   60,    0,  -20,     4,      3,    4,     4,         31    \ Vertex 10
 VERTEX    0,    7,   35,     0,      0,    4,     4,         18    \ Vertex 11
 VERTEX    0,    8,   25,     0,      0,    4,     4,         20    \ Vertex 12
 VERTEX  -12,    2,   45,     0,      0,    0,     0,         20    \ Vertex 13
 VERTEX   12,    2,   45,     4,      4,    4,     4,         20    \ Vertex 14
 VERTEX  -10,    6,  -40,     5,      5,    5,     5,         20    \ Vertex 15
 VERTEX  -10,   -6,  -40,     5,      5,    5,     5,         20    \ Vertex 16
 VERTEX   10,   -6,  -40,     5,      5,    5,     5,         20    \ Vertex 17
 VERTEX   10,    6,  -40,     5,      5,    5,     5,         20    \ Vertex 18

.SHIP_COUGAR_EDGES

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     2,     0,         31    \ Edge 0
 EDGE       1,       7,     1,     0,         31    \ Edge 1
 EDGE       7,       8,     1,     0,         31    \ Edge 2
 EDGE       8,       2,     1,     0,         31    \ Edge 3
 EDGE       2,       3,     5,     0,         30    \ Edge 4
 EDGE       3,       6,     5,     4,         30    \ Edge 5
 EDGE       2,       4,     5,     1,         30    \ Edge 6
 EDGE       4,       6,     5,     3,         30    \ Edge 7
 EDGE       6,      10,     4,     3,         31    \ Edge 8
 EDGE      10,       9,     4,     3,         31    \ Edge 9
 EDGE       9,       5,     4,     3,         31    \ Edge 10
 EDGE       5,       0,     4,     2,         31    \ Edge 11
 EDGE       0,       3,     4,     0,         27    \ Edge 12
 EDGE       1,       4,     2,     1,         27    \ Edge 13
 EDGE       5,       4,     3,     2,         27    \ Edge 14
 EDGE       1,       2,     1,     0,         26    \ Edge 15
 EDGE       5,       6,     4,     3,         26    \ Edge 16
 EDGE      12,      13,     0,     0,         20    \ Edge 17
 EDGE      13,      11,     0,     0,         18    \ Edge 18
 EDGE      11,      14,     4,     4,         18    \ Edge 19
 EDGE      14,      12,     4,     4,         20    \ Edge 20
 EDGE      15,      16,     5,     5,         18    \ Edge 21
 EDGE      16,      18,     5,     5,         20    \ Edge 22
 EDGE      18,      17,     5,     5,         18    \ Edge 23
 EDGE      17,      15,     5,     5,         20    \ Edge 24

.SHIP_COUGAR_FACES

\FACE normal_x, normal_y, normal_z, visibility
 FACE      -16,       46,        4,         31    \ Face 0
 FACE      -16,      -46,        4,         31    \ Face 1
 FACE        0,      -27,        5,         31    \ Face 2
 FACE       16,      -46,        4,         31    \ Face 3
 FACE       16,       46,        4,         31    \ Face 4
 FACE        0,        0,     -160,         30    \ Face 5

