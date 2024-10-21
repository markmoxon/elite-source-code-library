\ ******************************************************************************
\
\       Name: SHIP_ROCK_HERMIT
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a rock hermit (asteroid)
\  Deep dive: Ship blueprints
\
IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ The ship blueprint for the rock hermit reuses the edges and faces data from
\ the asteroid, so the edges and faces data offsets are negative.
\
ENDIF
\ ******************************************************************************

.SHIP_ROCK_HERMIT

 EQUB 7                 \ Max. canisters on demise = 7
 EQUW 80 * 80           \ Targetable area          = 80 * 80

IF _MASTER_VERSION OR _APPLE_VERSION \ Platform

 EQUB LO(SHIP_ASTEROID_EDGES - SHIP_ROCK_HERMIT)   \ Edges from asteroid
 EQUB LO(SHIP_ASTEROID_FACES - SHIP_ROCK_HERMIT)   \ Faces from asteroid

ELIF _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION

 EQUB LO(SHIP_ROCK_HERMIT_EDGES - SHIP_ROCK_HERMIT)   \ Edges data offset (low)
 EQUB LO(SHIP_ROCK_HERMIT_FACES - SHIP_ROCK_HERMIT)   \ Faces data offset (low)

ENDIF

 EQUB 69                \ Max. edge count          = (69 - 1) / 4 = 17
 EQUB 0                 \ Gun vertex               = 0
 EQUB 50                \ Explosion count          = 11, as (4 * n) + 6 = 50
 EQUB 54                \ Number of vertices       = 54 / 6 = 9
 EQUB 21                \ Number of edges          = 21
 EQUW 0                 \ Bounty                   = 0
 EQUB 56                \ Number of faces          = 56 / 4 = 14
 EQUB 50                \ Visibility distance      = 50
 EQUB 180               \ Max. energy              = 180
 EQUB 30                \ Max. speed               = 30

IF _MASTER_VERSION OR _APPLE_VERSION \ Platform

 EQUB HI(SHIP_ASTEROID_EDGES - SHIP_ROCK_HERMIT)   \ Edges from asteroid
 EQUB HI(SHIP_ASTEROID_FACES - SHIP_ROCK_HERMIT)   \ Faces from asteroid

ELIF _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION

 EQUB HI(SHIP_ROCK_HERMIT_EDGES - SHIP_ROCK_HERMIT)   \ Edges data offset (high)
 EQUB HI(SHIP_ROCK_HERMIT_FACES - SHIP_ROCK_HERMIT)   \ Faces data offset (high)

ENDIF

 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
 EQUB %00000010         \ Laser power              = 0
                        \ Missiles                 = 2

.SHIP_ROCK_HERMIT_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,   80,    0,    15,     15,   15,    15,         31    \ Vertex 0
 VERTEX  -80,  -10,    0,    15,     15,   15,    15,         31    \ Vertex 1
 VERTEX    0,  -80,    0,    15,     15,   15,    15,         31    \ Vertex 2
 VERTEX   70,  -40,    0,    15,     15,   15,    15,         31    \ Vertex 3
 VERTEX   60,   50,    0,     5,      6,   12,    13,         31    \ Vertex 4
 VERTEX   50,    0,   60,    15,     15,   15,    15,         31    \ Vertex 5
 VERTEX  -40,    0,   70,     0,      1,    2,     3,         31    \ Vertex 6
 VERTEX    0,   30,  -75,    15,     15,   15,    15,         31    \ Vertex 7
 VERTEX    0,  -50,  -60,     8,      9,   10,    11,         31    \ Vertex 8

IF _6502SP_VERSION OR _C64_VERSION OR _NES_VERSION \ Platform

.SHIP_ROCK_HERMIT_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     2,     7,         31    \ Edge 0
 EDGE       0,       4,     6,    13,         31    \ Edge 1
 EDGE       3,       4,     5,    12,         31    \ Edge 2
 EDGE       2,       3,     4,    11,         31    \ Edge 3
 EDGE       1,       2,     3,    10,         31    \ Edge 4
 EDGE       1,       6,     2,     3,         31    \ Edge 5
 EDGE       2,       6,     1,     3,         31    \ Edge 6
 EDGE       2,       5,     1,     4,         31    \ Edge 7
 EDGE       5,       6,     0,     1,         31    \ Edge 8
 EDGE       0,       5,     0,     6,         31    \ Edge 9
 EDGE       3,       5,     4,     5,         31    \ Edge 10
 EDGE       0,       6,     0,     2,         31    \ Edge 11
 EDGE       4,       5,     5,     6,         31    \ Edge 12
 EDGE       1,       8,     8,    10,         31    \ Edge 13
 EDGE       1,       7,     7,     8,         31    \ Edge 14
 EDGE       0,       7,     7,    13,         31    \ Edge 15
 EDGE       4,       7,    12,    13,         31    \ Edge 16
 EDGE       3,       7,     9,    12,         31    \ Edge 17
 EDGE       3,       8,     9,    11,         31    \ Edge 18
 EDGE       2,       8,    10,    11,         31    \ Edge 19
 EDGE       7,       8,     8,     9,         31    \ Edge 20

.SHIP_ROCK_HERMIT_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE        9,       66,       81,         31    \ Face 0
 FACE        9,      -66,       81,         31    \ Face 1
 FACE      -72,       64,       31,         31    \ Face 2
 FACE      -64,      -73,       47,         31    \ Face 3
 FACE       45,      -79,       65,         31    \ Face 4
 FACE      135,       15,       35,         31    \ Face 5
 FACE       38,       76,       70,         31    \ Face 6
 FACE      -66,       59,      -39,         31    \ Face 7
 FACE      -67,      -15,      -80,         31    \ Face 8
 FACE       66,      -14,      -75,         31    \ Face 9
 FACE      -70,      -80,      -40,         31    \ Face 10
 FACE       58,     -102,      -51,         31    \ Face 11
 FACE       81,        9,      -67,         31    \ Face 12
 FACE       47,       94,      -63,         31    \ Face 13

ENDIF

