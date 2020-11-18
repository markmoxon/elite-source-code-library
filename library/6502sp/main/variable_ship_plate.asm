\ ******************************************************************************
\
\       Name: SHIP_PLATE
\       Type: Variable
\   Category: Drawing ships
\    Summary: Ship blueprint for an alloy plate
\
\ ******************************************************************************

.SHIP_PLATE

 EQUB &80               \ Max. canisters on demise = 
 EQUW &0064             \ Targetable area          = 
 EQUB &2C               \ Edges data offset (low)  = &
 EQUB &3C               \ Faces data offset (low)  = &
 EQUB &15               \ Max. edge count          = ( - 1) / 4 = 
 EQUB &00               \ Gun vertex               = 
 EQUB &0A               \ Explosion count          = , as (4 * n) + 6 = 
 EQUB &18               \ Number of vertices       = 24 / 6 = 4
 EQUB &04               \ Number of edges          = 4
 EQUW &0000             \ Bounty                   = 
 EQUB &04               \ Number of faces          = 4 / 4 = 1
 EQUB &05               \ Visibility distance      = 
 EQUB &10               \ Max. energy              = 
 EQUB &10               \ Max. speed               = 
 EQUB &00               \ Edges data offset (high) = &
 EQUB &00               \ Faces data offset (high) = &
 EQUB &03               \ Normals are scaled by    = 2^ = 
 EQUB &00               \ Laser power              = 
                        \ Missiles                 = 

 EQUB &0F, &16, &09, &FF, &FF, &FF
 EQUB &0F, &26, &09, &BF, &FF, &FF
 EQUB &13, &20, &0B, &14, &FF, &FF
 EQUB &0A, &2E, &06, &54, &FF, &FF


 EQUB &1F, &FF, &00, &04
 EQUB &10, &FF, &04, &08
 EQUB &14, &FF, &08, &0C
 EQUB &10, &FF, &0C, &00

 EQUB &00, &00, &00, &00

