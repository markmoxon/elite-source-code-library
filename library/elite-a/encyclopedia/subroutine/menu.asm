\ ******************************************************************************
\
\       Name: menu
\       Type: Subroutine
\   Category: Encyclopedia
\    Summary: Display a menu and ask for a choice
\  Deep dive: The Encyclopedia Galactica
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of the menu to display (0 to 4)
\
\ Returns:
\
\   A                   The number entered
\
\   R                   Also contains the number entered
\
\   C flag              Set if the number is too large, clear otherwise
\
\ ******************************************************************************

.menu

 LDA menu_entry,X       \ Store the menu's size (i.e. the number of entries) in
 STA QQ25               \ QQ25

 LDA menu_offset,X      \ Store the token number of the menu's first item in
 STA QQ29               \ QQ29

 LDA menu_query,X       \ Store the menu's query token number on the stack,
 PHA                    \ which contains the query prompt we show at the bottom
                        \ of the menu

 LDA menu_title,X       \ Store the menu's title token number on the stack
 PHA

 LDA menu_titlex,X      \ Store the menu's title x-coordinate on the stack
 PHA

 LDA #32                \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 32

 JSR MT1                \ Switch to ALL CAPS when printing extended tokens

 PLA                    \ Retrieve the menu's title x-coordinate from the stack
 STA XC                 \ and move the text cursor to it

 PLA                    \ Retrieve the menu's title token number from the stack
 JSR write_msg3         \ and print it (the menu tokens are in the msg_3 table)

 JSR NLIN4              \ Draw a horizontal line at pixel row 19 to box in the
                        \ title

IF _ELITE_A_ENCYCLOPEDIA

 JSR MT2                \ Switch to Sentence Case when printing extended tokens

 LDA #%10000000         \ Set bit 7 of QQ17 to switch standard tokens to
 STA QQ17               \ Sentence Case

ENDIF

 INC YC                 \ Move the text cursor down a line

 LDX #0                 \ We are now going to work our way through the items in
                        \ the menu, printing as we go, so set a counter in X to
                        \ hold the number of the current item (starting from 0)

.menu_loop

 STX XX13               \ Store the current menu item number in XX13

 JSR TT67               \ Print a newline

 LDX XX13               \ Print the current item number + 1 to 3 digits, left-
 INX                    \ padding with spaces, and with no decimal point, so the
 CLC                    \ items are numbered from 1
 JSR pr2

 JSR TT162              \ Print a space

IF _ELITE_A_6502SP_PARA

 JSR MT2                \ Switch to Sentence Case when printing extended tokens

 LDA #%10000000         \ Set bit 7 of QQ17 to switch standard tokens to
 STA QQ17               \ Sentence Case

ENDIF

 CLC                    \ Set A = XX13 + QQ29
 LDA XX13               \
 ADC QQ29               \ This will contain the token number for the first entry
                        \ in this menu, as QQ29 contains the number of the first
                        \ token in this menu, and XX13 contains the number of
                        \ this entry within the menu

 JSR write_msg3         \ Print the extended token for this menu item (the menu
                        \ tokens are in the msg_3 table)

 LDX XX13               \ Fetch the menu item number from XX13

 INX                    \ Increment the menu item number to point to the next
                        \ item

 CPX QQ25               \ Loop back to menu_loop until we have shown all QQ25
 BCC menu_loop          \ menu items

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the three bottom rows

 PLA                    \ Retrieve the menu's query token number from the stack
 JSR write_msg3         \ and print it

 LDA #'?'               \ Print a question mark
 JSR DASC

 JSR gnum               \ Call gnum to get a number from the keyboard, which
                        \ will be the menu item number of the menu item we want
                        \ to show, returning the number entered in A and R, and
                        \ setting the C flag if the number is bigger than the
                        \ highest menu item number in QQ25

 BEQ menu_start         \ If no number was entered, jump to menu_start to show
                        \ the cargo bay

 BCS menu_start         \ If the number entered was too big, jump to menu_start
                        \ show the cargo bay

 RTS                    \ Return from the subroutine

.menu_start

 JMP BAY                \ Jump to BAY to go to the docking bay (i.e. show the
                        \ Encyclopedia screen)

