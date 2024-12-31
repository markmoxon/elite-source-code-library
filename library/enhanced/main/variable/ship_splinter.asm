\ ******************************************************************************
\
\       Name: SHIP_SPLINTER
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a splinter
\  Deep dive: Ship blueprints
IF NOT(_ELITE_A_VERSION)
\             Comparing ship specifications
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF NOT(_ELITE_A_VERSION)
\ The ship blueprint for the splinter reuses the edges data from the escape pod,
\ so the edges data offset is negative.
ELIF _ELITE_A_VERSION
\ The ship blueprint for the splinter is supposed to reuse the edges data from
\ the escape pod, but there is a bug in Elite-A that breaks splinters. The edges
\ data offset is negative, as it should be, but the offset value is incorrect
\ and doesn't even point to edge data - in the Tube version, it points into the
\ middle of the Thargoid's vertex data, while in the disc version it points to a
\ different place depending on the structure of the individual blueprint file.
\ In all cases the offset is wrong, so splinters in Elite-A appear as a random
\ mess of lines. The correct value of the offset should be:
\
\   SHIP_ESCAPE_POD_EDGES - SHIP_SPLINTER
\
\ split into the high byte and low byte, as it is in the disc version.
ENDIF
\
\ ******************************************************************************

.SHIP_SPLINTER

 EQUB 0 + (11 << 4)     \ Max. canisters on demise = 0
                        \ Market item when scooped = 11 + 1 = 12 (minerals)
 EQUW 16 * 16           \ Targetable area          = 16 * 16

IF NOT(_ELITE_A_VERSION)
 EQUB LO(SHIP_ESCAPE_POD_EDGES - SHIP_SPLINTER)    \ Edges from escape pod
ELIF _ELITE_A_VERSION

IF _RELEASED OR _SOURCE_DISC

 EQUB &5A               \ This value is incorrect (see above)

ELIF _BUG_FIX

 EQUB LO(SHIP_ESCAPE_POD_EDGES - SHIP_SPLINTER)    \ Edges from escape pod

ENDIF

ENDIF
 EQUB LO(SHIP_SPLINTER_FACES - SHIP_SPLINTER) + 24 \ Faces data offset (low)

IF _DISC_FLIGHT OR _ELITE_A_VERSION \ Advanced: The advanced versions of Elite have an extra edge count for the ship colour; splinters are shown in red
 EQUB 25                \ Max. edge count          = (25 - 1) / 4 = 6
ELIF _6502SP_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
 EQUB 29                \ Max. edge count          = (29 - 1) / 4 = 7
ENDIF
 EQUB 0                 \ Gun vertex               = 0
 EQUB 22                \ Explosion count          = 4, as (4 * n) + 6 = 22
 EQUB 24                \ Number of vertices       = 24 / 6 = 4
 EQUB 6                 \ Number of edges          = 6
IF NOT(_ELITE_A_VERSION)
 EQUW 0                 \ Bounty                   = 0
ELIF _ELITE_A_VERSION
 EQUW 1                 \ Bounty                   = 1
ENDIF
 EQUB 16                \ Number of faces          = 16 / 4 = 4
 EQUB 8                 \ Visibility distance      = 8
IF NOT(_ELITE_A_VERSION)
 EQUB 20                \ Max. energy              = 20
ELIF _ELITE_A_VERSION
 EQUB 16                \ Max. energy              = 16
ENDIF
 EQUB 10                \ Max. speed               = 10

IF NOT(_ELITE_A_VERSION)
 EQUB HI(SHIP_ESCAPE_POD_EDGES - SHIP_SPLINTER)    \ Edges from escape pod
ELIF _ELITE_A_VERSION

IF _RELEASED OR _SOURCE_DISC

 EQUB &FE               \ This value is incorrect (see above)

ELIF _BUG_FIX

 EQUB HI(SHIP_ESCAPE_POD_EDGES - SHIP_SPLINTER)    \ Edges from escape pod

ENDIF

ENDIF
 EQUB HI(SHIP_SPLINTER_FACES - SHIP_SPLINTER)      \ Faces data offset (low)

 EQUB 5                 \ Normals are scaled by    = 2^5 = 32
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

.SHIP_SPLINTER_VERTICES

      \    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX  -24,  -25,   16,     2,      1,    3,     3,         31    \ Vertex 0
 VERTEX    0,   12,  -10,     2,      0,    3,     3,         31    \ Vertex 1
 VERTEX   11,   -6,    2,     1,      0,    3,     3,         31    \ Vertex 2
 VERTEX   12,   42,    7,     1,      0,    2,     2,         31    \ Vertex 3

.SHIP_SPLINTER_FACES

    \ normal_x, normal_y, normal_z, visibility
 FACE       35,        0,        4,         31      \ Face 0
 FACE        3,        4,        8,         31      \ Face 1
 FACE        1,        8,       12,         31      \ Face 2
 FACE       18,       12,        0,         31      \ Face 3

