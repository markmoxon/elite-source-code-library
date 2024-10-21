\ ******************************************************************************
\
\       Name: SHIP_MORAY
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Moray
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_MORAY

 EQUB 1                 \ Max. canisters on demise = 1
 EQUW 30 * 30           \ Targetable area          = 30 * 30

 EQUB LO(SHIP_MORAY_EDGES - SHIP_MORAY)            \ Edges data offset (low)
 EQUB LO(SHIP_MORAY_FACES - SHIP_MORAY)            \ Faces data offset (low)

IF _DISC_FLIGHT OR _ELITE_A_VERSION \ Advanced: The advanced versions of Elite have an extra edge count for the ship colour; Morays are shown in cyan/red/black/yellow stripes
 EQUB 69                \ Max. edge count          = (69 - 1) / 4 = 17
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
 EQUB 73                \ Max. edge count          = (73 - 1) / 4 = 18
ENDIF
 EQUB 0                 \ Gun vertex               = 0
 EQUB 26                \ Explosion count          = 5, as (4 * n) + 6 = 26
 EQUB 84                \ Number of vertices       = 84 / 6 = 14
 EQUB 19                \ Number of edges          = 19
 EQUW 50                \ Bounty                   = 50
 EQUB 36                \ Number of faces          = 36 / 4 = 9
 EQUB 40                \ Visibility distance      = 40
IF NOT(_ELITE_A_VERSION)
 EQUB 100               \ Max. energy              = 100
ELIF _ELITE_A_VERSION
 EQUB 89                \ Max. energy              = 89
ENDIF
 EQUB 25                \ Max. speed               = 25

 EQUB HI(SHIP_MORAY_EDGES - SHIP_MORAY)            \ Edges data offset (high)
 EQUB HI(SHIP_MORAY_FACES - SHIP_MORAY)            \ Faces data offset (high)

 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
IF NOT(_ELITE_A_VERSION)
 EQUB %00010000         \ Laser power              = 2
                        \ Missiles                 = 0

ELIF _ELITE_A_VERSION
 EQUB %00101010         \ Laser power              = 5
                        \ Missiles                 = 2

ENDIF

.SHIP_MORAY_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX   15,    0,   65,     2,      0,    8,     7,         31    \ Vertex 0
 VERTEX  -15,    0,   65,     1,      0,    7,     6,         31    \ Vertex 1
 VERTEX    0,   18,  -40,    15,     15,   15,    15,         17    \ Vertex 2
 VERTEX  -60,    0,    0,     3,      1,    6,     6,         31    \ Vertex 3
 VERTEX   60,    0,    0,     5,      2,    8,     8,         31    \ Vertex 4
 VERTEX   30,  -27,  -10,     5,      4,    8,     7,         24    \ Vertex 5
 VERTEX  -30,  -27,  -10,     4,      3,    7,     6,         24    \ Vertex 6
 VERTEX   -9,   -4,  -25,     4,      4,    4,     4,          7    \ Vertex 7
 VERTEX    9,   -4,  -25,     4,      4,    4,     4,          7    \ Vertex 8
 VERTEX    0,  -18,  -16,     4,      4,    4,     4,          7    \ Vertex 9
 VERTEX   13,    3,   49,     0,      0,    0,     0,          5    \ Vertex 10
 VERTEX    6,    0,   65,     0,      0,    0,     0,          5    \ Vertex 11
 VERTEX  -13,    3,   49,     0,      0,    0,     0,          5    \ Vertex 12
 VERTEX   -6,    0,   65,     0,      0,    0,     0,          5    \ Vertex 13

.SHIP_MORAY_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     7,     0,         31    \ Edge 0
 EDGE       1,       3,     6,     1,         31    \ Edge 1
 EDGE       3,       6,     6,     3,         24    \ Edge 2
 EDGE       5,       6,     7,     4,         24    \ Edge 3
 EDGE       4,       5,     8,     5,         24    \ Edge 4
 EDGE       0,       4,     8,     2,         31    \ Edge 5
 EDGE       1,       6,     7,     6,         15    \ Edge 6
 EDGE       0,       5,     8,     7,         15    \ Edge 7
 EDGE       0,       2,     2,     0,         15    \ Edge 8
 EDGE       1,       2,     1,     0,         15    \ Edge 9
 EDGE       2,       3,     3,     1,         17    \ Edge 10
 EDGE       2,       4,     5,     2,         17    \ Edge 11
 EDGE       2,       5,     5,     4,         13    \ Edge 12
 EDGE       2,       6,     4,     3,         13    \ Edge 13
 EDGE       7,       8,     4,     4,          5    \ Edge 14
 EDGE       7,       9,     4,     4,          7    \ Edge 15
 EDGE       8,       9,     4,     4,          7    \ Edge 16
 EDGE      10,      11,     0,     0,          5    \ Edge 17
 EDGE      12,      13,     0,     0,          5    \ Edge 18

.SHIP_MORAY_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE        0,       43,        7,         31    \ Face 0
 FACE      -10,       49,        7,         31    \ Face 1
 FACE       10,       49,        7,         31    \ Face 2
 FACE      -59,      -28,     -101,         24    \ Face 3
 FACE        0,      -52,      -78,         24    \ Face 4
 FACE       59,      -28,     -101,         24    \ Face 5
 FACE      -72,      -99,       50,         31    \ Face 6
 FACE        0,      -83,       30,         31    \ Face 7
 FACE       72,      -99,       50,         31    \ Face 8

