\ ******************************************************************************
\
\       Name: TT167
\       Type: Subroutine
\   Category: Market
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Show the Market Price screen (red key f7)
ELIF _ELECTRON_VERSION
\    Summary: Show the Market Price screen (FUNC-8)
ELIF _NES_VERSION
\    Summary: Show the Market Price screen
ENDIF
\
\ ******************************************************************************

IF _NES_VERSION

 JMP TT213              \ Jump to TT213 to show the Inventory screen instead of
                        \ the Market Price screen

ENDIF

.TT167

IF _NES_VERSION

 LDA #&BA               \ If we are already showing the Market Price screen
 CMP QQ11               \ (i.e. QQ11 is &BA), then jump to TT213 to show the
 BEQ TT167-3            \ Inventory screen, so the icon bar button toggles
                        \ between the two

 JSR ChangeToView       \ We are not already showing the Market Price screen,
                        \ so that's what we do now, by clearing the screen and
                        \ setting the view type in QQ11 to &BA (Market Price)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ 6502SP: In the 6502SP version, you can send the Market Price screen to the printer by pressing CTRL-f7

 LDA #16                \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 16 (Market
                        \ Price screen)

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA #16                \ Clear the top part of the screen, draw a white border,
 JSR TRADEMODE          \ and set up a printable trading screen with a view type
                        \ in QQ11 of 32 (Market Price screen)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Tube

 LDA #5                 \ Move the text cursor to column 5
 STA XC

ELIF _6502SP_VERSION

 LDA #5                 \ Move the text cursor to column 5
 JSR DOXC

ENDIF

IF NOT(_NES_VERSION)

 LDA #167               \ Print recursive token 7 ("{current system name} MARKET
 JSR NLIN3              \ PRICES") and draw a horizontal line at pixel row 19
                        \ to box in the title

ELIF _NES_VERSION

 LDA #167               \ Print recursive token 7 ("{current system name} MARKET
 JSR NLIN3              \ PRICES") on the top row

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION \ Tube

 LDA #3                 \ Move the text cursor to row 3
 STA YC

ELIF _6502SP_VERSION

 LDA #3                 \ Move the text cursor to row 3
 JSR DOYC

ELIF _NES_VERSION

 LDA #2                 \ Move the text cursor to row 2
 STA YC

ENDIF

 JSR TT163              \ Print the column headers for the prices table

IF _6502SP_VERSION \ Tube

 LDA #6                 \ Move the text cursor to row 6
 JSR DOYC

ELIF _MASTER_VERSION

 LDA #6                 \ Move the text cursor to row 6
 STA YC

ELIF _NES_VERSION

 LDX languageIndex      \ Move the text cursor to the correct row for the Market
 LDA yMarketPrice,X     \ Prices title in the chosen language
 STA YC

ENDIF

 LDA #0                 \ We're going to loop through all the available market
 STA QQ29               \ items, so we set up a counter in QQ29 to denote the
                        \ current item and start it at 0

.TT168

IF _NES_VERSION

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

ENDIF

IF NOT(_ELITE_A_FLIGHT OR _ELITE_A_DOCKED OR _NES_VERSION)

 LDX #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case, with the
 STX QQ17               \ next letter in capitals

ELIF _ELITE_A_FLIGHT OR _ELITE_A_DOCKED

 JSR vdu_80             \ Call vdu_80 to switch to Sentence Case, with the next
                        \ letter in capitals

ENDIF

 JSR TT151              \ Call TT151 to print the item name, market price and
                        \ availability of the current item, and set QQ24 to the
                        \ item's price / 4, QQ25 to the quantity available and
                        \ QQ19+1 to byte #1 from the market prices table for
                        \ this item

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Tube

 INC YC                 \ Move the text cursor down one row

ELIF _6502SP_VERSION

 JSR INCYC              \ Move the text cursor down one row

ENDIF

 INC QQ29               \ Increment QQ29 to point to the next item

 LDA QQ29               \ If QQ29 >= 17 then jump to TT168 as we have done the
 CMP #17                \ last item
 BCC TT168

IF NOT(_NES_VERSION)

 RTS                    \ Return from the subroutine

ELIF _NES_VERSION

                        \ Fall through into BuyAndSellCargo to process the
                        \ buying and selling of cargo on the Market Price
                        \ screen

ENDIF

