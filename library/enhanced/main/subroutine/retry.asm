\ ******************************************************************************
\
\       Name: retry
\       Type: Subroutine
\   Category: Save and load
\    Summary: Scan the keyboard until a key is pressed and display the disc
\             access menu
\
\ ******************************************************************************

.retry

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

                        \ Fall through into SVE to display the disc access menu

