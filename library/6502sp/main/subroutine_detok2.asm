\ ******************************************************************************
\
\       Name: DETOK2
\       Type: Subroutine
\   Category: Text
\    Summary: Print an extended text token
\
\ ------------------------------------------------------------------------------
\
\ * If bit 7 of DTW3 is set:
\
\   0-31            Call the corresponding JMTB routine
\   32-255          Print standard text token with TT27
\
\ * If bit 7 of DTW3 is clear:
\
\   0-31            Call the corresponding JMTB routine
\   32-64           Print standard text token with TT27
\   A-Z (65-90)     * If bit 7 of DTW6 is set, OR with DTW1, AND with DTW8, print standard text token
\                   * If bit 7 of DTW2 is set, AND with DTW8, print standard text token
\                   * Otherwise print standard text token
\   91-128          Print extended recursive token with DETOK, fetching token number from MTIN table (subtract 91 to get 0-37 + random 0-4)
\   129-215         Print extended recursive token with DETOK
\   215-227         Print extended two-letter token from table TKN2 (subtract 215 to get 0-12)
\
\ DTW8 is either %11111111 (set at start of DASC) or %11011111 (set in MT19), so the AND can clear bit 5
\ DTW1 is always %00100000, so the OR sets bit 5
\ DTW3 is always 0 (set to 0 in MT5)
\
\ DTW6 starts as 0 and is set to 0 by MT2 and %10000000 by MT13
\ DTW2 starts as %11111111, is set to %11111111 by MT8 and can be set to 0 in DASC, looks like an 'in-word' flag where it is 0 if we are in a word
\
\ Bit 5 clear in an ASCII letter code = upper case
\ Bit 5 set in an ASCII letter code = lower case
\
\ Arguments:
\
\   A                   The token to be printed
\
\ Returns:
\
\   A                   A is preserved
\
\   Y                   Y is preserved
\
\   V(1 0)              V(1 0) is preserved
\ 
\ ******************************************************************************

.DETOK2

 CMP #32                \ If A < 32, jump to DT3
 BCC DT3

 BIT DTW3               \ If bit 7 of DTW3 is clear, jump to DT8
 BPL DT8

                        \ If we get there then the token number in A is 32 or
                        \ more and bit 7 of DTW3 is not set, so we can call the
                        \ standard text token routine at TT27 to print the token

 TAX                    \ Copy the token number from A into X

 TYA                    \ Store Y on the stack
 PHA

 LDA V                  \ Store V(1 0) on the stack
 PHA
 LDA V+1
 PHA

 TXA                    \ Copy the token number from X back into A

 JSR TT27               \ Call TT27 to print the text token

 JMP DT7                \ Jump to DT7 to restore V(1 0) and Y from the stack and
                        \ return from the subroutine

.DT8

                        \ If we get here then the token number in A is 32 or
                        \ more and bit 7 of DTW3 is set

 CMP #'['               \ If A < ASCII "[" (i.e. A <= ASCII "Z") then this is a
 BCC DTS                \ printable ASCII character, so jump down to DTS to
                        \ print it

 CMP #129               \ If A < 129, so A is in the range 91-128 (as ASCII "["
 BCC DT6                \ is 91), jump to DT6 to print a token from the MTIN
                        \ table

 CMP #215               \ If A < 215, so A is in the range 129-215, jump to
 BCC DETOK              \ DETOK as this is a recursive token

                        \ If we get here then A >= 215, which is an extended
                        \ two-letter token from the TKN2 table

 SBC #215               \ Subtract 215 to get a token number in the range 0-12
                        \ (the C flag is set as we passed through the BCC above,
                        \ so this subtraction is correct)

 ASL A                  \ Set A = A * 2, so it can be used as a pointer into the
                        \ two-letter token table at TKN2

 PHA                    \ Store A on the stack, so we can restore it for the
                        \ second letter below

 TAX                    \ Fetch the first letter of the two-letter token from
 LDA TKN2,X             \ TKN2, which is at TKN2 + X

 JSR DTS                \ Call DTS to print it

 PLA                    \ Restore A from the stack and transfer it into X
 TAX

 LDA TKN2+1,X           \ Fetch the second letter of the two-letter token from
                        \ TKN2, which is at TKN2 + X + 1, and fall througn into
                        \ DTS to print it

.DTS

 CMP #'A'               \ If A < ASCII "A", jump to DT9 to print this as ASCII
 BCC DT9

 BIT DTW6               \ If bit 7 of DTW6 is set, jump to DT10
 BMI DT10

 BIT DTW2               \ If bit 7 of DTW2 is set, jump to DT5
 BMI DT5

.DT10

 ORA DTW1               \ Set the character value to at least DTW1

.DT5

 AND DTW8               \ Mask the character value with DTW8

.DT9

 JMP DASC               \ Jump to DASC to print the ASCII character in A,
                        \ returning from the routine with a tail call

.DT3

                        \ The token number is less than 32, so this refers to
                        \ a value in the jump table JMTB

 TAX                    \ Copy the token number from A into X

 TYA                    \ Store Y on the stack
 PHA

 LDA V                  \ Store V(1 0) on the stack
 PHA
 LDA V+1
 PHA

 TXA                    \ Copy the token number from X back into A

 ASL A                  \ Set A = A * 2, so it can be used as a pointer into the
                        \ jump table at JMTB

 TAX                    \ Copy the doubled token number from A into X

 LDA JMTB-2,X           \ Set DTM(2 1) to the X-2-th address from the JMTB table
 STA DTM+1              \ which modifies the JSR DASC instruction at label DTM
 LDA JMTB-1,X           \ below to call the subroutine at the address from the
 STA DTM+2              \ JMTB table

 TXA                    \ Copy the doubled token number from X back into A

 LSR A                  \ Halve A to get the original token number

.DTM

 JSR DASC               \ Call DASC to print the ASCII character in A (or, if
                        \ the token number is less than 32, call the relevant
                        \ JMTB subroutine, as this instruction will have been
                        \ modified)

.DT7

 PLA                    \ Restore V(1 0) from the stack, so it is preserved
 STA V+1                \ through calls to this routine
 PLA
 STA V

 PLA                    \ Restore Y from the stack, so it is preserved through
 TAY                    \ calls to this routine

 RTS                    \ Return from the subroutine

.DT6

                        \ If we get here then A is in the range 91-128, so we
                        \ print a randomly picked token from the MTIN table

 STA SC                 \ Store the token number in SC

 TYA                    \ Store Y on the stack
 PHA

 LDA V                  \ Store V(1 0) on the stack
 PHA
 LDA V+1
 PHA

 JSR DORND              \ Set X to a random number
 TAX

 LDA #0                 \ Set A to 0, so we can build a random number from 0 to
                        \ 4 in A plus the C flag, with the higher values being
                        \ increasingly less likely the higher they are

 CPX #51                \ Add 1 to A if X >= 51
 ADC #0

 CPX #102               \ Add 1 to A if X >= 102
 ADC #0

 CPX #153               \ Add 1 to A if X >= 153
 ADC #0

 CPX #204               \ Set the C flag if X >= 204

 LDX SC                 \ Fetch the token number from SC into X, so X is now in
                        \ the range 92-128

 ADC MTIN-91,X          \ Set A = MTIN-91 + token number (91-128) + random (0-4)
                        \       = MTIN + token number (0-37) + random (0-4)

 JSR DETOK              \ Call DETOK to print the extended recursive token in A

 JMP DT7                \ Jump to DT7 to restore V(1 0) and Y from the stack and
                        \ return from the subroutine

