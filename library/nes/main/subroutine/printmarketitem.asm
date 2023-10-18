\ ******************************************************************************
\
\       Name: PrintMarketItem
\       Type: Subroutine
\   Category: Market
\    Summary: Print the name, price and availability of a market item on the
\             correct row for the chosen language
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The item number of the market item to display
\
\ ******************************************************************************

.PrintMarketItem

 TAY                    \ Set Y to the market item number

 CLC                    \ Move the text cursor to the row for this market item,
 LDX languageIndex      \ starting from item 0 at the top, on the correct row
 ADC yMarketPrice,X     \ for the chosen language
 STA YC

 TYA                    \ Call TT151 to print the item name, market price and
 JMP TT151              \ availability of the current item, and set QQ24 to the
                        \ item's price / 4, QQ25 to the quantity available and
                        \ QQ19+1 to byte #1 from the market prices table for
                        \ this item
                        \
                        \ When done, return from the subroutine using a tail
                        \ call

