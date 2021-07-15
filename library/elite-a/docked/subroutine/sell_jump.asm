\ ******************************************************************************
\
\       Name: sell_jump
\       Type: Subroutine
\   Category: Equipment
\    Summary: Show the Sell Equipment screen (CTRL-f2)
\
\ ******************************************************************************

.sell_jump

 INC XC                 \ Move the text cursor down one line

 LDA #207               \ Print recursive token 47 ("EQUIP") and draw a
 JSR NLIN3              \ horizontal line at pixel row 19 to box in the title

 JSR TT69               \ Call TT69 to set Sentence Case and print a newline

 JSR TT67               \ Print a newline

 JSR sell_equip         \ Call sell_equip to show the Sell Equipment screen,
                        \ which will run through all the equipment apart from
                        \ the escape pod

 LDA ESCP               \ If we do not have an escape pod fitted, in which case
 BEQ sell_escape        \ ESCP will be 0, jump to sell_escape

 LDA #112               \ We do have an E.C.M. fitted, so print recursive token
 LDX #30                \ 112 ("ESCAPE POD"), and as this is the Sell Equipment
 JSR status_equip       \ screen, show and process a sell prompt for the piece of
                        \ equipment at LASER+X = LASER+30 = ESCP before printing
                        \ a newline

.sell_escape

 JMP BAY                \ Go to the docking bay (i.e. show the Status Mode
                        \ screen) and return from the subroutine with a tail
                        \ call

