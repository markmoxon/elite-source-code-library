\ ******************************************************************************
\
\       Name: U%
\       Type: Subroutine
IF NOT(_NES_VERSION)
\   Category: Keyboard
ELIF _NES_VERSION
\   Category: Controllers
ENDIF
IF NOT(_C64_VERSION)
\    Summary: Clear the key logger
ELIF _C64_VERSION
\    Summary: Clear the key logger and reset a number of flight variables
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _C64_VERSION
\ This routine zeroes the 17 key logger locations from KY1 to KY20 and the key
\ variable at KL, and resets the 40 variable bytes from LSP to TYPE.
\
ENDIF
\ Returns:
\
\   A                   A is set to 0
\
IF NOT(_NES_VERSION)
\   Y                   Y is set to 0
\
ENDIF
\ ******************************************************************************

.U%

IF _NES_VERSION

 LDX #6                 \ We want to clear the 6 key logger locations from
                        \ KY1 to KY6, so set a counter in X

ENDIF

IF NOT(_APPLE_VERSION OR _C64_VERSION)

 LDA #0                 \ Set A to 0, as this means "key not pressed" in the
                        \ key logger at KL

ELIF _C64_VERSION

 LDA #0                 \ Set A to 0, as this means "key not pressed" in the
                        \ key logger at KLO

ELIF _APPLE_VERSION

\LDA #0                 \ These instructions are commented out in the original
\                       \ source
\LDY #&38

ENDIF

IF _NES_VERSION

 STA iconBarKeyPress    \ Reset the key logger entry for the icon bar button
                        \ choice

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: Compared to the cassette and Electron versions, the enhanced versions have an extra key in the key logger, for "P" (which turns off the docking computer)

 LDY #15                \ We want to clear the 15 key logger locations from
                        \ KY1 to KY19, so set a counter in Y

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION

 LDY #16                \ We want to clear the 16 key logger locations from
                        \ KY1 to KY20, so set a counter in Y

ELIF _C64_VERSION

 LDY #56                \ We want to clear the 16 key logger locations from KY1
                        \ to KY20, and we want to zero the 40 variable bytes
                        \ from LSP to TYPE, so set a counter in Y

ENDIF

IF NOT(_NES_VERSION OR _C64_VERSION OR _APPLE_VERSION)

.DKL3

 STA KL,Y               \ Store 0 in the Y-th byte of the key logger

 DEY                    \ Decrement the counter

 BNE DKL3               \ And loop back for the next key, until we have just
                        \ KL+1. We don't want to clear the first key logger
                        \ location at KL, as the keyboard table at KYTB starts
                        \ with offset 1, not 0, so KL is not technically part of
                        \ the key logger (it's actually used for logging keys
                        \ that don't appear in the keyboard table, and which
                        \ therefore don't use the key logger)

ELIF _C64_VERSION

.DKL3

 STA KLO,Y              \ Store 0 in the Y-th byte of the key logger

 DEY                    \ Decrement the counter

 BNE DKL3               \ And loop back for the next key, until we have just
                        \ KLO+1

 STA KL                 \ Clear KL, which is used for logging keys that don't
                        \ appear in the keyboard table

ELIF _APPLE_VERSION

.DKL3

\STA KLO,Y              \ These instructions are commented out in the original
\                       \ source
\DEY
\
\BNE DKL3
\
\STA KL

ELIF _NES_VERSION

.DKL3

 STA KL,X               \ Store 0 in the X-th byte of the key logger

 DEX                    \ Decrement the counter

 BPL DKL3               \ Loop back for the next key, until we have cleared from
                        \ KL to KL+6 (i.e. KY1 through KY6)

ENDIF

 RTS                    \ Return from the subroutine

