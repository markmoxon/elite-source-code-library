\ ******************************************************************************
\
\       Name: ZES2
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Zero-fill a specific page
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\ Zero-fill from address (X SC) + Y to (X SC) + &FF.
\
ELIF _ELECTRON_VERSION
\ Zero-fill from address SC(1 0) + Y to SC(1 0) + &FF.
\
ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT
\ Zero-fill from address (X SC) to (X SC) + Y.
\
ELIF _ELITE_A_6502SP_IO
\ Zero-fill from address (X SC) to (X SC) + &FF.
\
ENDIF
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\   X                   The high byte (i.e. the page) of the starting point of
\                       the zero-fill
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _ELITE_A_DOCKED OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\   Y                   The offset from (X SC) where we start zeroing, counting
\                       up to &FF
\
ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT
\   Y                   The offset from (X SC) where we start zeroing, counting
\                       down to 0
\
ELIF _ELITE_A_6502SP_IO
\   Y                   Must be set to 0
\
ENDIF
\   SC                  The low byte (i.e. the offset into the page) of the
\                       starting point of the zero-fill
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Z flag              Z flag is set
\
\ ******************************************************************************

.ZES2

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Other: Group A: The disc version's flight code has a different ZES2 routine - it still zero-fills a part of a page, but it fills the opposite part of the page to the other versions

 LDA #0                 \ Load A with the byte we want to fill the memory block
                        \ with - i.e. zero

 STX SC+1               \ We want to zero-fill page X, so store this in the
                        \ high byte of SC, so the 16-bit address in SC and
                        \ SC+1 is now pointing to the SC-th byte of page X

ELIF _ELECTRON_VERSION

 LDA #0                 \ Load A with the byte we want to fill the memory block
                        \ with - i.e. zero

ELIF _ELITE_A_6502SP_IO

 TYA                    \ Load A with the byte we want to fill the memory block
                        \ with - i.e. zero

 STX SC+1               \ We want to zero-fill page X, so store this in the
                        \ high byte of SC, so the 16-bit address in SC and
                        \ SC+1 is now pointing to the SC-th byte of page X

ENDIF

.ZEL1

 STA (SC),Y             \ Zero the Y-th byte of the block pointed to by SC,
                        \ so that's effectively the Y-th byte before SC

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA OR _ELITE_A_6502SP_PARA OR _ELITE_A_6502SP_IO OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Other: See group A

 INY                    \ Increment the loop counter

ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT

 DEY                    \ Decrement the loop counter

ENDIF

 BNE ZEL1               \ Loop back to zero the next byte

 RTS                    \ Return from the subroutine

