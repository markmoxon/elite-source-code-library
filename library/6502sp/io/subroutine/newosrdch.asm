\ ******************************************************************************
\
\       Name: newosrdch
\       Type: Subroutine
\   Category: Tube
\    Summary: The custom OSRDCH routine for reading characters
\  Deep dive: 6502 Second Processor Tube communication
\
\ ------------------------------------------------------------------------------
\
IF NOT(_C64_VERSION OR _APPLE_VERSION)
\ RDCHV is set to point to this routine in the STARTUP routine that runs when
\ the I/O processor code first loads. It uses the standard OSRDCH routine to
\ read characters from the input stream, and bolts on logic to check for valid
\ and invalid characters.
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The character that is read:
\
\                         * Valid input: The character's ASCII value
\
\                         * Invalid input: 7
\
\   C flag              The C flag is cleared
\
ELIF _C64_VERSION
\ This routine is not used in this version of Elite. It is left over from the
\ 650s Second Processor version.
\
ELIF _C64_VERSION OR _APPLE_VERSION
\ This routine is not used in this version of Elite. It is left over from the
\ 650s Second Processor version.
\
\ The entry point at coolkey is used, however.
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   coolkey             Clear the C flag and return from the subroutine
\
ENDIF
\ ******************************************************************************

.newosrdch

 JSR &FFFF              \ This address is overwritten by the STARTUP routine to
                        \ contain the original value of RDCHV, so this call acts
                        \ just like a standard JSR OSRDCH call, and reads a
                        \ character from the current input stream and stores it
                        \ in A

 CMP #128               \ If A < 128 then skip the following three instructions,
 BCC P%+6               \ otherwise the character is invalid, so fall through
                        \ into badkey to deal with it

.badkey

                        \ If we get here then the character we read is invalid,
                        \ so we return a beep character

 LDA #7                 \ Set A to the beep character

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

                        \ If we get here then A < 128

 CMP #' '               \ If A >= ASCII " " then this is a valid alphanumerical
 BCS coolkey            \ key press (as A is in the range 32 to 127), so jump
                        \ down to coolkey to return this key press

 CMP #13                \ If A = 13 then this is the return character, so jump
 BEQ coolkey            \ down to coolkey to return this key press

 CMP #21                \ If A <> 21 jump up to badkey
 BNE badkey

.coolkey

                        \ If we get here then the character we read is valid, so
                        \ return it

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

