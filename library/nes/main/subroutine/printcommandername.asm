\ ******************************************************************************
\
\       Name: PrintCommanderName
\       Type: Subroutine
\   Category: Save and load
\    Summary: Print the commander name from the commander file in BUF, with the
\             save count added to the end
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\ ******************************************************************************

.PrintCommanderName

 PHA                    \ Store the value of A on the stack so we can restore it
                        \ at the end of the subroutine

 LDY #0                 \ We start by printing the commander name from the first
                        \ seven bytes of the commander file at BUF, so set a
                        \ character index in Y so we can loop though the name
                        \ one character at a time

.pnam1

 LDA BUF,Y              \ Set A to the Y-th character from the name at BUF

 JSR DASC_b2            \ Print the character

 INY                    \ Increment the character index in Y

 CPY #7                 \ Loop back until we have printed all seven characters
 BCC pnam1              \ in the BUF buffer from BUF to BUF+6

                        \ Now that the name is printed, we print the save count
                        \ after the end of the name as a one- or two-digit
                        \ decimal value

 LDX #0                 \ Set X = 0 to use as a division counter in the loop
                        \ below

 LDA BUF+7              \ Set A to the byte after the end of the name, which
                        \ contains the save counter in SVC

 AND #%01111111         \ Clear bit 7 of the save counter so we are left with
                        \ the number of saves in A

 SEC                    \ Set the C flag for the subtraction below

.pnam2

 SBC #10                \ Set A = A - 10

 INX                    \ Increment X

 BCS pnam2              \ If the subtraction didn't underflow, jump back to
                        \ pnam2 to subtract another 10

 TAY                    \ By this point X contains the number of whole tens in
                        \ the original number, plus 1 (as that extra one broke
                        \ the subtraction), while A contains the remainder, so
                        \ this instruction sets Y so the following is true:
                        \
                        \   SVC = 10 * (X + 1) - (10 - Y)
                        \       = 10 * (X + 1) + (Y - 10)

 LDA #' '               \ Set A to the ASCII for space

 DEX                    \ Decrement X so this is now true:
                        \
                        \   SVC = 10 * X + (Y - 10)

 BEQ pnam3              \ If X = 0 then jump to pnam3 to print a space for the
                        \ first digit of the save count, as it is less than ten

 TXA                    \ Otherwise set A to the ASCII code for the digit in X
 ADC #'0'               \ so we print the correct tens digit for the save
                        \ counter

.pnam3

 JSR DASC_b2            \ Print the character in A to print the first digit of
                        \ the save counter

 TYA                    \ The remainder of the calculation above is Y - 10, so
 CLC                    \ to get the second digit in the value of SVC, we need
 ADC #'0'+10            \ to add 10 to the value in Y, before adding ASCII "0"
                        \ to convert it into a character

 JSR DASC_b2            \ Print the character in A to print the second digit of
                        \ the save counter

 PLA                    \ Restore the value of A that we stored on the stack, so
                        \ A is preserved

 RTS                    \ Return from the subroutine

