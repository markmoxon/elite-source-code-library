\ ******************************************************************************
\
\       Name: tnpr
\       Type: Subroutine
\   Category: Market
\    Summary: Work out if we have space for a specific amount of cargo
\
\ ------------------------------------------------------------------------------
\
\ Given a market item and an amount, work out whether there is room in the
\ cargo hold for this item.
\
IF NOT(_ELITE_A_VERSION)
\ For standard tonne canisters, the limit is given by the type of cargo hold we
\ have, with a standard cargo hold having a capacity of 20t and an extended
\ cargo bay being 35t.
\
\ For items measured in kg (gold, platinum), g (gem-stones) and alien items,
\ the individual limit on each of these is 200 units.
ELIF _ELITE_A_VERSION
\ For standard tonne canisters, the limit is given by size of the cargo hold of
\ our current ship.
\
\ For items measured in kg (gold, platinum), g (gem-stones) and alien items,
\ there is no limit.
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of units of this market item
\
\   QQ29                The type of market item (see QQ23 for a list of market
\                       item numbers)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
IF NOT(_ELITE_A_VERSION)
\   A                   A is preserved
\
ENDIF
\   C flag              Returns the result:
\
\                         * Set if there is no room for this item
\
\                         * Clear if there is room for this item
\
IF _ELITE_A_VERSION
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   Tml                 Calculate the sum of the following, returning the C flag
\                       according to whether this all fits into the hold:
\
\                         * The total tonnage of the first X items of cargo
\
\                         * The value in A
\
\                         * Plus one more tonne if the C flag is set on entry
\
\                       This is called with X = 12, A = the number of alien
\                       items in the hold, and the C flag set, to see if there
\                       is room for one more tonne in the hold
\
ENDIF
\ ******************************************************************************

.tnpr

IF NOT(_ELITE_A_VERSION)

 PHA                    \ Store A on the stack

ENDIF

 LDX #12                \ If QQ29 > 12 then jump to kg below, as this cargo
 CPX QQ29               \ type is gold, platinum, gem-stones or alien items,
 BCC kg                 \ and they have different cargo limits to the standard
                        \ tonne canisters

IF _ELITE_A_VERSION

 CLC                    \ Clear the C flag for the addition below

ENDIF

.Tml

                        \ Here we count the tonne canisters we have in the hold
                        \ and add to A to see if we have enough room for A more
                        \ tonnes of cargo, using X as the loop counter, starting
                        \ with X = 12

IF NOT(_ELITE_A_VERSION)

 ADC QQ20,X             \ Set A = A + the number of tonnes we have in the hold
                        \ of market item number X. Note that the first time we
                        \ go round this loop, the C flag is set (as we didn't
                        \ branch with the BCC above, so the effect of this loop
                        \ is to count the number of tonne canisters in the hold,
                        \ and add 1

ELIF _ELITE_A_VERSION

 ADC QQ20,X             \ Set A = A + the number of tonnes we have in the hold
                        \ of market item number X

 BCS n_over             \ If the addition overflowed, jump to n_over to return
                        \ from the subroutine with the C flag set, as the hold
                        \ is already full

ENDIF

 DEX                    \ Decrement the loop counter

 BPL Tml                \ Loop back to add in the next market item in the hold,
                        \ until we have added up all market items from 12
                        \ (minerals) down to 0 (food)

IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION \ Master: The Master version contains the code for Trumbles to take up cargo space, though as we never actually get given any Trumbles, the value is always zero

 ADC TRIBBLE+1          \ Add the high byte of the number of Trumbles in the
                        \ hold, as 256 Trumbles take up one tonne of cargo space

ENDIF

IF NOT(_ELITE_A_VERSION)

 CMP CRGO               \ If A < CRGO then the C flag will be clear (we have
                        \ room in the hold)
                        \
                        \ If A >= CRGO then the C flag will be set (we do not
                        \ have room in the hold)
                        \
                        \ This works because A contains the number of canisters
                        \ plus 1, while CRGO contains our cargo capacity plus 2,
                        \ so if we actually have "a" canisters and a capacity
                        \ of "c", then:
                        \
                        \ A < CRGO means: a+1 <  c+2
                        \                 a   <  c+1
                        \                 a   <= c
                        \
                        \ So this is why the value in CRGO is 2 higher than the
                        \ actual cargo bay size, i.e. it's 22 for the standard
                        \ 20-tonne bay, and 37 for the large 35-tonne bay

 PLA                    \ Restore A from the stack

ELIF _ELITE_A_VERSION

 CMP new_hold           \ If A < new_hold then the C flag will be clear (we have
                        \ room in the hold)
                        \
                        \ If A >= new_hold then the C flag will be set (we do
                        \ not have room in the hold)

.n_over

ENDIF

 RTS                    \ Return from the subroutine

.kg

                        \ Here we count the number of items of this type that
                        \ we already have in the hold, and add to A to see if
                        \ we have enough room for A more units

 LDY QQ29               \ Set Y to the item number we want to add

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION \ Disc: When scooping gold, platinum, gem-stones or alien items in the disc version, we are allowed to scoop what we want as long as our existing hold containss 200 units or less (irrespecitve of what we're trying to scoop); in the other versions, we can only scoop more units if it would result in a total haul of 200 units or less

 ADC QQ20,Y             \ Set A = A + the number of units of this item that we
                        \ already have in the hold

ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT

 LDA QQ20,Y             \ Set A to the number of units of this item that we
                        \ already have in the hold

ENDIF

IF NOT(_ELITE_A_VERSION OR _NES_VERSION)

 CMP #200               \ Is the result greater than 200 (the limit on
                        \ individual stocks of gold, platinum, gem-stones and
                        \ alien items)?
                        \
                        \ If so, this sets the C flag (no room)
                        \
                        \ Otherwise it is clear (we have room)

 PLA                    \ Restore A from the stack

ELIF _NES_VERSION

 CMP #201               \ Is the result greater than 201 (the limit on
                        \ individual stocks of gold, platinum, gem-stones and
                        \ alien items)?
                        \
                        \ If so, this sets the C flag (no room)
                        \
                        \ Otherwise it is clear (we have room)

 PLA                    \ Restore A from the stack

ENDIF

 RTS                    \ Return from the subroutine

IF _6502SP_VERSION \ Minor

 NOP                    \ This instruction appears to have no effect

ENDIF

