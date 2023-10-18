\ ******************************************************************************
\
\       Name: PrintCharacter
\       Type: Subroutine
\   Category: Text
\    Summary: An unused routine that prints a character and sets the C flag
\
\ ******************************************************************************

.PrintCharacter

 JSR DASC_b2            \ Print the character in A

 SEC                    \ Set the C flag

 RTS                    \ Return from the subroutine

