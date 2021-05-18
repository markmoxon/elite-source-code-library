\ ******************************************************************************
\
\       Name: TT167
\       Type: Subroutine
\   Category: Market
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Show the Market Price screen (red key f7)
ELIF _ELECTRON_VERSION
\    Summary: Show the Market Price screen (FUNC-8)
ENDIF
\
\ ******************************************************************************

.TT167

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION  \ 6502SP: In the 6502SP version, you can send the Market Price screen to the printer by pressing CTRL-f7

 LDA #16                \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 16 (Market
                        \ Price screen)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA #16                \ Clear the top part of the screen, draw a white border,
 JSR TRADEMODE          \ and set up a printable trading screen with a view type
                        \ in QQ11 of 32 (Market Price screen)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION  \ Tube

 LDA #5                 \ Move the text cursor to column 4
 STA XC

ELIF _6502SP_VERSION

 LDA #5                 \ Move the text cursor to column 4
 JSR DOXC

ENDIF

 LDA #167               \ Print recursive token 7 ("{current system name} MARKET
 JSR NLIN3              \ PRICES") and draw a horizontal line at pixel row 19
                        \ to box in the title

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Tube

 LDA #3                 \ Move the text cursor to row 3
 STA YC

ELIF _6502SP_VERSION

 LDA #3                 \ Move the text cursor to row 3
 JSR DOYC

ENDIF

 JSR TT163              \ Print the column headers for the prices table

IF _6502SP_VERSION \ Tube

 LDA #6                 \ Move the text cursor to row 6
 JSR DOYC

ELIF _MASTER_VERSION

 LDA #6                 \ Move the text cursor to row 6
 STA YC

ENDIF

 LDA #0                 \ We're going to loop through all the available market
 STA QQ29               \ items, so we set up a counter in QQ29 to denote the
                        \ current item and start it at 0

.TT168

 LDX #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case, with the
 STX QQ17               \ next letter in capitals

 JSR TT151              \ Call TT151 to print the item name, market price and
                        \ availability of the current item, and set QQ24 to the
                        \ item's price / 4, QQ25 to the quantity available and
                        \ QQ19+1 to byte #1 from the market prices table for
                        \ this item

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Tube

 INC YC                 \ Move the text cursor down one row

ELIF _6502SP_VERSION

 JSR INCYC              \ Move the text cursor down one row

ENDIF

 INC QQ29               \ Increment QQ29 to point to the next item

 LDA QQ29               \ If QQ29 >= 17 then jump to TT168 as we have done the
 CMP #17                \ last item
 BCC TT168

 RTS                    \ Return from the subroutine

