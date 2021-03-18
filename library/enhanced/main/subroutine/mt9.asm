\ ******************************************************************************
\
\       Name: MT9
\       Type: Subroutine
\   Category: Text
\    Summary: Clear the screen and set the current view type to 1
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ This routine sets the following:
\
\   * XC = 1 (tab to column 1)
\
\ before calling TT66 to clear the screen and set the view type to 1.
\
\ ******************************************************************************

.MT9

IF _DISC_DOCKED OR _MASTER_VERSION \ Tube

 LDA #1                 \ Move the text cursor to column 1
 STA XC

ELIF _6502SP_VERSION

 LDA #1                 \ Call DOXC to move the text cursor to column 1
 JSR DOXC

ENDIF

 JMP TT66               \ Jump to TT66 to clear the screen and set the current
                        \ view type to 1, returning from the subroutine using a
                        \ tail call

