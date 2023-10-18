\ ******************************************************************************
\
\       Name: PrintCtrlCode
\       Type: Subroutine
\   Category: Text
\    Summary: Print a control code (in the range 0 to 9)
\
\ ******************************************************************************

.PrintCtrlCode

 TXA                    \ Copy the token number from X to A. We can then keep
                        \ decrementing X and testing it against zero, while
                        \ keeping the original token number intact in A; this
                        \ effectively implements a switch statement on the
                        \ value of the token

 BEQ csh                \ If token = 0, this is control code 0 (current amount
                        \ of cash and newline), so jump to csh to print the
                        \ amount of cash and return from the subroutine using
                        \ a tail call

 DEX                    \ If token = 1, this is control code 1 (current galaxy
 BEQ tals               \ number), so jump to tal via tals to print the galaxy
                        \ number and return from the subroutine using a tail
                        \ call

 DEX                    \ If token = 2, this is control code 2 (current system
 BEQ ypls               \ name), so jump to ypl via ypls to print the current
                        \ system name  and return from the subroutine using a
                        \ tail call

 DEX                    \ If token > 3, skip the following instruction
 BNE P%+5

 JMP cpl                \ This token is control code 3 (selected system name)
                        \ so jump to cpl to print the selected system name
                        \ and return from the subroutine using a tail call

 DEX                    \ If token <> 4, skip the following instruction
 BNE P%+5

 JMP cmn                \ This token is control code 4 (commander name) so jump
                        \ to cmn to print the commander name and return from the
                        \ subroutine using a tail call

 DEX                    \ If token = 5, this is control code 5 (fuel, newline,
 BEQ fwls               \ cash, newline), so jump to fwl via fwls to print the
                        \ fuel level and return from the subroutine using a tail
                        \ call

 DEX                    \ If token > 6, skip the following three instructions
 BNE ptok2

 LDA #%10000000         \ This token is control code 6 (switch to Sentence
 STA QQ17               \ Case), so set bit 7 of QQ17 to switch to Sentence Case

.ptok1

 RTS                    \ Return from the subroutine

.ptok2

 DEX                    \ If token = 7, this is control code 7 (beep), so jump
 BEQ ptok1              \ to ptok1 to return from the subroutine

 DEX                    \ If token > 8, jump to ptok3
 BNE ptok3

 STX QQ17               \ This is control code 8, so set QQ17 = 0 to switch to
                        \ ALL CAPS (we know X is zero as we just passed through
                        \ a BNE)

 RTS                    \ Return from the subroutine

.ptok3

                        \ If we get here then token > 8, so this is control code
                        \ 9 (print a colon then tab to column 22 or 23)

 JSR TT73               \ Print a colon

 LDA languageNumber     \ If bit 1 of languageNumber is set, then the chosen
 AND #%00000010         \ language is German, so jump to ptok4 to move the text
 BNE ptok4              \ cursor to column 23

 LDA #22                \ Bit 1 of languageNumber is clear, so the chosen
 STA XC                 \ language is English or French, so move the text cursor
                        \ to column 22

 RTS                    \ Return from the subroutine

.ptok4

 LDA #23                \ Move the text cursor to column 23
 STA XC

 RTS                    \ Return from the subroutine

