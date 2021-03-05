\ ******************************************************************************
\
\       Name: EQSHP
\       Type: Subroutine
\   Category: Equipment
\    Summary: Show the Equip Ship screen (red key f3)
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   err                 Beep, pause and go to the docking bay (i.e. show the
\                       Status Mode screen)
\
\ ******************************************************************************

.bay

 JMP BAY                \ Go to the docking bay (i.e. show the Status Mode
                        \ screen)

.EQSHP

IF _CASSETTE_VERSION \ Platform

 JSR DIALS              \ Call DIALS to update the dashboard

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Advanced: In the 6502SP version, you can send the Equip Ship screen to the printer by pressing SHIFT-f3

 LDA #32                \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 32 (Equip
                        \ Ship screen)

ELIF _6502SP_VERSION

 LDA #32                \ Clear the top part of the screen, draw a white border,
 JSR TRADEMODE          \ and set up a printable trading screen with a view type
                        \ in QQ11 of 32 (Equip Ship screen)

ENDIF

IF _DISC_DOCKED \ Platform

 JSR FLKB               \ Flush the keyboard buffer

ENDIF

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Tube

 LDA #12                \ Move the text cursor to column 12
 STA XC

ELIF _6502SP_VERSION

 LDA #12                \ Move the text cursor to column 12
 JSR DOXC

ENDIF

 LDA #207               \ Print recursive token 47 ("EQUIP") followed by a space
 JSR spc

 LDA #185               \ Print recursive token 25 ("SHIP") and draw a
 JSR NLIN3              \ horizontal line at pixel row 19 to box in the title

 LDA #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case, with the
 STA QQ17               \ next letter in capitals

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Tube

 INC YC                 \ Move the text cursor down one line

ELIF _6502SP_VERSION

 JSR INCYC              \ Move the text cursor down one line

ENDIF

 LDA tek                \ Fetch the tech level of the current system from tek
 CLC                    \ and add 3 (the tech level is stored as 0-14, so A is
 ADC #3                 \ now set to between 3 and 17)

IF _CASSETTE_VERSION \ Enhanced: There are 14 types of equipment in the enhanced version, as opposed to 12 in the cassette version

 CMP #12                \ If A >= 12 then set A = 12, so A is now set to between
 BCC P%+4               \ 3 and 12
 LDA #12

ELIF _6502SP_VERSION OR _DISC_DOCKED

 CMP #12                \ If A >= 12 then set A = 14, so A is now set to between
 BCC P%+4               \ 3 and 14
 LDA #14

ENDIF

 STA Q                  \ Set QQ25 = A (so QQ25 is in the range 3-12 and
 STA QQ25               \ represents number of the most advanced item available
 INC Q                  \ in this system, which we can pass to gnum below when
                        \ asking which item we want to buy)
                        \
                        \ Set Q = A + 1 (so Q is in the range 4-13 and contains
                        \ QQ25 + 1, i.e. the highest item number on sale + 1)

 LDA #70                \ Set A = 70 - QQ14, where QQ14 contains the current
 SEC                    \ level in light years * 10, so this leaves the amount
 SBC QQ14               \ of fuel we need to fill 'er up (in light years * 10)

 ASL A                  \ The price of fuel is always 2 Cr per light year, so we
 STA PRXS               \ double A and store it in PRXS, as the first price in
                        \ the price list (which is reserved for fuel), and
                        \ because the table contains prices as price * 10, it's
                        \ in the right format (so a full tank, or 7.0 light
                        \ years, would be 14.0 Cr, or a PRXS value of 140)

 LDX #1                 \ We are now going to work our way through the equipment
                        \ price list at PRXS, printing out the equipment that is
                        \ available at this station, so set a counter in X,
                        \ starting at 1, to hold the number of the current item
                        \ plus 1 (so the item number in X loops through 1-13)

.EQL1

 STX XX13               \ Store the current item number + 1 in XX13

 JSR TT67               \ Print a newline

 LDX XX13               \ Print the current item number + 1 to 3 digits, left-
 CLC                    \ padding with spaces, and with no decimal point, so the
 JSR pr2                \ items are numbered from 1

 JSR TT162              \ Print a space

 LDA XX13               \ Print recursive token 104 + XX13, which will be in the
 CLC                    \ range 105 ("FUEL") to 116 ("GALACTIC HYPERSPACE ")
 ADC #104               \ so this prints the current item's name
 JSR TT27

 LDA XX13               \ Call prx-3 to set (Y X) to the price of the item with
 JSR prx-3              \ number XX13 - 1 (as XX13 contains the item number + 1)

 SEC                    \ Set the C flag so we will print a decimal point when
                        \ we print the price

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Tube

 LDA #25                \ Move the text cursor to column 25
 STA XC

ELIF _6502SP_VERSION

 LDA #25                \ Move the text cursor to column 25
 JSR DOXC

ENDIF

 LDA #6                 \ Print the number in (Y X) to 6 digits, left-padding
 JSR TT11               \ with spaces and including a decimal point, which will
                        \ be the correct price for this item as (Y X) contains
                        \ the price * 10, so the trailing zero will go after the
                        \ decimal point (i.e. 5250 will be printed as 525.0)

 LDX XX13               \ Increment the current item number in XX13
 INX

 CPX Q                  \ If X < Q, loop back up to print the next item on the
 BCC EQL1               \ list of equipment available at this station

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the three bottom rows

 LDA #127               \ Print recursive token 127 ("ITEM") followed by a
 JSR prq                \ question mark

 JSR gnum               \ Call gnum to get a number from the keyboard, which
                        \ will be the number of the item we want to purchase,
                        \ returning the number entered in A and R, and setting
                        \ the C flag if the number is bigger than the highest
                        \ item number in QQ25

 BEQ bay                \ If no number was entered, jump up to bay to go to the
                        \ docking bay (i.e. show the Status Mode screen)

 BCS bay                \ If the number entered was too big, jump up to bay to
                        \ go to the docking bay (i.e. show the Status Mode
                        \ screen)

 SBC #0                 \ Set A to the number entered - 1 (because the C flag is
                        \ clear), which will be the actual item number we want
                        \ to buy

