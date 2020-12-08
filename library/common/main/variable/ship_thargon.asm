\ ******************************************************************************
\
\       Name: SHIP_THARGON
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Thargon
\
\ ------------------------------------------------------------------------------
\
\ The ship blueprint for the Thargon reuses the edges data from the cargo
\ canister, so the edges data offset is negative.
\
\ ******************************************************************************

.SHIP_THARGON

IF _CASSETTE_VERSION
 EQUB 0                 \ Max. canisters on demise = 0
ELIF _6502SP_VERSION
 EQUB 0 + (15 << 4)     \ Max. canisters on demise = 0
                        \ Market item when scooped = 15 + 1 = 16 (Alien items)
ENDIF
 EQUW 40 * 40           \ Targetable area          = 40 * 40
IF _CASSETTE_VERSION
 EQUB &A8               \ Edges data offset (low)  = &FFA8 = -88 (canister)
ELIF _6502SP_VERSION
 EQUB &E6               \ Edges data offset (low)  = &E7E6 = -6170 (canister)
ENDIF
 EQUB &50               \ Faces data offset (low)  = &0050
IF _CASSETTE_VERSION
 EQUB 65                \ Max. edge count          = (65 - 1) / 4 = 16
ELIF _6502SP_VERSION
 EQUB 69                \ Max. edge count          = (69 - 1) / 4 = 17
ENDIF
 EQUB 0                 \ Gun vertex               = 0
 EQUB 18                \ Explosion count          = 3, as (4 * n) + 6 = 18
 EQUB 60                \ Number of vertices       = 60 / 6 = 10
 EQUB 15                \ Number of edges          = 15
 EQUW 50                \ Bounty                   = 50
 EQUB 28                \ Number of faces          = 28 / 4 = 7
 EQUB 20                \ Visibility distance      = 20
 EQUB 20                \ Max. energy              = 20
 EQUB 30                \ Max. speed               = 30
IF _CASSETTE_VERSION
 EQUB &FF               \ Edges data offset (high) = &FFA8 = -88 (canister)
ELIF _6502SP_VERSION
 EQUB &E7               \ Edges data offset (high) = &E7E6 = -6170 (canister)
ENDIF
 EQUB &00               \ Faces data offset (high) = &0050
 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
 EQUB %00010000         \ Laser power              = 2
                        \ Missiles                 = 0

\VERTEX    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX   -9,    0,   40,     1,      0,    5,     5,         31    \ Vertex 0
 VERTEX   -9,  -38,   12,     1,      0,    2,     2,         31    \ Vertex 1
 VERTEX   -9,  -24,  -32,     2,      0,    3,     3,         31    \ Vertex 2
 VERTEX   -9,   24,  -32,     3,      0,    4,     4,         31    \ Vertex 3
 VERTEX   -9,   38,   12,     4,      0,    5,     5,         31    \ Vertex 4
 VERTEX    9,    0,   -8,     5,      1,    6,     6,         31    \ Vertex 5
 VERTEX    9,  -10,  -15,     2,      1,    6,     6,         31    \ Vertex 6
 VERTEX    9,   -6,  -26,     3,      2,    6,     6,         31    \ Vertex 7
 VERTEX    9,    6,  -26,     4,      3,    6,     6,         31    \ Vertex 8
 VERTEX    9,   10,  -15,     5,      4,    6,     6,         31    \ Vertex 9

\FACE normal_x, normal_y, normal_z, visibility
 FACE      -36,        0,        0,         31    \ Face 0
 FACE       20,       -5,        7,         31    \ Face 1
 FACE       46,      -42,      -14,         31    \ Face 2
 FACE       36,        0,     -104,         31    \ Face 3
 FACE       46,       42,      -14,         31    \ Face 4
 FACE       20,        5,        7,         31    \ Face 5
 FACE       36,        0,        0,         31    \ Face 6

