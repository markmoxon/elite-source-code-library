\ ******************************************************************************
\
\       Name: DrawEquipment
\       Type: Subroutine
\   Category: Equipment
\    Summary: Draw the currently fitted equipment onto the Cobra Mk III image on
\             the Equip Ship screen
\
\ ******************************************************************************

.DrawEquipment

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

 LDA ECM                \ If we do not have E.C.M. fitted, jump to dreq1 to move
 BEQ dreq1              \ on to the next piece of equipment

 LDY #0                 \ Set Y = 0 so we set up the sprites using data from
                        \ sprite 0 onwards in the equipSprites table

 LDX #3                 \ Set X = 3 so we draw three sprites, i.e. equipment
                        \ sprites 0 to 2 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ E.C.M. on our Cobra Mk III

.dreq1

 LDX LASER              \ If we do not have a laser fitted to the front view,
 BEQ dreq2              \ jump to dreq2 to move on to the next piece of
                        \ equipment

 JSR GetLaserPattern    \ Set A to the pattern number of the laser's equipment
                        \ sprite for the type of laser fitted, to pass to the
                        \ SetLaserSprite routine

 LDY #3 * 4             \ Set Y = 3 * 4 so we set up the sprites using data
                        \ from sprite 3 onwards in the equipSprites table

 LDX #2                 \ Set X = 2 so we draw two sprites, i.e. equipment
                        \ sprites 3 and 4 from the equipSprites table

 JSR SetLaserSprite     \ Set up the sprites in the sprite buffer to show the
                        \ front view laser on our Cobra Mk III

 JMP dreq2              \ This instruction has no effect (presumably it is left
                        \ over from code that was later removed)

.dreq2

 LDX LASER+1            \ If we do not have a laser fitted to the rear view,
 BEQ dreq3              \ jump to dreq3 to move on to the next piece of
                        \ equipment

 JSR GetLaserPattern    \ Set A to the pattern number of the laser's equipment
                        \ sprite for the type of laser fitted, to pass to the
                        \ SetLaserSprite routine

 LDY #9 * 4             \ Set Y = 9 * 4 so we set up the sprites using data
                        \ from sprite 9 onwards in the equipSprites table

 LDX #1                 \ Set X = 1 so we draw one sprite, i.e. equipment
                        \ sprite 9 from the equipSprites table

 JSR SetLaserSprite     \ Set up the sprites in the sprite buffer to show the
                        \ rear view laser on our Cobra Mk III

 JMP dreq3              \ This instruction has no effect (presumably it is left
                        \ over from code that was later removed)

.dreq3

 LDX LASER+2            \ If we do not have a laser fitted to the left view,
 BEQ dreq5              \ jump to dreq5 to move on to the next piece of
                        \ equipment

 CPX #Armlas            \ If the laser fitted to the left view is a military
 BEQ dreq4              \ laser, jump to dreq4 to show the laser using
                        \ equipment sprites 10 and 11

 JSR GetLaserPattern    \ Set A to the pattern number of the laser's equipment
                        \ sprite for the type of laser fitted, to pass to the
                        \ SetLaserSprite routine

 LDY #5 * 4             \ Set Y = 5 * 4 so we set up the sprites using data
                        \ from sprite 5 onwards in the equipSprites table

 LDX #2                 \ Set X = 2 so we draw two sprites, i.e. equipment
                        \ sprites 5 and 6 from the equipSprites table

 JSR SetLaserSprite     \ Set up the sprites in the sprite buffer to show the
                        \ left view laser on our Cobra Mk III

 JMP dreq5              \ Jump to dreq5 to move on to the next piece of
                        \ equipment

.dreq4

 LDY #10 * 4            \ Set Y = 10 * 4 so we set up the sprites using data
                        \ from sprite 10 onwards in the equipSprites table

 LDX #2                 \ Set X = 2 so we draw two sprites, i.e. equipment
                        \ sprites 10 and 11 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ left view military laser on our Cobra Mk III

