\ ******************************************************************************
\
\       Name: SFXFRCH
\       Type: Variable
\   Category: Sound
\    Summary: The frequency change to be applied to each sound effect in each
\             frame (as a signed number)
\  Deep dive: Sound effects in Commodore 64 Elite
\
\ ******************************************************************************

.SFXFRCH

 EQUB 254               \ Sound  0 = sfxplas  = Pulse lasers fired by us
 EQUB 254               \ Sound  1 = sfxelas  = Being hit by lasers 1
 EQUB 243               \ Sound  2 = sfxhit   = Other ship exploding
 EQUB 255               \ Sound  3 = sfxexpl  = We died / Collision
 EQUB 0                 \ Sound  4 = sfxwhosh = Missile launched / Ship launch
 EQUB 0                 \ Sound  5 = sfxbeep  = Short, high beep
 EQUB 0                 \ Sound  6 = sfxboop  = Long, low beep
 EQUB 68                \ Sound  7 = sfxhyp1  = Hyperspace drive engaged 1
 EQUB 0                 \ Sound  8 = sfxeng   = This sound is not used
 EQUB 85                \ Sound  9 = sfxecm   = E.C.M. on
 EQUB 254               \ Sound 10 = sfxblas  = Beam lasers fired by us
 EQUB 255               \ Sound 11 = sfxalas  = Military lasers fired by us
 EQUB 239               \ Sound 12 = sfxmlas  = Mining lasers fired by us
 EQUB 119               \ Sound 13 = sfxbomb  = Energy bomb
 EQUB 123               \ Sound 14 = sfxtrib  = Trumbles dying
 EQUB 254               \ Sound 15 = sfxelas2 = Being hit by lasers 2

