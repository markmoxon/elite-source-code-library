\ ******************************************************************************
\
\       Name: TT210
\       Type: Subroutine
\   Category: Inventory
\    Summary: Show a list of current cargo in our hold, optionally to sell
\
\ ------------------------------------------------------------------------------
\
\ Show a list of current cargo in our hold, either with the ability to sell (the
\ Sell Cargo screen) or without (the Inventory screen), depending on the current
\ view.
\
\ Arguments:
\
\   QQ11                The current view:
\
\                           * 4 = Sell Cargo
\
\                           * 8 = Inventory
\
IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION \ Comment
\ Other entry points:
\
\   NWDAVxx             Used to rejoin this routine from the call to NWDAV4
\
ENDIF
\ ******************************************************************************

.TT210

 LDY #0                 \ We're going to loop through all the available market
                        \ items and check whether we have any in the hold (and,
                        \ if we are in the Sell Cargo screen, whether we want
                        \ to sell any items), so we set up a counter in Y to
                        \ denote the current item and start it at 0

.TT211

 STY QQ29               \ Store the current item number in QQ29

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION \ Label

.NWDAVxx

ENDIF

 LDX QQ20,Y             \ Fetch into X the amount of the current item that we
 BEQ TT212              \ have in our cargo hold, which is stored in QQ20+Y,
                        \ and if there are no items of this type in the hold,
                        \ jump down to TT212 to skip to the next item

 TYA                    \ Set Y = Y * 4, so this will act as an index into the
 ASL A                  \ market prices table at QQ23 for this item (as there
 ASL A                  \ are four bytes per item in the table)
 TAY

 LDA QQ23+1,Y           \ Fetch byte #1 from the market prices table for the
 STA QQ19+1             \ current item and store it in QQ19+1, for use by the
                        \ call to TT152 below

 TXA                    \ Store the amount of item in the hold (in X) on the
 PHA                    \ stack

 JSR TT69               \ Call TT69 to set Sentence Case and print a newline

 CLC                    \ Print recursive token 48 + QQ29, which will be in the
 LDA QQ29               \ range 48 ("FOOD") to 64 ("ALIEN ITEMS"), so this
 ADC #208               \ prints the current item's name
 JSR TT27

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Tube

 LDA #14                \ Move the text cursor to column 14, for the item's
 STA XC                 \ quantity

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA #14                \ Move the text cursor to column 14, for the item's
 JSR DOXC               \ quantity

ENDIF

 PLA                    \ Restore the amount of item in the hold into X
 TAX

IF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION \ Enhanced: Group A: In the enhanced versions, you can specify how much of each individual commodity you want to sell. In the cassette version, for each commodity you have to choose whether to sell all of your stock, or none

 STA QQ25               \ Store the amount of this item in the hold in QQ25

ENDIF

IF NOT(_ELITE_A_FLIGHT)

 CLC                    \ Print the 8-bit number in X to 3 digits, without a
 JSR pr2                \ decimal point

ELIF _ELITE_A_FLIGHT

 JSR pr2-1              \ Print the 8-bit number in X to 3 digits, without a
                        \ decimal point

