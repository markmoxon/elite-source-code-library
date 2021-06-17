\ ******************************************************************************
\
\       Name: SHIP_ASP_MK_2
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for an Asp Mk II
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_ASP_MK_2

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 60 * 60           \ Targetable area          = 60 * 60
 EQUB &86               \ Edges data offset (low)  = &0086
 EQUB &F6               \ Faces data offset (low)  = &00F6
IF _DISC_FLIGHT OR _ELITE_A_VERSION \ Advanced: The advanced versions of Elite have an extra edge count for the ship colour; Asps are shown in cyan
 EQUB 101               \ Max. edge count          = (101 - 1) / 4 = 25
ELIF _6502SP_VERSION OR _MASTER_VERSION
 EQUB 105               \ Max. edge count          = (105 - 1) / 4 = 26
ENDIF
 EQUB 32                \ Gun vertex               = 32
 EQUB 26                \ Explosion count          = 5, as (4 * n) + 6 = 26
 EQUB 114               \ Number of vertices       = 114 / 6 = 19
 EQUB 28                \ Number of edges          = 28
IF NOT(_ELITE_A_VERSION)
 EQUW 200               \ Bounty                   = 200
ELIF _ELITE_A_SHIPS_T
 EQUW 550               \ Bounty                   = 550
ELIF _ELITE_A_VERSION
 EQUW 450               \ Bounty                   = 450
ENDIF
 EQUB 48                \ Number of faces          = 48 / 4 = 12
 EQUB 40                \ Visibility distance      = 40
IF NOT(_ELITE_A_VERSION)
 EQUB 150               \ Max. energy              = 150
ELIF _ELITE_A_SHIPS_T
 EQUB 117               \ Max. energy              = 117
ELIF _ELITE_A_VERSION
 EQUB 109               \ Max. energy              = 109
ENDIF
 EQUB 40                \ Max. speed               = 40
 EQUB &00               \ Edges data offset (high) = &0086
 EQUB &00               \ Faces data offset (high) = &00F6
 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
IF NOT(_ELITE_A_VERSION)
 EQUB %00101001         \ Laser power              = 5
                        \ Missiles                 = 1

ELIF _ELITE_A_VERSION
 EQUB %01001001         \ Laser power              = 9 AJD
                        \ Missiles                 = 1

ENDIF

\VERTEX    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,  -18,    0,     1,      0,    2,     2,         22    \ Vertex 0
 VERTEX    0,   -9,  -45,     2,      1,   11,    11,         31    \ Vertex 1
 VERTEX   43,    0,  -45,     6,      1,   11,    11,         31    \ Vertex 2
 VERTEX   69,   -3,    0,     6,      1,    9,     7,         31    \ Vertex 3
 VERTEX   43,  -14,   28,     1,      0,    7,     7,         31    \ Vertex 4
 VERTEX  -43,    0,  -45,     5,      2,   11,    11,         31    \ Vertex 5
 VERTEX  -69,   -3,    0,     5,      2,   10,     8,         31    \ Vertex 6
 VERTEX  -43,  -14,   28,     2,      0,    8,     8,         31    \ Vertex 7
 VERTEX   26,   -7,   73,     4,      0,    9,     7,         31    \ Vertex 8
 VERTEX  -26,   -7,   73,     4,      0,   10,     8,         31    \ Vertex 9
 VERTEX   43,   14,   28,     4,      3,    9,     6,         31    \ Vertex 10
 VERTEX  -43,   14,   28,     4,      3,   10,     5,         31    \ Vertex 11
 VERTEX    0,    9,  -45,     5,      3,   11,     6,         31    \ Vertex 12
 VERTEX  -17,    0,  -45,    11,     11,   11,    11,         10    \ Vertex 13
 VERTEX   17,    0,  -45,    11,     11,   11,    11,          9    \ Vertex 14
 VERTEX    0,   -4,  -45,    11,     11,   11,    11,         10    \ Vertex 15
 VERTEX    0,    4,  -45,    11,     11,   11,    11,          8    \ Vertex 16
 VERTEX    0,   -7,   73,     4,      0,    4,     0,         10    \ Vertex 17
 VERTEX    0,   -7,   83,     4,      0,    4,     0,         10    \ Vertex 18

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     2,     1,         22    \ Edge 0
 EDGE       0,       4,     1,     0,         22    \ Edge 1
 EDGE       0,       7,     2,     0,         22    \ Edge 2
 EDGE       1,       2,    11,     1,         31    \ Edge 3
 EDGE       2,       3,     6,     1,         31    \ Edge 4
 EDGE       3,       8,     9,     7,         16    \ Edge 5
 EDGE       8,       9,     4,     0,         31    \ Edge 6
 EDGE       6,       9,    10,     8,         16    \ Edge 7
 EDGE       5,       6,     5,     2,         31    \ Edge 8
 EDGE       1,       5,    11,     2,         31    \ Edge 9
 EDGE       3,       4,     7,     1,         31    \ Edge 10
 EDGE       4,       8,     7,     0,         31    \ Edge 11
 EDGE       6,       7,     8,     2,         31    \ Edge 12
 EDGE       7,       9,     8,     0,         31    \ Edge 13
 EDGE       2,      12,    11,     6,         31    \ Edge 14
 EDGE       5,      12,    11,     5,         31    \ Edge 15
 EDGE      10,      12,     6,     3,         22    \ Edge 16
 EDGE      11,      12,     5,     3,         22    \ Edge 17
 EDGE      10,      11,     4,     3,         22    \ Edge 18
 EDGE       6,      11,    10,     5,         31    \ Edge 19
 EDGE       9,      11,    10,     4,         31    \ Edge 20
 EDGE       3,      10,     9,     6,         31    \ Edge 21
 EDGE       8,      10,     9,     4,         31    \ Edge 22
 EDGE      13,      15,    11,    11,         10    \ Edge 23
 EDGE      15,      14,    11,    11,          9    \ Edge 24
 EDGE      14,      16,    11,    11,          8    \ Edge 25
 EDGE      16,      13,    11,    11,          8    \ Edge 26
 EDGE      18,      17,     4,     0,         10    \ Edge 27

\FACE normal_x, normal_y, normal_z, visibility
 FACE        0,      -35,        5,         31    \ Face 0
 FACE        8,      -38,       -7,         31    \ Face 1
 FACE       -8,      -38,       -7,         31    \ Face 2
 FACE        0,       24,       -1,         22    \ Face 3
 FACE        0,       43,       19,         31    \ Face 4
 FACE       -6,       28,       -2,         31    \ Face 5
 FACE        6,       28,       -2,         31    \ Face 6
 FACE       59,      -64,       31,         31    \ Face 7
 FACE      -59,      -64,       31,         31    \ Face 8
 FACE       80,       46,       50,         31    \ Face 9
 FACE      -80,       46,       50,         31    \ Face 10
 FACE        0,        0,      -90,         31    \ Face 11

