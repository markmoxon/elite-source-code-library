\ ******************************************************************************
\
\       Name: MoveEquipmentDown
\       Type: Subroutine
\   Category: Equipment
\    Summary: Move the currently selected item down the list of equipment
\
\ ******************************************************************************

.MoveEquipmentDown

 JSR PrintEquipment     \ Print the name and price for the equipment item in
                        \ XX13

 LDA XX13               \ Set A = XX13 + 1, so A contains the item number below
 CLC                    \ the currently selected item in the equipment list
 ADC #1

 CMP Q                  \ If A has not reached Q, which contains the number of
 BNE eqdn1              \ items in the list plus 1, then we have not fallen off
                        \ the bottom of the list, so jump to eqdn1 to skip the
                        \ following

 LDA Q                  \ Set A = Q - 1 to set the currently selected item to
 SBC #1                 \ the bottom item in the list, so we don't go past the
                        \ bottom of the list (the subtraction works because we
                        \ just passed through a BNE, so the comparison was
                        \ equal which sets the C flag)

.eqdn1

 STA XX13               \ Store the new item number in XX13, so we move down the
                        \ equipment list

 JMP UpdateEquipment    \ Jump up to UpdateEquipment to highlight the newly
                        \ chosen item of equipment, update the Cobra Mk III,
                        \ redraw the screen and rejoin the main EQSHP routine to
                        \ continue checking for button presses

