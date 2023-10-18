\ ******************************************************************************
\
\       Name: PrintCrTab
\       Type: Subroutine
\   Category: Text
\    Summary: Print a newline and the correct indent for Status Mode entries in
\             the chosen language
\
\ ******************************************************************************

.PrintCrTab

 JSR TT67               \ Print a newline

 LDX languageIndex      \ Move the text cursor to the correct column for the
 LDA xStatusMode,X      \ Status Mode entry in the chosen language
 STA XC

 RTS                    \ Return from the subroutine

