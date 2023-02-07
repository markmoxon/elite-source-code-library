\ ******************************************************************************
\
\       Name: SHIP_LOGO
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for the Elite logo
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_LOGO

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 99 * 99           \ Targetable area          = 99 * 99
 EQUB LO(SHIP_LOGO_EDGES - SHIP_LOGO)              \ Edges data offset (low)
 EQUB LO(SHIP_LOGO_FACES - SHIP_LOGO)              \ Faces data offset (low)
 EQUB 153               \ Max. edge count          = (153 - 1) / 4 = 38
 EQUB 0                 \ Gun vertex               = 0
 EQUB 54                \ Explosion count          = 12, as (4 * n) + 6 = 54
 EQUB 252               \ Number of vertices       = 252 / 6 = 42
 EQUB 37                \ Number of edges          = 37
 EQUW 0                 \ Bounty                   = 0
 EQUB 20                \ Number of faces          = 20 / 4 = 5
 EQUB 99                \ Visibility distance      = 99
 EQUB 252               \ Max. energy              = 252
 EQUB 36                \ Max. speed               = 36
 EQUB HI(SHIP_LOGO_EDGES - SHIP_LOGO)              \ Edges data offset (high)
 EQUB HI(SHIP_LOGO_FACES - SHIP_LOGO)              \ Faces data offset (high)
 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

\          x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,   -9,   55,     0,      0,    0,     0,         31    \ Vertex 0
 VERTEX  -10,   -9,   30,     0,      0,    0,     0,         31    \ Vertex 1
 VERTEX  -25,   -9,   93,     0,      0,    0,     0,         31    \ Vertex 2
 VERTEX -150,   -9,  180,     0,      0,    0,     0,         31    \ Vertex 3
 VERTEX  -90,   -9,   10,     0,      0,    0,     0,         31    \ Vertex 4
 VERTEX -140,   -9,   10,     0,      0,    0,     0,         31    \ Vertex 5
 VERTEX    0,   -9,  -95,     0,      0,    0,     0,         31    \ Vertex 6
 VERTEX  140,   -9,   10,     0,      0,    0,     0,         31    \ Vertex 7
 VERTEX   90,   -9,   10,     0,      0,    0,     0,         31    \ Vertex 8
 VERTEX  150,   -9,  180,     0,      0,    0,     0,         31    \ Vertex 9
 VERTEX   25,   -9,   93,     0,      0,    0,     0,         31    \ Vertex 10
 VERTEX   10,   -9,   30,     0,      0,    0,     0,         31    \ Vertex 11
 VERTEX  -85,   -9,  -30,     2,      0,    3,     3,         31    \ Vertex 12
 VERTEX   85,   -9,  -30,     2,      0,    4,     4,         31    \ Vertex 13
 VERTEX  -70,   11,    5,     1,      0,    3,     3,         31    \ Vertex 14
 VERTEX  -70,   11,  -25,     2,      0,    3,     3,         31    \ Vertex 15
 VERTEX   70,   11,  -25,     2,      0,    4,     4,         31    \ Vertex 16
 VERTEX   70,   11,    5,     1,      0,    4,     4,         31    \ Vertex 17
 VERTEX    0,   -9,    5,     0,      0,    0,     0,         31    \ Vertex 18
 VERTEX    0,   -9,    5,     0,      0,    0,     0,         31    \ Vertex 19
 VERTEX    0,   -9,    5,     0,      0,    0,     0,         31    \ Vertex 20
 VERTEX  -28,   11,   -2,     0,      0,    0,     0,         31    \ Vertex 21
 VERTEX  -49,   11,   -2,     0,      0,    0,     0,         31    \ Vertex 22
 VERTEX  -49,   11,  -10,     0,      0,    0,     0,         31    \ Vertex 23
 VERTEX  -49,   11,  -17,     0,      0,    0,     0,         31    \ Vertex 24
 VERTEX  -28,   11,  -17,     0,      0,    0,     0,         31    \ Vertex 25
 VERTEX  -28,   11,  -10,     0,      0,    0,     0,         31    \ Vertex 26
 VERTEX  -24,   11,   -2,     0,      0,    0,     0,         31    \ Vertex 27
 VERTEX  -24,   11,  -17,     0,      0,    0,     0,         31    \ Vertex 28
 VERTEX   -3,   11,  -17,     0,      0,    0,     0,         31    \ Vertex 29
 VERTEX    0,   11,   -2,     0,      0,    0,     0,         31    \ Vertex 30
 VERTEX    0,   11,  -17,     0,      0,    0,     0,         31    \ Vertex 31
 VERTEX    4,   11,   -2,     0,      0,    0,     0,         31    \ Vertex 32
 VERTEX   25,   11,   -2,     0,      0,    0,     0,         31    \ Vertex 33
 VERTEX   14,   11,   -2,     0,      0,    0,     0,         31    \ Vertex 34
 VERTEX   14,   11,  -17,     0,      0,    0,     0,         31    \ Vertex 35
 VERTEX   49,   11,   -2,     0,      0,    0,     0,         31    \ Vertex 36
 VERTEX   28,   11,   -2,     0,      0,    0,     0,         31    \ Vertex 37
 VERTEX   28,   11,  -10,     0,      0,    0,     0,         31    \ Vertex 38
 VERTEX   28,   11,  -17,     0,      0,    0,     0,         31    \ Vertex 39
 VERTEX   49,   11,  -17,     0,      0,    0,     0,         31    \ Vertex 40
 VERTEX   49,   11,  -10,     0,      0,    0,     0,         31    \ Vertex 41

