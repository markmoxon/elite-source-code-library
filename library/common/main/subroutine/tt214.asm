\ ******************************************************************************
\
\       Name: TT214
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Ask a question with a "Y/N?" prompt and return the response
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The text token to print before the "Y/N?" prompt
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if the response was "yes", clear otherwise
\
\ ******************************************************************************

.TT214

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Standard: In the cassette and Electron versions, there's an extra space before the "Y/N?" prompt in the Buy Cargo and Sell Cargo screens compared to the other versions

 PHA                    \ Print a space, using the stack to preserve the value
 JSR TT162              \ of A
 PLA

ELIF _MASTER_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION

\.TT214                 \ These instructions are commented out in the original
\PHA                    \ source
\JSR TT162
\PLA

ENDIF

.TT221

 JSR TT27               \ Print the text token in A

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Minor

 LDA #225               \ Print recursive token 65 ("(Y/N)?")
 JSR TT27

ELIF _6502SP_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 LDA #206               \ Print extended token 206 ("{all caps}(Y/N)?")
 JSR DETOK

ENDIF

 JSR TT217              \ Scan the keyboard until a key is pressed, and return
                        \ the key's ASCII code in A and X

 ORA #%00100000         \ Set bit 5 in the value of the key pressed, which
                        \ converts it to lower case

 CMP #'y'               \ If "y" was pressed, jump to TT218
 BEQ TT218

 LDA #'n'               \ Otherwise jump to TT26 to print "n" and return from
 JMP TT26               \ the subroutine using a tail call (so all other
                        \ responses apart from "y" indicate a no)

.TT218

 JSR TT26               \ Print the character in A, i.e. print "y"

 SEC                    \ Set the C flag to indicate a "yes" response

 RTS                    \ Return from the subroutine

