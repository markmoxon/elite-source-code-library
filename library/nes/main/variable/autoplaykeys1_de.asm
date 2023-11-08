\ ******************************************************************************
\
\       Name: autoPlayKeys1_DE
\       Type: Variable
\   Category: Combat demo
\    Summary: Auto-play commands for the first part of the auto-play combat demo
\             (combat practice) when German is the chosen language
\
\ ******************************************************************************

.autoPlayKeys1_DE

                        \ At this point the we are at the title screen, which
                        \ will show the rotating Cobra Mk III before starting
                        \ the combat demo in auto-play mode

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

                        \ At this point the combat demo starts

 EQUB &C2               \ Do nothing (%00000000) while MANY+19 = 0 (i.e. wait
 EQUB %00000000         \ until the Sidewinder - ship type 19 - is spawned)
 EQUW MANY+19

 EQUB &8A               \ Do nothing for 10 * 4 = 40 VBlanks

 EQUB %01000000         \ Press the A button (%01000000) for 4 VBlanks to fire
 EQUB 4                 \ the laser (this kills the first ship)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB &C2               \ Do nothing (%00000000) while FRIN+4 = 0 (i.e. wait
 EQUB %00000000         \ until the third ship is spawned in ship slot 4)
 EQUW FRIN+4

 EQUB &9C               \ Do nothing for 12 * 4 = 48 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 20 VBlanks to
 EQUB 20                \ pull the nose up

 EQUB %01000100         \ Press the down and A buttons (%01000100) for 6 VBlanks
 EQUB 6                 \ to pull the nose up and fire the lasers

 EQUB %01000000         \ Press the A button (%01000000) for 31 VBlanks to fire
 EQUB 31                \ the lasers

 EQUB %01000000         \ Press the A button (%01000000) for 31 VBlanks to fire
 EQUB 31                \ the lasers

 EQUB %00100001         \ Press the right and B buttons (%01000100) for 14
 EQUB 14                \ VBlanks to move the icon bar pointer to the right
                        \ and onto the Target Missile button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. target the missile)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &8D               \ Do nothing for 13 * 4 = 52 VBlanks

 EQUB %00000001         \ Press the right button (%00000001) for 31 VBlanks to
 EQUB 31                \ roll to the right (clockwise)

 EQUB %00000001         \ DE: Press the right button (%00000001) for 19 VBlanks
 EQUB 19                \ to roll to the right (clockwise)

 EQUB %00001000         \ Press the up button (%00001000) for 20 VBlanks to
 EQUB 20                \ pitch down

 EQUB &8E               \ Do nothing for 14 * 4 = 56 VBlanks

 EQUB %00001000         \ Press the up button (%00001000) for 31 VBlanks to
 EQUB 31                \ pitch down

 EQUB %00001000         \ DE: Press the up button (%00001000) for 31 VBlanks to
 EQUB 31                \ pitch down

 EQUB %00001000         \ DE: Press the up button (%00001000) for 22 VBlanks to
 EQUB 22                \ pitch down

 EQUB %00100001         \ Press the right and B buttons (%00100001) for 2
 EQUB 2                 \ VBlanks to move the icon bar pointer to the right
                        \ and onto the Fire Missile button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB &C3               \ Press the up button (%00001000) while bit 7 of MSTG is
 EQUB %00001000         \ set (i.e. pull up until the missile has locked onto a
 EQUW MSTG              \ target)

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. fire the missile),
                        \ which sends a missile to kill the second ship

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ DE: Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00100010         \ Press the left and B buttons (%00100010) for 22
 EQUB 22                \ VBlanks to move the icon bar pointer to the left
                        \ and onto the Front View button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. to change from front
                        \ view to rear view)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB %00100001         \ Press the right and B buttons (%00100001) for 18
 EQUB 18                \ VBlanks to move the icon bar pointer to the right
                        \ and onto the Target Missile button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. target the missile)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB %00100001         \ Press the right and B buttons (%00100001) for 2
 EQUB 2                 \ VBlanks to move the icon bar pointer to the right
                        \ and onto the Fire Missile button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000001         \ DE: Press the right button (%00000001) for 12 VBlanks
 EQUB 12                \ to roll to the right (clockwise)

 EQUB %00000100         \ DE: Press the down button (%00000100) for 31 VBlanks
 EQUB 31                \ to pull the nose up

 EQUB %00000100         \ DE: Press the down button (%00000100) for 30 VBlanks
 EQUB 30                \ to pull the nose up

 EQUB %00100100         \ DE: Press the down and B buttons (%00100100) for 22
 EQUB 22                \ VBlanks to reduce our speed

 EQUB &C3               \ Do nothing (%00000000) while bit 7 of MSTG is set
 EQUB %00000000         \ (i.e. do nothing until the missile has locked onto a
 EQUW MSTG              \ target)

 EQUB &C0               \ Switch to the autoPlayKeys2 table in the next VBlank
                        \ to move on to the second part of the auto-play demo,
                        \ which demonstrates the game itself

