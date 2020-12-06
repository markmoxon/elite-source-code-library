\ ******************************************************************************
\
\       Name: U%
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Clear the key logger (from KY1 through KY19)
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

IF _CASSETTE_VERSION

 LDY #15                \ We want to clear the 15 key logger locations from
                        \ KY1 to KY19, so set a counter in Y. We don't want to
                        \ clear the first key logger location, at KL, as the
                        \ keyboard table at KYTB starts with offset 1, not 0,
                        \ so KL is not technically part of the key logger
                        \ (it's actually used for logging keys that don't
                        \ appear in the keyboard table, and which therefore
                        \ don't use the key logger)

ELIF _6502SP_VERSION

 LDY #16

ENDIF

.DKL3

 STA KL,Y               \ Store 0 in the Y-th byte of the key logger

 DEY                    \ Decrement the counter

 BNE DKL3               \ And loop back for the next key

 RTS

