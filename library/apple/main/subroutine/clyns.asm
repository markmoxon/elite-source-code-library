\ ******************************************************************************
\
\       Name: CLYNS
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear two character rows near the bottom of the screen
\
\ ------------------------------------------------------------------------------
\
\ This routine clears some space at the bottom of the screen and moves the text
\ cursor to column 1 on row 21 (for the space view) or row 15 (for the text
\ views).
\
\ ******************************************************************************

.CLYNS

 LDA #0                 \ Set the delay in DLY to 0, to indicate that we are
 STA DLY                \ no longer showing an in-flight message, so any new
                        \ in-flight messages will be shown instantly

 STA de                 \ Clear de, the flag that appends " DESTROYED" to the
                        \ end of the next text token, so that it doesn't

.CLYNS2

 JSR CLYS1              \ Call CLYS1 to move the text cursor to column 21 on
                        \ row 1

 LDA #%11111111         \ Set DTW2 = %11111111 to denote that we are not
 STA DTW2               \ currently printing a word

 LDA #%10000000         \ Set bit 7 of QQ17 to switch standard tokens to
 STA QQ17               \ Sentence Case

 LDA text               \ If bit 7 of text is clear then the current screen mode
 BPL CLY1               \ is the high-resolution graphics mode, so jump to CLY1
                        \ clear two character rows on the graphics screen

                        \ Otherwise this is the text screen, so we clear two
                        \ character rows by printing 64 spaces (32 spaces per
                        \ row

 LDA #' '               \ Set A to the space character, so we can pass it to
                        \ CHPR to print a space

 LDX #64                \ Set a character counter in X so we print 64 spaces

.CLYL1

 JSR CHPR               \ Print a space character

 DEX                    \ Decrement the character counter

 BNE CLYL1              \ Loop back until we have printed 64 spaces to blank
                        \ out two character rows

.CLYS1

 LDA #21                \ Move the text cursor to column 21 on row 1
 STA YC
 LDA #1
 STA XC

 RTS                    \ Return from the subroutine

.CLY1

 LDY #15                \ Move the text cursor to column 15 on row 1
 STY YC
 LDA #1
 STA XC

 JSR clearrow           \ Clear character row Y in screen memory, drawing blue
                        \ borders along the left and right edges as we do so

 INY                    \ Increment Y to the next character row

                        \ Fall through into clearrow to clear a second character
                        \ row in screen memory, drawing blue borders along the
                        \ left and right edges as we do so

