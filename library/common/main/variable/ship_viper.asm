\ ******************************************************************************
\
\       Name: SHIP_VIPER
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Viper
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_VIPER

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 75 * 75           \ Targetable area          = 75 * 75
 EQUB LO(SHIP_VIPER_EDGES - SHIP_VIPER)            \ Edges data offset (low)
 EQUB LO(SHIP_VIPER_FACES - SHIP_VIPER)            \ Faces data offset (low)
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Advanced: The advanced versions of Elite have an extra edge count for the ship colour; Vipers are shown in cyan
 EQUB 77                \ Max. edge count          = (77 - 1) / 4 = 19
ELIF _6502SP_VERSION OR _MASTER_VERSION
 EQUB 81                \ Max. edge count          = (81 - 1) / 4 = 20
ENDIF
 EQUB 0                 \ Gun vertex               = 0
 EQUB 42                \ Explosion count          = 9, as (4 * n) + 6 = 42
 EQUB 90                \ Number of vertices       = 90 / 6 = 15
 EQUB 20                \ Number of edges          = 20
IF NOT(_ELITE_A_VERSION)
 EQUW 0                 \ Bounty                   = 0
ELIF _ELITE_A_SHIPS_R OR _ELITE_A_SHIPS_S OR _ELITE_A_SHIPS_T
 EQUW 100               \ Bounty                   = 100
ELIF _ELITE_A_SHIPS_U OR _ELITE_A_SHIPS_V OR _ELITE_A_SHIPS_W
 EQUW 200               \ Bounty                   = 100
ELIF _ELITE_A_VERSION
 EQUW 0                 \ Bounty                   = 0
ENDIF
 EQUB 28                \ Number of faces          = 28 / 4 = 7
 EQUB 23                \ Visibility distance      = 23
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: The Viper has a different maximum energy in the disc version (100), cassette version (120) and advanced versions (140), so they are easiest to kill in the disc version, harder to kill in the cassette version, and even harder to kill in the advanced versions
 EQUB 120               \ Max. energy              = 120
ELIF _DISC_VERSION OR _ELITE_A_SHIPS_U OR _ELITE_A_SHIPS_V
 EQUB 100               \ Max. energy              = 100
ELIF _6502SP_VERSION OR _MASTER_VERSION
 EQUB 140               \ Max. energy              = 140
ELIF _ELITE_A_SHIPS_R OR _ELITE_A_SHIPS_T OR _ELITE_A_SHIPS_W
 EQUB 92                \ Max. energy              = 91
ELIF _ELITE_A_SHIPS_S
 EQUB 99                \ Max. energy              = 99
ELIF _ELITE_A_VERSION
 EQUB 91                \ Max. energy              = 91
ENDIF
 EQUB 32                \ Max. speed               = 32
 EQUB HI(SHIP_VIPER_EDGES - SHIP_VIPER)            \ Edges data offset (high)
 EQUB HI(SHIP_VIPER_FACES - SHIP_VIPER)            \ Faces data offset (high)
 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
IF NOT(_ELITE_A_6502SP_PARA OR _ELITE_A_FLIGHT)
 EQUB %00010001         \ Laser power              = 2
                        \ Missiles                 = 1

ELIF _ELITE_A_SHIPS_W
 EQUB %00110001         \ Laser power              = 6
                        \ Missiles                 = 1

ELIF _ELITE_A_6502SP_PARA OR _ELITE_A_FLIGHT
 EQUB %00101001         \ Laser power              = 5
                        \ Missiles                 = 1

ENDIF

\          x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    0,   72,     1,      2,    3,     4,         31    \ Vertex 0
 VERTEX    0,   16,   24,     0,      1,    2,     2,         30    \ Vertex 1
 VERTEX    0,  -16,   24,     3,      4,    5,     5,         30    \ Vertex 2
 VERTEX   48,    0,  -24,     2,      4,    6,     6,         31    \ Vertex 3
 VERTEX  -48,    0,  -24,     1,      3,    6,     6,         31    \ Vertex 4
 VERTEX   24,  -16,  -24,     4,      5,    6,     6,         30    \ Vertex 5
 VERTEX  -24,  -16,  -24,     5,      3,    6,     6,         30    \ Vertex 6
 VERTEX   24,   16,  -24,     0,      2,    6,     6,         31    \ Vertex 7
 VERTEX  -24,   16,  -24,     0,      1,    6,     6,         31    \ Vertex 8
 VERTEX  -32,    0,  -24,     6,      6,    6,     6,         19    \ Vertex 9
 VERTEX   32,    0,  -24,     6,      6,    6,     6,         19    \ Vertex 10
 VERTEX    8,    8,  -24,     6,      6,    6,     6,         19    \ Vertex 11
 VERTEX   -8,    8,  -24,     6,      6,    6,     6,         19    \ Vertex 12
 VERTEX   -8,   -8,  -24,     6,      6,    6,     6,         18    \ Vertex 13
 VERTEX    8,   -8,  -24,     6,      6,    6,     6,         18    \ Vertex 14

.SHIP_VIPER_EDGES

\     vertex1, vertex2, face1, face2, visibility
 EDGE       0,       3,     2,     4,         31    \ Edge 0
 EDGE       0,       1,     1,     2,         30    \ Edge 1
 EDGE       0,       2,     3,     4,         30    \ Edge 2
 EDGE       0,       4,     1,     3,         31    \ Edge 3
 EDGE       1,       7,     0,     2,         30    \ Edge 4
 EDGE       1,       8,     0,     1,         30    \ Edge 5
 EDGE       2,       5,     4,     5,         30    \ Edge 6
 EDGE       2,       6,     3,     5,         30    \ Edge 7
 EDGE       7,       8,     0,     6,         31    \ Edge 8
 EDGE       5,       6,     5,     6,         30    \ Edge 9
 EDGE       4,       8,     1,     6,         31    \ Edge 10
 EDGE       4,       6,     3,     6,         30    \ Edge 11
 EDGE       3,       7,     2,     6,         31    \ Edge 12
 EDGE       3,       5,     6,     4,         30    \ Edge 13
 EDGE       9,      12,     6,     6,         19    \ Edge 14
 EDGE       9,      13,     6,     6,         18    \ Edge 15
 EDGE      10,      11,     6,     6,         19    \ Edge 16
 EDGE      10,      14,     6,     6,         18    \ Edge 17
 EDGE      11,      14,     6,     6,         16    \ Edge 18
 EDGE      12,      13,     6,     6,         16    \ Edge 19

.SHIP_VIPER_FACES

\     normal_x, normal_y, normal_z, visibility
 FACE        0,       32,        0,         31    \ Face 0
 FACE      -22,       33,       11,         31    \ Face 1
 FACE       22,       33,       11,         31    \ Face 2
 FACE      -22,      -33,       11,         31    \ Face 3
 FACE       22,      -33,       11,         31    \ Face 4
 FACE        0,      -32,        0,         31    \ Face 5
 FACE        0,        0,      -48,         31    \ Face 6