.dreq5

 LDX LASER+3            \ If we do not have a laser fitted to the right view,
 BEQ dreq7              \ jump to dreq7 to move on to the next piece of
                        \ equipment

 CPX #Armlas            \ If the laser fitted to the left view is a military
 BEQ dreq6              \ laser, jump to dreq6 to show the laser using
                        \ equipment sprites 12 and 13

 JSR GetLaserPattern    \ Set A to the pattern number of the laser's equipment
                        \ sprite for the type of laser fitted, to pass to the
                        \ SetLaserSprite routine

 LDY #7 * 4             \ Set Y = 7 * 4 so we set up the sprites using data
                        \ from sprite 7 onwards in the equipSprites table

 LDX #2                 \ Set X = 2 so we draw two sprites, i.e. equipment
                        \ sprites 7 and 8 from the equipSprites table

 JSR SetLaserSprite     \ Set up the sprites in the sprite buffer to show the
                        \ right view laser on our Cobra Mk III

 JMP dreq7              \ Jump to dreq7 to move on to the next piece of
                        \ equipment

.dreq6

 LDY #12 * 4            \ Set Y = 12 * 4 so we set up the sprites using data
                        \ from sprite 12 onwards in the equipSprites table

 LDX #2                 \ Set X = 2 so we draw two sprites, i.e. equipment
                        \ sprites 12 and 13 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ right view military laser on our Cobra Mk III

.dreq7

 LDA BST                \ If we do not have fuel scoops fitted, jump to dreq8 to
 BEQ dreq8              \ move on to the next piece of equipment

 LDY #14 * 4            \ Set Y = 14 * 4 so we set up the sprites using data
                        \ from sprite 14 onwards in the equipSprites table

 LDX #2                 \ Set X = 2 so we draw two sprites, i.e. equipment
                        \ sprites 14 and 15 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ fuel scoops on our Cobra Mk III

.dreq8

 LDA ENGY               \ If we do not have an energy unit fitted, jump to
 BEQ dreq10             \ dreq10 to move on to the next piece of equipment

 LSR A                  \ If ENGY is 2 or more, then we have the naval energy
 BNE dreq9              \ unit fitted, to jump to dreq9 to display the four
                        \ sprites for the naval version

 LDY #18 * 4            \ Set Y = 18 * 4 so we set up the sprites using data
                        \ from sprite 18 onwards in the equipSprites table

 LDX #2                 \ Set X = 2 so we draw two sprites, i.e. equipment
                        \ sprites 18 and 19 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ standard energy unit on our Cobra Mk III

 JMP dreq10             \ Jump to dreq10 to move on to the next piece of
                        \ equipment

.dreq9

                        \ The naval energy unit consists of the two sprites
                        \ for the standard energy unit (sprites 18 and 19),
                        \ plus two extra sprites (16 and 17)

 LDY #16 * 4            \ Set Y = 16 * 4 so we set up the sprites using data
                        \ from sprite 16 onwards in the equipSprites table

 LDX #4                 \ Set X = 4 so we draw four sprites, i.e. equipment
                        \ sprites 16 to 19 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ naval energy unit on our Cobra Mk III

