\ ******************************************************************************
\
\       Name: TT219
\       Type: Subroutine
\   Category: Market
\    Summary: Show the Buy Cargo screen (red key f1)
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   BAY2                Jump into the main loop at FRCE, setting the key
\                       "pressed" to red key f9 (so we show the Inventory
\                       screen)
\
\ ******************************************************************************

.TT219

IF _CASSETTE_VERSION

\LDA#2                  \ This instruction is commented out in the original
                        \ source. Perhaps this view originally had a QQ11 value
                        \ of 2, but it turned out not to need its own unique ID,
                        \ so the authors found they could just use a view value
                        \ of 1 and save an instruction at the same time?

 JSR TT66-2             \ Clear the top part of the screen, draw a white border,
                        \ and set the current view type in QQ11 to 1

ELIF _6502SP_VERSION

 LDA #2                 \ Clear the top part of the screen, draw a white border,
 JSR TRADEMODE          \ and set up a printable trading screen with a view type
                        \ in QQ11 of 2 (Buy Cargo screen)

ENDIF

 JSR TT163              \ Print the column headers for the prices table

 LDA #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case, with the
 STA QQ17               \ next letter in capitals

\JSR FLKB               \ This instruction is commented out in the original
                        \ source. It calls a routine to flush the keyboard
                        \ buffer (FLKB) that isn't present in the cassette
                        \ version but is in other versions

 LDA #0                 \ We're going to loop through all the available market
 STA QQ29               \ items, so we set up a counter in QQ29 to denote the
                        \ current item and start it at 0

.TT220

 JSR TT151              \ Call TT151 to print the item name, market price and
                        \ availability of the current item, and set QQ24 to the
                        \ item's price / 4, QQ25 to the quantity available and
                        \ QQ19+1 to byte #1 from the market prices table for
                        \ this item

 LDA QQ25               \ If there are some of the current item available, jump
 BNE TT224              \ to TT224 below to see if we want to buy any

 JMP TT222              \ Otherwise there are none available, so jump down to
                        \ TT222 to skip this item

.TQ4

 LDY #176               \ Set Y to the recursive token 16 ("QUANTITY")

.Tc

 JSR TT162              \ Print a space

 TYA                    \ Print the recursive token in Y followed by a question
 JSR prq                \ mark

.TTX224

 JSR dn2                \ Call dn2 to make a short, high beep and delay for 1
                        \ second

.TT224

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the three bottom rows

 LDA #204               \ Print recursive token 44 ("QUANTITY OF ")
 JSR TT27

 LDA QQ29               \ Print recursive token 48 + QQ29, which will be in the
 CLC                    \ range 48 ("FOOD") to 64 ("ALIEN ITEMS"), so this
 ADC #208               \ prints the current item's name
 JSR TT27

 LDA #'/'               \ Print "/"
 JSR TT27

 JSR TT152              \ Print the unit ("t", "kg" or "g") for the current item
                        \ (as the call to TT151 above set QQ19+1 with the
                        \ appropriate value)

 LDA #'?'               \ Print "?"
 JSR TT27

 JSR TT67               \ Print a newline

 LDX #0                 \ These instructions have no effect, as they are
 STX R                  \ repeated at the start of gnum, which we call next.
 LDX #12                \ Perhaps they were left behind when code was moved from
 STX T1                 \ here into gnum, and weren't deleted?

IF _CASSETTE_VERSION

\.TT223                 \ This label is commented out in the original source,
                        \ and is a duplicate of a label in gnum, so this could
                        \ also be a remnant if the code in gnum was originally
                        \ here, but got moved into the gnum subroutine

ELIF _6502SP_VERSION

