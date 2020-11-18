\ ******************************************************************************
\
\       Name: SHIP_ESCAPE_POD
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for an escape pod
\
\ ******************************************************************************

.SHIP_ESCAPE_POD

IF _CASSETTE_VERSION
 EQUB 0                 \ Max. canisters on demise = 0
ELIF _6502SP_VERSION
 EQUB 32                \ Max. canisters on demise = 32
ENDIF
 EQUW 16 * 16           \ Targetable area          = 16 * 16
 EQUB &2C               \ Edges data offset (low)  = &002C
 EQUB &44               \ Faces data offset (low)  = &0044
IF _CASSETTE_VERSION
 EQUB 25                \ Max. edge count          = (25 - 1) / 4 = 6
ELIF _6502SP_VERSION
 EQUB 29                \ Max. edge count          = (29 - 1) / 4 = 7
ENDIF
 EQUB 0                 \ Gun vertex               = 0
 EQUB 22                \ Explosion count          = 4, as (4 * n) + 6 = 22
 EQUB 24                \ Number of vertices       = 24 / 6 = 4
 EQUB 6                 \ Number of edges          = 6
 EQUW 0                 \ Bounty                   = 0
 EQUB 16                \ Number of faces          = 16 / 4 = 4
 EQUB 8                 \ Visibility distance      = 8
 EQUB 17                \ Max. energy              = 17
 EQUB 8                 \ Max. speed               = 8
 EQUB &00               \ Edges data offset (high) = &002C
 EQUB &00               \ Faces data offset (high) = &0044
IF _CASSETTE_VERSION
 EQUB 3                 \ Normals are scaled by    =  2^3 = 8
ELIF _6502SP_VERSION
 EQUB 4                 \ Normals are scaled by    =  2^4 = 16
ENDIF
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

\VERTEX    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX   -7,    0,   36,     2,      1,    3,     3,         31    \ Vertex 0
 VERTEX   -7,  -14,  -12,     2,      0,    3,     3,         31    \ Vertex 1
 VERTEX   -7,   14,  -12,     1,      0,    3,     3,         31    \ Vertex 2
 VERTEX   21,    0,    0,     1,      0,    2,     2,         31    \ Vertex 3

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     3,     2,         31    \ Edge 0
 EDGE       1,       2,     3,     0,         31    \ Edge 1
 EDGE       2,       3,     1,     0,         31    \ Edge 2
 EDGE       3,       0,     2,     1,         31    \ Edge 3
 EDGE       0,       2,     3,     1,         31    \ Edge 4
 EDGE       3,       1,     2,     0,         31    \ Edge 5

IF _CASSETTE_VERSION

\FACE normal_x, normal_y, normal_z, visibility
 FACE       26,        0,      -61,         31    \ Face 0
 FACE       19,       51,       15,         31    \ Face 1
 FACE       19,      -51,       15,         31    \ Face 2
 FACE      -56,        0,        0,         31    \ Face 3

ELIF _6502SP_VERSION

 EQUB &3F, &34, &00, &7A
 EQUB &1F, &27, &67, &1E
 EQUB &5F, &27, &67, &1E
 EQUB &9F, &70, &00, &00

ENDIF
