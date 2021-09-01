\ ******************************************************************************
\
\       Name: SHIP_TRANSPORTER
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for a Transporter
\  Deep dive: Ship blueprints
\
\ ******************************************************************************

.SHIP_TRANSPORTER

 EQUB 0                 \ Max. canisters on demise = 0
 EQUW 50 * 50           \ Targetable area          = 50 * 50
 EQUB LO(SHIP_TRANSPORTER_EDGES - SHIP_TRANSPORTER)   \ Edges data offset (low)
 EQUB LO(SHIP_TRANSPORTER_FACES - SHIP_TRANSPORTER)   \ Faces data offset (low)
IF _DISC_VERSION OR _ELITE_A_VERSION \ Advanced: The advanced versions of Elite have an extra edge count for the ship colour; Transporters are shown in cyan
 EQUB 145               \ Max. edge count          = (145 - 1) / 4 = 36
ELIF _6502SP_VERSION OR _MASTER_VERSION
 EQUB 149               \ Max. edge count          = (149 - 1) / 4 = 37
ENDIF
 EQUB 48                \ Gun vertex               = 48
 EQUB 26                \ Explosion count          = 5, as (4 * n) + 6 = 26
 EQUB 222               \ Number of vertices       = 222 / 6 = 37
 EQUB 46                \ Number of edges          = 46
 EQUW 0                 \ Bounty                   = 0
 EQUB 56                \ Number of faces          = 56 / 4 = 14
 EQUB 16                \ Visibility distance      = 16
 EQUB 32                \ Max. energy              = 32
 EQUB 10                \ Max. speed               = 10
 EQUB HI(SHIP_TRANSPORTER_EDGES - SHIP_TRANSPORTER)   \ Edges data offset (high)
 EQUB HI(SHIP_TRANSPORTER_FACES - SHIP_TRANSPORTER)   \ Faces data offset (high)
IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Disc: The ship hanger in the disc version displays the Transporter with normals scaled with a factor of 4, rather than the scale factor of 2 used in the other versions, but the face normals themselves are unchanged. I'm not entirely sure why
 EQUB 2                 \ Normals are scaled by    = 2^2 = 4
ELIF _DISC_DOCKED OR _ELITE_A_VERSION
 EQUB 1                 \ Normals are scaled by    = 2^1 = 2
ENDIF
 EQUB %00000000         \ Laser power              = 0
                        \ Missiles                 = 0

IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Disc: Group A: The ship hanger in the disc version displays the Transporter with slightly different visibility settings to the other enhanced versions (the visibility settings are lower). I'm not entirely sure why

