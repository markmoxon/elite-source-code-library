\ ******************************************************************************
\
\       Name: tal
\       Type: Subroutine
\   Category: Text
\    Summary: Print the current galaxy numbe
\
\ ------------------------------------------------------------------------------
\
\ Print control code 1 (the current galaxy number, right-aligned to width 3).
\
\ ******************************************************************************

.tal

IF NOT(_ELITE_A_FLIGHT)

 CLC                    \ We don't want to print the galaxy number with a
                        \ decimal point, so clear the C flag for pr2 to take as
                        \ an argument

ENDIF

 LDX GCNT               \ Load the current galaxy number from GCNT into X

 INX                    \ Add 1 to the galaxy number, as the galaxy numbers
                        \ are 0-7 internally, but we want to display them as
                        \ galaxy 1 through 8

IF NOT(_ELITE_A_FLIGHT)

 JMP pr2                \ Jump to pr2, which prints the number in X to a width
                        \ of 3 figures, left-padding with spaces to a width of
                        \ 3, and once done, return from the subroutine (as pr2
                        \ ends with an RTS)

ELIF _ELITE_A_FLIGHT

 JMP pr2-1              \ AJD

ENDIF

