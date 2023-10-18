\ ******************************************************************************
\
\       Name: BuyAndSellCargo
\       Type: Subroutine
\   Category: Market
\    Summary: Process the buying and selling of cargo on the Market Price screen
\
\ ******************************************************************************

.BuyAndSellCargo

 LDA QQ12               \ If we are docked (QQ12 = &FF) then jump to sell3 to
 BNE sell3              \ show the buy/sell screen

.sell1

                        \ If we get here then we are in space, so we just
                        \ display the view as we can't buy or sell cargo in
                        \ space

 JSR SetScreenForUpdate \ Get the screen ready for updating by hiding all
                        \ sprites, after fading the screen to black if we are
                        \ changing view

 JSR DrawInventoryIcon  \ Draw the inventory icon on top of the second button
                        \ in the icon bar

 JMP UpdateView         \ Update the view, returning from the subroutine using
                        \ a tail call

.sell2

 JMP sell13             \ Jump to sell13 to process the left button being
                        \ pressed

.sell3

 LDA #0                 \ We're going to highlight the current market item and
 STA QQ29               \ let the player move the highlight up and down, so use
                        \ QQ29 to denote the number of the currently selected
                        \ item, starting with item 0 at the top of the list

 JSR HighlightSaleItem  \ Highlight the name, price and availability of market
                        \ item 0 on the correct row for the chosen language

 JSR PrintCash          \ Print our cash levels in the correct place for the
                        \ chosen language

 JSR sell1              \ Call sell1 above to clear the screen and update the
                        \ view

.sell4

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA controller1B       \ If the B button is being pressed, jump to sell6
 BMI sell6

 LDA controller1Up      \ If neither of the up or down buttons are being
 ORA controller1Down    \ pressed, jump to sell5
 BEQ sell5

 LDA controller1Left    \ If neither of the left or right buttons are being
 ORA controller1Right   \ pressed, jump to sell6
 BNE sell6

.sell5

                        \ If we get here then at least one of the direction
                        \ buttons is being pressed

 LDA controller1Up      \ If the up button is being pressed and has been held
 AND #%11110000         \ down for at least four VBlanks, jump to sell7
 CMP #%11110000
 BEQ sell7

 LDA controller1Down    \ If the down button is being pressed and has been held
 AND #%11110000         \ down for at least four VBlanks, jump to sell10
 CMP #%11110000
 BEQ sell10

 LDA controller1Left03  \ If the left button was being held down four VBlanks
 CMP #%11110000         \ ago for at least four VBlanks, jump to sell13 via
 BEQ sell2              \ sell2

 LDA controller1Right03 \ If the right button was being held down four VBlanks
 CMP #%11110000         \ ago for at least four VBlanks, jump to sell12
 BEQ sell12

.sell6

                        \ If we get here then either the B button is being
                        \ pressed or no directional buttons are being pressed

 LDA iconBarChoice      \ If iconBarChoice = 0 then nothing has been chosen on
 BEQ sell4              \ the icon bar (if it had, iconBarChoice would contain
                        \ the number of the chosen icon bar button), so loop
                        \ back to sell4 to keep listening for button presses

                        \ If we get here then either a choice has been made on
                        \ the icon bar during NMI and the number of the icon bar
                        \ button is in iconBarChoice, or the Start button has
                        \ been pressed and iconBarChoice is 80

 JSR CheckForPause-3    \ If the Start button has been pressed then process the
                        \ pause menu and set the C flag, otherwise clear it

 BCS sell4              \ If it was the pause button, loop back to sell4 to pick
                        \ up where we left off and keep listening for button
                        \ presses

 RTS                    \ Otherwise a choice has been made from the icon bar, so
                        \ return from the subroutine

.sell7

                        \ If we get here then the up button is being pressed

 LDA QQ29               \ Set A to the number of the currently selected item in
                        \ QQ29

 JSR PrintMarketItem    \ Print the name, price and availability of market item
                        \ item A on the correct row for the chosen language, to
                        \ remove the highlight from the current item

 LDA QQ29               \ Set A = QQ29 - 1
 SEC                    \
 SBC #1                 \ So A is the number of the item above the currently
                        \ selected item

 BPL sell8              \ If A is negative, set A = 0, so 0 is the minimum value
 LDA #0                 \ of A (so we can't move the highlight off the top of
                        \ the list of items)

.sell8

 STA QQ29               \ Store the updated item number in QQ29

.sell9

 LDA QQ29               \ Set A to the number of the currently selected item in
                        \ QQ29 (we do this so we can jump here)

 JSR HighlightSaleItem  \ Highlight the name, price and availability of market
                        \ item A on the correct row for the chosen language

 JSR DrawScreenInNMI    \ Configure the NMI handler to draw the screen, so the
                        \ screen gets updated

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 JMP sell4              \ Jump back to sell4 to keep listening for button
                        \ presses