\VERTEX    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,   10,  -26,     6,      0,    7,     7,         31    \ Vertex 0
 VERTEX  -25,    4,  -26,     1,      0,    7,     7,         31    \ Vertex 1
 VERTEX  -28,   -3,  -26,     1,      0,    2,     2,         31    \ Vertex 2
 VERTEX  -25,   -8,  -26,     2,      0,    3,     3,         31    \ Vertex 3
 VERTEX   26,   -8,  -26,     3,      0,    4,     4,         31    \ Vertex 4
 VERTEX   29,   -3,  -26,     4,      0,    5,     5,         31    \ Vertex 5
 VERTEX   26,    4,  -26,     5,      0,    6,     6,         31    \ Vertex 6
 VERTEX    0,    6,   12,    15,     15,   15,    15,         19    \ Vertex 7
 VERTEX  -30,   -1,   12,     7,      1,    9,     8,         31    \ Vertex 8
 VERTEX  -33,   -8,   12,     2,      1,    9,     3,         31    \ Vertex 9
 VERTEX   33,   -8,   12,     4,      3,   10,     5,         31    \ Vertex 10
 VERTEX   30,   -1,   12,     6,      5,   11,    10,         31    \ Vertex 11
 VERTEX  -11,   -2,   30,     9,      8,   13,    12,         31    \ Vertex 12
 VERTEX  -13,   -8,   30,     9,      3,   13,    13,         31    \ Vertex 13
 VERTEX   14,   -8,   30,    10,      3,   13,    13,         31    \ Vertex 14
 VERTEX   11,   -2,   30,    11,     10,   13,    12,         31    \ Vertex 15
 VERTEX   -5,    6,    2,     7,      7,    7,     7,          7    \ Vertex 16
 VERTEX  -18,    3,    2,     7,      7,    7,     7,          7    \ Vertex 17
 VERTEX   -5,    7,   -7,     7,      7,    7,     7,          7    \ Vertex 18
 VERTEX  -18,    4,   -7,     7,      7,    7,     7,          7    \ Vertex 19
 VERTEX  -11,    6,  -14,     7,      7,    7,     7,          7    \ Vertex 20
 VERTEX  -11,    5,   -7,     7,      7,    7,     7,          7    \ Vertex 21
 VERTEX    5,    7,  -14,     6,      6,    6,     6,          7    \ Vertex 22
 VERTEX   18,    4,  -14,     6,      6,    6,     6,          7    \ Vertex 23
 VERTEX   11,    5,   -7,     6,      6,    6,     6,          7    \ Vertex 24
 VERTEX    5,    6,   -3,     6,      6,    6,     6,          7    \ Vertex 25
 VERTEX   18,    3,   -3,     6,      6,    6,     6,          7    \ Vertex 26
 VERTEX   11,    4,    8,     6,      6,    6,     6,          7    \ Vertex 27
 VERTEX   11,    5,   -3,     6,      6,    6,     6,          7    \ Vertex 28
 VERTEX  -16,   -8,  -13,     3,      3,    3,     3,          6    \ Vertex 29
 VERTEX  -16,   -8,   16,     3,      3,    3,     3,          6    \ Vertex 30
 VERTEX   17,   -8,  -13,     3,      3,    3,     3,          6    \ Vertex 31
 VERTEX   17,   -8,   16,     3,      3,    3,     3,          6    \ Vertex 32
 VERTEX  -13,   -3,  -26,     0,      0,    0,     0,          8    \ Vertex 33
 VERTEX   13,   -3,  -26,     0,      0,    0,     0,          8    \ Vertex 34
 VERTEX    9,    3,  -26,     0,      0,    0,     0,          5    \ Vertex 35
 VERTEX   -8,    3,  -26,     0,      0,    0,     0,          5    \ Vertex 36

ELIF _DISC_DOCKED OR _ELITE_A_VERSION

\VERTEX    x,    y,    z, face1, face2, face3, face4, visibility
 VERTEX    0,   19,  -51,     6,     0,     7,     7,         31     \ Vertex 0
 VERTEX  -51,    7,  -51,     1,     0,     7,     7,         31     \ Vertex 1
 VERTEX  -57,   -7,  -51,     1,     0,     2,     2,         31     \ Vertex 2
 VERTEX  -51,  -17,  -51,     2,     0,     3,     3,         31     \ Vertex 3
 VERTEX   51,  -17,  -51,     3,     0,     4,     4,         31     \ Vertex 4
 VERTEX   57,   -7,  -51,     4,     0,     5,     5,         31     \ Vertex 5
 VERTEX   51,    7,  -51,     5,     0,     6,     6,         31     \ Vertex 6
 VERTEX    0,   12,   24,    15,    15,    15,    15,         18     \ Vertex 7
 VERTEX  -60,   -2,   24,     7,     1,     9,     8,         31     \ Vertex 8
 VERTEX  -66,  -17,   24,     2,     1,     9,     3,         31     \ Vertex 9
 VERTEX   66,  -17,   24,     4,     3,    10,     5,         31     \ Vertex 10
 VERTEX   60,   -2,   24,     6,     5,    11,    10,         31     \ Vertex 11
 VERTEX  -22,   -5,   61,     9,     8,    13,    12,         31     \ Vertex 12
 VERTEX  -27,  -17,   61,     9,     3,    13,    13,         31     \ Vertex 13
 VERTEX   27,  -17,   61,    10,     3,    13,    13,         31     \ Vertex 14
 VERTEX   22,   -5,   61,    11,    10,    13,    12,         31     \ Vertex 15
 VERTEX  -10,   11,    5,     7,     7,     7,     7,          6     \ Vertex 16
 VERTEX  -36,    5,    5,     7,     7,     7,     7,          6     \ Vertex 17
 VERTEX  -10,   13,  -14,     7,     7,     7,     7,          6     \ Vertex 18
 VERTEX  -36,    7,  -14,     7,     7,     7,     7,          6     \ Vertex 19
 VERTEX  -23,   12,  -29,     7,     7,     7,     7,          6     \ Vertex 20
 VERTEX  -23,   10,  -14,     7,     7,     7,     7,          6     \ Vertex 21
 VERTEX   10,   15,  -29,     6,     6,     6,     6,          6     \ Vertex 22
 VERTEX   36,    9,  -29,     6,     6,     6,     6,          6     \ Vertex 23
 VERTEX   23,   10,  -14,     6,     6,     6,     6,          6     \ Vertex 24
 VERTEX   10,   12,   -6,     6,     6,     6,     6,          6     \ Vertex 25
 VERTEX   36,    6,   -6,     6,     6,     6,     6,          6     \ Vertex 26
 VERTEX   23,    7,   16,     6,     6,     6,     6,          6     \ Vertex 27
 VERTEX   23,    9,   -6,     6,     6,     6,     6,          6     \ Vertex 28
 VERTEX  -33,  -17,  -26,     3,     3,     3,     3,          5     \ Vertex 29
 VERTEX  -33,  -17,   33,     3,     3,     3,     3,          5     \ Vertex 30
 VERTEX   33,  -17,  -26,     3,     3,     3,     3,          5     \ Vertex 31
 VERTEX   33,  -17,   33,     3,     3,     3,     3,          5     \ Vertex 32
 VERTEX  -25,   -6,  -51,     0,     0,     0,     0,          7     \ Vertex 33
 VERTEX   26,   -6,  -51,     0,     0,     0,     0,          7     \ Vertex 34
 VERTEX   17,    6,  -51,     0,     0,     0,     0,          4     \ Vertex 35
 VERTEX  -17,    6,  -51,     0,     0,     0,     0,          4     \ Vertex 36

