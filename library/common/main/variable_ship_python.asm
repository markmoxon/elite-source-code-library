\ ******************************************************************************
\
\       Name: SHIP_PYTHON
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Python
\
\ ******************************************************************************

.SHIP_PYTHON

IF _CASSETTE_VERSION
 EQUB 3                 \ Max. canisters on demise = 3
 EQUW 120 * 120         \ Targetable area          = 120 * 120
ELIF _6502SP_VERSION
 EQUB 5                 \ Max. canisters on demise = 5
 EQUW 80 * 80           \ Targetable area          = 80 * 80
ENDIF
 EQUB &56               \ Edges data offset (low)  = &0056
 EQUB &BE               \ Faces data offset (low)  = &00BE
IF _CASSETTE_VERSION
 EQUB 85                \ Max. edge count          = (85 - 1) / 4 = 21
ELIF _6502SP_VERSION
 EQUB 89                \ Max. edge count          = (89 - 1) / 4 = 22
ENDIF
 EQUB 0                 \ Gun vertex               = 0
IF _CASSETTE_VERSION
 EQUB 46                \ Explosion count          = 10, as (4 * n) + 6 = 46
ELIF _6502SP_VERSION
 EQUB 42                \ Explosion count          = 9, as (4 * n) + 6 = 42
ENDIF
 EQUB 66                \ Number of vertices       = 66 / 6 = 11
 EQUB 26                \ Number of edges          = 26
IF _CASSETTE_VERSION
 EQUW 200               \ Bounty                   = 200
ELIF _6502SP_VERSION
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

IF _CASSETTE_VERSION

\VERTEX    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,    0,  224,     0,      1,    2,     3,         31    \ Vertex 0
 VERTEX    0,   48,   48,     0,      1,    4,     5,         30    \ Vertex 1
 VERTEX   96,    0,  -16,    15,     15,   15,    15,         31    \ Vertex 2
 VERTEX  -96,    0,  -16,    15,     15,   15,    15,         31    \ Vertex 3
 VERTEX    0,   48,  -32,     4,      5,    8,     9,         30    \ Vertex 4
 VERTEX    0,   24, -112,     9,      8,   12,    12,         31    \ Vertex 5
 VERTEX  -48,    0, -112,     8,     11,   12,    12,         31    \ Vertex 6
 VERTEX   48,    0, -112,     9,     10,   12,    12,         31    \ Vertex 7
 VERTEX    0,  -48,   48,     2,      3,    6,     7,         30    \ Vertex 8
 VERTEX    0,  -48,  -32,     6,      7,   10,    11,         30    \ Vertex 9
 VERTEX    0,  -24, -112,    10,     11,   12,    12,         30    \ Vertex 10

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       8,     2,     3,         30    \ Edge 0
 EDGE       0,       3,     0,     2,         31    \ Edge 1
 EDGE       0,       2,     1,     3,         31    \ Edge 2
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
 EDGE       2,       7,     9,    10,         31    \ Edge 16
 EDGE       3,       6,     8,    11,         31    \ Edge 17
 EDGE       5,       6,     8,    12,         31    \ Edge 18
 EDGE       5,       7,     9,    12,         31    \ Edge 19
 EDGE       7,      10,    12,    10,         29    \ Edge 20
 EDGE       6,      10,    11,    12,         29    \ Edge 21
 EDGE       4,       5,     8,     9,         29    \ Edge 22
 EDGE       9,      10,    10,    11,         29    \ Edge 23
 EDGE       1,       4,     4,     5,         29    \ Edge 24
 EDGE       8,       9,     6,     7,         29    \ Edge 25

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

 SKIP 11                \ This space is unused

ELIF _6502SP_VERSION

 VERTEX    0,    0,  224,     0,      1,    2,     3,         31    \ Vertex 0
 EQUB &00, &30, &30, &1F, &10, &54
 VERTEX   96,    0,  -16,    15,     15,   15,    15,         31    \ Vertex 2
 VERTEX  -96,    0,  -16,    15,     15,   15,    15,         31    \ Vertex 3
 EQUB &00, &30, &20, &3F, &54, &98
 VERTEX    0,   24, -112,     9,      8,   12,    12,         31    \ Vertex 5
 VERTEX  -48,    0, -112,     8,     11,   12,    12,         31    \ Vertex 6
 VERTEX   48,    0, -112,     9,     10,   12,    12,         31    \ Vertex 7
 EQUB &00, &30, &30, &5F, &32, &76
 EQUB &00, &30, &20, &7F, &76, &BA
 EQUB &00, &18, &70, &7F, &BA, &CC

 EQUB &1F, &32, &00, &20
 EQUB &1F, &20, &00, &0C
 EQUB &1F, &31, &00, &08
 EQUB &1F, &10, &00, &04
 EQUB &1F, &59, &08, &10
 EQUB &1F, &51, &04, &08
 EQUB &1F, &37, &08, &20
 EQUB &1F, &40, &04, &0C
 EQUB &1F, &62, &0C, &20
 EQUB &1F, &A7, &08, &24
 EQUB &1F, &84, &0C, &10
 EQUB &1F, &B6, &0C, &24
 EQUB &07, &88, &0C, &14
 EQUB &07, &BB, &0C, &28
 EQUB &07, &99, &08, &14
 EQUB &07, &AA, &08, &28
 EQUB &1F, &A9, &08, &1C
 EQUB &1F, &B8, &0C, &18
 EQUB &1F, &C8, &14, &18
 EQUB &1F, &C9, &14, &1C
 EQUB &1F, &AC, &1C, &28
 EQUB &1F, &CB, &18, &28
 EQUB &1F, &98, &10, &14
 EQUB &1F, &BA, &24, &28
 EQUB &1F, &54, &04, &10
 EQUB &1F, &76, &20, &24

 EQUB &9F, &1B, &28, &0B
 EQUB &1F, &1B, &28, &0B
 EQUB &DF, &1B, &28, &0B
 EQUB &5F, &1B, &28, &0B
 EQUB &9F, &13, &26, &00
 EQUB &1F, &13, &26, &00
 EQUB &DF, &13, &26, &00
 EQUB &5F, &13, &26, &00
 EQUB &BF, &19, &25, &0B
 EQUB &3F, &19, &25, &0B
 EQUB &7F, &19, &25, &0B
 EQUB &FF, &19, &25, &0B
 EQUB &3F, &00, &00, &70

ENDIF