ENDIF

 JSR TT152              \ Print the unit ("t", "kg" or "g") for the market item
                        \ whose byte #1 from the market prices table is in
                        \ QQ19+1 (which we set up above)

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION \ Platform

 LDA QQ11               \ If the current view type in QQ11 is not 4 (Sell Cargo
 CMP #4                 \ screen), jump to TT212 to skip the option to sell
 BNE TT212              \ items

ENDIF

IF _6502SP_VERSION \ Comment

\JSR TT162              \ This instruction is commented out in the original
                        \ source

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: See group A

 LDA #205               \ Set A to recursive token 45 ("SELL")

 JSR TT214              \ Call TT214 to print "Sell(Y/N)?" and return the
                        \ response in the C flag

 BCC TT212              \ If the response was "no", jump to TT212 to move on to
                        \ the next item

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _MASTER_VERSION

 LDA #205               \ Print recursive token 45 ("SELL")
 JSR TT27

 LDA #206               \ Print extended token 206 ("{all caps}(Y/N)?")
 JSR DETOK

 JSR gnum               \ Call gnum to get a number from the keyboard, which
                        \ will be the number of the item we want to sell,
                        \ returning the number entered in A and R, and setting
                        \ the C flag if the number is bigger than the available
                        \ amount of this item in QQ25

 BEQ TT212              \ If no number was entered, jump to TT212 to move on to
                        \ the next item

 BCS NWDAV4             \ If the number entered was too big, jump to NWDAV4 to
                        \ print an "ITEM?" error, make a beep and rejoin the
                        \ routine at NWDAVxx above

ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 JSR sell_yn            \ Call sell_yn to print a "Sell(Y/N)?" prompt and get a
                        \ number from the keyboard, which will be the number of
                        \ the item we want to sell, returning the number entered
                        \ in A and R, and setting the C flag if the number is
                        \ bigger than the available amount of this item in QQ25

 BEQ TT212              \ If no number was entered, jump to TT212 to move on to
                        \ the next item

 BCS NWDAV4             \ If the number entered was too big, jump to NWDAV4 to
                        \ print an "ITEM?" error, make a beep and rejoin the
                        \ routine at NWDAVxx above

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION \ Platform

 LDA QQ29               \ We are selling this item, so fetch the item number
                        \ from QQ29

 LDX #255               \ Set QQ17 = 255 to disable printing
 STX QQ17

 JSR TT151              \ Call TT151 to set QQ24 to the item's price / 4 (the
                        \ routine doesn't print the item details, as we just
                        \ disabled printing)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: See group A

 LDY QQ29               \ Set P to the amount of this item we have in our cargo
 LDA QQ20,Y             \ hold (which is the amount to sell)
 STA P

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION

 LDY QQ29               \ Subtract R (the number of items we just asked to buy)
 LDA QQ20,Y             \ from the available amount of this item in QQ20, as we
 SEC                    \ just bought them
 SBC R
 STA QQ20,Y

 LDA R                  \ Set P to the amount of this item we just bought
 STA P

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _MASTER_VERSION \ Platform

 LDA QQ24               \ Set Q to the item's price / 4
 STA Q

 JSR GCASH              \ Call GCASH to calculate
                        \
                        \   (Y X) = P * Q * 4
                        \
                        \ which will be the total price we make from this sale
                        \ (as P contains the quantity we're selling and Q
                        \ contains the item's price / 4)

 JSR MCASH              \ Add (Y X) cash to the cash pot in CASH

ELIF _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA

 LDA QQ24               \ Set Q to the item's price / 4
 STA Q

 JSR MULTU              \ Call MULTU to calculate (A P) = P * Q

 JSR price_xy           \ Call price_xy to set (Y X) = (A P) = P * Q

 JSR MCASH              \ Add 4 * (Y X) cash to the cash pot in CASH, i.e.
 JSR MCASH              \
 JSR MCASH              \   (Y X) = P * Q * 4
 JSR MCASH              \
                        \ which will be the total price we make from this sale
                        \ (as P contains the quantity we're selling and Q
                        \ contains the item's price / 4)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: See group A

 LDA #0                 \ We've made the sale, so set the amount
 LDY QQ29
 STA QQ20,Y

 STA QQ17               \ Set QQ17 = 0, which enables printing again

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION

 LDA #0                 \ We've made the sale, so set the amount

 STA QQ17               \ Set QQ17 = 0, which enables printing again

ENDIF

.TT212

 LDY QQ29               \ Fetch the item number from QQ29 into Y, and increment
 INY                    \ Y to point to the next item

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 CPY #17                \ If Y >= 17 then skip the next instruction as we have
 BCS P%+5               \ done the last item

 JMP TT211              \ Otherwise loop back to TT211 to print the next item
                        \ in the hold

ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT

 CPY #17                \ If Y < 17 then loop back to TT211 to print the next
 BCC TT211              \ item in the hold

 RTS                    \ Otherwise return from the subroutine

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION

 CPY #17                \ Loop back to TT211 to print the next item in the hold
 BCC TT211              \ until Y = 17 (at which point we have done the last
                        \ item)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _MASTER_VERSION \ Platform

 LDA QQ11               \ If the current view type in QQ11 is not 4 (Sell Cargo
 CMP #4                 \ screen), skip the next two instructions and just
 BNE P%+8               \ return from the subroutine

 JSR dn2                \ This is the Sell Cargo screen, so call dn2 to make a
                        \ short, high beep and delay for 1 second

 JMP BAY2               \ And then jump to BAY2 to display the Inventory
                        \ screen, as we have finished selling cargo

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA \ Master: The Master version contains a fair amount of Trumble-related code, though it doesn't have any effect as we never get to pick up any Trumbles (though if we did, they would take over our cargo bay and hoof up all the food and narcotics, just as in the Commodore 64 version, so their essence is still encoded in the Master version)

 RTS                    \ Return from the subroutine

ELIF _MASTER_VERSION

 JSR TT69               \ Call TT69 to set Sentence Case and print a newline

 LDA TRUMBLE            \ If there are any Trumbles in the hold, skip the
 ORA TRUMBLE+1          \ following RTS and continue on (in the Master version,
 BNE P%+3               \ there are never any Trumbles, so this value will
                        \ always be zero)

.zebra

 RTS                    \ There are no Trumbles in the hold, so return from the
                        \ subroutine

                        \ If we get here then we have Trumbles in the hold, so
                        \ we print out the number (though we never get here in
                        \ the Master version)

 CLC                    \ Clear the C flag, so the call to TT11 below doesn't
                        \ include a decimal point

 LDA #0                 \ Set A = 0, for the call to TT11 below, so we don't pad
                        \ out the number of Trumbles

 LDX TRUMBLE            \ Fetch the number of Trumbles into (Y X)
 LDY TRUMBLE+1

 JSR TT11               \ Call TT11 to print the number of Trumbles in (Y X),
                        \ with no decimal point

 JSR DORND              \ Print out a random extended token from 111 to 114, all
 AND #3                 \ of which are blank in this version of Elite
 CLC
 ADC #111
 JSR DETOK

 LDA #198               \ Print extended token 198, which is blank, but would
 JSR DETOK              \ presumably contain the word "TRUMBLE" if they were
                        \ enabled

 LDA TRUMBLE+1          \ If we have more than 256 Trumbles, skip to DOANS
 BNE DOANS

 LDX TRUMBLE            \ If we have exactly one Trumble, return from the
 DEX                    \ subroutine (as zebra contains an RTS)
 BEQ zebra

.DOANS

 LDA #'s'               \ We have more than one Trumble, so print an 's' and
 JMP DASC               \ return from the subroutine using a tail call

ENDIF