.sell10

                        \ If we get here then the down button is being pressed

 LDA QQ29               \ Set A to the number of the currently selected item in
                        \ QQ29

 JSR PrintMarketItem    \ Print the name, price and availability of market item
                        \ item A on the correct row for the chosen language, to
                        \ remove the highlight from the current item

 LDA QQ29               \ Set A = QQ29 + 1
 CLC                    \
 ADC #1                 \ So A is the number of the item below the currently
                        \ selected item

 CMP #17                \ If A = 17, set A = 16, so 16 is the maximum value of
 BNE sell11             \ A (so we can't move the highlight off the bottom of
 LDA #16                \ the list of items)

.sell11

 STA QQ29               \ Store the updated item number in QQ29

 JMP sell9              \ Jump up to sell9 to highlight the newly selected item
                        \ and go back to listening for button presses

.sell12

                        \ If we get here then the right button is being pressed,
                        \ so we process buying an item

 LDA #1                 \ Call tnpr with the selected market item in QQ29 and
 JSR tnpr               \ A set to 1, to work out whether we have room in the
                        \ hold for the selected item (A is preserved by this
                        \ call, and the C flag contains the result)

 BCS sell14             \ If the C flag is set then we have no room in the hold
                        \ for the selected item, so jump to sell4 via sell14 to
                        \ abort the sale and keep listening for button presses

 LDY QQ29               \ Fetch the currently selected market item number from
                        \ QQ29 into Y

 LDA AVL,Y              \ Set A to the number of available units of the market
                        \ item in Y

 BEQ sell14             \ If there are no units available, jump to sell4 via
                        \ sell14 to abort the sale and keep listening for button
                        \ presses

 LDA QQ24               \ Set P to the item's price / 4
 STA P

 LDA #0                 \ Set A = 0, so (A P) contains the item's price / 4

 JSR GC2                \ Call GC2 to calculate:
                        \
                        \   (Y X) = (A P) * 4
                        \
                        \ which will be the total price of this transaction, as
                        \ (A P) contains the item's price / 4

 JSR LCASH              \ Subtract (Y X) cash from the cash pot in CASH

 BCC sell14             \ If the C flag is clear, we didn't have enough cash,
                        \ so jump to sell4 via sell14 to abort the sale and keep
                        \ listening for button presses

 JSR UpdateSaveCount    \ Update the save counter for the current commander

 LDY #28                \ Call the NOISE routine with Y = 28 to make a trill
 JSR NOISE              \ sound to indicate that we have bought something

 LDY QQ29               \ Fetch the currently selected market item number from
                        \ QQ29 into Y

 LDA AVL,Y              \ Set A to the number of available units of the market
                        \ item in Y

 SEC                    \ Subtract 1 from the market availability, as we just
 SBC #1                 \ bought one unit
 STA AVL,Y

 LDA QQ20,Y             \ Set A to the number of units of this item that we
                        \ already have in the hold

 CLC                    \ Add 1 to the number of units and update the number in
 ADC #1                 \ the hold
 STA QQ20,Y

 JSR PrintCash          \ Print our cash levels in the correct place for the
                        \ chosen language

 JMP sell9              \ Jump up to sell9 to update the highlighted item with
                        \ the new availability and go back to listening for
                        \ button presses

.sell13

                        \ If we get here then the left button is being pressed,
                        \ so we process selling an item

 LDY QQ29               \ Fetch the currently selected market item number from
                        \ QQ29 into Y

 LDA AVL,Y              \ If there are 99 or more units available on the market,
 CMP #99                \ then the market is already saturated, so jump to sell4
 BCS sell14             \ via sell14 to abort the sale and keep listening for
                        \ button presses

 LDA QQ20,Y             \ Set A to the number of units of this item that we
                        \ already have in the hold

 BEQ sell14             \ If we don't have any items of this type in the hold,
                        \ jump to sell4 via sell14 to abort the sale and keep
                        \ listening for button presses

 JSR UpdateSaveCount    \ Update the save counter for the current commander

 SEC                    \ Subtract 1 from the number of units and update the
 SBC #1                 \ number in the hold
 STA QQ20,Y

 LDA AVL,Y              \ Add 1 to the market availability, as we just sold
 CLC                    \ one unit into the market
 ADC #1
 STA AVL,Y

 LDA QQ24               \ Set P to the item's price / 4
 STA P

 LDA #0                 \ Set A = 0, so (A P) contains the item's price / 4

 JSR GC2                \ Call GC2 to calculate:
                        \
                        \   (Y X) = (A P) * 4
                        \
                        \ which will be the total price of this transaction, as
                        \ (A P) contains the item's price / 4

 JSR MCASH              \ Add (Y X) cash to the cash pot in CASH

 JSR PrintCash          \ Print our cash levels in the correct place for the
                        \ chosen language

 LDY #3                 \ Call the NOISE routine with Y = 3 to make a short,
 JSR NOISE              \ high beep to indicate that we have made a sale

 JMP sell9              \ Jump up to sell9 to update the highlighted item with
                        \ the new availability and go back to listening for
                        \ button presses

.sell14

 JMP sell4              \ Jump up to sell4 to keep listening for button presses

