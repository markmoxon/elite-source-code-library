\ ******************************************************************************
\
\       Name: GETYN
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Wait until either "Y" or "N" is pressed
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   C flag              Set if "Y" was pressed, clear if "N" was pressed
\
\ ******************************************************************************

.GETYN

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 CMP #'Y'               \ If "Y" was pressed, return from the subroutine with
 BEQ PL6                \ the C flag set (as the CMP sets the C flag, and PL6
                        \ contains an RTS)

 CMP #'N'               \ If "N" was not pressed, loop back to keep scanning
 BNE GETYN              \ for key presses

 CLC                    \ Clear the C flag

 RTS                    \ Return from the subroutine

