\ ******************************************************************************
\
\       Name: SHIP_MISSILE
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a missile
\  Deep dive: Ship blueprints
IF NOT(_ELITE_A_VERSION)
\             Comparing ship specifications
ENDIF
\
\ ******************************************************************************

.SHIP_MISSILE

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 40 * 40           \ Targetable area          = 40 * 40

 EQUB LO(SHIP_MISSILE_EDGES - SHIP_MISSILE)        \ Edges data offset (low)
 EQUB LO(SHIP_MISSILE_FACES - SHIP_MISSILE)        \ Faces data offset (low)

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Advanced: The advanced versions of Elite have an extra edge count for the ship colour; missiles are shown in yellow
 EQUB 81                \ Max. edge count          = (81 - 1) / 4 = 20
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
 EQUB 85                \ Max. edge count          = (85 - 1) / 4 = 21
ENDIF
 EQUB 0                 \ Gun vertex               = 0
 EQUB 10                \ Explosion count          = 1, as (4 * n) + 6 = 10
 EQUB 102               \ Number of vertices       = 102 / 6 = 17
 EQUB 24                \ Number of edges          = 24
 EQUW 0                 \ Bounty                   = 0
 EQUB 36                \ Number of faces          = 36 / 4 = 9
 EQUB 14                \ Visibility distance      = 14
 EQUB 2                 \ Max. energy              = 2
 EQUB 44                \ Max. speed               = 44

 EQUB HI(SHIP_MISSILE_EDGES - SHIP_MISSILE)        \ Edges data offset (high)
 EQUB HI(SHIP_MISSILE_FACES - SHIP_MISSILE)        \ Faces data offset (high)

 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

.SHIP_MISSILE_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    0,   68,     0,      1,    2,     3,         31    \ Vertex 0
 VERTEX    8,   -8,   36,     1,      2,    4,     5,         31    \ Vertex 1
 VERTEX    8,    8,   36,     2,      3,    4,     7,         31    \ Vertex 2
 VERTEX   -8,    8,   36,     0,      3,    6,     7,         31    \ Vertex 3
 VERTEX   -8,   -8,   36,     0,      1,    5,     6,         31    \ Vertex 4
 VERTEX    8,    8,  -44,     4,      7,    8,     8,         31    \ Vertex 5
 VERTEX    8,   -8,  -44,     4,      5,    8,     8,         31    \ Vertex 6
 VERTEX   -8,   -8,  -44,     5,      6,    8,     8,         31    \ Vertex 7
 VERTEX   -8,    8,  -44,     6,      7,    8,     8,         31    \ Vertex 8
 VERTEX   12,   12,  -44,     4,      7,    8,     8,          8    \ Vertex 9
 VERTEX   12,  -12,  -44,     4,      5,    8,     8,          8    \ Vertex 10
 VERTEX  -12,  -12,  -44,     5,      6,    8,     8,          8    \ Vertex 11
 VERTEX  -12,   12,  -44,     6,      7,    8,     8,          8    \ Vertex 12
 VERTEX   -8,    8,  -12,     6,      7,    7,     7,          8    \ Vertex 13
 VERTEX   -8,   -8,  -12,     5,      6,    6,     6,          8    \ Vertex 14
 VERTEX    8,    8,  -12,     4,      7,    7,     7,          8    \ Vertex 15
 VERTEX    8,   -8,  -12,     4,      5,    5,     5,          8    \ Vertex 16

.SHIP_MISSILE_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     1,     2,         31    \ Edge 0
 EDGE       0,       2,     2,     3,         31    \ Edge 1
 EDGE       0,       3,     0,     3,         31    \ Edge 2
 EDGE       0,       4,     0,     1,         31    \ Edge 3
 EDGE       1,       2,     4,     2,         31    \ Edge 4
 EDGE       1,       4,     1,     5,         31    \ Edge 5
 EDGE       3,       4,     0,     6,         31    \ Edge 6
 EDGE       2,       3,     3,     7,         31    \ Edge 7
 EDGE       2,       5,     4,     7,         31    \ Edge 8
 EDGE       1,       6,     4,     5,         31    \ Edge 9
 EDGE       4,       7,     5,     6,         31    \ Edge 10
 EDGE       3,       8,     6,     7,         31    \ Edge 11
 EDGE       7,       8,     6,     8,         31    \ Edge 12
 EDGE       5,       8,     7,     8,         31    \ Edge 13
 EDGE       5,       6,     4,     8,         31    \ Edge 14
 EDGE       6,       7,     5,     8,         31    \ Edge 15
 EDGE       6,      10,     5,     8,          8    \ Edge 16
 EDGE       5,       9,     7,     8,          8    \ Edge 17
 EDGE       8,      12,     7,     8,          8    \ Edge 18
 EDGE       7,      11,     5,     8,          8    \ Edge 19
 EDGE       9,      15,     4,     7,          8    \ Edge 20
 EDGE      10,      16,     4,     5,          8    \ Edge 21
 EDGE      12,      13,     6,     7,          8    \ Edge 22
 EDGE      11,      14,     5,     6,          8    \ Edge 23

.SHIP_MISSILE_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE      -64,        0,       16,         31      \ Face 0
 FACE        0,      -64,       16,         31      \ Face 1
 FACE       64,        0,       16,         31      \ Face 2
 FACE        0,       64,       16,         31      \ Face 3
 FACE       32,        0,        0,         31      \ Face 4
 FACE        0,      -32,        0,         31      \ Face 5
 FACE      -32,        0,        0,         31      \ Face 6
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION OR _ELITE_A_VERSION \ Disc: The data for faces 7 and 8 of the disc version's missile blueprint is quite different compared to the other versions
 FACE        0,       32,        0,         31      \ Face 7
 FACE        0,        0,     -176,         31      \ Face 8
ELIF _DISC_VERSION

IF _STH_DISC OR _IB_DISC

 FACE        0,      160,      110,         31      \ Face 7
 FACE        0,       64,        4,          0      \ Face 8

ELIF _SRAM_DISC

 FACE        0,       32,        0,         31      \ Face 7
 FACE        0,        0,     -176,         31      \ Face 8

ENDIF

ENDIF

