\ ******************************************************************************
\
\       Name: SHIP_PLATE
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for an alloy plate
\  Deep dive: Ship blueprints
IF NOT(_ELITE_A_VERSION)
\             Comparing ship specifications
ENDIF
\
\ ******************************************************************************

.SHIP_PLATE

 EQUB 0 + (8 << 4)      \ Max. canisters on demise = 0
                        \ Market item when scooped = 8 + 1 = 9 (alloys)
 EQUW 10 * 10           \ Targetable area          = 10 * 10

 EQUB LO(SHIP_PLATE_EDGES - SHIP_PLATE)            \ Edges data offset (low)
 EQUB LO(SHIP_PLATE_FACES - SHIP_PLATE)            \ Faces data offset (low)

IF _DISC_FLIGHT OR _ELITE_A_VERSION \ Advanced: The advanced versions of Elite have an extra edge count for the ship colour; alloy plates are shown in cyan
 EQUB 17                \ Max. edge count          = (17 - 1) / 4 = 4
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
 EQUB 21                \ Max. edge count          = (21 - 1) / 4 = 5
ENDIF
 EQUB 0                 \ Gun vertex               = 0
 EQUB 10                \ Explosion count          = 1, as (4 * n) + 6 = 10
 EQUB 24                \ Number of vertices       = 24 / 6 = 4
 EQUB 4                 \ Number of edges          = 4
IF NOT(_ELITE_A_VERSION)
 EQUW 0                 \ Bounty                   = 0
ELIF _ELITE_A_VERSION
 EQUW 1                 \ Bounty                   = 1
ENDIF
 EQUB 4                 \ Number of faces          = 4 / 4 = 1
 EQUB 5                 \ Visibility distance      = 5
IF NOT(_ELITE_A_VERSION)
 EQUB 16                \ Max. energy              = 16
ELIF _ELITE_A_VERSION
 EQUB 8                 \ Max. energy              = 8
ENDIF
 EQUB 16                \ Max. speed               = 16

 EQUB HI(SHIP_PLATE_EDGES - SHIP_PLATE)            \ Edges data offset (high)
 EQUB HI(SHIP_PLATE_FACES - SHIP_PLATE)            \ Faces data offset (high)

 EQUB 3                 \ Normals are scaled by    = 2^3 = 8
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

.SHIP_PLATE_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX  -15,  -22,   -9,    15,     15,   15,    15,         31    \ Vertex 0
 VERTEX  -15,   38,   -9,    15,     15,   15,    15,         31    \ Vertex 1
 VERTEX   19,   32,   11,    15,     15,   15,    15,         20    \ Vertex 2
 VERTEX   10,  -46,    6,    15,     15,   15,    15,         20    \ Vertex 3

.SHIP_PLATE_EDGES

    \ vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,    15,    15,         31    \ Edge 0
 EDGE       1,       2,    15,    15,         16    \ Edge 1
 EDGE       2,       3,    15,    15,         20    \ Edge 2
 EDGE       3,       0,    15,    15,         16    \ Edge 3

.SHIP_PLATE_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE        0,        0,        0,          0      \ Face 0

