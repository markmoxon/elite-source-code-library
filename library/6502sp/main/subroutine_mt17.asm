\ ******************************************************************************
\
\       Name: MT17
\       Type: Subroutine
\   Category: Text
\    Summary: 
\
\ ******************************************************************************

.MT17

 LDA QQ17               \ Clear bit 6 of QQ17 to switch to ALL CAPS
 AND #%10111111
 STA QQ17

 LDA #3                 \ Print control code 3 (selected system name)
 JSR TT27

 LDX DTW5               \ Set A to the DTW5-th byte of BUF
 LDA BUF-1,X

 JSR VOWEL              \ Test whether the character is a vowel, in which case
                        \ this will set the C flag

 BCC MT171              \ If the character is not a vowel, skip the following
                        \ instruction

 DEC DTW5               \ The character is a vowel, so decrement DTW5

.MT171

 LDA #153               \ Print extended token 153
 JMP DETOK