IF _CASSETTE_VERSION OR _DISC_DOCKED \ Tube

 LDX #2                 \ Move the text cursor to column 2
 STX XC

 INC YC                 \ Move the text cursor down one line

ELIF _6502SP_VERSION

 PHA                    \ Store A on the stack so we can restore it after the
                        \ following call to DOXC

 LDA #2                 \ Move the text cursor to column 2
 JSR DOXC

 JSR INCYC              \ Move the text cursor down one line

 PLA                    \ Restore A from the stack

ENDIF

 PHA                    \ While preserving the value in A, call eq to subtract
 JSR eq                 \ the price of the item we want to buy (which is in A)
 PLA                    \ from our cash pot, but only if we have enough cash in
                        \ the pot. If we don't have enough cash, exit to the
                        \ docking bay (i.e. show the Status Mode screen)

 BNE et0                \ If A is not 0 (i.e. the item we've just bought is not
                        \ fuel), skip to et0

IF _CASSETTE_VERSION \ Other: The cassette version resets the MCNT main loop counter when we refuel, which the other versions don't. I don't know why it would do this - perhaps it's a remnant of some other code that was cleared out in later versions?

 STA MCNT               \ We just bought fuel, so we zero the main loop counter

ENDIF

 LDX #70                \ And set the current fuel level * 10 in QQ14 to 70, or
 STX QQ14               \ 7.0 light years (a full tank)

.et0

 CMP #1                 \ If A is not 1 (i.e. the item we've just bought is not
 BNE et1                \ a missile), skip to et1

 LDX NOMSL              \ Fetch the current number of missiles from NOMSL into X

 INX                    \ Increment X to the new number of missiles

IF _CASSETTE_VERSION \ Minor

 LDY #117               \ Set Y to recursive token 117 ("ALL")

ELIF _6502SP_VERSION OR _DISC_DOCKED

 LDY #124               \ Set Y to recursive token 124 ("ALL")

ENDIF

 CPX #5                 \ If buying this missile would give us 5 missiles, this
 BCS pres               \ is more than the maximum of 4 missiles that we can
                        \ fit, so jump to pres to show the error "All Present",
                        \ beep and exit to the docking bay (i.e. show the Status
                        \ Mode screen)

 STX NOMSL              \ Otherwise update the number of missiles in NOMSL

 JSR msblob             \ Reset the dashboard's missile indicators so none of
                        \ them are targeted

