\ ******************************************************************************
\
\       Name: SFXSUS
\       Type: Variable
\   Category: Sound
\    Summary: The release length and sustain volume (SID+6) for each sound
\             effect
\
\ ------------------------------------------------------------------------------
\
\ The release length and sustain volume are set in this table as follows:
\
\   * Bits 0-3 = release length
\
\   * Bits 4-7 = sustain volume
\
\ ******************************************************************************

.SFXSUS

 EQUB &D1               \ Sound  0 = sfxplas  = Pulse lasers fired by us
 EQUB &F1               \ Sound  1 = sfxelas  = Being hit by lasers 1
 EQUB &E5               \ Sound  2 = sfxhit   = Other ship exploding
 EQUB &FB               \ Sound  3 = sfxexpl  = We died / Collision
 EQUB &DC               \ Sound  4 = sfxwhosh = Missile launched / Ship launch
 EQUB &F0               \ Sound  5 = sfxbeep  = Short, high beep
 EQUB &F3               \ Sound  6 = sfxboop  = Long, low beep
 EQUB &D8               \ Sound  7 = sfxhyp1  = Hyperspace drive engaged 1
 EQUB &00               \ Sound  8 = sfxeng   = This sound is not used
 EQUB &E1               \ Sound  9 = sfxecm   = E.C.M. on
 EQUB &E1               \ Sound 10 = sfxblas  = Beam lasers fired by us
 EQUB &F1               \ Sound 11 = sfxalas  = Military lasers fired by us
 EQUB &F4               \ Sound 12 = sfxmlas  = Mining lasers fired by us
 EQUB &E3               \ Sound 13 = sfxbomb  = Energy bomb
 EQUB &B0               \ Sound 14 = sfxtrib  = Trumbles dying
 EQUB &A1               \ Sound 15 = sfxelas2 = Being hit by lasers 2

