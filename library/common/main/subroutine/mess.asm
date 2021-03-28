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

IF _6502SP_VERSION \ Screen

 PHA                    \ Store A on the stack so we can restore it after the
                        \ the call to DOCOL

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ switch to colour 1, which is yellow

 PLA                    \ Restore A from the stack

ELIF _MASTER_VERSION

 PHA                    \ Store A on the stack so we can restore it after the
                        \ the call to DOCOL

 LDX QQ11               \ If this is the space view, skip the following
 BEQ P%+5               \ instruction

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the three bottom rows

 LDA #21                \ Move the text cursor to row 21
 STA YC

 LDA #YELLOW            \ Switch to colour 1, which is yellow
 STA COL

ENDIF

 LDX #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STX QQ17

IF _CASSETTE_VERSION OR _DISC_VERSION \ Advanced: Group A: The original versions display in-flight messages at column 9 on row 22, at the bottom of the screen. The advanced versions go one better and centre their in-flight messages on screen, rather than always starting them at column 9

 LDY #9                 \ Move the text cursor to column 9, row 22, at the
 STY XC                 \ bottom middle of the screen, and set Y = 22
 LDY #22
 STY YC

ELIF _6502SP_VERSION

 PHA                    \ Store A on the stack so we can restore it after the
                        \ the calls to DOXC and DOYC

 LDA messXC             \ Move the text cursor to column messXC, in case we
 JSR DOXC               \ jump to me1 below to erase the current in-flight
                        \ message (whose column we stored in messXC when we
                        \ called MESS to put it there in the first place)

 LDA #22                \ Move the text cursor to row 22, and set Y = 22
 TAY
 JSR DOYC

 PLA                    \ Restore A from the stack

ELIF _MASTER_VERSION

 LDA messXC             \ Move the text cursor to column messXC, in case we
 STA XC                 \ jump to me1 below to erase the current in-flight
                        \ message (whose column we stored in messXC when we
                        \ called MESS to put it there in the first place)

 PLA                    \ Restore A from the stack

 LDY #20                \ Set Y = 20 for setting the message delay below

ENDIF

 CPX DLY                \ If the message delay in DLY is not zero, jump up to
 BNE me1                \ me1 to erase the current message first (whose token
                        \ number will be in MCH)

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION

 STY DLY                \ Set the message delay in DLY to 22

ELIF _MASTER_VERSION

 STY DLY                \ Set the message delay in DLY to 20

ENDIF

 STA MCH                \ Set MCH to the token we are about to display

IF _6502SP_VERSION OR _MASTER_VERSION \ Advanced: See group A

                        \ Before we fall through into mes9 to print the token,
                        \ we need to work out the starting column for the
                        \ message we want to print, so it's centred on-screen,
                        \ so the following doesn't print anything, it just uses
                        \ the justified text mechanism to work out the number of
                        \ characters in the message we are going to print

 LDA #%11000000         \ Set the DTW4 flag to %11000000 (justify text, buffer
 STA DTW4               \ entire token including carriage returns)

 LDA de                 \ Set the C flag to bit 1 of the destruction flag in de
 LSR A

 LDA #0                 \ Set A = 0

 BCC P%+4               \ If the destruction flag in de is not set, skip the
                        \ following instruction

 LDA #10                \ Set A = 10

 STA DTW5               \ Store A in DTW5, so DTW5 (which holds the size of the
                        \ justified text buffer at BUF) is set to 0 if the
                        \ destruction flag is not set, or 10 if it is (10 being
                        \ the number of characters in the " DESTROYED" token)

 LDA MCH                \ Call TT27 to print the token in MCH into the buffer
 JSR TT27               \ (this doesn't print it on-screen, it just puts it into
                        \ the buffer and moves the DTW5 pointer along, so DTW5
                        \ now contains the size of the message we want to print,
                        \ includint the " DESTROYED" part if that's going to be
                        \ included)

 LDA #32                \ Set A = (32 - DTW5) / 2
 SEC                    \
 SBC DTW5               \ so A now contains the column number we need to print
 LSR A                  \ our message at for it to be centred on-screen (as
                        \ there are 32 columns)

 STA messXC             \ Store A in messXC, so when we erase the message via
                        \ the branch to me1 above, messXC will tell us where to
                        \ print it

ENDIF

IF _6502SP_VERSION \ Platform

 JSR DOXC               \ Move the text cursor to column messXC

ELIF _MASTER_VERSION

 STA XC                 \ Move the text cursor to column messXC

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Advanced: See group A

 JSR MT15               \ Call MT15 to wwitch to left-aligned text when printing
                        \ extended tokens disabling the justify text setting we
                        \ set above

 LDA MCH                \ Set MCH to the token we are about to display

ENDIF

                        \ Fall through into mes9 to print the token in A

