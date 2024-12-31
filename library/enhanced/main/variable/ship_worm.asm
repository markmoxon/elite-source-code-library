\ ******************************************************************************
\
\       Name: SHIP_WORM
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Worm
\  Deep dive: Ship blueprints
IF NOT(_ELITE_A_VERSION)
\             Comparing ship specifications
ENDIF
\
\ ******************************************************************************

.SHIP_WORM

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 99 * 99           \ Targetable area          = 99 * 99

 EQUB LO(SHIP_WORM_EDGES - SHIP_WORM)              \ Edges data offset (low)
 EQUB LO(SHIP_WORM_FACES - SHIP_WORM)              \ Faces data offset (low)

IF _DISC_FLIGHT OR _ELITE_A_VERSION \ Advanced: The advanced versions of Elite have an extra edge count for the ship colour; Worms are shown in cyan
 EQUB 73                \ Max. edge count          = (73 - 1) / 4 = 18
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
 EQUB 77                \ Max. edge count          = (77 - 1) / 4 = 19
ENDIF
 EQUB 0                 \ Gun vertex               = 0
 EQUB 18                \ Explosion count          = 3, as (4 * n) + 6 = 18
 EQUB 60                \ Number of vertices       = 60 / 6 = 10
 EQUB 16                \ Number of edges          = 16
 EQUW 0                 \ Bounty                   = 0
 EQUB 32                \ Number of faces          = 32 / 4 = 8
 EQUB 19                \ Visibility distance      = 19
IF NOT(_ELITE_A_VERSION)
 EQUB 30                \ Max. energy              = 30
ELIF _ELITE_A_VERSION
 EQUB 32                \ Max. energy              = 32
ENDIF
 EQUB 23                \ Max. speed               = 23

 EQUB HI(SHIP_WORM_EDGES - SHIP_WORM)              \ Edges data offset (high)
 EQUB HI(SHIP_WORM_FACES - SHIP_WORM)              \ Faces data offset (high)

 EQUB 3                 \ Normals are scaled by    = 2^3 = 8
IF NOT(_ELITE_A_VERSION)
 EQUB %00001000         \ Laser power              = 1
                        \ Missiles                 = 0

ELIF _ELITE_A_VERSION
 EQUB %00011000         \ Laser power              = 3
                        \ Missiles                 = 0

ENDIF

.SHIP_WORM_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX   10,  -10,   35,     2,      0,    7,     7,         31    \ Vertex 0
 VERTEX  -10,  -10,   35,     3,      0,    7,     7,         31    \ Vertex 1
 VERTEX    5,    6,   15,     1,      0,    4,     2,         31    \ Vertex 2
 VERTEX   -5,    6,   15,     1,      0,    5,     3,         31    \ Vertex 3
 VERTEX   15,  -10,   25,     4,      2,    7,     7,         31    \ Vertex 4
 VERTEX  -15,  -10,   25,     5,      3,    7,     7,         31    \ Vertex 5
 VERTEX   26,  -10,  -25,     6,      4,    7,     7,         31    \ Vertex 6
 VERTEX  -26,  -10,  -25,     6,      5,    7,     7,         31    \ Vertex 7
 VERTEX    8,   14,  -25,     4,      1,    6,     6,         31    \ Vertex 8
 VERTEX   -8,   14,  -25,     5,      1,    6,     6,         31    \ Vertex 9

.SHIP_WORM_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     7,     0,         31    \ Edge 0
 EDGE       1,       5,     7,     3,         31    \ Edge 1
 EDGE       5,       7,     7,     5,         31    \ Edge 2
 EDGE       7,       6,     7,     6,         31    \ Edge 3
 EDGE       6,       4,     7,     4,         31    \ Edge 4
 EDGE       4,       0,     7,     2,         31    \ Edge 5
 EDGE       0,       2,     2,     0,         31    \ Edge 6
 EDGE       1,       3,     3,     0,         31    \ Edge 7
 EDGE       4,       2,     4,     2,         31    \ Edge 8
 EDGE       5,       3,     5,     3,         31    \ Edge 9
 EDGE       2,       8,     4,     1,         31    \ Edge 10
 EDGE       8,       6,     6,     4,         31    \ Edge 11
 EDGE       3,       9,     5,     1,         31    \ Edge 12
 EDGE       9,       7,     6,     5,         31    \ Edge 13
 EDGE       2,       3,     1,     0,         31    \ Edge 14
 EDGE       8,       9,     6,     1,         31    \ Edge 15

.SHIP_WORM_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE        0,       88,       70,         31      \ Face 0
 FACE        0,       69,       14,         31      \ Face 1
 FACE       70,       66,       35,         31      \ Face 2
 FACE      -70,       66,       35,         31      \ Face 3
 FACE       64,       49,       14,         31      \ Face 4
 FACE      -64,       49,       14,         31      \ Face 5
 FACE        0,        0,     -200,         31      \ Face 6
 FACE        0,      -80,        0,         31      \ Face 7

