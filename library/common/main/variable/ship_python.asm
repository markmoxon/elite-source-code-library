\ ******************************************************************************
\
\       Name: SHIP_PYTHON
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Python
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_PYTHON

IF _CASSETTE_VERSION \ Feature: Pythons in the cassette version spawn up to 3 canisters on their demise, but this rises to 5 canisters in all other versions
 EQUB 3                 \ Max. canisters on demise = 3
ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION
 EQUB 5                 \ Max. canisters on demise = 5
ENDIF
IF _CASSETTE_VERSION \ Feature: Pythons in the cassette version have a larger targetable area (120 x 120) than in all other versions (80 x 80)
 EQUW 120 * 120         \ Targetable area          = 120 * 120
ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION
 EQUW 80 * 80           \ Targetable area          = 80 * 80
ENDIF
 EQUB &56               \ Edges data offset (low)  = &0056
 EQUB &BE               \ Faces data offset (low)  = &00BE
IF _CASSETTE_VERSION OR _DISC_VERSION \ Advanced: The colour versions of Elite have an extra edge count for the ship colour; Pythons are shown in cyan
 EQUB 85                \ Max. edge count          = (85 - 1) / 4 = 21
ELIF _6502SP_VERSION OR _MASTER_VERSION
 EQUB 89                \ Max. edge count          = (89 - 1) / 4 = 22
ENDIF
 EQUB 0                 \ Gun vertex               = 0
IF _CASSETTE_VERSION \ Feature: Pythons in the cassette version have a slightly more glorious demise, with 10 expoding nodes compared to 9 nodes in all other versions
 EQUB 46                \ Explosion count          = 10, as (4 * n) + 6 = 46
ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION
 EQUB 42                \ Explosion count          = 9, as (4 * n) + 6 = 42
ENDIF
 EQUB 66                \ Number of vertices       = 66 / 6 = 11
 EQUB 26                \ Number of edges          = 26
IF _CASSETTE_VERSION \ Feature: All Pythons in the cassette version have a bounty of 200 Cr, whereas other versions have two types of Python: traders (with no bounty) and pirates (with a bounty of 200 Cr)
 EQUW 200               \ Bounty                   = 200
ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION
 EQUW 0                 \ Bounty                   = 0
ENDIF
 EQUB 52                \ Number of faces          = 52 / 4 = 13
 EQUB 40                \ Visibility distance      = 40
 EQUB 250               \ Max. energy              = 250
 EQUB 20                \ Max. speed               = 20
 EQUB &00               \ Edges data offset (high) = &0056
 EQUB &00               \ Faces data offset (high) = &00BE
 EQUB 0                 \ Normals are scaled by    = 2^0 = 1
 EQUB %00011011         \ Laser power              = 3
                        \ Missiles                 = 3

\VERTEX    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    0,  224,     0,      1,    2,     3,         31    \ Vertex 0
IF _CASSETTE_VERSION OR _DISC_DOCKED \ Feature: Group A: The Python has a number of different visibility settings for vertices, edges and faces between the cassette and disc ship hanger versions (which have slightly lower visibility values), and the other versions
 VERTEX    0,   48,   48,     0,      1,    4,     5,         30    \ Vertex 1
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION
 VERTEX    0,   48,   48,     0,      1,    4,     5,         31    \ Vertex 1
ENDIF
 VERTEX   96,    0,  -16,    15,     15,   15,    15,         31    \ Vertex 2
 VERTEX  -96,    0,  -16,    15,     15,   15,    15,         31    \ Vertex 3
IF _CASSETTE_VERSION OR _DISC_DOCKED \ Feature: See group A
 VERTEX    0,   48,  -32,     4,      5,    8,     9,         30    \ Vertex 4
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION
 VERTEX    0,   48,  -32,     4,      5,    8,     9,         31    \ Vertex 4
ENDIF
 VERTEX    0,   24, -112,     9,      8,   12,    12,         31    \ Vertex 5
 VERTEX  -48,    0, -112,     8,     11,   12,    12,         31    \ Vertex 6
 VERTEX   48,    0, -112,     9,     10,   12,    12,         31    \ Vertex 7
IF _CASSETTE_VERSION OR _DISC_DOCKED \ Feature: See group A
 VERTEX    0,  -48,   48,     2,      3,    6,     7,         30    \ Vertex 8
 VERTEX    0,  -48,  -32,     6,      7,   10,    11,         30    \ Vertex 9
 VERTEX    0,  -24, -112,    10,     11,   12,    12,         30    \ Vertex 10
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION
 VERTEX    0,  -48,   48,     2,      3,    6,     7,         31    \ Vertex 8
 VERTEX    0,  -48,  -32,     6,      7,   10,    11,         31    \ Vertex 9
 VERTEX    0,  -24, -112,    10,     11,   12,    12,         31    \ Vertex 10