ENDIF

.SHIP_TRANSPORTER_EDGES

\EDGE vertex1, vertex2, face1, face2, visibility
 EDGE       0,       1,     7,     0,         31    \ Edge 0
 EDGE       1,       2,     1,     0,         31    \ Edge 1
 EDGE       2,       3,     2,     0,         31    \ Edge 2
 EDGE       3,       4,     3,     0,         31    \ Edge 3
 EDGE       4,       5,     4,     0,         31    \ Edge 4
 EDGE       5,       6,     5,     0,         31    \ Edge 5
 EDGE       0,       6,     6,     0,         31    \ Edge 6
IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Disc: See group A
 EDGE       0,       7,     7,     6,         16    \ Edge 7
ELIF _DISC_DOCKED OR _ELITE_A_VERSION
 EDGE       0,       7,     7,     6,         15    \ Edge 7
ENDIF
 EDGE       1,       8,     7,     1,         31    \ Edge 8
IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Disc: See group A
 EDGE       2,       9,     2,     1,         11    \ Edge 9
ELIF _DISC_DOCKED OR _ELITE_A_VERSION
 EDGE       2,       9,     2,     1,         10    \ Edge 9
ENDIF
 EDGE       3,       9,     3,     2,         31    \ Edge 10
 EDGE       4,      10,     4,     3,         31    \ Edge 11
IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Disc: See group A
 EDGE       5,      10,     5,     4,         11    \ Edge 12
ELIF _DISC_DOCKED OR _ELITE_A_VERSION
 EDGE       5,      10,     5,     4,         10    \ Edge 12
ENDIF
 EDGE       6,      11,     6,     5,         31    \ Edge 13
IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Disc: See group A
 EDGE       7,       8,     8,     7,         17    \ Edge 14
 EDGE       8,       9,     9,     1,         17    \ Edge 15
 EDGE      10,      11,    10,     5,         17    \ Edge 16
 EDGE       7,      11,    11,     6,         17    \ Edge 17
 EDGE       7,      15,    12,    11,         19    \ Edge 18
 EDGE       7,      12,    12,     8,         19    \ Edge 19
ELIF _DISC_DOCKED OR _ELITE_A_VERSION
 EDGE       7,       8,     8,     7,         16    \ Edge 14
 EDGE       8,       9,     9,     1,         16    \ Edge 15
 EDGE      10,      11,    10,     5,         16    \ Edge 16
 EDGE       7,      11,    11,     6,         16    \ Edge 17
 EDGE       7,      15,    12,    11,         18    \ Edge 18
 EDGE       7,      12,    12,     8,         18    \ Edge 19
