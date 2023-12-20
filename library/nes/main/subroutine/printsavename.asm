\ ******************************************************************************
\
\       Name: PrintSaveName
\       Type: Subroutine
\   Category: Save and load
\    Summary: Print the name of a specific save slot
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The save slot number to print:
\
\                         * 0 to 7 = print the name of a specific save slot on
\                                    the right of the screen
\
\                         * 8 = print the current commander name in the middle
\                               column
\
\                         * 9 = print the current commander name in the left
\                               column
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is preserved
\
\ ******************************************************************************

.PrintSaveName

 JSR CopyCommanderToBuf \ Copy the commander file from save slot A into the
                        \ buffer at BUF, so we can access its name

 PHA                    \ Store the value of A on the stack so we can restore it
                        \ at the end of the subroutine

 CMP #8                 \ If A < 8 then this is one of the save slots on the
 BCC psav3              \ right of the screen, so jump to pav3 to print the name
                        \ in the right column

 LDX #1                 \ Move the text cursor to column 1
 STX XC

 CMP #9                 \ If A < 9 then A = 8, which represents the middle
 BCC psav2              \ column, so jump to psav2 to print the name in the
                        \ middle column

 BEQ psav1              \ If A = 9 then this represents the current commander in
                        \ the left column so jump to psav1 to print the name on
                        \ the left of the screen

                        \ If we get here then A >= 10, which is never the case,
                        \ so this code might be left over from functionality
                        \ that was later removed

 LDA #18                \ Move the text cursor to row 18
 STA YC

 JMP psav4              \ Jump to psav4 to print the name of the file in the
                        \ save slot

.psav1

                        \ If we get here then A = 9, so we need to print the
                        \ commander name in the left column

 LDA #14                \ Move the text cursor to row 14
 STA YC

 JMP psav4              \ Jump to psav4 to print the name of the file in the
                        \ save slot

.psav2

                        \ If we get here then A = 8, so we need to print the
                        \ commander name in the middle column

 LDA #6                 \ Move the text cursor to row 6
 STA YC

 JMP psav4              \ Jump to psav4 to print the name of the file in the
                        \ save slot

.psav3

                        \ If we get here then A is in the range 0 to 7, so we
                        \ need to print the commander name in the right column

 ASL A                  \ Move the text cursor to row 6 + A * 2
 CLC                    \
 ADC #6                 \ So this is the text row for slot number A in the right
 STA YC                 \ column of the screen

 LDA #21                \ Move the text cursor to column 21 for the column of
 STA XC                 \ slot names on the right of the screen

.psav4

 PLA                    \ Restore the value of A that we stored on the stack, so
                        \ A is preserved

                        \ Fall through into PrintCommanderName to print the name
                        \ of the commander file in BUF, followed by the save
                        \ count

