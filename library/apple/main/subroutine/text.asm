\ ******************************************************************************
\
\       Name: TEXT
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Switch to the text screen mode
\
\ ******************************************************************************

.TEXT

 LDA &C054              \ Select page 1 display (i.e. main screen memory) by
                        \ reading the PAGE20FF soft switch

 LDA &C051              \ Select the text mode by reading the TEXTON soft switch

 SEC                    \ Set bit 7 of text to indicate that we are now in the
 ROR text               \ text screen mode

 RTS                    \ Return from the subroutine

