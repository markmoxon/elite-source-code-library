\ ******************************************************************************
\
\       Name: MoveEquipmentUp
\       Type: Subroutine
\   Category: Equipment
\    Summary: Move the currently selected item up the list of equipment
\
\ ******************************************************************************

.MoveEquipmentUp

 JSR PrintEquipment     \ Print the name and price for the equipment item in
                        \ XX13

 LDA XX13               \ Set A = XX13 - 1, so A contains the item number above
 SEC                    \ the currently selected item in the equipment list
 SBC #1

 BNE equp1              \ If XX13 is non-zero then we have not just tried to
                        \ move off the top of the list, so jump to equp1 to skip
                        \ the following instruction

 LDA #1                 \ Set A = 1 to set the currently selected item to the
                        \ first item in the list, so we don't go past the top
                        \ of the list

.equp1

 STA XX13               \ Store the new item number in XX13, so we move up the
                        \ equipment list

                        \ Fall through into UpdateEquipment to highlight the
                        \ newly chosen item of equipment, update the Cobra Mk
                        \ III, redraw the screen and rejoin the main EQSHP
                        \ routine to continue checking for button presses

