\ ******************************************************************************
\
\       Name: equip_data
\       Type: Subroutine
\   Category: Encyclopedia
\    Summary: Show the Equipment menu and display the chosen page
\
\ ******************************************************************************

.equip_data

 LDX #4                 \ Call menu with X = 4 to show menu 4, the Equipment
 JSR menu               \ menu, and return the choice in A, so A is now:
                        \
                        \   *  1 = Missiles
                        \   *  2 = I.F.F. system
                        \   *  3 = E.C.M. system
                        \   *  4 = Pulse lasers
                        \   *  5 = Beam lasers
                        \   *  6 = Fuel scoops
                        \   *  7 = Escape pod
                        \   *  8 = Hyperspace unit
                        \   *  9 = Energy unit
                        \   * 10 = Docking computers
                        \   * 11 = Galactic hyperdrive
                        \   * 12 = Military lasers
                        \   * 13 = Mining lasers

 ADC #107               \ Store the choice + 107 on the stack, to give the token
 PHA                    \ number of the body to show for the relevant choice,
                        \ from missiles (token 108) to mining lasers (token 120)

 SBC #12                \ Store the choice + 94 on the stack, to give the token
 PHA                    \ number of the title to show for the relevant choice,
                        \ from missiles (token 95) to mining lasers (token 107)

 LDA #32                \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 32

 JSR MT1                \ Switch to ALL CAPS when printing extended tokens

 LDA #11                \ Move the text cursor to column 11
 STA XC

 PLA                    \ Pull the token number for the title from the stack
 JSR write_msg3         \ (choice + 95) and print it

 JSR NLIN4              \ Draw a horizontal line at pixel row 19 to box in the
                        \ title

 JSR MT2                \ Switch to Sentence Case when printing extended tokens
                        \ (though this gets overridden by the following
                        \ instruction, so this has no effect)

 JSR MT13               \ Switch to lower case when printing extended tokens, so
                        \ the text is shown in justified paragraphs of lower
                        \ case text

 INC YC                 \ Move the text cursor down two lines
 INC YC

 LDA #1                 \ Move the text cursor to column 1
 STA XC

 PLA                    \ Pull the token number for the body from the stack
 JSR write_msg3         \ (choice + 107) and print it

 JMP l_restart          \ Jump to l_restart to wait until a key is pressed and
                        \ show the Encyclopedia screen

