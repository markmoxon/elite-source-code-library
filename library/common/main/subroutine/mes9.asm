\ ******************************************************************************
\
\       Name: mes9
\       Type: Subroutine
\   Category: Text
\    Summary: Print a text token, possibly followed by " DESTROYED"
\
\ ------------------------------------------------------------------------------
\
\ Print a text token, followed by " DESTROYED" if the destruction flag is set
\ (for when a piece of equipment is destroyed).
\
\ ******************************************************************************

.mes9

 JSR TT27               \ Call TT27 to print the text token in A

IF _CASSETTE_VERSION OR _6502SP_VERSION

 LSR de                 \ If bit 0 of variable de is clear, return from the
 BCC out                \ subroutine (as out contains an RTS)

ELIF _DISC_DOCKED

 LSR de                 \ If bits 1-7 of variable de are clear, return from the
 BEQ out                \ subroutine (as out contains an RTS). This means that
                        \ " DESTROYED" is never shown, even if bit 0 of de is
                        \ set, which makes sense as we are docked

ELIF _DISC_FLIGHT

 LSR de                 \ If bit 0 of variable de is clear, return from the
 BCC DK5                \ subroutine (as DK5 contains an RTS)

ENDIF

 LDA #253               \ Print recursive token 93 (" DESTROYED") and return
 JMP TT27               \ from the subroutine using a tail call

