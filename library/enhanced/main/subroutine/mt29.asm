\ ******************************************************************************
\
\       Name: MT29
\       Type: Subroutine
\   Category: Text
IF NOT(_APPLE_VERSION OR _NES_VERSION OR _C64_VERSION)
\    Summary: Move to row 6, switch to white text, and switch to lower case when
\             printing extended tokens
ELIF _C64_VERSION
\    Summary: Move to row 6 and switch to lower case when printing extended
\             tokens
ELIF _APPLE_VERSION
\    Summary: Move to row 5 and switch to lower case when printing extended
\             tokens
ELIF _NES_VERSION
\    Summary: Move to row 7 and switch to lower case when printing extended
\             tokens
ENDIF
\  Deep dive: Extended text tokens
\
\ ******************************************************************************

.MT29

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _MASTER_VERSION \ Tube

 LDA #6                 \ Move the text cursor to row 6
 STA YC

ELIF _6502SP_VERSION OR _C64_VERSION

 LDA #6                 \ Move the text cursor to row 6
 JSR DOYC

ELIF _APPLE_VERSION

 LDA #5                 \ Move the text cursor to row 5
 STA YC

ELIF _NES_VERSION

 LDA #7                 \ Move the text cursor to row 7
 STA YC

ENDIF

IF _6502SP_VERSION \ Screen

 JSR WHITETEXT          \ Set white text

ELIF _MASTER_VERSION

 LDA #CYAN              \ Set white text
 STA COL

ELIF _C64_VERSION

 JSR WHITETEXT          \ This routine has no effect in this version of Elite

ENDIF

IF NOT(_NES_VERSION)

 JMP MT13               \ Jump to MT13 to set bit 7 of DTW6 and bit 5 of DTW1,
                        \ returning from the subroutine using a tail call

ELIF _NES_VERSION

                        \ Fall through into MT13 to set bit 7 of DTW6 and bit 5
                        \ of DTW1

ENDIF

