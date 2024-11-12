\ ******************************************************************************
\
\       Name: WHITETEXT
\       Type: Subroutine
\   Category: Text
\    Summary: Switch to white text
\
\ ******************************************************************************

.WHITETEXT

IF NOT(_C64_VERSION OR _APPLE_VERSION)

 LDA #32                \ Send a #SETVDU19 32 command to the I/O processor to
 JSR DOVDU19            \ switch to the mode 1 palette for the title screen,
                        \ which is yellow (colour 1), white (colour 2) and cyan
                        \ (colour 3)

 LDA #RED               \ Send a #SETCOL RED command to the I/O processor to
 JMP DOCOL              \ switch to colour 2, which is white in the title
                        \ screen, and return from the subroutine using a tail
                        \ call

ELIF _C64_VERSION OR _APPLE_VERSION

\LDA #32                \ These instructions are commented out in the original
\JSR DOVDU19            \ source
\LDA #RED
\JMP DOCOL

 RTS                    \ Return from the subroutine

ENDIF


