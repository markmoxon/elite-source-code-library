\ ******************************************************************************
\
\       Name: confirm
\       Type: Subroutine
\   Category: Save and load
\    Summary: Print "ARE YOU SURE?" and wait for a response
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   If save_lock matches this value, then we do not ask for
\                       confirmation and instead assume the answer was "Y"
\
\ Returns:
\
\   Z flag              If "Y" is pressed, then BEQ will branch (Z flag is set),
\                       otherwise BNE will branch (Z flag is clear)
\
\ ******************************************************************************

.confirm

 CMP save_lock          \ If A = save_lock, jump to confirmed to return from the
 BEQ confirmed          \ subroutine without asking for confirmation, but
                        \ assuming a positive response

 LDA #3                 \ Print extended token 3 ("ARE YOU SURE?")
 JSR DETOK

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 JSR CHPR               \ Print the character in A

 ORA #%00100000         \ Set bit 5 in the value of the key pressed, which
                        \ converts it to lower case

 PHA                    \ Store A on the stack so we can retrieve it after the
                        \ call to FEED

 JSR TT67               \ Print a newline

 JSR FEED               \ Print a newline

 PLA                    \ Restore A from the stack

 CMP #'y'               \ Set the C flag if A >= ASCII y' (i.e. if "Y" was
                        \ pressed and not "N"), otherwise clear it

.confirmed

 RTS                    \ Return from the subroutine

