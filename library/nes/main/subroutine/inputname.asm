\ ******************************************************************************
\
\       Name: InputName
\       Type: Subroutine
\   Category: Controllers
\    Summary: Get a name from the controller for searching the galaxy or
\             changing commander name
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   INWK+5              The current name
\
\   inputNameSize       The maximum size of the name to fetch - 1
\
\ Returns:
\
\   INWK+5              The entered name, terminated by ASCII 13
\
\   C flag              The status of the entered name:
\
\                         * Set = The name is empty
\
\                         * Clear = The name is not empty
\
\ ******************************************************************************

.InputName

 LDY #0                 \ Set an index in Y to point to the letter within the
                        \ name that we are entering, starting with the first
                        \ letter at index 0

                        \ The currently entered name is at INWK+5, so we use
                        \ that to provide the starting point for each letter
                        \ (or we start at "A" if there is no currently entered
                        \ name)

.name1

 LDA INWK+5,Y           \ Fetch the Y-th character of the currently entered
                        \ name at INWK+5

 CMP #'A'               \ If the character is ASCII "A" or greater, jump to
 BCS name2              \ name2 to use this as the starting point for this
                        \ letter

 LDA #'A'               \ Otherwise set A to the letter "A" to use as the
                        \ starting point

.name2

 PHA                    \ These instructions together have no effect
 PLA

 JSR ChangeLetter       \ Call ChangeLetter to allow us to move up or down
                        \ through the alphabet, returning with the letter
                        \ selected in A

 BCS name4              \ If the C flag was set by ChangeLetter then the A
                        \ button was pressed, so jump to name4 to finish the
                        \ process as this means we have finished entering the
                        \ name

                        \ Otherwise we now check whether the chosen character
                        \ is valid

 CMP #27                \ If ChangeLetter returned an ASCII ESC character, jump
 BEQ name5              \ to name5 to return from the subroutine with an empty
                        \ name and the C flag set

 CMP #127               \ If ChangeLetter returned an ASCII DEL character, jump
 BEQ name6              \ to name6 to delete the character to the left

 CPY inputNameSize      \ If Y >= inputNameSize then the entered name is too
 BCS name3              \ long, so jump to name3 to give an error beep and try
                        \ again

 CMP #'!'               \ If A < ASCII "!" then it is a control character, so
 BCC name3              \ jump to name3 to give an error beep and try again

 CMP #'{'               \ If A >= ASCII "{" then it is not a valid character, so
 BCS name3              \ jump to name3 to give an error beep and try again

                        \ If we get here then the chosen character is valid

 STA INWK+5,Y           \ Store the chosen character in the Y-th position in the
                        \ string at INWK+5

 INY                    \ Increment the index in Y to point to the next letter

 INC XC                 \ Move the text cursor to the right by one place

 JMP name1              \ Loop back to name1 to fetch the next letter

.name3

                        \ If we get here then there are too many characters in
                        \ the string, or the entered character is not a valid
                        \ letter

 JSR BEEP_b7            \ Call the BEEP subroutine to make a short, high beep to
                        \ indicate an error

 LDY inputNameSize      \ Set Y to the maximum length of the string, so when we
                        \ loop back to name1, we ask for the last letter again

 JMP name1              \ Loop back to name1 to fetch the next letter

.name4

                        \ If we get here then we have finished entering the name

 STA INWK+5,Y           \ Store the chosen character in the Y-th position in the
                        \ string at INWK+5

 INY                    \ Increment the index in Y to point to the next letter

 LDA #13                \ Store the string terminator in the next letter, so the
 STA INWK+5,Y           \ entered string is terminated properly

 LDA #12                \ Print a newline
 JSR CHPR_b2

 JSR DrawMessageInNMI   \ Configure the NMI to display the message that we just
                        \ printed

 CLC                    \ Clear the C flag to indicate that a name has
                        \ successfully been entered

 RTS                    \ Return from the subroutine

.name5

 LDA #13                \ Store the string terminator in the first letter, so
 STA INWK+5             \ the returned string is empty

 SEC                    \ Set the C flag to indicate that a valid name has not
                        \ been entered

 RTS                    \ Return from the subroutine

.name6

                        \ If we get here then we need to delete the character to
                        \ the left of the current letter

 TYA                    \ If Y = 0 then we are still on the first letter, so
 BEQ name7              \ jump to name7 to given an error beep, as we can't
                        \ delete past the start of the name

 DEY                    \ Decrement the length of the current name in Y, so the
                        \ next character we enter replaces the one we are
                        \ deleting

 LDA #127               \ Print a delete character to delete the letter to the
 JSR CHPR_b2            \ left

 LDA INWK+5,Y           \ Set A to the character before the one we just deleted,
                        \ as that's the current character now

 JMP name2              \ Loop back to name2 to keep scanning for button presses

.name7

                        \ If we get here then we need to give an error beep, as
                        \ we just tried to delete past the start of the name

 JSR BEEP_b7            \ Call the BEEP subroutine to make a short, high beep to
                        \ indicate an error

 LDY #0                 \ Set Y = 0 to set the current character to the start of
                        \ the name

 BEQ name1              \ Loop back to name1 to fetch the next letter (this BEQ
                        \ is effectively a JMP, as Y is always zero)