{
.TT223                  \ This label is a duplicate of a label in gnum (which is
                        \ why we need to surround it with braces, as BeebAsm
                        \ doesn't allow us to redefine labels). This could be
                        \ a remnant if the code in gnum was originally here, but
                        \ got moved into the gnum subroutine without removing
                        \ the original

}

ENDIF

 JSR gnum               \ Call gnum to get a number from the keyboard, which
                        \ will be the quantity of this item we want to purchase,
                        \ returning the number entered in A and R

 BCS TQ4                \ If gnum set the C flag, the number entered is greater
                        \ then the quantity available, so jump up to TQ4 to
                        \ display a "Quantity?" error, beep, clear the number
                        \ and try again

 STA P                  \ Otherwise we have a valid purchase quantity entered,
                        \ so store the amount we want to purchase in P

 JSR tnpr               \ Call tnpr to work out whether there is room in the
                        \ cargo hold for this item

 LDY #206               \ If the C flag is set, then there is no room in the
 BCS Tc                 \ cargo hold, so set Y to the recursive token 46
                        \ (" CARGO{sentence case}") and jump up to Tc to print a
                        \ "Cargo?" error, beep, clear the number and try again

 LDA QQ24               \ There is room in the cargo hold, so now to check
 STA Q                  \ whether we have enough cash, so fetch the item's
                        \ price / 4, which was returned in QQ24 by the call
                        \ to TT151 above and store it in Q

 JSR GCASH              \ Call GCASH to calculate
                        \
                        \   (Y X) = P * Q * 4
                        \
                        \ which will be the total price of this transaction
                        \ (as P contains the purchase quantity and Q contains
                        \ the item's price / 4)

 JSR LCASH              \ Subtract (Y X) cash from the cash pot in CASH

 LDY #197               \ If the C flag is clear, we didn't have enough cash,
 BCC Tc                 \ so set Y to the recursive token 37 ("CASH") and jump
                        \ up to Tc to print a "Cash?" error, beep, clear the
                        \ number and try again

 LDY QQ29               \ Fetch the current market item number from QQ29 into Y

 LDA R                  \ Set A to the number of items we just purchased (this
                        \ was set by gnum above)

 PHA                    \ Store the quantity just purchased on the stack

 CLC                    \ Add the number purchased to the Y-th byte of QQ20,
 ADC QQ20,Y             \ which contains the number of items of this type in
 STA QQ20,Y             \ our hold (so this transfers the bought items into our
                        \ cargo hold)

 LDA AVL,Y              \ Subtract the number of items from the Y-th byte of
 SEC                    \ AVL, which contains the number of items of this type
 SBC R                  \ that are available on the market
 STA AVL,Y

 PLA                    \ Restore the quantity just purchased

 BEQ TT222              \ If we didn't buy anything, jump to TT222 to skip the
                        \ following instruction

 JSR dn                 \ Call dn to print the amount of cash left in the cash
                        \ pot, then make a short, high beep to confirm the
                        \ purchase, and delay for 1 second

.TT222

IF _CASSETTE_VERSION

 LDA QQ29               \ Move the text cursor to row QQ29 + 5 (where QQ29 is
 CLC                    \ the item number, starting from 0)
 ADC #5
 STA YC

 LDA #0                 \ Move the text cursor to column 0
 STA XC

ELIF _6502SP_VERSION

 LDA QQ29               \ Move the text cursor to row QQ29 + 5 (where QQ29 is
 CLC                    \ the item number, starting from 0)
 ADC #5
 JSR DOYC

 LDA #0                 \ Move the text cursor to column 0
 JSR DOXC

ENDIF

 INC QQ29               \ Increment QQ29 to point to the next item

 LDA QQ29               \ If QQ29 >= 17 then jump to BAY2 as we have done the
 CMP #17                \ last item
 BCS BAY2

 JMP TT220              \ Otherwise loop back to TT220 to print the next market
                        \ item

.BAY2

 LDA #f9                \ Jump into the main loop at FRCE, setting the key
 JMP FRCE               \ "pressed" to red key f9 (so we show the Inventory
                        \ screen)

