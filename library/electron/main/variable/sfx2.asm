\ ******************************************************************************
\
\       Name: SFX2
\       Type: Variable
\   Category: Sound
\    Summary: The priority and a minimum duration for each sound
\
\ ------------------------------------------------------------------------------
\
\ In the Electron version, each of the game's sounds is allocated a priority and
\ a minimum duration.
\
\ ******************************************************************************

.SFX2

 EQUB &70               \ 0  - Priority 112, minimum duration 0
 EQUB &24               \ 8  - Priority  36, minimum duration 4
 EQUB &56               \ 16 - Priority  86, minimum duration 6
 EQUB &56               \ 24 - Priority  86, minimum duration 6
 EQUB &42               \ 32 - Priority  66, minimum duration 2
 EQUB &28               \ 40 - Priority  40, minimum duration 8
 EQUB &C8               \ 48 - Priority 200, minimum duration 8
 EQUB &D0               \ 56 - Priority 208, minimum duration 0
 EQUB &F0               \ 64 - Priority 240, minimum duration 0
 EQUB &E0               \ 72 - Priority 224, minimum duration 0

