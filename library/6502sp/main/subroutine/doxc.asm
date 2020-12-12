\ ******************************************************************************
\
\       Name: DOXC
\       Type: Subroutine
\   Category: Text
\    Summary: Move the text cursor to a specified column by sending a #SETXC
\             command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The new column number
\
\ ******************************************************************************

.DOXC

 PHA                    \ Store the new column number on the stack

 BIT printflag          \ If bit 7 of printflag is clear (printer output is not
 BPL DOX1               \ enabled), jump to DOX1 to skip the printer-specific
                        \ code below

                        \ The following code moves the printer text cursor

 CMP XC                 \ If the new column in A is less than the current column
 BCC DOXLF              \ in XC, jump down to DOXLF to do a carriage return, as
                        \ we need to move the print head to the left, which we
                        \ do by moving it all the way to the left first, before
                        \ tabbing along to the new column value

 BEQ DOX1               \ If the new column in A is equal to the current column
                        \ in XC, we don't need to move the print head, so jump
                        \ to DOX1 to move on to the screen code

 PHY                    \ Store X and Y on the stack, so we can restore them
 PHX                    \ after the following loop

 SBC XC                 \ Set X = A - XC, which is the number of spaces by which
 TAX                    \ we should move the print head to the right

.DOXL1

 LDA #32                \ Print a space to move the print head to the right
 JSR TT26

 DEX                    \ Decrement the number of spaces to move

 BNE DOXL1              \ Loop back until we have moved the print head to the
                        \ right by X spaces

 PLX                    \ Retrieve X and Y from the stack
 PLY

.DOX1

                        \ The following moves the screen text cursor

 LDA #SETXC             \ Send the first part of a #SETXC command to the I/O
 JSR OSWRCH             \ processor

 PLA                    \ Retrieve the new column number from the stack

 STA XC                 \ Set the text cursor x-coordinate in XC to the new
                        \ column number

 JMP OSWRCH             \ Send the column number to the I/O processor, so
                        \ we've now sent a #SETXC <column> command, and return
                        \ from the subroutine using a tail call

.DOXLF

 LDA #13                \ Print a carriage return to send the print head to the
 JSR TT26               \ beginning of the current line (note, this is not a
                        \ newline, which is both a carriage return and a line
                        \ feed, it's just a carriage return)

 JMP DOX1               \ Jump up to DOX1 to update the screen text cursor

