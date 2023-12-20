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
\ For standard tonne canisters, the limit is given by size of the cargo hold of
\ our current ship.
\
\ For items measured in kg (gold, platinum), g (gem-stones) and alien items,
\ there is no limit.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The type of market item (see QQ23 for a list of market
\                       item numbers)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The new number of items of type X in the hold
\
\   C flag              Returns the result:
\
\                         * Set if there is no room for this item
\
\                         * Clear if there is room for this item
\
\ ******************************************************************************

.tnpr1

 CPX #16                \ If we are checking whether to add alien items (item
 BEQ n_aliens           \ type 16), jump to n_aliens to skip the following two
                        \ instructions

 CPX #13                \ If X >= 13, then X = 13, 14 or 15 (gold, platinum or
 BCS l_2b04             \ gem-stones), for which there is no storage limit, so
                        \ jump to l_2b04 to signal that there is room for this
                        \ item

.n_aliens

 LDY #12                \ Here we count the tonne canisters we have in the hold
                        \ and add 1 to see if we have enough room for one more
                        \ tonne of cargo, using Y as the loop counter, starting
                        \ with Y = 12

 SEC                    \ Set the C flag, so the addition below has one extra,
                        \ representing the extra tonne we want to try to add

 LDA QQ20+16            \ Set A to the number of alien items we already have in
                        \ the hold

.l_2af9

 ADC QQ20,Y             \ Set A = A + the number of tonnes we have in the hold
                        \ of market item number Y

 BCS n_cargo            \ If the addition overflowed, jump to n_cargo to return
                        \ from the subroutine with the C flag set, as the hold
                        \ is already full

 DEY                    \ Decrement the loop counter

 BPL l_2af9             \ Loop back to add in the next market item in the hold,
                        \ until we have added up all market items from 12
                        \ (minerals) down to 0 (food)

 CMP new_hold           \ If A < new_hold then the C flag will be clear (we have
                        \ room in the hold)
                        \
                        \ If A >= new_hold then the C flag will be set (we do
                        \ not have room in the hold)

.n_cargo

 RTS                    \ Return from the subroutine

.l_2b04

                        \ If we get here then the item is gold, platinum or
                        \ gem-stones, for which there is no storage limit, and
                        \ the C flag is set

 LDA QQ20,X             \ Set A to the number of units of this item that we
                        \ already have in the hold

 ADC #0                 \ The C flag is set, so this adds one for the item we
                        \ just scooped

 RTS                    \ Return from the subroutine

