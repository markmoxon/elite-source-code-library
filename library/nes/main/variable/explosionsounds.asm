\ ******************************************************************************
\
\       Name: explosionSounds
\       Type: Variable
\   Category: Sound
\    Summary: Sound numbers for explosions at different distances from our ship
\  Deep dive: Sound effects in NES Elite
\
\ ******************************************************************************

.explosionSounds

 EQUB 27                \ Ship explosion at a distance of z_hi >= 16

 EQUB 23                \ Ship explosion at a distance of z_hi >=8

 EQUB 14                \ Ship explosion at a distance of z_hi >= 6

 EQUB 13                \ Ship explosion at a distance of z_hi >= 3

 EQUB 13                \ Nearby ship explosion