IF _6502SP_VERSION \ Platform: The MSBAR routine that msblob calls corrupts the A register in the 6502SP version, so we need to reset it

 LDA #1                 \ Set A to 1 as the call to msblob will have overwritten
                        \ the original value, and we still need it set
                        \ correctly so we can continue through the conditional
                        \ statements for all the other equipment

ENDIF

.et1

 LDY #107               \ Set Y to recursive token 107 ("LARGE CARGO{sentence
                        \ case} BAY")

 CMP #2                 \ If A is not 2 (i.e. the item we've just bought is not
 BNE et2                \ a large cargo bay), skip to et2

 LDX #37                \ If our current cargo capacity in CRGO is 37, then we
 CPX CRGO               \ already have a large cargo bay fitted, so jump to pres
 BEQ pres               \ to show the error "Large Cargo Bay Present", beep and
                        \ exit to the docking bay (i.e. show the Status Mode
                        \ screen)

 STX CRGO               \ Otherwise we just scored ourselves a large cargo bay,
                        \ so update our current cargo capacity in CRGO to 37

.et2

 CMP #3                 \ If A is not 3 (i.e. the item we've just bought is not
 BNE et3                \ an E.C.M. system), skip to et3

 INY                    \ Increment Y to recursive token 108 ("E.C.M.SYSTEM")

 LDX ECM                \ If we already have an E.C.M. fitted (i.e. ECM is
 BNE pres               \ non-zero), jump to pres to show the error "E.C.M.
                        \ System Present", beep and exit to the docking bay
                        \ (i.e. show the Status Mode screen)

 DEC ECM                \ Otherwise we just took delivery of a brand new E.C.M.
                        \ system, so set ECM to &FF (as ECM was 0 before the DEC
                        \ instruction)

.et3

 CMP #4                 \ If A is not 4 (i.e. the item we've just bought is not
 BNE et4                \ an extra pulse laser), skip to et4

 JSR qv                 \ Print a menu listing the four views, with a "View ?"
                        \ prompt, and ask for a view number, which is returned
                        \ in X (which now contains 0-3)

IF _CASSETTE_VERSION \ Enhanced: The enhanced versions have two extra types of laser: Mining and Military

 LDA #4                 \ This instruction doesn't appear to do anything, as we
                        \ either don't need it (if we already have this laser)
                        \ or we set A to 4 below (if we buy it)

 LDY LASER,X            \ If there is no laser mounted in the chosen view (i.e.
 BEQ ed4                \ LASER+X, which contains the laser power for view X, is
                        \ zero), jump to ed4 to buy a pulse laser

.ed7

 LDY #187               \ Otherwise we already have a laser mounted in this
 BNE pres               \ view, so jump to pres with Y set to token 27
                        \ (" LASER") to show the error "Laser Present", beep
                        \ and exit to the docking bay (i.e. show the Status
                        \ Mode screen)

.ed4

 LDA #POW               \ We just bought a pulse laser for view X, so we need
 STA LASER,X            \ to fit it by storing the laser power for a pulse laser
                        \ (given in POW) in LASER+X

ELIF _6502SP_VERSION OR _DISC_DOCKED

 LDA #POW               \ Call refund with A set to the power of the new pulse
 JSR refund             \ laser to install the new laser and process a refund if
                        \ we already have a laser fitted to this view

ENDIF

 LDA #4                 \ Set A to 4 as we just overwrote the original value,
                        \ and we still need it set correctly so we can continue
                        \ through the conditional statements for all the other
                        \ equipment

.et4

 CMP #5                 \ If A is not 5 (i.e. the item we've just bought is not
 BNE et5                \ an extra beam laser), skip to et5

 JSR qv                 \ Print a menu listing the four views, with a "View ?"
                        \ prompt, and ask for a view number, which is returned
                        \ in X (which now contains 0-3)

