\ ******************************************************************************
\
\       Name: SHIP_SHUTTLE
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Shuttle
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_SHUTTLE

 EQUB 15                \ Max. canisters on demise = 15
 EQUW 50 * 50           \ Targetable area          = 50 * 50

 EQUB LO(SHIP_SHUTTLE_EDGES - SHIP_SHUTTLE)        \ Edges data offset (low)
 EQUB LO(SHIP_SHUTTLE_FACES - SHIP_SHUTTLE)        \ Faces data offset (low)

IF _DISC_VERSION OR _ELITE_A_VERSION \ Advanced: The advanced versions of Elite have an extra edge count for the ship colour; Shuttles are shown in cyan
 EQUB 109               \ Max. edge count          = (109 - 1) / 4 = 27
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION
 EQUB 113               \ Max. edge count          = (113 - 1) / 4 = 28
ENDIF
 EQUB 0                 \ Gun vertex               = 0
 EQUB 38                \ Explosion count          = 8, as (4 * n) + 6 = 38
 EQUB 114               \ Number of vertices       = 114 / 6 = 19
 EQUB 30                \ Number of edges          = 30
 EQUW 0                 \ Bounty                   = 0
 EQUB 52                \ Number of faces          = 52 / 4 = 13
 EQUB 22                \ Visibility distance      = 22
 EQUB 32                \ Max. energy              = 32
 EQUB 8                 \ Max. speed               = 8

 EQUB HI(SHIP_SHUTTLE_EDGES - SHIP_SHUTTLE)        \ Edges data offset (high)
 EQUB HI(SHIP_SHUTTLE_FACES - SHIP_SHUTTLE)        \ Faces data offset (high)

 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

.SHIP_SHUTTLE_VERTICES

IF _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Disc: Group A: The ship hangar in the disc version displays the Shuttle with slightly different visibility settings to the other enhanced versions, and the face normals are twice the size (even though the scale factor is the same). I'm not entirely sure why

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,  -17,   23,    15,     15,   15,    15,         31    \ Vertex 0
 VERTEX  -17,    0,   23,    15,     15,   15,    15,         31    \ Vertex 1
 VERTEX    0,   18,   23,    15,     15,   15,    15,         31    \ Vertex 2
 VERTEX   18,    0,   23,    15,     15,   15,    15,         31    \ Vertex 3
 VERTEX  -20,  -20,  -27,     2,      1,    9,     3,         31    \ Vertex 4
 VERTEX  -20,   20,  -27,     4,      3,    9,     5,         31    \ Vertex 5
 VERTEX   20,   20,  -27,     6,      5,    9,     7,         31    \ Vertex 6
 VERTEX   20,  -20,  -27,     7,      1,    9,     8,         31    \ Vertex 7
 VERTEX    5,    0,  -27,     9,      9,    9,     9,         16    \ Vertex 8
 VERTEX    0,   -2,  -27,     9,      9,    9,     9,         16    \ Vertex 9
 VERTEX   -5,    0,  -27,     9,      9,    9,     9,          9    \ Vertex 10
 VERTEX    0,    3,  -27,     9,      9,    9,     9,          9    \ Vertex 11
 VERTEX    0,   -9,   35,    10,      0,   12,    11,         16    \ Vertex 12
 VERTEX    3,   -1,   31,    15,     15,    2,     0,          7    \ Vertex 13
 VERTEX    4,   11,   25,     1,      0,    4,    15,          8    \ Vertex 14
 VERTEX   11,    4,   25,     1,     10,   15,     3,          8    \ Vertex 15
 VERTEX   -3,   -1,   31,    11,      6,    3,     2,          7    \ Vertex 16
 VERTEX   -3,   11,   25,     8,     15,    0,    12,          8    \ Vertex 17
 VERTEX  -10,    4,   25,    15,      4,    8,     1,          8    \ Vertex 18

ELIF _DISC_DOCKED OR _ELITE_A_VERSION

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,  -35,   47,    15,    15,    15,    15,         31     \ Vertex 0
 VERTEX  -35,    0,   47,    15,    15,    15,    15,         31     \ Vertex 1
 VERTEX    0,   35,   47,    15,    15,    15,    15,         31     \ Vertex 2
 VERTEX   35,    0,   47,    15,    15,    15,    15,         31     \ Vertex 3
 VERTEX  -40,  -40,  -53,     2,     1,     9,     3,         31     \ Vertex 4
 VERTEX  -40,   40,  -53,     4,     3,     9,     5,         31     \ Vertex 5
 VERTEX   40,   40,  -53,     6,     5,     9,     7,         31     \ Vertex 6
 VERTEX   40,  -40,  -53,     7,     1,     9,     8,         31     \ Vertex 7
 VERTEX   10,    0,  -53,     9,     9,     9,     9,         16     \ Vertex 8
 VERTEX    0,   -5,  -53,     9,     9,     9,     9,         16     \ Vertex 9
 VERTEX  -10,    0,  -53,     9,     9,     9,     9,          8     \ Vertex 10
 VERTEX    0,    5,  -53,     9,     9,     9,     9,          8     \ Vertex 11
 VERTEX    0,  -17,   71,    10,     0,    12,    11,         16     \ Vertex 12
 VERTEX    5,   -2,   61,    15,    15,     2,     0,          6     \ Vertex 13
 VERTEX    7,   23,   49,     1,     0,     4,    15,          7     \ Vertex 14
 VERTEX   21,    9,   49,     1,    10,    15,     3,          7     \ Vertex 15
 VERTEX   -5,   -2,   61,    11,     6,     3,     2,          6     \ Vertex 16
 VERTEX   -7,   23,   49,     8,    15,     0,    12,          7     \ Vertex 17
 VERTEX  -21,    9,   49,    15,     4,     8,     1,          7     \ Vertex 18