ENDIF

IF _MASTER_VERSION \ Label

.SHIP_PYTHON_EDGES

ENDIF

\EDGE vertex1, vertex2, face1, face2, visibility
IF _CASSETTE_VERSION OR _DISC_DOCKED \ Feature: See group A
 EDGE       0,       8,     2,     3,         30    \ Edge 0
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION
 EDGE       0,       8,     2,     3,         31    \ Edge 0
ENDIF
 EDGE       0,       3,     0,     2,         31    \ Edge 1
 EDGE       0,       2,     1,     3,         31    \ Edge 2
IF _CASSETTE_VERSION OR _DISC_DOCKED \ Feature: See group A
 EDGE       0,       1,     0,     1,         30    \ Edge 3
 EDGE       2,       4,     9,     5,         29    \ Edge 4
 EDGE       1,       2,     1,     5,         29    \ Edge 5
 EDGE       2,       8,     7,     3,         29    \ Edge 6
 EDGE       1,       3,     0,     4,         29    \ Edge 7
 EDGE       3,       8,     2,     6,         29    \ Edge 8
 EDGE       2,       9,     7,    10,         29    \ Edge 9
 EDGE       3,       4,     4,     8,         29    \ Edge 10
 EDGE       3,       9,     6,    11,         29    \ Edge 11
 EDGE       3,       5,     8,     8,          5    \ Edge 12
 EDGE       3,      10,    11,    11,          5    \ Edge 13
 EDGE       2,       5,     9,     9,          5    \ Edge 14
 EDGE       2,      10,    10,    10,          5    \ Edge 15
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION
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
ENDIF
 EDGE       2,       7,     9,    10,         31    \ Edge 16
 EDGE       3,       6,     8,    11,         31    \ Edge 17
 EDGE       5,       6,     8,    12,         31    \ Edge 18
 EDGE       5,       7,     9,    12,         31    \ Edge 19
IF _CASSETTE_VERSION OR _DISC_DOCKED \ Feature: See group A
 EDGE       7,      10,    12,    10,         29    \ Edge 20
 EDGE       6,      10,    11,    12,         29    \ Edge 21
 EDGE       4,       5,     8,     9,         29    \ Edge 22
 EDGE       9,      10,    10,    11,         29    \ Edge 23
 EDGE       1,       4,     4,     5,         29    \ Edge 24
 EDGE       8,       9,     6,     7,         29    \ Edge 25
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION
 EDGE       7,      10,    12,    10,         31    \ Edge 20
 EDGE       6,      10,    11,    12,         31    \ Edge 21
 EDGE       4,       5,     8,     9,         31    \ Edge 22
 EDGE       9,      10,    10,    11,         31    \ Edge 23
 EDGE       1,       4,     4,     5,         31    \ Edge 24
 EDGE       8,       9,     6,     7,         31    \ Edge 25
ENDIF

IF _MASTER_VERSION \ Label

.SHIP_PYTHON_FACES

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Feature: See group A

\FACE normal_x, normal_y, normal_z, visibility
 FACE      -27,       40,       11,         30    \ Face 0
 FACE       27,       40,       11,         30    \ Face 1
 FACE      -27,      -40,       11,         30    \ Face 2
 FACE       27,      -40,       11,         30    \ Face 3
 FACE      -19,       38,        0,         30    \ Face 4
 FACE       19,       38,        0,         30    \ Face 5
 FACE      -19,      -38,        0,         30    \ Face 6
 FACE       19,      -38,        0,         30    \ Face 7
 FACE      -25,       37,      -11,         30    \ Face 8
 FACE       25,       37,      -11,         30    \ Face 9
 FACE       25,      -37,      -11,         30    \ Face 10
 FACE      -25,      -37,      -11,         30    \ Face 11
 FACE        0,        0,     -112,         30    \ Face 12

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

\FACE normal_x, normal_y, normal_z, visibility
 FACE      -27,       40,       11,        31    \ Face 0
 FACE       27,       40,       11,        31    \ Face 1
 FACE      -27,      -40,       11,        31    \ Face 2
 FACE       27,      -40,       11,        31    \ Face 3
 FACE      -19,       38,        0,        31    \ Face 4
 FACE       19,       38,        0,        31    \ Face 5
 FACE      -19,      -38,        0,        31    \ Face 6
 FACE       19,      -38,        0,        31    \ Face 7
 FACE      -25,       37,      -11,        31    \ Face 8
 FACE       25,       37,      -11,        31    \ Face 9
 FACE       25,      -37,      -11,        31    \ Face 10
 FACE      -25,      -37,      -11,        31    \ Face 11
 FACE        0,        0,     -112,        31    \ Face 12

ENDIF

