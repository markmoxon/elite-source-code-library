\ ******************************************************************************
\
\       Name: WHITETEXT
\       Type: Subroutine
\   Category: Text
\    Summary: Switch to white text
\
\ ******************************************************************************

.WHITETEXT

 LDA #32                \ Send a #SETVDU19 32 command to the I/O processor to
 JSR DOVDU19            \ set the mode 1 palette to yellow (colour 1), white
                        \ (colour 2) and cyan (colour 3)

 LDA #RED               \ Send a #SETCOL &F0 command to the I/O processor to
 JMP DOCOL              \ switch to colour 2, which is now white