ENDIF
 EDGE       8,      12,     9,     8,         16    \ Edge 20
 EDGE       9,      13,     9,     3,         31    \ Edge 21
 EDGE      10,      14,    10,     3,         31    \ Edge 22
 EDGE      11,      15,    11,    10,         16    \ Edge 23
 EDGE      12,      13,    13,     9,         31    \ Edge 24
 EDGE      13,      14,    13,     3,         31    \ Edge 25
 EDGE      14,      15,    13,    10,         31    \ Edge 26
 EDGE      12,      15,    13,    12,         31    \ Edge 27
IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Disc: See group A
 EDGE      16,      17,     7,     7,          7    \ Edge 28
 EDGE      18,      19,     7,     7,          7    \ Edge 29
 EDGE      19,      20,     7,     7,          7    \ Edge 30
 EDGE      18,      20,     7,     7,          7    \ Edge 31
 EDGE      20,      21,     7,     7,          7    \ Edge 32
 EDGE      22,      23,     6,     6,          7    \ Edge 33
 EDGE      23,      24,     6,     6,          7    \ Edge 34
 EDGE      24,      22,     6,     6,          7    \ Edge 35
 EDGE      25,      26,     6,     6,          7    \ Edge 36
 EDGE      26,      27,     6,     6,          7    \ Edge 37
 EDGE      25,      27,     6,     6,          7    \ Edge 38
 EDGE      27,      28,     6,     6,          7    \ Edge 39
 EDGE      29,      30,     3,     3,          6    \ Edge 40
 EDGE      31,      32,     3,     3,          6    \ Edge 41
 EDGE      33,      34,     0,     0,          8    \ Edge 42
 EDGE      34,      35,     0,     0,          5    \ Edge 43
 EDGE      35,      36,     0,     0,          5    \ Edge 44
 EDGE      36,      33,     0,     0,          5    \ Edge 45
ELIF _DISC_DOCKED OR _ELITE_A_VERSION
 EDGE      16,      17,     7,     7,          6    \ Edge 28
 EDGE      18,      19,     7,     7,          6    \ Edge 29
 EDGE      19,      20,     7,     7,          6    \ Edge 30
 EDGE      18,      20,     7,     7,          6    \ Edge 31
 EDGE      20,      21,     7,     7,          6    \ Edge 32
 EDGE      22,      23,     6,     6,          6    \ Edge 33
 EDGE      23,      24,     6,     6,          6    \ Edge 34
 EDGE      24,      22,     6,     6,          6    \ Edge 35
 EDGE      25,      26,     6,     6,          6    \ Edge 36
 EDGE      26,      27,     6,     6,          6    \ Edge 37
 EDGE      25,      27,     6,     6,          6    \ Edge 38
 EDGE      27,      28,     6,     6,          6    \ Edge 39
 EDGE      29,      30,     3,     3,          5    \ Edge 40
 EDGE      31,      32,     3,     3,          5    \ Edge 41
 EDGE      33,      34,     0,     0,          7    \ Edge 42
 EDGE      34,      35,     0,     0,          4    \ Edge 43
 EDGE      35,      36,     0,     0,          4    \ Edge 44
 EDGE      36,      33,     0,     0,          4    \ Edge 45
ENDIF

.SHIP_TRANSPORTER_FACES

\FACE normal_x, normal_y, normal_z, visibility
 FACE        0,        0,     -103,         31    \ Face 0
 FACE     -111,       48,       -7,         31    \ Face 1
 FACE     -105,      -63,      -21,         31    \ Face 2
 FACE        0,      -34,        0,         31    \ Face 3
 FACE      105,      -63,      -21,         31    \ Face 4
 FACE      111,       48,       -7,         31    \ Face 5
 FACE        8,       32,        3,         31    \ Face 6
 FACE       -8,       32,        3,         31    \ Face 7
IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Disc: See group A
 FACE       -8,       34,       11,         19    \ Face 8
ELIF _DISC_DOCKED OR _ELITE_A_VERSION
 FACE       -8,       34,       11,         18    \ Face 8
ENDIF
 FACE      -75,       32,       79,         31    \ Face 9
 FACE       75,       32,       79,         31    \ Face 10
IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Disc: See group A
 FACE        8,       34,       11,         19    \ Face 11
ELIF _DISC_DOCKED OR _ELITE_A_VERSION
 FACE        8,       34,       11,         18    \ Face 11
ENDIF
 FACE        0,       38,       17,         31    \ Face 12
 FACE        0,        0,      121,         31    \ Face 13

