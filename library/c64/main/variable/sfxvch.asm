\ ******************************************************************************
\
\       Name: SFXVCH
\       Type: Variable
\   Category: Sound
\    Summary: The volume change rate for each sound effect, i.e. how many frames
\             need to pass before the sound effect's volume is reduced by one
\
\ ******************************************************************************

.SFXVCH

 EQUB 3                 \ Sound  0 = sfxplas  = Pulse lasers fired by us
 EQUB 3                 \ Sound  1 = sfxelas  = Being hit by lasers 1
 EQUB 3                 \ Sound  2 = sfxhit   = Other ship exploding
 EQUB 15                \ Sound  3 = sfxexpl  = We died / Collision
 EQUB 15                \ Sound  4 = sfxwhosh = Missile launched / Ship launch
 EQUB 255               \ Sound  5 = sfxbeep  = Short, high beep
 EQUB 255               \ Sound  6 = sfxboop  = Long, low beep
 EQUB 31                \ Sound  7 = sfxhyp1  = Hyperspace drive engaged 1
 EQUB 255               \ Sound  8 = sfxeng   = This sound is not used
 EQUB 255               \ Sound  9 = sfxecm   = E.C.M. on
 EQUB 3                 \ Sound 10 = sfxblas  = Beam lasers fired by us
 EQUB 3                 \ Sound 11 = sfxalas  = Military lasers fired by us
 EQUB 15                \ Sound 12 = sfxmlas  = Mining lasers fired by us
 EQUB 255               \ Sound 13 = sfxbomb  = Energy bomb
 EQUB 255               \ Sound 14 = sfxtrib  = Trumbles dying
 EQUB 3                 \ Sound 15 = sfxelas2 = Being hit by lasers 2
