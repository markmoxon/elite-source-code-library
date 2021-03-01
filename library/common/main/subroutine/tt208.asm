\ ******************************************************************************
\
\       Name: TT208
\       Type: Subroutine
\   Category: Market
\    Summary: Show the Sell Cargo screen (red key f2)
\
\ ******************************************************************************

.TT208

IF _CASSETTE_VERSION OR _DISC_DOCKED

 LDA #4                 \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 4 (Sell
                        \ Cargo screen)

ENDIF

IF _CASSETTE_VERSION

 LDA #4                 \ Move the text cursor to row 4, column 4
 STA YC
 STA XC

\JSR FLKB               \ This instruction is commented out in the original
                        \ source. It calls a routine to flush the keyboard
                        \ buffer (FLKB) that isn't present in the cassette
                        \ version but is in other versions

ELIF _DISC_DOCKED

 LDA #10                \ Move the text cursor to column 10
 STA XC

 JSR FLKB               \ Flush the keyboard buffer

ELIF _6502SP_VERSION

 LDA #4                 \ Clear the top part of the screen, draw a white border,
 JSR TRADEMODE          \ and set up a printable trading screen with a view type
                        \ in QQ11 of 4 (Sell Cargo screen)

 LDA #10                \ Move the text cursor to column 10
 JSR DOXC

ENDIF

 LDA #205               \ Print recursive token 45 ("SELL")
 JSR TT27

IF _CASSETTE_VERSION

 LDA #206               \ Print recursive token 46 (" CARGO{sentence case}")
 JSR TT68               \ followed by a colon

ELIF _6502SP_VERSION OR _DISC_DOCKED

 LDA #206               \ Print recursive token 46 (" CARGO{sentence case}")
 JSR NLIN3              \ draw a horizontal line at pixel row 19 to box in the
                        \ title

 JSR TT67               \ Print a newline

ENDIF

                        \ Fall through into TT210 to show the Inventory screen
                        \ with the option to sell

