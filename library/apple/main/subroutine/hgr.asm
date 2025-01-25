\ ******************************************************************************
\
\       Name: HGR
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Switch to the high-resolution graphics screen mode
\
\ ******************************************************************************

.HGR

 LDA &C054              \ Select page 1 display (i.e. main screen memory) by
                        \ reading the PAGE20FF soft switch

 LDA &C052              \ Configure graphics on the whole screen by reading the
                        \ MIXEDOFF soft switch

 LDA &C057              \ Select high-resolution graphics by reading the HIRESON
                        \ soft switch

 LDA &C050              \ Select the graphics mode by reading the TEXTOFF soft
                        \ switch

 LSR text               \ Clear bit 7 of text to indicate that we are now in the
                        \ high-resolution graphics screen mode

 RTS                    \ Return from the subroutine

