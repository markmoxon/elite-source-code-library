\ ******************************************************************************
\
\       Name: MT18
\       Type: Subroutine
\   Category: Text
\    Summary: Print a random 1-8 letter word in Sentence Case
\  Deep dive: Extended text tokens
\
\ ******************************************************************************

.MT18

 JSR MT19               \ Call MT19 to capitalise the next letter (i.e. set
                        \ Sentence Case for this word only)

 JSR DORND              \ Set A and X to random numbers and reduce A to a
 AND #3                 \ random number in the range 0-3

 TAY                    \ Copy the random number into Y, so we can use Y as a
                        \ loop counter to print 1-4 words (i.e. Y+1 words)

.MT18L

 JSR DORND              \ Set A and X to random numbers and reduce A to an even
 AND #62                \ random number in the range 0-62 (as bit 0 of 62 is 0)

 TAX                    \ Copy the random number into X, so X contains the table
                        \ offset of a random extended two-letter token from 0-31
                        \ which we can now use to pick a token from the combined
                        \ tables at TKN2+2 and QQ16 (we intentionally exclude
                        \ the first token in TKN2, which contains a newline)

IF NOT(_NES_VERSION)

 LDA TKN2+2,X           \ Print the first letter of the token at TKN2+2 + X
 JSR DTS

 LDA TKN2+3,X           \ Print the second letter of the token at TKN2+2 + X
 JSR DTS

ELIF _NES_VERSION

 LDA TKN2+2,X           \ Print the first letter of the token at TKN2+2 + X
 JSR DTS_BANK7

 LDA TKN2+3,X           \ Fetch the second letter of the token from TKN2+2 + X

 CMP #'?'               \ If the second letter is a question mark, skip the
 BEQ P%+5               \ following instruction (as ? indicates a single-letter
                        \ token)

 JSR DTS_BANK7          \ Print the second letter of the token at TKN2+2 + X

ENDIF

 DEY                    \ Decrement the loop counter

 BPL MT18L              \ Loop back to MT18L to print another two-letter token
                        \ until we have printed Y+1 of them

 RTS                    \ Return from the subroutine

