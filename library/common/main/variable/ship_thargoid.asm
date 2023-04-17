\ ******************************************************************************
\
\       Name: SHIP_THARGOID
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Thargoid mothership
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_THARGOID

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 99 * 99           \ Targetable area          = 99 * 99
 EQUB LO(SHIP_THARGOID_EDGES - SHIP_THARGOID)      \ Edges data offset (low)
 EQUB LO(SHIP_THARGOID_FACES - SHIP_THARGOID)      \ Faces data offset (low)
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Advanced: The advanced versions of Elite have an extra edge count for the ship colour; Thargoids are shown in "white" (cyan/red stripes)
 EQUB 101               \ Max. edge count          = (101 - 1) / 4 = 25
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _NES_VERSION
 EQUB 105               \ Max. edge count          = (105 - 1) / 4 = 26
ENDIF
 EQUB 60                \ Gun vertex               = 60 / 4 = 15
 EQUB 38                \ Explosion count          = 8, as (4 * n) + 6 = 38
 EQUB 120               \ Number of vertices       = 120 / 6 = 20
 EQUB 26                \ Number of edges          = 26
 EQUW 500               \ Bounty                   = 500
 EQUB 40                \ Number of faces          = 40 / 4 = 10
 EQUB 55                \ Visibility distance      = 55
IF NOT(_ELITE_A_VERSION)
 EQUB 240               \ Max. energy              = 240
ELIF _ELITE_A_VERSION
 EQUB 253               \ Max. energy              = 253
ENDIF
 EQUB 39                \ Max. speed               = 39
 EQUB HI(SHIP_THARGOID_EDGES - SHIP_THARGOID)      \ Edges data offset (high)
 EQUB HI(SHIP_THARGOID_FACES - SHIP_THARGOID)      \ Faces data offset (high)
 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
IF NOT(_ELITE_A_VERSION)
 EQUB %00010110         \ Laser power              = 2
                        \ Missiles                 = 6

ELIF _ELITE_A_VERSION
 EQUB %00111000         \ Laser power              = 7
                        \ Missiles                 = 0

ENDIF

\          x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX   32,  -48,   48,     0,      4,    8,     8,         31    \ Vertex 0
 VERTEX   32,  -68,    0,     0,      1,    4,     4,         31    \ Vertex 1
 VERTEX   32,  -48,  -48,     1,      2,    4,     4,         31    \ Vertex 2
 VERTEX   32,    0,  -68,     2,      3,    4,     4,         31    \ Vertex 3
 VERTEX   32,   48,  -48,     3,      4,    5,     5,         31    \ Vertex 4
 VERTEX   32,   68,    0,     4,      5,    6,     6,         31    \ Vertex 5
 VERTEX   32,   48,   48,     4,      6,    7,     7,         31    \ Vertex 6
 VERTEX   32,    0,   68,     4,      7,    8,     8,         31    \ Vertex 7
 VERTEX  -24, -116,  116,     0,      8,    9,     9,         31    \ Vertex 8
 VERTEX  -24, -164,    0,     0,      1,    9,     9,         31    \ Vertex 9
 VERTEX  -24, -116, -116,     1,      2,    9,     9,         31    \ Vertex 10
 VERTEX  -24,    0, -164,     2,      3,    9,     9,         31    \ Vertex 11
 VERTEX  -24,  116, -116,     3,      5,    9,     9,         31    \ Vertex 12
 VERTEX  -24,  164,    0,     5,      6,    9,     9,         31    \ Vertex 13
 VERTEX  -24,  116,  116,     6,      7,    9,     9,         31    \ Vertex 14
 VERTEX  -24,    0,  164,     7,      8,    9,     9,         31    \ Vertex 15
 VERTEX  -24,   64,   80,     9,      9,    9,     9,         30    \ Vertex 16
 VERTEX  -24,   64,  -80,     9,      9,    9,     9,         30    \ Vertex 17
 VERTEX  -24,  -64,  -80,     9,      9,    9,     9,         30    \ Vertex 18
 VERTEX  -24,  -64,   80,     9,      9,    9,     9,         30    \ Vertex 19

.SHIP_THARGOID_EDGES

\     vertex1, vertex2, face1, face2, visibility
 EDGE       0,       7,     4,     8,         31    \ Edge 0
 EDGE       0,       1,     0,     4,         31    \ Edge 1
 EDGE       1,       2,     1,     4,         31    \ Edge 2
 EDGE       2,       3,     2,     4,         31    \ Edge 3
 EDGE       3,       4,     3,     4,         31    \ Edge 4
 EDGE       4,       5,     4,     5,         31    \ Edge 5
 EDGE       5,       6,     4,     6,         31    \ Edge 6
 EDGE       6,       7,     4,     7,         31    \ Edge 7
 EDGE       0,       8,     0,     8,         31    \ Edge 8
 EDGE       1,       9,     0,     1,         31    \ Edge 9
 EDGE       2,      10,     1,     2,         31    \ Edge 10
 EDGE       3,      11,     2,     3,         31    \ Edge 11
 EDGE       4,      12,     3,     5,         31    \ Edge 12
 EDGE       5,      13,     5,     6,         31    \ Edge 13
 EDGE       6,      14,     6,     7,         31    \ Edge 14
 EDGE       7,      15,     7,     8,         31    \ Edge 15
 EDGE       8,      15,     8,     9,         31    \ Edge 16
 EDGE       8,       9,     0,     9,         31    \ Edge 17
 EDGE       9,      10,     1,     9,         31    \ Edge 18
 EDGE      10,      11,     2,     9,         31    \ Edge 19
 EDGE      11,      12,     3,     9,         31    \ Edge 20
 EDGE      12,      13,     5,     9,         31    \ Edge 21
 EDGE      13,      14,     6,     9,         31    \ Edge 22
 EDGE      14,      15,     7,     9,         31    \ Edge 23
 EDGE      16,      17,     9,     9,         30    \ Edge 24
 EDGE      18,      19,     9,     9,         30    \ Edge 25

.SHIP_THARGOID_FACES

\     normal_x, normal_y, normal_z, visibility
 FACE      103,      -60,       25,         31    \ Face 0
 FACE      103,      -60,      -25,         31    \ Face 1
 FACE      103,      -25,      -60,         31    \ Face 2
 FACE      103,       25,      -60,         31    \ Face 3
 FACE       64,        0,        0,         31    \ Face 4
 FACE      103,       60,      -25,         31    \ Face 5
 FACE      103,       60,       25,         31    \ Face 6
 FACE      103,       25,       60,         31    \ Face 7
 FACE      103,      -25,       60,         31    \ Face 8
 FACE      -48,        0,        0,         31    \ Face 9

