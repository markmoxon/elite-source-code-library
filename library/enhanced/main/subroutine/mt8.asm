\ ******************************************************************************
\
\       Name: MT8
\       Type: Subroutine
\   Category: Text
\    Summary: Tab to column 6 and start a new word when printing extended tokens
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ This routine sets the following:
\
\   * XC = 6 (tab to column 6)
\
\   * DTW2 = %11111111 (we are not currently printing a word)
\
IF _ELITE_A_ENCYCLOPEDIA
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   set_token           Start a new word when printing extended tokens
\
ENDIF
\ ******************************************************************************

.MT8

IF _DISC_DOCKED OR _ELITE_A_VERSION OR _NES_VERSION \ Tube

 LDA #6                 \ Move the text cursor to column 6
 STA XC

ELIF _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION

 LDA #6                 \ Move the text cursor to column 6
 JSR DOXC

ELIF _APPLE_VERSION

 LDA #6                 \ Set A = 6 to denote column 6

IF _IB_DISK

 STA XC                 \ Move the text cursor to column 6

ELIF _SOURCE_DISK

 JSR DOXC               \ Move the text cursor to column 6

ENDIF

ENDIF

IF _ELITE_A_ENCYCLOPEDIA

.set_token

ENDIF

 LDA #%11111111         \ Set all the bits in DTW2
 STA DTW2

 RTS                    \ Return from the subroutine

