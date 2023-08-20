\ ******************************************************************************
\
\       Name: MT9
\       Type: Subroutine
\   Category: Text
IF NOT(_NES_VERSION)
\    Summary: Clear the screen and set the current view type to 1
ELIF _NES_VERSION
\    Summary: Clear the screen and show the Trumble mission briefing
ENDIF
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

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Tube

 LDA #1                 \ Move the text cursor to column 1
 STA XC

ELIF _6502SP_VERSION

 LDA #1                 \ Call DOXC to move the text cursor to column 1
 JSR DOXC

ENDIF

IF NOT(_NES_VERSION)

 JMP TT66               \ Jump to TT66 to clear the screen and set the current
                        \ view type to 1, returning from the subroutine using a
                        \ tail call

ELIF _NES_VERSION

 LDA #&95               \ Clear the screen and and set the view type in QQ11 to
 JMP TT66_b0            \ &95 (Trumble mission briefing), returning from the
                        \ subroutine using a tail call

ENDIF

