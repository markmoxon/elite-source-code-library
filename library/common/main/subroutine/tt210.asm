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
\ ******************************************************************************

.TT210

 LDY #0                 \ We're going to loop through all the available market
                        \ items and check whether we have any in the hold (and,
                        \ if we are in the Sell Cargo screen, whether we want
                        \ to sell any items), so we set up a counter in Y to
                        \ denote the current item and start it at 0

.TT211

 STY QQ29               \ Store the current item number in QQ29

IF _6502SP_VERSION

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

IF _CASSETTE_VERSION

 LDA #14                \ Set the text cursor to column 14, for the item's
 STA XC                 \ quantity

ELIF _6502SP_VERSION

 LDA #14                \ Set the text cursor to column 14, for the item's
 JSR DOXC               \ quantity

ENDIF

 PLA                    \ Restore the amount of item in the hold into X
 TAX

IF _6502SP_VERSION

 STA QQ25

ENDIF

 CLC                    \ Print the 8-bit number in X to 3 digits, without a
 JSR pr2                \ decimal point

 JSR TT152              \ Print the unit ("t", "kg" or "g") for the market item
                        \ whose byte #1 from the market prices table is in
                        \ QQ19+1 (which we set up above)

 LDA QQ11               \ If the current view type in QQ11 is not 4 (Sell Cargo
 CMP #4                 \ screen), jump to TT212 to skip the option to sell
 BNE TT212              \ items

IF _CASSETTE_VERSION

 LDA #205               \ Set A to recursive token 45 ("SELL")

 JSR TT214              \ Call TT214 to print "Sell(Y/N)?" and return the
                        \ response in the C flag

 BCC TT212              \ If the response was "no", jump to TT212 to move on to
                        \ the next item

ELIF _6502SP_VERSION

\JSRTT162

 LDA #205               \ Set A to recursive token 45 ("SELL")

 JSR TT27
 LDA #206
 JSR DETOK
 JSR gnum
 BEQ TT212
 BCS NWDAV4

ENDIF

 LDA QQ29               \ We are selling this item, so fetch the item number
                        \ from QQ29

 LDX #255               \ Set QQ17 = 255 to disable printing
 STX QQ17

 JSR TT151              \ Call TT151 to set QQ24 to the item's price / 4 (the
                        \ routine doesn't print the item details, as we just
                        \ disabled printing)

IF _CASSETTE_VERSION

 LDY QQ29               \ Set P to the amount of this item we have in our cargo
 LDA QQ20,Y             \ hold (which is the amount to sell)
 STA P

ELIF _6502SP_VERSION

 LDY QQ29
 LDA QQ20,Y
 SEC
 SBC R
 STA QQ20,Y
 LDA R
 STA P

ENDIF

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

IF _CASSETTE_VERSION

 LDA #0                 \ We've made the sale, so set the amount
 LDY QQ29
 STA QQ20,Y

ELIF _6502SP_VERSION

 LDA #0                 \ We've made the sale, so set the amount

ENDIF

 STA QQ17               \ Set QQ17 = 0, which enables printing again

.TT212

 LDY QQ29               \ Fetch the item number from QQ29 into Y, and increment
 INY                    \ Y to point to the next item

IF _CASSETTE_VERSION

 CPY #17                \ If A >= 17 then skip the next instruction as we have
 BCS P%+5               \ done the last item

 JMP TT211              \ Otherwise loop back to TT211 to print the next item
                        \ in the hold

ELIF _6502SP_VERSION

 CPY #17
 BCC TT211

ENDIF

 LDA QQ11               \ If the current view type in QQ11 is not 4 (Sell Cargo
 CMP #4                 \ screen), skip the next two instructions and just
 BNE P%+8               \ return from the subroutine

 JSR dn2                \ This is the Sell Cargo screen, so call dn2 to make a
                        \ short, high beep and delay for 1 second

 JMP BAY2               \ And then jump to BAY2 to display the Inventory
                        \ screen, as we have finished selling cargo

 RTS                    \ Return from the subroutine
