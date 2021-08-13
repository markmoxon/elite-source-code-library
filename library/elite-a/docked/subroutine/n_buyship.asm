\ ******************************************************************************
\
\       Name: n_buyship
\       Type: Subroutine
\   Category: Buying ships
\    Summary: Show the Buy Ship screen (CTRL-f3)
\  Deep dive: Buying and flying ships in Elite-A
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   cash_query          Print "CASH?", make a short, high beep, delay for 1
\                       second and go to the docking bay (i.e. show the Status
\                       Mode screen)
\
\   jmp_start3          Make a short, high beep, and delay for 1 second and go
\                       to the docking bay (i.e. show the Status Mode screen)
\
\ ******************************************************************************

.n_buyship

 LDX #0                 \ Set a counter in X so we can work our way through the
                        \ available ships, starting with X = 0, and working our
                        \ way through the types in the new_ships table (where
                        \ the ships are in order of increasing price)

 SEC                    \ Set QQ25 = 15 - 2 * QQ28
 LDA #15                \
 SBC QQ28               \ QQ25 contains the number of ship types that we offer
 SBC QQ28               \ for sale, so the number is smaller in less advanced
 STA QQ25               \ economies, and ranges from 15 ship types for rich
                        \ industrial economies, down to 1 for poor agricultural
                        \ economies

.n_bloop

 STX XX13               \ Store the loop counter X in XX13 so we can retrieve it
                        \ after the call to TT67, and throughout the following

 JSR TT67               \ Print a newline

 LDX XX13               \ Set X = XX13 + 1, so X contains 1 for the first ship
 INX                    \ type, 2 for the second ship type, and so on

 CLC                    \ Clear the C flag so the call to pr2 doesn't show a
                        \ decimal point

 JSR pr2                \ Call pr2 to print the number in X to a width of 3
                        \ 3 figures, so this prints the item number at the start
                        \ of the menu item, starting with item 1 at the top

 JSR TT162              \ Print a space

 LDY XX13               \ Print the name of the ship type given in XX13
 JSR n_name

 LDY XX13               \ Set K(3 2 1 0) to the price of the ship given in XX13
 JSR n_price

 LDA #22                \ Move the text cursor to column 22
 STA XC

 LDA #9                 \ We want to print the ship price using up to 9 digits
 STA U                  \ (including the decimal point), so store this in U
                        \ for BRPNT to take as an argument

 SEC                    \ We want to print the price with a decimal point,
                        \ so set the C flag for BRPNT to take as an argument

 JSR BPRNT              \ Print the amount of cash to 9 digits with a decimal
                        \ point

 LDX XX13               \ Fetch the loop counter from XX13

 INX                    \ Increment the loop counter

 CPX QQ25               \ Loop back to n_bloop until we have shown the first
 BCC n_bloop            \ QQ25 ship types (ordered by price)

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the three bottom rows

 LDA #185               \ Print recursive token 25 ("SHIP") followed by a
 JSR prq                \ question mark

 JSR gnum               \ Call gnum to get a number from the keyboard, which
                        \ will be the menu item number of the ship we want to
                        \ buy, returning the number entered in A and R, and
                        \ setting the C flag if the number is bigger than the
                        \ highest menu item number in QQ25

 BEQ jmp_start3         \ If no number was entered, jump to jmp_start3 to make a
                        \ beep and show the cargo bay

 BCS jmp_start3         \ If the number entered was too big, jump to jmp_start3
                        \ to make a beep and show the cargo bay

 SBC #0                 \ Set A = A - 1 (as we know the C flag is clear)

 CMP QQ25               \ If A >= QQ25 then the number entered is bigger than
 BCS jmp_start3         \ the number of entries in the menu, so jump to
                        \ jmp_start3 to make a beep and show the cargo bay

 LDX #2                 \ Move the text cursor to column 2
 STX XC

 INC YC                 \ Move the text cursor down one line

 STA Q                  \ Set INWK to the number of the ship type we want to buy

 LDY cmdr_type          \ Set K(0 1 2 3) to the price of our current ship, whose
 JSR n_price            \ type is in new_type

                        \ We now want to do the following 32-bit addition:
                        \
                        \   XX16(0 1 2 3) = CASH(0 1 2 3) + K(0 1 2 3)
                        \
                        \ so XX16 contains the cash pot after we get a refund
                        \ for the price of our existing ship

 CLC                    \ Clear the C flag for the addition below

 LDX #3                 \ Set a counter in X to loop through the four bytes in
                        \ the addition

