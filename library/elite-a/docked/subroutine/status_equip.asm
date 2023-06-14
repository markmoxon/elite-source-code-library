\ ******************************************************************************
\
\       Name: status_equip
\       Type: Subroutine
\   Category: Text
\    Summary: Print equipment name, adding a sell prompt if appropriate
\
\ ------------------------------------------------------------------------------
\
\ Print a text token containing the equipment name. Then:
\
\   * If this is the Status Mode or Inventory screen, print a newline and move
\     the text cursor to column 8
\
\   * If this is the Sell Equipment screen, show and process a "Sell(Y/N)?"
\     prompt on the end of the same line as the equipment name, and move the
\     text cursor to the start of the next line
\
\ Arguments:
\
\   A                   The text token to be printed
\
\   X                   If this is the Sell Equipment screen, this contains the
\                       offset from LASER where this piece of equipment's flag
\                       is stored (e.g. X = 25 means LASER+25, which is BST,
\                       the flag for the fuel scoops)
\
\ ******************************************************************************

.status_equip

 STX CNT                \ Store the tab indent in CNT, so we can use it later

 STA XX4                \ Store the text token in XX4, so we can use it later

 JSR TT27               \ Print the text token in A

 LDX QQ11               \ If the current view is the Status Mode screen or the
 CPX #8                 \ Inventory screen, jump to status_keep to print a tab
 BEQ status_keep        \ to column 8 (as X = 8) and return from the subroutine,
                        \ as we don't want to show a sell prompt

 LDA #21                \ Move the text cursor to column 21
 STA XC

 JSR vdu_80             \ Call vdu_80 to switch to Sentence Case, with the next
                        \ letter in capitals

 LDA #1                 \ Set QQ25 to 1, which sets the maximum number of items
 STA QQ25               \ we can sell in the following call to sell_yn

 JSR sell_yn            \ Call sell_yn to print a "Sell(Y/N)?" prompt and get a
                        \ number from the keyboard

 BEQ status_no          \ If no number was entered, jump to status_no to move to
                        \ the next line and return from the subroutine

 BCS status_no          \ If the number entered was too big, jump to status_no
                        \ to move to the next line and return from the
                        \ subroutine

 LDA XX4                \ If XX4 >= 107, then the token is a piece of equipment
 CMP #107               \ ("I.F.F.SYSTEM" onwards) rather a laser, so skip the
 BCS status_over        \ following instruction to reach status_over with
                        \ A >= 107 and the C flag set

 ADC #7                 \ The token in A is < 107, so it must be a pulse laser
                        \ (103) or beam laser (104), so add 7 to set A to 110
                        \ or 111 (as we know the C flag is clear), and fall
                        \ through into status_over with the C flag clear

.status_over

                        \ We get here with one of the following:
                        \
                        \   * A >= 107 and the C flag set, if this is not a
                        \     pulse or beam laser
                        \
                        \   * A = 110 or 111 with the C flag clear, if this is a
                        \     pulse or beam laser

 SBC #104               \ Subtract 104 - (1 - C) from the token number, so
                        \ either:
                        \
                        \   * A is now 1 for fuel, 2 for missiles, 3 for the
                        \     I.F.F. system, and so on
                        \
                        \   * A = 5 or 6 for pulse or beam lasers
                        \
                        \ In each case, A contains the equipment number from the
                        \ PRXS table, plus 1

 JSR prx-3              \ Call prx-3 to set (A X) to the price of the item with
                        \ number A - 1

 LSR A                  \ We now halve the price in (A X) and put the result
 TAY                    \ into (Y X), starting with the high byte in A

 TXA                    \ And then halving the low byte in X
 ROR A
 TAX

 JSR MCASH              \ Call MCASH to add (Y X) to the cash pot, so we get
                        \ half of the original price back when selling equipment

 INC new_hold           \ We just sold a piece of equipment, so increment the
                        \ amount of free space in the hold

 LDX CNT                \ Set X to the value we stored in CNT above, so it now
                        \ contains the equipment flag's offset from LASER

 LDA #0                 \ We just sold this piece of equipment, so set the flag
 STA LASER,X            \ to zero to indicate we no longer have the equipment
                        \ fitted

IF _ELITE_A_6502SP_PARA

 JSR update_pod         \ Update the dashboard colours to reflect whether we
                        \ have an escape pod

ENDIF

.status_no

 LDX #1                 \ Set X = 1 so we move the text cursor to column 1 in
                        \ in the next instruction

.status_keep

 STX XC                 \ Move the text cursor to the column specified in X

 LDA #10                \ Print a line feed to move the text cursor down a line
 JMP TT27               \ and return from the subroutine using a tail call

