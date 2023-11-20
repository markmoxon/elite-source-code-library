\ ******************************************************************************
\
\       Name: SHIP_KRAIT
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Krait
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_KRAIT

 EQUB 1                 \ Max. canisters on demise = 1
 EQUW 60 * 60           \ Targetable area          = 60 * 60

 EQUB LO(SHIP_KRAIT_EDGES - SHIP_KRAIT)            \ Edges data offset (low)
 EQUB LO(SHIP_KRAIT_FACES - SHIP_KRAIT)            \ Faces data offset (low)

IF _DISC_VERSION OR _ELITE_A_VERSION \ Advanced: The advanced versions of Elite have an extra edge count for the ship colour; Kraits are shown in cyan
 EQUB 85                \ Max. edge count          = (85 - 1) / 4 = 21
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION
 EQUB 89                \ Max. edge count          = (89 - 1) / 4 = 22
ENDIF
 EQUB 0                 \ Gun vertex               = 0
 EQUB 18                \ Explosion count          = 3, as (4 * n) + 6 = 18
 EQUB 102               \ Number of vertices       = 102 / 6 = 17
 EQUB 21                \ Number of edges          = 21
IF NOT(_ELITE_A_SHIPS_U OR _ELITE_A_SHIPS_W)
 EQUW 100               \ Bounty                   = 100
ELIF _ELITE_A_SHIPS_U
 EQUW 200               \ Bounty                   = 200
ELIF _ELITE_A_SHIPS_W
 EQUW 400               \ Bounty                   = 200
ENDIF
 EQUB 24                \ Number of faces          = 24 / 4 = 6
IF _DISC_FLIGHT OR _ELITE_A_VERSION \ Disc: In the disc version, the Krait has a visibility distance of 25 compared to 20 in the other versions, so if one is running away from you in the disc version, it will turn into a dot later than in the other versions
 EQUB 25                \ Visibility distance      = 25
ELIF _6502SP_VERSION OR _DISC_DOCKED OR _MASTER_VERSION OR _NES_VERSION
 EQUB 20                \ Visibility distance      = 20
ENDIF
IF NOT(_ELITE_A_VERSION)
 EQUB 80                \ Max. energy              = 80
ELIF _ELITE_A_SHIPS_U
 EQUB 81                \ Max. energy              = 81
ELIF _ELITE_A_SHIPS_W
 EQUB 82                \ Max. energy              = 82
ELIF _ELITE_A_VERSION
 EQUB 73                \ Max. energy              = 73
ENDIF
 EQUB 30                \ Max. speed               = 30

 EQUB HI(SHIP_KRAIT_EDGES - SHIP_KRAIT)            \ Edges data offset (high)
 EQUB HI(SHIP_KRAIT_FACES - SHIP_KRAIT)            \ Faces data offset (high)

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Disc: Group A: The ship hangar in the disc version displays the Krait with normals scaled with a factor of 4, which are more accurate than in the ship hangars of the other enhanced versions, which store them with a scale factor of 2
 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
ELIF _DISC_DOCKED
 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
ENDIF
IF NOT(_ELITE_A_6502SP_PARA OR _ELITE_A_FLIGHT OR _ELITE_A_SHIPS_W)
 EQUB %00010000         \ Laser power              = 2
                        \ Missiles                 = 0

ELIF _ELITE_A_SHIPS_W

 EQUB %00101000         \ Laser power              = 5
                        \ Missiles                 = 0

ELIF _ELITE_A_6502SP_PARA OR _ELITE_A_FLIGHT
 EQUB %00100000         \ Laser power              = 4
                        \ Missiles                 = 0

ENDIF

.SHIP_KRAIT_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    0,   96,     1,      0,    3,     2,         31    \ Vertex 0
 VERTEX    0,   18,  -48,     3,      0,    5,     4,         31    \ Vertex 1
 VERTEX    0,  -18,  -48,     2,      1,    5,     4,         31    \ Vertex 2
 VERTEX   90,    0,   -3,     1,      0,    4,     4,         31    \ Vertex 3
 VERTEX  -90,    0,   -3,     3,      2,    5,     5,         31    \ Vertex 4
IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform
 VERTEX   90,    0,   87,     1,      0,    1,     1,         30    \ Vertex 5
 VERTEX  -90,    0,   87,     3,      2,    3,     3,         30    \ Vertex 6
ELIF _DISC_DOCKED
 VERTEX   90,    0,   87,     1,     0,     1,     1,         28     \ Vertex 5
 VERTEX  -90,    0,   87,     3,     2,     3,     3,         28     \ Vertex 6
ENDIF
 VERTEX    0,    5,   53,     0,      0,    3,     3,          9    \ Vertex 7
 VERTEX    0,    7,   38,     0,      0,    3,     3,          6    \ Vertex 8
 VERTEX  -18,    7,   19,     3,      3,    3,     3,          9    \ Vertex 9
 VERTEX   18,    7,   19,     0,      0,    0,     0,          9    \ Vertex 10
 VERTEX   18,   11,  -39,     4,      4,    4,     4,          8    \ Vertex 11
 VERTEX   18,  -11,  -39,     4,      4,    4,     4,          8    \ Vertex 12
 VERTEX   36,    0,  -30,     4,      4,    4,     4,          8    \ Vertex 13
 VERTEX  -18,   11,  -39,     5,      5,    5,     5,          8    \ Vertex 14
 VERTEX  -18,  -11,  -39,     5,      5,    5,     5,          8    \ Vertex 15
 VERTEX  -36,    0,  -30,     5,      5,    5,     5,          8    \ Vertex 16

.SHIP_KRAIT_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     3,     0,         31    \ Edge 0
 EDGE       0,       2,     2,     1,         31    \ Edge 1
 EDGE       0,       3,     1,     0,         31    \ Edge 2
 EDGE       0,       4,     3,     2,         31    \ Edge 3
 EDGE       1,       4,     5,     3,         31    \ Edge 4
 EDGE       4,       2,     5,     2,         31    \ Edge 5
 EDGE       2,       3,     4,     1,         31    \ Edge 6
 EDGE       3,       1,     4,     0,         31    \ Edge 7
IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Platform
 EDGE       3,       5,     1,     0,         30    \ Edge 8
 EDGE       4,       6,     3,     2,         30    \ Edge 9
 EDGE       1,       2,     5,     4,          8    \ Edge 10
ELIF _DISC_DOCKED
 EDGE       3,       5,     1,     0,         28    \ Edge 8
 EDGE       4,       6,     3,     2,         28    \ Edge 9
 EDGE       1,       2,     5,     4,          5    \ Edge 10
ENDIF
 EDGE       7,      10,     0,     0,          9    \ Edge 11
 EDGE       8,      10,     0,     0,          6    \ Edge 12
 EDGE       7,       9,     3,     3,          9    \ Edge 13
 EDGE       8,       9,     3,     3,          6    \ Edge 14
 EDGE      11,      13,     4,     4,          8    \ Edge 15
 EDGE      13,      12,     4,     4,          8    \ Edge 16
 EDGE      12,      11,     4,     4,          7    \ Edge 17
 EDGE      14,      15,     5,     5,          7    \ Edge 18
 EDGE      15,      16,     5,     5,          8    \ Edge 19
 EDGE      16,      14,     5,     5,          8    \ Edge 20

.SHIP_KRAIT_FACES

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Disc: See group A

    \ normal_x, normal_y, normal_z, visibility
 FACE        3,       24,        3,         31    \ Face 0
 FACE        3,      -24,        3,         31    \ Face 1
 FACE       -3,      -24,        3,         31    \ Face 2
 FACE       -3,       24,        3,         31    \ Face 3
 FACE       38,        0,      -77,         31    \ Face 4
 FACE      -38,        0,      -77,         31    \ Face 5

ELIF _DISC_DOCKED

    \ normal_x, normal_y, normal_z, visibility
 FACE        7,       48,        6,         31    \ Face 0
 FACE        7,      -48,        6,         31    \ Face 1
 FACE       -7,      -48,        6,         31    \ Face 2
 FACE       -7,       48,        6,         31    \ Face 3
 FACE       77,        0,     -154,         31    \ Face 4
 FACE      -77,        0,     -154,         31    \ Face 5

ENDIF

