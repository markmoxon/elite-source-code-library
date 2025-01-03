\ ******************************************************************************
\
\       Name: SHIP_SIDEWINDER
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Sidewinder
\  Deep dive: Ship blueprints
IF NOT(_ELITE_A_VERSION)
\             Comparing ship specifications
ENDIF
\
\ ******************************************************************************

.SHIP_SIDEWINDER

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 65 * 65           \ Targetable area          = 65 * 65

 EQUB LO(SHIP_SIDEWINDER_EDGES - SHIP_SIDEWINDER)  \ Edges data offset (low)
 EQUB LO(SHIP_SIDEWINDER_FACES - SHIP_SIDEWINDER)  \ Faces data offset (low)

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Advanced: The advanced versions of Elite have an extra edge count for the ship colour; Sidewinders are shown in cyan
 EQUB 61                \ Max. edge count          = (61 - 1) / 4 = 15
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
 EQUB 65                \ Max. edge count          = (65 - 1) / 4 = 16
ENDIF
 EQUB 0                 \ Gun vertex               = 0
 EQUB 30                \ Explosion count          = 6, as (4 * n) + 6 = 30
 EQUB 60                \ Number of vertices       = 60 / 6 = 10
 EQUB 15                \ Number of edges          = 15
IF NOT(_ELITE_A_VERSION)
 EQUW 50                \ Bounty                   = 50
ELIF _ELITE_A_SHIPS_S OR _ELITE_A_SHIPS_W
 EQUW 300               \ Bounty                   = 300
ELIF _ELITE_A_SHIPS_V
 EQUW 400               \ Bounty                   = 400
ELIF _ELITE_A_VERSION
 EQUW 100               \ Bounty                   = 100
ENDIF
 EQUB 28                \ Number of faces          = 28 / 4 = 7
 EQUB 20                \ Visibility distance      = 20
IF NOT(_ELITE_A_VERSION)
 EQUB 70                \ Max. energy              = 70
ELIF _ELITE_A_SHIPS_S OR _ELITE_A_SHIPS_V
 EQUB 82                \ Max. energy              = 82
ELIF _ELITE_A_SHIPS_W
 EQUB 81                \ Max. energy              = 81
ELIF _ELITE_A_VERSION
 EQUB 73                \ Max. energy              = 73
ENDIF
 EQUB 37                \ Max. speed               = 37

 EQUB HI(SHIP_SIDEWINDER_EDGES - SHIP_SIDEWINDER)  \ Edges data offset (high)
 EQUB HI(SHIP_SIDEWINDER_FACES - SHIP_SIDEWINDER)  \ Faces data offset (high)

 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
IF NOT(_ELITE_A_VERSION)
 EQUB %00010000         \ Laser power              = 2
                        \ Missiles                 = 0

ELIF _ELITE_A_SHIPS_V OR _ELITE_A_SHIPS_W
 EQUB %00101000         \ Laser power              = 5
                        \ Missiles                 = 0

ELIF _ELITE_A_VERSION
 EQUB %00100000         \ Laser power              = 4
                        \ Missiles                 = 0

ENDIF

.SHIP_SIDEWINDER_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX  -32,    0,   36,     0,      1,    4,     5,         31    \ Vertex 0
 VERTEX   32,    0,   36,     0,      2,    5,     6,         31    \ Vertex 1
 VERTEX   64,    0,  -28,     2,      3,    6,     6,         31    \ Vertex 2
 VERTEX  -64,    0,  -28,     1,      3,    4,     4,         31    \ Vertex 3
 VERTEX    0,   16,  -28,     0,      1,    2,     3,         31    \ Vertex 4
 VERTEX    0,  -16,  -28,     3,      4,    5,     6,         31    \ Vertex 5
 VERTEX  -12,    6,  -28,     3,      3,    3,     3,         15    \ Vertex 6
 VERTEX   12,    6,  -28,     3,      3,    3,     3,         15    \ Vertex 7
 VERTEX   12,   -6,  -28,     3,      3,    3,     3,         12    \ Vertex 8
 VERTEX  -12,   -6,  -28,     3,      3,    3,     3,         12    \ Vertex 9

.SHIP_SIDEWINDER_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     0,     5,         31    \ Edge 0
 EDGE       1,       2,     2,     6,         31    \ Edge 1
 EDGE       1,       4,     0,     2,         31    \ Edge 2
 EDGE       0,       4,     0,     1,         31    \ Edge 3
 EDGE       0,       3,     1,     4,         31    \ Edge 4
 EDGE       3,       4,     1,     3,         31    \ Edge 5
 EDGE       2,       4,     2,     3,         31    \ Edge 6
 EDGE       3,       5,     3,     4,         31    \ Edge 7
 EDGE       2,       5,     3,     6,         31    \ Edge 8
 EDGE       1,       5,     5,     6,         31    \ Edge 9
 EDGE       0,       5,     4,     5,         31    \ Edge 10
 EDGE       6,       7,     3,     3,         15    \ Edge 11
 EDGE       7,       8,     3,     3,         12    \ Edge 12
 EDGE       6,       9,     3,     3,         12    \ Edge 13
 EDGE       8,       9,     3,     3,         12    \ Edge 14

.SHIP_SIDEWINDER_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE        0,       32,        8,         31      \ Face 0
 FACE      -12,       47,        6,         31      \ Face 1
 FACE       12,       47,        6,         31      \ Face 2
 FACE        0,        0,     -112,         31      \ Face 3
 FACE      -12,      -47,        6,         31      \ Face 4
 FACE        0,      -32,        8,         31      \ Face 5
 FACE       12,      -47,        6,         31      \ Face 6