IF _CASSETTE_VERSION \ Platform: The refund code has been moved to the refund routine in the enhanced versions

 STX T1                 \ Store the view in T1 so we can retrieve it below

 LDA #5                 \ Set A to 5 as the call to qv will have overwritten
                        \ the original value, and we still need it set
                        \ correctly so we can continue through the conditional
                        \ statements for all the other equipment

 LDY LASER,X            \ If there is no laser mounted in the chosen view (i.e.
 BEQ ed5                \ LASER+X, which contains the laser power for view X,
                        \ is zero), jump to ed5 to buy a beam laser

\BPL P%+4               \ This instruction is commented out in the original
                        \ source, though it would have no effect (it would
                        \ simply skip the BMI if A is positive, which is what
                        \ BMI does anyway)

 BMI ed7                \ If there is a beam laser already mounted in the chosen
                        \ view (i.e. LASER+X has bit 7 set, which indicates a
                        \ beam laser rather than a pulse laser), skip back to
                        \ ed7 to print a "Laser Present" error, beep and exit
                        \ to the docking bay (i.e. show the Status Mode screen)

 LDA #4                 \ If we get here then we already have a pulse laser in
 JSR prx                \ the selected view, so we call prx to set (Y X) to the
                        \ price of equipment item number 4 (extra pulse laser)
                        \ so we can give a refund of the pulse laser

 JSR MCASH              \ Add (Y X) cash to the cash pot in CASH, so we refund
                        \ the price of the pulse laser we are exchanging for a
                        \ new beam laser

.ed5

 LDA #POW+128           \ We just bought a beam laser for view X, so we need
 LDX T1                 \ to fit it by storing the laser power for a beam laser
 STA LASER,X            \ (given in POW+128) in LASER+X, using the view number
                        \ we stored in T1 earlier, as the call to prx will have
                        \ overwritten the original value in X

ELIF _6502SP_VERSION OR _DISC_DOCKED

 LDA #POW+128           \ Call refund with A set to the power of the new beam
 JSR refund             \ laser to install the new laser and process a refund if
                        \ we already have a laser fitted to this view

ENDIF

.et5

 LDY #111               \ Set Y to recursive token 107 ("FUEL SCOOPS")

 CMP #6                 \ If A is not 6 (i.e. the item we've just bought is not
 BNE et6                \ a fuel scoop), skip to et6

 LDX BST                \ If we already have fuel scoops fitted (i.e. BST is
 BEQ ed9                \ zero), jump to ed9, otherwise fall through into pres
                        \ to show the error "Fuel Scoops Present", beep and
                        \ exit to the docking bay (i.e. show the Status Mode
                        \ screen)

.pres

                        \ If we get here we need to show an error to say that
                        \ item number A is already present, where the item's
                        \ name is recursive token Y

 STY K                  \ Store the item's name in K

 JSR prx                \ Call prx to set (Y X) to the price of equipment item
                        \ number A

 JSR MCASH              \ Add (Y X) cash to the cash pot in CASH, as the station
                        \ already took the money for this item in the JSR eq
                        \ instruction above, but we can't fit the item, so need
                        \ our money back

 LDA K                  \ Print the recursive token in K (the item's name)
 JSR spc                \ followed by a space

 LDA #31                \ Print recursive token 145 ("PRESENT")
 JSR TT27

.err

 JSR dn2                \ Call dn2 to make a short, high beep and delay for 1
                        \ second

 JMP BAY                \ Jump to BAY to go to the docking bay (i.e. show the
                        \ Status Mode screen)

.ed9

 DEC BST                \ We just bought a shiny new fuel scoop, so set BST to
                        \ &FF (as BST was 0 before the jump to ed9 above)

.et6

 INY                    \ Increment Y to recursive token 112 ("E.C.M.SYSTEM")

 CMP #7                 \ If A is not 7 (i.e. the item we've just bought is not
 BNE et7                \ an escape pod), skip to et7

 LDX ESCP               \ If we already have an escape pod fitted (i.e. ESCP is
 BNE pres               \ non-zero), jump to pres to show the error "Escape Pod
                        \ Present", beep and exit to the docking bay (i.e. show
                        \ the Status Mode screen)

 DEC ESCP               \ Otherwise we just bought an escape pod, so set ESCP
                        \ to &FF (as ESCP was 0 before the DEC instruction)

