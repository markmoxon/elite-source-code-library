\ ******************************************************************************
\
\       Name: ChangeLetter
\       Type: Subroutine
\   Category: Controllers
\    Summary: Choose a letter using the up and down buttons
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The letter to start on
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The chosen letter
\
\   C flag              The status of the A button:
\
\                         * Set = the A button was pressed to finish entering
\                                 the string
\
\                         * Clear = the A button was not pressed
\
\ ******************************************************************************

.ChangeLetter

 TAX                    \ Set X to the starting letter

 STY YSAV               \ Store Y in YSAV so we can retrieve it below

 LDA fontStyle          \ Store the current font style on the stack, so we can
 PHA                    \ restore it when we return from the subroutine

 LDA QQ11               \ If bit 5 of the view type in QQ11 is clear, then the
 AND #%00100000         \ normal font is not loaded, so jump to lett1 to skip
 BEQ lett1              \ the following instruction

 LDA #1                 \ Set the font style to print in the normal font
 STA fontStyle

.lett1

 TXA                    \ Set A to the starting letter

.lett2

 PHA                    \ Store the current letter in A on the stack so we can
                        \ retrieve it below

 LDY #4                 \ Wait until four NMI interrupts have passed (i.e. the
 JSR DELAY              \ next four VBlanks)

 PLA                    \ Set A to the current letter, leaving a copy of it on
 PHA                    \ the stack

 JSR CHPR_b2            \ Print the character in A

 DEC XC                 \ Move the text cursor left by one character, so it is
                        \ the correct column for the letter we just printed

 JSR DrawMessageInNMI   \ Configure the NMI to display the message that we just
                        \ printed

 SEC                    \ Set the C flag to return from the subroutine if the
                        \ following check shows that the A button was pressed,
                        \ in which case we have finished entering letters

 LDA controller1A       \ If the A button on controller 1 is being pressed, jump
 BMI lett5              \ to lett5 to return from the subroutine with the C flag
                        \ set and the current letter as the chosen letter

 CLC                    \ Clear the C flag to indicate that the A button was not
                        \ pressed

 PLA                    \ Set A to the current letter, which we stored on the
                        \ stack above

 LDX controller1B       \ If the B button on controller 1 is being pressed, loop
 BMI lett2              \ back to lett2 to keep scanning for button presses, as
                        \ the arrow buttons have a different meaning when the B
                        \ button is also held down

 LDX iconBarChoice      \ If an icon has been chosen from the icon bar, jump to
 BNE lett7              \ lett7 to return from the subroutine with a value of
                        \ 27 (ESC, or escape) and the C flag clear

 LDX controller1Left03  \ If the left button on controller 1 was being held down
 BMI lett4              \ four VBlanks ago, jump to lett4 to return from the
                        \ subroutine with a value of 127 (DEL, or delete) and
                        \ the C flag clear

 LDX controller1Right03 \ If the right button on controller 1 was being held
 BMI lett6              \ down four VBlanks ago, jump to lett6 to return from
                        \ the subroutine with the C flag clear

 LDX controller1Up      \ If the up button on controller 1 is not being pressed,
 BPL lett3              \ jump to lett3 to move on to the next button

                        \ If we get here then the up button is being pressed

 CLC                    \ Increment the current character in A
 ADC #1

 CMP #'Z'+1             \ If A is still a letter in the range "A" to "Z", then
 BNE lett3              \ jump to lett3 to skip the following

 LDA #'A'               \ Set A to ASCII "A" so we wrap round to the start of
                        \ the alphabet

.lett3

 LDX controller1Down    \ If the down button on controller 1 is not being
 BPL lett2              \ pressed, loop back to lett2 to keep scanning for
                        \ button presses

                        \ If we get here then the down button is being pressed

 SEC                    \ Decrement the current character in A
 SBC #1

 CMP #'A'-1             \ If A is still a letter in the range "A" to "Z", then
 BNE lett2              \ look back to lett2 to keep scanning for button presses

 LDA #'Z'               \ Set A to ASCII "Z" so we wrap round to the end of
                        \ the alphabet

 BNE lett2              \ Loop back to lett2 to keep scanning for button presses
                        \ (this BNE is effectively a JMP as A is never zero)

.lett4

                        \ If we get here then the left button is being pressed

 LDA #127               \ Set A to the ASCII code for DEL, or delete

 BNE lett6              \ Jump to lett6 to return from the subroutine (this BNE
                        \ is effectively a JMP as A is never zero)

.lett5

 PLA                    \ Set A to the current letter, which we stored on the
                        \ stack above

.lett6

 TAX                    \ Store the chosen letter in X so we can retrieve it
                        \ below

 PLA                    \ Restore the font style that we stored on the stack
 STA fontStyle          \ so it's unchanged by the routine

 LDY YSAV               \ Retrieve the value of Y we stored above

 TXA                    \ Restore the chosen letter from X into A so we can
                        \ return it

 RTS                    \ Return from the subroutine

.lett7

                        \ If we get here then an icon bar button has been
                        \ chosen, so we need to abort the letter choosing
                        \ process

 LDA #27                \ Set A to the ASCII code for ESC, or escape

 BNE lett6              \ Jump to lett6 to return from the subroutine (this BNE
                        \ is effectively a JMP as A is never zero)