.dreq10

 LDA NOMSL              \ If we do not have any missiles fitted, jump to dreq11
 BEQ dreq11             \ to move on to the next piece of equipment

                        \ We start by setting up the sprites for missile 2

 LDY #20 * 4            \ Set Y = 20 * 4 so we set up the sprites using data
                        \ from sprite 20 onwards in the equipSprites table

 LDX #2                 \ Set X = 2 so we draw two sprites, i.e. equipment
                        \ sprites 20 and 21 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ first missile on our Cobra Mk III

 LDA NOMSL              \ If the number of missiles in NOMSL is 1, jump to
 LSR A                  \ dreq11 to move on to the next piece of equipment
 BEQ dreq11

                        \ We now set up the sprites for missile 2

 LDY #22 * 4            \ Set Y = 22 * 4 so we set up the sprites using data
                        \ from sprite 22 onwards in the equipSprites table

 LDX #2                 \ Set X = 2 so we draw two sprites, i.e. equipment
                        \ sprites 22 and 23 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ second missile on our Cobra Mk III

 LDA NOMSL              \ If the number of missiles in NOMSL is 2, jump to
 CMP #2                 \ dreq11 to move on to the next piece of equipment
 BEQ dreq11

                        \ We now set up the sprites for missile 3

 LDY #24 * 4            \ Set Y = 24 * 4 so we set up the sprites using data
                        \ from sprite 24 onwards in the equipSprites table

 LDX #2                 \ Set X = 2 so we draw two sprites, i.e. equipment
                        \ sprites 24 and 25 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ third missile on our Cobra Mk III

 LDA NOMSL              \ If the number of missiles in NOMSL is not 4, then it
 CMP #4                 \ must be 3, so jump to dreq11 to move on to the next
 BNE dreq11             \ piece of equipment

                        \ We now set up the sprites for missile 4

 LDY #26 * 4            \ Set Y = 26 * 4 so we set up the sprites using data
                        \ from sprite 26 onwards in the equipSprites table

 LDX #2                 \ Set X = 2 so we draw two sprites, i.e. equipment
                        \ sprites 26 and 27 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ fourth missile on our Cobra Mk III

.dreq11

 LDA BOMB               \ If we do not have an energy bomb fitted, jump to
 BEQ dreq12             \ dreq12 to move on to the next piece of equipment

 LDY #28 * 4            \ Set Y = 28 * 4 so we set up the sprites using data
                        \ from sprite 28 onwards in the equipSprites table

 LDX #3                 \ Set X = 3 so we draw three sprites, i.e. equipment
                        \ sprites 28 to 30 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ energy bomb on our Cobra Mk III

.dreq12

 LDA CRGO               \ If we do not have a large cargo bay fitted (i.e. our
 CMP #37                \ cargo capacity in CRGO is not the larger capacity of
 BNE dreq13             \ 37), jump to dreq13 to move on to the next piece of
                        \ equipment

 LDY #31 * 4            \ Set Y = 31 * 4 so we set up the sprites using data
                        \ from sprite 31 onwards in the equipSprites table

 LDX #2                 \ Set X = 2 so we draw two sprites, i.e. equipment
                        \ sprites 31 and 32 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ large cargo bay on our Cobra Mk III

.dreq13

 LDA ESCP               \ If we do not have an escape pod fitted, jump to
 BEQ dreq14             \ dreq14 to move on to the next piece of equipment

 LDY #33 * 4            \ Set Y = 33 * 4 so we set up the sprites using data
                        \ from sprite 33 onwards in the equipSprites table

 LDX #1                 \ Set X = 1 so we draw one sprite, i.e. equipment
                        \ sprite 33 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ escape pod on our Cobra Mk III

.dreq14

 LDA DKCMP              \ If we do not have a docking computer fitted, jump to
 BEQ dreq15             \ dreq15 to move on to the next piece of equipment

 LDY #34 * 4            \ Set Y = 34 * 4 so we set up the sprites using data
                        \ from sprite 34 onwards in the equipSprites table

 LDX #8                 \ Set X = 8 so we draw eight sprites, i.e. equipment
                        \ sprites 34 to 41 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ docking computer on our Cobra Mk III

.dreq15

 LDA GHYP               \ If we do not have a galactic hyperdrive fitted, jump
 BEQ dreq16             \ to dreq16 to return from the subroutine, as we have
                        \ now drawn all our equipment

 LDY #42 * 4            \ Set Y = 42 * 4 so we set up the sprites using data
                        \ from sprite 24 onwards in the equipSprites table

 LDX #2                 \ Set X = 2 so we draw two sprites, i.e. equipment
                        \ sprites 42 and 43 from the equipSprites table

 JSR SetEquipmentSprite \ Set up the sprites in the sprite buffer to show the
                        \ galactic hyperdrive on our Cobra Mk III

.dreq16

 RTS                    \ Return from the subroutine

