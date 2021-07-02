\ ******************************************************************************
\
\       Name: prx
\       Type: Subroutine
\   Category: Equipment
\    Summary: Return the price of a piece of equipment
\
\ ------------------------------------------------------------------------------
\
\ This routine returns the price of equipment as listed in the table at PRXS.
\
\ Arguments:
\
\   A                   The item number of the piece of equipment (0-11) as
\                       shown in the table at PRXS
\
\ Returns:
\
\   (Y X)               The item price in Cr * 10 (Y = high byte, X = low byte)
\
\ Other entry points:
\
\   prx-3               Return the price of the item with number A - 1
\
\   c                   Contains an RTS
\
\ ******************************************************************************

 SEC                    \ Decrement A (for when this routine is called via
 SBC #1                 \ prx-3)

.prx

IF NOT(_ELITE_A_VERSION)

 ASL A                  \ Set Y = A * 2, so it can act as an index into the
 TAY                    \ PRXS table, which has two bytes per entry

ELIF _ELITE_A_VERSION

 ASL A                  \ Set A = A * 2, so it can act as an index into the
                        \ PRXS table, which has two bytes per entry

 BEQ n_fcost            \ If A = 0, skip the following, as we are fetching the
                        \ price of fuel, and fuel is always the same price,
                        \ regardless of ship type

 ADC new_costs          \ In Elite-A the PRXS table has multiple sections, for
                        \ the different types of ship we can buy, and the offset
                        \ to the price table for our current ship is held in
                        \ new_costs, so this points the index in A to the
                        \ correct section of the PRXS table for our current ship

.n_fcost

 TAY                    \ Copy A into Y, so it can be used as an index

ENDIF

 LDX PRXS,Y             \ Fetch the low byte of the price into X

 LDA PRXS+1,Y           \ Fetch the high byte of the price into A and transfer
 TAY                    \ it to X, so the price is now in (Y X)

.c

 RTS                    \ Return from the subroutine