.et7

 INY                    \ Increment Y to recursive token 113 ("ENERGY BOMB")

 CMP #8                 \ If A is not 8 (i.e. the item we've just bought is not
 BNE et8                \ an energy bomb), skip to et8

 LDX BOMB               \ If we already have an energy bomb fitted (i.e. BOMB
 BNE pres               \ is non-zero), jump to pres to show the error "Energy
                        \ Bomb Present", beep and exit to the docking bay (i.e.
                        \ show the Status Mode screen)

 LDX #&7F               \ Otherwise we just bought an energy bomb, so set BOMB
 STX BOMB               \ to &7F

.et8

 INY                    \ Increment Y to recursive token 114 ("ENERGY UNIT")

 CMP #9                 \ If A is not 9 (i.e. the item we've just bought is not
 BNE etA                \ an energy unit), skip to etA

 LDX ENGY               \ If we already have an energy unit fitted (i.e. ENGY is
 BNE pres               \ non-zero), jump to pres to show the error "Energy Unit
                        \ Present", beep and exit to the docking bay (i.e. show
                        \ the Status Mode screen)

 INC ENGY               \ Otherwise we just picked up an energy unit, so set
                        \ ENGY to 1 (as ENGY was 0 before the INC instruction)

.etA

 INY                    \ Increment Y to recursive token 115 ("DOCKING
                        \ COMPUTERS")

 CMP #10                \ If A is not 10 (i.e. the item we've just bought is not
 BNE etB                \ a docking computer), skip to etB

 LDX DKCMP              \ If we already have a docking computer fitted (i.e.
 BNE pres               \ DKCMP is non-zero), jump to pres to show the error
                        \ "Docking Computer Present", beep and exit to the
                        \ docking bay (i.e. show the Status Mode screen)

 DEC DKCMP              \ Otherwise we just got hold of a docking computer, so
                        \ set DKCMP to &FF (as DKCMP was 0 before the DEC
                        \ instruction)

.etB

 INY                    \ Increment Y to recursive token 116 ("GALACTIC
                        \ HYPERSPACE ")

 CMP #11                \ If A is not 11 (i.e. the item we've just bought is not
 BNE et9                \ a galactic hyperdrive), skip to et9

 LDX GHYP               \ If we already have a galactic hyperdrive fitted (i.e.
 BNE pres               \ GHYP is non-zero), jump to pres to show the error
                        \ "Galactic Hyperspace Present", beep and exit to the
                        \ docking bay (i.e. show the Status Mode screen)

 DEC GHYP               \ Otherwise we just splashed out on a galactic
                        \ hyperdrive, so set GHYP to &FF (as GHYP was 0 before
                        \ the DEC instruction)

.et9

IF _6502SP_VERSION OR _DISC_DOCKED \ Enhanced: Mining and Military lasers can be fitted to any views in the Equip Ship screen

 INY                    \ Increment Y to recursive token 117 ("MILITARY  LASER")

 CMP #12                \ If A is not 12 (i.e. the item we've just bought is not
 BNE et10               \ a military laser), skip to et10

 JSR qv                 \ Print a menu listing the four views, with a "View ?"
                        \ prompt, and ask for a view number, which is returned
                        \ in X (which now contains 0-3)

 LDA #Armlas            \ Call refund with A set to the power of the new
 JSR refund             \ military laser to install the new laser and process a
                        \ refund if we already have a laser fitted to this view

.et10

 INY                    \ Increment Y to recursive token 118 ("MINING  LASER")

 CMP #13                \ If A is not 13 (i.e. the item we've just bought is not
 BNE et11               \ a mining laser), skip to et11

 JSR qv                 \ Print a menu listing the four views, with a "View ?"
                        \ prompt, and ask for a view number, which is returned
                        \ in X (which now contains 0-3)

 LDA #Mlas              \ Call refund with A set to the power of the new mining
 JSR refund             \ laser to install the new laser and process a refund if
                        \ we already have a laser fitted to this view

.et11

ENDIF

 JSR dn                 \ We are done buying equipment, so print the amount of
                        \ cash left in the cash pot, then make a short, high
                        \ beep to confirm the purchase, and delay for 1 second

 JMP EQSHP              \ Jump back up to EQSHP to show the Equip Ship screen
                        \ again and see if we can't track down another bargain

