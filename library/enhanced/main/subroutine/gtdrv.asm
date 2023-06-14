\ ******************************************************************************
\
\       Name: GTDRV
\       Type: Subroutine
\   Category: Save and load
\    Summary: Get an ASCII disc drive number from the keyboard
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The ASCII value of the entered drive number ("0" to "3")
\
\   C flag              Clear if a valid drive number was entered (0-3), set
\                       otherwise
\
\ ******************************************************************************

.GTDRV

 LDA #2                 \ Print extended token 2 ("{cr}WHICH DRIVE?")
 JSR DETOK

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 ORA #%00010000         \ Set bit 4 of A, perhaps to avoid printing any control
                        \ characters in the next instruction

 JSR CHPR               \ Print the character in A

 PHA                    \ Store A on the stack so we can retrieve it after the
                        \ call to FEED

 JSR FEED               \ Print a newline

 PLA                    \ Restore A from the stack

 CMP #'0'               \ If A < ASCII "0", then it is not a valid drive number,
 BCC LOR                \ so jump to LOR to set the C flag and return from the
                        \ subroutine

 CMP #'4'               \ If A >= ASCII "4", then it is not a valid drive
                        \ number, and this CMP sets the C flag, otherwise it is
                        \ a valid drive number in the range 0-3, so clear it

 RTS                    \ Return from the subroutine