ENDIF

.SHIP_SHUTTLE_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     2,     0,         31    \ Edge 0
 EDGE       1,       2,    10,     4,         31    \ Edge 1
 EDGE       2,       3,    11,     6,         31    \ Edge 2
 EDGE       0,       3,    12,     8,         31    \ Edge 3
 EDGE       0,       7,     8,     1,         31    \ Edge 4
 EDGE       0,       4,     2,     1,         24    \ Edge 5
 EDGE       1,       4,     3,     2,         31    \ Edge 6
 EDGE       1,       5,     4,     3,         24    \ Edge 7
 EDGE       2,       5,     5,     4,         31    \ Edge 8
 EDGE       2,       6,     6,     5,         12    \ Edge 9
 EDGE       3,       6,     7,     6,         31    \ Edge 10
 EDGE       3,       7,     8,     7,         24    \ Edge 11
 EDGE       4,       5,     9,     3,         31    \ Edge 12
 EDGE       5,       6,     9,     5,         31    \ Edge 13
 EDGE       6,       7,     9,     7,         31    \ Edge 14
 EDGE       4,       7,     9,     1,         31    \ Edge 15
 EDGE       0,      12,    12,     0,         16    \ Edge 16
 EDGE       1,      12,    10,     0,         16    \ Edge 17
 EDGE       2,      12,    11,    10,         16    \ Edge 18
 EDGE       3,      12,    12,    11,         16    \ Edge 19
 EDGE       8,       9,     9,     9,         16    \ Edge 20
IF _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Disc: See group A
 EDGE       9,      10,     9,     9,          7    \ Edge 21
 EDGE      10,      11,     9,     9,          9    \ Edge 22
 EDGE       8,      11,     9,     9,          7    \ Edge 23
 EDGE      13,      14,    11,    11,          5    \ Edge 24
 EDGE      14,      15,    11,    11,          8    \ Edge 25
 EDGE      13,      15,    11,    11,          7    \ Edge 26
 EDGE      16,      17,    10,    10,          5    \ Edge 27
 EDGE      17,      18,    10,    10,          8    \ Edge 28
 EDGE      16,      18,    10,    10,          7    \ Edge 29
ELIF _DISC_DOCKED OR _ELITE_A_VERSION
 EDGE       9,      10,     9,     9,          6    \ Edge 21
 EDGE      10,      11,     9,     9,          8    \ Edge 22
 EDGE       8,      11,     9,     9,          6    \ Edge 23
 EDGE      13,      14,    11,    11,          4    \ Edge 24
 EDGE      14,      15,    11,    11,          7    \ Edge 25
 EDGE      13,      15,    11,    11,          6    \ Edge 26
 EDGE      16,      17,    10,    10,          4    \ Edge 27
 EDGE      17,      18,    10,    10,          7    \ Edge 28
 EDGE      16,      18,    10,    10,          6    \ Edge 29
ENDIF

.SHIP_SHUTTLE_FACES

IF _DISC_FLIGHT OR _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Disc: See group A

    \ normal_x, normal_y, normal_z, visibility
 FACE      -55,      -55,       40,         31    \ Face 0
 FACE        0,      -74,        4,         31    \ Face 1
 FACE      -51,      -51,       23,         31    \ Face 2
 FACE      -74,        0,        4,         31    \ Face 3
 FACE      -51,       51,       23,         31    \ Face 4
 FACE        0,       74,        4,         31    \ Face 5
 FACE       51,       51,       23,         31    \ Face 6
 FACE       74,        0,        4,         31    \ Face 7
 FACE       51,      -51,       23,         31    \ Face 8
 FACE        0,        0,     -107,         31    \ Face 9
 FACE      -41,       41,       90,         31    \ Face 10
 FACE       41,       41,       90,         31    \ Face 11
 FACE       55,      -55,       40,         31    \ Face 12

ELIF _DISC_DOCKED OR _ELITE_A_VERSION

    \ normal_x, normal_y, normal_z, visibility
 FACE     -110,     -110,       80,         31    \ Face 0
 FACE        0,     -149,        7,         31    \ Face 1
 FACE     -102,     -102,       46,         31    \ Face 2
 FACE     -149,        0,        7,         31    \ Face 3
 FACE     -102,      102,       46,         31    \ Face 4
 FACE        0,      149,        7,         31    \ Face 5
 FACE      102,      102,       46,         31    \ Face 6
 FACE      149,        0,        7,         31    \ Face 7
 FACE      102,     -102,       46,         31    \ Face 8
 FACE        0,        0,     -213,         31    \ Face 9
 FACE      -81,       81,      177,         31    \ Face 10
 FACE       81,       81,      177,         31    \ Face 11
 FACE      110,     -110,       80,         31    \ Face 12

ENDIF

