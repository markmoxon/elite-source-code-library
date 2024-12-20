\ ******************************************************************************
\
\       Name: SFXCNT
\       Type: Variable
\   Category: Sound
\    Summary: The counter for each sound effect, which defines the duration of
\             the effect in frames
\  Deep dive: Sound effects in Commodore 64 Elite
\
\ ******************************************************************************

.SFXCNT

 EQUB 20                \ Sound  0 = sfxplas  = Pulse lasers fired by us
 EQUB 14                \ Sound  1 = sfxelas  = Being hit by lasers 1
 EQUB 12                \ Sound  2 = sfxhit   = Other ship exploding
 EQUB 80                \ Sound  3 = sfxexpl  = We died / Collision
 EQUB 63                \ Sound  4 = sfxwhosh = Missile launched / Ship launch
 EQUB 5                 \ Sound  5 = sfxbeep  = Short, high beep
 EQUB 24                \ Sound  6 = sfxboop  = Long, low beep
 EQUB 128               \ Sound  7 = sfxhyp1  = Hyperspace drive engaged 1
 EQUB 48                \ Sound  8 = sfxeng   = This sound is not used
 EQUB 255               \ Sound  9 = sfxecm   = E.C.M. on
 EQUB 16                \ Sound 10 = sfxblas  = Beam lasers fired by us
 EQUB 16                \ Sound 11 = sfxalas  = Military lasers fired by us
 EQUB 112               \ Sound 12 = sfxmlas  = Mining lasers fired by us
 EQUB 64                \ Sound 13 = sfxbomb  = Energy bomb
 EQUB 15                \ Sound 14 = sfxtrib  = Trumbles dying
 EQUB 14                \ Sound 15 = sfxelas2 = Being hit by lasers 2

