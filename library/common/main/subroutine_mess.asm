\ ******************************************************************************
\
\       Name: MESS
\       Type: Subroutine
\   Category: Text
\    Summary: Display an in-flight message
\
\ ------------------------------------------------------------------------------
\
\ Display an in-flight message in capitals at the bottom of the space view,
\ erasing any existing in-flight message first.
\
\ Arguments:
\
\   A                   The text token to be printed
\
\ ******************************************************************************

.MESS

IF _6502SP_VERSION

 PHA
 LDA #YELLOW
 JSR DOCOL
 PLA

ENDIF

 LDX #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STX QQ17

IF _CASSETTE_VERSION

 LDY #9                 \ Move the text cursor to column 9, row 22, at the
 STY XC                 \ bottom middle of the screen
 LDY #22
 STY YC

ELIF _6502SP_VERSION

 PHA
 LDA messXC
 JSR DOXC
 LDA #22
 TAY
 JSR DOYC
 PLA

ENDIF

 CPX DLY                \ If the message delay in DLY is not zero, jump up to
 BNE me1                \ me1 to erase the current message first (whose token
                        \ number will be in MCH)

 STY DLY                \ Set the message delay in DLY to 22

 STA MCH                \ Set MCH to the token we are about to display and fall
                        \ through to mes9 to print the token

IF _6502SP_VERSION

 LDA #&C0
 STA DTW4
 LDA de
 LSR A
 LDA #0
 BCC P%+4
 LDA #10
 STA DTW5
 LDA MCH
 JSR TT27
 LDA #32
 SEC
 SBC DTW5
 LSR A
 STA messXC
 JSR DOXC
 JSR MT15
 LDA MCH

ENDIF

