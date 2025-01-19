\ ******************************************************************************
\
\       Name: clss
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the screen, move the text cursor to the top-left corner and
\             jump back into the CHPR routine to print the next character
\
\ ******************************************************************************

.clss

IF _C64_VERSION

 JSR TT66simp           \ Call TT66simp to clear the whole screen inside the box
                        \ border, and move the text cursor to the top-left
                        \ corner


ELIF _APPLE_VERSION

 BIT text               \ If bit 7 of text is clear then the current screen mode
 BPL clss1              \ is the high-resolution graphics mode, so jump to clss1
                        \ to clear the graphics screen

 JSR cleartext          \ This is a text view, so clear screen memory for the
                        \ text screen mode and move the text cursor to the
                        \ top-left corner

ENDIF

 LDA K3                 \ We called this routine from CHPR, which put the
                        \ character we are printing into K3, so set A to the
                        \ character number so we can jump back to CHPR to print
                        \ it on the newly cleared screen

 JMP RRafter            \ Jump back into the CHPR routine to print the character
                        \ in A

IF _APPLE_VERSION

.clss1

 JSR cleargrap          \ This is a high-resolution graphics screen, so clear
                        \ screen memory for the top part of the graphics screen
                        \ mode (the space view), drawing blue borders along the
                        \ sides as we do so, and moving the text cursor to the
                        \ top-left corner

 LDA K3                 \ We called this routine from CHPR, which put the
                        \ character we are printing into K3, so set A to the
                        \ character number so we can jump back to CHPR to print
                        \ it on the newly cleared screen

 JMP RRafter            \ Jump back into the CHPR routine to print the character
                        \ in A

ENDIF

