\ ******************************************************************************
\
\       Name: MT9
\       Type: Subroutine
\   Category: Text
IF NOT(_NES_VERSION)
\    Summary: Clear the screen and set the current view type to 1
ELIF _NES_VERSION
\    Summary: Clear the screen and set the view type for a text-based mission
\    briefing
ENDIF
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ This routine sets the following:
\
\   * XC = 1 (tab to column 1)
\
IF NOT(_NES_VERSION)
\ before calling TT66 to clear the screen and set the view type to 1.
ELIF _NES_VERSION
\ before calling TT66 to clear the screen and set the view type to &95.
ENDIF
\
\ ******************************************************************************

.MT9

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Tube

 LDA #1                 \ Move the text cursor to column 1
 STA XC

ELIF _6502SP_VERSION OR _C64_VERSION

 LDA #1                 \ Call DOXC to move the text cursor to column 1
 JSR DOXC

ENDIF

IF NOT(_NES_VERSION)

 JMP TT66               \ Jump to TT66 to clear the screen and set the current
                        \ view type to 1, returning from the subroutine using a
                        \ tail call

ELIF _NES_VERSION

 LDA #&95               \ Clear the screen and set the view type in QQ11 to &95
 JMP TT66_b0            \ (Text-based mission briefing), returning from the
                        \ subroutine using a tail call

ENDIF

