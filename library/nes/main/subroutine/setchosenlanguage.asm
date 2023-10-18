\ ******************************************************************************
\
\       Name: SetChosenLanguage
\       Type: Subroutine
\   Category: Start and end
\    Summary: Set the language-related variables according to the language
\             chosen on the Start screen
\
\ ******************************************************************************

.SetChosenLanguage

 LDY LASCT              \ Set Y to the language choice, which gets stored in
                        \ LASCT by the ChooseLanguage routine

                        \ Fall through to set the language chosen in Y

