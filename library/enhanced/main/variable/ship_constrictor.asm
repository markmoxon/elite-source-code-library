\ ******************************************************************************
\
\       Name: SHIP_CONSTRICTOR
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Constrictor
\  Deep dive: Ship blueprints
IF NOT(_ELITE_A_VERSION)
\             Comparing ship specifications
ENDIF
\
\ ******************************************************************************

.SHIP_CONSTRICTOR

IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Platform
 EQUB 3                 \ Max. canisters on demise = 3
 EQUW 65 * 65           \ Targetable area          = 65 * 65
ELIF _DISC_DOCKED OR _ELITE_A_VERSION
 EQUB 3 + (15 << 4)     \ Max. canisters on demise = 3
                        \ Market item when scooped = 15 + 1 = 16 (alien items)
 EQUW 99 * 99           \ Targetable area          = 99 * 99
ENDIF

 EQUB LO(SHIP_CONSTRICTOR_EDGES - SHIP_CONSTRICTOR)   \ Edges data offset (low)
 EQUB LO(SHIP_CONSTRICTOR_FACES - SHIP_CONSTRICTOR)   \ Faces data offset (low)

IF _DISC_VERSION OR _ELITE_A_VERSION \ Advanced: The advanced versions of Elite have an extra edge count for the ship colour; Constrictors are shown in cyan
 EQUB 77                \ Max. edge count          = (77 - 1) / 4 = 19
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
 EQUB 81                \ Max. edge count          = (81 - 1) / 4 = 20
ENDIF
 EQUB 0                 \ Gun vertex               = 0
 EQUB 46                \ Explosion count          = 10, as (4 * n) + 6 = 46
 EQUB 102               \ Number of vertices       = 102 / 6 = 17
 EQUB 24                \ Number of edges          = 24
 EQUW 0                 \ Bounty                   = 0
 EQUB 40                \ Number of faces          = 40 / 4 = 10
 EQUB 45                \ Visibility distance      = 45
IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Platform
 EQUB 252               \ Max. energy              = 252
 EQUB 36                \ Max. speed               = 36
ELIF _DISC_DOCKED
 EQUB 200               \ Max. energy              = 200
 EQUB 55                \ Max. speed               = 55
ELIF _ELITE_A_DOCKED
 EQUB 118               \ Max. energy              = 118
 EQUB 55                \ Max. speed               = 55
ELIF _ELITE_A_6502SP_PARA OR _ELITE_A_FLIGHT
 EQUB 115               \ Max. energy              = 115
 EQUB 55                \ Max. speed               = 55
ENDIF

 EQUB HI(SHIP_CONSTRICTOR_EDGES - SHIP_CONSTRICTOR)   \ Edges data offset (high)
 EQUB HI(SHIP_CONSTRICTOR_FACES - SHIP_CONSTRICTOR)   \ Faces data offset (high)

 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Platform
 EQUB %00110100         \ Laser power              = 6
                        \ Missiles                 = 4
ELIF _DISC_DOCKED OR _ELITE_A_DOCKED
 EQUB %00101111         \ Laser power              = 5
                        \ Missiles                 = 7
ELIF _ELITE_A_6502SP_PARA OR _ELITE_A_FLIGHT
 EQUB %01000111         \ Laser power              = 8
                        \ Missiles                 = 7
ENDIF

.SHIP_CONSTRICTOR_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX   20,   -7,   80,     2,      0,    9,     9,         31    \ Vertex 0
 VERTEX  -20,   -7,   80,     1,      0,    9,     9,         31    \ Vertex 1
 VERTEX  -54,   -7,   40,     4,      1,    9,     9,         31    \ Vertex 2
 VERTEX  -54,   -7,  -40,     5,      4,    9,     8,         31    \ Vertex 3
 VERTEX  -20,   13,  -40,     6,      5,    8,     8,         31    \ Vertex 4
 VERTEX   20,   13,  -40,     7,      6,    8,     8,         31    \ Vertex 5
 VERTEX   54,   -7,  -40,     7,      3,    9,     8,         31    \ Vertex 6
 VERTEX   54,   -7,   40,     3,      2,    9,     9,         31    \ Vertex 7
 VERTEX   20,   13,    5,    15,     15,   15,    15,         31    \ Vertex 8
 VERTEX  -20,   13,    5,    15,     15,   15,    15,         31    \ Vertex 9
 VERTEX   20,   -7,   62,     9,      9,    9,     9,         18    \ Vertex 10
 VERTEX  -20,   -7,   62,     9,      9,    9,     9,         18    \ Vertex 11
 VERTEX   25,   -7,  -25,     9,      9,    9,     9,         18    \ Vertex 12
 VERTEX  -25,   -7,  -25,     9,      9,    9,     9,         18    \ Vertex 13
 VERTEX   15,   -7,  -15,     9,      9,    9,     9,         10    \ Vertex 14
 VERTEX  -15,   -7,  -15,     9,      9,    9,     9,         10    \ Vertex 15
 VERTEX    0,   -7,    0,    15,      9,    1,     0,          0    \ Vertex 16

.SHIP_CONSTRICTOR_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     9,     0,         31    \ Edge 0
 EDGE       1,       2,     9,     1,         31    \ Edge 1
 EDGE       1,       9,     1,     0,         31    \ Edge 2
 EDGE       0,       8,     2,     0,         31    \ Edge 3
 EDGE       0,       7,     9,     2,         31    \ Edge 4
 EDGE       7,       8,     3,     2,         31    \ Edge 5
 EDGE       2,       9,     4,     1,         31    \ Edge 6
 EDGE       2,       3,     9,     4,         31    \ Edge 7
 EDGE       6,       7,     9,     3,         31    \ Edge 8
 EDGE       6,       8,     7,     3,         31    \ Edge 9
 EDGE       5,       8,     7,     6,         31    \ Edge 10
 EDGE       4,       9,     6,     5,         31    \ Edge 11
 EDGE       3,       9,     5,     4,         31    \ Edge 12
 EDGE       3,       4,     8,     5,         31    \ Edge 13
 EDGE       4,       5,     8,     6,         31    \ Edge 14
 EDGE       5,       6,     8,     7,         31    \ Edge 15
 EDGE       3,       6,     9,     8,         31    \ Edge 16
 EDGE       8,       9,     6,     0,         31    \ Edge 17
 EDGE      10,      12,     9,     9,         18    \ Edge 18
 EDGE      12,      14,     9,     9,          5    \ Edge 19
 EDGE      14,      10,     9,     9,         10    \ Edge 20
 EDGE      11,      15,     9,     9,         10    \ Edge 21
 EDGE      13,      15,     9,     9,          5    \ Edge 22
 EDGE      11,      13,     9,     9,         18    \ Edge 23

.SHIP_CONSTRICTOR_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE        0,       55,       15,         31      \ Face 0
 FACE      -24,       75,       20,         31      \ Face 1
 FACE       24,       75,       20,         31      \ Face 2
 FACE       44,       75,        0,         31      \ Face 3
 FACE      -44,       75,        0,         31      \ Face 4
 FACE      -44,       75,        0,         31      \ Face 5
 FACE        0,       53,        0,         31      \ Face 6
 FACE       44,       75,        0,         31      \ Face 7
 FACE        0,        0,     -160,         31      \ Face 8
 FACE        0,      -27,        0,         31      \ Face 9

