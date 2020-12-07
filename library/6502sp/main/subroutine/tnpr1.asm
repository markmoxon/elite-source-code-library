\ ******************************************************************************
\
\       Name: tnpr1
\       Type: Subroutine
\   Category: Market
\    Summary: Work out if we have space for one tonne of cargo
\
\ ------------------------------------------------------------------------------
\
\ Given a market item, work out whether there is room in the cargo hold for one
\ tonne of this item.
\
\ For standard tonne canisters, the limit is given by the type of cargo hold we
\ have, with a standard cargo hold having a capacity of 20t and an extended
\ cargo bay being 35t.
\
\ For items measured in kg (gold, platinum), g (gem-stones) and alien items,
\ the individual limit on each of these is 200 units.
\
\ Arguments:
\
\   A                   The type of market item (see QQ23 for a list of market
\                       item numbers)
\
\ Returns:
\
\   A                   A = 1
\
\   C flag              Returns the result:
\
\                         * Set if there is no room for this item
\
\                         * Clear if there is room for this item
\
\ ******************************************************************************


.tnpr1

 STA QQ29               \ Store the type of market item in QQ29

 LDA #1                 \ Set the number of units of this market item to 1

                        \ Fall through into tnpr to work out whether there is
                        \ room in the cargo hold for A tonnes of the item of
                        \ type QQ29

