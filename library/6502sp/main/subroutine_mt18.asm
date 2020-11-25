\ ******************************************************************************
\
\       Name: MT18
\       Type: Subroutine
\   Category: Text
\    Summary: Print a random number (1-4) of extended two-letter tokens
\
\ ******************************************************************************

.MT18

 JSR MT19               \ Call MT19 to set upper case for the first letter ???

 JSR DORND              \ Set A and X to random numbers and reduce A to a
 AND #3                 \ random number in the range 0-3

 TAY                    \ Copy the random number into Y, so Y contains the
                        \ number of words to print (i.e. we print 1-4 words)

.MT18L

 JSR DORND              \ Set A and X to random numbers and reduce A to an even
 AND #62                \ random number in the range 0-62 (as bit 0 of 62 is 0)

 TAX                    \ Copy the random number into X, so X contains the table
                        \ offset of a random extended two-letter token from 0-31
                        \ which we can use to pick a token from the combined
                        \ tables at TKN2+2 and QQ16 (we exclude the first token
                        \ in TKN2, which contains a newline)

 LDA TKN2+2,X           \ Print the first letter of the token at TKN2 + 2 + X
 JSR DTS

 LDA TKN2+3,X           \ Print the first letter of the token at TKN2 + 3 + X
 JSR DTS

 DEY                    \ Decrement the loop counter

 BPL MT18L              \ Loop back to MT18L to print another two-letter token
                        \ until we have printed Y+1 of them

 RTS                    \ Return from the subroutine

