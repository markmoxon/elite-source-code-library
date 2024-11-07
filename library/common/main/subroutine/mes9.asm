\ ******************************************************************************
\
\       Name: mes9
\       Type: Subroutine
\   Category: Flight
\    Summary: Print a text token, possibly followed by " DESTROYED"
\
\ ------------------------------------------------------------------------------
\
\ Print a text token, followed by " DESTROYED" if the destruction flag is set
\ (for when a piece of equipment is destroyed).
\
IF _NES_VERSION
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   mes9+3              Don't print the text token, just print " DESTROYED"
\                       where applicable
\
ENDIF
\ ******************************************************************************

.mes9

IF NOT(_NES_VERSION)

 JSR TT27               \ Call TT27 to print the text token in A

ELIF _NES_VERSION

 JSR TT27_b2            \ Call TT27 to print the text token in A

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Minor

 LSR de                 \ If bit 0 of variable de is clear, return from the
 BCC out                \ subroutine (as out contains an RTS)

ELIF _DISC_DOCKED OR _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 LSR de                 \ If bits 1-7 of variable de are clear, return from the
 BEQ out                \ subroutine (as out contains an RTS). This means that
                        \ " DESTROYED" is never shown, even if bit 0 of de is
                        \ set, which makes sense as we are docked

ELIF _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_PARA

 LSR de                 \ If bit 0 of variable de is clear, return from the
 BCC DK5                \ subroutine (as DK5 contains an RTS)

ELIF _NES_VERSION

 LDA de                 \ If de is zero, then jump to StoreMessage to skip the
 BEQ StoreMessage       \ following, as we don't need to print " DESTROYED"

ENDIF

IF NOT(_NES_VERSION)

 LDA #253               \ Print recursive token 93 (" DESTROYED") and return
 JMP TT27               \ from the subroutine using a tail call

ELIF _NES_VERSION

 LDA #253               \ Print recursive token 93 (" DESTROYED")
 JSR TT27_b2

                        \ Fall through into StoreMessage to copy the message
                        \ from the justified text buffer in BUF into the
                        \ message buffer at messageBuffer

ENDIF

