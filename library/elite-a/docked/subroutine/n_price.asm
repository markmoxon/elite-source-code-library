\ ******************************************************************************
\
\       Name: n_price
\       Type: Subroutine
\   Category: Buying ships
\    Summary: Set K(3 2 1 0) to the price of a given ship
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The ship type number, in the range 0 to 14, as defined
\                       in the new_ships table
\
\ ******************************************************************************

.n_price

 LDX new_offsets,Y      \ Set X to the offset, measured from new_price, for this
                        \ ship's details block, so X now points to the offset of
                        \ the ship's price in the new_ships table

 LDY #3                 \ Each ship price consists of exactly four bytes (as it
                        \ is a 32-bit number), so set Y = 3 to act as a byte
                        \ counter in the following loop

.n_lprice

 LDA new_price,X        \ Set A to X-th byte of the ship's price from the
                        \ new_ships table

 STA K,Y                \ Store it in the X-th byte of K(3 2 1 0)

 INX                    \ Increment X to point to the next price byte

 DEY                    \ Decrement the byte counter

 BPL n_lprice           \ Loop back to copy the next byte until we have copied
                        \ all 4 of them

 RTS                    \ Return from the subroutine

