\ ******************************************************************************
\
\       Name: controls
\       Type: Subroutine
\   Category: Encyclopedia
\    Summary: Show the Controls menu and display the chosen page
\  Deep dive: The Encyclopedia Galactica
\
\ ******************************************************************************

.controls

 LDX #3                 \ Call menu with X = 3 to show menu 3, the Controls
 JSR menu               \ menu, and return the choice in A, so A is now:
                        \
                        \   * 1 = Flight
                        \   * 2 = Combat
                        \   * 3 = Navigation
                        \   * 4 = Trading

 ADC #86                \ Store the choice + 86 on the stack, to give the token
 PHA                    \ number of the body to show for the relevant choice,
                        \ from flight controls (token 87) to trading controls
                        \ (token 90)

 ADC #4                 \ Store the choice + 90 on the stack, to give the token
 PHA                    \ number of the title to show for the relevant choice,
                        \ from flight controls (token 91) to trading controls
                        \ (token 94)

 LDA #32                \ Clear the top part of the screen, draw a border box,
 JSR TT66               \ and set the current view type in QQ11 to 32

 JSR MT1                \ Switch to ALL CAPS when printing extended tokens

 LDA #11                \ Move the text cursor to column 11
 STA XC

 PLA                    \ Pull the token number for the title from the stack
 JSR write_msg3         \ (choice + 90) and print it

 JSR NLIN4              \ Draw a horizontal line at pixel row 19 to box in the
                        \ title

 JSR MT2                \ Switch to Sentence Case when printing extended tokens

 INC YC                 \ Move the text cursor down one line

 PLA                    \ Pull the token number for the body from the stack
 JSR write_msg3         \ (choice + 86) and print it

 JMP l_restart          \ Jump to l_restart to wait until a key is pressed and
                        \ show the Encyclopedia screen

