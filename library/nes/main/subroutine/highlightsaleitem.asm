\ ******************************************************************************
\
\       Name: HighlightSaleItem
\       Type: Subroutine
\   Category: Market
\    Summary: Highlight the name, price and availability of a market item on the
\             correct row for the chosen language
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The item number of the market item to display
\
\ ******************************************************************************

.HighlightSaleItem

 TAY                    \ Set Y to the market item number

 LDX #2                 \ Set the font style to print in the highlight font
 STX fontStyle

 CLC                    \ Move the text cursor to the row for this market item,
 LDX languageIndex      \ starting from item 0 at the top, on the correct row
 ADC yMarketPrice,X     \ for the chosen language
 STA YC

 TYA                    \ Call TT151 to print the item name, market price and
 JSR TT151              \ availability of the current item, and set QQ24 to the
                        \ item's price / 4, QQ25 to the quantity available and
                        \ QQ19+1 to byte #1 from the market prices table for
                        \ this item

 LDX #1                 \ Set the font style to print in the normal font
 STX fontStyle

 RTS                    \ Return from the subroutine

