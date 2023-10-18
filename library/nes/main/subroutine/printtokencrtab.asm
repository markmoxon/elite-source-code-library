\ ******************************************************************************
\
\       Name: PrintTokenCrTab
\       Type: Subroutine
\   Category: Text
\    Summary: Print a token, a newline and the correct indent for Status Mode
\             entries in the chosen language
\
\ ******************************************************************************

.PrintTokenCrTab

 JSR TT27_b2            \ Print the token in A

                        \ Fall through into PrintCrTab to print a newline and
                        \ the correct indent for the chosen language

