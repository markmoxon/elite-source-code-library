\ ******************************************************************************
\
\       Name: ZEKTRAN
\       Type: Subroutine
\   Category: Keyboard
IF _6502SP_VERSION
\    Summary: Reset the key logger buffer at KTRAN
ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION
\    Summary: Clear the key logger
ENDIF
\
IF _MASTER_VERSION
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   X is set to 0
\
ENDIF
\ ******************************************************************************

.ZEKTRAN

IF _6502SP_VERSION \ Minor

 LDX #11                \ We use the first 12 bytes of the key logger buffer at
                        \ KTRAN, so set a loop counter accordingly

ELIF _C64_VERSION

 LDX #64                \ We want to clear the 65 key logger locations from
                        \ KEYLOOK to KEYLOOK+64, so set a counter in X

ENDIF

 LDA #0                 \ We want to zero the key logger buffer, so set A % 0

IF _MASTER_VERSION \ Minor

 LDX #17                \ We want to clear the 17 key logger locations from
                        \ KL to KY20, so set a counter in X

ELIF _C64_VERSION

 STA thiskey            \ ???

ELIF _APPLE_VERSION

 LDX #16                \ We want to clear the 17 key logger locations from
                        \ KEYLOOK to KEYLOOK+16, so set a counter in X

ENDIF

.ZEKLOOP

IF _6502SP_VERSION \ Minor

 STA KTRAN,X            \ Reset the X-th byte of the key logger buffer to 0

 DEX                    \ Decrement the loop counter

 BPL ZEKLOOP            \ Loop back until we have zeroed bytes #11 through #0

ELIF _MASTER_VERSION

 STA JSTY,X             \ Store 0 in the X-th byte of the key logger

 DEX                    \ Decrement the counter

 BNE ZEKLOOP            \ And loop back for the next key, until we have just
                        \ KL+1. We don't want to clear the first key logger
                        \ location at KL, as the keyboard table at KYTB starts
                        \ with offset 1, not 0, so KL is not technically part of
                        \ the key logger (it's actually used for logging keys
                        \ that don't appear in the keyboard table, and which
                        \ therefore don't use the key logger)

ELIF _C64_VERSION OR _APPLE_VERSION

 STA KEYLOOK,X          \ Reset the X-th byte of the key logger buffer to 0

 DEX                    \ Decrement the loop counter

 BPL ZEKLOOP            \ Loop back until we have zeroed bytes #11 through #0

ENDIF

 RTS                    \ Return from the subroutine

IF _6502SP_VERSION OR  _C64_VERSION OR _APPLE_VERSION \ Minor

 RTS                    \ This instruction has no effect as we already returned
                        \ from the subroutine

ENDIF

