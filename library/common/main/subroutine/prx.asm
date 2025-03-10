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
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
IF _ELECTRON_VERSION OR _CASSETTE_VERSION \ Comment
\   A                   The item number of the piece of equipment (0-11) as
\                       shown in the table at PRXS
ELIF _6502SP_VERSION OR _DISC_DOCKED OR _MASTER_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION
\   A                   The item number of the piece of equipment (0-13) as
\                       shown in the table at PRXS
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   (Y X)               The item price in Cr * 10 (Y = high byte, X = low byte)
IF _ELITE_A_VERSION
\
\   (A X)               Contains the same as (Y X)
ENDIF
\
\ ------------------------------------------------------------------------------
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

IF _NES_VERSION

 LDX priceDebug         \ This code is never run, but it looks like it might
 LDA #0                 \ have been used to override the price of equipment
 TAY                    \ during testing, as it sets (Y X) to (0 priceDebug)
 RTS                    \ before returning from the subroutine

ENDIF

