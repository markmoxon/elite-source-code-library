\ ******************************************************************************
\
\       Name: csh
\       Type: Subroutine
\   Category: Text
\    Summary: Print the current amount of cash
\
\ ------------------------------------------------------------------------------
\
\ Print control code 0 (the current amount of cash, right-aligned to width 9,
\ followed by " CR" and a newline).
\
\ ******************************************************************************

.csh

 LDX #3                 \ We are going to use the BPRNT routine to print out
                        \ the current amount of cash, which is stored as a
                        \ 32-bit number at location CASH. BPRNT prints out
                        \ the 32-bit number stored in K, so before we call
                        \ BPRNT, we need to copy the four bytes from CASH into
                        \ K, so first we set up a counter in X for the 4 bytes

.pc1

 LDA CASH,X             \ Copy byte X from CASH to K
 STA K,X

 DEX                    \ Decrement the loop counter

 BPL pc1                \ Loop back for the next byte to copy

 LDA #9                 \ We want to print the cash amount using up to 9 digits
 STA U                  \ (including the decimal point), so store this in U
                        \ for BRPNT to take as an argument

 SEC                    \ We want to print the cash amount with a decimal point,
                        \ so set the C flag for BRPNT to take as an argument

 JSR BPRNT              \ Print the amount of cash to 9 digits with a decimal
                        \ point

 LDA #226               \ Print recursive token 66 (" CR") followed by a
                        \ newline by falling through into plf