.SHIP_LOGO_EDGES

\     vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     0,     0,         31    \ Edge 0
 EDGE       1,       2,     0,     0,         31    \ Edge 1
 EDGE       2,       3,     0,     0,         31    \ Edge 2
 EDGE       3,       4,     0,     0,         31    \ Edge 3
 EDGE       4,       5,     0,     0,         31    \ Edge 4
 EDGE       5,       6,     0,     0,         31    \ Edge 5
 EDGE       6,       7,     0,     0,         31    \ Edge 6
 EDGE       7,       8,     0,     0,         31    \ Edge 7
 EDGE       8,       9,     0,     0,         31    \ Edge 8
 EDGE       9,      10,     0,     0,         31    \ Edge 9
 EDGE      10,      11,     0,     0,         31    \ Edge 10
 EDGE      11,       0,     0,     0,         31    \ Edge 11
 EDGE      14,      15,     3,     0,         30    \ Edge 12
 EDGE      15,      16,     1,     0,         30    \ Edge 13
 EDGE      16,      17,     4,     0,         30    \ Edge 14
 EDGE      17,      14,     1,     0,         30    \ Edge 15
 EDGE       4,      12,     3,     0,         30    \ Edge 16
 EDGE      12,      13,     2,     2,         30    \ Edge 17
 EDGE      13,       8,     4,     0,         30    \ Edge 18
 EDGE       8,       4,     1,     1,         30    \ Edge 19
 EDGE       4,      14,     3,     1,         30    \ Edge 20
 EDGE      12,      15,     3,     1,         30    \ Edge 21
 EDGE      13,      16,     4,     2,         30    \ Edge 22
 EDGE       8,      17,     4,     1,         30    \ Edge 23
 EDGE      21,      22,     0,     0,         30    \ Edge 24
 EDGE      22,      24,     0,     0,         30    \ Edge 25
 EDGE      24,      25,     0,     0,         30    \ Edge 26
 EDGE      23,      26,     0,     0,         30    \ Edge 27
 EDGE      27,      28,     0,     0,         30    \ Edge 28
 EDGE      28,      29,     0,     0,         30    \ Edge 29
 EDGE      30,      31,     0,     0,         30    \ Edge 30
 EDGE      32,      33,     0,     0,         30    \ Edge 31
 EDGE      34,      35,     0,     0,         30    \ Edge 32
 EDGE      36,      37,     0,     0,         30    \ Edge 33
 EDGE      37,      39,     0,     0,         30    \ Edge 34
 EDGE      39,      40,     0,     0,         30    \ Edge 35
 EDGE      41,      38,     0,     0,         30    \ Edge 36

.SHIP_LOGO_FACES

\     normal_x, normal_y, normal_z, visibility
 FACE        0,       23,        0,         31    \ Face 0
 FACE        0,        4,       15,         31    \ Face 1
 FACE        0,       13,      -52,         31    \ Face 2
 FACE      -81,       81,        0,         31    \ Face 3
 FACE       81,       81,        0,         31    \ Face 4