.n_addl

 LDA CASH,X             \ Add the X-th bytes of CASH and K and store the result
 ADC K,X                \ in the X-th byte of XX16
 STA XX16,X

 DEX                    \ Decrement the loop counter

 BPL n_addl             \ Loop back until we have added all four bytes

 LDY Q                  \ Fetch the number of the ship type that we want to buy
                        \ into Y

 JSR n_price            \ Set K(0 1 2 3) to the price of the ship we want to buy

                        \ We now want to do the following 32-bit subtraction:
                        \
                        \   K(0 1 2 3) = XX16(0 1 2 3) - K(0 1 2 3)
                        \
                        \ so K(0 1 2 3) contains the cash we have left after we
                        \ buy our new ship

 SEC                    \ Set the C flag for the subtraction below

 LDX #3                 \ Set a counter in X to loop through the four bytes in
                        \ the subtraction

.n_subl

 LDA XX16,X             \ Subtract the X-th byte of K from the X-th byte of XX16
 SBC K,X                \ and store the result in the X-th byte of K
 STA K,X

 DEX                    \ Decrement the loop counter

 BPL n_subl             \ Loop back until we have subtracted all four bytes

 LDA Q                  \ Fetch the number of the ship type that we just bought
                        \ into A

 BCS n_buy              \ If the subtraction didn't underflow, then we have
                        \ enough cash after the refund to buy the ship, so jump
                        \ to n_buy to skip the following

.cash_query

 LDA #197               \ We don't have enough cash to buy this ship, so print
 JSR prq                \ recursive token 37 ("CASH") followed by a question
                        \ mark

.jmp_start3

 JSR dn2                \ Call dn2 to make a short, high beep and delay for 1
                        \ second

 JMP BAY                \ Jump to BAY to go to the docking bay (i.e. show the
                        \ Status Mode screen)

.n_buy

 TAX                    \ Store the number of the ship type that we just bought
                        \ in X

 LDY #3                 \ As the transaction has gone through, we now update our
                        \ cash levels in CASH(0 1 2 3) to the amount we have
                        \ left after buying our new ship, which is in K(0 1 2 3)

.n_cpyl

 LDA K,Y                \ Copy the Y-th byte of K(0 1 2 3) to the Y-th byte of
 STA CASH,Y             \ CASH(0 1 2 3)

 DEY                    \ Decrement the loop counter

 BPL n_cpyl             \ Loop back until we have copied all four bytes

                        \ Next we want to reset the current ship's equipment, so
                        \ we start with nothing and don't carry anything over
                        \ from our previous ship, and we also want to reset
                        \ any special cargo missions, as well as our legal
                        \ status (so buying a new ship is a good way to get the
                        \ law off our backs)

 LDA #0                 \ Set A = 0 so we can use it to zero the settings

 LDY #36                \ We want to zero everything from LASER (the start of
                        \ our current ship's equipment table) to LASER+36 (our
                        \ legal status in FIST), so set Y as an index, starting
                        \ at 36

.n_wipe

 STA LASER,Y            \ Zero the Y-th byte of the block starting with LASER

 DEY                    \ Decrement the index

 BPL n_wipe             \ Loop back until we have zeroed from LASER+36 down to
                        \ LASER+0

 STX cmdr_type          \ Store the type of ship we just bought in cmdr_type, to
                        \ set our current ship type to our new purchase

 JSR n_load             \ Call n_load to load the flight characteristics and set
                        \ the name token for our new ship

 LDA new_range          \ Set our fuel level in QQ14 to the hyperspace range of
 STA QQ14               \ of our new ship, so our new ship comes with a full
                        \ tank

 JSR msblob             \ Reset the dashboard's missile indicators so they show
                        \ the correct number of missiles fitted to our new ship
                        \ (which will be zero)

IF _ELITE_A_6502SP_PARA

 JSR update_pod         \ Update the dashboard colours to reflect whether we
                        \ have an escape pod fitted to our new ship (which we
                        \ don't)

ENDIF

 JMP BAY                \ Jump to BAY to go to the docking bay (i.e. show the
                        \ Status Mode screen)

