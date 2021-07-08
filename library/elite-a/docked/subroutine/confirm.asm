\ ******************************************************************************
\
\       Name: confirm
\       Type: Subroutine
\   Category: Save and load
\    Summary: Print "ARE YOU SURE?" and wait for a response
\
\ ******************************************************************************

.confirm

 CMP save_lock          \ If save_lock = 0, jump to confirmed to return from the
 BEQ confirmed          \ subroutine

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

 CMP #121               \ AJD

.confirmed

 RTS                    \ Return from the subroutine

