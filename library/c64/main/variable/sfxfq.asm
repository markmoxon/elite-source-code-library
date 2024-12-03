\ ******************************************************************************
\
\       Name: SFXFQ
\       Type: Variable
\   Category: Sound
\    Summary: The frequency (SID+&5) for each sound effect
\
\ ******************************************************************************

.SFXFQ

 EQUB 69                \ Sound  0 = sfxplas  = Pulse lasers fired by us
 EQUB 72                \ Sound  1 = sfxelas  = Being hit by lasers 1
 EQUB 208               \ Sound  2 = sfxhit   = Other ship exploding
 EQUB 81                \ Sound  3 = sfxexpl  = We died / Collision
 EQUB 64                \ Sound  4 = sfxwhosh = Missile launched / Ship launch
 EQUB 240               \ Sound  5 = sfxbeep  = Short, high beep
 EQUB 64                \ Sound  6 = sfxboop  = Long, low beep
 EQUB 128               \ Sound  7 = sfxhyp1  = Hyperspace drive engaged 1
 EQUB 16                \ Sound  8 = sfxeng   = This sound is not used
 EQUB 80                \ Sound  9 = sfxecm   = E.C.M. on
 EQUB 52                \ Sound 10 = sfxblas  = Beam lasers fired by us
 EQUB 51                \ Sound 11 = sfxalas  = Military lasers fired by us
 EQUB 96                \ Sound 12 = sfxmlas  = Mining lasers fired by us
 EQUB 85                \ Sound 13 = sfxbomb  = Energy bomb
 EQUB 128               \ Sound 14 = sfxtrib  = Trumbles dying
 EQUB 64                \ Sound 15 = sfxelas2 = Being hit by lasers 2

