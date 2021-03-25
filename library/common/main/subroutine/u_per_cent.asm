\ ******************************************************************************
\
\       Name: U%
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Clear the key logger
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is set to 0
\
\ ******************************************************************************

.U%

 LDA #0                 \ Set A to 0, as this means "key not pressed" in the
                        \ key logger at KL

IF _CASSETTE_VERSION \ Enhanced: Compared to the cassette version, the enhanced versions have an extra key in the key logger, for "P" (which turns off the docking computer)

 LDY #15                \ We want to clear the 15 key logger locations from
                        \ KY1 to KY19, so set a counter in Y

ELIF _6502SP_VERSION OR _DISC_FLIGHT

 LDY #16                \ We want to clear the 16 key logger locations from
                        \ KY1 to KY19, so set a counter in Y

ELIF _MASTER_VERSION

 LDX #17                \ ???

ENDIF

.DKL3

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION

 STA KL,Y               \ Store 0 in the Y-th byte of the key logger

 DEY                    \ Decrement the counter

ELIF _MASTER_VERSION

 STA JSTY,X             \ Store 0 in the Y-th byte of the key logger ???

 DEX                    \ Decrement the counter

ENDIF

 BNE DKL3               \ And loop back for the next key, until we have just
                        \ KL+1. We don't want to clear the first key logger
                        \ location at KL, as the keyboard table at KYTB starts
                        \ with offset 1, not 0, so KL is not technically part of
                        \ the key logger (it's actually used for logging keys
                        \ that don't appear in the keyboard table, and which
                        \ therefore don't use the key logger)

 RTS                    \ Return from the subroutine

