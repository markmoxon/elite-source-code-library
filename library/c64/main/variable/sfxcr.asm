\ ******************************************************************************
\
\       Name: SFXCR
\       Type: Variable
\   Category: Sound
\    Summary: The voice control register (SID+&4) for each sound effect
\
\ ------------------------------------------------------------------------------
\
\ The voice control register is set in this table as follows:
\
\   * Bit 0: 0 = voice off, release cycle
\            1 = voice on, attack-decay-sustain cycle
\
\   * Bit 1 set = synchronization enabled
\
\   * Bit 2 set = ring modulation enabled
\
\   * Bit 3 set = disable voice, reset noise generator
\
\   * Bit 4 set = triangle waveform enabled
\
\   * Bit 5 set = saw waveform enabled
\
\   * Bit 6 set = square waveform enabled
\
\   * Bit 7 set = noise waveform enabled
\
\ ******************************************************************************

.SFXCR

 EQUB %01000001         \ Sound  0 = sfxplas  = Pulse lasers fired by us
 EQUB %00010001         \ Sound  1 = sfxelas  = Being hit by lasers 1
 EQUB %10000001         \ Sound  2 = sfxhit   = Other ship exploding
 EQUB %10000001         \ Sound  3 = sfxexpl  = We died / Collision
 EQUB %10000001         \ Sound  4 = sfxwhosh = Missile launched / Ship launch
 EQUB %00010001         \ Sound  5 = sfxbeep  = Short, high beep
 EQUB %00010001         \ Sound  6 = sfxboop  = Long, low beep
 EQUB %01000001         \ Sound  7 = sfxhyp1  = Hyperspace drive engaged 1
 EQUB %00100001         \ Sound  8 = sfxeng   = This sound is not used
 EQUB %01000001         \ Sound  9 = sfxecm   = E.C.M. on
 EQUB %00100001         \ Sound 10 = sfxblas  = Beam lasers fired by us
 EQUB %00100001         \ Sound 11 = sfxalas  = Military lasers fired by us
 EQUB %00010001         \ Sound 12 = sfxmlas  = Mining lasers fired by us
 EQUB %10000001         \ Sound 13 = sfxbomb  = Energy bomb
 EQUB %00010001         \ Sound 14 = sfxtrib  = Trumbles dying
 EQUB %00100001         \ Sound 15 = sfxelas2 = Being hit by lasers 2

