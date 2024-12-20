\ ******************************************************************************
\
\       Name: SFXATK
\       Type: Variable
\   Category: Sound
\    Summary: The attack and decay length (SID+&5) for each sound effect
\  Deep dive: Sound effects in Commodore 64 Elite
\
\ ------------------------------------------------------------------------------
\
\ The attack and decay are set in this table as follows:
\
\   * Bits 0-3 = decay length
\
\   * Bits 4-7 = attack length
\
\ ******************************************************************************

.SFXATK

 EQUB &01               \ Sound  0 = sfxplas  = Pulse lasers fired by us
 EQUB &09               \ Sound  1 = sfxelas  = Being hit by lasers 1
 EQUB &20               \ Sound  2 = sfxhit   = Other ship exploding
 EQUB &08               \ Sound  3 = sfxexpl  = We died / Collision
 EQUB &0C               \ Sound  4 = sfxwhosh = Missile launched / Ship launch
 EQUB &00               \ Sound  5 = sfxbeep  = Short, high beep
 EQUB &63               \ Sound  6 = sfxboop  = Long, low beep
 EQUB &18               \ Sound  7 = sfxhyp1  = Hyperspace drive engaged 1
 EQUB &44               \ Sound  8 = sfxeng   = This sound is not used
 EQUB &11               \ Sound  9 = sfxecm   = E.C.M. on
 EQUB &00               \ Sound 10 = sfxblas  = Beam lasers fired by us
 EQUB &00               \ Sound 11 = sfxalas  = Military lasers fired by us
 EQUB &44               \ Sound 12 = sfxmlas  = Mining lasers fired by us
 EQUB &11               \ Sound 13 = sfxbomb  = Energy bomb
 EQUB &18               \ Sound 14 = sfxtrib  = Trumbles dying
 EQUB &09               \ Sound 15 = sfxelas2 = Being hit by lasers 2

