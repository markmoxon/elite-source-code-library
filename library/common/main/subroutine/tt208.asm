\ ******************************************************************************
\
\       Name: TT208
\       Type: Subroutine
\   Category: Market
IF _CASSETTE_VERSION OR _DISC_DOCKED OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Show the Sell Cargo screen (red key f2)
ELIF _ELECTRON_VERSION
\    Summary: Show the Sell Cargo screen (FUNC-3)
ELIF _ELITE_A_VERSION
\    Summary: Show the Sell Cargo screen (red key f2) or Sell Equipment screen
\             (CTRL-f2)
ELIF _C64_VERSION OR _APPLE_VERSION
\    Summary: Show the Sell Cargo screen
ENDIF
\
\ ******************************************************************************

.TT208

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION \ 6502SP: In the 6502SP version, you can send the Sell Cargo screen to the printer by pressing CTRL-f2

 LDA #4                 \ Clear the top part of the screen, draw a border box,
 JSR TT66               \ and set the current view type in QQ11 to 4 (Sell
                        \ Cargo screen)

ELIF _6502SP_VERSION

 LDA #4                 \ Clear the top part of the screen, draw a border box,
 JSR TRADEMODE          \ and set up a printable trading screen with a view type
                        \ in QQ11 of 4 (Sell Cargo screen)

ELIF _MASTER_VERSION

 LDA #4                 \ Clear the top part of the screen, draw a border box,
 JSR TRADEMODE          \ and set up a trading screen with a view type in QQ11
                        \ of 4 (Sell Cargo screen)

ELIF _C64_VERSION

 LDA #4                 \ Clear the screen, draw a border box, and set up a
 JSR TRADEMODE          \ trading screen with a view type in QQ11 of 4 (Sell
                        \ Cargo screen)

ELIF _APPLE_VERSION

 LDA #4                 \ Clear the screen and set up a trading screen with a
 JSR TRADEMODE          \ view type in QQ11 of 4 (Sell Cargo screen)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: Group A: The layout of the Sell Cargo screen in the cassette and Electron versions is slightly different to the other versions (it doesn't have a boxed title and the text starts lower down the screen)

 LDA #4                 \ Move the text cursor to row 4, column 4
 STA YC
 STA XC

ELIF _DISC_DOCKED OR _ELITE_A_VERSION OR _MASTER_VERSION

 LDA #10                \ Move the text cursor to column 10
 STA XC

ELIF _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDA #10                \ Move the text cursor to column 10
 JSR DOXC

ENDIF

IF _CASSETTE_VERSION \ Platform

\JSR FLKB               \ This instruction is commented out in the original
                        \ source. It calls a routine to flush the keyboard
                        \ buffer (FLKB) that isn't present in the cassette
                        \ version but is in other versions

ELIF _DISC_DOCKED OR _ELITE_A_VERSION

 JSR FLKB               \ Flush the keyboard buffer

ENDIF

 LDA #205               \ Print recursive token 45 ("SELL")
 JSR TT27

IF _ELITE_A_VERSION

 JSR CTRL               \ Scan the keyboard to see if CTRL is currently pressed,
                        \ returning a negative value in A if it is

 BMI sell_jump          \ If CTRL is being pressed, jump to sell_jump to show
                        \ the Sell Equipment screen (CTRL-f2)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: See group A

 LDA #206               \ Print recursive token 46 (" CARGO{sentence case}")
 JSR TT68               \ followed by a colon

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_VERSION OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDA #206               \ Print recursive token 46 (" CARGO{sentence case}")
 JSR NLIN3              \ draw a horizontal line at pixel row 19 to box in the
                        \ title

 JSR TT67               \ Print a newline

ENDIF

                        \ Fall through into TT210 to show the Inventory screen
                        \ with the option to sell

