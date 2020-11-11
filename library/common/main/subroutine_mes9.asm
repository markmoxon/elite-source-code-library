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

 LSR de                 \ If bit 1 of location de is clear, return from the
 BCC out                \ subroutine (as out contains an RTS)

 LDA #253               \ Print recursive token 93 (" DESTROYED") and return
 JMP TT27               \ from the subroutine using a tail call

