\ ******************************************************************************
\
\       Name: SHIP_PYTHON_P
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Python (pirate)
\  Deep dive: Ship blueprints
\
IF _MASTER_VERSION
\ ------------------------------------------------------------------------------
\
\ The ship blueprint for the pirate Python reuses the edges and faces data from
\ the non-pirate Python, so the edges and faces data offsets are negative.
\
ENDIF
\ ******************************************************************************

.SHIP_PYTHON_P

 EQUB 2                 \ Max. canisters on demise = 2
 EQUW 80 * 80           \ Targetable area          = 80 * 80
IF _MASTER_VERSION
 EQUB LO(SHIP_PYTHON_EDGES - SHIP_PYTHON_P)          \ Edges data = Python
 EQUB LO(SHIP_PYTHON_FACES - SHIP_PYTHON_P)          \ Faces data = Python
ELIF _6502SP_VERSION OR _DISC_FLIGHT
 EQUB &56               \ Edges data offset (low)  = &0056
 EQUB &BE               \ Faces data offset (low)  = &00BE
ENDIF
IF _DISC_FLIGHT
 EQUB 85                \ Max. edge count          = (85 - 1) / 4 = 21
ELIF _6502SP_VERSION OR _MASTER_VERSION
 EQUB 89                \ Max. edge count          = (89 - 1) / 4 = 22
ENDIF
 EQUB 0                 \ Gun vertex               = 0
 EQUB 42                \ Explosion count          = 9, as (4 * n) + 6 = 42
 EQUB 66                \ Number of vertices       = 66 / 6 = 11
 EQUB 26                \ Number of edges          = 26
 EQUW 200               \ Bounty                   = 200
 EQUB 52                \ Number of faces          = 52 / 4 = 13
 EQUB 40                \ Visibility distance      = 40
 EQUB 250               \ Max. energy              = 250
 EQUB 20                \ Max. speed               = 20
IF _MASTER_VERSION
 EQUB HI(SHIP_PYTHON_EDGES - SHIP_PYTHON_P)          \ Edges data = Python
 EQUB HI(SHIP_PYTHON_FACES - SHIP_PYTHON_P)          \ Faces data = Python
ELIF _6502SP_VERSION OR _DISC_FLIGHT
 EQUB &00               \ Edges data offset (high) = &0056
 EQUB &00               \ Faces data offset (high) = &00BE
ENDIF
 EQUB 0                 \ Normals are scaled by    = 2^0 = 1
 EQUB %00011011         \ Laser power              = 3
                        \ Missiles                 = 3

\VERTEX    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    0,  224,     0,      1,    2,     3,         31    \ Vertex 0
 VERTEX    0,   48,   48,     0,      1,    4,     5,         31    \ Vertex 1
 VERTEX   96,    0,  -16,    15,     15,   15,    15,         31    \ Vertex 2
 VERTEX  -96,    0,  -16,    15,     15,   15,    15,         31    \ Vertex 3
 VERTEX    0,   48,  -32,     4,      5,    8,     9,         31    \ Vertex 4
 VERTEX    0,   24, -112,     9,      8,   12,    12,         31    \ Vertex 5
 VERTEX  -48,    0, -112,     8,     11,   12,    12,         31    \ Vertex 6
 VERTEX   48,    0, -112,     9,     10,   12,    12,         31    \ Vertex 7
 VERTEX    0,  -48,   48,     2,      3,    6,     7,         31    \ Vertex 8
 VERTEX    0,  -48,  -32,     6,      7,   10,    11,         31    \ Vertex 9
 VERTEX    0,  -24, -112,    10,     11,   12,    12,         31    \ Vertex 10

IF _6502SP_VERSION OR _DISC_FLIGHT

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       8,     2,     3,         31    \ Edge 0
 EDGE       0,       3,     0,     2,         31    \ Edge 1
 EDGE       0,       2,     1,     3,         31    \ Edge 2
 EDGE       0,       1,     0,     1,         31    \ Edge 3
 EDGE       2,       4,     9,     5,         31    \ Edge 4
 EDGE       1,       2,     1,     5,         31    \ Edge 5
 EDGE       2,       8,     7,     3,         31    \ Edge 6
 EDGE       1,       3,     0,     4,         31    \ Edge 7
 EDGE       3,       8,     2,     6,         31    \ Edge 8
 EDGE       2,       9,     7,    10,         31    \ Edge 9
 EDGE       3,       4,     4,     8,         31    \ Edge 10
 EDGE       3,       9,     6,    11,         31    \ Edge 11
 EDGE       3,       5,     8,     8,          7    \ Edge 12
 EDGE       3,      10,    11,    11,          7    \ Edge 13
 EDGE       2,       5,     9,     9,          7    \ Edge 14
 EDGE       2,      10,    10,    10,          7    \ Edge 15
 EDGE       2,       7,     9,    10,         31    \ Edge 16
 EDGE       3,       6,     8,    11,         31    \ Edge 17
 EDGE       5,       6,     8,    12,         31    \ Edge 18
 EDGE       5,       7,     9,    12,         31    \ Edge 19
 EDGE       7,      10,    12,    10,         31    \ Edge 20
 EDGE       6,      10,    11,    12,         31    \ Edge 21
 EDGE       4,       5,     8,     9,         31    \ Edge 22
 EDGE       9,      10,    10,    11,         31    \ Edge 23
 EDGE       1,       4,     4,     5,         31    \ Edge 24
 EDGE       8,       9,     6,     7,         31    \ Edge 25

\FACE normal_x, normal_y, normal_z, visibility
 FACE      -27,       40,       11,         31    \ Face 0
 FACE       27,       40,       11,         31    \ Face 1
 FACE      -27,      -40,       11,         31    \ Face 2
 FACE       27,      -40,       11,         31    \ Face 3
 FACE      -19,       38,        0,         31    \ Face 4
 FACE       19,       38,        0,         31    \ Face 5
 FACE      -19,      -38,        0,         31    \ Face 6
 FACE       19,      -38,        0,         31    \ Face 7
 FACE      -25,       37,      -11,         31    \ Face 8
 FACE       25,       37,      -11,         31    \ Face 9
 FACE       25,      -37,      -11,         31    \ Face 10
 FACE      -25,      -37,      -11,         31    \ Face 11
 FACE        0,        0,     -112,         31    \ Face 12

ENDIF

