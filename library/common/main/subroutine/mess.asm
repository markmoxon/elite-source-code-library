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
                        \ call to DOCOL

 LDA #YELLOW            \ Send a #SETCOL YELLOW command to the I/O processor to
 JSR DOCOL              \ switch to colour 1, which is yellow

 PLA                    \ Restore A from the stack

ELIF _MASTER_VERSION

 PHA                    \ Store A on the stack so we can restore it after the
                        \ following

 LDX QQ11               \ If this is the space view, skip the following
 BEQ infrontvw          \ instruction

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the three bottom rows

.infrontvw

 LDA #21                \ Move the text cursor to row 21
 STA YC

 LDA #YELLOW            \ Switch to colour 1, which is yellow
 STA COL

ELIF _NES_VERSION

 PHA                    \ Store A on the stack so we can restore it after the
                        \ following

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDY #10                \ Set the message delay in DLY to 10
 STY DLY

 LDA #%11000000         \ Set the DTW4 flag to %11000000 (justify text, buffer
 STA DTW4               \ entire token including carriage returns)

 LDA #0                 \ Set DTW5 = 0, which sets the size of the justified
 STA DTW5               \ text buffer at BUF to zero

 PLA                    \ Restore A from the stack

 CMP #250               \ If this is not token 250 (the hyperspace countdown),
 BNE mess1              \ jump to mess1 to print the token in A

                        \ This is token 250, so now we print the hyperspace
                        \ countdown

 LDA #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STA QQ17

 LDA #189               \ Print recursive token 29 ("HYPERSPACE ")
 JSR TT27_b2

 LDA #'-'               \ Print a hyphen
 JSR TT27_b2

 JSR TT162              \ Print a space

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR SetCurrentSeeds    \ Set the seeds for the selected system in QQ15 to the
                        \ seeds in the safehouse

 LDA #3                 \ Set A = 3 so we print the hyperspace countdown with
                        \ three digits

 CLC                    \ Clear the C flag so we print the hyperspace countdown
                        \ without a decimal point

 LDX QQ22+1             \ Set (Y X) = QQ22+1, which contains the number that's
 LDY #0                 \ shown on-screen during hyperspace countdown

 JSR TT11               \ Print the hyperspace countdown with 3 digits and no
                        \ decimal point

 JMP CB7E8              \ Jump to CB7E8 to skip the following, as we have
                        \ already printed the message

.mess1

 PHA                    \ Store A on the stack so we can restore it after the
                        \ following

ENDIF

IF NOT(_ELITE_A_FLIGHT OR _NES_VERSION)

 LDX #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STX QQ17

ELIF _NES_VERSION

 LDA #0                 \ Set QQ17 = 0 to switch to ALL CAPS
 STA QQ17

ELIF _ELITE_A_FLIGHT

 JSR vdu_00             \ Call vdu_00 to switch to ALL CAPS

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Advanced: Group A: The original versions display in-flight messages at column 9 on row 22, at the bottom of the screen. The advanced versions go one better and centre their in-flight messages on screen, rather than always starting them at column 9

 LDY #9                 \ Move the text cursor to column 9, row 22, at the
 STY XC                 \ bottom middle of the screen, and set Y = 22
 LDY #22
 STY YC

ELIF _6502SP_VERSION

 PHA                    \ Store A on the stack so we can restore it after the
                        \ calls to DOXC and DOYC

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

ELIF _NES_VERSION

 PLA                    \ Restore A from the stack

ENDIF

IF NOT(_NES_VERSION)

 CPX DLY                \ If the message delay in DLY is not zero, jump up to
 BNE me1                \ me1 to erase the current message first (whose token
                        \ number will be in MCH)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: The Master version flashes in-flight messages 10% more quickly than the other versions

 STY DLY                \ Set the message delay in DLY to 22

ELIF _MASTER_VERSION

 STY DLY                \ Set the message delay in DLY to 20

ENDIF

IF NOT(_NES_VERSION)

 STA MCH                \ Set MCH to the token we are about to display

ENDIF

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
                        \ including the " DESTROYED" part if that's going to be
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

 JSR MT15               \ Call MT15 to switch to left-aligned text when printing
                        \ extended tokens disabling the justify text setting we
                        \ set above

 LDA MCH                \ Set MCH to the token we are about to display

ENDIF

                        \ Fall through into mes9 to print the token in A

