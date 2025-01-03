\ ******************************************************************************
\
\       Name: SHIP_ESCAPE_POD
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for an escape pod
\  Deep dive: Ship blueprints
IF NOT(_ELITE_A_VERSION)
\             Comparing ship specifications
ENDIF
\
\ ******************************************************************************

.SHIP_ESCAPE_POD

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: In the enhanced versions, the escape pod ship blueprint contains the information in the high nibble of byte #0 that scooping escape pods gives us slaves
 EQUB 0                 \ Max. canisters on demise = 0
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
 EQUB 0 + (2 << 4)      \ Max. canisters on demise = 0
                        \ Market item when scooped = 2 + 1 = 3 (slaves)
ENDIF
 EQUW 16 * 16           \ Targetable area          = 16 * 16

 EQUB LO(SHIP_ESCAPE_POD_EDGES - SHIP_ESCAPE_POD)  \ Edges data offset (low)
 EQUB LO(SHIP_ESCAPE_POD_FACES - SHIP_ESCAPE_POD)  \ Faces data offset (low)

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Advanced: The advanced versions of Elite have an extra edge count for the ship colour; escape pods are shown in cyan
 EQUB 25                \ Max. edge count          = (25 - 1) / 4 = 6
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
 EQUB 29                \ Max. edge count          = (29 - 1) / 4 = 7
ENDIF
 EQUB 0                 \ Gun vertex               = 0
 EQUB 22                \ Explosion count          = 4, as (4 * n) + 6 = 22
 EQUB 24                \ Number of vertices       = 24 / 6 = 4
 EQUB 6                 \ Number of edges          = 6
 EQUW 0                 \ Bounty                   = 0
 EQUB 16                \ Number of faces          = 16 / 4 = 4
 EQUB 8                 \ Visibility distance      = 8
IF NOT(_ELITE_A_VERSION)
 EQUB 17                \ Max. energy              = 17
ELIF _ELITE_A_VERSION
 EQUB 8                 \ Max. energy              = 8
ENDIF
 EQUB 8                 \ Max. speed               = 8

 EQUB HI(SHIP_ESCAPE_POD_EDGES - SHIP_ESCAPE_POD)  \ Edges data offset (high)
 EQUB HI(SHIP_ESCAPE_POD_FACES - SHIP_ESCAPE_POD)  \ Faces data offset (high)

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: Group A: In the cassette and Electron versions, the escape pod stores its faces with a scale factor of 8, while the other versions store them at a more accurate factor of 16
 EQUB 3                 \ Normals are scaled by    =  2^3 = 8
ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
 EQUB 4                 \ Normals are scaled by    =  2^4 = 16
ENDIF
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

.SHIP_ESCAPE_POD_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX   -7,    0,   36,     2,      1,    3,     3,         31    \ Vertex 0
 VERTEX   -7,  -14,  -12,     2,      0,    3,     3,         31    \ Vertex 1
 VERTEX   -7,   14,  -12,     1,      0,    3,     3,         31    \ Vertex 2
 VERTEX   21,    0,    0,     1,      0,    2,     2,         31    \ Vertex 3

.SHIP_ESCAPE_POD_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     3,     2,         31    \ Edge 0
 EDGE       1,       2,     3,     0,         31    \ Edge 1
 EDGE       2,       3,     1,     0,         31    \ Edge 2
 EDGE       3,       0,     2,     1,         31    \ Edge 3
 EDGE       0,       2,     3,     1,         31    \ Edge 4
 EDGE       3,       1,     2,     0,         31    \ Edge 5

.SHIP_ESCAPE_POD_FACES

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: See group A

    \ normal_x, normal_y, normal_z, visibility
 FACE       26,        0,      -61,         31      \ Face 0
 FACE       19,       51,       15,         31      \ Face 1
 FACE       19,      -51,       15,         31      \ Face 2
 FACE      -56,        0,        0,         31      \ Face 3

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

    \ normal_x, normal_y, normal_z, visibility
 FACE       52,        0,     -122,         31      \ Face 0
 FACE       39,      103,       30,         31      \ Face 1
 FACE       39,     -103,       30,         31      \ Face 2
 FACE     -112,        0,        0,         31      \ Face 3

ENDIF
