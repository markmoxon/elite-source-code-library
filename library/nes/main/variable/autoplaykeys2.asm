\ ******************************************************************************
\
\       Name: autoplayKeys2
\       Type: Variable
\   Category: Combat demo
\    Summary: Auto-play commands for the second part of the auto-play demo
\             (demonstrating the game itself)
\
\ ******************************************************************************

.autoplayKeys2

 EQUB &89               \ Do nothing for 9 * 4 = 36 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. fire the missile),
                        \ which sends a missile to kill the third ship

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB %00101000         \ Press the up and B buttons (%00101000) for 25
 EQUB 25                \ VBlanks to increase our speed

 EQUB &C2               \ Do nothing (%00000000) while QQ12 = 0 (i.e. wait until
 EQUB %00000000         \ we are docked, which will happen when the combat demo
 EQUW QQ12              \ finishes after killing the third ship and showing the
                        \ scroll text with the results of combat practice

                        \ At this point the combat demo has finished and we are
                        \ back at the title screen

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00100010         \ Press the left and B buttons (%00100010) for 22
 EQUB 22                \ VBlanks to move the icon bar pointer to the left
                        \ and onto the Equip Ship button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. Equip Ship)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00000100         \ FR: Press the down button (%00000100) for 4 VBlanks
 EQUB 4                 \ to move the cursor down the list of equipment by one
                        \ row onto the missile entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %01000000         \ Press the A button (%01000000) for 4 VBlanks to buy a
 EQUB 4                 \ missile

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00100010         \ Press the left and B buttons (%00100010) for 18
 EQUB 18                \ VBlanks to move the icon bar pointer to the left
                        \ and onto the Market Price button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. Market Price)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00000001         \ Press the right button (%00000001) for 4 VBlanks to
 EQUB 4                 \ buy one tonne of Food

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000001         \ Press the right button (%00000001) for 4 VBlanks to
 EQUB 4                 \ buy one tonne of Food (so we now have two)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000001         \ Press the right button (%00000001) for 4 VBlanks to
 EQUB 4                 \ buy one tonne of Food (so we now have three)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000001         \ Press the right button (%00000001) for 4 VBlanks to
 EQUB 4                 \ buy one tonne of Food (so we now have four)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000001         \ Press the right button (%00000001) for 4 VBlanks to
 EQUB 4                 \ buy one tonne of Food (so we now have five)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000001         \ Press the right button (%00000001) for 4 VBlanks to
 EQUB 4                 \ buy one tonne of Food (so we now have six)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000001         \ Press the right button (%00000001) for 4 VBlanks to
 EQUB 4                 \ buy one tonne of Food (so we now have seven)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000001         \ Press the right button (%00000001) for 4 VBlanks to
 EQUB 4                 \ buy one tonne of Food (so we now have eight)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Textiles
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000001         \ Press the right button (%00000001) for 4 VBlanks to
 EQUB 4                 \ buy one tonne of Textiles

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Radioactives
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Robot Slaves
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Beverages
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Luxuries
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Rare Species
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Computers
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Machinery
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Alloys
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Firearms
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Furs
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Minerals
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Gold
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Platinum
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Gem-stones
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000001         \ Press the right button (%00000001) for 4 VBlanks to
 EQUB 4                 \ buy one gram of Gem-stones

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. Inventory) to show the
                        \ cargo that we just bought

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00100010         \ Press the left and B buttons (%00100010) for 2
 EQUB 2                 \ VBlanks to move the icon bar pointer to the left
                        \ and onto the Launch button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. Launch) to launch from
                        \ the space station

                        \ At this point we are back in space, outside the space
                        \ station at Lave

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00100001         \ Press the right and B buttons (%00100001) for 22
 EQUB 22                \ VBlanks to move the icon bar pointer to the right
                        \ and onto the Front View button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. to change from front
                        \ view to rear view)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00001000         \ Press the up button (%00001000) for 30 VBlanks to
 EQUB 30                \ pitch down

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00100010         \ Press the left and B buttons (%00100010) for 2
 EQUB 2                 \ VBlanks to move the icon bar pointer to the left
                        \ and onto the Charts button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. the Short-range Chart)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. System Data) to show
                        \ the system data for Lave

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. the Short-range Chart)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00000001         \ Press the right button (%00000001) for 31 VBlanks to
 EQUB 31                \ move the crosshairs to the right

 EQUB %00000101         \ Press the right and down buttons (%00000101) for 31
 EQUB 31                \ VBlanks to move the crosshairs down and to the right

 EQUB %00000001         \ Press the right button (%00000001) for 5 VBlanks to
 EQUB 5                 \ move the crosshairs to the right, so Zaonce gets
                        \ selected

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. System Data) to show
                        \ the system data for Zaonce

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. the Short-range Chart)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB %00100010         \ Press the left and B buttons (%00100010) for 2
 EQUB 2                 \ VBlanks to move the icon bar pointer to the left
                        \ and onto the Charts icon

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. the Long-range Chart)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. the Short-range Chart)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00100001         \ Press the right and B buttons (%00100001) for 26
 EQUB 26                \ VBlanks to move the icon bar pointer to the right
                        \ and onto the Hyperspace button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. hyperspace) to start
                        \ the hyperspace countdown

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &96               \ Do nothing for 22 * 4 = 88 VBlanks

 EQUB %00100010         \ Press the left and B buttons (%00100010) for 18
 EQUB 18                \ VBlanks to move the icon bar pointer to the left
                        \ and onto the Front View button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. the front view) so we
                        \ can see Lave in front of us

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &C4               \ Do nothing (%00000000) while bit 7 of FRIN+1 is clear
 EQUB %00000000         \ (i.e. do nothing until the sun has been spawned in
 EQUW FRIN+1            \ the second ship slot, at which point we know we have
                        \ arrived in Zaonce)

 EQUB %00000010         \ Press the left button (%00000010) for 22 VBlanks to
 EQUB 22                \ roll to the left (anti-clockwise)

 EQUB %00000100         \ Press the down button (%00000100) for 30 VBlanks to
 EQUB 30                \ pull the nose up

 EQUB %00100001         \ Press the right and B buttons (%01000100) for 14
 EQUB 34                \ VBlanks to move the icon bar pointer to the right
                        \ and onto the Fast-forward button (for an in-system
                        \ jump)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. do an in-system jump)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. do a second in-system
                        \ jump)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. do a third in-system
                        \ jump)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. do a fourth in-system
                        \ jump)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &C2               \ Do nothing (%00000000) while MANY+2 = 0 (i.e. wait
 EQUB %00000000         \ until the space station - ship type 2 - is spawned)
 EQUW MANY+2

 EQUB %00100010         \ Press the left and B buttons (%00100010) for 22
 EQUB 58                \ VBlanks to move the icon bar pointer to the left
                        \ and onto the Docking Computer button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. engage the docking
                        \ computer)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &C2               \ Do nothing (%00000000) while QQ12 = 0 (i.e. wait until
 EQUB %00000000         \ we are docked)
 EQUW QQ12

                        \ At this point we are docked in Zaonce

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00100001         \ Press the right and B buttons (%01000100) for 2
 EQUB 2                 \ VBlanks to move the icon bar pointer to the right
                        \ and onto the Market Price button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. Market Price)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00000010         \ Press the left button (%00000010) for 4 VBlanks to
 EQUB 4                 \ sell one tonne of Food (so we now have seven tonnes
                        \ left)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000010         \ Press the left button (%00000010) for 4 VBlanks to
 EQUB 4                 \ sell one tonne of Food (so we now have six tonnes
                        \ left)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000010         \ Press the left button (%00000010) for 4 VBlanks to
 EQUB 4                 \ sell one tonne of Food (so we now have five tonnes
                        \ left)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000010         \ Press the left button (%00000010) for 4 VBlanks to
 EQUB 4                 \ sell one tonne of Food (so we now have four tonnes
                        \ left)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000010         \ Press the left button (%00000010) for 4 VBlanks to
 EQUB 4                 \ sell one tonne of Food (so we now have three tonnes
                        \ left)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000010         \ Press the left button (%00000010) for 4 VBlanks to
 EQUB 4                 \ sell one tonne of Food (so we now have two tonnes
                        \ left)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000010         \ Press the left button (%00000010) for 4 VBlanks to
 EQUB 4                 \ sell one tonne of Food (so we now have one tonne
                        \ left)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000010         \ Press the left button (%00000010) for 4 VBlanks to
 EQUB 4                 \ sell one tonne of Food (so we have sold them all)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000100         \ Press the down button (%00000100) for 4 VBlanks to
 EQUB 4                 \ move the highlight down one row onto the Textiles
                        \ entry

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00000010         \ Press the left button (%00000010) for 4 VBlanks to
 EQUB 4                 \ sell one tonne of Textiles (so we have sold them all)

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00100001         \ Press the right and B buttons (%00100001) for 18
 EQUB 18                \ VBlanks to move the icon bar pointer to the right
                        \ and onto the Equip Ship button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. Equip Ship)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %01000000         \ Press the A button (%01000000) for 31 VBlanks to buy
 EQUB 31                \ fuel

 EQUB %01000000         \ Press the A button (%01000000) for 31 VBlanks to buy
 EQUB 31                \ fuel

 EQUB %01000000         \ Press the A button (%01000000) for 31 VBlanks to buy
 EQUB 31                \ fuel

 EQUB %01000000         \ Press the A button (%01000000) for 31 VBlanks to buy
 EQUB 31                \ fuel

 EQUB %00100010         \ Press the left and B buttons (%00100010) for 54
 EQUB 54                \ VBlanks to move the icon bar pointer to the left
                        \ and onto the Launch button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. Launch) to launch from
                        \ the space station

                        \ At this point we are back in space, outside the space
                        \ station at Zaonce

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00001000         \ Press the up button (%00001000) for 31 VBlanks to
 EQUB 31                \ pitch down

 EQUB %00001000         \ Press the up button (%00001000) for 31 VBlanks to
 EQUB 31                \ pitch down

 EQUB %00101000         \ Press the up and B buttons (%00101000) for 10
 EQUB 10                \ VBlanks to increase our speed

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00100001         \ Press the right and B buttons (%00100001) for 14
 EQUB 14                \ VBlanks to move the icon bar pointer to the right
                        \ and onto the Status Mode button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. Status Mode)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00100001         \ Press the right and B buttons (%00100001) for 14
 EQUB 14                \ VBlanks to move the icon bar pointer to the right
                        \ and onto the Front View button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. the front view)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00100001         \ Press the right and B buttons (%00100001) for 18
 EQUB 18                \ VBlanks to move the icon bar pointer to the right
                        \ and onto the Target Missile button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00100100         \ Press the down and B buttons (%00100100) for 31
 EQUB 31                \ VBlanks to reduce our speed

 EQUB %00001000         \ Press the up button (%00001000) for 31 VBlanks to
 EQUB 31                \ pitch down

 EQUB %00001000         \ Press the up button (%00001000) for 31 VBlanks to
 EQUB 31                \ pitch down

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. target the missile)

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &C3               \ Press the up button (%00001000) while bit 7 of MSTG is
 EQUB %00001000         \ set (i.e. pull up until the missile has locked onto
 EQUW MSTG              \ the space station)

 EQUB &9F               \ Do nothing for 31 * 4 = 124 VBlanks

 EQUB %00100001         \ Press the right and B buttons (%00100001) for 2
 EQUB 2                 \ VBlanks to move the icon bar pointer to the right
                        \ and onto the Fire Missile button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. fire the missile),
                        \ which fires a missile at the space station, triggering
                        \ the station's E.C.M.

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB %00100010         \ Press the left and B buttons (%00100010) for 30
 EQUB 30                \ VBlanks to move the icon bar pointer to the left
                        \ and onto the Status Mode button

 EQUB &83               \ Do nothing for 3 * 4 = 12 VBlanks

 EQUB %00101000         \ Press the up and B buttons (%00101000) for 10
 EQUB 10                \ VBlanks to increase our speed

 EQUB &C3               \ Do nothing (%00000000) while bit 7 of ENERGY is set
 EQUB %00000000         \ (i.e. do nothing until our energy levels start to
 EQUW ENERGY            \ deplete as the station's Vipers attack us and blast
                        \ away our shields)

 EQUB %00010000         \ Press the Select button (%00010000) for 3 VBlanks to
 EQUB 3                 \ choose the selected icon (i.e. Status Mode) so we can
                        \ see the commander image flashing with a red background
                        \ until we finally reach the Game Over screen

 EQUB &88               \ Do nothing for 8 * 4 = 32 VBlanks

 EQUB &80               \ Quit auto-play and return to the title screen

