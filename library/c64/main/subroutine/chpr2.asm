\ ******************************************************************************
\
\       Name: CHPR2
\       Type: Subroutine
\   Category: Text
\    Summary: Character print vector handler
\
\ ------------------------------------------------------------------------------
\
\ This routine is set as the handler in CHRV, so it replaces the Kernal's
\ character-printing routine.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to print
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              The C flag is cleared
\
\ ******************************************************************************

.CHPR2

 CMP #123               \ If the character to print in A is outside of the range
 BCS whosentthisshit    \ 13 to 122, jump to whosentthisshit to print nothing
 CMP #13
 BCC whosentthisshit

 BNE CHPR               \ If A is not 13, jump to CHPR to print the character,
                        \ returning from the subroutine using a tail call

 LDA #12                \ If we get here then A is 13, so call CHPR with A = 12,
 JSR CHPR               \ which will print a carriage return

 LDA #13                \ Set A = 13 so it is unchanged

.whosentthisshit

 CLC                    \ Clear the C flag, as the CHPR routine does this and
                        \ we need CHPR2 to act in the same way

 RTS                    \ Return from the subroutine

